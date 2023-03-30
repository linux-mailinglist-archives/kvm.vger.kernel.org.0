Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A496D1016
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 22:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjC3Ugy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 16:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjC3Ugx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 16:36:53 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E158BDC9
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 13:36:50 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5461fe3163eso68929667b3.17
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 13:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680208610;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mOc7QRI6vr/NyUwVE8LrJGTxRHHh12pQ+l4hg/ojUak=;
        b=CuDmFhCvr0zPB3egM6QVXPV+kb1rCQk4waPaW8HcA/YcVDkIBmaxoUoM/azrL5uBCB
         +NIu/AaJ8ehmg2VLpGBRo1JNzcRsY/gmYMRVn5aJIHtobAkDfBl7KHWG7y614WQExjAL
         VSUY2I+esDiUzHQh+NaNjkqfQG9nMcrhhvmuLyO7sxJ7RDTbUAR0TzYsHi9LsZswmjYo
         wG+LjNbiXyHZdv+P1RQfUIoZfYK55CXwLSr3YPa+GuDmO0uxay1jpoV4lXQDz23A7DLB
         JkHOocAAZnIRKGG/SOAduJk9CVwC/etLAicmQ/4e4BxRxt9Yo1Lnbf/2J1AomClN90Kb
         9RLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680208610;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mOc7QRI6vr/NyUwVE8LrJGTxRHHh12pQ+l4hg/ojUak=;
        b=TbgPig3BPP+SvujjuuI+ps+dYT8I8jgkKTc+HPTgHS5/EcVm4B75ETjaSspfyovQnr
         galGrwgwqdXd7uJfC3HLgEecHf7hrmCL+EB/0dD5zq9I+yLv2+dxKbT7LaybINrxFTTI
         RvTAUqHra9Gvi1peA23OduaQCKDFm32zs6YVDD85nMCjlNuDATmFmlxf0UOVeS1qIw5O
         y7gGTkKtUrzfPP1mG5dDIJMjAthAaZAnBG69b8dLvL9aL9FWPXA4aREQEW94XGW20uQc
         zQ9JDuKHABvZL5DQ4HNr0GHCyIvZ+jsQonXk3kWPJCJenyXNr0MX/ZijwdJrGwFJKPzP
         CCrg==
X-Gm-Message-State: AAQBX9f52Qf3ruG9Lgzjyqkjp91CCdnEeZul0sNr6advjBPK6WAULMF7
        DGC/UdUsfZatwo38KJ+b49iZ7/p7SCg=
X-Google-Smtp-Source: AKy350ZC4xNLPfjro8E/mq7a/h4oXBOsuypI9FopH8pKq1uWXOABjSIGdkBerKGHAzyMScx9hS+mUmp93Gw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:7403:0:b0:b7e:6118:348 with SMTP id
 p3-20020a257403000000b00b7e61180348mr4415064ybc.0.1680208609862; Thu, 30 Mar
 2023 13:36:49 -0700 (PDT)
Date:   Thu, 30 Mar 2023 13:36:48 -0700
In-Reply-To: <4c5f4f61-a8d1-a707-8100-e095d3b18398@grsecurity.net>
Mime-Version: 1.0
References: <20230322013731.102955-1-minipli@grsecurity.net>
 <20230322013731.102955-7-minipli@grsecurity.net> <677169b4-051f-fcae-756b-9a3e1bb9f8fe@grsecurity.net>
 <ZCXDAiUOnsL3fRBj@google.com> <ea3a8fbc-2bf8-7442-e498-3e5818384c83@grsecurity.net>
 <4c5f4f61-a8d1-a707-8100-e095d3b18398@grsecurity.net>
Message-ID: <ZCXy4C+eauDBgk37@google.com>
Subject: Re: [PATCH v4 6/6] KVM: VMX: Make CR0.WP a guest owned bit
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023, Mathias Krause wrote:
> On 30.03.23 22:15, Mathias Krause wrote:
> > [...]
> > Maybe it's not a stale CR0 value but the page table walker not taking
> > the guest's CR0.WP into account? Maybe a missing role update?
> 
> Indeed, it is. This does the trick for me:
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 31be188aa842..6a9e90725c84 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8372,6 +8372,9 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
> 
>         init_decode_cache(ctxt);
>         vcpu->arch.emulate_regs_need_sync_from_vcpu = false;
> +       /* Ensure we're doing page table walks with an up2date MMU role */
> +       if ((vcpu->arch.cr0 ^ kvm_read_cr0(vcpu)) == X86_CR0_WP)
> +               kvm_init_mmu(vcpu);
>  }
> 
>  void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
> 
> Very heavy weight and misplaced, but a start :)
> 
> It should (1) be limited to VMX as that's the only one that would make
> CR0.WP a guest owned bit and (2) limited to emulated instructions that
> actually do write operations, as read are harmless, obviously.

For the record, I wrote my email before I saw this ;-)
