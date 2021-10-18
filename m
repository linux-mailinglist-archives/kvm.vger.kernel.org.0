Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0280D4326A8
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 20:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbhJRSly (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 14:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233345AbhJRSlv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 14:41:51 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F5FC061765
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 11:39:39 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j193-20020a2523ca000000b005b789d71d9aso21128697ybj.21
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 11:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Z9lSCgng6PENRU7XUcbUjNAgdCnmNhgyeQM9ylTy8XU=;
        b=T16d2Cz0z6C79eReHcK0NzPXLXzkkC5LTHWLTT4ixGi8hA4721rxIwkUvTWXCILU53
         xNz2Fy4E85yFn3I2E8ovePxYp0ZoJ/VBgXyC1GoSijEBmDVPlaUhv+Nen2iOgeXWL4gN
         /aR4WnuByohlZogjgqaBui9Qb1eCWqo+4D/QneBcPhZaJEZ0zl+EuTQqzcM6yDFHpbP/
         /gx0OCJvLoNlDkvaSiOex+l7VRzb+tTjAHw9WsWLi3CJPQBnpJeR5IUZtO83Ub5+abVE
         IJTW/bFWrodCPi5v34GLsL1katcZH8QyipYKys9v0RuZeo0y6hDq1a5/hnZaE/+FQTii
         mKsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Z9lSCgng6PENRU7XUcbUjNAgdCnmNhgyeQM9ylTy8XU=;
        b=iddu3pFjcXc8BO+pHv37mjOugRx5yQQxYSE6s8uLNPaSdBA2I5Y/6oX9XWTIi4B1FB
         tMXxUDg7iqk0ZGflzZuVEGI+8Q1fKkt+JKCZDNAyYKI1DiupdIKDEksZhdqRkyiWvNEg
         6s7tiufBLlu7KN91xKq1JPJQasF46WhOhrETbSiI3I6mkKjZJQBIUmXfaN88UrQF0K+e
         Zr2R2P5I8VcN/cOSnNCa947dJL5nJLr2bH4RLhfQVdvKmo9vZ7I5EYqUgH4Aim2E9oW3
         LCSi3jb3xpCAfiILv2AgLxgSQi/0Uw0AYY7LM7v2gMaVmdSc1iRxjvjcI3pAQCpsR9wI
         a0dw==
X-Gm-Message-State: AOAM531Po3U6+sskUN7c9k/pzCnEDo/S+OE8xi7E3P/TMp1eTB76KpgM
        u0CmCWtR9b42sZV1q0SM5t7iTrHetUM=
X-Google-Smtp-Source: ABdhPJzDbaVaci4slpMBiw3afK2s6EnhqSg0q9el+upfqRVe2WJT5VdI/49sU/EkpG83CSznV16uEaS7zqE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:ae71:c4e5:5609:3546])
 (user=seanjc job=sendgmr) by 2002:a25:86d1:: with SMTP id y17mr32139385ybm.174.1634582379088;
 Mon, 18 Oct 2021 11:39:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 18 Oct 2021 11:39:29 -0700
In-Reply-To: <20211018183929.897461-1-seanjc@google.com>
Message-Id: <20211018183929.897461-3-seanjc@google.com>
Mime-Version: 1.0
References: <20211018183929.897461-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH 2/2] KVM: x86: Defer "already loaded" check until after basic
 support checks
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move KVM's check for a vendor module already being loaded below the basic
functionality checks so that attempting to load an unsupported module
provides the same result regardless of whether or not a supported vendor
module is already loaded.

Intentionally keep the err non-ratelimited; if userspace is probing two
different modules for the same vendor on all CPUs, it deserves the spam.

Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e966e9cdd805..f67da77be267 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8538,12 +8538,6 @@ int kvm_arch_init(void *opaque)
 	struct kvm_x86_init_ops *ops = opaque;
 	int r;
 
-	if (kvm_x86_ops.hardware_enable) {
-		pr_err("kvm: already loaded vendor module '%s'\n", kvm_x86_ops.name);
-		r = -EEXIST;
-		goto out;
-	}
-
 	if (!ops->cpu_has_kvm_support()) {
 		pr_err_ratelimited("kvm: no hardware support for '%s'\n",
 				   ops->runtime_ops->name);
@@ -8556,6 +8550,11 @@ int kvm_arch_init(void *opaque)
 		r = -EOPNOTSUPP;
 		goto out;
 	}
+	if (kvm_x86_ops.hardware_enable) {
+		pr_err("kvm: already loaded vendor module '%s'\n", kvm_x86_ops.name);
+		r = -EEXIST;
+		goto out;
+	}
 
 	/*
 	 * KVM explicitly assumes that the guest has an FPU and
-- 
2.33.0.1079.g6e70778dc9-goog

