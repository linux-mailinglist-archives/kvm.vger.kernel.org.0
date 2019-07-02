Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCCC5D46F
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 18:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfGBQjb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 12:39:31 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:35611 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbfGBQja (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 12:39:30 -0400
Received: by mail-io1-f65.google.com with SMTP id m24so38572808ioo.2
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 09:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cJKujP4fkM3z2RD8g5Cwbhd6zL26dOcsHa0bH40LmNQ=;
        b=Eb5/A+Rsp6mvOjKb1VDybsOmEm5JhKIyMZG0BUXzXpckh4kpfVbcqTl9x/IR0BDNGE
         Xd3OdFDiNSSo216z/VfeWXTnTY2lfZTsoY74m3aweU9GRTVu1di6pzvjm8vUn+PYN27/
         gLz8qBDPP9lYqO2uznXig6mgNakHnBi6iOU4rEPPZSrk9riBC5zivncswET7AzYV+aqW
         x9sepQTTQVR/jtj6v7GVFAIqBEtB7Pl4juUhCPPTTPdn3DNdVsnXZcdUTb7C28mdTsfX
         MHDuaET+tmXRNbg7ITs+S3Hr1xsGZ5Tkuyz9n4XfF331rE4wUbMTufzr+6Ib/6jR2+62
         ojRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cJKujP4fkM3z2RD8g5Cwbhd6zL26dOcsHa0bH40LmNQ=;
        b=nzOGRG3zxuUkT1oAicgbMaS9gG9ctZTLV7DpdAPGA/bnPOrsoo2SLr5OyPmWokYs86
         NXp8zb74AKAjcf18lPRhiEzJQn01qAS7/0J/pFC2VYWv8KZVucb/BwzOwZ2zBYOEJMbC
         kO6s2mOE/4AoDtmTZbSDNw+Q6Mer37sxClmjNQEjPtx/ixSrux1pEmQR+1gB26pubEgT
         qcK4vrg+y2K8kmxevPiMR9TGT0A/LF2KHoyS1yD8fMu/NKPRF/9eZ65e0l8KEThkrPK7
         fw7cDEdojbx++G3CMpDcld2s+oa/qSeeEcpWCljodjGFaXhjNOs/IISJPO+nl+tr4tcp
         I27g==
X-Gm-Message-State: APjAAAUozthMoHY6Krc332zflWQjBvlskRUgp9RGSfDymxXC2hVLcxv9
        lhoFnODsTqYdlR36lEA++vlG5E+VeAggKakO4Cll6HgO
X-Google-Smtp-Source: APXvYqzy2Ae7R1BoOpMWCkUcy8MxPE79laybLlT2s/2EzaUn1+cV9fZb6XylHdhwCCrHzcBTawPmq3BLRJC2SqhrOnA=
X-Received: by 2002:a5e:8508:: with SMTP id i8mr2877980ioj.108.1562085569425;
 Tue, 02 Jul 2019 09:39:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190613161608.120838-1-jmattson@google.com>
In-Reply-To: <20190613161608.120838-1-jmattson@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 2 Jul 2019 09:39:18 -0700
Message-ID: <CALMp9eRRnpywexfc78Mb=VR7OyLCjUKe_zJ8aBGqJoc5DzDDAA@mail.gmail.com>
Subject: Re: [PATCH] kvm: nVMX: Remove unnecessary sync_roots from handle_invept
To:     kvm list <kvm@vger.kernel.org>
Cc:     Junaid Shahid <junaids@google.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 13, 2019 at 9:16 AM Jim Mattson <jmattson@google.com> wrote:
>
> When L0 is executing handle_invept(), the TDP MMU is active. Emulating
> an L1 INVEPT does require synchronizing the appropriate shadow EPT
> root(s), but a call to kvm_mmu_sync_roots in this context won't do
> that. Similarly, the hardware TLB and paging-structure-cache entries
> associated with the appropriate shadow EPT root(s) must be flushed,
> but requesting a TLB_FLUSH from this context won't do that either.
>
> How did this ever work? KVM always does a sync_roots and TLB flush (in
> the correct context) when transitioning from L1 to L2. That isn't the
> best choice for nested VM performance, but it effectively papers over
> the mistakes here.
>
> Remove the unnecessary operations and leave a comment to try to do
> better in the future.
>
> Reported-by: Junaid Shahid <junaids@google.com>
> Fixes: bfd0a56b90005f ("nEPT: Nested INVEPT")
> Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> Cc: Nadav Har'El <nyh@il.ibm.com>
> Cc: Jun Nakajima <jun.nakajima@intel.com>
> Cc: Xinhao Xu <xinhao.xu@intel.com>
> Cc: Yang Zhang <yang.z.zhang@Intel.com>
> Cc: Gleb Natapov <gleb@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by Peter Shier <pshier@google.com>
> Reviewed-by: Junaid Shahid <junaids@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 1032f068f0b9..35621e73e726 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4670,13 +4670,11 @@ static int handle_invept(struct kvm_vcpu *vcpu)
>
>         switch (type) {
>         case VMX_EPT_EXTENT_GLOBAL:
> +       case VMX_EPT_EXTENT_CONTEXT:
>         /*
> -        * TODO: track mappings and invalidate
> -        * single context requests appropriately
> +        * TODO: Sync the necessary shadow EPT roots here, rather than
> +        * at the next emulated VM-entry.
>          */
> -       case VMX_EPT_EXTENT_CONTEXT:
> -               kvm_mmu_sync_roots(vcpu);
> -               kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
>                 break;
>         default:
>                 BUG_ON(1);
> --
> 2.22.0.rc2.383.gf4fbbf30c2-goog
>

Ping.
