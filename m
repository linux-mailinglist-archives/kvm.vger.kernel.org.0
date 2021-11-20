Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6D6457B80
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237128AbhKTEzj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237135AbhKTEyz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:55 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC455C061761
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:36 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id s16-20020a170902ea1000b00142728c2ccaso5689803plg.23
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=/08OTpsEPyjG29uUc0ve9IP8fl+G305Evs7tfqoTx9U=;
        b=qm58qKkmKCofG1rl8AsEnxKNJKQMmTqYi/SyL5DQxDipCgpmQJx60OzZ7vyGAls4T4
         jai6IXIEuIiBxa0/44UVq6YEetSG23v24iPFqYsth8h+hNRjc6UrxkFW4+QgTZgImL6F
         JQWdGAHn9JsnRftpCkgq+qvbpvoFf2gVuVrBAdV6Y29E38kYpIoKvR45vn3ktDuqA0cO
         OVU+dbo8SYmrT3720Tsn7s0eeHhZSF/IPS6B8pCbgpprAL/bAt1skDSMV2TMRkwav5Bn
         SGGKX0TNSA755gUBvEAFVLP+ZH8/+LfRj6w4WrRrGfcAxbEJsscxMlvl+JDQq0xDpV4F
         u7Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=/08OTpsEPyjG29uUc0ve9IP8fl+G305Evs7tfqoTx9U=;
        b=2/DHPYOOCWEPsudr1BhxhCDrFcvrVJBAugl6i3L1oR3CgCBCCHEEuvcF9jbA/A+sWu
         Aa4KUhMTjRdJ76hpTmHYMQw/LaVF6fN9P8/ynqPiRsTo8g4RD3GEajceM28g10tQrvDD
         N/4XAB/MBISykW7dCxI9rD3Dt4eZu0A9eaqAetkUFDu3vJ2U/CH2nhTA5lNr40I7eU+E
         NfavNOSHdBNaCnAcnktsZCYynzyuEf3h6miCyg+5Xwc8ssUskqNzMLIhwsMHwP2xkcbN
         F30APIuEtiB1+M5DwiWmd9E2/KpVy9t5WvLv4+9t4J+oQ2gLyo0c17nrEeh0OJb5s8AU
         IpoQ==
X-Gm-Message-State: AOAM530OYq1EEMNrFzQTHrYqz03gc2BNWXUMIbSbOaB9zUggxSCpYEs7
        adxpFHsLXoqE2t+wkfq+kQFoRFAyBk8=
X-Google-Smtp-Source: ABdhPJz0MUvTzQ9EkXX5uMsf26P2QO+Vm7NIdM0HTdiSztJoxrWO84fI2GQgWDhD8siIH+2z7szi/FJWSNY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:245:b0:143:c5ba:8bd8 with SMTP id
 j5-20020a170903024500b00143c5ba8bd8mr59994254plh.64.1637383896267; Fri, 19
 Nov 2021 20:51:36 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:45 +0000
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
Message-Id: <20211120045046.3940942-28-seanjc@google.com>
Mime-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 27/28] KVM: x86/mmu: Do remote TLB flush before dropping RCU
 in TDP MMU resched
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When yielding in the TDP MMU iterator, service any pending TLB flush
before  dropping RCU protections in anticipation of using the callers RCU
"lock" as a proxy for vCPUs in the guest.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 79a52717916c..55c16680b927 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -732,11 +732,11 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
 		return false;
 
 	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
-		rcu_read_unlock();
-
 		if (flush)
 			kvm_flush_remote_tlbs(kvm);
 
+		rcu_read_unlock();
+
 		if (shared)
 			cond_resched_rwlock_read(&kvm->mmu_lock);
 		else
-- 
2.34.0.rc2.393.gf8c9666880-goog

