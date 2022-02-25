Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D23F24C4BFA
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 18:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243622AbiBYRXl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 12:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238554AbiBYRXk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 12:23:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 97240B0E86
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 09:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645809787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o6+p4N/r5BZgyxyBk99ql5qndbC6qsnKcpY4R84Y2C8=;
        b=HhRP2zKVFlBoogIQbmLo8sfZVPdvcaD9HAl7e5oO2OtTX1l9v5S6TKppAPzHpD1kagSvbv
        12ZDiB60lAwo2s4vADFi9IuZAbRLwbfGaPE91wwnDZvq6yI/VhmuW7P00MZl4LC2WkZjBT
        w7AbUYjBULnN3lowpmtgRaMoWuT8fQk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-t_3oUhy-NCKAHGse6EVuyQ-1; Fri, 25 Feb 2022 12:23:04 -0500
X-MC-Unique: t_3oUhy-NCKAHGse6EVuyQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBE94FC81;
        Fri, 25 Feb 2022 17:23:01 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 91D4A2B450;
        Fri, 25 Feb 2022 17:22:42 +0000 (UTC)
Message-ID: <552134618737fec8c06afc878dc81b740d70930e.camel@redhat.com>
Subject: Re: [PATCH v6 8/9] KVM: x86: Allow userspace set maximum VCPU id
 for VM
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>
Date:   Fri, 25 Feb 2022 19:22:41 +0200
In-Reply-To: <20220225082223.18288-9-guang.zeng@intel.com>
References: <20220225082223.18288-1-guang.zeng@intel.com>
         <20220225082223.18288-9-guang.zeng@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-02-25 at 16:22 +0800, Zeng Guang wrote:
> Introduce new max_vcpu_id in KVM for x86 architecture. Userspace
> can assign maximum possible vcpu id for current VM session using
> KVM_CAP_MAX_VCPU_ID of KVM_ENABLE_CAP ioctl().
> 
> This is done for x86 only because the sole use case is to guide
> memory allocation for PID-pointer table, a structure needed to
> enable VMX IPI.
> 
> By default, max_vcpu_id set as KVM_MAX_VCPU_IDS.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> ---
> No new KVM capability is added to advertise the support of
> configurable maximum vCPU ID to user space because max_vcpu_id is
> just a hint/commitment to allow KVM to reduce the size of PID-pointer
> table. But I am not 100% sure if it is proper to do so.
> 
>  arch/x86/include/asm/kvm_host.h |  6 ++++++
>  arch/x86/kvm/x86.c              | 11 +++++++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6dcccb304775..db16aebd946c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1233,6 +1233,12 @@ struct kvm_arch {
>  	hpa_t	hv_root_tdp;
>  	spinlock_t hv_root_tdp_lock;
>  #endif
> +	/*
> +	 * VM-scope maximum vCPU ID. Used to determine the size of structures
> +	 * that increase along with the maximum vCPU ID, in which case, using
> +	 * the global KVM_MAX_VCPU_IDS may lead to significant memory waste.
> +	 */
> +	u32 max_vcpu_id;
>  };
>  
>  struct kvm_vm_stat {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4f6fe9974cb5..ca17cc452bd3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5994,6 +5994,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		kvm->arch.exit_on_emulation_error = cap->args[0];
>  		r = 0;
>  		break;
> +	case KVM_CAP_MAX_VCPU_ID:
> +		if (cap->args[0] <= KVM_MAX_VCPU_IDS) {
> +			kvm->arch.max_vcpu_id = cap->args[0];
> +			r = 0;
> +		} else
> +			r = -E2BIG;
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
> @@ -11067,6 +11074,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	struct page *page;
>  	int r;
>  
> +	if (vcpu->vcpu_id >= vcpu->kvm->arch.max_vcpu_id)
> +		return -E2BIG;
> +
>  	vcpu->arch.last_vmentry_cpu = -1;
>  	vcpu->arch.regs_avail = ~0;
>  	vcpu->arch.regs_dirty = ~0;
> @@ -11589,6 +11599,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
>  	kvm->arch.hv_root_tdp = INVALID_PAGE;
>  #endif
> +	kvm->arch.max_vcpu_id = KVM_MAX_VCPU_IDS;
>  
>  	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
>  	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

+ Reminder for myself to use this in AVIC code to as well to limit the size of the physid table.
(The max size of the table (for now...) is 1 page (or 1/2 of page for non x2avic), 
but still no doubt it takes some effort  for microcode to scan all the unused entries in it for nothing
(and soon my nested avic code will have to scan it as well).

Best regards,
	Maxim Levitsky

