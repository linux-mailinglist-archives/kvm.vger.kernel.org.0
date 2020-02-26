Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF6216FB20
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 10:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbgBZJom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 04:44:42 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:38020 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbgBZJom (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 04:44:42 -0500
Received: by mail-pf1-f202.google.com with SMTP id 203so1755220pfx.5
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 01:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UtzL/mOBJbhx1wqaitkgRIuidwcFWAMCohGe1UdpshI=;
        b=YB4rwED48l9nJfaTI5YVya96asUrFfT6Ic7DMgyUT8gXrA/y9a7VEAN68hI66ir1Iq
         andqqs41SMbE8G6wbHb4bD09HfYV6/gf9xzuHIQ/X+tOQ/SeVLbLoPAyCN/fjiriA576
         CYbclruU5fYRrooTgG2O7DXmCcKALKKuTbFT2szF7NVL3gfPSSaiKPuKwL4pPQGvpsNf
         qvyaisnLb9+iohMALrhE4pePkyiuNXPVIBrpDLXaXZspVneRBrVUDqWvyp7Be//VTdGV
         iwD5fOGUQRnLUVfqLoDHS1NeL04www9Ilz+Zn33KcgXx+cgCA7EMoM6L7hDZecm9ndb2
         +OdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UtzL/mOBJbhx1wqaitkgRIuidwcFWAMCohGe1UdpshI=;
        b=nBpD/EtFCMRRMLL3P1zQ77JfM6ezpFWa30mJhJQYM+wM+4PXKauKgDSI3BljETj/u6
         9IyifqOICLn2UN42esg1DOzzLE5aSQ7oOICwV6l7ziW73I+4h0saIJYph2XVy4m374+Q
         yfRyn+CqNZZJSKnKkPPDY9Byx/ZIAkjTfBesWYl99cnfqkz2X3rUaDiTxtGhiC+L7n2K
         mx7ZQjYdp2Yekn7nDm5CAZwIq35audmKcqYJEY0Z5ZsaAU5cH8gi5OR/vKg3wCOWn0Ra
         Q2Lqrg8Z7kDzj/4ElCliCLUHg3Fxts3UT2h+fw3+460Co7TXzPwNip7pisDenuesk8ZM
         rARg==
X-Gm-Message-State: APjAAAXANvKrOFSiRBaHfqQPERR3yKaeg8wREzX9ypG/7gBgK3eM0RTI
        YGblGEDXUaWU8qPwY6X51YrEqiNfVMoUpNYi6U/x5fgP553/+XG07S83EwUGmWrjQBq8ARGI/8y
        Ikbd2WW530a9Ixoqt2oc90f3Rq7PE/OnQc3pqof43HKo/jbfSh3q+WQ==
X-Google-Smtp-Source: APXvYqwxT+4LC0iHQbbifqhH9DQSutpnUXG4GHzFGL9fE6shs+QQt21j0iJgs3w2V4KuNAYEzxY3oJNnmg==
X-Received: by 2002:a63:f0a:: with SMTP id e10mr2772684pgl.402.1582710279605;
 Wed, 26 Feb 2020 01:44:39 -0800 (PST)
Date:   Wed, 26 Feb 2020 01:44:20 -0800
In-Reply-To: <20200226094433.210968-1-morbo@google.com>
Message-Id: <20200226094433.210968-2-morbo@google.com>
Mime-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com> <20200226094433.210968-1-morbo@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [kvm-unit-tests PATCH 1/7] x86: emulator: use "SSE2" for the target
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org
Cc:     oupton@google.com, pbonzini@redhat.com, drjones@redhat.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The movdqu and movapd instructions are SSE2 instructions. Clang
interprets the __attribute__((target("sse"))) as allowing SSE only
instructions. Using SSE2 instructions cause an error.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/emulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index 8fe03b8..2990550 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -658,7 +658,7 @@ static bool sseeq(sse_union *v1, sse_union *v2)
     return ok;
 }
 
-static __attribute__((target("sse"))) void test_sse(sse_union *mem)
+static __attribute__((target("sse2"))) void test_sse(sse_union *mem)
 {
     sse_union v;
 
-- 
2.25.0.265.gbab2e86ba0-goog

