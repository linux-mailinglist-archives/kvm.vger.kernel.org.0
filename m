Return-Path: <kvm+bounces-18585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 72A138D7556
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2024 14:26:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27E141F21A8A
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2024 12:26:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 270733BBF6;
	Sun,  2 Jun 2024 12:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L0bn7OOo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185773BBF1
	for <kvm@vger.kernel.org>; Sun,  2 Jun 2024 12:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717331184; cv=none; b=uYvSs4o+ORc2zviHamaW88rAPx7jcC8ZnS7xwDiTpS4RxgQQrpr44GfmAk+DJ+IXLFJLO2pI7hu1cpnNAS1XgGcztDPgahe3sm9vmMREjyScWUD6JXe83n0nwVzE/uTa+k5rIa3Qkjhio0ntpe4yuhlrJiAXKvqZLVaF76OHvg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717331184; c=relaxed/simple;
	bh=twgV4D8fcFPyldpVqsWOheV5XcPjZqxLc6kivXVKvCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2VsdoAZbUmHNOTDq5PoKXVdlIP0MVLiz29nxbaZq6Cj4KqvvSdBeWpOghHdPRO7O4/D6xdLDdk8ycAIz93+TX5Vwx4t6a1nehT8WBdc6WS/W+ixO+5ffeMbtkxrT3pO4oLxDfobI/oPMbNDBDpnhsSHoe2zC9/4/PrwcnMi/88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L0bn7OOo; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-681ad081695so2433301a12.3
        for <kvm@vger.kernel.org>; Sun, 02 Jun 2024 05:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717331182; x=1717935982; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oTUSs4lOqKqsTcBc/80zqv5xqWnxY0ATi5ZuSQV9qm4=;
        b=L0bn7OOoWsjF3LvxJRD5PTuVCbBqesJyRNPVfZrTALlFCKZDbPX4IZcCsafGI5yV4V
         02X76jUvyb0Ui0F2DE391qGAuMCf+IcjoWs8HuGK3iEwzV7edre6Z0TxQ2655+FSS7vt
         qJZ96n+i1LoHgEOKjfKS5/YV/f2Vodogz8u8+ZW1kJdjPY8tY3xoW41vGtpNV1xa6GcU
         2xJqw1jqeSR67qxp9iwXXLkcH2vK5XNK5rx75JlxokEXtCv4waUyZiKNus7q3Ac859YY
         iw18KR70n6ETc2eQJuORwY2c8pq72/n72r9XjVQbaQWWujisUXQIYdaFZ94FQl0RsS13
         uuSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717331182; x=1717935982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oTUSs4lOqKqsTcBc/80zqv5xqWnxY0ATi5ZuSQV9qm4=;
        b=eTGXdmNpvP+HrUFUB7IPEKzDpGufzVWLqTGiF8cRRZsbx8u7SlvrXg/I1NRlpTBcYn
         UEFEMtsbGkM4QbZS27arzzQPT7ivnLKmYeAl2Vy7VMxwSfFEVs0hWzcKM+xpuU/pn4Sx
         RW7t9O8PCZY2vclZiAolsuWgF6/4JVTeMrF5n3f8lSF+TmC4eXOC5VT1Xe0iR+cHqA7o
         3miDdwghSUcrrwIKR38HpOaCgH1fzdY4wdVo7cHA/uCzA7ezHoMJ86toJWlYN+L2mpWD
         1W1zREZPnlVScJoz+WhbyrnD4+1WvZpDcN1Rho1znw2/M8HzRa/KXuuPx/TpfJxmLkDL
         OZkg==
X-Forwarded-Encrypted: i=1; AJvYcCWeD+MNNqR+3n3o6gTgzRPSb0qVowrOFT6PGo8I4uPnbTYs/oaiGzH6txJgUJ7tx7/Hrh4PXL9EUrZjFAeOarYTFVrW
X-Gm-Message-State: AOJu0YzrZiU5XMpRwwebxM0u+dNNSe9p47Kl9FdypKVGUhdYNpjyESaO
	HKFQw1jc9YBmBXjHRUuo2c231gD0F7eDY3a4i4+x75t8id3GKGZh
X-Google-Smtp-Source: AGHT+IGBd/TXYqfXRbsJw/MakgwRG+zCUog/ZxdmHLRVg9xF1CKnV6jnv8JLXjGuLsdfHgzU8sYZrQ==
X-Received: by 2002:a17:903:32cf:b0:1f3:33b:ff18 with SMTP id d9443c01a7336-1f636ff51d9mr75607115ad.11.1717331182266;
        Sun, 02 Jun 2024 05:26:22 -0700 (PDT)
Received: from wheely.local0.net (110-175-65-7.tpgi.com.au. [110.175.65.7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6703f7673sm7834145ad.210.2024.06.02.05.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jun 2024 05:26:21 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 4/4] gitlab-ci: Always save artifacts
Date: Sun,  2 Jun 2024 22:25:58 +1000
Message-ID: <20240602122559.118345-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240602122559.118345-1-npiggin@gmail.com>
References: <20240602122559.118345-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The unit test logs are important to have when a test fails so
mark these as always save.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 .gitlab-ci.yml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 23bb69e24..c58dcc46c 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -4,14 +4,19 @@ before_script:
  - dnf update -y
  - dnf install -y make python
 
+# Always save logs even for build failure, because the tests are actually
+# run as part of the test step (because there is little need for an
+# additional build step.
 .intree_template:
  artifacts:
+  when: always
   expire_in: 2 days
   paths:
    - logs
 
 .outoftree_template:
  artifacts:
+  when: always
   expire_in: 2 days
   paths:
    - build/logs
-- 
2.43.0


