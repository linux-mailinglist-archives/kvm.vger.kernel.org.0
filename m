Return-Path: <kvm+bounces-18587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 018F58D758B
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2024 15:07:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29AE11C20953
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2024 13:07:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D2AD3BBF1;
	Sun,  2 Jun 2024 13:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E1r0E7pH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1468C10795;
	Sun,  2 Jun 2024 13:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717333632; cv=none; b=Hjh34ycjDACWRRKCFkmVZ+Ujs45XpXZ/jf2swbUBklDZPmMhzafgAQP+OiKBqAAiVcgo52gj7iCNpWJWtNhGd9vt2/wW4jrCdW4BrLy6yXpwO0B9vUn7jXZL6LXNC2MUhDH3cEUD+BEQ2jld0rtkqEux0tGAWOFVa5ULB7ljWrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717333632; c=relaxed/simple;
	bh=FH0kSoTf3GFg61ooCBg0WYMnLgTRSbRWJbNQmv0jzyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=poU6tGY88vnBBLombEHI+RSFe7S3GZTfrrks3NRBvR3q3pKe6CRjOusVvIgDWZBG0uF6SJFZ6DfvsKlA2ghDdKYzLlmIeQjfGQEXGWt4T/lRNmFQ4WRlUR8kV91wQNtBHb3b8P9/pNP6LdNKUXmnPDniZw5OvFlQNlbJPG7udNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E1r0E7pH; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-70249c5fb36so1615680b3a.2;
        Sun, 02 Jun 2024 06:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717333630; x=1717938430; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FdJAWFUB+L1UfVj9JilXmEdsovfbSHIZV4hZgFve3rc=;
        b=E1r0E7pHPN/1Xfky1KWDLW9Xhaa1bWZo+D5Y8kdYBaeydmVFPydJfGKaZYUf0gPd6y
         DHzg46CasUOyduTB59rO2Zy6XFNzyIqkpq7wAb8HIBpnRwP5gFC06HylT7OX1nC1Qzk9
         bycV9FLb4Ju/hLbhBLyZr/h6MOsgBUVlkxzh0y/GIt1DxAqt6Kh8dDAW5uTUwuNJc+jb
         8bbVLWl8vmQ0CoD2DWtB/y/n86kseVmHBkBlB95m6+MaZouunxsby1XGX1G6sBG4s2Fd
         gfcDIbj1hFtCdeOCQo32Kae9PFs1oO3/h2+19iU/KuQntEkZ9YEePuBW8LwbEGwm4eYz
         557A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717333630; x=1717938430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FdJAWFUB+L1UfVj9JilXmEdsovfbSHIZV4hZgFve3rc=;
        b=GmvMSzqS9qZLkRq9zHgKQy+7mlyP8LpiAeKzB/B+RmgMW31ni9nb+rmnwZo1rXEQZz
         d1UAvPkJ5rhUWbNIJDYjeDDvTv0H2Ml8VY2X9F6CsqOQQ1G5cVjWnKWjrqbFbaWKU31I
         PWcnvhW2lF/M5qT9rjFhZ6aou/WIlaMUZimmQgc+nGjOpa9lATYpmfh17twZYq8qrrLf
         QLiQHdYlo6MrBppnQcrv4MUUCXznxyCWrGgsAg2t48+i4ZfOzALm7FbeZWS4OdCw2EV4
         LQbi+W48MrduegbCslU4fdJbo8EfQf+FccDMseYMLxK95KCfmITr4iF+5KJ+DZMIXpWw
         QHpw==
X-Forwarded-Encrypted: i=1; AJvYcCVOP3dnZZJDIkLdoyF/v9EQo/Dp4wMftNdQ90HtKxZGAHK+/DWu7o64yOQB+FoI12hUWyFfI+2KvvuCXM/lMGjSrCfb
X-Gm-Message-State: AOJu0Yw//6d8fepcAmhD2LSBSXSd1xPeZ92+yFLI9vr76XpVk9MEy7Bb
	6e/EeHG8yuSG2iPoaO+23OJE7bnkLVP72IuRH7Pqdw5az/pcBYm/0gr4Rw==
X-Google-Smtp-Source: AGHT+IHvsvuIQ5SOq1qQYCUdhBK/sF25bxnpSIpAMGkwACdBlhLBTmFt1HMDZF+iSDbpLdvnQVGbzw==
X-Received: by 2002:a05:6a00:3c83:b0:6f4:59cd:717 with SMTP id d2e1a72fcca58-702478c7cfcmr8219037b3a.28.1717333629615;
        Sun, 02 Jun 2024 06:07:09 -0700 (PDT)
Received: from wheely.local0.net (110-175-65-7.tpgi.com.au. [110.175.65.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-702423cf27fsm4138655b3a.12.2024.06.02.06.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jun 2024 06:07:09 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: linux-s390@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 1/2] s390x: Only run genprotimg if necessary
Date: Sun,  2 Jun 2024 23:06:55 +1000
Message-ID: <20240602130656.120866-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240602130656.120866-1-npiggin@gmail.com>
References: <20240602130656.120866-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

genprotimg is not required if the --host-key-document= configure option
is not specified, so avoid running it in that case. This prevents the
build message:

  bash: line 1: genprotimg: command not found

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 s390x/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/s390x/Makefile b/s390x/Makefile
index 19c41a2ec..c6518bbd1 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -213,12 +213,16 @@ $(comm-key):
 
 # The genprotimg arguments for the cck changed over time so we need to
 # figure out which argument to use in order to set the cck
+ifneq ($(HOST_KEY_DOCUMENT),)
 GENPROTIMG_HAS_COMM_KEY = $(shell $(GENPROTIMG) --help | grep -q -- --comm-key && echo yes)
 ifeq ($(GENPROTIMG_HAS_COMM_KEY),yes)
 	GENPROTIMG_COMM_OPTION := --comm-key
 else
 	GENPROTIMG_COMM_OPTION := --x-comm-key
 endif
+else
+GENPROTIMG_HAS_COMM_KEY =
+endif
 
 ifeq ($(CONFIG_DUMP),yes)
 	# allow dumping + PCKMO
-- 
2.43.0


