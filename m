Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D1A4C0C2D
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237231AbiBWF3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238471AbiBWF1U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:27:20 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439246F484
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:34 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2d07ae11464so162269707b3.14
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cWpgk2PD8ywov80MgvYy738g6oDVkPJMa4mg6Kd57WI=;
        b=EONmeIZhbgQ2Ix8S9q3J8G/HTiRJQe/uAmut/mIfTv5CIy/cqk4x/lLfaofIL6ZsPO
         2DK7UMkGosmFYOPK8XbKYJ2B7I4QKSD7X8xoOad3cTZw5YniQxiy63dmB34fBM3ScXK9
         b4M3PhJD3t0ZCy25IHGFNrU1Wai96D7oCn70Yeg5Az606EQRIrVrKV03yc49SjAoBqEY
         D/bmDYBLa30k0Q0T1/0E+zVvHZ7GWXBtnOemyeM6dCZ+R2nj996pZd5wNPpUZxVxnqxJ
         WaqOqmkCjUVkdvW9sUwO7Bbj6HXZvuS7EIm1omaeZny3PaSOUoJHhQmMblrL8LNsc6wd
         q1rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cWpgk2PD8ywov80MgvYy738g6oDVkPJMa4mg6Kd57WI=;
        b=ZPr686fB9C16mvBE2Lih674/lw2/G0f3XAI4AE/fqpJUui+0ZEfnByn7KmSa+YaeOj
         md6rGSPQMenNAi2m8W4H5fUaH47yUWUJv3bw08/sWapbxJ7ejLGhhHQ0WBl4PGfVaMlA
         bt+iRV83eDS0oL8X7mV4l5iDOQH9V8r7uGAn4N7COLys7QEBLD3Hjd/JJ0PTNUuVgwh8
         DXG4CxWuA3ZKNaU3Y/42xgbYW7mPHQUELNZIy9XMeMKASbB247Nnoyt3xMKtZkyJUPpT
         zvGGk6RuM0eLCJ8Ho/Q0hUxEMtP2U/XV9ZB+GkyyohAVzYuwX3lqnJ+F0Kc7fGzpcAgS
         Ufzg==
X-Gm-Message-State: AOAM533pkdzJrkICaCqeDRMnfbmorLIukyMNmUu3dNEM9n0VUdH05WyN
        qxDIf+1z0Uh0Oy/9jGs0tbGLWMTtKHm5
X-Google-Smtp-Source: ABdhPJxkXSiWBnVLfkr470oqcQZfrXanhJKcgx/q87EPE8RXSdLDTEk6wPn7sTX4KYfxfNXBGCkwiM0xCmzr
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a25:bf87:0:b0:622:1e66:e7fd with SMTP id
 l7-20020a25bf87000000b006221e66e7fdmr25540509ybk.341.1645593928498; Tue, 22
 Feb 2022 21:25:28 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:22:22 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-47-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 46/47] kvm: asi: Do asi_exit() in vcpu_run loop before
 returning to userspace
From:   Junaid Shahid <junaids@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     Ofir Weisse <oweisse@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com, pjt@google.com,
        alexandre.chartre@oracle.com, rppt@linux.ibm.com,
        dave.hansen@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, luto@kernel.org, linux-mm@kvack.org
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

From: Ofir Weisse <oweisse@google.com>

For the time being, we switch to the full kernel address space before
returning back to userspace. Once KPTI is also implemented using ASI,
we could potentially also switch to the KPTI address space directly.

Signed-off-by: Ofir Weisse <oweisse@google.com>


---
 arch/x86/kvm/x86.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 680725089a18..294f73e9e71e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10148,13 +10148,17 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 			srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 			r = xfer_to_guest_mode_handle_work(vcpu);
 			if (r)
-				return r;
+				goto exit;
 			vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
 		}
 	}
 
 	srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 
+exit:
+        /* TODO(oweisse): trace this exit if we're still within an ASI. */
+        asi_exit();
+
 	return r;
 }
 
-- 
2.35.1.473.g83b2b277ed-goog

