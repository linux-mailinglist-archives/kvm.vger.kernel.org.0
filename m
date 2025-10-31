Return-Path: <kvm+bounces-61659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A113EC23E37
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 09:46:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8462B4F15C2
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 08:45:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A70CA30FC01;
	Fri, 31 Oct 2025 08:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ju2TN/PS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0422BEC32;
	Fri, 31 Oct 2025 08:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761900337; cv=none; b=dQuoiJpZF82w7JMlTSk/06W/c7AacD0q9dbQY+0bWRNm/oKvpxYrICEpTVmAlD8Hucodl4TZV1GdG0YhyEzF+p7RbazH5+soMHMrWVOwjp7lguoMH13BKe6NrmD8OX9d8hXrwOPlZE+pkIR7GNP0duHjItK2EswqhsLkleeaoPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761900337; c=relaxed/simple;
	bh=QGKeS5Y6HiaMuwcnV9Aka+TVZ1AUsrFwxmv9BuB8eXQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rfB+lLm23MgQ6OQmEFcwq/gDklmJ6slU3b6Rw2loIh0m7XeATNWIJ0fyNBfrBScjqXPeKvcp2E8EPyw3RgN4qkR9DnCiDkC863fOwb4SpNS2gxp94XASzSCIAYJc00Ha45SJmL2/kSWJy7z14W9UlzmXyYARcr5TzWP+5tx8yr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ju2TN/PS; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59UMBSXv026517;
	Fri, 31 Oct 2025 08:45:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=kCGZRy
	pNIGAnkk9E5RGYpNiTnxrNItt2vLGbMaGLh9w=; b=ju2TN/PSz1zxqwYF3sDxKD
	1V3UqIJG8MzLO/elJG7WzuFDTF7UXgOrm/HqyQgf5dg6CoxHmo2DHTwle2QArVRR
	+Su33+yQfHLtNQM+nygdASd8kefTBxXkUXJUyyfuwhZ6T6XvJgZ/CctKVvc/r/G0
	MU2ZLu9b6ZB3Gp3582VOGwN6POmYaT1M9YZyUJUCVyDj6BliRocG2EIuxPmF7NXp
	PvwoIUpqOQMhr6GeGuT6mofUvzxF8fB+4IE6N1rJ7pH60CrPwugpyQzpyG/EdvOR
	RlZ7jGabW2NQTqVbSJY8Dlpzpk6zB6r1hBvnul0h6SbzmWXJBAh7JbNX9v5LgS4A
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a34aavpcy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Oct 2025 08:45:33 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59V7r0Gr030747;
	Fri, 31 Oct 2025 08:45:32 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a33wwwce1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Oct 2025 08:45:32 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59V8jSlb25428546
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Oct 2025 08:45:28 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6CF0B20040;
	Fri, 31 Oct 2025 08:45:28 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1564120043;
	Fri, 31 Oct 2025 08:45:28 +0000 (GMT)
Received: from [9.111.65.71] (unknown [9.111.65.71])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Oct 2025 08:45:27 +0000 (GMT)
Message-ID: <5255f540-e723-47e5-8035-387bea9f6fa3@linux.ibm.com>
Date: Fri, 31 Oct 2025 09:45:27 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: Add capability that forwards operation
 exceptions
To: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com
References: <20251029130744.6422-1-frankja@linux.ibm.com>
 <8c25cc75-021d-4199-96de-83e06e16a514@redhat.com>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <8c25cc75-021d-4199-96de-83e06e16a514@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=ALkgKXG8 c=1 sm=1 tr=0 ts=6904772d cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=Xv-bD52oe_4w3DNoDjkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: bYTL_5o2YePXq4cm5MuN4aqOiOd3Ezgq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDE2NiBTYWx0ZWRfX1Y72kBSzU48+
 FKpqXGe7D9Hi4r3B022ZorcwRiWPNyexaKaIz4L9x7yH4Lhj5Ln4KvNjk2fuTWVHAdiiA+ur2yP
 SlTyU4sJcMeJLn8JhVFBM8sC5PPSkLNhibM/TQTs3sbX1WNcNHeYp4GwGlzZTtKuGtR7M2C30I7
 c33X7DQb5FrqO2jy75Bsq8qzjSXh5AlDdciSunhfN8F0RmT8nvezZMaGP0BleASXQsdei6ZCPww
 PouYC799oKOvwYZkvwQbIbCPmNsiMuLMeVgGNVFtgM7S/0esnzAWTi3gtQk7t0KAxfgGTepvn00
 dsSZTTV7MixBBLgcLFKKNC73vacwpyhOYC5Lcbk53kL3+RveJXxr5ObIruzuh/Tvk6LQyhbi0D7
 L8QxFTCzl+w7q0iEykIgLgZEi1QerQ==
X-Proofpoint-GUID: bYTL_5o2YePXq4cm5MuN4aqOiOd3Ezgq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-31_02,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2510280166

On 10/30/25 08:10, Thomas Huth wrote:
> On 29/10/2025 14.04, Janosch Frank wrote:
>> Setting KVM_CAP_S390_USER_OPEREXEC will forward all operation
>> exceptions to user space. This also includes the 0x0000 instructions
>> managed by KVM_CAP_S390_USER_INSTR0. It's helpful if user space wants
>> to emulate instructions which do not (yet) have an opcode.
>>
>> While we're at it refine the documentation for
>> KVM_CAP_S390_USER_INSTR0.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ...
>> +7.45 KVM_CAP_S390_USER_OPEREXEC
>> +----------------------------
>> +
>> +:Architectures: s390
>> +:Parameters: none
>> +
>> +When this capability is enabled KVM forwards all operation exceptions
>> +that it doesn't handle itself to user space. This also includes the
>> +0x0000 instructions managed by KVM_CAP_S390_USER_INSTR0. This is
>> +helpful if user space wants to emulate instructions which do not (yet)
>> +have an opcode.
> 
> "which do not (yet) have an opcode" sounds a little bit weird. Maybe rather:
> "which are not (yet) implemented in the current CPU" or so?

How about:
...which are not (yet) implemented in hardware.


> 
>> +This capability can be enabled dynamically even if VCPUs were already
>> +created and are running.
>> +
>>    8. Other capabilities.
>>    ======================
> ...
>> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
>> index c7908950c1f4..420ae62977e2 100644
>> --- a/arch/s390/kvm/intercept.c
>> +++ b/arch/s390/kvm/intercept.c
>> @@ -471,6 +471,9 @@ static int handle_operexc(struct kvm_vcpu *vcpu)
>>    	if (vcpu->arch.sie_block->ipa == 0xb256)
>>    		return handle_sthyi(vcpu);
>>    
>> +	if (vcpu->kvm->arch.user_operexec)
>> +		return -EOPNOTSUPP;
>> +
>>    	if (vcpu->arch.sie_block->ipa == 0 && vcpu->kvm->arch.user_instr0)
>>    		return -EOPNOTSUPP;
>>    	rc = read_guest_lc(vcpu, __LC_PGM_NEW_PSW, &newpsw, sizeof(psw_t));
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 70ebc54b1bb1..56d4730b7c41 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -606,6 +606,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>    	case KVM_CAP_SET_GUEST_DEBUG:
>>    	case KVM_CAP_S390_DIAG318:
>>    	case KVM_CAP_IRQFD_RESAMPLE:
>> +	case KVM_CAP_S390_USER_OPEREXEC:
>>    		r = 1;
>>    		break;
>>    	case KVM_CAP_SET_GUEST_DEBUG2:
>> @@ -921,6 +922,12 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>>    		VM_EVENT(kvm, 3, "ENABLE: CAP_S390_CPU_TOPOLOGY %s",
>>    			 r ? "(not available)" : "(success)");
>>    		break;
>> +	case KVM_CAP_S390_USER_OPEREXEC:
>> +		VM_EVENT(kvm, 3, "%s", "ENABLE: CAP_S390_USER_OPEREXEC");
>> +		kvm->arch.user_operexec = 1;
>> +		icpt_operexc_on_all_vcpus(kvm);
> 
> Maybe check cap->flags here and return with an error if any flag is set? ...
> otherwise, if we ever add flags here, userspace cannot check whether the
> kernel accepted a flag or not.

Check the top of the function :)
I can surely add a second check to be doubly sure.

int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
{
         int r;

         if (cap->flags)
                 return -EINVAL;



>> +/*
>> + * Run all tests above.
>> + *
>> + * Enablement after VCPU has been added is automatically tested since
>> + * we enable the capability after VCPU creation.
>> + */
>> +static struct testdef {
>> +	const char *name;
>> +	void (*test)(void);
>> +} testlist[] = {
>> +	{ "instr0", test_user_instr0 },
>> +	{ "operexec", test_user_operexec },
>> +	{ "operexec_combined", test_user_operexec_combined},
>> +};
>> +
>> +int main(int argc, char *argv[])
>> +{
>> +	int idx;
>> +
>> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_S390_USER_INSTR0));
>> +
>> +	ksft_print_header();
>> +	ksft_set_plan(ARRAY_SIZE(testlist));
>> +	for (idx = 0; idx < ARRAY_SIZE(testlist); idx++) {
>> +		testlist[idx].test();
>> +		ksft_test_result_pass("%s\n", testlist[idx].name);
>> +	}
>> +	ksft_finished();
>> +}
> 
> You could likely use the KVM_ONE_VCPU_TEST() macro and test_harness_run() to
> get rid of the boilerplate code here.

Is there a general directive to use KVM_ONE_VCPU_TEST?
To be honest I prefer the look as is since it doesn't hide things behind 
macros and 95% of our tests use it.

