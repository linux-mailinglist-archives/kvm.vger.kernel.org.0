Return-Path: <kvm+bounces-13686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 026D28998DC
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 11:03:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7BE2D280F27
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 09:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67CC8160786;
	Fri,  5 Apr 2024 09:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EHyOLtcr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D8F15FD0E;
	Fri,  5 Apr 2024 09:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307746; cv=none; b=l47WWLPGZSI/oxqEbXmXzoZxj8aWPAIqusYrywDWDF53JBCKIyc7GDkKBh1tjtntoZ2sWsm+JhuElq+i38lyHLS9Cu/CR3zn0zjuZ5EYVdfZ+VYRO8g3tST3uq8ndgaah05JvWH1xBbo2HzKJfFaygyOi+ZhwLnKtVZOLJ/YF3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307746; c=relaxed/simple;
	bh=5GeQjgmyuUTE42hH1s2QbxPN2QS1tsG/7YB+V3jiAPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTyXJSDmOzWLEHwZXaPgPV9ZDmTjiiymOBuibYi42A1h4UqAKtj7vb+5gKfXuNTurrGMt0rClEWXI1r0077Zs9mtKPxHf6hugfnLUJwuCuwzWCfqnsHUeIdApb4yLnMzFRAYZTNZazbOkHE+qjMHSih/nlVZU0dAHFy5hBt0yco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EHyOLtcr; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6eced6fd98aso1444416b3a.0;
        Fri, 05 Apr 2024 02:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307744; x=1712912544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pxe6HTJDpXeWz+A4d/z3W+WfFv5s26i6kZ8vmOxuk2w=;
        b=EHyOLtcreR/mRZyaA43XoD4o8qt6RHabd2yYQzjlj6SQ65jUSrV8ktnTQLQcxLbePZ
         dK4FPiGTjTNpjOIOb69n9oIOgwm6wf+Z/xohaMHxyWaWQnHxTpV+ZNGQlmGvdMCaCgFa
         HSL/jSLqsbwdJURas9epAYeIOEDOItE+jbtPsdEx9uIk1hgCyUK4v0GMRp+rjoBl9WaH
         mtIOjP/AqWyDWevII2aRFDtcEP7Ra2awzpNA8Pq5yfkJKrf/Vzg14io6JIUVaKCE75O0
         Wr5yYVFpHa3rz9+zt4pqcV89B2rDuIjHobatoCcLPAffq5Ar9QPIUjhQLDz/VNfF8VZg
         mqWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307744; x=1712912544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pxe6HTJDpXeWz+A4d/z3W+WfFv5s26i6kZ8vmOxuk2w=;
        b=oWFlL70G0+PyPHc79fNM+f9h5dXL7PTTNtYEqp3ct/e0d5XQk50Imfu5Yd2nylwXE7
         paEQSJSF/lnb0OQRB/PRhdmmWKcXy9n+mYftqTMDhOXWMGOF5ollENVHI/qgkw4lXPeO
         eRsXJOYWduE2qQ6WO0Wu3+7lLZ/riYpUm2t8Qgy5fjZouuuluGBFqxAbPVavgba7hesn
         CtRSdTDRTsasv9grSRTYG9iKzjtkuUGHpzXV3J+N6+I+2kpLSnUg/VZb0ma8QN3cTo23
         qO0z4YDmtWNsMfroXn2VCPJbVRaINwiXUsb4CaUPX2i8A0m5mMO/W3MhVn1r18/jGfsW
         g8mg==
X-Forwarded-Encrypted: i=1; AJvYcCXVRJrthN1yfpquG89gdMru/JEFxYwRLOaImqHsXs4kKY+vCF9OUVzldsb0XExqOVdzAoYyRpdSeR9SjfS0GDkqEaAaYv0ZHgeBtiHPTWn1edqkrTqcjcYCpf39/8wRQg==
X-Gm-Message-State: AOJu0YyFW2ikwgiOBpjpS02mP4R5hCZlXFg7WapLxonWRF4C2pS85X6Y
	ZCoCvj1iM+yWvLok7npg/jk7QkKsjoqGnLSUg29CtdWiNNAztN93
X-Google-Smtp-Source: AGHT+IFi0wcgnFzUT48JpEZlFnQyd03or96zaStrZ3u3axPTcX7D20CB8PvzKwnmjg2fzqLkBgB2zA==
X-Received: by 2002:aa7:8893:0:b0:6e5:faca:3683 with SMTP id z19-20020aa78893000000b006e5faca3683mr1042054pfe.26.1712307744654;
        Fri, 05 Apr 2024 02:02:24 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:02:24 -0700 (PDT)
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
Subject: [kvm-unit-tests RFC PATCH 09/17] shellcheck: Fix SC2143
Date: Fri,  5 Apr 2024 19:00:41 +1000
Message-ID: <20240405090052.375599-10-npiggin@gmail.com>
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

  SC2143 (style): Use ! grep -q instead of comparing output with
  [ -z .. ].

Not a bug.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index d1edd1d69..9dc34a54a 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -61,7 +61,11 @@ run_qemu ()
 		# Even when ret==1 (unittest success) if we also got stderr
 		# logs, then we assume a QEMU failure. Otherwise we translate
 		# status of 1 to 0 (SUCCESS)
-		if [ -z "$(echo "$errors" | grep -vi warning)" ]; then
+	        if [ "$errors" ]; then
+			if ! grep -qvi warning <<<"$errors" ; then
+				ret=0
+			fi
+		else
 			ret=0
 		fi
 	fi
-- 
2.43.0


