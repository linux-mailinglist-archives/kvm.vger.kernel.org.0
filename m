Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA21C18F8E9
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 16:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbgCWPr5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 11:47:57 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:32822 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727176AbgCWPr5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 11:47:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584978475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dvBlRRLg3CjMYlQe8Gy70l16tflLAU7l7Cy4EhgrGo0=;
        b=E+bISzEj8i2+b/tP9/hhcHcfI1L+ErHLihn5U7GBNkoY0x5B7D9gNHq2OktNSYsE39DA92
        ERelCJCjbCm+LkTH7qAnrahdefGqUSAwHbxry6p2nDxrTjhRTMDXvvHJUdEzaiTuWtA0dH
        KBJD19wsJXO6kLcBJnMlKkMiqeOR5MA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-apfFdg8GMAOcmzpYLa4Hbg-1; Mon, 23 Mar 2020 11:47:54 -0400
X-MC-Unique: apfFdg8GMAOcmzpYLa4Hbg-1
Received: by mail-wr1-f70.google.com with SMTP id b11so7535081wru.21
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 08:47:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dvBlRRLg3CjMYlQe8Gy70l16tflLAU7l7Cy4EhgrGo0=;
        b=e74+UugVxP+XFX6BSqE5XzuH3MdQjCZrBY/VLZ7dtLZHHra+rv9XOO9lhRC5prr3ej
         fSUO4uL0w4IdF5fs2dZfvo9aRrq+ygaZKVOJen7OE+ODPnd0sX9udxszugkStw0hU6+R
         5rc2eSBYHTDX5joo9QnCSDJGTVmFKiPsIrhJUyU+8sl+9yAYhqKkH8fxml07g2y7Xbos
         CJMWLPaenPAhyWUTd1c6mt8uTb08opJMMZV6Yiz8J/MXdWwN1/tNQ0vCzDPHaiGwEt2Q
         Uq0IW/QW+isJp5FKB858eE8/oNjVbCkFPMLbvapRZ7VbTP/FZucxIurpb8BztV5g1dIb
         y4Fg==
X-Gm-Message-State: ANhLgQ1GEMp9A/4RPcIu2as77BbfwJogYDcooAfcilchIxMf7EFSObDD
        6SYPAjdLVuR2/GoowwdKRa2h2+jOieRYf+fsokv6EMprj80kk7vHXi6GGuxDkywzWIZmARa/SeY
        I4HhfkOawyg/g
X-Received: by 2002:a1c:98c4:: with SMTP id a187mr6825269wme.76.1584978471553;
        Mon, 23 Mar 2020 08:47:51 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vu6SRGI7uUqQOuOD8Xkl9vZIQC4ykzVWdgZrGD/mWxQULS1g06vwwsinh5zxqAoG0+ZZJGMBA==
X-Received: by 2002:a1c:98c4:: with SMTP id a187mr6825239wme.76.1584978471254;
        Mon, 23 Mar 2020 08:47:51 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id h81sm24320939wme.42.2020.03.23.08.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 08:47:50 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 05/37] KVM: x86: Export kvm_propagate_fault() (as kvm_inject_emulated_page_fault)
In-Reply-To: <20200320212833.3507-6-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com> <20200320212833.3507-6-sean.j.christopherson@intel.com>
Date:   Mon, 23 Mar 2020 16:47:49 +0100
Message-ID: <87sghz844a.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Export the page fault propagation helper so that VMX can use it to
> correctly emulate TLB invalidation on page faults in an upcoming patch.
>
> In the (hopefully) not-too-distant future, SGX virtualization will also
> want access to the helper for injecting page faults to the correct level
> (L1 vs. L2) when emulating ENCLS instructions.
>
> Rename the function to kvm_inject_emulated_page_fault() to clarify that
> it is (a) injecting a fault and (b) only for page faults.  WARN if it's
> invoked with an exception other than PF_VECTOR.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 ++
>  arch/x86/kvm/x86.c              | 8 ++++++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9a183e9d4cb1..328b1765ff76 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1447,6 +1447,8 @@ void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
>  void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr);
>  void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
>  void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
> +bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
> +				    struct x86_exception *fault);
>  int kvm_read_guest_page_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  			    gfn_t gfn, void *data, int offset, int len,
>  			    u32 access);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e54c6ad628a8..64ed6e6e2b56 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -611,8 +611,11 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
>  }
>  EXPORT_SYMBOL_GPL(kvm_inject_page_fault);
>  
> -static bool kvm_propagate_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
> +bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
> +				    struct x86_exception *fault)
>  {
> +	WARN_ON_ONCE(fault->vector != PF_VECTOR);
> +
>  	if (mmu_is_nested(vcpu) && !fault->nested_page_fault)
>  		vcpu->arch.nested_mmu.inject_page_fault(vcpu, fault);
>  	else
> @@ -620,6 +623,7 @@ static bool kvm_propagate_fault(struct kvm_vcpu *vcpu, struct x86_exception *fau
>  
>  	return fault->nested_page_fault;
>  }
> +EXPORT_SYMBOL_GPL(kvm_inject_emulated_page_fault);

We don't seem to use the return value a lot, actually,
inject_emulated_exception() seems to be the only one, the rest just call
it without checking the return value. Judging by the new name, I'd guess
that the function returns whether it was able to inject the exception or
not but this doesn't seem to be the case. My suggestion would then be to
make it return 'void' and return 'fault->nested_page_fault' separately
in inject_emulated_exception().

>  
>  void kvm_inject_nmi(struct kvm_vcpu *vcpu)
>  {
> @@ -6373,7 +6377,7 @@ static bool inject_emulated_exception(struct kvm_vcpu *vcpu)
>  {
>  	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
>  	if (ctxt->exception.vector == PF_VECTOR)
> -		return kvm_propagate_fault(vcpu, &ctxt->exception);
> +		return kvm_inject_emulated_page_fault(vcpu, &ctxt->exception);
>  
>  	if (ctxt->exception.error_code_valid)
>  		kvm_queue_exception_e(vcpu, ctxt->exception.vector,

With or without the change suggested above,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

