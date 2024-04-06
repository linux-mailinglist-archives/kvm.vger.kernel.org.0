Return-Path: <kvm+bounces-13805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D514E89AADE
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 14:40:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B24AB2160F
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 12:40:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0A1C2E83C;
	Sat,  6 Apr 2024 12:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kgGF8njm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5172869B;
	Sat,  6 Apr 2024 12:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407204; cv=none; b=bmYd/1jFKlzjYBxRo4fgnli17O22b2BsdDt9y8sH/Cjp/Jxgd8d3NK5OM1MvdeJ6ib211yJIqc1HZ5fR4kB9dPT1hSSkLClHbd3YXQl36ZXZhXjUQdxFiTzoEtGpBNiGmewNTU5GcXEosy0BruAJVjHlDXV4MnpKy3EoL+9e9+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407204; c=relaxed/simple;
	bh=C9hhWnwCALdwqG5WyS4H7F9rVkRx8HCoDY3R0fruCbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=niNJbG9aa+dE9APtX/Cw1LQVDu3yldzkC1mc8vE4SG56R5rXH/Uz2CBdVWacHYrwS6r1V8++MT1ECyVSxa4zVAzX0teI8Pqh0xHFJAoR0Gsu9TJq8balvDg8cxEqtcQzDD/3onxe+OfJlVYUSq1GSPmFoUnP4fW/aMfZB1QnyC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kgGF8njm; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6e74aa08d15so2359976b3a.1;
        Sat, 06 Apr 2024 05:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407202; x=1713012002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jc9Ns5Gs4d6EQrXAeFAipEGyYWBXJXNznus1Vgd5gEY=;
        b=kgGF8njm8BeaipAg+eCxdDOPU8APvq8pZqhnFfOKpIPlbUozoZbf9zAoYg4Lj4Sfwo
         rd6aUmtPb5xT2vH+/vjQNkmkmanurwr4NcBWposp2gLPaHZsJ1Haduq8x0dkVScuyoGb
         nEEXLDvY4vKSYMfcvyDAy3Y22s/5h/ysPhrB/9R8jehpKBBqlxIBUqz8WtAjyvVZ4mLY
         SuvIjHS0gPqzcLgWG8VLUlh4OnZlZEK7yFNIeZMYDvnhwdr7f00gzgKi1hfY4a3HPhLU
         0xep0Gvb2v697r0yoEwYO/hCSJLrTOVU6sIiysQgggNeOXIpzQU5TTP0xsJDP469RETS
         gXjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407202; x=1713012002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jc9Ns5Gs4d6EQrXAeFAipEGyYWBXJXNznus1Vgd5gEY=;
        b=Skgk5rNPQxlo1c1IaCi5d0vBSc2AZmaWVGLnNKtc62iANAP4a9p1vb/gyTUGO8avMK
         JRyHdh8+nZzTt3Ru35JdXT+RiFbbY5LibpQvq6qhqM2mNWTDCwsug/u4L/boI/dxBHSo
         2BDEe3TDo2jgMLY9oT82+yxDygwjzzxuQdowTHkIVAbw4lGRTMaDmumb7WalR7s+j484
         qdWDWrgZTtcv6xwaK1RTLURJYCGYygJbyTHrdDAgWWabsJg+dDpL3ipGPa/8VzLwjFbB
         qXhlLNzLUVINtf+rMqxZ4dk7g0zKUsyWtWr4fDIOKTw/ufLuj96S6wXEQA0pXJCM4bdt
         aHng==
X-Forwarded-Encrypted: i=1; AJvYcCVR33alOGCmjjn3CZ0GS0SYF4aGZmr9jeU9eljUGRL2JVjwfB5ghwa+ezKYZ/CFcVkKI6xJ5YtmOo22YfYb6dClAWY4RS1Y/Ju5LVx9nJ0hDCLh7IvtoNs+Ev5ueFav2Q==
X-Gm-Message-State: AOJu0YxWfp0ts/l4XkEP5iyFGApAdLuce/4XgkqRXN55GEhMVCtR/VnO
	SEhBXK6P1oU5VS24ApbTi5HfU4LhdJRRnuMhI5iFLy91bIpunHBL
X-Google-Smtp-Source: AGHT+IGFqwzSPVPQ9YT3jplB+7wqnHfvH8TCbOoaXrxURWMaPygGn8PVC/qsnNpJzSZ+kKAlRUuDBA==
X-Received: by 2002:a05:6a20:12ca:b0:1a7:c63:add2 with SMTP id v10-20020a056a2012ca00b001a70c63add2mr5190444pzg.10.1712407202215;
        Sat, 06 Apr 2024 05:40:02 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:40:01 -0700 (PDT)
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
Subject: [RFC kvm-unit-tests PATCH v2 08/14] shellcheck: Fix SC2013
Date: Sat,  6 Apr 2024 22:38:17 +1000
Message-ID: <20240406123833.406488-9-npiggin@gmail.com>
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

  SC2013 (info): To read lines rather than words, pipe/redirect to a
  'while read' loop.

Not a bug.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index cd75405c8..45ec8f57d 100644
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


