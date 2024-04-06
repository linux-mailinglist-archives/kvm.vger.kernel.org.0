Return-Path: <kvm+bounces-13802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A3CF89AAD8
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 14:39:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E41C2821C5
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 12:39:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C1EB2E83F;
	Sat,  6 Apr 2024 12:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FO/3bm5c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAF52CCA0;
	Sat,  6 Apr 2024 12:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407177; cv=none; b=pMRrKKnEXtLhEAXZFKNBP7GbNgrmDsAnKEo7VwBPusyDv6QyZUHud1SYIIgcXBPTPsk+/gNCfwJlgPzM2OkU6k+BvW6Czjure5zcxZhLYz7mTp6zmYNeCBbzfZR4IpDupRMCVddqbQUB+MhUJ1KFHEwkBlKtpkjxZBbuVtHf4JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407177; c=relaxed/simple;
	bh=U34po4updKQxQ4IZ87lCoa6hfZpy0R9FdoTvDox5LYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqRjrAhDvQTJFBD8q03d1Ae+GrEWPvZeE196dRVNbzg4DfynZxn1ddUgBYD9s+B9Om7jH3TPw5MHvKqMu0jfqLP7W8KIEkhRU/6EQOs/Gt/IakYhykP5UsHabslWN4xbuq7Fg6TcO9BlKG1rwUce0rR64iuqQ4NLVHEd2N3F1QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FO/3bm5c; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2a2d0ca3c92so1953750a91.0;
        Sat, 06 Apr 2024 05:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407176; x=1713011976; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ctDYQgLStioQbOFeEtouOSGyQc9IUR3PlFjjsp3HZ2Q=;
        b=FO/3bm5cPkuK/E6zTkpusOFcK2M4afGynmm5iQwFvZFYUi0SGondG5JeR0MqOrMi8e
         Mi0190QWllAf6e9At5vuch0SmhdnoiXoO/eBy2ZeNglwvUYaSfxrIjevlZJv5lF+hLp7
         BOpn/8NBNRyOeIIHvuPD9fKCH4dqi7K055aERXamRUszg7Ys/ztsvwdWiaDMxtcxa/0O
         QtkOlMzEIjLveV5gGpEanzRBSYnjtlpjsuCU+77W8z9Pf99gYCP1/muNhWCxdlVCP1PT
         E85wxUIHNbXZOrOXvd8lPCIcgH/6wHvL4tcad2Dv0w/gAxH6lKhS3rwEdsAixHL3ajbu
         dzOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407176; x=1713011976;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ctDYQgLStioQbOFeEtouOSGyQc9IUR3PlFjjsp3HZ2Q=;
        b=TVDKIFwwMwsxo7z0+XeifrTwE3GvnvVUwugcpf4koKIGuNT2C7AHF/2xVGVS0ODxat
         bKcrlBp2ywJtr+oXeIq0N6S4lVw1F8Z3xqxo7G4LuDDd8uPw3DcXt5kXuLiSF3NXvrMU
         NkDMKWwa03G/KUlxl4EjlLi1mYKnslTn/iP5lGWXc+GptAKDfl6sC3JY4aTId9THapOZ
         wJ21YlXLq/IpSi47f4UbNrlLAsLMr7x4+Ot7KwTvz9HXAsD61evA1bSYd/b6s77ZkT3W
         m4lDukN4Vx51Qc9qe9pP4B4rN95q7/Ei9SM/1YNA+Tqyo8wb+cfn7prvCEgbjiFbiyQr
         jQXA==
X-Forwarded-Encrypted: i=1; AJvYcCXy5N9vtQiowFS5Y0xoTWIOMPOx0+U/MLYcDQIqg62yA+oc35uepaXKWb0xIv92E6eaxGDA68jRWvtLWhABWNdEVMyqC09zCUjvZjTD2JOTVndjfevJCmqTWMxjzizXtg==
X-Gm-Message-State: AOJu0YxA6pebu5Dd6UVafGnGcNmGAU+EmAJQA2hnc950PJCD9o2+TN5c
	8IDepTP3sdWiR10EEsUGdqXTb+4twvB2uzBpeBy+63ceIwbwd9U4
X-Google-Smtp-Source: AGHT+IFubLHuw+tn9P2k0qkE0L7n1y54S4hs/qXXktspKqdJ/DtIjqspW0ZznPjBc8pACbaNSoegBA==
X-Received: by 2002:a17:90a:1109:b0:2a3:846:6a45 with SMTP id d9-20020a17090a110900b002a308466a45mr6611290pja.5.1712407175820;
        Sat, 06 Apr 2024 05:39:35 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:39:35 -0700 (PDT)
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
Subject: [RFC kvm-unit-tests PATCH v2 05/14] shellcheck: Fix SC2006
Date: Sat,  6 Apr 2024 22:38:14 +1000
Message-ID: <20240406123833.406488-6-npiggin@gmail.com>
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

  SC2006 (style): Use $(...) notation instead of legacy backticks `...`.

No bug identified.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 6 +++---
 scripts/runtime.bash  | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 472c31b08..f9d1fade9 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -271,16 +271,16 @@ do_migration ()
 	qmp ${src_qmp} '"migrate", "arguments": { "uri": "unix:'${dst_incoming}'" }' > ${src_qmpout}
 
 	# Wait for the migration to complete
-	migstatus=`qmp ${src_qmp} '"query-migrate"' | grep return`
+	migstatus=$(qmp ${src_qmp} '"query-migrate"' | grep return)
 	while ! grep -q '"completed"' <<<"$migstatus" ; do
 		sleep 0.1
-		if ! migstatus=`qmp ${src_qmp} '"query-migrate"'`; then
+		if ! migstatus=$(qmp ${src_qmp} '"query-migrate"'); then
 			echo "ERROR: Querying migration state failed." >&2
 			echo > ${dst_infifo}
 			qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
 			return 2
 		fi
-		migstatus=`grep return <<<"$migstatus"`
+		migstatus=$(grep return <<<"$migstatus")
 		if grep -q '"failed"' <<<"$migstatus"; then
 			echo "ERROR: Migration failed." >&2
 			echo > ${dst_infifo}
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 2d7ff5baa..f79c4e281 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -61,9 +61,9 @@ function print_result()
     local reason="$4"
 
     if [ -z "$reason" ]; then
-        echo "`$status` $testname $summary"
+        echo "$($status) $testname $summary"
     else
-        echo "`$status` $testname ($reason)"
+        echo "$($status) $testname ($reason)"
     fi
 }
 
-- 
2.43.0


