Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60D5387806
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 12:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406239AbfHIK5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 06:57:19 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52208 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbfHIK5S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 06:57:18 -0400
Received: by mail-wm1-f68.google.com with SMTP id 207so5271271wma.1
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2019 03:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2MlbsA24Rszqm07Nqr+QNBq64s8U7dZBznf1kxDCc+o=;
        b=RbvTUxvpSfR7R6gnDAoga/3zvpsIjjCUAIVcI44P10LXPdhdodAKeQteTcJqzM9vwO
         Cwn8MCM+FFdLkYEXuG11MOnSW4EPKXCYF0UyyGdKWDHtDuZxJW4paQexRYqy6RIcR0rL
         tQjokoy8wjBysq2bUVIJhs4tsh/fVjDnXP4wqIdtc25EKwCeGxlOURDbPdPTZ0s+kXOB
         T9PNSrixOtly3+6VfFF1/Wl4MZsvQfSDY++tJpmH4ZRSaJmCdjdv7MzmfinY+h+c/5Fy
         ebS9KKW+jJ/T0i2/DRx3Q/uUb+rqxRH/I/8aR8Wm02b0lFOT1xyg/uzRDP/kbFHrPy2z
         Iuwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=2MlbsA24Rszqm07Nqr+QNBq64s8U7dZBznf1kxDCc+o=;
        b=kwG7oWpBlFWmezrk3eyoqexBYrtNKFbkqb9qYrhVeqs0h02v8hBz5XVrT76hOykKaS
         xndGzC35BzkyBxmhlEPQpnW62iEcHEvb6+7zHNE825l5YV4s/RM2wx4yqnBIDg9+czuA
         I2bScIFdypv7deyQYnS1XWeGn59yzM5iUvvhwMvhgqbld8BFpNRnjCve5gymsbsvlrEr
         ndHHtrdbruxT1267iaJ4kUGH31rQPFy414w8oI/KG2Pn8EUFVdVcwvFxCjXJoVhep/2G
         zI1OeEicjL3dC+fw72juhMQaGgNgZfhQo/PVj7TbIxA15Q4UxOGbsj90vtmzSgeihG5j
         JC5w==
X-Gm-Message-State: APjAAAWvp6NZxklD30ZLggou3LzIAZwdrzZG61BCT0Q5Bgac7PPAMc0i
        +J3ww5jRF04375jkl27tzCeLXs61
X-Google-Smtp-Source: APXvYqzPK1N82hyA9Zq+Sp553xkvn4LCERARaRyHkl6ikf8JcY9dLwjpGx0t81GtdMP1PcKPYPh8MQ==
X-Received: by 2002:a7b:c202:: with SMTP id x2mr9853564wmi.49.1565348236674;
        Fri, 09 Aug 2019 03:57:16 -0700 (PDT)
Received: from donizetti.redhat.com ([2001:b07:6468:f312:b42d:b492:69df:ed61])
        by smtp.gmail.com with ESMTPSA id o4sm4164314wmh.35.2019.08.09.03.57.15
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 03:57:16 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] x86: access: avoid undefined behavior
Date:   Fri,  9 Aug 2019 12:57:14 +0200
Message-Id: <20190809105714.9450-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In this test, at->ptep is tested in one argument to ac_test_check
and dereferenced in another.  The compiler notices that and observes
that at->ptep cannot be NULL.  The test is indeed broken and has
been broken for 9+ years: the ac_test_check should not be performed at
all if there is no PTE.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/access.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index f0d1879..4ec0b0a 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -704,8 +704,9 @@ static int ac_test_do_access(ac_test_t *at)
                   "unexpected access");
     ac_test_check(at, &success, fault && e != at->expected_error,
                   "error code %x expected %x", e, at->expected_error);
-    ac_test_check(at, &success, at->ptep && *at->ptep != at->expected_pte,
-                  "pte %x expected %x", *at->ptep, at->expected_pte);
+    if (at->ptep)
+        ac_test_check(at, &success, *at->ptep != at->expected_pte,
+                      "pte %x expected %x", *at->ptep, at->expected_pte);
     ac_test_check(at, &success,
                   !pt_match(*at->pdep, at->expected_pde, at->ignore_pde),
                   "pde %x expected %x", *at->pdep, at->expected_pde);
-- 
2.21.0

