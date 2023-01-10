Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD96B664E4E
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 22:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbjAJVw0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 16:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjAJVwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 16:52:24 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C93DDFF5
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 13:52:23 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id p2-20020a17090a74c200b00226cc39b0afso5453577pjl.2
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 13:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=l82ntIFd7MfJAb7UiGfLmOAfwMt4TTGXS4HxL44y3uE=;
        b=Uz9zoI5PIuJEA3ZBY0NKTCrxWY1gEr3XrAkrjbc0mNIWWEKtyjhjkJbdAWwFHsA5mz
         42BBPxGHZOuY1lZXGJ8yo7K4veyW+s+7BDy00DwsX81abu/bJLJvQTyDLFNksvvnqHrY
         Ss0cd47ymETSaSkxU2VtFh/UunHB1akrwCg4KcTsRV+2KAcpx45/1Y45D5+bQX2Oi+Ew
         DDiPDHUQINNAXGRYONFlkS8VHXXSzrHUhusni7eGl2JPO9fpeGLmsKNNdgV/gDwacsWh
         LFXCZ0NI7yjO/A5Kbrs8iQUInwWmRt3pU/ufQNBFCS03eoIWa8DmPo6pKlGhZ4/5MxtT
         WA4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l82ntIFd7MfJAb7UiGfLmOAfwMt4TTGXS4HxL44y3uE=;
        b=UVnt52Xm04WPn4pNdrtyeMMz/mvVUsIlYuZk8rIkX0UYsR2B2OvlJz4JrMipgPnn2H
         wpDdyUe02o5XiyFOM/kqnCRF6mV5Ga8nO6mD1z82LMdXvGvaYgA4J+cB0MIlPnzOSYqg
         mI920j/DrwP0nTDBGqO9Hj/X/qe0tSP926dvpiPWGlo+EhT6MTZtUeHslL2qbWZChqW/
         9oodThwusvoAHQdjBeCDBcsmc+uCzFufLqMzeZfzWNgxLvO/8Cl4jtFKOIh9O7ICFwRa
         1f6/tXD1qfZVdYtxPvoMWgUKqjmFJp+NBpK1keCqlOOlSuxw2iy0j63nUd669F+Qt6ls
         Ku5w==
X-Gm-Message-State: AFqh2krmW/vxYOsawgy5BNX51aTb4370RjJ1uIMwAo3qJtHIVs4AzM5t
        Xzzh5DofEPl+UyrSUssA1cg/DEu0raaS
X-Google-Smtp-Source: AMrXdXstAIFHK82xxA5xKyMtQGZenpxd6q1WUBPtqRilf0ydCgzQse3nEmc5uf3aIs86K21xX17SjCa3bzB9
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:aa7:82cb:0:b0:578:3ec0:f264 with SMTP id
 f11-20020aa782cb000000b005783ec0f264mr5821763pfn.22.1673387542828; Tue, 10
 Jan 2023 13:52:22 -0800 (PST)
Date:   Tue, 10 Jan 2023 13:52:03 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230110215203.4144627-1-vipinsh@google.com>
Subject: [Patch] KVM: selftests: Make reclaim_period_ms input always be positive
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

reclaim_period_ms used to be positive only but the commit 0001725d0f9b
("KVM: selftests: Add atoi_positive() and atoi_non_negative() for input
validation") incorrectly changed it to non-negative validation.

Change validation to allow only positive input.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Reported-by: Ben Gardon <bgardon@google.com>
---
 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
index ea0978f22db8..251794f83719 100644
--- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
@@ -241,7 +241,7 @@ int main(int argc, char **argv)
 	while ((opt = getopt(argc, argv, "hp:t:r")) != -1) {
 		switch (opt) {
 		case 'p':
-			reclaim_period_ms = atoi_non_negative("Reclaim period", optarg);
+			reclaim_period_ms = atoi_positive("Reclaim period", optarg);
 			break;
 		case 't':
 			token = atoi_paranoid(optarg);
-- 
2.39.0.314.g84b9a713c41-goog

