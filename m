Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 458264EE5DE
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 04:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243922AbiDACDM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 22:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233627AbiDACDL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 22:03:11 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9F71B3709
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 19:01:23 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id q19so1240774pgm.6
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 19:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=inp9kuKjhcCLTA1TO6bZG50bHXwwzvGRunHbg0VDKic=;
        b=SI/wkGZSO7rD48uN4BWXpx6niBQ5n6IQZ0XrvOha2hO9JYf6qnh35WLUCCrN9BoXhG
         4Pzbqszklq7U+YWi6+uZR/x4kx2Nif9znv3m5N/yDazmW/3ZQP2CpKvgEQQtIDmlldkg
         fMDB3yOMCVhKpwuu11cRmHpnVvQCk2c87Ta4zgKDP5wqzXbpV/KAHE4yPFl9E3Z2I3uJ
         kn54xeV+HaS8CfMS+IGBwiK87R7D0ylyf5O5tF6QBEuUqYCPoUPYyU+shQ2gRWdMvUks
         PuxA/AqVzcsb4YvP1Yz34eGVzoU8+gGEgO0nKu7ZbHxbevGRwM3L9xSaPq6qa3swviSH
         ItYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=inp9kuKjhcCLTA1TO6bZG50bHXwwzvGRunHbg0VDKic=;
        b=w5bMONxBDWHjuX5Nx/idV4iCToZlI/TsUVNXB3JJxvixIKEI+PqMWL152v7dp0NPC6
         NKWl7PAX5wae/4HsSdNCpE43yFoHMEiAu8+YAiYFR1OLkmIlVJ+jNkif1BmapyRAtKhM
         4YV51tMk0Y52i7hr+W17YpDhfyQxpCgW2joPkJ0z9/jKJywoLEMn5yOAyTHqEcMEsrPt
         JVRQb3sA618XHPdQkCfaSZxuRHt84KIvYWcnCCDCaFNIO45AeIM7N2v1Tw56X2+h1ZcG
         EfAmFT0wAl+5crz+1RwLmOzCkaIZNr/LKQHix+hFEtTRAzrCMNTyHzfK5sOwOK/oL9CI
         O2hw==
X-Gm-Message-State: AOAM531kXsdJpY26D4FZpovYK94JY8x4xD6M2cXFbI8Atc+eS9XhrMki
        1D5dWkcsCDbzTuLmC5q7PY8pIg==
X-Google-Smtp-Source: ABdhPJyLL3SdY6NIy8qFZ4rOg3G6n19qIWtzib0xs31/VSRF6zM7QszMHFllBq9XXMt8yIf+wClntA==
X-Received: by 2002:a63:384e:0:b0:374:ae28:71fc with SMTP id h14-20020a63384e000000b00374ae2871fcmr13138721pgn.159.1648778482243;
        Thu, 31 Mar 2022 19:01:22 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j11-20020a63230b000000b00372a08b584asm604023pgj.47.2022.03.31.19.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 19:01:21 -0700 (PDT)
Date:   Fri, 1 Apr 2022 02:01:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
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
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>
Subject: Re: [PATCH v7 7/8] KVM: x86: Allow userspace set maximum VCPU id for
 VM
Message-ID: <YkZc7cMsDaR5S2hM@google.com>
References: <20220304080725.18135-1-guang.zeng@intel.com>
 <20220304080725.18135-8-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304080725.18135-8-guang.zeng@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 04, 2022, Zeng Guang wrote:
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
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  6 ++++++
>  arch/x86/kvm/x86.c              | 11 +++++++++++

The new behavior needs to be documented in api.rst.

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

This should be max_vcpu_ids.  I agree the it _should_ be max_vcpu_id, but KVM's API
for this is awful and we're stuck with the plural name.

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

I think it makes sense to change kvm_vm_ioctl_check_extension() to return the
current max, it is a VM-scoped ioctl after all.

Amusingly, I think we also need a capability to enumerate that KVM_CAP_MAX_VCPU_ID
is writable.  

> +		if (cap->args[0] <= KVM_MAX_VCPU_IDS) {
> +			kvm->arch.max_vcpu_id = cap->args[0];

This needs to be rejected if kvm->created_vcpus > 0, and that check needs to be
done under kvm_lock, otherwise userspace can bump the max ID after KVM allocates
per-VM structures and trigger buffer overflow.

> +			r = 0;
> +		} else

If-elif-else statements need curly braces for all paths if any path needs braces.
Probably a moot point for this patch due to the above changes.

> +			r = -E2BIG;

This should be -EINVAL, not -E2BIG.

E.g.

	case KVM_CAP_MAX_VCPU_ID:
		r = -EINVAL;
		if (cap->args[0] > KVM_MAX_VCPU_IDS)
			break;

		mutex_lock(&kvm->lock);
		if (!kvm->created_vcpus) {
			kvm->arch.max_vcpu_id = cap->args[0];
			r = 0;
		}
		mutex_unlock(&kvm->lock);
		break;


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

Same here, it should be -EINVAL.

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
> -- 
> 2.27.0
> 
