Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91AFB57EA5F
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 01:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236408AbiGVXls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 19:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236332AbiGVXlr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 19:41:47 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BFCA9B93
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 16:41:46 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id l14-20020a17090a72ce00b001f20ed3c55dso5411563pjk.5
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 16:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=cAsBcLqW/j10OPe10nECHhYviVbD1h1TXA0nTgOdmqs=;
        b=C61i6+fG5SVbtUyJgdugCrOYXfNPORT+bMCi3jhy3CJPRst5DCeQAgv3YS6YDHyrbx
         CM6Vdi8x3GdL9SdtB5jEt8pcevCTHNC8LCwFzLAdp3iFXxPAB5OBDgGtHOmMvLqnRUYk
         f04ZpJCCojLFyTi+ODrur/jN0m3+2uhQnu4DGt6dnx5Raos1faX5JoSvvgDA60KK/Snz
         3BcL+rH1alPvmtKtKMRh9e6NxT+jU59lt/PpXqjYi8eqpcCJS7Km3MxW2so3s9ZuGzSy
         9BuAjA6s4y9JAdSZibrgmaLVfsBW44BKvbusfizAC2Qiz18vqvBbPzDtl23viSnurAkr
         SSgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=cAsBcLqW/j10OPe10nECHhYviVbD1h1TXA0nTgOdmqs=;
        b=vzNo6tgveRSBzkxKFQoNch0T1Xhp66aE+f457+MRmWfnzn8gCh3HkLLqi2coOXWhW5
         H/7X0g6bO4qZ6nvrPT97ii8dTkFhFTD4rotg00TVzKeGiG5VDoP32eB1TyFNYX0CJrCd
         svN6ap2GMRk3smh7XwRKKtMFTzoCbWXJnvPhFTFAKmppB3wPCV44kDQxqRjh4guKxwqU
         NcYEF0HYByjUgHsERqZ+AkGQgvhfOyq28QMozAC02pBMhTd6JPFgEcEBu+vcC8VTJ/KV
         gOY64DzsqpjDsFzIWk/qvzP4kZr7FLzAXBSV2veyfwXRcRoZtgR9xLyj/FQgOHEu8gtV
         W83A==
X-Gm-Message-State: AJIora8boXrNGpL3X4S5xa3iKSyw8z8LQHq/uh6a8ttOskBfjbjRWr5T
        QEWoOHn6YYrNybSD7rALRWJnjQf69U7Hww==
X-Google-Smtp-Source: AGRyM1sPwCGTWigi08or9T0Rgi8HbUKCEiny/H3q4FyAL/Rub3pvp1ZQoiSIt9IlfP4WKXTmWhvjew==
X-Received: by 2002:a17:903:32c2:b0:16c:3c8d:3807 with SMTP id i2-20020a17090332c200b0016c3c8d3807mr2151575plr.173.1658533305818;
        Fri, 22 Jul 2022 16:41:45 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id b2-20020a170903228200b0015ee60ef65bsm4368264plh.260.2022.07.22.16.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 16:41:45 -0700 (PDT)
Date:   Fri, 22 Jul 2022 23:41:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrei Vagin <avagin@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jianfeng Tan <henry.tjf@antfin.com>,
        Adin Scannell <ascannell@google.com>,
        Konstantin Bogomolov <bogomolov@google.com>,
        Etienne Perot <eperot@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/5] KVM/x86: add a new hypercall to execute host system
Message-ID: <Yts1tUfPxdPH5XGs@google.com>
References: <20220722230241.1944655-1-avagin@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220722230241.1944655-1-avagin@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+x86 maintainers, patch 1 most definitely needs acceptance from folks beyond KVM.

On Fri, Jul 22, 2022, Andrei Vagin wrote:
> Another option is the KVM platform. In this case, the Sentry (gVisor
> kernel) can run in a guest ring0 and create/manage multiple address
> spaces. Its performance is much better than the ptrace one, but it is
> still not great compared with the native performance. This change
> optimizes the most critical part, which is the syscall overhead.

What exactly is the source of the syscall overhead, and what alternatives have
been explored?  Making arbitrary syscalls from within KVM is mildly terrifying.

> The idea of using vmcall to execute system calls isn’t new. Two large users
> of gVisor (Google and AntFinacial) have out-of-tree code to implement such
> hypercalls.
>
> In the Google kernel, we have a kvm-like subsystem designed especially
> for gVisor. This change is the first step of integrating it into the KVM
> code base and making it available to all Linux users.

Can you please lay out the complete set of changes that you will be proposing?
Doesn't have to be gory details, but at a minimum there needs to be a high level
description that very clearly defines the scope of what changes you want to make
and what the end result will look like.

It's practically impossible to review this series without first understanding the
bigger picture, e.g. if KVM_HC_HOST_SYSCALL is ultimately useless without the other
bits you plan to upstream, then merging it without a high level of confidence that
the other bits are acceptable is a bad idea since it commits KVM to supporting
unused ABI.
