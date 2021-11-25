Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B675F45D2BB
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 02:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353471AbhKYCDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352913AbhKYCBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:01:01 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61853C0619D9
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:30 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id x9-20020a056a00188900b0049fd22b9a27so2525277pfh.18
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=5ugeGbQtv5WecOE5/AOsR5g8aqO54J3Un9RXWbwUga0=;
        b=jzhXD3ohSBw3Q0zc7qs4vnS965hq0pMaMb44DSghjtBd0VNnyveuS+NNbY0wthUlfa
         mTR72vyS89vtaNCfilkz5hP2NxMR5YdOQ/mYlAzoJXMhZmtwAWpBIeWGVPPmdEiI27ak
         NhW2IstEH+hzQZMtjpfnI43psq9khFzxn6ELPbIKtGDKNA0Ot8B/xhcBHBkEoiTXnYDK
         voiqrX23HXyz60tl+hqFsU65cyQPkseWcZnvO9DpMVGl+AI0DYC/sPr0yIBTdD1aLYES
         wvSk6ZwBTUsFby6wxj5i791vwDPTSTBP6VD2bN1/dq7WX+YRr+yK5tKL1XtDVAU0o1yI
         Lk2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=5ugeGbQtv5WecOE5/AOsR5g8aqO54J3Un9RXWbwUga0=;
        b=GrtjJhmwOXkalyv1GS+2BxY/etoaF4l/mj2QzHD1FmnyKNzIUNN/+Pts/JmIT0u5XM
         9NpXsMJ6KfrzZLnYRfcCOn7vicoxndWWpu0qMDnQ0ZgwqqClpgxcrz1sS48oFx+mUTYt
         +5UtZEDXet0j7Ss8rm4wc+rQ9CJgAEodd0/WpUt0jLvSBtg3UZqt4tnawW5O8O2eqR2V
         O7+NC5+dFhOdcVyG4tkCaoHgTP9vFEjNhFdDx6FgMCptKZUO7zFpbvGX/ZMXBOz5mQaI
         J4hKrG0+MWpHH9/v9HWGK+JgLO1UwW7Mue2TYLnRyrEtwFe2MNq2aUPRuYtgdk5zSbkH
         kI+A==
X-Gm-Message-State: AOAM532qB1zejYuoRmHngmfaHDQyHSPze2ohrgjBadq6sz+rDr09vkjy
        y987ItJDIwhp9Xvnx2IX3h0yI1gTfww=
X-Google-Smtp-Source: ABdhPJyvOLYk4Pn+IAr36jKCHGw7W93a5FzhTIbGBFroScix6ZtIH62giNMJEnhaMhMdBqwEgcN+hjrEDtQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:88cb:0:b0:49f:ad17:c08 with SMTP id
 k11-20020aa788cb000000b0049fad170c08mr10599366pff.19.1637803769934; Wed, 24
 Nov 2021 17:29:29 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:36 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-19-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 18/39] x86/access: Remove manual override of
 PUD/PMD in prefetch sub-test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the overrides from the check_pfec_on_prefetch_pte() test now that
pre-allocating page tables will naturally have them use the same PUD and
PMD entries.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 3e1a684..956a450 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -957,10 +957,10 @@ static int check_pfec_on_prefetch_pte(ac_pt_env_t *pt_env)
 	__ac_test_init(&at2, 0xffff923406003000ul, pt_env, &at1);
 
 	at1.flags = AC_PDE_PRESENT_MASK | AC_PTE_PRESENT_MASK;
-	ac_setup_specific_pages(&at1, 30 * 1024 * 1024, 30 * 1024 * 1024);
+	ac_setup_specific_pages(&at1, 0, 0);
 
 	at2.flags = at1.flags | AC_PTE_NX_MASK;
-	ac_setup_specific_pages(&at2, 30 * 1024 * 1024, 30 * 1024 * 1024);
+	ac_setup_specific_pages(&at2, 0, 0);
 
 	if (!ac_test_do_access(&at1)) {
 		printf("%s: prepare fail\n", __FUNCTION__);
-- 
2.34.0.rc2.393.gf8c9666880-goog

