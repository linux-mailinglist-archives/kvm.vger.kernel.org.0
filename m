Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F17F569526
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 00:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbiGFWRn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 18:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiGFWRl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 18:17:41 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A73A2B185
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 15:17:40 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id t26-20020a9d775a000000b006168f7563daso12773475otl.2
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 15:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1EMMmqphd91Ju+K/4EV2gpB3SCsQxfnUR4WTRXFnUaw=;
        b=JUAKZLgflnGvGeY8IT6zP5OMaHQ6VMe5txVcGNkWPkN5pW8lnvNe1NeuVhmEOa7le7
         +CTn3Yy1P35wIc/RxOoOX7e5EFrgzZ6N/3dFbKln656S4EK1O2pVJcP/23F0Ia8hvY9/
         8+FE7oy1Igk8AS8hxlWEURY23hpln8UL9PdP8Zta9mpwgCTklHMay6n8UeTbSxAu940m
         5yZg8qnF5+qmTqyRm8V6NP68KoBw+huVP03/30Tg4RfF9i9oBocSxaSxEu7zdLtWK11K
         mfp/qiX/28WzZSheMJhBqXiKnpx3AkF9dVh+IEFM93tYahd7YP3+K3ZASvKhzzJXWG9/
         I9UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1EMMmqphd91Ju+K/4EV2gpB3SCsQxfnUR4WTRXFnUaw=;
        b=Z24XFMEZGukMTGGCPgl4Ir6AtX9LO3cMvvql2aPgd1v4f7CM2vpmf8MLzkKZrL2XIJ
         x7DpQgmj7gejjAKb7lT06UH4LsK2ySyfOE7nax7Fu6EfKpmnpoxc2QZCU4lOVsKWvR5y
         zxVFdhJSfR4A2R7GckyBPGSt/PbVdcveOaYU2B+90zyvNFoajiVi9xtA2Q8enk2yuocX
         VuO02WqgTjr3vx5icR71pfw5TktllaZxxmoeRMhQaSKtEkFXQyJgYSF8KegDvU1AsBeE
         MjjJn+dERDPyfTT6jSUVFpqnsdDfrrGLoFn48LhbHb3D1xFiST7kMEGLUjT+AZtZZPyU
         Bdkg==
X-Gm-Message-State: AJIora8JZO41DK1IUaEGrNHpvKgmKm5yqzI2XZxiFLdeNKusW8hSeVDG
        fv5uO6hkLdG7ve2M8//I7HUJIGBCLDGwqvKRidGiRQ==
X-Google-Smtp-Source: AGRyM1viMzcYHYxWXxBukv/4+pwjZlKWOv7GADlAvy/iHMvt/m9eaoK6woLeA+AiCgYd3MktCPiMnYzCuKkAekLu8IM=
X-Received: by 2002:a05:6830:14:b0:616:dcbd:e53e with SMTP id
 c20-20020a056830001400b00616dcbde53emr17979803otp.267.1657145859328; Wed, 06
 Jul 2022 15:17:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220614204730.3359543-1-seanjc@google.com> <20220614204730.3359543-4-seanjc@google.com>
In-Reply-To: <20220614204730.3359543-4-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 6 Jul 2022 15:17:28 -0700
Message-ID: <CALMp9eTEkt5nGZDT1qnn1sD5Ft_O_keKomDDiyeWLcPo2Xap7A@mail.gmail.com>
Subject: Re: [PATCH v2 03/21] KVM: x86: Don't check for code breakpoints when
 emulating on exception
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
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

On Tue, Jun 14, 2022 at 1:47 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Don't check for code breakpoints during instruction emulation if the
> emulation was triggered by exception interception.  Code breakpoints are
> the highest priority fault-like exception, and KVM only emulates on
> exceptions that are fault-like.  Thus, if hardware signaled a different
> exception, then the vCPU is already passed the stage of checking for
> hardware breakpoints.
>
> This is likely a glorified nop in terms of functionality, and is more for
> clarification and is technically an optimization.  Intel's SDM explicitly
> states vmcs.GUEST_RFLAGS.RF on exception interception is the same as the
> value that would have been saved on the stack had the exception not been
> intercepted, i.e. will be '1' due to all fault-like exceptions setting RF
> to '1'.  AMD says "guest state saved ... is the processor state as of the
> moment the intercept triggers", but that begs the question, "when does
> the intercept trigger?".

IIRC, AMD does not prematurely clobber EFLAGS.RF on an intercepted exception.

This is actually a big deal with shadow paging. On Intel, the
hypervisor can't fully squash a #PF and restart the guest instruction
after filling in the shadow page table entry...not easily, anyway.

(OTOH, AMD does prematurely clobber DR6 and DR7 on an intercepted #DB.
So, no one should be celebrating!)
