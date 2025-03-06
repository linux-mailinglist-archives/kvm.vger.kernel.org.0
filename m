Return-Path: <kvm+bounces-40241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CF76A549D8
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 12:46:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B9673A655E
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 11:42:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C314820DD64;
	Thu,  6 Mar 2025 11:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dGZXTDG2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A73202F60
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 11:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741261217; cv=none; b=eTjfvueeQfUCnOC6P1V6ZgEcXZu+wDH5303ZAjppCiKz3RBigv1Sn0roKs+lKM/ZsS75MhiknbR1HbYMnc7HuJ9qLdvzSnRAAytZuRith1T2iwozCepwENjbvmEorUG6ZJipJTo8UV18/mRvhZYuyQo4LVTJ5INnMOniSCtLh2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741261217; c=relaxed/simple;
	bh=o7+qzA3tnXoihxhFi1DPIH2yiBV/2EGLP2z4cqNipuA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bkGYFy5LLG0mI5OGz5+ZgZoHzSFZs1sauEfepdle+qjHxvpLeJAmnuUaOB5dTcUIXFNk2WwTxJG6Z1aScVpz3gZAqhr3PIyYaguO2WWfwptQ0wjI8Sr+cMYt8ElrqS/Q+uL2a6K+jb6y2gdvKms/ZFYPV+684DWwMKw5agImrTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dGZXTDG2; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2fe8c35b6cbso836791a91.3
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 03:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741261214; x=1741866014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9127nfWm073HCRtDVJJCI2MtukOnN0i1WxmOkQABjqQ=;
        b=dGZXTDG2Sv3EOdIiwF9uY4zpk3iJDNmqNIdkpK76i5xtNqQtS6yR/TUqzJNmzB2+Eb
         J/wf5ALM3UWQIs5mBv4z7+jzK5lRJ2q/CvbjDXucUr7AWVYsGM9/39d8MS5Ig54KC+Cd
         pwuclvaaCbbZ6pWpo2cmOM4tLF5mPh1cmN4lTcDPjtHrg3Rl5ch+30kRy5MFWAiuwfgv
         WpyQ6AGuUZIQOfiMsmeAw/isKDAEzvF7aU9p+k1jgqln7+M4h5JSenepA5R7MQYhN97F
         1H2DiQZ59mDiLHS+hUcOxe6jeG87xCyza8xH5kak5SVz1FXaRtQjKTs2y6hTkw6jQUMT
         G6tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741261214; x=1741866014;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9127nfWm073HCRtDVJJCI2MtukOnN0i1WxmOkQABjqQ=;
        b=DiI9+yxHShlBtEyviL+0MyDdAL0hDbmomuCy/AGxp5/GFiz+CxEihMNmCaGjsYeYao
         EeuwSPvBCCfPArvYV3/4pYyqx4nKIkc6jv7MSU42F7V0CCplY3AiozKtmP9R/KlmeLQH
         JRb6Akv4Egz+HEM9hDsxKrfZoV0Yk9w8eRbt99KkdLqiCDeRLYMoyiPzr6Jt+8JpLpLA
         ZG+5OdyGaZ6abP/t+lDfIZJDS1jnSYZ5jHXw6udweDCBUftaiE+1sfRbinKOJsKlUxBd
         nJxxx6+/bPUQ/7iiKsTEvyMPBrMXBbj01g1qs6BCv4FVpjjQxAvday4BC7Js9fMNNWH4
         eXsA==
X-Gm-Message-State: AOJu0YzlBFn76TBh34FIIwjRL74UWKFnFl1dIPtig3mdW4Ek2w94aTrr
	oanauSEiPI44iw9ew+JtxmedA2TlbzfwziSJvyPlK44hIQRq2zxlJFMe3b02
X-Gm-Gg: ASbGncsloJJzbxkUFj3Bf4I+pHcBE/PzXKuMeJspjrdPxOjpKWcajUwCNv2tfM58fev
	tveUTBMYugL+jkUDytQJ1jvCpd3gDS+7t7zh0AEReB1bmXzKA7htL9Q3TgU8qGOdcwRBGm6jLHQ
	xulWRVoq8TzbxExPknJTo3WN1z0ZI35yRF8EmrLyw/ruhzIv1xQwgUvkB0Vtqab0ahPa3bOCADx
	dQj4wfP8dqQs0KA2hqb8YGAeBrNNZeMqzc6D1kTgCbRglEElMGCjdX199O2pdC9RnB/3dfutVzW
	TOub3viaRbvjVjHatLoC4DrFnrHNrt0KQV8g/qrjps85E6tq7Q==
X-Google-Smtp-Source: AGHT+IEtuu46e7H6o8/6x99gkEya55XCSCqBYUNaHQQFYfXPg5HS5TLIbUViPUHCZTK/sm0CjW3/bw==
X-Received: by 2002:a17:90b:3e87:b0:2ee:d371:3227 with SMTP id 98e67ed59e1d1-2ff4975330cmr12737518a91.17.1741261214024;
        Thu, 06 Mar 2025 03:40:14 -0800 (PST)
Received: from pop-os.. ([2401:4900:51f0:c013:746a:c997:bfb5:9e96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ff4e7ff9dbsm2920111a91.32.2025.03.06.03.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Mar 2025 03:40:13 -0800 (PST)
From: Akshay Behl <akshaybehl231@gmail.com>
To: kvm@vger.kernel.org
Cc: Akshay Behl <akshaybehl231@gmail.com>
Subject: [kvm-unit-tests PATCH] riscv: Add fwft landing_pad tests
Date: Thu,  6 Mar 2025 17:09:42 +0530
Message-Id: <20250306113942.10880-1-akshaybehl231@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Added invalid value, invalid flags, locking and other checks for fwft landing_pad feature.

Signed-off-by: Akshay Behl <akshaybehl231@gmail.com>
---
 riscv/sbi-fwft.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
index ac2e3486..5d88d683 100644
--- a/riscv/sbi-fwft.c
+++ b/riscv/sbi-fwft.c
@@ -329,6 +329,87 @@ adue_done:
 	report_prefix_pop();
 }
 
+static struct sbiret fwft_landing_pad_set(unsigned long value, unsigned long flags)
+{
+	return fwft_set(SBI_FWFT_LANDING_PAD, value, flags);
+}
+
+static struct sbiret fwft_landing_pad_get(void)
+{
+	return fwft_get(SBI_FWFT_LANDING_PAD);
+}
+
+static void fwft_check_landing_pad(void)
+{
+	struct sbiret ret;
+	report_prefix_push("landing_pad");
+
+	ret = fwft_landing_pad_get();
+	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
+		report_skip("SBI_FWFT_LANDING_PAD is not supported");
+		return;
+	} else if (!sbiret_report_error(&ret, SBI_SUCCESS, "get landing pad feature"))
+		return;
+
+	report(ret.value == 0, "initial landing pad feature value is 0");
+
+	/* Invalid value test */
+	ret = fwft_landing_pad_set(2, 0);
+	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
+			    "set landing pad feature invalid value 2");
+	ret = fwft_landing_pad_set(0xFFFFFFFF, 0);
+	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
+				"set landing pad feature invalid value 0xFFFFFFFF");
+
+	/* Set to 1 and check with get */
+	ret = fwft_landing_pad_set(1, 0);
+	sbiret_report_error(&ret, SBI_SUCCESS,
+			    "set landing pad feature to 1");
+	ret = fwft_landing_pad_get();
+	sbiret_report(&ret, SBI_SUCCESS, 1,
+		      "get landing pad feature expected value 1");
+
+	/* Set to 0 and check with get */
+	ret = fwft_landing_pad_set(0, 0);
+	sbiret_report_error(&ret, SBI_SUCCESS,
+			    "set landing pad feature to 0");
+	ret = fwft_landing_pad_get();
+	sbiret_report(&ret, SBI_SUCCESS, 0,
+		      "get landing pad feature expected value 0");
+
+#if __riscv_xlen > 32
+	/* Test using invalid flag bits */
+	ret = fwft_landing_pad_set(BIT(32), 0);
+	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
+			    "Set misaligned deleg with invalid value > 32bits");
+	ret = fwft_landing_pad_set(1, BIT(32));
+	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
+			    "set landing pad feature with invalid flag > 32 bits");
+#endif
+
+	/* Locking test */
+	ret = fwft_landing_pad_set(1, SBI_FWFT_SET_FLAG_LOCK);
+	sbiret_report_error(&ret, SBI_SUCCESS,
+			    "set landing pad feature to 1 and lock");
+
+	/* Attempt without the lock flag */
+	ret = fwft_landing_pad_set(0, 0);
+	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
+			    "attempt to set locked landing pad feature to 0 without lock flag");
+
+	/* Attempt with the lock flag still should fail */
+	ret = fwft_landing_pad_set(0, SBI_FWFT_SET_FLAG_LOCK);
+	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
+			    "attempt to set locked landing pad feature to 0 with lock flag");
+
+	/* Verify that the value remains locked at 1 */
+	ret = fwft_landing_pad_get();
+	sbiret_report(&ret, SBI_SUCCESS, 1,
+		      "get locked landing pad feature expected value 1");
+
+	report_prefix_pop();
+}
+
 void check_fwft(void)
 {
 	report_prefix_push("fwft");
@@ -344,6 +425,7 @@ void check_fwft(void)
 	fwft_check_base();
 	fwft_check_misaligned_exc_deleg();
 	fwft_check_pte_ad_hw_updating();
+	fwft_check_landing_pad();
 
 	report_prefix_pop();
 }
-- 
2.34.1


