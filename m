Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD464A5480
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 02:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbiBABJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 20:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbiBABJE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jan 2022 20:09:04 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02168C061401
        for <kvm@vger.kernel.org>; Mon, 31 Jan 2022 17:09:04 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id 188-20020a6219c5000000b004ce24bef61fso2920461pfz.9
        for <kvm@vger.kernel.org>; Mon, 31 Jan 2022 17:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=bL3FT8k/Xb3BcGI4WIfdGnBaIJMFJqmCvBuj1gJGH44=;
        b=qfjP1xUS1KlVS/IMykXefKvK1qQTncFnnytcKJMuNz7cZ6izT1HFdUafvswOgJug6w
         fUu2gRE/sPO/gMGaQJHy1cu/gikzlTFd+dwYsScIQ2aSEr19oNQfPZGlCSgrgT+A/ptb
         /BmWw9Q/5FLUgVtaJXFmF+ufSdVc0dVArOlkXmwriEDJ5vmsdUA1krlC7d3M4dgj/hAk
         ZH38ahZRKwAFuq+7rfQkwCiebPXcQlBJDlblbvkGBTV3eebX1oiryLzUoQsHW5mONR+9
         1uIdR6azhY2x3J/pkEG8jDjFnokQdpdQEl+iLKEku7fanF+2DkTtHnGCKT2OvwN8+DmO
         kjOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=bL3FT8k/Xb3BcGI4WIfdGnBaIJMFJqmCvBuj1gJGH44=;
        b=RzadKh7ihtVfaY9Ndfc7elfMG2+Zid5V53zRUupbJ/Ew7O/Utyt7EhyoLp6veECKeW
         Qu6V4faMTEZBtSLu57Hf72MOaeF9Z/ydEL/lXRo29dD2umeHzClp1h3OSDphqBg5U+ut
         sXFq4HL+R+t0ulAHNaLVYw0EL91/SkxSwEDtg7BXXcrExGBq56tT/m0vBzqmZQXGpyc2
         npfvKGuO4ilmbsZbmvjUEMdJrnH/xOatpOoLN6JiN9belIL/hzpOLIzD7ykxPewFYpxa
         ljVt9eyZKY0Eo2IvpGUvG68mdYmS3IEFSLjJWa/QN3IdNFzdDIwdw9S8GpPdxqIqHpwN
         X9jw==
X-Gm-Message-State: AOAM533xy8Oakg3oVXBFCvRQTKFKMG4Gy3As+5Pke8VPe5Qt10YvnhPF
        JgUiEvLnHipTYMvLMr3dEG0dDhGzjBE=
X-Google-Smtp-Source: ABdhPJyr1xQ8ILXqOSdU52v8l3fst3RJPIJ4yAP+ddUL0kFfLBBG3IGhmHWreArnTTL96e8JdujXax4R5iE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:7784:: with SMTP id
 o4mr23247435pll.173.1643677743484; Mon, 31 Jan 2022 17:09:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  1 Feb 2022 01:08:38 +0000
In-Reply-To: <20220201010838.1494405-1-seanjc@google.com>
Message-Id: <20220201010838.1494405-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220201010838.1494405-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 5/5] KVM: x86: Bail to userspace if emulation of atomic user
 access faults
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Exit to userspace when emulating an atomic guest access if the CMPXCHG on
the userspace address faults.  Emulating the access as a write and thus
likely treating it as emulated MMIO is wrong, as KVM has already
confirmed there is a valid, writable memslot.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 37064d565bbc..66c5410dd4c3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7217,7 +7217,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	}
 
 	if (r < 0)
-		goto emul_write;
+		return X86EMUL_UNHANDLEABLE;
 	if (r)
 		return X86EMUL_CMPXCHG_FAILED;
 
-- 
2.35.0.rc2.247.g8bbb082509-goog

