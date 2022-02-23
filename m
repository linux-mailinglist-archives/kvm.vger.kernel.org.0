Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612634C0BF8
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238230AbiBWF0Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238317AbiBWFZl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:25:41 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2576D859
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:46 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id k10-20020a056902070a00b0062469b00335so10829245ybt.14
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wpN/U5eluX6Jnat+pEDX2C0UlbFhsXsgqK2IMjW00B0=;
        b=eO68TZsayJUnzF9ppfHaPSwA9f3cpJtiM/bQv1NjIx1viksnomhVCZg/OPfesExCQe
         GPBpKhmjuCayGTZhMCQafKSmuYZ+smeOmFtUbvbkWS5siPQw7nd2sd5jds4KSpKgIMG1
         5rAZMh+2rFOS1AHpWlupbprjH1FaaIPoFdMADMVIZrEncJu5IwxbAAD77jq17vk7nHI/
         pHx7Yx3y5+Ja+7mdhxYJ7U+IEaib+spU25N1cAyqYIyEgycYL490w9sjOc0zBhbj55fl
         oXav/h9TUMbHXVfYpZ1MYXyKyDqxgCsBYAWNUi6HD47X/71tlKLWuj7QNFucy0Ul1WpD
         v86A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wpN/U5eluX6Jnat+pEDX2C0UlbFhsXsgqK2IMjW00B0=;
        b=4zC+VmrzZyqsIKJ1O8fTcxlA4CqsOet3iA5RMQnDOgta9RvXohAY6mFVx1VOiN76DW
         iK9GoIQLQCINvVs3ZeP1hSQVFiVw/tPfjK8RUgqDzcWWSnN9re70vgpEcO/8Vv1Rxtb7
         juHIphPCbYIqeRopASgEnG2n0N6PQI8QBBo+XXubpn6fYs1PjHXNdXLS9+svhNztRy3j
         m2MRtaP3Dc+Mcr662RCmsGF7B5vzD9iJvpEYyLInmyneuEotkl9koyT1GLIEwTaKPxAR
         o3nGGw/9SEKxembq9QxfZc+wVAopLWvjxvGP2exhrSxlBQOaVXdSl//bpm1ypSgwWYuQ
         Vfyw==
X-Gm-Message-State: AOAM5312E+nw5UhLgIHy9JNkcefQ0ZmQ/yvLjicJsSPU0sCiEd0gM/LA
        buLNH2rQaVXxHqc/1c5ZsTsvAariB4X9
X-Google-Smtp-Source: ABdhPJy8YBcGGLS1CDa1jQAvWHy6IX+C9Fx9N9t0vFRpgYOq3ptmbXD9mdu9QbdYBQ3ESjXtAc+9DWkF+HCP
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a81:7141:0:b0:2d3:d549:23f8 with SMTP id
 m62-20020a817141000000b002d3d54923f8mr27573261ywc.87.1645593872454; Tue, 22
 Feb 2022 21:24:32 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:21:57 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-22-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 21/47] mm: asi: Add support for locally non-sensitive
 VM_USERMAP pages
From:   Junaid Shahid <junaids@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, alexandre.chartre@oracle.com,
        rppt@linux.ibm.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, luto@kernel.org,
        linux-mm@kvack.org
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

VM_USERMAP pages can be mapped into userspace, which would overwrite
the asi_mm field, so we restore that field when freeing these pages.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 mm/vmalloc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ea94d8a1e2e9..a89866a926f6 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2424,6 +2424,14 @@ static void asi_unmap_vm_area(struct vm_struct *area)
 	 */
 	if (area->flags & (VM_GLOBAL_NONSENSITIVE | VM_LOCAL_NONSENSITIVE))
 		asi_unmap(area->asi, area->addr, get_vm_area_size(area), true);
+
+	if (area->flags & VM_USERMAP) {
+		uint i;
+
+		for (i = 0; i < area->nr_pages; i++)
+			if (PageLocalNonSensitive(area->pages[i]))
+				area->pages[i]->asi_mm = area->asi->mm;
+	}
 }
 
 #else
-- 
2.35.1.473.g83b2b277ed-goog

