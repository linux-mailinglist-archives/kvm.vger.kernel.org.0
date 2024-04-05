Return-Path: <kvm+bounces-13680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 009578998BE
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 11:01:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 329251C21090
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 09:01:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B50C315FCE3;
	Fri,  5 Apr 2024 09:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YgqljkMQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D0413D290;
	Fri,  5 Apr 2024 09:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307694; cv=none; b=JRsuxRZLw6Fo4YOa9liqxYyfgptLZlNx2M1P48rAtXAuKY5wBrstTuQ/s4GXWRLA6Z8r8iYifUmXgzXnbkFKK/ZTPKNTilq48AEDGrOhoM8hHBKmXq7AobFRfKjufCahVgE1FxSpyvNArqD90MsO2k1bXl6GqergwO9q5PHq1uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307694; c=relaxed/simple;
	bh=iorWhAXzDkMgXS5/h1dXUFesPq+RiQ56mLvxEzBdjLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ilk/gbr44Cph3rQ5rTEXb3NV2/pFH/q3WgAC75oLZf3YnFaBBdvRsVIx1J0A/YUhfrAZXP4+TiRE4PlZitbZdnzoFV2w2Ip0iHrqN3vwYSpUSa7HazGZ8ya9Oez/ztpScBgg53xji6hX5+WZWdxbGjMRlYSE5Oz6nbKCuv5nVvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YgqljkMQ; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6ecf3943040so961514b3a.0;
        Fri, 05 Apr 2024 02:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307692; x=1712912492; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OJFizl9fM2o773KG2KC0tcguyLSt89Cu1ul3ajDj2fU=;
        b=YgqljkMQxl4rnBZCTdSTPK8G8OOLJj9Dv0aN/p9jwR1zSEODMXNAnqXfIkWMVLZ9Pe
         aZNULXj92+wm68626fcwQnxc605ntnFCZHRiXFpADvY6v/ouYJu2roVhSRBSaINiblFl
         Yzq9+SALr67Va6FwKbmdzD1ZcyzLTdG5zIJ5U/s5uY4tI76vtRvB1D6P+kTaZReUW5xX
         DrS24hDij+OSQW4yPARUXMeLDQAzetbOFKpk9Un2njHI4pBKVyx0hneXc/UvUeHWIxY5
         mR6l/5yFvtqnBboZPwGZZswxo1iFqXOmauoLOMcSbsPSXGAbk4ZnzrRICEWcDTO0gfiR
         z1Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307692; x=1712912492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OJFizl9fM2o773KG2KC0tcguyLSt89Cu1ul3ajDj2fU=;
        b=k9X5kUO2Z6X/6Qo9pgWUdp5ELBtUQZvOzpXj3TdcWQsx9+skcTi9jrViQOqwQ4PovT
         q4pmBoSaojBHkWYpUsxcdkEOcdi2ULHVOx3QIQKEgNoFPflQCBBgHFnaJQxuXfk6pUu/
         fCa/hJtEJebGkxDzkqSJZnzqOQvsmoIOTcH0P4LegXDxcEqjKuMEKu2ghygzsuYRXNKI
         JNwpj69p6nCEds9P/kSoU2X9NuTqICic9vGQWbKrW/KR/LOwoNNfGqVc0nV9pMVBKUrI
         ZI6HbdBxqnLJTb4DLmAo8KAj5CPAdpEJPEbEdi90+Xwx2VvCFSSJ7HozMpOeCFYLaet9
         96dA==
X-Forwarded-Encrypted: i=1; AJvYcCVTHWYvdNbVFGqd/tczlXZMU2KSNISK6bVSeujaszguumMJQwritnWAv6Yoseth+tU8qzJh4hZ38KjQ0Bs6yBPoxGGzyPbtyFfkDKoGjLYprhENQPeLfov+tDJj5WrJCg==
X-Gm-Message-State: AOJu0YwcunrR4GaAFJP4dkwFhG96Jj20oiuyyZDrNr8I4J6SNtXg8tK0
	JEufXkds5z3HGUz/+tAvXha6SGQnFYaEKv68BDTEa1HQmH1T+YFQ
X-Google-Smtp-Source: AGHT+IFwBaywWHmRGfwbcmA9HRMJtA9TMzs93GW1jGz92SN7GfW4oW/+SF2bpNq91FjZDkLQnrluFw==
X-Received: by 2002:a05:6a21:9996:b0:1a3:55d2:1489 with SMTP id ve22-20020a056a21999600b001a355d21489mr1063196pzb.7.1712307692560;
        Fri, 05 Apr 2024 02:01:32 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:01:32 -0700 (PDT)
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
Subject: [kvm-unit-tests RFC PATCH 03/17] shellcheck: Fix SC2295
Date: Fri,  5 Apr 2024 19:00:35 +1000
Message-ID: <20240405090052.375599-4-npiggin@gmail.com>
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

  SC2295 (info): Expansions inside ${..} need to be quoted separately,
  otherwise they match as patterns.

Doesn't appear to be a bug since the match string does not include
patterns.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 run_tests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/run_tests.sh b/run_tests.sh
index 9067e529e..116188e92 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -99,7 +99,7 @@ else
         local testname="$1"
         CR=$'\r'
         while read -r line; do
-            line="${line%$CR}"
+            line="${line%"$CR"}"
             case "${line:0:4}" in
                 PASS)
                     echo "ok TEST_NUMBER - ${testname}: ${line#??????}" >&3
-- 
2.43.0


