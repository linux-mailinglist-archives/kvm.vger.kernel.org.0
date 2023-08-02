Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501B576D945
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 23:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbjHBVMW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 17:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbjHBVMV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 17:12:21 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30762D63
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 14:12:16 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-583f048985bso1924317b3.2
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 14:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691010736; x=1691615536;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b4xwn51MMH8/TD8NmBb03SZ933wh4CAq63jVKlR8R6E=;
        b=adiOeSOfgg/U4kqaO2lDm7chOOMJ5lu5UPbD90dnVdCbAoFiid2/fbQrPLcy1T+hNB
         az/Mul7JqrX4Ny7Xp1KwmsOMb0IAfw/omvcryflYy/J/8x3c0t5yT6LJTHPQ4B29V8xs
         FRE1JnTzB4di/0H8T5JWXYJImtmwt83S1JIoHA7y+cy/VLzG3EeOmgCjWrE5gXHml1iN
         J9+7oKFVoIRztxdw7zS6U8YB8PZ6eFN7lV0HV9jSYxjwapMMzXvfgJLCJdo7QPVwwYLa
         kysftkrJTLlvGmaF8Yv/DprGZZoDTWOBG1k1+BF6hbbpOvh0DZzqUB0ipLXlzCUysESw
         70bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691010736; x=1691615536;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b4xwn51MMH8/TD8NmBb03SZ933wh4CAq63jVKlR8R6E=;
        b=P0YXAztn6jJP3Hsg1j1e+zKSHKy/+LwEt3ciBp4ClfkEvB/Aj1+WLsSKtMSSik9lMi
         5fGAk/bKB3vU6AKQ1UrXTgcywvotVIcacjQjT8K/AP09o6uJZTSNj/5pXGHKbRDZtDAm
         WZuxQxnyvfq8C/BvU/kuPrATlTHkZrkT5gnUGdToIlGN0KpAWPof0pt/0kzyFcam3Bky
         8m2lRo5xJu3Gv1eRHGl+a6JhuaGAga8mn7aZVUon654nJuGn84wnF3u9UpZQjUJg/TQ9
         ZgwB+mmoXCGif0yMoqTsz8bBqa+8YV+h6LqFVHY3o58ateITmCQi74HjJpN/fx2nb0dA
         Strg==
X-Gm-Message-State: ABy/qLaDZ0zY6osUFcR+rhMIOVNfGRxpl7IcE35EhoDNcWKBdn+8Vjav
        5ZkkgznBxgzckStAfHVs9bNcwk0TLGk=
X-Google-Smtp-Source: APBJJlHzyX4fgB3JfvIRdmw/iRu6hNCnQ9E4/kno1yhnb7en5T9kwKr3i0SsoMdKySzgGu+J9wfDG2bj8J4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:af0e:0:b0:56d:1b6:5360 with SMTP id
 n14-20020a81af0e000000b0056d01b65360mr152930ywh.5.1691010735839; Wed, 02 Aug
 2023 14:12:15 -0700 (PDT)
Date:   Wed,  2 Aug 2023 14:11:51 -0700
In-Reply-To: <20230728001606.2275586-1-mhal@rbox.co>
Mime-Version: 1.0
References: <20230728001606.2275586-1-mhal@rbox.co>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <169100872740.1737125.14417847751002571677.b4-ty@google.com>
Subject: Re: [PATCH 0/2] sync_regs() TOCTOU issues
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, shuah@kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 28 Jul 2023 02:12:56 +0200, Michal Luczaj wrote:
> Both __set_sregs() and kvm_vcpu_ioctl_x86_set_vcpu_events() assume they
> have exclusive rights to structs they operate on. While this is true when
> coming from an ioctl handler (caller makes a local copy of user's data),
> sync_regs() breaks this contract; a pointer to a user-modifiable memory
> (vcpu->run->s.regs) is provided. This can lead to a situation when incoming
> data is checked and/or sanitized only to be re-set by a user thread running
> in parallel.
> 
> [...]

Applied to kvm-x86 selftests (there are in-flight reworks for selftests
that will conflict, and I didn't want to split the testcases from the fix).

As mentioned in my reply to patch 2, I split up the selftests patch and
massaged things a bit.  Please holler if you disagree with any of the
changes.

Thanks much!

[1/4] KVM: x86: Fix KVM_CAP_SYNC_REGS's sync_regs() TOCTOU issues
      https://github.com/kvm-x86/linux/commit/0d033770d43a
[2/4] KVM: selftests: Extend x86's sync_regs_test to check for CR4 races
      https://github.com/kvm-x86/linux/commit/ae895cbe613a
[3/4] KVM: selftests: Extend x86's sync_regs_test to check for event vector races
      https://github.com/kvm-x86/linux/commit/60c4063b4752
[4/4] KVM: selftests: Extend x86's sync_regs_test to check for exception races
      https://github.com/kvm-x86/linux/commit/0de704d2d6c8

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
