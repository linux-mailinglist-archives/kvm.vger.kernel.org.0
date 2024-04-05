Return-Path: <kvm+bounces-13687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 65EDA8998DE
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 11:03:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20A61282E45
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 09:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFB86160793;
	Fri,  5 Apr 2024 09:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KzlUzlzW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD5B15FCE9;
	Fri,  5 Apr 2024 09:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307755; cv=none; b=CQi+7M4b94Nkbe/VutMaWU0qy269E9JRqpcmiwdsQXETk/hJ8V81vehs7SHUSnNj2LX5b53iDCLV28B+Ub9vF16V5p1wxVc/BteJJmdtYSuD5NUal+RRgqmH6jfqjqPFA9T+UDoIMpvMq/G4XYA9LxFkxHkV8UQHPxAj4fnAGYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307755; c=relaxed/simple;
	bh=2vv/IKl54+GfCSIelDXCPjWVEwwZrrCpGl2AJlVYet4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMqVm9rzU3J1eZeLF2XWPUSqKno/ECqZ/HI7ZW/nKPv6e8Mol0P1hMfALHEMRnG7bkpK++Cx/wXYcawMiKaXHk9VU95U+dMhq5L2W6ioH+A39BKf7OKUApTPTEHLC3aUGtItivZxMR/LcV1m+b3XwbmhUZhq+Uh3yGoHWR59ii8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KzlUzlzW; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6e782e955adso1797783b3a.3;
        Fri, 05 Apr 2024 02:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307753; x=1712912553; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FQyG6PJPa2DgRXJ6ENxjgOjT0GZyabu8ITbgcsO6HNU=;
        b=KzlUzlzWpUmG0Ix5/33JGLLNAItTxusnZ6XWuysOqZ4yezfUpxvCRM/uYGYgCBdVNT
         Hi6MTTdexYbUfFgHxiBjrY1kQ2K5Y4qyTLpA/gH6ueiN0ygIxe4cgYsNDi11tzVZ9ClA
         QuWf3oWZ+tfqQgGjA/VyjmBb0a8K1v324qjAcSM10AXu5PT/zftWs1u4DMkdZeSUhV+m
         Je3dZCiZl9bFCS5gdtfzskM96cej1hgGKBiyfkeE4IvS0is88SSdZWln7yGh4LA5EsNq
         BoPCUzb+adYTrwrDmFD0omfb/3HvCJ+XLF+MgIcMVNe0ZKCV4C3+Xu2sSv4rMUGdL69p
         TuWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307753; x=1712912553;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FQyG6PJPa2DgRXJ6ENxjgOjT0GZyabu8ITbgcsO6HNU=;
        b=cxkBCJyrAMyHBz/81YZCiHQ3WhWvdP7WsMEqjGYhfUHjOB58FfXgWTf1IukWMN5/LZ
         7CdvBwBHHLLjWXG+N+S6aSi+9y4T3CY71PgjzE5eabuo2iqtLQNLFMTprZzj2om4dfYF
         dd4DC1LMSuMJ+h/1fEeSI2TElwV9RyinUcI7DpvMYGmgs/2cMmr4Jdz9m6aMIiRfGR9t
         apKQGqFlVI9oeBtvQVJ6bBpq0nY8DoEGhY6sfy8gkTZ09AyfHerTs848SdDaFMRCOhwd
         BW5sE7v3dwM4C/gd9/pakiw7UT5A0eFY+/+RGF8NW+0a0Ym0b5uryMRoyfG79lWUl49q
         ibag==
X-Forwarded-Encrypted: i=1; AJvYcCW9EzwgffLJShsON2VlzWLYY2F5lON3tpXwnRfqMh74gYGJDAeElo6rcSDQw6IZWngL896sUCmxFNmHp78MegNhXHgiugnfU9BkDFi7uyQYART8J/4gtG4Lqlv35A872A==
X-Gm-Message-State: AOJu0YwfqHGBjIWThFHwU2Hfc3ey3mgDxBnFFFn4IC9Pkegn7sDPtDiM
	emecBDPRgGbHEalk6aPI4jKW07lI3eC9znJPPzyZYsunj0KKNzDU
X-Google-Smtp-Source: AGHT+IHhBxfSYK+gCHVhFCLwN0vh7vqzr1fhMMMTvd8dOdpq1OMcW1smOYtODZbfkK2Var8DE55FAA==
X-Received: by 2002:a05:6a21:1a5:b0:1a1:87b5:298b with SMTP id le37-20020a056a2101a500b001a187b5298bmr1072821pzb.21.1712307753391;
        Fri, 05 Apr 2024 02:02:33 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:02:33 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Nadav Amit <namit@vmware.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Ricardo Koller <ricarkol@google.com>,
	rminmin <renmm6@chinaunicom.cn>,
	Gavin Shan <gshan@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests RFC PATCH 10/17] shellcheck: Fix SC2013
Date: Fri,  5 Apr 2024 19:00:42 +1000
Message-ID: <20240405090052.375599-11-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405090052.375599-1-npiggin@gmail.com>
References: <20240405090052.375599-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

  SC2013 (info): To read lines rather than words, pipe/redirect to a
  'while read' loop.

Not a bug.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 9dc34a54a..e5750cb98 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -487,7 +487,7 @@ env_file ()
 
 	[ ! -f "$KVM_UNIT_TESTS_ENV_OLD" ] && return
 
-	for line in $(grep -E '^[[:blank:]]*[[:alpha:]_][[:alnum:]_]*=' "$KVM_UNIT_TESTS_ENV_OLD"); do
+	grep -E '^[[:blank:]]*[[:alpha:]_][[:alnum:]_]*=' "$KVM_UNIT_TESTS_ENV_OLD" | while IFS= read -r line ; do
 		var=${line%%=*}
 		if ! grep -q "^$var=" $KVM_UNIT_TESTS_ENV; then
 			eval export "$line"
-- 
2.43.0


