Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A958549C8E
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 21:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346586AbiFMTAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 15:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346268AbiFMTAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 15:00:21 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1D89969C
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 09:19:51 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id j15-20020a17090a738f00b001e345e429d2so2438617pjg.0
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 09:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=TaFkEEYysed0ZjHcXQwF9Zz5rGBFJVxcbzKnAkD2bLE=;
        b=BdyUyuAnmo6m8r1koxsfiOlsc5iBNlYySi3Y71QAYuY10veGPQMdUfMGhTfXRAD/jp
         SaugyRrAgCkYojFlfApB5/etcSDN8V3lOYeZbFaLsfFxquOJpuM7LqW1zpASrDwckUmz
         j/Z0XFHKi+sAiqu+/S7/+sdCMNhh5cz6On2RgMVy/6TzrZUxACT1WPSaoKueO5gbBNRL
         VT73mZjb7UOAZvch0+ny+tV5U7YNfmQEetOqihOu6tPpGN7lA/4r99PVFyO1KI8OSaLT
         8ZVdkz4NMXRaVxReAL6jLw2J0RfErikAiKKvUu4FY26zUvFXv2WHfvkqNJhwloC9P74f
         QIKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=TaFkEEYysed0ZjHcXQwF9Zz5rGBFJVxcbzKnAkD2bLE=;
        b=lDjz14dIY/BD+yht1+w7cltt+9hQPB67q13gL0kupBW339JPVEqVC5tGb7Gx0vAcdH
         rNws9lSMHx13gYN5fI9EFWEQtwRCTK9ne1+jj3d2yWU2Vp7p1irTPlHIlJ+IT2Ousxxo
         Wuk1brVMKFma2wbHw5+wLrSBF6jzDIzeY6wGPcP58q53OpRs8V/KPfIX4omY34frhuBg
         ++LmOaHEKh6GnXmjwdfblBGE86xmdL59ttshHhLr5vcox9EtOl83eidASKb/3DPxkXI6
         R5vDTjE8hFrm07oUJbbq7lK80sZKXOoSkOzpKghM6FzZqcJgMbZZrDt4Z9v6e02kx6H5
         4ZXQ==
X-Gm-Message-State: AJIora83rQLfzizGCJ0w6Fbs+iyjB8p0fF2t4C0uTNwkG/SJJomo1l3A
        KI85iyHhzwCWZUx5ZfxhN2jfzpMObxs=
X-Google-Smtp-Source: AGRyM1uSISy6bunfnR8Yit2TWacf4gJnLWhGMnEplJRMVeWD2oqBzx69YnLQTZsKrF295eR0wT9fMyUouO8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:ead4:b0:161:c85a:8fff with SMTP id
 p20-20020a170902ead400b00161c85a8fffmr390270pld.97.1655137190747; Mon, 13 Jun
 2022 09:19:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 13 Jun 2022 16:19:41 +0000
In-Reply-To: <20220613161942.1586791-1-seanjc@google.com>
Message-Id: <20220613161942.1586791-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220613161942.1586791-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 3/4] KVM: selftests: Drop a duplicate TEST_ASSERT() in vm_nr_pages_required()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Remove a duplicate TEST_ASSERT() on the number of runnable vCPUs in
vm_nr_pages_required() that snuck in during a rebase gone bad.

Reported-by: Andrew Jones <drjones@redhat.com>
Fixes: 6e1d13bf3815 ("KVM: selftests: Move per-VM/per-vCPU nr pages calculation to __vm_create()")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 0c550fb0dab2..bceb668f2627 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -284,10 +284,6 @@ static uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
 	 */
 	nr_pages += (nr_pages + extra_mem_pages) / PTES_PER_MIN_PAGE * 2;
 
-	TEST_ASSERT(nr_runnable_vcpus <= kvm_check_cap(KVM_CAP_MAX_VCPUS),
-		    "Host doesn't support %d vCPUs, max-vcpus = %d",
-		    nr_runnable_vcpus, kvm_check_cap(KVM_CAP_MAX_VCPUS));
-
 	return vm_adjust_num_guest_pages(mode, nr_pages);
 }
 
-- 
2.36.1.476.g0c4daa206d-goog

