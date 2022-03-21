Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC884E3532
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 01:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbiCUXvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 19:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233530AbiCUXvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 19:51:09 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 531F7196082
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 16:49:07 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2e643f85922so26975137b3.2
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 16:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eaMpQz/2+gIGl1l/NaHHR9r8rELtroyMHUNp7EK/mzA=;
        b=jZYdyGLDT1rPNya0zYp8WpaU+7kOP6KdfhIGOZTmttYfnyNJYfBrtepboIJ5odwfrw
         /bkRPaq97VIIspJKNuKc7luPOnIcS0tV9iwcn9xP1ETSpPvv1m3pKyhPJPll3UysqUZy
         13apm+c73YOVfmTCZGSkEnIID2JwLpUe3SNPXBTgn+pyLgl9Eo2v4InmS4VI0x5zWsyz
         S3RmYfjfHpSWZpKQQtm8v9rjfGPox7DtcBK0lvgS2QxrP4hQ19bE/ihH53tNnTy6dhFG
         jTn/LVRXjSC6RS81tHBse92oanoDwaJuqzH9s5V5nDtWXJvcN6RYPR99KNH4ekdPT98G
         JDJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eaMpQz/2+gIGl1l/NaHHR9r8rELtroyMHUNp7EK/mzA=;
        b=iRVRtpkLTdxcCaRfCUs2ZXexq8iKEwfYUCXV/3f/dT5KpP5gEur+t4fQ9J8ENt0VB+
         QN10syeQgpP3VKIAqaOhqypPcQwhKWOnqWrqixcldaiytfAeTtUe22eIkz8iY/RWzRG3
         95G2A9bba0/O1ufP1RDEn/9gJCBBnk2Y7h4EOQeNwRW9qH3bUufz/aXsL1jXHcV2Y57y
         DbV/uqf0wzzP4e8z53uCDQUl7uBD8I/UE2UZu/yKDGHkWJ+ADhsgvZ68b0oN9UuDOF6d
         euNDLRc4uEML9J0NJNBD7hxFIXpML3ewENZPcP1kVrfHqPRhvodlO5Uywu+TQG8y/bVE
         NRhQ==
X-Gm-Message-State: AOAM530UNeIED8eRZdtwfyv7i4Tp8/B5urLSRnXED7mNL+q2GuZDMZ2x
        wrzXYthfwthdAUWva1hnWIngkBtDwk1e
X-Google-Smtp-Source: ABdhPJwxJQuW8sN2Dk7+xF8QgGAHRKBKpRfkRsxXusPwZUYwUcL/DREHHbw6Wl/K/RBIHiR210AiJjavemar
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:b76a:f152:cb5e:5cd2])
 (user=bgardon job=sendgmr) by 2002:a05:690c:11b:b0:2e6:529:d6b2 with SMTP id
 bd27-20020a05690c011b00b002e60529d6b2mr12866359ywb.345.1647906543992; Mon, 21
 Mar 2022 16:49:03 -0700 (PDT)
Date:   Mon, 21 Mar 2022 16:48:38 -0700
In-Reply-To: <20220321234844.1543161-1-bgardon@google.com>
Message-Id: <20220321234844.1543161-6-bgardon@google.com>
Mime-Version: 1.0
References: <20220321234844.1543161-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 05/11] KVM: selftests: Improve error message in vm_phy_pages_alloc
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
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

Make an error message in vm_phy_pages_alloc more specific, and log the
number of pages requested in the allocation.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 09742a787546..9d72d1bb34fa 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2408,9 +2408,10 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 	} while (pg && pg != base + num);
 
 	if (pg == 0) {
-		fprintf(stderr, "No guest physical page available, "
+		fprintf(stderr,
+			"Unable to find %ld contiguous guest physical pages. "
 			"paddr_min: 0x%lx page_size: 0x%x memslot: %u\n",
-			paddr_min, vm->page_size, memslot);
+			num, paddr_min, vm->page_size, memslot);
 		fputs("---- vm dump ----\n", stderr);
 		vm_dump(stderr, vm, 2);
 		abort();
-- 
2.35.1.894.gb6a874cedc-goog

