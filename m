Return-Path: <kvm+bounces-13684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 807B38998D8
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 11:03:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39A3C282CD3
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 09:03:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FD7D16132F;
	Fri,  5 Apr 2024 09:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ow5h2Pok"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D29E16132B;
	Fri,  5 Apr 2024 09:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307729; cv=none; b=hz2w0BoRytnBDvTMQfSUL/Br3l2a1rLQBxA163+vD85IgQTfW2FnudytgSMGLHaMrFaK5QWACtZZiarSqh72iOfU0csfsJJG+w8nSSybNIPouoUGANzogNxw3ojtNz6MbfYCJC5kuUn0/1YFU8G9wisDk6K2l4vbICNDocaqTwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307729; c=relaxed/simple;
	bh=47fkLuLqHEZtB3S2cnlevqOMobm0CWU9n/5DYYSuwNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scN9tU8JgBEsIUbYB329DoweuMQlVYGW7cuxtb6osBCCzsHIVGoaai59LuQEmlMhV8PtcHPvEP9YWS9y1ssLG5twb/uUfsTHurFerxd43w6gcnfP1k093ZgoHW1O4VyJWsSctOUGrdB1QicNY+Tf/gijGte4hXKn/rLWxT2sjy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ow5h2Pok; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6eced6fd98aso1444146b3a.0;
        Fri, 05 Apr 2024 02:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307727; x=1712912527; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XTMqAyJBqz4rOiSgRtnzTZtMbx0voGPftwqzEIUfG30=;
        b=Ow5h2PokgtE4EVhHS/Enlwt+Af5b1KmE3sG5ugwpnRmAwI8tJ6dgRAp5Rt/lZv8qLN
         Mexus1oOpdHk13H3aPR4pyOrkmdwoJQ9S0tKyJXVBp478/hm15uuggqPAJOIYPJd2Hbg
         WnQ+RT+ADghdTtixq/aTDt2f5N2OAffWgBdg6CsISgS/Z8FRMaSZzNCOdJF3kB7VLpfc
         2NFrd1AcAQiOCeLcK8SBF5EBeGMW3pVkxlL9c7s0i0J/WNuwfqlMk5fHKFTYh5Y7F4KZ
         iQQKaqEIEMp1xC9rbbLYSyl/+DUHUHmYuQasmsyUraV6Tt5UhRAPFEMqQGJpSET7T7gE
         d6Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307727; x=1712912527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XTMqAyJBqz4rOiSgRtnzTZtMbx0voGPftwqzEIUfG30=;
        b=lxL3aSWp5B4LduI4vtHRCWAB1GDwaZUi24c7AM2Q5rhMbeDDEdigB4Ar8eSnx0sUCc
         g8EhqUCXRlnHqhjIV6yCVE7x+tFcZYtWwLVM/BpTJxtv24JIntskJO/KuylkZYOqz1Co
         O/ky3VxWzhLHK5OoP6JXSjTWpY9mLmmwzZ2jgC3l7dp868LSsOxd5Wygz8/uR2CcIaHB
         srKqMInBDpPKStLKHuZMLbN39B8hEypmwvpmImGZ2E7+ypaeU6if9VRlAAfQfBl5CuRO
         8kNEFMYt7TW7xQ3iawWSRFliPCx4+vhvH03CvYVPm9Bcg2kSJENgQSTEUzAhIw4hQ9k6
         5mag==
X-Forwarded-Encrypted: i=1; AJvYcCWP8nxBoZnreuF1lFINeUykWG3qIEBbP8LrjT+S2nbTyQyxRNyXZW12EC/64ZSTsXpXauk97o01VnSicjw42xyR9PJafclb71NS+AGCQFLQRsDWYLxzUOOPIF3F3CIHwA==
X-Gm-Message-State: AOJu0YxdbWbB+BI92qjOqljSQqSVPU3gsYqJvn6xyVso/BQ3oplKx5kg
	XT1roGfMF46KBqBWIt+pBVOIlcZUqUmAPd9sR4ox3gdu7AbgeIC7
X-Google-Smtp-Source: AGHT+IEXfc3N1ZI16wRWq13BpZo+ByZPJ7Mm8iWXe4JP9NepPrfWkfcdQ8IrIrN/6TID9n4Pw5Bi8A==
X-Received: by 2002:a05:6a20:9785:b0:1a3:a99c:cd4d with SMTP id hx5-20020a056a20978500b001a3a99ccd4dmr926415pzc.48.1712307727470;
        Fri, 05 Apr 2024 02:02:07 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:02:07 -0700 (PDT)
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
Subject: [kvm-unit-tests RFC PATCH 07/17] shellcheck: Fix SC2235
Date: Fri,  5 Apr 2024 19:00:39 +1000
Message-ID: <20240405090052.375599-8-npiggin@gmail.com>
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

  SC2235 (style): Use { ..; } instead of (..) to avoid subshell
  overhead.

No bug identified. Overhead is pretty irrelevant.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index ae4b06679..d1edd1d69 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -580,15 +580,15 @@ kvm_available ()
 		return 1
 
 	[ "$HOST" = "$ARCH_NAME" ] ||
-		( [ "$HOST" = aarch64 ] && [ "$ARCH" = arm ] ) ||
-		( [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] )
+		{ [ "$HOST" = aarch64 ] && [ "$ARCH" = arm ] ; } ||
+		{ [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] ; }
 }
 
 hvf_available ()
 {
 	[ "$(sysctl -n kern.hv_support 2>/dev/null)" = "1" ] || return 1
 	[ "$HOST" = "$ARCH_NAME" ] ||
-		( [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] )
+		{ [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] ; }
 }
 
 set_qemu_accelerator ()
-- 
2.43.0


