Return-Path: <kvm+bounces-26274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF922973B05
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 17:09:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F25628722D
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 15:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36262199FA4;
	Tue, 10 Sep 2024 15:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j8uSenXQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1710119994E
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725980943; cv=none; b=mEnMnuM9F5XNHIukMeZ/E/sZgrpua3GqnvwzoM0767WLa6OjM0pAxHcvdAEcq2DJlI6GDzXva+timhIGtIKDAbuBA8ptwCRh0fakaEaU0Wy2FQ6hl64R2uN9PW58fxImE0O+DPQCUjRlKH7aObJ87RVDz1YdC8rG2y2lwxTPKc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725980943; c=relaxed/simple;
	bh=e0yLn4OQcCUOSUKXnCM9m4Gsgh4KiaEcRL2S3Z/9s4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1cBkYunyQrNMP+62lyeCzKLPPxeEH7Qb4tO3hqw0SthgqKjix6CF9kGbiF60PBuJDqV/MsUKYTJFiVxJqR7vtXWVbTmurAitTHi5lRE7hHN100BP9dYxC6F7Cr+yGSf1nrQNh+QJGK93v4mT7ExfZLFfa3wsKWszbZzbMSyWoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j8uSenXQ; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2d8b96c18f0so4433533a91.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 08:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725980941; x=1726585741; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J/LNwaUAGrr1fu/pOWbGaVjGYKY8WsxJd5roKC5v5Io=;
        b=j8uSenXQQQB22a+J1rkWd7+CGAEqYM0v/53TzzSKIkyFGTz5EFArSfN1uj6R3irzaK
         vpyaH4Iraab/zr54tN0NINIj7DMmv3KdLvqhm72z5uCb8vNNkip+82TmKNdJWUzO2LuS
         sA61cUbrhtV7FNZA5vYmlXVDDeuqwvyEVhwX6S/wEabKrQBFZb7UeNTxtCfxSwjjtXoS
         /tr8FKZFeeFiw+VTBZkN6mfItUDHCNaqzpIq2hzPkYeG6+uGBvs9gtw/Zia9ZTcxR8UW
         jLBc4B8tukUE/xPeyJuDWQ/kfz9HKlL7tW1eWJ/mVdpwqYfHEqy2Gk95X0hy7xzBHn0y
         +EZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725980941; x=1726585741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J/LNwaUAGrr1fu/pOWbGaVjGYKY8WsxJd5roKC5v5Io=;
        b=BqW6AdwJ/37czxLF01GFoEW1SCAvUxeSDtNRWi4guSDq0M4i7AXFWIBhXJnuMt/X8k
         ccIa4DkfHOocJaAx1NkSVehWq7nW/5nJIQTuJ4QqL9GqG6qPnVkQV9bYqp3cQmF93gx5
         9k44RHyzrWZm65H+dy3bib1ZLZiEa51njM7XWa/rBoj43y05RfVys+ohUcDPHVsLcoBg
         2a0SMEiVZR53undzBEfPvXJYyTp+kIfZ8qsDqWvhy6AfUTdMed6qPPq1S6ZB7FUI6/BO
         6yS5iAFs/Hk9IaKtkBaTZ9Ph44V37Z8kIyz9VJY0ltoYw2B7C8uoxyuf92+2ZW6CsL2m
         g1aQ==
X-Gm-Message-State: AOJu0Yy3iW2y8sAidRq99ZWYFk8GlOI1fIkAsUanLytBTnXZd1doCGYj
	BrO1UzdjLExPGK4AEwd/3mJ31+a2H1IKrqj0GYeFRl+LfMhEvmUjsnDA7Rwf
X-Google-Smtp-Source: AGHT+IGZfZBU54LIQhQtpYZ+otDovhuOB67i3DfWln9A/RUYV0lneOXqkrj/lcHR6A+PYPm2h9fbRQ==
X-Received: by 2002:a17:90a:d143:b0:2d8:905e:d25b with SMTP id 98e67ed59e1d1-2dad4ef223emr17362068a91.9.1725980941059;
        Tue, 10 Sep 2024 08:09:01 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2db041a02c7sm6615120a91.19.2024.09.10.08.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 08:09:00 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH 2/2] riscv: sbi: Tidy up report prefix pops
Date: Tue, 10 Sep 2024 23:08:42 +0800
Message-ID: <20240910150842.156949-3-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240910150842.156949-1-jamestiotio@gmail.com>
References: <20240910150842.156949-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace multiple consecutive calls of the `report_prefix_pop` function
with the new `report_prefix_popn` function.

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 riscv/sbi.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/riscv/sbi.c b/riscv/sbi.c
index 093c20a0..f88bf700 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -140,8 +140,7 @@ static void check_base(void)
 	report_prefix_push("unavailable");
 	ret = sbi_base(SBI_EXT_BASE_PROBE_EXT, 0xb000000);
 	gen_report(&ret, 0, 0);
-	report_prefix_pop();
-	report_prefix_pop();
+	report_prefix_popn(2);
 
 	report_prefix_push("mvendorid");
 	if (env_or_skip("MVENDORID")) {
@@ -166,9 +165,7 @@ static void check_base(void)
 		ret = sbi_base(SBI_EXT_BASE_GET_MIMPID, 0);
 		gen_report(&ret, 0, expected);
 	}
-	report_prefix_pop();
-
-	report_prefix_pop();
+	report_prefix_popn(2);
 }
 
 struct timer_info {
@@ -281,8 +278,7 @@ static void check_time(void)
 	local_irq_disable();
 	install_irq_handler(IRQ_S_TIMER, NULL);
 
-	report_prefix_pop();
-	report_prefix_pop();
+	report_prefix_popn(2);
 }
 
 #define DBCN_WRITE_TEST_STRING		"DBCN_WRITE_TEST_STRING\n"
@@ -401,9 +397,7 @@ static void check_dbcn(void)
 		ret = sbi_dbcn_write(1, base_addr_lo, base_addr_hi);
 		report(ret.error == SBI_ERR_INVALID_PARAM, "address (error=%ld)", ret.error);
 	}
-	report_prefix_pop();
-
-	report_prefix_pop();
+	report_prefix_popn(2);
 	report_prefix_push("write_byte");
 
 	puts("DBCN_WRITE_BYTE TEST BYTE: ");
@@ -418,8 +412,7 @@ static void check_dbcn(void)
 	report(ret.error == SBI_SUCCESS, "write success (error=%ld)", ret.error);
 	report(ret.value == 0, "expected ret.value (%ld)", ret.value);
 
-	report_prefix_pop();
-	report_prefix_pop();
+	report_prefix_popn(2);
 }
 
 int main(int argc, char **argv)
-- 
2.43.0


