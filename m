Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A1F7AA0F8
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbjIUU4X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbjIUU4H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:56:07 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517C82118
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:33:38 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c5cfd475fbso10566985ad.1
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695328418; x=1695933218; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pekGycpm690ftEnzP10xe6Ye5goWUg/PNLNn/FLDQrU=;
        b=lwSNIm63R+7w1SGh93pi7J7uo6VBJm+uY9BngSBpoYHuLRB1GwdCJ7SWRCejttudXa
         ThCTZ+h2tE/t/XM3gNkIreJrE6CjrLT4MeO5waQTOpIbIirJ958HB0ItsrXXUAhkK3pz
         6+j2P74GJCOqjsYqPrVPu2z25l34HXWg1Fr7d7Ub7xY9E1PGz43Rmplcd45u3ml5LZ8J
         Gc/KittbcQLNdF4Ctn3YV4aorSEWHg0epHChNlB1R59rDpndkyVrdmRogZp556tzw/8B
         6U5czBzwMrasMbHvuB6OeEWhkMco9dQg2/jFPlwO7ePqYf3JHivzvTKbdPKDLrnvAsXU
         uyWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695328418; x=1695933218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pekGycpm690ftEnzP10xe6Ye5goWUg/PNLNn/FLDQrU=;
        b=ksxlravANtt82PKEdjESGlWmoyFswsq707ftArl78zp/S+kZXEDxzo6h+58Hl2EnA7
         2hy5goO6+u0FLyC78HpJcAeO5GepGa48pmo7xNdo4zl/w1X55ygIE1LMtSS/Ttt2WehY
         D19nTPMrIGh0Krgja2j0iPZBSTP657DLi52rWAjAydwTWiTMCwZRHGJUdJ2kakEVRAM0
         Y9c6GXs7PeD/wAtGmBXXn+Ra2KI8YOMRxxmAc30GL78Gcnz+d9x+Xf5PH79ZV9Jf3ZFT
         ML3WORuhT5kalXlFmbKPXWwRF9cPitxM7kaMz8iaa4iJU9+oy21ZJSrMJDX/knwQdFW2
         Y7JA==
X-Gm-Message-State: AOJu0YzD5U47wnmlFGWjR1yk5+IZ+6rce8FfSFf5mVXbRbdImlCwp9AN
        CbX1kiQ0eMo59ae9G8AhHg7wFi3NtIY=
X-Google-Smtp-Source: AGHT+IEF4UT19Y0uaQX2IVlYHJIurtmC15TJZ1HuZVfkpN+vNSXFUmg/Of1RoXtQbwOKngdV2kpar7enry4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c945:b0:1c5:a79f:8ebb with SMTP id
 i5-20020a170902c94500b001c5a79f8ebbmr85481pla.6.1695328417821; Thu, 21 Sep
 2023 13:33:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 21 Sep 2023 13:33:19 -0700
In-Reply-To: <20230921203331.3746712-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230921203331.3746712-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230921203331.3746712-3-seanjc@google.com>
Subject: [PATCH 02/13] KVM: Actually truncate the inode when doing PUNCH_HOLE
 for guest_memfd
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>,
        Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Restore the call to truncate_inode_pages_range() in guest_memfd's handling
of PUNCH_HOLE that was unintentionally removed in a rebase gone bad.

Reported-by: Michael Roth <michael.roth@amd.com>
Fixes: 1d46f95498c5 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/guest_mem.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
index a819367434e9..3c9e83a596fe 100644
--- a/virt/kvm/guest_mem.c
+++ b/virt/kvm/guest_mem.c
@@ -140,10 +140,13 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	 */
 	filemap_invalidate_lock(inode->i_mapping);
 
-	list_for_each_entry(gmem, gmem_list, entry) {
+	list_for_each_entry(gmem, gmem_list, entry)
 		kvm_gmem_invalidate_begin(gmem, start, end);
+
+	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
+
+	list_for_each_entry(gmem, gmem_list, entry)
 		kvm_gmem_invalidate_end(gmem, start, end);
-	}
 
 	filemap_invalidate_unlock(inode->i_mapping);
 
-- 
2.42.0.515.g380fc7ccd1-goog

