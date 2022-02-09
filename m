Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F19174AE70E
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 03:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244931AbiBIClh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 21:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243777AbiBIBu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 20:50:57 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF89BC06157B
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 17:50:56 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id i34so1417547lfv.2
        for <kvm@vger.kernel.org>; Tue, 08 Feb 2022 17:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=00ue7mh27A+X6OpqpLZbYpT8mqERta0wmIi5D16JCX4=;
        b=Z1kDYLA9n9TCvwffb62ktmsXygmzX7qqPpuvdIGbKGMYvlUqdx2mESpVKJx6LSyv2z
         Xn6dErF7/FirfOBXiUwl7QDoR+kxtWuuDt+qTPhN+MjamloM9O2kTQk5jpw3VORBcfJr
         +oqWrVVmSv0IWrixiGkx+kXjTpB8lB/LQGAW9V9muzNu9dGOkclIT9X2X9+NR1TxOhaf
         NZ5qJhp4aL0g9Uv63qVuXGReQ1BwTC4+Ok70SCVSZZ8aMeqzZXiZpggQyrrX20UdiePI
         GiMIWfl7+CY6Nu2KjC0QgVZ9o9ehFE6bEAiwFr/8jF4oUOvvjmujBt1mIwRB1ts4zCwX
         /d7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=00ue7mh27A+X6OpqpLZbYpT8mqERta0wmIi5D16JCX4=;
        b=UAeySdYp48rrTBaZBXU/u7M5Pibs546ZvmV8jKqeH1xupBuQDxD7kbMb/k/SOtWp7k
         SLDwpqEtHh1sdK+bcX9PtY2unPDoMGDikaXOdpgtgIOkWV/7nS+B1L6duNx1qzEbuKH6
         zvmCAhiBQll8uhwBTWVs/DsMBYnXbi/iS92jUktcT+oaC4a3jolxFXw0MwBckgVkVbsv
         ObuMPUrR7mrliWqPle9UgraGkKbt7nsonK56SOIITWhVafCG/+c67E6jn7Gk1l4Q/3nK
         qrZk19dTwGLNHbVVQGHXj3krDdrQYTo7rpidTiVFIJkteFWWCy/RY+g2yfXinRZYeh+k
         pHcA==
X-Gm-Message-State: AOAM531dVMk99Gb1GfmhEwxIoU3nzOz146L9OQ37fcpbLTd3VBJmyp8F
        zazz6wQIGp424Z3LOBdhZBc5iSSTBplzg9P4hC+NtQ==
X-Google-Smtp-Source: ABdhPJzjP/mX8v49D2BVaQ40Tvn2n/uO/MYQfZkS/pIrLRxnLNH/8s5J3EeeZX9c4sxbWkGUfeTsRRGDtbKQSuR7WM8=
X-Received: by 2002:ac2:4951:: with SMTP id o17mr4759190lfi.553.1644371454915;
 Tue, 08 Feb 2022 17:50:54 -0800 (PST)
MIME-Version: 1.0
References: <20220204204705.3538240-1-oupton@google.com> <20220204204705.3538240-5-oupton@google.com>
 <YgFfpTk/woy75TVj@google.com>
In-Reply-To: <YgFfpTk/woy75TVj@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 8 Feb 2022 17:50:43 -0800
Message-ID: <CAOQ_QshC=DKZNQ1OVjtx19nw3+ET46fmCVnU+VQFHUBQ3vgFqw@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] KVM: nVMX: Add a quirk for KVM tweaks to VMX
 control MSRs
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
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

On Mon, Feb 7, 2022 at 10:06 AM Sean Christopherson <seanjc@google.com> wrote:

[...]

> > +#define KVM_X86_QUIRK_TWEAK_VMX_CTRL_MSRS    (1 << 5)
>
> I'd prefer we include msr_ia32_feature_control_valid_bits in this quirk, it should
> be relatively easy to do since most of the modifications stem from
> vmx_vcpu_after_set_cpuid().  vmx_setup_mce() is a bit odd, but IMO it's worth
> excising as much crud as we can.
>

Sure, this is a good opportunity to rip out the crud.
msr_ia32_feature_control_valid_bits is a bit messy, since the default
value does not contain all the bits we support. At least with
IA32_VM_TRUE_{ENTRY,EXIT}_CTLS we slim down the hardware values to get
the default value.

Not at all objecting, but it looks like we will need to populate some
bits in the default value of the IA32_FEAT_CTL mask, otherwise with
the quirk enabled guests could never set any of the bits in the MSR.

> >  #define KVM_STATE_NESTED_FORMAT_VMX  0
> >  #define KVM_STATE_NESTED_FORMAT_SVM  1
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 395787b7e7ac..60b1b76782e1 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7231,6 +7231,9 @@ void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
> >  {
> >       struct vcpu_vmx *vmx = to_vmx(vcpu);
> >
> > +     if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_TWEAK_VMX_CTRL_MSRS))
> > +             return;
>
>
> Probably worth calling out that nested_vmx_cr_fixed1_bits_update() is intentionally
> exempt from this "rule":

Agreed.

--
Thanks,
Oliver
