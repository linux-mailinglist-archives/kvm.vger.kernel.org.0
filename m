Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF8945D2AB
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 02:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352940AbhKYCBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348224AbhKYB7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 20:59:01 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C07C061373
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:06 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id x6-20020a17090a6c0600b001a724a5696cso2312502pjj.6
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ZNRWi49sEeBLezOelralMdKGAHnjnpG0gngkdEcyfP4=;
        b=Hxwcf7KEIUcF1lkRTrVncZk9Nok1GE8f/+UsquABgzdIIg3OMrGm826vHMM+V9Bu5Y
         FFoS/J80/Be4BL55Avu8CmpaFPAegFvUsS0RzAtcuJSSFQ4V+F8gFHe304XEJxMbMBnx
         qMLNdiifua8qoiHQvXsqsFBTN4s++JjOFb45nlJlIzjepdPTTbRcUgqLLIICxGJzZFQy
         HIkkh1GVEs0yEwi6itcmIeOTQi/BbAW4++CIJllzvvg3fNODuS+Kzrhn4g8qlQLtKapm
         G0krvDFT+ZNbi6612LkRQ4rNiU9xyaL09/7kltXe/yAJ8Mf2ykWDG8c/QJW+btzOTZGC
         msOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ZNRWi49sEeBLezOelralMdKGAHnjnpG0gngkdEcyfP4=;
        b=cPouXCk4GaFFx3zkmhwguZXKPZjjBbcw5WnJQ4EX2k4PSn+PQsgvbkAWDqYRs+cn4x
         0QCPHiaLnDAlXGc26uFicPyEk8xENYVGGgeQDfFBxO8Uxqk3X6XE74GPww0jfwvTsD8F
         Pvn6mM1EAgjWxqNWw/a4IvnI3JrYT88Wtzm2zHLSpHiSEURpiZIXkRYkN38jziEEhp/H
         +yMe80MrTS+wo+hHE8BC5x8ADmJiwM1pTznIvI3WvjrGgqQ8hUw/qGdEoSRbn8wCfEsB
         HRlsOj2XP1Oae84MuDQkkICXu1hXQDR/DR5Kw8Vl9DfXRiiFxyzbOvPH2wA67xDwAzsG
         W+Bw==
X-Gm-Message-State: AOAM533vRVEPu5n4PEk0G0jCelIFkIhHz0VIYwA/+3cAZYVB/FL38ZLl
        rkqvmq9cSOqtQ16yeGcdOK/RVs3HnJQ=
X-Google-Smtp-Source: ABdhPJzZEJyz7qRh870D9WuOAvWzdVP6s7Hozu24l5iM4gzhdkVzFWHRZ/NpiWXp1A+ZEI65tb9sy8C3YUE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1486:: with SMTP id
 js6mr625930pjb.0.1637803745535; Wed, 24 Nov 2021 17:29:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:21 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-4-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 03/39] x86/access:  Use do-while loop for what
 is obviously a do-while loop
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make unnecessarily confusing code less confusing.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index eb0ba60..60bb379 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -355,9 +355,10 @@ static int ac_test_bump(ac_test_t *at)
 {
 	int ret;
 
-	ret = ac_test_bump_one(at);
-	while (ret && !ac_test_legal(at))
+	do {
 		ret = ac_test_bump_one(at);
+	} while (ret && !ac_test_legal(at));
+
 	return ret;
 }
 
-- 
2.34.0.rc2.393.gf8c9666880-goog

