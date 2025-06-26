Return-Path: <kvm+bounces-50794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49A6BAE96DB
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 09:35:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DA833B45F5
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 07:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C9632517A5;
	Thu, 26 Jun 2025 07:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="Dlrmj4L0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6688216A94A
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 07:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750923308; cv=none; b=JChEKTO5kW6OjenCVOfsTknwg3yGgNyVuaHX328zViOQBPCm5dSRXfo1y2a9QV0uiX1DhWEtKadJsb37/68aNQNL9J1MXJpFmOfkW2J2T+vtBIgyMOruPle8G4aYbaKA9mgjXTuJazo2UBXPNCt7X9cgorpk/C6ChP16lYriiIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750923308; c=relaxed/simple;
	bh=BjZ2DoFppAmM6F1SuH+Pn79IKaBzkBJtdhrnEOC0T9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0NhvjjorSHA7fMYr2y+RiEiJI+F2Xc2QI4Eki8+UdQL50HYhdRP7YyUPOXt9v9SUC60NcaEJwCQpGze8BSS9CElVW4zqoSLEjaAruZYixU2JIHjUayJmKxmFCx5V1bxodt7sKBWv0HVnQwTf95T3iRHjx5kRZqv7/Rj5Sx+EUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=Dlrmj4L0; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4537fdec33bso3414475e9.1
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 00:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750923305; x=1751528105; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O5XPh45yd+Nk6SuA5lhfFS0Jt1da9i/6L9WmurJtxcs=;
        b=Dlrmj4L0LDcdgKPt/MKaBGC8IO2mfN0ZGcf+ZaW6ubLsZTEavf35amuhvf088dNdt9
         w5MZCplg27eokfaQO85Et7kfDNaBR2KCfCpywD8NfQP6DZ25q1bdw1TG2WNpjPe80QKT
         qGZztFOBMMbtMfadbXEmR6rQUK7VI1awilJ3P2MI7HDhHcY6Z3v/9cKSrkHz9YyGmH9l
         dNfRjvrjCElYPlDZvbRPBjshlsGrPHCMMcuTTOQI5/gke3Vj3Y9KD7hMVaCotK7ByXQ5
         RmWfR+fab4oBlECk4S60PE4O1m3Op0HzDFwaL6IbC9fGH/FaURSWQjvgwHXe9CjQOJDq
         FoXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750923305; x=1751528105;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O5XPh45yd+Nk6SuA5lhfFS0Jt1da9i/6L9WmurJtxcs=;
        b=UNUr2lhywPwuUMgpOpC2BNn87RevR8vKOsA8uJbtilV103KnZGNl0OgR74Gn9XR0HX
         81GSCstikRmq3E6GRTk0zHyZy4TrPBI+re7dq1kE0MRxfxXh78bloUVdiY9D8dYrAxPD
         OMjPJqWve3jZn8swZBYC1UjQsiq64Igu6t57wyOhTTx0QVInDSRBFaTBc2TEacn0uCRS
         hM4i7Il7LxfPd/Hcnf5/z+77MOvrWrAvZAFEalJhLkMm/85poUGBUCcG8gFLGPo+nSDb
         cfe0kVTMznwIWIwlHu+hZPXw2emvv6V7Tzebbwl9tw/UltjZ76Tp6ePI0FUIQv3fgCW3
         4E8g==
X-Forwarded-Encrypted: i=1; AJvYcCXIh/k3+5ImsEUmwWa9Ed91Ysf6cdJ/yZPRpeFTLqHyiaJLmcF8Br/BD0CKwmmf1JQNrqw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfcqKFKRp6k6CI+WTwPNP7MTzEmVXGDDgLBaDV8GHMbaRy3RRJ
	2QRmriQvzy+SSRFD9+ARUx1ahD5NR94Q9VzDJ0BovwcIBYFd1mGXG07duMiVIs7iPFU=
X-Gm-Gg: ASbGncs+cYd5qmLNx57hMtsB/WI13YNlsx+5YmNaYKx5bTTwn6ZQZH1ZdunzQDHaw1z
	VXlwAnh9Qz/4dJzZ7zRx7obxSVJo/dv0GGMFM3eLGNy7Xi9IaqNXb31ZqUEREaC35W2QJiNxjCN
	nEyrbZltsdVpnKaWO4cRReao5Ht8BcqyGkDIUWBPKVM4g2l1DmuzQXBYK8/ujWani14CoBT6fcd
	RL/HDaC+bIxULaXOzPsgCkUZBHfAdl9gx/wJGDRMcOXTnZtV/u4KQ2l4z4QxpvKmPg6oQZ2BNpU
	66J8Z2CZOszkts9XQW0gjYFG51FWn/dXTk2l7AFR/CtCXmC1EkilkjawyOE3zNm8aTxeCiV8meO
	Ha0nwlgZmujwVjnBERH+cNoxgSyhrHqhS4UgsEum28Ra/YVczVkIUjP+MTwgu7k+3cQ==
X-Google-Smtp-Source: AGHT+IEBrOs73t67jM5D59x0wRbutccRfF6WPF3sqzOkzosTDmoiWkTFVdPobFltUV6X43uEwQGgxA==
X-Received: by 2002:a05:600c:4594:b0:450:c20d:64c3 with SMTP id 5b1f17b1804b1-45381ae454fmr61492025e9.18.1750923304562;
        Thu, 26 Jun 2025 00:35:04 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e80f259dsm6692451f8f.50.2025.06.26.00.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 00:35:04 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Chao Gao <chao.gao@intel.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 02/13] x86: cet: Remove unnecessary memory zeroing for shadow stack
Date: Thu, 26 Jun 2025 09:34:48 +0200
Message-ID: <20250626073459.12990-3-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250626073459.12990-1-minipli@grsecurity.net>
References: <20250626073459.12990-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chao Gao <chao.gao@intel.com>

Skip mapping the shadow stack as a writable page and the redundant memory
zeroing.

Currently, the shadow stack is allocated using alloc_page(), then mapped as
a writable page, zeroed, and finally mapped as a shadow stack page. The
memory zeroing is redundant as alloc_page() already does that.

This also eliminates the need for invlpg, as the shadow stack is no
longer mapped writable.

Signed-off-by: Chao Gao <chao.gao@intel.com>
[mks: drop invlpg() as it's no longer needed, adapted changelog accordingly]
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
v2:
- dropped invlpg(), no longer needed

 x86/cet.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index 51a54a509a47..ce4de5e44c35 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -67,7 +67,6 @@ int main(int ac, char **av)
 {
 	char *shstk_virt;
 	unsigned long shstk_phys;
-	unsigned long *ptep;
 	pteval_t pte = 0;
 	bool rvc;
 
@@ -90,17 +89,8 @@ int main(int ac, char **av)
 	shstk_phys = (unsigned long)virt_to_phys(alloc_page());
 
 	/* Install the new page. */
-	pte = shstk_phys | PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
+	pte = shstk_phys | PT_PRESENT_MASK | PT_USER_MASK | PT_DIRTY_MASK;
 	install_pte(current_page_table(), 1, shstk_virt, pte, 0);
-	memset(shstk_virt, 0x0, PAGE_SIZE);
-
-	/* Mark it as shadow-stack page. */
-	ptep = get_pte_level(current_page_table(), shstk_virt, 1);
-	*ptep &= ~PT_WRITABLE_MASK;
-	*ptep |= PT_DIRTY_MASK;
-
-	/* Flush the paging cache. */
-	invlpg((void *)shstk_virt);
 
 	/* Enable shadow-stack protection */
 	wrmsr(MSR_IA32_U_CET, ENABLE_SHSTK_BIT);
-- 
2.47.2


