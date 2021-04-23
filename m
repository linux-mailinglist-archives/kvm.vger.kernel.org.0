Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90F8368F77
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 11:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhDWJhK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 05:37:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53970 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229811AbhDWJhJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 05:37:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619170592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p9J8d+DcmrmU5bpl7D7O/0XVrwseyB5JAxCq6IfLR4U=;
        b=ehYVX298psUNDVr11YijCqmIna8pJBqreNx2WP5Cf/TKLZbCePSIbZSNQyg81hG20Jk/jf
        CsD6AFLeHzcHubKEKB7nzRFzvwC5aetdBsku5scAzo3kh0B/8FJyb2nBqj4AC21Q5rgyGw
        R/WD9abDhS5A/dkwE3OoRAgYGz8o0KM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-EjT7diIhNsS7fauK_UN5Kg-1; Fri, 23 Apr 2021 05:36:31 -0400
X-MC-Unique: EjT7diIhNsS7fauK_UN5Kg-1
Received: by mail-ed1-f70.google.com with SMTP id d2-20020aa7d6820000b0290384ee872881so14207600edr.10
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 02:36:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=p9J8d+DcmrmU5bpl7D7O/0XVrwseyB5JAxCq6IfLR4U=;
        b=kgu/ON622KlMRd0QaRJrLJoi/WjaL64IrMlRPOWx/cMuQ7AllPomff/eQzfWB2bT6i
         lmqLbk5z3tTokSwP7sUyXJpj+LvkrXRMREn3Hso8aMItNDZmsk9WwCC0Eq1iWQk65BG8
         0RbgY71jmu48MQYSzP2wagEi2qSSOV7j0DCoZZxjh2KGRQAfH4U/Dwaw4+C1Hdu7aZX3
         xoao53S4hMcTwdxNLB+jvWB4oRWgZ6NQl3zQaiRjMPvg090XfePYY3eugtAUVIJJQL/Q
         H85tobgt4Qr86k6a53nTUrhVclPcV7AEnHmgr3TroXYStIr1+wJF+yFT80J4uC2yoJui
         4p4A==
X-Gm-Message-State: AOAM530kTPmaNEvegIzLGqRkmhhk9meu9rL6zPGirwmpDPW5FS4wKlno
        n3xK2moTjrLxcfSgBPUuhcMMWcipO3y6u2M6/36UdeqXBJKqWSpNInUbB+0uW9oq33GaLdXD68C
        Qh8+w/LdrSlvJ
X-Received: by 2002:a50:f395:: with SMTP id g21mr3455738edm.238.1619170588617;
        Fri, 23 Apr 2021 02:36:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPvQeASMPZ9Nlq9ueh1HJgNqcWr2ObOsJP+voJ0+O8Gy6PfYnk5Y07l9nhaCt4WEIeyB/9KA==
X-Received: by 2002:a50:f395:: with SMTP id g21mr3455708edm.238.1619170588342;
        Fri, 23 Apr 2021 02:36:28 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id c13sm4252594edw.88.2021.04.23.02.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 02:36:28 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: hyper-v: Add new exit reason HYPERV_OVERLAY
In-Reply-To: <20210423090333.21910-1-sidcha@amazon.de>
References: <20210423090333.21910-1-sidcha@amazon.de>
Date:   Fri, 23 Apr 2021 11:36:27 +0200
Message-ID: <87y2d9filg.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Siddharth Chandrasekaran <sidcha@amazon.de> writes:

> Hypercall code page is specified in the Hyper-V TLFS to be an overlay
> page, ie., guest chooses a GPA and the host _places_ a page at that
> location, making it visible to the guest and the existing page becomes
> inaccessible. Similarly when disabled, the host should _remove_ the
> overlay and the old page should become visible to the guest.
>
> Currently KVM directly patches the hypercall code into the guest chosen
> GPA. Since the guest seldom moves the hypercall code page around, it
> doesn't see any problems even though we are corrupting the exiting data
> in that GPA.
>
> VSM API introduces more complex overlay workflows during VTL switches
> where the guest starts to expect that the existing page is intact. This
> means we need a more generic approach to handling overlay pages: add a
> new exit reason KVM_EXIT_HYPERV_OVERLAY that exits to userspace with the
> expectation that a page gets overlaid there.
>
> In the interest of maintaing userspace exposed behaviour, add a new KVM
> capability to allow the VMMs to enable this if they can handle the
> hypercall page in userspace.
>
> Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
>
> CR: https://code.amazon.com/reviews/CR-49011379

This line wasn't supposed to go to the upstream patch, was it? :-)

> ---
>  arch/x86/include/asm/kvm_host.h |  4 ++++
>  arch/x86/kvm/hyperv.c           | 25 ++++++++++++++++++++++---
>  arch/x86/kvm/x86.c              |  5 +++++
>  include/uapi/linux/kvm.h        | 10 ++++++++++
>  4 files changed, 41 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3768819693e5..2b560e77f8bc 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -925,6 +925,10 @@ struct kvm_hv {
>  
>  	struct hv_partition_assist_pg *hv_pa_pg;
>  	struct kvm_hv_syndbg hv_syndbg;
> +
> +	struct {
> +		u64 overlay_hcall_page:1;
> +	} flags;

Do you plan to add more flags here? If not, I'd suggest we use a simple
boolean instead of the whole 'flags' structure.

>  };
>  
>  struct msr_bitmap_range {
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index f98370a39936..e7d9d3bb39dc 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -191,6 +191,21 @@ static void kvm_hv_notify_acked_sint(struct kvm_vcpu *vcpu, u32 sint)
>  	srcu_read_unlock(&kvm->irq_srcu, idx);
>  }
>  
> +static void overlay_exit(struct kvm_vcpu *vcpu, u32 msr, u64 gpa,
> +			 u32 data_len, const u8 *data)
> +{
> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +
> +	hv_vcpu->exit.type = KVM_EXIT_HYPERV_OVERLAY;
> +	hv_vcpu->exit.u.overlay.msr = msr;
> +	hv_vcpu->exit.u.overlay.gpa = gpa;
> +	hv_vcpu->exit.u.overlay.data_len = data_len;
> +	if (data_len)
> +		memcpy(hv_vcpu->exit.u.overlay.data, data, data_len);

It seems this exit to userspace has double meaning:
1) Please put an overlay page at GPA ... (are we sure we will never need
more than one page?)
2) Do something else depending on the MSR which triggered the write (are
we sure all such exits are going to be triggered by an MSR write?)

and I'm wondering if it would be possible to actually limit
KVM_EXIT_HYPERV_OVERLAY to 'put an overlay page' and do the rest somehow
differently.

In particularly, I think we can still do hypercall page patching
directly from KVM after overlay page setup. With VTL, when the logic is
more complex, do you expect it to be implemented primarily in userspace?

> +
> +	kvm_make_request(KVM_REQ_HV_EXIT, vcpu);
> +}
> +
>  static void synic_exit(struct kvm_vcpu_hv_synic *synic, u32 msr)
>  {
>  	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
> @@ -1246,9 +1261,13 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
>  		/* ret */
>  		((unsigned char *)instructions)[i++] = 0xc3;
>  
> -		addr = data & HV_X64_MSR_HYPERCALL_PAGE_ADDRESS_MASK;
> -		if (kvm_vcpu_write_guest(vcpu, addr, instructions, i))
> -			return 1;
> +		if (kvm->arch.hyperv.flags.overlay_hcall_page) {
> +			overlay_exit(vcpu, msr, data, (u32)i, instructions);
> +		} else {
> +			addr = data & HV_X64_MSR_HYPERCALL_PAGE_ADDRESS_MASK;
> +			if (kvm_vcpu_write_guest(vcpu, addr, instructions, i))
> +				return 1;
> +		}
>  		hv->hv_hypercall = data;
>  		break;
>  	}
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index eca63625aee4..b3e497343e5c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3745,6 +3745,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_HYPERV_TLBFLUSH:
>  	case KVM_CAP_HYPERV_SEND_IPI:
>  	case KVM_CAP_HYPERV_CPUID:
> +	case KVM_CAP_HYPERV_OVERLAY_HCALL_PAGE:
>  	case KVM_CAP_SYS_HYPERV_CPUID:
>  	case KVM_CAP_PCI_SEGMENT:
>  	case KVM_CAP_DEBUGREGS:
> @@ -5357,6 +5358,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  			kvm->arch.bus_lock_detection_enabled = true;
>  		r = 0;
>  		break;
> +	case KVM_CAP_HYPERV_OVERLAY_HCALL_PAGE:
> +		kvm->arch.hyperv.flags.overlay_hcall_page = true;
> +		r = 0;
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index f6afee209620..37b0715da4fd 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -185,10 +185,13 @@ struct kvm_s390_cmma_log {
>  	__u64 values;
>  };
>  
> +#define KVM_EXIT_HV_OVERLAY_DATA_SIZE  64

Could you please elaborate on why you think 64 bytes is going to be
enough? (like what structures we'll be passing here for VTL)

> +
>  struct kvm_hyperv_exit {
>  #define KVM_EXIT_HYPERV_SYNIC          1
>  #define KVM_EXIT_HYPERV_HCALL          2
>  #define KVM_EXIT_HYPERV_SYNDBG         3
> +#define KVM_EXIT_HYPERV_OVERLAY        4

Please document this in Documentation/virt/kvm/api.rst

>  	__u32 type;
>  	__u32 pad1;
>  	union {
> @@ -213,6 +216,12 @@ struct kvm_hyperv_exit {
>  			__u64 recv_page;
>  			__u64 pending_page;
>  		} syndbg;
> +		struct {
> +			__u32 msr;
> +			__u32 data_len;
> +			__u64 gpa;
> +			__u8 data[KVM_EXIT_HV_OVERLAY_DATA_SIZE];

... in partucular, please document the meaning of 'data' (in case it
needs to be here).

> +		} overlay;
>  	} u;
>  };
>  
> @@ -1078,6 +1087,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_DIRTY_LOG_RING 192
>  #define KVM_CAP_X86_BUS_LOCK_EXIT 193
>  #define KVM_CAP_PPC_DAWR1 194
> +#define KVM_CAP_HYPERV_OVERLAY_HCALL_PAGE 195
>  
>  #ifdef KVM_CAP_IRQ_ROUTING

-- 
Vitaly

