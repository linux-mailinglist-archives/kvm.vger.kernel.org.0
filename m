Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B371023D0F5
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbgHETy4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbgHEQsi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 12:48:38 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D017C0086D0;
        Wed,  5 Aug 2020 07:15:28 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id z20so4577113plo.6;
        Wed, 05 Aug 2020 07:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rEOIric6Ir5n+lOqeIUvVaHq8kkbGDlIxFcFnaIeFVQ=;
        b=ZkRT9n6qi1MmrCkM+E537KhVRT1l3vdm2/Ro4pCdDJRA6UkpwxDmS8ZAyxOdST5s62
         WBF4QZ/RCetbs01gGxXt1a02B2K+L5tE6l8UkHXoItIluhgeuw3INFKrnuvDNdTdCWHN
         s/QyMREKiE87UIIBQXZuCKez7UJ63uDhXPgUH6Xwz9mcxZMDtjvVxt4eceSv4x8PTyGA
         B5ZGKsXdPM4wZ1E+xnGW/xdPlkv0xTcfJuKeReyDLfljFHOZfQKYI59kg0aamYAy54b2
         nSbl8F62rRI6F1BGgexyInUdVE8u38O7AcmnjAEZs2NO7ET5GcxsI65CDT86tzgobmGs
         pryA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rEOIric6Ir5n+lOqeIUvVaHq8kkbGDlIxFcFnaIeFVQ=;
        b=V3TOuKnc2p7tK3ANQdyyk48gTmy385C1LGWO/BUZP6oSTjwtl3LgibourgFR0BWzbV
         CJnY+EiURtpNzPg92sVW54dGjGdTCv6OEuuZyxVu1vlm34kc+4iKhw5xxfGZcreA39jF
         qkbkxxTfk4X0PzWIbitNWFALtV/X5dQdwyiw13lnZlwZyXTzvkdYY+lFp0pzNEcGdxUl
         bFr3oJY8hAUfeEq66QFDChKURhcx631X3X+dgLMLgO95zEWhL3wP+VvbjClZIAhC1Eh6
         SRgppINgoCkUgGIPVSVwnQtJNnq2rK25O4DXc+5VDrc92g52Q+aNkAR/gPegYES8FFei
         KrhQ==
X-Gm-Message-State: AOAM533x1XHlloGm3cEUHDCjCKDixSt+69+cTE9wNDmMXJ5a5dov0Mm0
        fAudTHotGtiJ9ASQ0vie42Q=
X-Google-Smtp-Source: ABdhPJxoCHeKbtH4i8Re0QtrWCP7cYen3eIDSZ4CjAepg/EGPcmYe2gP1t4htLViL7C20uPS82QTlA==
X-Received: by 2002:a17:902:b489:: with SMTP id y9mr3065180plr.99.1596636927791;
        Wed, 05 Aug 2020 07:15:27 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.62])
        by smtp.gmail.com with ESMTPSA id q82sm4253725pfc.139.2020.08.05.07.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 07:15:27 -0700 (PDT)
From:   Yulei Zhang <yulei.kernel@gmail.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, xiaoguangrong.eric@gmail.com,
        kernellwp@gmail.com, lihaiwei.kernel@gmail.com,
        Yulei Zhang <yuleixzhang@tencent.com>
Subject: [RFC 9/9] Handle certain mmu exposed functions properly while turn on direct build EPT mode
Date:   Wed,  5 Aug 2020 22:16:19 +0800
Message-Id: <20200805141619.9529-1-yulei.kernel@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yulei Zhang <yuleixzhang@tencent.com>

Signed-off-by: Yulei Zhang <yuleixzhang@tencent.com>
---
 arch/x86/kvm/mmu/mmu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f963a3b0500f..bad01f66983d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1775,6 +1775,9 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 	int i;
 	bool write_protected = false;
 
+	if (kvm->arch.global_root_hpa)
+		return write_protected;
+
 	for (i = PT_PAGE_TABLE_LEVEL; i <= PT_MAX_HUGEPAGE_LEVEL; ++i) {
 		rmap_head = __gfn_to_rmap(gfn, i, slot);
 		write_protected |= __rmap_write_protect(kvm, rmap_head, true);
@@ -5835,6 +5838,9 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
  */
 static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 {
+	if (kvm->arch.global_root_hpa)
+		return;
+
 	lockdep_assert_held(&kvm->slots_lock);
 
 	spin_lock(&kvm->mmu_lock);
@@ -5897,6 +5903,9 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	struct kvm_memory_slot *memslot;
 	int i;
 
+	if (kvm->arch.global_root_hpa)
+		return;
+
 	spin_lock(&kvm->mmu_lock);
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		slots = __kvm_memslots(kvm, i);
-- 
2.17.1

