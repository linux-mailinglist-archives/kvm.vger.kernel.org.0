Return-Path: <kvm+bounces-13682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 14C0B8998D1
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 11:03:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D2F01F25660
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 09:03:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC4EF15FCE1;
	Fri,  5 Apr 2024 09:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EePS2SyO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE66B13D265;
	Fri,  5 Apr 2024 09:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307712; cv=none; b=NbxOJeegzzM6S5b67BdmmnhCk/1Zot9SmVw9m+9KRpgdrVV1wyANGD0wcrSwfv05FFYLM0u4Hq76s1mVu4ugiW4JyieJc149A1n8cVKjhdA+4+QYXWrUeOYV/fZX/uvd8EOXkQBAbH+psb0PzXKfGl4C7OrCuxgkh/hI7fSzyjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307712; c=relaxed/simple;
	bh=4g1r/UsnPqbm9eIN4ayWeeOIX2i8p9mAV/a9qMDvTH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0vJAfGXlllJASp1IqRuYXrTLCm3u3GixrQq9FInaZzpMjCkKJ8e5YNLMz8+u3iYOPZOZ/idFaG4xBPtXETQY4ltxe/bqFVASsvOXOTOPuXDmfv0i8CYSLoiVWpHV2fWLtTIGxdyFx/Ykpisw5lq21mtirGYOF/dCSSJrO5eJoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EePS2SyO; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6ed054f282aso48072b3a.0;
        Fri, 05 Apr 2024 02:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307710; x=1712912510; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tE5LrHkhPWwsD1wVtesjtmAMJJFllrOtQDVtshSFCEA=;
        b=EePS2SyOhcD8W5iI1cieVp/3buQpQrZ/Q6QPZ2gmL9/vMFrlpOVzQdMOyB1Yn8PA5i
         eCMCT9swb7EpJvJ5h0r0V8ScR+RYeQZj0QvcvbPusWFnO6w8PbNk/XWQviD3z0Gx/1H2
         ZZOeByW2oEM8CR0BmDF0/KesQXI/BnwDf7uvgy3eza1+Ee1IVP+7J4C/KjAoVw/Ob0T4
         30jbY96ffDIbWzVjY7lzyZq72EVDHA+dRLgufwT/xzU7cqwR6L7CfklAv8402h30ksQv
         9aRJqI/zjBYPMB+71SST0wx30CrmS14XOaNEk/ASxCKq+Eex/CTSrdnkaqp1Jr2VC6ye
         wxdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307710; x=1712912510;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tE5LrHkhPWwsD1wVtesjtmAMJJFllrOtQDVtshSFCEA=;
        b=Ok/CAUH4qKEhi9Nx38EGPZYNA2mfHVLR3CX1iyUn7386OlzvkxN9HYdloWE+3NLsT/
         Aa2fjHr1/kNL+A2Ta6nxL0pIAM62Eutm5NEt0422OPoE68AfO4w+P8GgnTBA66SoZLEi
         hKxYnKSKYwfg9yIxLnrIki2doEXNnNRoxAUlGwDhiHuk/g+7i2g4SdhpQy6XfyKc7E+I
         o0AdaMZ9bBRPbQeRUE4aNah78pTnu4K4+FAOMvfkn8fPaJx0GN6SK/JEy9j0VX+M0azf
         xsOZ90/tWzGrSX5JywYdzMK3eKS4RY/i8a3ccbPiiyY6DWBZDVw5pdItzd/GN/rSlhTJ
         C5kw==
X-Forwarded-Encrypted: i=1; AJvYcCW3VhU6Zs3htsnE18vd/n124xv4U2unAz9w61YuDXB8FExsz1ZAQ7hzZZFQ+Dk+oKdoSTXRHpXSYzHDMY84iyxAB7N8fSSfQ9/3oZFon8eh6qifMnFswEPdHfsxQhj7Sg==
X-Gm-Message-State: AOJu0YwPVMg5XjAQ02W2yfI1TEx8PxNnJc/H1PVae9Bd97Q9iRJAZL0q
	3DCN5vfCezTcVyIV8WI3pG1k2hv9aO7+njrOP/NmZSLWn4mgFY/c
X-Google-Smtp-Source: AGHT+IG8zRLKzBiTQEfRs0hBIeVmr7NK/SMycA7/nOPbTjd9DY0AzfGVwPzzqjCddECVKUaZg6xLKQ==
X-Received: by 2002:a05:6a00:988:b0:6ec:da6c:fd42 with SMTP id u8-20020a056a00098800b006ecda6cfd42mr1095467pfg.5.1712307709981;
        Fri, 05 Apr 2024 02:01:49 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:01:49 -0700 (PDT)
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
Subject: [kvm-unit-tests RFC PATCH 05/17] shellcheck: Fix SC2006
Date: Fri,  5 Apr 2024 19:00:37 +1000
Message-ID: <20240405090052.375599-6-npiggin@gmail.com>
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

  SC2006 (style): Use $(...) notation instead of legacy backticks `...`.

No bug identified.

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


