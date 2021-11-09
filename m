Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E81E44B4F7
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 22:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245259AbhKIV4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 16:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244649AbhKIV4H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Nov 2021 16:56:07 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA80C061766
        for <kvm@vger.kernel.org>; Tue,  9 Nov 2021 13:53:20 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id m5-20020a170902bb8500b0013a2b785187so501634pls.11
        for <kvm@vger.kernel.org>; Tue, 09 Nov 2021 13:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=44hY6dpD+MXlkWIZf50iY/QoTJnaBVVLOApHjVkiZy0=;
        b=Wra/qJa5K2ybr5YHNwoPxE2rM370wC4BVyMCDzaNVmDVkMNNCRgy8XfSzw6XNsZGIR
         6WCUECYgEi9RHz0tCXUik6IbSUz4ag6HhEwkjsmJ0xLhPPlorLCmlxODCGiN6qUGQbhl
         JdhoUqlEevTZdq46B2YX8JJt4x/rrU9C9YS5gS//gDVK4vYyltJIi+WQzS2Slm8hwPTm
         4hdMHbUnfcwHGnnHEH1JGIHyBpM+/QYPOIdfEkiBU7EkwOWDZT02Yi7UYkH2UKDMOkEu
         UYdGHcBhxGeuVxyQdhdgm1wS/flXK2ZEZZ88qgEjDP5XbitMrQxEMy21pe57sSRdyAuP
         BrpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=44hY6dpD+MXlkWIZf50iY/QoTJnaBVVLOApHjVkiZy0=;
        b=m9FQjCBNKugmta8OrHt92UnbTLuxTG8Rd3tWGgc+ZpWs6bo1V68xSfOO3gvV+Yiy3Q
         1oDehDQpn0JCUh5jKh3tCBszmh4LWaVNX7tODcJFn4oJL6hJo8VKgTzqA+f6y7+iOOGh
         nzjVY5gGZapXOQdqINqtGOWn43MqdBB0zNrHfAk2gqnIGDYbIomzUXkCYNtHRGsKkFcg
         VRBSxA+gsmG1R9yrKCmrkp3m9y9DW7zelKoUbum2D4S5Dj/TWBiLnsXQk+GwXpVSGHMV
         ucmTmQ3MPY4XQOyn+nxmnGgim2OkGf7M3rujOcnCNoml67fDW9LoI63QTh0alfJgjfz4
         HvBw==
X-Gm-Message-State: AOAM532XJrE4K16cL//m7iavAN9vnfFYtOpuI6X2u2oGpTwUps1WroXb
        5AEFZjm2nhrVjqnIhfpXmkGZzHj7D1U=
X-Google-Smtp-Source: ABdhPJwSsWF/gxvXx1G9lCyzN+lozHBrRFLTIBYdaNiY7IGPFhllfKTvd1B9yOLzncvl9Y4AxiIZeLDpnzg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:aa03:b0:13f:a07e:da04 with SMTP id
 be3-20020a170902aa0300b0013fa07eda04mr10512686plb.80.1636494800399; Tue, 09
 Nov 2021 13:53:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  9 Nov 2021 21:51:00 +0000
In-Reply-To: <20211109215101.2211373-1-seanjc@google.com>
Message-Id: <20211109215101.2211373-6-seanjc@google.com>
Mime-Version: 1.0
References: <20211109215101.2211373-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 5/6] KVM: SEV: Drop a redundant setting of sev->asid during initialization
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Marc Orr <marcorr@google.com>,
        Nathan Tempelman <natet@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove a fully redundant write to sev->asid during SEV/SEV-ES guest
initialization.  The ASID is set a few lines earlier prior to the call to
sev_platform_init(), which doesn't take "sev" as a param, i.e. can't
muck with the ASID barring some truly magical behind-the-scenes code.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a869b11301df..a69dfa0d62aa 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -249,7 +249,6 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (ret)
 		goto e_free;
 
-	sev->asid = asid;
 	INIT_LIST_HEAD(&sev->regions_list);
 
 	return 0;
-- 
2.34.0.rc0.344.g81b53c2807-goog

