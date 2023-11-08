Return-Path: <kvm+bounces-1150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 971517E5338
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:20:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C846F1C20DB4
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 10:20:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5519B11C93;
	Wed,  8 Nov 2023 10:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="l4Y+SGy1"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D13811194
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 10:20:12 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413E71BD6;
	Wed,  8 Nov 2023 02:20:11 -0800 (PST)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A89F3xr017923;
	Wed, 8 Nov 2023 10:20:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=MpBJpGijZohx3AcywvI1ehabXiYb/3V44jpSJazdoAY=;
 b=l4Y+SGy1ZUcB+2YWXfb0NyREjgWE23n+ukjagfqrZdc+eQOwxqCLf+hrQFE4fOfcAH4N
 ES3fHm9y303dm/zGjWzCXbA2BzcPtw3ofL67lEuBe/qsFAgP3G+D+M0+tCCX2XWG8nIC
 mZiXhGy1Mz/7p+vhl93M+4T/xIO/BQPYB7gCL0t00ytgueFXSHk1/8aEAMswmSic9iNx
 JSjV/MPJWddwXwRRQ0yUc+3DaZvJ6q/ML+fjOPxyjERgjq8FrjUnYBRagrtlOVYn7jXJ
 KElcIXGxAUw/37tKaZYJu9K1vbNbBLbvBmnbL9hC/UP0QTK4gro5L24krYXWHmfOxbV6 tg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u87hfj85x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 10:20:10 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A8AFM0t006684;
	Wed, 8 Nov 2023 10:20:09 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u87hfj84q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 10:20:09 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A88YJtn014332;
	Wed, 8 Nov 2023 10:20:08 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u7w21v151-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 10:20:08 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A8AK6FN37355804
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Nov 2023 10:20:06 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 738D22004F;
	Wed,  8 Nov 2023 10:20:06 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 57BB22004E;
	Wed,  8 Nov 2023 10:20:06 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Nov 2023 10:20:06 +0000 (GMT)
Date: Wed, 8 Nov 2023 11:20:05 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] selftests: kvm/s390x: use vm_create_barebones()
Message-ID: <20231108112005.54e86585@p-imbrenda>
In-Reply-To: <20231108094055.221234-1-pbonzini@redhat.com>
References: <20231108094055.221234-1-pbonzini@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KAjCfeo6K7RSch_bhh7m6CVvIIeIMptn
X-Proofpoint-ORIG-GUID: jFvB63MgjZ08D_h3RChgzVkAMs4UEMo7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-08_01,2023-11-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311080085

On Wed,  8 Nov 2023 04:40:55 -0500
Paolo Bonzini <pbonzini@redhat.com> wrote:

> This function does the same but makes it clearer why one would use
> the "____"-prefixed version of vm_create().
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  tools/testing/selftests/kvm/s390x/cmma_test.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/s390x/cmma_test.c b/tools/testing/selftests/kvm/s390x/cmma_test.c
> index c8e0a6495a63..626a2b8a2037 100644
> --- a/tools/testing/selftests/kvm/s390x/cmma_test.c
> +++ b/tools/testing/selftests/kvm/s390x/cmma_test.c
> @@ -94,11 +94,6 @@ static void guest_dirty_test_data(void)
>  	);
>  }
>  
> -static struct kvm_vm *create_vm(void)
> -{
> -	return ____vm_create(VM_MODE_DEFAULT);
> -}
> -
>  static void create_main_memslot(struct kvm_vm *vm)
>  {
>  	int i;
> @@ -157,7 +152,7 @@ static struct kvm_vm *create_vm_two_memslots(void)
>  {
>  	struct kvm_vm *vm;
>  
> -	vm = create_vm();
> +	vm = vm_create_barebones();
>  
>  	create_memslots(vm);
>  
> @@ -276,7 +271,7 @@ static void assert_exit_was_hypercall(struct kvm_vcpu *vcpu)
>  
>  static void test_migration_mode(void)
>  {
> -	struct kvm_vm *vm = create_vm();
> +	struct kvm_vm *vm = vm_create_barebones();
>  	struct kvm_vcpu *vcpu;
>  	u64 orig_psw;
>  	int rc;
> @@ -670,7 +665,7 @@ struct testdef {
>   */
>  static int machine_has_cmma(void)
>  {
> -	struct kvm_vm *vm = create_vm();
> +	struct kvm_vm *vm = vm_create_barebones();
>  	int r;
>  
>  	r = !__kvm_has_device_attr(vm->fd, KVM_S390_VM_MEM_CTRL, KVM_S390_VM_MEM_ENABLE_CMMA);


