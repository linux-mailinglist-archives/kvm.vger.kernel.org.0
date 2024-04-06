Return-Path: <kvm+bounces-13808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05B5589AAE5
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 14:40:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3351DB21B4A
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 12:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F33B2E83F;
	Sat,  6 Apr 2024 12:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ESjwq3m6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADB04C84;
	Sat,  6 Apr 2024 12:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407230; cv=none; b=bvISg0e2jRngDMDkEbJu7jGsRc6YuhR6An5dOxKW998eMBYU7J+26zyTAXXkPynruQQm4x4sGZPmD2SWLNQJXTeDuE1ebquW/ctgPHTvsiXnT4GaxW0ImTsYJcj/SJ3MToUkXXcUGhwg1+6J6q88XHrfqKYSFPQDVK9LVkTfDVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407230; c=relaxed/simple;
	bh=FFft7ygHb4sNew26D/dJgFST62xDvyHht1DMBSvtx6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qiiyn+CdW8+qDZTRzvO8PJpXKaWIBjCjIWKcowIzwVs+qIytzkTpO89S7CuQZVxf0goyeYhn2fhult6VoD+JWvldo3DJbfVLf/nNri76xLFAJA1obRZXC4qKGFr3T3WmBpeyXr4FrUId4MgmfXqCOXuvw4PRlEEA731HWafcIQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ESjwq3m6; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2a2e5d86254so1731584a91.1;
        Sat, 06 Apr 2024 05:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407228; x=1713012028; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DtN3qRr/BJ5ghrfuBVmkjt4OGFVHY6H/GotGGIKP5Pw=;
        b=ESjwq3m6RGKkkfq4a/ddZX7IvMzSFEeywSpJXdmGS+OAgzA06GW/8mlGWyDPDkoSfO
         I1adyOH+qp5VYdFvnC0FUb5LcrIirDYrVDZ5cuYCR7DMlaRkLNGmvSa/AcmXdv3Dw/jG
         YyfFFVSDY/dRIr48YuQHm5Kxh7s+5E+Pr31vPyKEjHjqhy2IUrIj9pfFghVWTq6o5cOd
         mzsvetsXeYg/TAblGMdz24/gugd92GQD6jmw1HFWmoqsWJrRG1S7w/zFQDxVqPS8QMox
         OxfW3zH7KsVBMjOREO8wA+/NwUMhWYgEupuSq/kqSsCfBD4ks8URgHA6JKmqD/tx9Trx
         mNUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407228; x=1713012028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DtN3qRr/BJ5ghrfuBVmkjt4OGFVHY6H/GotGGIKP5Pw=;
        b=eaM5tngs2Nz9SkljKk/a/Nl2YZNTSFMheGe1Kayxntj1a8wryg2g6DK4/q8gae61fW
         1oipeFzLQOm9iUZHxXI1IK6XHfNODDyqZYYjsunST+wO0/LvA4P6BlciYO1jqjICAFoI
         DP86J4HCam5NmJyW+wY5626suGYjq8pLjVkLCOTqK1/TfwyhF7KWtZqqAawitCo0Tn0P
         5K6g1TIG94JDmMxBvB5okQ5RbeDgmCtCj8pLOS3xTnsIOkUy7DZeb+B/Bj4KdpkoqKwN
         YiYs95tJ1DQ9akNxPBH55XI8U29osBA4M0oArOSigkPIEV88PjyoGlyJsmNAsoVwjUHL
         /fnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJ+Vf+IY2UG4jM9LcojM08bPlY0oG8EH1eFKUX80J3OIlk6Gqi3pAMmX0P1Ph2V4VlVYD4SwfutNj2E13DY4H9dC7RGu0Dqq7Zu+wRgAe3qr2ZbC3snJepM92VUs+NdQ==
X-Gm-Message-State: AOJu0YymxdbRe+LdsMFTKzP96v3Hszh5VMXjJc1DGluzscY80xl9+fuy
	2+1cLN7luwRTgi6iDeyFvI6QCcFB5+dx11sunNmLHbcW2IezkEVE
X-Google-Smtp-Source: AGHT+IE7xfGD09MIaUCfQ0PlF2nHZILjJWkZ4PfKwm4uXDYYCAtdwhtHcBBozUYIc7FVTGi7mIF6mw==
X-Received: by 2002:a17:90a:4e06:b0:2a2:c812:9648 with SMTP id n6-20020a17090a4e0600b002a2c8129648mr6948766pjh.9.1712407228261;
        Sat, 06 Apr 2024 05:40:28 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:40:28 -0700 (PDT)
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
Subject: [RFC kvm-unit-tests PATCH v2 11/14] shellcheck: Fix SC2294
Date: Sat,  6 Apr 2024 22:38:20 +1000
Message-ID: <20240406123833.406488-12-npiggin@gmail.com>
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

  SC2294 (warning): eval negates the benefit of arrays. Drop eval to
  preserve whitespace/symbols (or eval as string).

No bug identified.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 95b6fa64d..98d29b671 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -179,7 +179,7 @@ run_migration ()
 	exec {src_infifo_fd}<>${src_infifo}
 	exec {dst_infifo_fd}<>${dst_infifo}
 
-	eval "${migcmdline[@]}" \
+	"${migcmdline[@]}" \
 		-chardev socket,id=mon,path=${src_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control \
 		< ${src_infifo} > ${src_outfifo} &
@@ -219,7 +219,7 @@ run_migration ()
 
 do_migration ()
 {
-	eval "${migcmdline[@]}" \
+	"${migcmdline[@]}" \
 		-chardev socket,id=mon,path=${dst_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
 		< ${dst_infifo} > ${dst_outfifo} &
@@ -357,7 +357,7 @@ run_panic ()
 	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
 
 	# start VM stopped so we don't miss any events
-	eval "$@" -chardev socket,id=mon,path=${qmp},server=on,wait=off \
+	"$@" -chardev socket,id=mon,path=${qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control -S &
 
 	panic_event_count=$(qmp_events ${qmp} | jq -c 'select(.event == "GUEST_PANICKED")' | wc -l)
-- 
2.43.0


