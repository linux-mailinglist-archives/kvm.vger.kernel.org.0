Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 768441634A3
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 22:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgBRVTB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 16:19:01 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57352 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726680AbgBRVTB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Feb 2020 16:19:01 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01ILFLaW007357
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 16:19:00 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y6dky0wyx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 16:18:59 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Tue, 18 Feb 2020 21:18:57 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 18 Feb 2020 21:18:53 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01ILInmA36896796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Feb 2020 21:18:50 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB11A42049;
        Tue, 18 Feb 2020 21:18:49 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CE6B42041;
        Tue, 18 Feb 2020 21:18:49 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.58.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Feb 2020 21:18:49 +0000 (GMT)
Subject: Re: [PATCH v2.1] KVM: s390: protvirt: Add initial vm and cpu
 lifecycle handling
To:     David Hildenbrand <david@redhat.com>
Cc:     Ulrich.Weigand@de.ibm.com, cohuck@redhat.com,
        frankja@linux.ibm.com, frankja@linux.vnet.ibm.com,
        gor@linux.ibm.com, imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, mimu@linux.ibm.com, thuth@redhat.com
References: <20200214222658.12946-10-borntraeger@de.ibm.com>
 <20200218083946.44720-1-borntraeger@de.ibm.com>
 <42deaa19-d2ca-f1cc-3e83-af0d5d77347f@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Tue, 18 Feb 2020 22:18:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <42deaa19-d2ca-f1cc-3e83-af0d5d77347f@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20021821-0012-0000-0000-00000388133B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021821-0013-0000-0000-000021C4A4E0
Message-Id: <f6bc712e-44b0-233e-886f-c72485ea13c3@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-18_06:2020-02-18,2020-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 suspectscore=2
 malwarescore=0 spamscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002180139
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 18.02.20 10:12, David Hildenbrand wrote:
> On 18.02.20 09:39, Christian Borntraeger wrote:
>> From: Janosch Frank <frankja@linux.ibm.com>
>>
>> This contains 3 main changes:
>> 1. changes in SIE control block handling for secure guests
>> 2. helper functions for create/destroy/unpack secure guests
>> 3. KVM_S390_PV_COMMAND ioctl to allow userspace dealing with secure
>> machines
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>> 2->2.1  - combine CREATE/DESTROY CPU/VM into ENABLE DISABLE
>> 	- rework locking and check locks with lockdep
>> 	- I still have the PV_COMMAND_CPU in here for later use in
>> 	  the SET_IPL_PSW ioctl. If wanted I can move
> 
> I'd prefer to move, and eventually just turn this into a clean, separate
> ioctl without subcommands (e.g., if we'll only need a single subcommand
> in the near future). And it makes this patch a alittle easier to review
> ... :)
> 

Maybe the MP_STATE solution will work out. Then we can get rid of this.
will look into that when dealing with the other patch.

> [...]

> 
> Once we lock the VCPU, it cannot be running, right?

Right, while holding the vcpu->mutex, KVM_RUN is blocked. 

> 
>> +	kvm_for_each_vcpu(i, vcpu, kvm) {
>> +		mutex_lock(&vcpu->mutex);
>> +		r = kvm_s390_pv_destroy_cpu(vcpu, rc, rrc);
>> +		mutex_unlock(&vcpu->mutex);
>> +		if (r)
>> +			break;
>> +	}
> 
> Can this actually ever fail? If so, you would leave half-initialized
> state around. Warn and continue?
> 
> Especially, kvm_arch_vcpu_destroy() ignores any error from
> kvm_s390_pv_destroy_cpu() as well ...
> 
> IMHO, we should make kvm_s390_switch_from_pv() and
> kvm_s390_pv_destroy_cpu() never fail.

will answer this part tomorrow.

> 
>> +	return r;
>> +}
>> +
>> +static int kvm_s390_switch_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
>> +{
>> +	int i, r = 0;
>> +	u16 dummy;
>> +
>> +	struct kvm_vcpu *vcpu;
>> +
>> +	kvm_for_each_vcpu(i, vcpu, kvm) {
>> +		mutex_lock(&vcpu->mutex);
>> +		r = kvm_s390_pv_create_cpu(vcpu, rc, rrc);
>> +		mutex_unlock(&vcpu->mutex);
>> +		if (r)
>> +			break;
>> +	}
>> +	if (r)
>> +		kvm_s390_switch_from_pv(kvm,&dummy, &dummy);
>> +	return r;
>> +}
>> +
>> +static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>> +{
>> +	int r = 0;
>> +	u16 dummy;
>> +	void __user *argp = (void __user *)cmd->data;
>> +
>> +	switch (cmd->cmd) {
>> +	case KVM_PV_ENABLE: {
>> +		r = -EINVAL;
>> +		if (kvm_s390_pv_is_protected(kvm))
>> +			break;
> 
> Why not factor out this check, it's common for all sucommands.

Unfortunately it is not common. Sometimes it has an "!" sometimes not.

> 
>> +
>> +		r = kvm_s390_pv_alloc_vm(kvm);
>> +		if (r)
>> +			break;
>> +
>> +		kvm_s390_vcpu_block_all(kvm);
> 
> As kvm_s390_vcpu_block_all() does not support nesting, this will not
> work as expected - sca_switch_to_extended() already blocks. Are the
> vcpu->locks not enough?

Right, we would need to move the sca_switch out of this lock. On the other
hand the vcpu->locks should be sufficent for the host integrity (and also
for the secure guest integrity))
So I will just remove the block_all here and below.
> 
> [...]
> 
>> @@ -2558,10 +2735,16 @@ static void kvm_free_vcpus(struct kvm *kvm)
>>  
>>  void kvm_arch_destroy_vm(struct kvm *kvm)
>>  {
>> +	u16 rc, rrc;
>>  	kvm_free_vcpus(kvm);
>>  	sca_dispose(kvm);
>> -	debug_unregister(kvm->arch.dbf);
>>  	kvm_s390_gisa_destroy(kvm);
>> +	/* do not use the lock checking variant at tear-down */
>> +	if (kvm_s390_pv_handle(kvm)) {
> 
> kvm_s390_pv_is_protected ? I dislike using kvm_s390_pv_handle() when
> we're not interested in the handle.

Then I would need to take the kvm->mutex here. This is why I added
the comment. We are already at the last steps of killing the kvm
and the lock is not held. So the lockdep check would complain.
On the other hand grabbing kvm->lock is pointless as the kvm file
descriptor is already gone so the ioctls that we would protect against
cannot happen.


What about Improving the comment:

        /*
         * We are already at the end of life and kvm->lock is not taken.
         * This is ok as the file descriptor is closed by now and nobody
         * can mess with the pv state. To avoid lockdep_assert_held from
         * complaining we do not use kvm_s390_pv_is_protected.
         */

On the other hand This looks a bit too verbose.




[...]

>> +static inline u64 kvm_s390_pv_handle(struct kvm *kvm)
>> +{
>> +	return kvm->arch.pv.handle;
>> +}
> 
> Can we rename this to
> 
> kvm_s390_pv_get_handle()

ack.
> 
>> +
>> +static inline u64 kvm_s390_pv_handle_cpu(struct kvm_vcpu *vcpu)
>> +{
>> +	return vcpu->arch.pv.handle;
>> +}
> 
> Can we rename this to kvm_s390_pv_cpu_get_handle() ? (so it doesn't look
> like the function will handle something)

ack. 

[...]
>> +int kvm_s390_pv_alloc_vm(struct kvm *kvm)
>> +{
>> +	unsigned long base = uv_info.guest_base_stor_len;
>> +	unsigned long virt = uv_info.guest_virt_var_stor_len;
>> +	unsigned long npages = 0, vlen = 0;
>> +	struct kvm_memory_slot *memslot;
>> +
>> +	kvm->arch.pv.stor_var = NULL;
>> +	kvm->arch.pv.stor_base = __get_free_pages(GFP_KERNEL, get_order(base));
>> +	if (!kvm->arch.pv.stor_base)
>> +		return -ENOMEM;
>> +
>> +	/*
>> +	 * Calculate current guest storage for allocation of the
>> +	 * variable storage, which is based on the length in MB.
>> +	 *
>> +	 * Slots are sorted by GFN
>> +	 */
>> +	mutex_lock(&kvm->slots_lock);
>> +	memslot = kvm_memslots(kvm)->memslots;
>> +	npages = memslot->base_gfn + memslot->npages;
>> +	mutex_unlock(&kvm->slots_lock);
> 
> Are you blocking the addition of new memslots somehow?
> 

>> +int kvm_s390_pv_create_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>> +{
>> +	u16 drc, drrc;
>> +	int cc;
>> +
>> +	struct uv_cb_cgc uvcb = {
>> +		.header.cmd = UVC_CMD_CREATE_SEC_CONF,
>> +		.header.len = sizeof(uvcb)
>> +	};
>> +
>> +	if (kvm_s390_pv_handle(kvm))
> 
> Why is that necessary? We should only be called in PV mode.

It is not because the caller already checks. It was necessary in a previous version I guess.

[...]
>> +int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
>> +			      u16 *rrc)
>> +{
>> +	struct uv_cb_ssc uvcb = {
>> +		.header.cmd = UVC_CMD_SET_SEC_CONF_PARAMS,
>> +		.header.len = sizeof(uvcb),
>> +		.sec_header_origin = (u64)hdr,
>> +		.sec_header_len = length,
>> +		.guest_handle = kvm_s390_pv_handle(kvm),
>> +	};
>> +	int cc;
>> +
>> +	if (!kvm_s390_pv_handle(kvm))
> 
> Why is that necessary? We should only be called in PV mode.

ack


[...]

>> +struct kvm_s390_pv_sec_parm {
>> +	__u64	origin;
>> +	__u64	length;
> 
> tabs vs. spaces. (I'd use a single space like in kvm_s390_pv_unp below)

ack.
[...]

