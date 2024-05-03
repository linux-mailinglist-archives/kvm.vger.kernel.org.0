Return-Path: <kvm+bounces-16478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8778B8BA699
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 07:25:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EFDF1F224AF
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 05:25:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9ACF139CE4;
	Fri,  3 May 2024 05:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ePGDkfsx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7FF2C181
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 05:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714713926; cv=none; b=kVu0XZd7Dp2RX8pkJcLtheObnh1L5yFECxFtHhsBLvkujjhy0REWQjB/VFMbmIcLJWKHGsHjiiO03Os9y3HnM7fEc/wTFibSegkW3TUdHaHA4ciH3ccXhB+8Dp9X55oiBUCy/WfbBnQFXwpldSUe9Bj45+/2RRZmX+LaqPHn9hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714713926; c=relaxed/simple;
	bh=/5uJMQp3yNu8bhBnBFO/iH8SSkGNUC3g8iOpw2JBT38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2dmh6isaMhd4DRS6oLdVeirEHXRvK+hyY5XXqAtPXKdZAy59NcnC8kYZ0u5jT8Egl6zfiG/tMgtQxAe+YXG4DMCGowsOql7tZUzrNpPtX7ITO1vSzIXXrKxwSKNBnObUiuS/nGFB+f8QlyP2VsMWK3RaWq63kbVc4xtNnvKIxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ePGDkfsx; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6f42924ca64so2005990b3a.2
        for <kvm@vger.kernel.org>; Thu, 02 May 2024 22:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714713924; x=1715318724; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4UbIgVBqQvP02FKP8S0NEy2lwq+MKac1wEMDpbWbGGY=;
        b=ePGDkfsx9cWAM9GKAqtdaLiv6uHlXy1XMQrUMTwTRnuRi0DzLoG6X3h4xSrPQMFTp+
         NIebtNJt267kjcf1IOMCcc3tpSvpnrpL099Zc30HFn7ZlReYIgmbZXNRHmrJdyuDhGui
         SzFQBGs36UyGxW0/i61FSZ/PA/ilUcMrcczNUS/c771NXicafQshwB3T130HLu4uZxcT
         b0jdpSANLn9UTqbuHtxUKqsWc9l0dKs//D2SPlCGM0XgObdnzvv7TtP9sXh3gUTGHRhF
         FXShPX0p0Idu9QbnGQmVrgnX1WRpwX6p1fL91f/2eAGGFAlUeJO+OaoUjRI1qkRoiVEN
         yunA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714713924; x=1715318724;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4UbIgVBqQvP02FKP8S0NEy2lwq+MKac1wEMDpbWbGGY=;
        b=vEp0/RAhTFo1zY7qrDnoTOR7IkHclOiHCp5mVcP2Wcffm99ZUMJKJb2NmVl20mBnKu
         9haj2V2BPuSIVZhxjcYxkReRIdr498u2UtEZGBIAGV0CIL6iTlNXOaNOw2JablLYaQQV
         QvR7V+mDZdnXJjtjvL/kzNjVwet2ZssrK1unjw2OsxLssIho5Gvjq9cOjlclIlcrTA8d
         OX3xbk0rLi12dV2e1oufJkNzbTqcxIQUlzzLaH6ZGx2Q2NIIgGElVthwtwGaecc2rKRa
         TOgWuhsWyJae5hF4gJNBV4jPwXKKCtqViiQchf2AMs4WU8Q1cuhFRki+NyDSIM//Ssv5
         Bvow==
X-Forwarded-Encrypted: i=1; AJvYcCWOkuT09paPwt3qxnH59bfezePXzEukbT/B0VzyS7MUrdVkoum3unKzkFGQy9l8eUjJzkmnsJHUPS+2hzaLkh8ONz7m
X-Gm-Message-State: AOJu0Yw8GKy0xEISzF5jpHtCyxsKf2suoyod4bjtc0bV2qBX/wdusvCH
	iXEl3AjVVT/yXLcGmt09FQjdFEosG+f1z2ntv536guD/YAKDyCGv
X-Google-Smtp-Source: AGHT+IHFYEWop2IhIirSfpH+QcxAMZ7fjLEj89ByiMeJxNxxryk37TEpKcQqrbPMWxGZ8N+d/cyQBQ==
X-Received: by 2002:a05:6a00:140f:b0:6ed:4288:650a with SMTP id l15-20020a056a00140f00b006ed4288650amr1560736pfu.19.1714713922965;
        Thu, 02 May 2024 22:25:22 -0700 (PDT)
Received: from wheely.local0.net ([1.146.23.181])
        by smtp.gmail.com with ESMTPSA id y21-20020a056a00191500b006ece7bb5636sm2205571pfi.134.2024.05.02.22.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 May 2024 22:25:22 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 1/2] shellcheck: Fix shellcheck target with out of tree build
Date: Fri,  3 May 2024 15:25:06 +1000
Message-ID: <20240503052510.968229-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240503052510.968229-1-npiggin@gmail.com>
References: <20240503052510.968229-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Prepend source directory to script names, and include source directory
in shellcheck search path.

Fixes: ddfdcc3929aef ("Add initial shellcheck checking")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 6240d8dfa..b0f7ad08b 100644
--- a/Makefile
+++ b/Makefile
@@ -143,7 +143,7 @@ cscope:
 
 .PHONY: shellcheck
 shellcheck:
-	shellcheck -a run_tests.sh */run */efi/run scripts/mkstandalone.sh
+	shellcheck -P $(SRCDIR) -a $(SRCDIR)/run_tests.sh $(SRCDIR)/*/run $(SRCDIR)/*/efi/run $(SRCDIR)/scripts/mkstandalone.sh
 
 .PHONY: tags
 tags:
-- 
2.43.0


