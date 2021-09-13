Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC87C409162
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 16:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343704AbhIMOBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 10:01:10 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:58110 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245108AbhIMN7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 09:59:07 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6FFA01FFE4;
        Mon, 13 Sep 2021 13:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631541469; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kMNxl3ROgcUS4F7pKtP67mA1glR29ldcpqto1Jdyazk=;
        b=rPaWfAfMYVL+BM/X+k2P3bUmJh1U9tCsNR63GI8x2DEc94HCtgtlZIzIL16fc2ArDHG7Lp
        lz75VBmInPm+LUyhQU6y+oZhBejKreTzXoDcy0AGUQR8McRw8s91+CF6xlpRc0RfjFdzMK
        7lnHwloRG7TlYQUGdIq05dMfbYB9D8U=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F3B3413F16;
        Mon, 13 Sep 2021 13:57:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WEHrOdxYP2FMUwAAMHmgww
        (envelope-from <jgross@suse.com>); Mon, 13 Sep 2021 13:57:48 +0000
From:   Juergen Gross <jgross@suse.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 1/2] x86/kvm: revert commit 76b4f357d0e7d8f6f00
Date:   Mon, 13 Sep 2021 15:57:43 +0200
Message-Id: <20210913135745.13944-2-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210913135745.13944-1-jgross@suse.com>
References: <20210913135745.13944-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 76b4f357d0e7d8f6f00 ("x86/kvm: fix vcpu-id indexed array sizes")
has wrong reasoning, as KVM_MAX_VCPU_ID is not defining the maximum
allowed vcpu-id as its name suggests, but the number of vcpu-ids.

So revert this patch again.

Suggested-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/kvm/ioapic.c | 2 +-
 arch/x86/kvm/ioapic.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index ff005fe738a4..698969e18fe3 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -96,7 +96,7 @@ static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
 static void rtc_irq_eoi_tracking_reset(struct kvm_ioapic *ioapic)
 {
 	ioapic->rtc_status.pending_eoi = 0;
-	bitmap_zero(ioapic->rtc_status.dest_map.map, KVM_MAX_VCPU_ID + 1);
+	bitmap_zero(ioapic->rtc_status.dest_map.map, KVM_MAX_VCPU_ID);
 }
 
 static void kvm_rtc_eoi_tracking_restore_all(struct kvm_ioapic *ioapic);
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index bbd4a5d18b5d..27e61ff3ac3e 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -39,13 +39,13 @@ struct kvm_vcpu;
 
 struct dest_map {
 	/* vcpu bitmap where IRQ has been sent */
-	DECLARE_BITMAP(map, KVM_MAX_VCPU_ID + 1);
+	DECLARE_BITMAP(map, KVM_MAX_VCPU_ID);
 
 	/*
 	 * Vector sent to a given vcpu, only valid when
 	 * the vcpu's bit in map is set
 	 */
-	u8 vectors[KVM_MAX_VCPU_ID + 1];
+	u8 vectors[KVM_MAX_VCPU_ID];
 };
 
 
-- 
2.26.2

