Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA264541AC
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 08:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbhKQHTT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 02:19:19 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:54244 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234109AbhKQHTS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 02:19:18 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 77CB61FCA3;
        Wed, 17 Nov 2021 07:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637133379; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=yaDw2rBJ4fDcUAx1ccACVUAisWN5AqchsHUPgNrv7sE=;
        b=tt03pe/WfEhCgX6FS2zwfC6Nhmwz6g8HTYOSQBBmKEgR8errwOK4O7bp2IyaBXSpoJSlWO
        uYPhbEGhwN2ewQPrqIkq6Liiwq8C+pjroqM5ly7aAARocdt81aR4iUo+ab5NciiqX91zUG
        9xVKqvm+8kNYUkR239hjSvz9vRUU8/8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1210313C03;
        Wed, 17 Nov 2021 07:16:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OlojA0OslGGcSAAAMHmgww
        (envelope-from <jgross@suse.com>); Wed, 17 Nov 2021 07:16:19 +0000
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
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86/kvm: remove unused ack_notifier callbacks
Date:   Wed, 17 Nov 2021 08:16:17 +0100
Message-Id: <20211117071617.19504-1-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit f52447261bc8c2 ("KVM: irq ack notification") introduced an
ack_notifier() callback in struct kvm_pic and in struct kvm_ioapic
without using them anywhere. Remove those callbacks again.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/kvm/ioapic.h | 1 -
 arch/x86/kvm/irq.h    | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index 623a3c5afad7..5666c39d8df1 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -81,7 +81,6 @@ struct kvm_ioapic {
 	unsigned long irq_states[IOAPIC_NUM_PINS];
 	struct kvm_io_device dev;
 	struct kvm *kvm;
-	void (*ack_notifier)(void *opaque, int irq);
 	spinlock_t lock;
 	struct rtc_status rtc_status;
 	struct delayed_work eoi_inject;
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 650642b18d15..c2d7cfe82d00 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -56,7 +56,6 @@ struct kvm_pic {
 	struct kvm_io_device dev_master;
 	struct kvm_io_device dev_slave;
 	struct kvm_io_device dev_elcr;
-	void (*ack_notifier)(void *opaque, int irq);
 	unsigned long irq_states[PIC_NUM_PINS];
 };
 
-- 
2.26.2

