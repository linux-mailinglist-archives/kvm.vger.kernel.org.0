Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E30595539
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 10:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbiHPI25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 04:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiHPI2U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 04:28:20 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DCF3B4E82
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 22:39:41 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id s20-20020a056a001c5400b005349d11961bso1967106pfw.8
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 22:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:reply-to:from:to:cc;
        bh=5FXMIJWyiNLBKv7isDACdrlTPfcFVt1/kas754uym6I=;
        b=By3alq51MEx2vTUSMhobtyxpKV2iPiGa2YROIh4PQEDd/on+32XGR2+0TO97wJCHSq
         6BU06jimkqtjYMqw/qVMXQDLdSUqmEbhMUT9XZemDQuWC2KHcf6CxEYAus7jX/doqhNV
         X0rOivNOjBzFbf8g/kxSrCD/6mgjaAd8UA9oK6+NsZFCRLaUDlCsrrIKmbQf7keeO8Wv
         l995wIU//bUusltc6b/el6Mbn8AFUTiKYUrbhH6Ra+Xjwrz8knxPFgqu5jon3JaDBvR1
         LIGfxevpAIAxy3DQrCRjj3Ldl57uMVnyF2X/r/L3LwItnQfMSah2/xVVzNrCdbKcPTCM
         MRCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:reply-to
         :x-gm-message-state:from:to:cc;
        bh=5FXMIJWyiNLBKv7isDACdrlTPfcFVt1/kas754uym6I=;
        b=jM6IomuL7vNOyQyRVWxOkwNXnxJ90X5vQq+gBArCwpzfD/5Dyxnq5PY3r/zJwZqRVM
         n8O9/mj7QDo1Hs9vZq+P14u8Ln+VTFDvGqateNXkLHegaWcRPedyfISgD5TSt3lwmWmB
         O5C6q8VOTmHDtfOD7ruucmWgC9QxmMi6KMAptF2ONpU3OIegw4WwmA1Zx7ML16fngmIl
         1GSah44oEb5E5fpIEL9GcNV/r0uRvfcGOWeV7xun6nIIm2ybIBbaTn/E796UtcRMH2Cu
         b5ZIheG8lbt38Vt6hD/SEcGTR1BUlJ3omw1zwJ37hnvrWTNaQ9dtoe2Cmgv30rzO7TO5
         7DJA==
X-Gm-Message-State: ACgBeo3bOPG/HjoHgNt9vgXTrqKpXHm2aefzHt63bnYed4u0dv6/T4L/
        QXVvKh5UjAPuKVr2pWsTLuOtoUWCvUk=
X-Google-Smtp-Source: AA6agR4fvcsuGDiHmW5hIjW9AESYx+icySZjbWRvCb9uSfgne0+lIfMXy7LFz6buKQqYkAApxiloc0/w8Jg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7c8c:b0:172:b78:ed9f with SMTP id
 y12-20020a1709027c8c00b001720b78ed9fmr18427096pll.112.1660628381126; Mon, 15
 Aug 2022 22:39:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 16 Aug 2022 05:39:34 +0000
Message-Id: <20220816053937.2477106-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 0/3] KVM: kvm_create_vm() bug fixes and cleanup
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+744e173caec2e1627ee0@syzkaller.appspotmail.com,
        Oliver Upton <oliver.upton@linux.dev>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix two (embarassing) bugs in kvm_create_vm() where KVM fails to properly
unwind VM creation, which most often manifests as a not-present page fault
due to use-after-free when walking the global vm_list (VM is added and
freed, but never removed from the list).  Patch 3 is a loosely related
clean up.

I discovered the try_get_module() bug by inspection[*].  syzkaller found
the debugfs around the same time.

The try_get_module() bug is especially bad/amusing.  The "rmmod --wait"
behavior KVM is trying to handle was removed ~9 years ago...

[*] https://lore.kernel.org/all/YvU+6fdkHaqQiKxp@google.com

Sean Christopherson (3):
  KVM: Properly unwind VM creation if creating debugfs fails
  KVM: Unconditionally get a ref to /dev/kvm module when creating a VM
  KVM: Move coalesced MMIO initialization (back) into kvm_create_vm()

 virt/kvm/kvm_main.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)


base-commit: 19a7cc817a380f7a412d7d76e145e9e2bc47e52f
-- 
2.37.1.595.g718a3a8f04-goog

