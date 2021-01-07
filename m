Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848F12EC749
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 01:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbhAGAUW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 19:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbhAGAUV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 19:20:21 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CED3C061371
        for <kvm@vger.kernel.org>; Wed,  6 Jan 2021 16:19:41 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id k13so2725575pfc.2
        for <kvm@vger.kernel.org>; Wed, 06 Jan 2021 16:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=dDiuE/L+TEOVkofWeADZyQOWx+prBVUG+hG/zE7qjqw=;
        b=VkjczQkDv6uSysLxiEUHoxuQ+DbKhDcWrtgG8nIXiIk9txn9MKBRgvUvoRfyoTVdn6
         F+V3rRcP5bSzLl0Zu2tc03tpgWRRfCP4476e7Wx8ki01QtG8Xw8UXuqfuOhiZu0eN0ZC
         l/uisVbTdVRibbAkrN0eGjVTnXuoFxvf1hrzN5daVrnwrtoP4/J1J9JohxHNaT7tC9Ow
         uG2mCdoqC/rM8zsbXCyc6qyz2PlYSiuysFaaeyb0/w7ZOc2rOCCg3I06N6+aQQbIP+uj
         7pz7Q9VyJCQkD9MoX/bKjNxU+fJmeL8vziSQGhhuxkVn+XmeRjM/p31kv+pKd4Ygxk5A
         +iRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dDiuE/L+TEOVkofWeADZyQOWx+prBVUG+hG/zE7qjqw=;
        b=OX/qo1pNeQDBSWjsz2Qudk0XC9mFbmyKX1gIAJ8AUtgYCmLGXTMgqxPFTGxPdasW5L
         cTx+BZ4+lTWevqmUYZxPXAfrsvrKCtYZvuBeC1ddnYt39sadVX9QxBrjZC+pd+4a5Q6A
         b26iNm5zATWbUiiyXIabP4F4IYbZlhanNgsH12LL4OQ4eVU/chkzvUVrq32gATIIjx6G
         ncaJZmvNLii9EeWPCcWImDiz/0QQnGKwxjqnMMipFuUAoisXMQbP6iYQJ8hDO18G/shK
         XZjt8dMbT8NzJMNX4/kAI0G4UDUNng24HHlyAp3TM10fJVX/SEBNaUNH73zL8qMNLT7C
         trmQ==
X-Gm-Message-State: AOAM532r/eoK1bsEjH+/OlUJWW6iv1W43q0IjSJyWonrERlPLX2VFE9z
        oix1dxgF8ynL3eitPirWSt4X5kYyJvI8
X-Google-Smtp-Source: ABdhPJyhjygi1mTx9UYbhuGSK2TiCC2wcA1NRyh1XTwbhkzoE5419S5iHE7Co7FcCeF3rCchoB5qhqOg9ACU
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:90b:14d3:: with SMTP id
 jz19mr6654541pjb.196.1609978780963; Wed, 06 Jan 2021 16:19:40 -0800 (PST)
Date:   Wed,  6 Jan 2021 16:19:35 -0800
In-Reply-To: <20210107001935.3732070-1-bgardon@google.com>
Message-Id: <20210107001935.3732070-2-bgardon@google.com>
Mime-Version: 1.0
References: <20210107001935.3732070-1-bgardon@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH v3 2/2] KVM: x86/mmu: Clarify TDP MMU page list invariants
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Leo Hou <leohou1402@gmail.com>, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The tdp_mmu_roots and tdp_mmu_pages in struct kvm_arch should only contain
pages with tdp_mmu_page set to true. tdp_mmu_pages should not contain any
pages with a non-zero root_count and tdp_mmu_roots should only contain
pages with a positive root_count, unless a thread holds the MMU lock and
is in the process of modifying the list. Various functions expect these
invariants to be maintained, but they are not explictily documented. Add
to the comments on both fields to document the above invariants.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/include/asm/kvm_host.h | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 39707e72b062..2389735a29f3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1010,9 +1010,21 @@ struct kvm_arch {
 	 */
 	bool tdp_mmu_enabled;
 
-	/* List of struct tdp_mmu_pages being used as roots */
+	/*
+	 * List of struct tdp_mmu_pages being used as roots.
+	 * All struct kvm_mmu_pages in the list should have
+	 * tdp_mmu_page set.
+	 * All struct kvm_mmu_pages in the list should have a positive
+	 * root_count except when a thread holds the MMU lock and is removing
+	 * an entry from the list.
+	 */
 	struct list_head tdp_mmu_roots;
-	/* List of struct tdp_mmu_pages not being used as roots */
+
+	/*
+	 * List of struct tdp_mmu_pages not being used as roots.
+	 * All struct kvm_mmu_pages in the list should have
+	 * tdp_mmu_page set and a root_count of 0.
+	 */
 	struct list_head tdp_mmu_pages;
 };
 
-- 
2.29.2.729.g45daf8777d-goog

