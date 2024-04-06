Return-Path: <kvm+bounces-13801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 13BF489AAD6
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 14:39:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A909C1F219E6
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 12:39:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFA342869B;
	Sat,  6 Apr 2024 12:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZwRTw6rg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F3A2AD02;
	Sat,  6 Apr 2024 12:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407168; cv=none; b=uIKv+H8+3C0LhXpubKo82yBxUYQqoWP4psAWEXbDxIzT0e1thCXY0V9JXEPcHPca/h4NsNL1sJv5nvBlTtMnX3USxHTfRqzG5Juhc7sHMDEJQLxN/mwtQCnT1Eqq/qNkv/mXhR9SEyOdhCOgrZLa6sy+E0JJHocOm+mkgev+fOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407168; c=relaxed/simple;
	bh=f797ca6qmLUHud4LT+RvBvCcJQO+xBNS9IZWMtZ/PRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQNMh7Bh1OVtiLKbK69qhiA2hMp7u+ofht52KZw9YcMJbIqrzXXR38vNZQxOH1xJw38awv9cwoBbhkBwudOyNInU3wFl2/pNAHuhQSmIU0a+U0ZiR7M7ufoMCe8u/PLA8Cbhs734jtjHfM3ZLzf8R0XcMGXqHXpckwl18BjTSh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZwRTw6rg; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-29ddfada0d0so2184241a91.3;
        Sat, 06 Apr 2024 05:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407167; x=1713011967; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sB3ENgv8+Bm1tRLghaKazWKQeuX0gBEHcWKY2qfgh1Q=;
        b=ZwRTw6rgHQSCalaQkOgIVJBaOwaDkJ/omrQmWfDWY4w51uYTVWwdtBsZoqmXT+EWiX
         9Askl+gjSx4L/F0bZ+eMUSyCx0MwiRL/eB4l8xiS3XjA+718CkzJLnlq00G7Cg71EqXO
         unU5WQZbSzAaRPeg+DuO/G2AckebEJ1/TgsSzIym2mAkaUq4Lh7xHvjDRM6NKzGOmORp
         4/pwJ1tdlXJQL5qafg+fQIZO/VMnW3J9/k73xEYFbWElSznd0XsGp8VTgZuOjE6M9fTd
         VYp05FyhqBNXobvv0IEdcxQ65tAW4SuS7MjqGU78/yyQD6FRMXIK1JcEIB1lqmaOGlZ8
         hdSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407167; x=1713011967;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sB3ENgv8+Bm1tRLghaKazWKQeuX0gBEHcWKY2qfgh1Q=;
        b=w+py6tiugN8esPZbIdt71CyQPJF5Iy4hflPJoSZD/SOuOXYeHNnfMblnJfW0bCiG4D
         SSy3NKkI+qM8RhVM8ApsWiXWIoXNNAay9m7mH/IX1QZd5HjDR1zdg26oDhpTrIj6YvQb
         HmQVvTK/YOS3ez/xbkEZnl5LENHfombkYa882X4oKZaziSz6ETl7f4ZeVSCMcWwGGMc1
         5j/8aT2mFEIG5Yk88BPwpYQ4B6i1cNDELuQykaDmIkcGoqcSArd2nr7K8ZvuW0yRX6zh
         i4rRkAce2hKMMvz9P25j0P3bT2AnXnKsHDwHKfIAxw40iL2Bzeiho9WbGg/L6IMckhPD
         vwYg==
X-Forwarded-Encrypted: i=1; AJvYcCWblGhOsiefCXqfkd4IEaWLnrQzJK/pb0IfkrZYgegKNc+MXJij9S1T3dji15KvUHx+5Akq1ZC8ttzE1b1VimYKWRINollwQCyQ15djI9maIXqVXkMMtAxDHK2l/aL1KQ==
X-Gm-Message-State: AOJu0YxmsGo7g9mrSakshxnGCXJc0s8gq4smTQYDOkbvjoeqTntsRJAC
	LnHJfUL2vC6jilwUnmbx6iaoqZtG+pFs1Xhpkp6dhvXrHg+oMWoW
X-Google-Smtp-Source: AGHT+IFsGkW61gbRnUwX+F4+qiUlZL7gQ1ZtjFZ3/rMtUrfy5XWV8+BO9FE9c5M3Fd0JMQ+twYXJKQ==
X-Received: by 2002:a17:90a:1fc9:b0:2a2:1900:493 with SMTP id z9-20020a17090a1fc900b002a219000493mr3185800pjz.40.1712407167008;
        Sat, 06 Apr 2024 05:39:27 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:39:26 -0700 (PDT)
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
Subject: [RFC kvm-unit-tests PATCH v2 04/14] shellcheck: Fix SC2094
Date: Sat,  6 Apr 2024 22:38:13 +1000
Message-ID: <20240406123833.406488-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240406123833.406488-1-npiggin@gmail.com>
References: <20240406123833.406488-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

  SC2094 (info): Make sure not to read and write the same file in the same
  pipeline.

This is not as clearly bad as overwriting an input file with >, but
could appended characters possibly be read in from the input
redirection?

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 1901a929f..472c31b08 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -492,6 +492,8 @@ env_file ()
 
 env_errata ()
 {
+	local new_env
+
 	if [ "$ACCEL" = "tcg" ]; then
 		export "ERRATA_FORCE=y"
 	elif [ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
@@ -500,7 +502,8 @@ env_errata ()
 	elif [ "$ERRATATXT" ]; then
 		env_generate_errata
 	fi
-	sort <(env | grep '^ERRATA_') <(grep '^ERRATA_' $KVM_UNIT_TESTS_ENV) | uniq -u >>$KVM_UNIT_TESTS_ENV
+	new_env=$(sort <(env | grep '^ERRATA_') <(grep '^ERRATA_' $KVM_UNIT_TESTS_ENV) | uniq -u)
+	echo "$new_env" >>$KVM_UNIT_TESTS_ENV
 }
 
 env_generate_errata ()
-- 
2.43.0


