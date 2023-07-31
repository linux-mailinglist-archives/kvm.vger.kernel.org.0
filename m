Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D727769981
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 16:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjGaOaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 10:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjGaOaE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 10:30:04 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE15CD
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 07:30:03 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bb83eb84e5so48906475ad.1
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 07:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690813802; x=1691418602;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ObUdgROJ4Fh6eGJrzpfR0YhkAzW7v0vw5c8AAWfwu6Y=;
        b=Tk9LoTMTTsEQqNvFWItA11F7gfp/gOQ/YnVlWInA1K44dlehN3cr8tbgER2TDsioQD
         M8EKZjZr+uxZAvdq1pAthJlrk/hQVImPC0csEHGHRru6EtYPWYFaQ1dK9ZYypfOlkYZM
         7OIjHkZVMJra3SF3JYr8YPdSWXFrA8YESyjxZmccUc+UwE9tzenDvdDMhSQdogJ02/9V
         CODm8eN5WRLPtikUqG1VqppGe4N7ikOXJ7q/qqEsdshtoH2o29FkfUssxpWVO2u68lNC
         MRbdwHNMeLCe6r6iXAovuJbi9j/lZYb8wTzl0/MUSRwZ40jvN1IAyn8Za88mB4OVqXi4
         rKsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690813802; x=1691418602;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ObUdgROJ4Fh6eGJrzpfR0YhkAzW7v0vw5c8AAWfwu6Y=;
        b=Jy8kiu8nZb8MlRpyPzv5kZL7ZzCkBjuENWs57mZvKl/lvkhi1xsROSFgRJQ7cQJtdQ
         hXO7QuZLfw3+37RmWKtbs3ngKFfqGNcOMj1YwB6pbz0XWrLw0/PeozXn1RzqGc9VJvOq
         wUWTulVO+Z7Btixicn8wniruc99Z1PcjbhC40p+I8GA6tpkxe7ZymVcLPNAYiU6zeOp3
         /3b609hmWmKwRWufLEZV+/m2qZNRxQnczXY1500x46QvaObfxf3hOqY84jNt4BvGmTDX
         Qa9Cx/JNgW2rooBpXg3RazbAN28ac7NH9Anw6aIWbH3YNj0m5NCUOe3JigKij1Z87xei
         MtYQ==
X-Gm-Message-State: ABy/qLYw8kt88yIY8JkdAfPc1h/ia9Hox/I5ByS5FaRSSI1iyhyeIwrv
        F/8axPOQmuUozTsOgEsYktU4HYda914=
X-Google-Smtp-Source: APBJJlFJCgvQUS3lYgpzxhrJr8+EP6qWlgqSSdZQQWXDlb76ZJKxLdFvbGJeFc6OC4VTdbe4FKDPaZCJ5V8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ce84:b0:1b8:2cee:946b with SMTP id
 f4-20020a170902ce8400b001b82cee946bmr43357plg.11.1690813802190; Mon, 31 Jul
 2023 07:30:02 -0700 (PDT)
Date:   Mon, 31 Jul 2023 07:30:00 -0700
In-Reply-To: <8eb933fd-2cf3-d7a9-32fe-2a1d82eac42a@mail.ustc.edu.cn>
Mime-Version: 1.0
References: <8eb933fd-2cf3-d7a9-32fe-2a1d82eac42a@mail.ustc.edu.cn>
Message-ID: <ZMfFaF2M6Vrh/QdW@google.com>
Subject: Re: [Question] int3 instruction generates a #UD in SEV VM
From:   Sean Christopherson <seanjc@google.com>
To:     wuzongyong <wuzongyo@mail.ustc.edu.cn>
Cc:     linux-kernel@vger.kernel.org, thomas.lendacky@amd.com,
        kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 29, 2023, wuzongyong wrote:
> Hi,
> I am writing a firmware in Rust to support SEV based on project td-shim[1].
> But when I create a SEV VM (just SEV, no SEV-ES and no SEV-SNP) with the firmware,
> the linux kernel crashed because the int3 instruction in int3_selftest() cause a
> #UD.

...

> BTW, if a create a normal VM without SEV by qemu & OVMF, the int3 instruction always generates a
> #BP.
> So I am confused now about the behaviour of int3 instruction, could anyone help to explain the behaviour?
> Any suggestion is appreciated!

Have you tried my suggestions from the other thread[*]?

  : > > I'm curious how this happend. I cannot find any condition that would
  : > > cause the int3 instruction generate a #UD according to the AMD's spec.
  : 
  : One possibility is that the value from memory that gets executed diverges from the
  : value that is read out be the #UD handler, e.g. due to patching (doesn't seem to
  : be the case in this test), stale cache/tlb entries, etc.
  : 
  : > > BTW, it worked nomarlly with qemu and ovmf.
  : > 
  : > Does this happen every time you boot the guest with your firmware? What
  : > processor are you running on?
  : 
  : And have you ruled out KVM as the culprit?  I.e. verified that KVM is NOT injecting
  : a #UD.  That obviously shouldn't happen, but it should be easy to check via KVM
  : tracepoints.

[*] https://lore.kernel.org/all/ZMFd5kkehlkIfnBA@google.com
