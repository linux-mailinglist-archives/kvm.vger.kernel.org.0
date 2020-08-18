Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7894248CAB
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 19:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgHRRO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 13:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbgHRROx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 13:14:53 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017F3C061389
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 10:14:53 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id l84so18545528oig.10
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 10:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wLSk1hD5x0b5ZJUN9D3Cg3DfYbJfyYbM3G81BYYFQKo=;
        b=NPoGE5tUdBrIJBQksCkBv0tPeUHDQRhSR88FZmTNzpbfTtbrRQpIKVQa+8I8XmsdfE
         namhSoNBJ3LhM15FzlcIxdGUojHZ+ViCdL6kl3lwvlRcGeU6jSBz0abQHX37zaaflUBE
         rvkyeS4+tBI1gAbYeswwdm2OWt9kZLkAPDTyBtZ7U2ov4TUjl5N1Sxg412i9kJ3pPwyi
         k52UuEovr48fyByhXbLnH9/HRXZPu/Hn1OCsJwSxHEFgQFGU7Ibx0+iQrbsTgPQB+6oN
         l6xJvb9bbXqHscpjel1yJ2wzqm2PJowxqSi1fxUCdtbcOvYZJ0kN+Ob70E2pWCycMOjO
         ImLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wLSk1hD5x0b5ZJUN9D3Cg3DfYbJfyYbM3G81BYYFQKo=;
        b=r78HdgjDsXVLZPgmbt+ifTBfsU1utsIUhIZLre9HbdcNq+aOnn22iTgJ3HUsrBMAvD
         yMZegikjRXBgleqOZwn65svZIrCwP8c6otW5ePmtSxRWAhLAwS6JfxeS4fyel0jnPWJJ
         fKeHcsxDIUaYOB3xSXbf8oxebVfcAXWTgIRej029QJzchWWLm0MlRdeUA5/rL83ki9cH
         ZViCcCY+RGTimuPM5YJLwn3gCQyJ8ro0DyWxhz9zzlP0NHEjGX8nFLXVxzhXWkryEhT2
         1bSctjethd0g2pFPPfZiVhCMCqJEYm7ipHr2Fc4NlDbVkzdxOezV+whYxefMD8+hhFRF
         vVHg==
X-Gm-Message-State: AOAM531A1TOnfD0OPosGXV3Eb1Re6QdrdHIWxesJPTIrccBHygzjM9xw
        VFpsDtK5jKAPoxUERa8L2qbh+mO4QjUGpxC5+t6IKw==
X-Google-Smtp-Source: ABdhPJwqVlfdnsPMs2BhFGJmHLxP6lIYCdQr4TMKMKAQfon8w/FZ5n1e3XAcrNxc1W/QLoFXufiY0TO7wk+M9IHr36Y=
X-Received: by 2002:aca:670b:: with SMTP id z11mr731427oix.6.1597770890340;
 Tue, 18 Aug 2020 10:14:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200818004314.216856-1-pshier@google.com> <20200818152048.GA15390@linux.intel.com>
In-Reply-To: <20200818152048.GA15390@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 18 Aug 2020 10:14:39 -0700
Message-ID: <CALMp9eS5UOPGF0v2vt9aMPEZT7_a6ruJx9n_DLKkjiEb_kCWag@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Update VMCS02 when L2 PAE PDPTE updates detected
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Peter Shier <pshier@google.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 18, 2020 at 8:20 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:

> I'd prefer to handle this on the switch from L2->L1.  It avoids adding a
> kvm_x86_ops and yet another sequence of four VMWRITEs, e.g. I think this
> will do the trick.
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 9c74a732b08d..67465f0ca1b9 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4356,6 +4356,9 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
>         if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
>                 kvm_vcpu_flush_tlb_current(vcpu);
>
> +       if (enable_ept && is_pae_paging(vcpu))
> +               ept_load_pdptrs(vcpu);
> +

Are the mmu->pdptrs[] guaranteed to be valid at this point? If L2 has
PAE paging enabled, and it has modified CR3 without a VM-exit, where
are the current PDPTE values read from the vmcs02 into mmu->pdptrs[]?
