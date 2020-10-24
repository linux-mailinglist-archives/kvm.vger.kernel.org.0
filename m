Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C34297F42
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 23:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1765103AbgJXVix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 17:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764669AbgJXVfp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 17:35:45 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26091C0613D5;
        Sat, 24 Oct 2020 14:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=RmePPOEb3bnuLREI31PqHdEbGn+3N49+keEMzsRjeWc=; b=oVqQMq/Xb+mcd+r6mt3x7XFrGh
        hEX/fCFJxmTh9qqkAlBrS9Pv/ENSPlFIcdyxzHz0VFPlDqc6VqinebkGzGZGdV2FM3Cq/toVgHytR
        uaxfv+O+7rc4N29pOOYvTdZUI3titd8AH8brTRs4WdKQYJFNenFmNBv0OKl7xgRvu3UusWrVuPp9J
        I0WHhQZmcxh4eJoGhM17W6hraR0LUggfUov6FwJs+dRBqDYEwciz7b6IRYc455OuEkdwhZH9dFX9r
        Wk2RsonwXD4BiZTYtJRlvtvyYOVLPTcPoV3q84b7jGdiNq9EmrApdjv4lguKbuaPepFkT8/r3LzbZ
        sCfZPcTQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWRCO-0008B2-Gl; Sat, 24 Oct 2020 21:35:40 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kWRCM-001rNk-L1; Sat, 24 Oct 2020 22:35:38 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v3 03/35] x86/apic/uv: Fix inconsistent destination mode
Date:   Sat, 24 Oct 2020 22:35:03 +0100
Message-Id: <20201024213535.443185-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201024213535.443185-1-dwmw2@infradead.org>
References: <e6601ff691afb3266e365a91e8b221179daf22c2.camel@infradead.org>
 <20201024213535.443185-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The UV x2apic is strictly using physical destination mode, but
apic::dest_logical is initialized with APIC_DEST_LOGICAL.

This does not matter much because UV does not use any of the generic
functions which use apic::dest_logical, but is still inconsistent.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kernel/apic/x2apic_uv_x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 714233cee0b5..9ade9e6a95ff 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -811,7 +811,7 @@ static struct apic apic_x2apic_uv_x __ro_after_init = {
 	.irq_dest_mode			= 0, /* Physical */
 
 	.disable_esr			= 0,
-	.dest_logical			= APIC_DEST_LOGICAL,
+	.dest_logical			= APIC_DEST_PHYSICAL,
 	.check_apicid_used		= NULL,
 
 	.init_apic_ldr			= uv_init_apic_ldr,
-- 
2.26.2

