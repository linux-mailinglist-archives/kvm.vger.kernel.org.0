Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A063D45D2B3
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 02:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353169AbhKYCBR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345596AbhKYB7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 20:59:07 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB12C061379
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:15 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id x1-20020a17090a294100b001a6e7ba6b4eso2302906pjf.9
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ijdDzuhpS3OA3CoRZLe6HOlTFMMwT0H61KwAXjSXijE=;
        b=lyMW6LmjvTHMB59DDKQvT5cbGWl9TweHxFEWxvWHtU+DXHDbs5Ci4VgR4xwdAVFNR5
         sBAH4VXTW+gxVEBy9+6YFUxxqtUsAD+IWtY+umPPMDPBednv8aSPlmFFUsfUXSb7/1Sx
         iqoZCwPrjH6xTeBYBKEIsNGXq2fJl+MDgk1RC84sxZDi8GJV+RyP2KsHIf5hlS+GMEl6
         Uwk12L46C/V70S65hs+saUThj8rzW7SJDZ84ONmBnQrAH/lLv3Z0LLEHO1qd0xyNptv3
         2sBAolQR9CqJf8cDI1B0I9XjnlzSkLMcK+KsOShDFvL6MMw7GJInA6ZSu/AaaNMmI9R1
         ts2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ijdDzuhpS3OA3CoRZLe6HOlTFMMwT0H61KwAXjSXijE=;
        b=62JS0nJGTds2peyQEyEqTEUlXjyqNCQ+CeC0EGiEE+NGl73pzhtqJPaLymKk5J33xk
         Qi/ep41e1hwYT6KssK+32C24UddlK7ynw+TdXVHgWy/xCdtwhpqMuwGb4d0SQrZkNpbx
         SK5BpKMhhqrtHJbsj8uwck4j5FfJW05C8e3T8wdlqh1bqKuk4laC2UaxqAckRa7cvXTp
         7/FLemx6ol5gG/j9Un7suBy0q4RFemtsZc2TOE3duGyO0QlLnlGvUJ44P4GlnB+z1gcF
         lf/eBWi4qtd+9Qqm1SzIv45ry8ZxDOPNpd2+pj/5Ovuzq44mbWWqJtrsYwyetyJ/1CZd
         79aQ==
X-Gm-Message-State: AOAM5338INWuZBADUHe9s7eoPKB8HOsr5oExjSH462ptmNV8VZL+vU5J
        M1tokeK5afAZJsmH6JLlsR5LgXlAGto=
X-Google-Smtp-Source: ABdhPJxpN/WIDykO0JiPzpFuJ1XaIh6NAsGwOIJo3Qzb04RJi1Gtj/g85I6ye0DMOOlCSCbW8SpHtsELbZY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:2c50:: with SMTP id s77mr13925439pgs.387.1637803755145;
 Wed, 24 Nov 2021 17:29:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:27 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-10-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 09/39] x86/access: Abort if page table
 insertion hits an unexpected level
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Assert that inserting PTEs doesn't encounter an unhandled level instead
of silently ignoring the bug and shoving a not-present PTE into the page
tables.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/x86/access.c b/x86/access.c
index fb8c194..06a2420 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -530,7 +530,7 @@ static void __ac_setup_specific_pages(ac_test_t *at, ac_pt_env_t *pt_env, bool r
 		pt_element_t *parent_pt = va(parent_pte & PT_BASE_ADDR_MASK);
 		unsigned index = PT_INDEX((unsigned long)at->virt, i);
 		pt_element_t *ptep = &parent_pt[index];
-		pt_element_t pte = 0;
+		pt_element_t pte;
 
 		/*
 		 * Reuse existing page tables along the path to the test code and data
@@ -618,7 +618,10 @@ static void __ac_setup_specific_pages(ac_test_t *at, ac_pt_env_t *pt_env, bool r
 				pte |= 1ull << 36;
 			at->ptep = ptep;
 			break;
+		default:
+			assert(0);
 		}
+
 		*ptep = pte;
  next:
 		parent_pte = *ptep;
-- 
2.34.0.rc2.393.gf8c9666880-goog

