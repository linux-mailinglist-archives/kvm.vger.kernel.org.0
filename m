Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2906A1D291D
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 09:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbgENHx0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 03:53:26 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58781 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725886AbgENHx0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 03:53:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589442804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=TrCBeSqKjO6O1ZTRFPbViol6yVoYxWh8OwTfPgDqwh0=;
        b=Ydfuhws0HZKse1tC5eJi7mo/JgtxFVKFSS+kzdUYZT7hWoDDfGQ1QfruMv8tKxJoTvQVO+
        cAobTl2n8tLh0KIe3TxtRZ/8ogmr0CrTQZAd8vERHCQKsbthpOBNJnHlxe5cdSuNJGOKCn
        AOn/wC+hM5CYT/42DB70jfJbQr0W3cs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-tuk6MqQPOuC4uMv4Xab4xA-1; Thu, 14 May 2020 03:53:22 -0400
X-MC-Unique: tuk6MqQPOuC4uMv4Xab4xA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BA32107ACF2;
        Thu, 14 May 2020 07:53:21 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-113-31.ams2.redhat.com [10.36.113.31])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A9E97529E;
        Thu, 14 May 2020 07:53:14 +0000 (UTC)
Subject: Re: [PATCH v6 2/2] s390/kvm: diagnose 318 handling
To:     Collin Walling <walling@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
References: <20200513221557.14366-1-walling@linux.ibm.com>
 <20200513221557.14366-3-walling@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d4320d09-7b3a-ac13-77be-02397f4ccc83@redhat.com>
Date:   Thu, 14 May 2020 09:53:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200513221557.14366-3-walling@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/05/2020 00.15, Collin Walling wrote:
> DIAGNOSE 0x318 (diag318) is a privileged s390x instruction that must
> be intercepted by SIE and handled via KVM. Let's introduce some
> functions to communicate between userspace and KVM via ioctls. These
> will be used to get/set the diag318 related information, as well as
> check the system if KVM supports handling this instruction.
> 
> This information can help with diagnosing the environment the VM is
> running in (Linux, z/VM, etc) if the OS calls this instruction.
> 
> By default, this feature is disabled and can only be enabled if a
> user space program (such as QEMU) explicitly requests it.
> 
> The Control Program Name Code (CPNC) is stored in the SIE block
> and a copy is retained in each VCPU. The Control Program Version
> Code (CPVC) is not designed to be stored in the SIE block, so we
> retain a copy in each VCPU next to the CPNC.
> 
> Signed-off-by: Collin Walling <walling@linux.ibm.com>
> ---
>  Documentation/virt/kvm/devices/vm.rst | 29 +++++++++
>  arch/s390/include/asm/kvm_host.h      |  6 +-
>  arch/s390/include/uapi/asm/kvm.h      |  5 ++
>  arch/s390/kvm/diag.c                  | 20 ++++++
>  arch/s390/kvm/kvm-s390.c              | 89 +++++++++++++++++++++++++++
>  arch/s390/kvm/kvm-s390.h              |  1 +
>  arch/s390/kvm/vsie.c                  |  2 +
>  7 files changed, 151 insertions(+), 1 deletion(-)
[...]
> diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
> index 563429dece03..3caed4b880c8 100644
> --- a/arch/s390/kvm/diag.c
> +++ b/arch/s390/kvm/diag.c
> @@ -253,6 +253,24 @@ static int __diag_virtio_hypercall(struct kvm_vcpu *vcpu)
>  	return ret < 0 ? ret : 0;
>  }
>  
> +static int __diag_set_diag318_info(struct kvm_vcpu *vcpu)
> +{
> +	unsigned int reg = (vcpu->arch.sie_block->ipa & 0xf0) >> 4;
> +	u64 info = vcpu->run->s.regs.gprs[reg];
> +
> +	if (!vcpu->kvm->arch.use_diag318)
> +		return -EOPNOTSUPP;
> +
> +	vcpu->stat.diagnose_318++;
> +	kvm_s390_set_diag318_info(vcpu->kvm, info);
> +
> +	VCPU_EVENT(vcpu, 3, "diag 0x318 cpnc: 0x%x cpvc: 0x%llx",
> +		   vcpu->kvm->arch.diag318_info.cpnc,
> +		   (u64)vcpu->kvm->arch.diag318_info.cpvc);
> +
> +	return 0;
> +}
> +
>  int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
>  {
>  	int code = kvm_s390_get_base_disp_rs(vcpu, NULL) & 0xffff;
> @@ -272,6 +290,8 @@ int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
>  		return __diag_page_ref_service(vcpu);
>  	case 0x308:
>  		return __diag_ipl_functions(vcpu);
> +	case 0x318:
> +		return __diag_set_diag318_info(vcpu);
>  	case 0x500:
>  		return __diag_virtio_hypercall(vcpu);

I wonder whether it would make more sense to simply drop to userspace
and handle the diag 318 call there? That way the userspace would always
be up-to-date, and as we've seen in the past (e.g. with the various SIGP
handling), it's better if the userspace is in control... e.g. userspace
could also decide to only use KVM_S390_VM_MISC_ENABLE_DIAG318 if the
guest just executed the diag 318 instruction.

And you need the kvm_s390_vm_get/set_misc functions anyway, so these
could also be simply used by the diag 318 handler in userspace?

>  	default:
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index d05bb040fd42..c3eee468815f 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -159,6 +159,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>  	{ "diag_9c_ignored", VCPU_STAT(diagnose_9c_ignored) },
>  	{ "instruction_diag_258", VCPU_STAT(diagnose_258) },
>  	{ "instruction_diag_308", VCPU_STAT(diagnose_308) },
> +	{ "instruction_diag_318", VCPU_STAT(diagnose_318) },
>  	{ "instruction_diag_500", VCPU_STAT(diagnose_500) },
>  	{ "instruction_diag_other", VCPU_STAT(diagnose_other) },
>  	{ NULL }
> @@ -1243,6 +1244,76 @@ static int kvm_s390_get_tod(struct kvm *kvm, struct kvm_device_attr *attr)
>  	return ret;
>  }
>  
> +void kvm_s390_set_diag318_info(struct kvm *kvm, u64 info)
> +{
> +	struct kvm_vcpu *vcpu;
> +	int i;
> +
> +	kvm->arch.diag318_info.val = info;
> +
> +	VM_EVENT(kvm, 3, "SET: CPNC: 0x%x CPVC: 0x%llx",
> +		 kvm->arch.diag318_info.cpnc, kvm->arch.diag318_info.cpvc);
> +
> +	if (sclp.has_diag318) {
> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			vcpu->arch.sie_block->cpnc = kvm->arch.diag318_info.cpnc;
> +		}
> +	}
> +}
> +
> +static int kvm_s390_vm_set_misc(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +	int ret;
> +	u64 diag318_info;
> +
> +	switch (attr->attr) {
> +	case KVM_S390_VM_MISC_ENABLE_DIAG318:
> +		kvm->arch.use_diag318 = 1;
> +		ret = 0;
> +		break;

Would it make sense to set kvm->arch.use_diag318 = 1 during the first
execution of KVM_S390_VM_MISC_DIAG318 instead, so that we could get
along without the KVM_S390_VM_MISC_ENABLE_DIAG318 ?

> +	case KVM_S390_VM_MISC_DIAG318:
> +		ret = -EFAULT;
> +		if (!kvm->arch.use_diag318)
> +			return -EOPNOTSUPP;
> +		if (get_user(diag318_info, (u64 __user *)attr->addr))
> +			break;
> +		kvm_s390_set_diag318_info(kvm, diag318_info);
> +		ret = 0;
> +		break;
> +	default:
> +		ret = -ENXIO;
> +		break;
> +	}
> +	return ret;
> +}

What about a reset of the guest VM? If a user first boots into a Linux
kernel that supports diag 318, then reboots and selects a Linux kernel
that does not support diag 318? I'd expect that the cpnc / cpnv values
need to be cleared here somewhere? Otherwise the information might not
be accurate anymore?

 Thomas

