Return-Path: <kvm+bounces-9806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BF2E8670D2
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:26:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08C46289CEC
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:26:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B8625A795;
	Mon, 26 Feb 2024 10:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GrWITiuK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F425A4ED
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942363; cv=none; b=lFoBygNHY6ImrJDCat7hEt/6IUMeuKxNZyW5kajkLm+nfcfUukGV9tQlikUuo8YhuL7gx5QUkXCObeEQDa040diY7b6YAyZCkgTeoS7zZwSLxTslq4jecb2PvyxZRQ4b+zE7Hk4ll7gMzQNgnrN56CBt/GP2+TKhlOroojvQjBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942363; c=relaxed/simple;
	bh=g09UVxwWEg2JJdRy6f3hMLHG5bYrl/Pu7HJxCoVuaN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fW9FSxKLl2OyhcL11+t6kvT7OmmYPgj6rjPXb/58VIN/bByhqaZsnrWhlw8iVmLolCpf0qRVZLFJZoHsjU3B+yGr+UOs59K1ny4Cy0nVvRzQL6suFqD8p4ankWzOMKA1eqWhgjerjy1RzDfGLY2oaevM8Q9Um93QkDq/lYtkq+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GrWITiuK; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6e457fab0e2so1716502b3a.0
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 02:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942361; x=1709547161; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iA5QeHI5caSGHGuItQ55ZINMqdlUnn71FtpS3lmpHgA=;
        b=GrWITiuKdwiL5s7/nRjseGuGvWyid15rZYCZjWIpqiag7CbDJZlnD1Ga5nSHt2M7Lx
         6rmiMRj8vSKSU0e0Npxidc1r3ZFJQdPVcjlantNk6ay/ki9+/iHmy0vJkCkDQHELi2JE
         3iLIHO9Y+twz+fOfR6LROzON//mPar2OLuYuwKWjLtjCumBM6BpRKYF3mh+bKJ+irapw
         L75CRW7x5Lpy3UG0v4MLDEQN+oCsXuy8xuDsCwjtaqXsZUPqvT9xyz7NQyDr8mPctSKD
         55gwJzZ9/IFFnzGv+sCl9bGlwiA3q78LUDw/Z5Gbeb67lf29sSlEuQe4GgYsU3ORV1A1
         2u6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942361; x=1709547161;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iA5QeHI5caSGHGuItQ55ZINMqdlUnn71FtpS3lmpHgA=;
        b=M0za69BMccybXmLIzzJWZFmiH/HD3H1HXSCeBrrWZwZRqblhJdQYYJ0zPCpxjujJ7F
         t6gSIRwiRK26/IhvJMnS2Zakw5nFvuF/w0uet0PzPpU1DG/DLlfbrVueb4F6dT+X8tTh
         H1bmlfB0cM1kkjAfZEfXiv1jplkxbRn5uJcDyp8qvVSSI8Vyk7OLDnx/aZhrqtyMNUHp
         CvywTeIeejoU8MTl44iudiKvNorv03DXQBULyc8dyJU5oMtIOaKrj4l5gewqX6Hb/u+v
         TKzZg1sJf4EOAhOb2zOYGrmwq7Tc/O0Htn7IifMcmMxTVPGRjbTgOUSNwqMM5HHv9kVk
         I0lg==
X-Forwarded-Encrypted: i=1; AJvYcCVr6STbDj5IiPxTDLeW70wt2QnZQAcxaw7qySpdJY4B5gblP4wpdAYU37h3xeTCeXvbPaAkOe8kNfG2P2QuGHIoEGrw
X-Gm-Message-State: AOJu0Ywf23yQxOOt06nEenA+MCgPmFk8TsdUiVvtIFoisIupWnznAiIt
	EdJAJ7Jg5gqvRzjvdZ8JHwwUqxJuHKquC3anMWy0FtVsdgJzFoUr
X-Google-Smtp-Source: AGHT+IGea8jhnynoirPKFsw6HLNHiZ8K4M5CZzg+/RSFPO2uI1VkHczFNVypYy/tQuf5IclRbmsu9w==
X-Received: by 2002:a05:6a20:b91b:b0:1a1:5:e883 with SMTP id fe27-20020a056a20b91b00b001a10005e883mr1818540pzb.22.1708942361339;
        Mon, 26 Feb 2024 02:12:41 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:12:41 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 02/32] powerpc: Fix pseries getchar return value
Date: Mon, 26 Feb 2024 20:11:48 +1000
Message-ID: <20240226101218.1472843-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226101218.1472843-1-npiggin@gmail.com>
References: <20240226101218.1472843-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

getchar() didn't get the shift value correct and never returned the
first character. This never really mattered since it was only ever
used for press-a-key-to-continue prompts. but it tripped me up when
debugging a QEMU console output problem.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/hcall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/powerpc/hcall.c b/lib/powerpc/hcall.c
index 711cb1b0f..b4d39ac65 100644
--- a/lib/powerpc/hcall.c
+++ b/lib/powerpc/hcall.c
@@ -43,5 +43,5 @@ int __getchar(void)
 	asm volatile (" sc 1 "  : "+r"(r3), "+r"(r4), "=r"(r5)
 				: "r"(r3),  "r"(r4));
 
-	return r3 == H_SUCCESS && r4 > 0 ? r5 >> 48 : -1;
+	return r3 == H_SUCCESS && r4 > 0 ? r5 >> 56 : -1;
 }
-- 
2.42.0


