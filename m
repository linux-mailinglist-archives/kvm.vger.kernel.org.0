Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD210177B4F
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 17:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbgCCP7Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 10:59:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51126 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729484AbgCCP7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 10:59:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583251163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dyna7Icg0hppwMOBlf0UCh1yYWzj0K1NaPb8TRW4vck=;
        b=AadUikxkm8hU2APC9mkSKHDEXLUWUvqxUMeT37T1S1a5WKeSWBp2IVlEanSvEL2jkYjMH1
        +RClEkwndoZhS4RUW9OZYUPzCTgTk5ertmd7lHHYCSkbr93UWW4F5LKU/Yc6pbWDDPgw9P
        A2K66JUbfe029EodjkHCArP/PVzvLE8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-x-cwrCuPN4CKsT94-hajuQ-1; Tue, 03 Mar 2020 10:59:20 -0500
X-MC-Unique: x-cwrCuPN4CKsT94-hajuQ-1
Received: by mail-wm1-f70.google.com with SMTP id c5so1272371wmd.8
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 07:59:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dyna7Icg0hppwMOBlf0UCh1yYWzj0K1NaPb8TRW4vck=;
        b=VHcLlnzCHKRPc9Pcp02ZwE2tmXgcEyWYruSTOpjBL2NJ4E+ipKZ63Fsvf9+I0SXFpR
         hySaqtPfl+sTzNNZ9afTNg8fMzdXXt4TY1Qbft1YbE1S7ADW3w3BzbyqMHUTIJoEBdoP
         tzCpddEqjJWmV+i/w7Z2/xWbp410edNdEm5ydRhYwO/G6eFkVp/c8PzIJSu0KbfzcNEU
         n7XLAfUW8LroPkk7y6ky3nvQaR7za2LqEZfBWp4tpOSwn3H9WkCm5kyaSHOnNeR/9fbZ
         hO5xDcWTVtYvWO1M6utWnhVTr5oYpEEyEnO9lyjIb86ljwzOmguLllShTIEv4WCETFDd
         73kg==
X-Gm-Message-State: ANhLgQ2x7uRIfZcHqoecAkAMsonHidl/irFbqANPQTVS+vNoR06XuPxR
        5ovCVja+TLgC1MnWSJEp3d95QalnJzLwgNLZtdajCaFEbTnINaohXmDoTeAmUuiEvN0gtUcBvm7
        qlZQgJJ8iMWFx
X-Received: by 2002:adf:ce8c:: with SMTP id r12mr6219836wrn.189.1583251158566;
        Tue, 03 Mar 2020 07:59:18 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsFyUVQZXNcnoHUqqilYkswr5iKSk1WWj022fMfssqqCnGN/YCOCr16rmfm//UYAURThINyCA==
X-Received: by 2002:adf:ce8c:: with SMTP id r12mr6219808wrn.189.1583251158302;
        Tue, 03 Mar 2020 07:59:18 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id c2sm4820004wma.39.2020.03.03.07.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 07:59:17 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v2 48/66] KVM: x86: Remove stateful CPUID handling
In-Reply-To: <20200302235709.27467-49-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com> <20200302235709.27467-49-sean.j.christopherson@intel.com>
Date:   Tue, 03 Mar 2020 16:59:16 +0100
Message-ID: <87ftepfmzv.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Remove the code for handling stateful CPUID 0x2 and mark the associated
> flags as deprecated.  WARN if host CPUID 0x2.0.AL > 1, i.e. if by some
> miracle a host with stateful CPUID 0x2 is encountered.
>
> No known CPU exists that supports hardware accelerated virtualization
> _and_ a stateful CPUID 0x2.  Barring an extremely contrived nested
> virtualization scenario, stateful CPUID support is dead code.
>
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  Documentation/virt/kvm/api.rst | 22 ++--------
>  arch/x86/kvm/cpuid.c           | 73 ++++++----------------------------
>  2 files changed, 17 insertions(+), 78 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index ebd383fba939..c38cd9f88237 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1574,8 +1574,8 @@ This ioctl would set vcpu's xcr to the value userspace specified.
>    };
>  
>    #define KVM_CPUID_FLAG_SIGNIFCANT_INDEX		BIT(0)
> -  #define KVM_CPUID_FLAG_STATEFUL_FUNC		BIT(1)
> -  #define KVM_CPUID_FLAG_STATE_READ_NEXT		BIT(2)
> +  #define KVM_CPUID_FLAG_STATEFUL_FUNC		BIT(1) /* deprecated */
> +  #define KVM_CPUID_FLAG_STATE_READ_NEXT		BIT(2) /* deprecated */
>  
>    struct kvm_cpuid_entry2 {
>  	__u32 function;
> @@ -1626,13 +1626,6 @@ emulate them efficiently. The fields in each entry are defined as follows:
>  
>          KVM_CPUID_FLAG_SIGNIFCANT_INDEX:
>             if the index field is valid
> -        KVM_CPUID_FLAG_STATEFUL_FUNC:
> -           if cpuid for this function returns different values for successive
> -           invocations; there will be several entries with the same function,
> -           all with this flag set
> -        KVM_CPUID_FLAG_STATE_READ_NEXT:
> -           for KVM_CPUID_FLAG_STATEFUL_FUNC entries, set if this entry is
> -           the first entry to be read by a cpu
>  
>     eax, ebx, ecx, edx:
>           the values returned by the cpuid instruction for
> @@ -3347,8 +3340,8 @@ The member 'flags' is used for passing flags from userspace.
>  ::
>  
>    #define KVM_CPUID_FLAG_SIGNIFCANT_INDEX		BIT(0)
> -  #define KVM_CPUID_FLAG_STATEFUL_FUNC		BIT(1)
> -  #define KVM_CPUID_FLAG_STATE_READ_NEXT		BIT(2)
> +  #define KVM_CPUID_FLAG_STATEFUL_FUNC		BIT(1) /* deprecated */
> +  #define KVM_CPUID_FLAG_STATE_READ_NEXT		BIT(2) /* deprecated */
>  
>    struct kvm_cpuid_entry2 {
>  	__u32 function;
> @@ -3394,13 +3387,6 @@ The fields in each entry are defined as follows:
>  
>          KVM_CPUID_FLAG_SIGNIFCANT_INDEX:
>             if the index field is valid
> -        KVM_CPUID_FLAG_STATEFUL_FUNC:
> -           if cpuid for this function returns different values for successive
> -           invocations; there will be several entries with the same function,
> -           all with this flag set
> -        KVM_CPUID_FLAG_STATE_READ_NEXT:
> -           for KVM_CPUID_FLAG_STATEFUL_FUNC entries, set if this entry is
> -           the first entry to be read by a cpu
>  
>     eax, ebx, ecx, edx:
>  
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index b5dce17c070f..49527dbcc90c 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -495,25 +495,16 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		 * time, with the least-significant byte in EAX enumerating the
>  		 * number of times software should do CPUID(2, 0).
>  		 *
> -		 * Modern CPUs (quite likely every CPU KVM has *ever* run on)
> -		 * are less idiotic.  Intel's SDM states that EAX & 0xff "will
> -		 * always return 01H. Software should ignore this value and not
> +		 * Modern CPUs, i.e. every CPU KVM has *ever* run on are less
> +		 * idiotic.  Intel's SDM states that EAX & 0xff "will always
> +		 * return 01H. Software should ignore this value and not
>  		 * interpret it as an informational descriptor", while AMD's
>  		 * APM states that CPUID(2) is reserved.
> +		 *
> +		 * WARN if a frankenstein CPU that supports virtualization and
> +		 * a stateful CPUID.0x2 is encountered.
>  		 */
> -		max_idx = entry->eax & 0xff;
> -		if (likely(max_idx <= 1))
> -			break;
> -
> -		entry->flags |= KVM_CPUID_FLAG_STATEFUL_FUNC;
> -		entry->flags |= KVM_CPUID_FLAG_STATE_READ_NEXT;
> -
> -		for (i = 1; i < max_idx; ++i) {
> -			entry = do_host_cpuid(array, function, 0);
> -			if (!entry)
> -				goto out;
> -			entry->flags |= KVM_CPUID_FLAG_STATEFUL_FUNC;
> -		}
> +		WARN_ON_ONCE((entry->eax & 0xff) > 1);
>  		break;
>  	/* functions 4 and 0x8000001d have additional index. */
>  	case 4:
> @@ -894,58 +885,20 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>  	return r;
>  }
>  
> -static int move_to_next_stateful_cpuid_entry(struct kvm_vcpu *vcpu, int i)
> -{
> -	struct kvm_cpuid_entry2 *e = &vcpu->arch.cpuid_entries[i];
> -	struct kvm_cpuid_entry2 *ej;
> -	int j = i;
> -	int nent = vcpu->arch.cpuid_nent;
> -
> -	e->flags &= ~KVM_CPUID_FLAG_STATE_READ_NEXT;
> -	/* when no next entry is found, the current entry[i] is reselected */
> -	do {
> -		j = (j + 1) % nent;
> -		ej = &vcpu->arch.cpuid_entries[j];
> -	} while (ej->function != e->function);
> -
> -	ej->flags |= KVM_CPUID_FLAG_STATE_READ_NEXT;
> -
> -	return j;
> -}
> -
> -/* find an entry with matching function, matching index (if needed), and that
> - * should be read next (if it's stateful) */
> -static int is_matching_cpuid_entry(struct kvm_cpuid_entry2 *e,
> -	u32 function, u32 index)
> -{
> -	if (e->function != function)
> -		return 0;
> -	if ((e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX) && e->index != index)
> -		return 0;
> -	if (unlikely(e->flags & KVM_CPUID_FLAG_STATEFUL_FUNC) &&
> -	    !(e->flags & KVM_CPUID_FLAG_STATE_READ_NEXT))
> -		return 0;
> -	return 1;
> -}
> -
>  struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
>  					      u32 function, u32 index)
>  {
> +	struct kvm_cpuid_entry2 *e;
>  	int i;
> -	struct kvm_cpuid_entry2 *best = NULL;
>  
>  	for (i = 0; i < vcpu->arch.cpuid_nent; ++i) {
> -		struct kvm_cpuid_entry2 *e;
> -
>  		e = &vcpu->arch.cpuid_entries[i];
> -		if (is_matching_cpuid_entry(e, function, index)) {
> -			if (unlikely(e->flags & KVM_CPUID_FLAG_STATEFUL_FUNC))
> -				move_to_next_stateful_cpuid_entry(vcpu, i);
> -			best = e;
> -			break;
> -		}
> +
> +		if (e->function == function && (e->index == index ||
> +		    !(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX)))
> +			return e;
>  	}
> -	return best;
> +	return NULL;
>  }
>  EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

