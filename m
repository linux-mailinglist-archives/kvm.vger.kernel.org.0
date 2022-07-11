Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D016570E4C
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 01:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbiGKX20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 19:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbiGKX2R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 19:28:17 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661028AB1C
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 16:28:16 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id a127-20020a624d85000000b00525950b1feeso1440905pfb.0
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 16:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=l1YVI1jymWKPwtQYaErfNq6OCrckplvwfXfah/8A/rc=;
        b=SVmaSc+lEZoy1vyMnxQkmZX7Wb3FG6N+CBqp55C3XwrUZ33I51/VK8pLmMruirVuhl
         z+Mxx1RY+uXt8Nj17/lLRC/NMw6LZlLUmrjDVupkRHj52stwdyergUPLjOnoeiM1Bhw1
         JyUdkak654zIqYhT1QsApidufgOzzlNHcW9pGtbuQKv6mU5pWGmx+dFYm19CXpOpZt9B
         wLFC4Ykc9rohW/Q4YHFEpyMN/CencJi4JOKSdSQkLa5C688mjx8lTKrwZSTGM3FSgAl6
         1+Ppb7K6Dx4e2fPDH3isw/w9weHrROniS6nUzTv8XOEPRLqIXEZf7ES5nhlyAeckGmES
         BMZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=l1YVI1jymWKPwtQYaErfNq6OCrckplvwfXfah/8A/rc=;
        b=H3nzoas07ehim38ck75Rh32NFaU55wPwnhTtI99zGJdfvfutWg7jZwtD9APeWmA05N
         f9UF/sTTCIDe6xF+L1A9ETl/CAGr8lGqfjKQr2xgWNCjImOBSgx5TFTA4fPETz+MD91C
         UBuRtunECc6KgS2v0G+gHDUrrMWEARN2jPCrFsws+M3GxkoBBqB/+EoPOIGxt1CSwUqJ
         5eSEpXgDq4sj5H2GxhChr4U/k+u5YnPr6RiUDJUYsEkfauJ3foTDnmLHKPEuHf6nrJyF
         gk75iq85VR3/MJTLKc5OTg+lrcXM0Su6xeujpffwfDRJatvuQi7gpkt47sSjnXs5ogtd
         vK8w==
X-Gm-Message-State: AJIora9bqitp64z59Sr+TZEfBkfgCymuYbmDLeiuEnEEVAx2Fw88fnJf
        U328Upb+5jrd5GfXgCoxBbBnnUn46q4=
X-Google-Smtp-Source: AGRyM1v0IgBIRDYDSdN+eimreeKt668f69l4v8Y/nJf+NT6IYH6M7hCBXRbqo0rXXs5/PS7XjbVfSNZUSjU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:474c:b0:1ec:f898:d85b with SMTP id
 y12-20020a17090a474c00b001ecf898d85bmr895865pjg.11.1657582095847; Mon, 11 Jul
 2022 16:28:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 11 Jul 2022 23:27:50 +0000
In-Reply-To: <20220711232750.1092012-1-seanjc@google.com>
Message-Id: <20220711232750.1092012-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220711232750.1092012-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH 3/3] KVM: x86: WARN only once if KVM leaves a dangling
 userspace I/O request
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+760a73552f47a8cd0fd9@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>
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

Change a WARN_ON() to separate WARN_ON_ONCE() if KVM has an outstanding
PIO or MMIO request without an associated callback, i.e. if KVM queued a
userspace I/O exit but didn't actually exit to userspace before moving
on to something else.  Warning on every KVM_RUN risks spamming the kernel
if KVM gets into a bad state.  Opportunistically split the WARNs so that
it's easier to triage failures when a WARN fires.

Deliberately do not use KVM_BUG_ON(), i.e. don't kill the VM.  While the
WARN is all but guaranteed to fire if and only if there's a KVM bug, a
dangling I/O request does not present a danger to KVM (that flag is truly
truly consumed only in a single emulator path), and any such bug is
unlikely to be fatal to the VM (KVM essentially failed to do something it
shouldn't have tried to do in the first place).  In other words, note the
bug, but let the VM keep running.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 567d13405445..50dc55996416 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10847,8 +10847,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		r = cui(vcpu);
 		if (r <= 0)
 			goto out;
-	} else
-		WARN_ON(vcpu->arch.pio.count || vcpu->mmio_needed);
+	} else {
+		WARN_ON_ONCE(vcpu->arch.pio.count);
+		WARN_ON_ONCE(vcpu->mmio_needed);
+	}
 
 	if (kvm_run->immediate_exit) {
 		r = -EINTR;
-- 
2.37.0.144.g8ac04bfd2-goog

