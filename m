Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2437415D995
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 15:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729417AbgBNOdX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 09:33:23 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35154 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgBNOdX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 09:33:23 -0500
Received: by mail-wm1-f68.google.com with SMTP id b17so10863628wmb.0;
        Fri, 14 Feb 2020 06:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I7FmDXyfboRLEPAe8bo8K3mXwXolpPNpCrODWfL+mak=;
        b=gAGGyVySMmr2ATay53+kqMswj1tPiJDsz3jS4++s3wXWDQlHnkpWf2HL70eWdJ+fsv
         CQvQV1BddgIFW0e4KztZJD7K4semtYzzKwObmrXtXYQ/cxD8Qzy6aTxMTRNqh6cRubpF
         r1mn7IPnxTtShGYjCl7ka+xqU3DkAAl59gyDCf6L/mYm7eFQ7XNxMEWhLhC5inUVRkjG
         b3lWZWNLQKotrlB26P93uU+wUAvI9uiOrpPMGRWGQwTatskOO7SGxBeGQoOg8tiuvbvj
         b02BwS2WnHhy3I04PFR9L9ZP6j0IWJ9ssjt+UJS+QH/c2pmOi3Ohh3JE9B08BgCSKO/U
         JhWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I7FmDXyfboRLEPAe8bo8K3mXwXolpPNpCrODWfL+mak=;
        b=GpmBROZNhghhymDlmg1EU/EIZhu3Mej5TqB08f5v71VF2Ro8vbA1VtM0McNRTtaeeu
         FxsXBKVs1iy5fV275QDcOztFwuNSIW5tUnhuvxVeBHr2LDlTlH7nUMfqyW2ioTTTkg9w
         gqL9qLXEhM/+q9qL5w+LuENpCCrSqFXf9RuI69V0RiJtMlBzqK6xrRiNw+qjxcKEiV8k
         w+MCdC5hxtWUoZ4ush5onATQzGEIjgIzCw+345Zn+9u8jyTQTAjE7NGdxPnCyiYhd7J0
         Ea+b1Rl35cDMW4zsbQjvZHwkfKyp+DfZqwP6njRsoU0+zxNntW585wgvnhJy18FLRIUo
         GwDA==
X-Gm-Message-State: APjAAAXiMstNfoeoc7ap6jGDRIX2AOI1ixK8Gl8bC37zMkKpx5mCaPIi
        tI4wuW63ZRlgxJcZppHchOAx2snMNgiWjQ==
X-Google-Smtp-Source: APXvYqx1QmY2R3J7t7fyqRZrLDCCPv+AondDOF0VmfUJgnj3oPdg3EMRb9Zs6jCDFFBEg13lUluE9g==
X-Received: by 2002:a7b:cf12:: with SMTP id l18mr5265928wmg.66.1581690799833;
        Fri, 14 Feb 2020 06:33:19 -0800 (PST)
Received: from t1700.criteois.lan ([91.199.242.236])
        by smtp.gmail.com with ESMTPSA id w13sm7511520wru.38.2020.02.14.06.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 06:33:19 -0800 (PST)
From:   Erwan Velu <erwanaliasr1@gmail.com>
X-Google-Original-From: Erwan Velu <e.velu@criteo.com>
Cc:     Erwan Velu <e.velu@criteo.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kvm: x86: Print "disabled by bios" only once per host
Date:   Fri, 14 Feb 2020 15:30:35 +0100
Message-Id: <20200214143035.607115-1-e.velu@criteo.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current behavior is to print a "disabled by bios" message per CPU thread.
As modern CPUs can have up to 64 cores, 128 on a dual socket, and turns this
printk to be a pretty noisy by showing up to 256 times the same line in a row.

This patch offer to only print the message once per host considering the BIOS will
disabled the feature for all sockets/cores at once and not on a per core basis.

Signed-off-by: Erwan Velu <e.velu@criteo.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fbabb2f06273..8f0d7a09d453 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7300,7 +7300,7 @@ int kvm_arch_init(void *opaque)
 		goto out;
 	}
 	if (ops->disabled_by_bios()) {
-		printk(KERN_ERR "kvm: disabled by bios\n");
+		printk_once(KERN_ERR "kvm: disabled by bios\n");
 		r = -EOPNOTSUPP;
 		goto out;
 	}
-- 
2.24.1

