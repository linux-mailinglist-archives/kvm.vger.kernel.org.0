Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9507C6D70DC
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 01:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236552AbjDDXo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 19:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjDDXo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 19:44:27 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4119C1BFC
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 16:44:26 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id f6-20020a170902ce8600b001a25ae310a9so14443866plg.10
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 16:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680651866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1RtBEBKe4cc1n2k+4f6iP8Gi/6GJTf7g8CUK0JvY99E=;
        b=ZVQOi8EMQ70xTg1fO5Td6o4KuLOz2xcmCaCBLRplPUFXNQcLP+4v4x5+MZoTxOgECI
         DspOjAWW4WGncjvAcfhYdgUaXrpfvpyG8DBe6SmYLmHmq6HNZdWn6f178c/ZwaNnKxKr
         ey0Ve46m8oIPfSKz22s05A5ZMrGZqWy77uJ58Ls6hxuRgs57gA/a2W1PsojQiBpA8vyE
         pYqWkWuKoRIUEUnCnPRR9BT+KPw2meoe1SfjvIxQhmmCVSUvQQD/X1WY8LfiNuRCAvhG
         f26O+SpdUatdKiyYTK8roZt9Ydk722PPiqV5prwO73gL0cbfnY1UcxOdNDVnpirjAjbO
         +RUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680651866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1RtBEBKe4cc1n2k+4f6iP8Gi/6GJTf7g8CUK0JvY99E=;
        b=Pxmm6yRqA1RK+74JBwAg5OZ5kcDGrO6jVEdnMC5yoLp4Pm2TsFy1SPzL3L4fLKIKOZ
         /a7wxcQk69JIC3aEfkXN1DPJ8dAG0grl6jxYgQ8DPQNXXXBB0loZfwz+GMa0ZGGDiITa
         gc/q9YGKnWBbAWJpfypo5cZTgsiDtDtXpiP6gEPazklUx52H2gHJAtFVAjNcn2lhHjwd
         P6GhgBiFVuuqdcatMhOcJgxnbrWO/RpO9KCDk0l56fNJxAhG/f1U6J6a9dBhLNeh/nIg
         O4P6x5ahW/6TxKR3T9M/Hr09NWdsxwV/bJwlvwBTRU+ehzroHgJCg1fxBzSw40lSdOxA
         AqFg==
X-Gm-Message-State: AAQBX9fXeln5RT9HPtcIvtDuK+ytUJK4y8qACfu44gEqPuAu1BTdH296
        tMK4xtRttG22w00y9adhH6DQFT3aNPE=
X-Google-Smtp-Source: AKy350Yos/Jvaj0BlByT/1Vz1NrDYtP0Og9A1Jb2uwUiwZZkmC3Ib7J4KEdxuxeL1m4N6b6LPWZzn9X1BF0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:a88:b0:237:1fe0:b151 with SMTP id
 8-20020a17090a0a8800b002371fe0b151mr1558403pjw.8.1680651865788; Tue, 04 Apr
 2023 16:44:25 -0700 (PDT)
Date:   Tue,  4 Apr 2023 16:43:40 -0700
In-Reply-To: <20230403095200.1391782-1-korantwork@gmail.com>
Mime-Version: 1.0
References: <20230403095200.1391782-1-korantwork@gmail.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <168063175075.174995.217166777153935864.b4-ty@google.com>
Subject: Re: [PATCH REBASED] KVM: x86: SVM: Fix one redefine issue about VMCB_AVIC_APIC_BAR_MASK
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, mlevitsk@redhat.com,
        korantwork@gmail.com
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Xinghui Li <korantli@tencent.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 03 Apr 2023 17:52:00 +0800, korantwork@gmail.com wrote:
> VMCB_AVIC_APIC_BAR_MASK is defined twice with the same value in svm.h,
> which is meaningless. Delete the duplicate one.

Applied to kvm-x86 svm, thanks!

In the future, please don't use "PATCH REBASED".  If you're sending a new
version of a patch that's been rebased, then the revision number needs to be
bumped.  The fact that the only change is that the patch was rebased isn't
relevant as far as versioning is concerned, it's still a new version.  The
cover letter and/or ignored part of the patch is where the delta between
versions should be captured.

And in this case, there really was no need to send a new version, the original
patch still applies cleanly.  I suspect that the REBASED version was sent as a
form of a ping, which again is not the right way to ping a patch/series.  If you
want to ping, please reply to the original patch.  Unnecessarily sending new
versions means more patches to sort through, i.e. makes maintainers lives harder,
not easier.

[1/1] KVM: x86: SVM: Fix one redefine issue about VMCB_AVIC_APIC_BAR_MASK
      https://github.com/kvm-x86/linux/commit/c0d0ce9b5a85

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
