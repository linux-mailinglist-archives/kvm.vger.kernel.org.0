Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 144275A3269
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 01:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345459AbiHZXM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 19:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345442AbiHZXMw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 19:12:52 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EC7EA174
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:12:50 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-337ed9110c2so47556047b3.15
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=wRixm1YVhAJ8xZe1pU1E4V06yoGJLAsGACDB692LvKs=;
        b=a14Azz3UWEGB1TFiwilQsSdjjeYlNQ4qVw7ykdMcGxGgW/6E3YbcqSOVMYquc+yorh
         7AjBfh2BJwFrNUrfuPm2NON91/U3D4qGTVfzFEmgRCYl4aISPTJmBVXpNEY/3aVgsPSL
         yiziBrUYY2bvfLKvv8+989Eb4Jg2eI3qz/iVBrs+p7TW32dTqnjMKjfFdmZUCdkQH0cD
         VKnNFkWNbek7VbykO5qfr6N74Sw89nsNQeC8NmWs4FzETAVR31NWebvmxMQ9VyNxp2we
         AYF8ef9A+vKc8WAFUDnIJ5XawlK8mtISATVaGM08bCuTZnvvOcWCVTuA0MsZGzfa4uRE
         /4Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=wRixm1YVhAJ8xZe1pU1E4V06yoGJLAsGACDB692LvKs=;
        b=UTJf5KJW2bMElfP4YMax4plPW+LXEKtaigVwyN8/AHzVJrrj8n/RLIOrvKeVakZHqC
         2YFtpvtC03gp+krV/1vFH6q6SpBVxdNkMiiEqaEYQ6aIAdpbjGSy9CansLjZGKYjHtGo
         5TkYJgx7VRtG4oyVcyVXyVEgkC5KmuIIp7nA6uubz5yOJEale9xgGWlHmkkr7B7KyUok
         /vLB7z5V7Zn75oRfWMgDRqC8zAGVRhefvdutxpxuhUsOwtAE/niBKLGr1p+kAqZviMDI
         ofcuA6BLczNueEJ+XwMUdZtrtA7LixCVL7gHmrDv+TYiUwSykV+aZi1qyMMYgcBPP9Ry
         mYiA==
X-Gm-Message-State: ACgBeo1Fgq9xhJYrfixzi/lm5AsrGZsYgsilrzdRD0a2/IotIVPKW3UW
        gvCKe67QL3qI3D5dPh2bHGIhk2Uy9CWiCg==
X-Google-Smtp-Source: AA6agR6VUHye4G1LZsaLksi0vReDzr2WREV02PyvuI7HuGwzk6GDhtr9ZRr03Ja4sHSp0q2KH3JjxHoiTQEQ6w==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:24c4:0:b0:696:3e03:2d0e with SMTP id
 k187-20020a2524c4000000b006963e032d0emr1785534ybk.104.1661555569856; Fri, 26
 Aug 2022 16:12:49 -0700 (PDT)
Date:   Fri, 26 Aug 2022 16:12:26 -0700
In-Reply-To: <20220826231227.4096391-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220826231227.4096391-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220826231227.4096391-10-dmatlack@google.com>
Subject: [PATCH v2 09/10] KVM: x86/mmu: Stop needlessly making MMU pages
 available for TDP MMU faults
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>, Peter Xu <peterx@redhat.com>
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

Stop calling make_mmu_pages_available() when handling TDP MMU faults.
The TDP MMU does not participate in the "available MMU pages" tracking
and limiting so calling this function is unnecessary work when handling
TDP MMU faults.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8f124a23ab4c..803aed2c0e74 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4347,10 +4347,6 @@ int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 	if (is_page_fault_stale(vcpu, fault))
 		goto out_unlock;
 
-	r = make_mmu_pages_available(vcpu);
-	if (r)
-		goto out_unlock;
-
 	r = kvm_tdp_mmu_map(vcpu, fault);
 
 out_unlock:
-- 
2.37.2.672.g94769d06f0-goog

