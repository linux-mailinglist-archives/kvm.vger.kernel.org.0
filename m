Return-Path: <kvm+bounces-13691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B26558998E6
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 11:04:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D70561C20F19
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 09:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E223115FA9C;
	Fri,  5 Apr 2024 09:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WwpZcVM2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A835515FA79;
	Fri,  5 Apr 2024 09:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307793; cv=none; b=DzrYd6W5FC1Ixp07mao2ExqoCqU0sOkU/zvtda0sruh0HXMFZZp9AqQNLY1OL35WslYCBaEM6ikIqDULZPhM7T4hLke6J1eN0WkUTxUvAypwPkINpD0b9Fy5/MepQSdxIHPtDCBRYSwjxLd290bnSfkA4bBCqUL7f2iDi/azhZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307793; c=relaxed/simple;
	bh=6p41UD/Qlbix35q2GMWXKkxcjMPc3SCEBB08xXaduLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oC7n8+TJZTlSel+MfnudoNr5EheowHM7wBVnZ1YhjSy+pko0XkkAuWjw5S8utKJCA/AgNu5p1uj+Jlonfgm5WC2wc3DjUKY9qhn9/oahnftns9f+rX1ASy9ABCfxBMGqiI3QFV82hD/vVcJrUB6bxG7B3ANwbJNy/7qnqOiyvBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WwpZcVM2; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6ecea46e1bfso1659893b3a.3;
        Fri, 05 Apr 2024 02:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307790; x=1712912590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R9jePsdBCGcy8FOcE4Dl0oxWEJ48LRHCUA6lv3K1JxQ=;
        b=WwpZcVM2pggQBh2At7BvrUGZyXfi390lQbCyxpvav3vCi+b4v71sJeQme9m32f1EgG
         Zvy4IV9Rtx/FkIMPPHqkGwetSBXFQLet70NiEshjHJrVcIkTuDHSgoRuMY+nFwitpadl
         LCwO+qPndKwQoV4/54gWQi7+ZTNbrfArHNJ31JxkCBYWUy3fbNEqOmKWHmgkeFBZ38eg
         RUNlm5ZqGVudwPZ1fRKK6T5H6ggVRl7mdGorAdgYZoyVuNWfvrMODorJLC8CnoD3WWgm
         rVmD/houT3y9dck1mpiioheVn9h9+29AEd/VSpLvBVBnshYnVvjx+gA8dqRIcM+6pIQk
         kRKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307790; x=1712912590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R9jePsdBCGcy8FOcE4Dl0oxWEJ48LRHCUA6lv3K1JxQ=;
        b=Fx5odcc41+6EAFJBHImAlok9zycqqOhmhom+lxhbLDfOGq4ZEmnQyHCUwLEYCHJt4U
         Hu3qvEk4WMPPDDlC7qh2V8iXx3EHGh92WWos1Dk2yd1SmpQRAS3FRQSDR2ZQZnqb+UKQ
         QXHMU9ud/w1YIMKXvWfzQWtr5iVv0jJMjcaE4WLq3hBp3JyQe6mQKWvOZlQm9/mdQ91Q
         T/M40rljm8RDz61sOVkKh2RVPUrSt226vF8fg1P3U6y98/3kSrdw2QmyYTfaszHnUbGW
         e5Tz9M/fuY2H1Wh2NenFYhqMtyryy4zMI3jPa4QpzLgSWS2ofJeNAV6R0Q7qLYAUUDuF
         aSAw==
X-Forwarded-Encrypted: i=1; AJvYcCVV3WRoywxxhw6aDSQfvX4QObMiZGEkGOgUvkQIAIAac9z4hTbpSKqKTOuVGgw6bXjIB9gegnK9J9Ar+3iMoBcRx9XtX+u41JTh7MdK0NGlxyKq7NGxgCR0uuUTzf5E/A==
X-Gm-Message-State: AOJu0Ywov47Wasbmtq838fJACNOtYLS6Rh2TdLxmpB/9zqTU8NXS1X54
	2SMOYtwMNzk8VFQQHqkaHNfg9SVrZNvCRLuRLbTXysdHYAXdu+OP
X-Google-Smtp-Source: AGHT+IEMEJ3nCJeD++W+neSnwL46t0FBmKBloHUglg2zIiLw0F8GdaDYwaaevNYobN9Y4Al5iZ2kEQ==
X-Received: by 2002:a05:6a00:4f89:b0:6ea:e31e:dc75 with SMTP id ld9-20020a056a004f8900b006eae31edc75mr827353pfb.5.1712307789932;
        Fri, 05 Apr 2024 02:03:09 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:03:09 -0700 (PDT)
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
Subject: [kvm-unit-tests RFC PATCH 14/17] shellcheck: Fix SC2178
Date: Fri,  5 Apr 2024 19:00:46 +1000
Message-ID: <20240405090052.375599-15-npiggin@gmail.com>
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

  SC2178 (warning): Variable was used as an array but is now assigned a
  string.

Not sure if there's a real bug.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arm/efi/run   | 2 +-
 riscv/efi/run | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm/efi/run b/arm/efi/run
index cf6d34b0b..8f41fc02d 100755
--- a/arm/efi/run
+++ b/arm/efi/run
@@ -44,7 +44,7 @@ qemu_args=()
 cmd_args=()
 while (( "$#" )); do
 	if [ "$1" = "-append" ]; then
-		cmd_args=$2
+		cmd_args=("$2")
 		shift 2
 	else
 		qemu_args+=("$1")
diff --git a/riscv/efi/run b/riscv/efi/run
index cce068694..5a72683a6 100755
--- a/riscv/efi/run
+++ b/riscv/efi/run
@@ -47,7 +47,7 @@ qemu_args=()
 cmd_args=()
 while (( "$#" )); do
 	if [ "$1" = "-append" ]; then
-		cmd_args=$2
+		cmd_args=("$2")
 		shift 2
 	else
 		qemu_args+=("$1")
-- 
2.43.0


