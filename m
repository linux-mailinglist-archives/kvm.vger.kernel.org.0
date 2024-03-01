Return-Path: <kvm+bounces-10616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE4B986DF14
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 11:14:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E02F71C20AB1
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 10:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF3A66BFB7;
	Fri,  1 Mar 2024 10:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hv+/9qb5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0F56AF99
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 10:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709288061; cv=none; b=gB+XOLhVQMVMsVA/e3mf6/j2OduSNyQPRPR7qesyIuJM0/JHF7XImT2iVNYiZx13d6iHk3Qb8B/Jd0ZXAkmxUKo5kP/CSavGNLBRdzmqIhPjh3y5BanY2EmrlfQlTafz+kudlsMvPKgIrwU9D4fSQv75T8FYex67li0xxoAdekc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709288061; c=relaxed/simple;
	bh=sND8jhV+K31Cz2knDCDV+qPQDZGZA9Xo2gOcAqB/Ihk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYSNNtrQppQy0vjnu/Vqqr4g8YXCOgXLmvYyhHtyP1+7oUIq+cISDlnXl7TuPPz3aPYSQ31/3KCwI0vYYkwUsW7+gzizsKuVnPT9p4RfkCWZ4Mc7zNhBOQyTkKcvJxwdBu21bU/6Jo1Gp5LekfFfLwnIuyccv2ctMdjxxqGA594=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hv+/9qb5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709288058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8s8i3ItjA9wi3+gOCrDxEDREoSwFyWHMRuQO27hhEhI=;
	b=hv+/9qb54HIyVq0lp2yDFueE5t5WSrDILWwqFzhir0JEJ7e70ggPj9YMmknfnSZSYR8D4d
	zVX/0DvmQr5MxMsKuy8Zn3FCZKpCvPhiDDiG999KooNkDC6J6glr/G6kQvrRff/4HQ0Z0x
	2qfuTiRbBe93WIW2daBzbBvA5pkKJDQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-c4D56yyKOrai0fd5slYOSg-1; Fri, 01 Mar 2024 05:14:15 -0500
X-MC-Unique: c4D56yyKOrai0fd5slYOSg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDBD68B39A1;
	Fri,  1 Mar 2024 10:14:14 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.121])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8859920229D6;
	Fri,  1 Mar 2024 10:14:14 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 11E471801492; Fri,  1 Mar 2024 11:14:11 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: kvm@vger.kernel.org
Cc: Gerd Hoffmann <kraxel@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND 64-BIT))
Subject: [PATCH 3/3] kvm/svm: limit guest_phys_bits to 48 in 4-level paging mode
Date: Fri,  1 Mar 2024 11:14:09 +0100
Message-ID: <20240301101410.356007-4-kraxel@redhat.com>
In-Reply-To: <20240301101410.356007-1-kraxel@redhat.com>
References: <20240301101410.356007-1-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

If the host runs in 4-level paging mode NPT is restricted to 4 paging
levels too.  Adjust kvm_caps.guest_phys_bits accordingly.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e90b429c84f1..8c3e2e3bd468 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5229,6 +5229,11 @@ static __init int svm_hardware_setup(void)
 			  get_npt_level(), PG_LEVEL_1G);
 	pr_info("Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
 
+	if (npt_enabled &&
+	    get_npt_level() == PT64_ROOT_4LEVEL &&
+	    kvm_caps.guest_phys_bits > 48)
+		kvm_caps.guest_phys_bits = 48;
+
 	/* Setup shadow_me_value and shadow_me_mask */
 	kvm_mmu_set_me_spte_mask(sme_me_mask, sme_me_mask);
 
-- 
2.44.0


