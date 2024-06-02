Return-Path: <kvm+bounces-18588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C6EF18D758D
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2024 15:07:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 64F551F2224E
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2024 13:07:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36F403BBCB;
	Sun,  2 Jun 2024 13:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LwrdDJfr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D0F10795;
	Sun,  2 Jun 2024 13:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717333636; cv=none; b=DNisjap/gerVIBqvyb5gOesYE2HQurWsW/iX1ItK8MSGEyr0BsZRM0PdgsPLqqMXeqDpci3yM9HzBOyfXWVFXQU0UujdxNkAUhiz7c1NupI0h6Go/I+aew6j/hReGFYO4gKTPtVkm7ilKCts1dtn8Lta2hvaEh2P6vO+77bNgyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717333636; c=relaxed/simple;
	bh=ZUHICodxKLHcGytgkDk7+KBk2k1vqHUHM7dveNF5/hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRA87kodTk/DPulwnOlWWZHw9r/5gTbRXiK643c2pEOu5c5EBVW4dLd8/h7LAial/W6dHJr9b7QEa6CAllxQjyyOZfOwXAK+zCFPz0ENJ/CPN+5Rw/xSNU2JZmmqXotN8eU042mMpdjnm5SRtG++njxxFchK9lcwvXkh7RYl81M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LwrdDJfr; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-701ae8698d8so2688390b3a.0;
        Sun, 02 Jun 2024 06:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717333634; x=1717938434; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7kbHiMK1inuLj0pOdGvpJ+rvlSH9E+ImoorzfUp0K1M=;
        b=LwrdDJfrleFxCokhG5PiFRZLEoMrbPrNQ+vUurxe89KGMxBGcltu/ec6eKXU+qbj+6
         xu2vP7kWA5OEhR/AArz2b/xQNW/kfWYkr9soAaE7Th78/6DQobgUh1gas9PNAwcj8UKU
         8O0/CAxvONX4FPfmAm2INqZH+rJy6NB+76ihxMhclR9/SnvLlF2f3PH4St6CBYmCV1ea
         MtY0lpryuP0dfEK+laa8tVx3NzutdWUWlSAKbYXZ0/+CViUE+Pe0xmXIZkpJHHUJWzde
         pYfD8CiE7taQT/G5zAHtIUMSWUYk5MRufH1B2sxdohXHUN8WnEieJsgMjmjSApiJVdBg
         hBnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717333634; x=1717938434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7kbHiMK1inuLj0pOdGvpJ+rvlSH9E+ImoorzfUp0K1M=;
        b=Nck/05KHyqpa8TmbOHEA4BO0Uj2uRujDIlUPvGy8olWffVh6Hoh/Lp3dVZoAPlUXJA
         YJrQI70C99WxiCHUhBKWcxs9tObWy+uBwP/uxRaq1Yen3Mo1fASl7HLWjzc3Ug/JwMwb
         8LC/7F+JqggOifaFin1789QGJC16yscr5q2vTJdFsDVH8w3L775DZtkn228NsT+fbprx
         pRfiR+ZrZlPLt9dWfjZbnhjBLaVUC+8WYZxhxDKpCfYiUbBxBxS1aUVGkTR3O0fdTXqT
         /EAoMFmP/r1LW80UB2Ki558yyN4k2mKw6HQJd+QChqebtTlp8jzNJF9xdminnhzsAj1i
         fxDg==
X-Forwarded-Encrypted: i=1; AJvYcCW63zwPymC3KoSRBMRzS32kAyYoDXOOm0gWgPmz9FV/3J2iclbJ/3WLvZBoQqn0oNHiu41m/4S2rtNwNjNbDnruvzpz
X-Gm-Message-State: AOJu0YwbLk2yoZh2vLdOlZPstgYrJEa4LtOx9oRRhbbqy7gA1jQzK4cJ
	FWhtWMYm55rBkkTSNrwmmh3O8DYu3R5NG8wyr0LI9ht59g9BjeGWxgPscg==
X-Google-Smtp-Source: AGHT+IFFnTrpdso0rZP5sjXPVO7GWyTiebsPVzyuVwhUAHKlB9TerM5N7o8fkWpwdDrlhX1+pDIT1w==
X-Received: by 2002:aa7:8893:0:b0:6f3:eaa2:53a0 with SMTP id d2e1a72fcca58-7024789ca9dmr8316315b3a.24.1717333633799;
        Sun, 02 Jun 2024 06:07:13 -0700 (PDT)
Received: from wheely.local0.net (110-175-65-7.tpgi.com.au. [110.175.65.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-702423cf27fsm4138655b3a.12.2024.06.02.06.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jun 2024 06:07:13 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: linux-s390@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 2/2] s390x: Specify program headers with flags to avoid linker warnings
Date: Sun,  2 Jun 2024 23:06:56 +1000
Message-ID: <20240602130656.120866-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240602130656.120866-1-npiggin@gmail.com>
References: <20240602130656.120866-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid "LOAD segment with RWX permissions" warnings from new linkers
by specifying program headers. See 59a797f451cde and linked commits
for similar fixes for other architectures.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 s390x/snippets/c/flat.lds.S | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/s390x/snippets/c/flat.lds.S b/s390x/snippets/c/flat.lds.S
index 468b5f1ee..6b8ceb9e0 100644
--- a/s390x/snippets/c/flat.lds.S
+++ b/s390x/snippets/c/flat.lds.S
@@ -1,5 +1,11 @@
 #include <asm/asm-offsets.h>
 
+PHDRS
+{
+    text PT_LOAD FLAGS(5);
+    data PT_LOAD FLAGS(6);
+}
+
 SECTIONS
 {
 	.lowcore : {
@@ -29,7 +35,7 @@ SECTIONS
 		*(.init)
 		*(.text)
 		*(.text.*)
-	}
+	} :text
 	. = ALIGN(4K);
 	etext = .;
 	/* End text */
@@ -37,9 +43,9 @@ SECTIONS
 	.data : {
 		*(.data)
 		*(.data.rel*)
-	}
+	} :data
 	. = ALIGN(16);
-	.rodata : { *(.rodata) *(.rodata.*) }
+	.rodata : { *(.rodata) *(.rodata.*) } :data
 	. = ALIGN(16);
 	.bss : { *(.bss) }
 	/* End data */
-- 
2.43.0


