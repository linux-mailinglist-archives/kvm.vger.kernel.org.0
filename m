Return-Path: <kvm+bounces-9811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B2368670E2
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:27:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B466F1F29D02
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:27:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6E585B690;
	Mon, 26 Feb 2024 10:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jvrLGV2y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7459B5B5DD
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942384; cv=none; b=S1OiX7gkDtHBReaR5rlb9y8JkkJIxmJ+9qu3vWUmk4mCmxktKP/ewrkuslhbJRYyfmjDWqzP3yzWZYkhH/TCXICskIIVFJpDUPdbn+s0vUQebWLpLMrATiKL5ChGYc6bGEWd5D/aH79aghuc3j5fzAUnAhDlUPpFRBxNznPBXIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942384; c=relaxed/simple;
	bh=Aqr+BhECowcnq05W3OaVOKRSxWSQZ4fbK8UUsjfseqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIvymQm2rl9ZjR+lye4IY1ye2HRQRRZ6YwxvSNRSEWpErkJvOiIVQaONB719eJbeXXt2iDfqKQp0gN7KM09BZ2Hw/CQZzEfgdiPWRjU+8Mn6d6Bn+cfRmGTcnogWXOcvzTaRVfOFfiBxukMBUbDPmJYYDycvQlwxtsvoAlU8pX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jvrLGV2y; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-5a0932aa9ecso259061eaf.3
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 02:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942382; x=1709547182; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PHtxMXAWIAgt1+JKe/+QGMJfuAT62NDiAlCOd/8IJBY=;
        b=jvrLGV2yMRYw4N9I18e7MpF5EjH9t81Wm2AxEjtZXUCGVKpXmmaYHPeEJKJLsTEOat
         WZD66xOsNgOi9oGKkW7XMPGs4tCIXJ2yRTYwKcOwl+kg87VYzQ/zKx81+t+/9qetlVeN
         qP7ixbqdApVUI/tF7sGuHvjcAQL/638w0ycaI6Osy0JDGE/fcnJv138UKtwCYds47J1d
         LqNy+hhL7WZKtKO6VHt+VkhHvirGP0X6AgloEMTMueheuND0pn5b7a4twjerEWLZ/C8t
         AceL5Gyar+rCsQxgTGjqTHHJlG8VGOjNPvyMwTTuwcmMw0G5YAdELqeL2DZ/7BkdAylQ
         5t1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942382; x=1709547182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PHtxMXAWIAgt1+JKe/+QGMJfuAT62NDiAlCOd/8IJBY=;
        b=r8GgpzzorJZvOrBWL1ogVXebfCKQdWM95ZRFYG1Px5CLWEhBb2Sj0O76Ou8i4PG/hY
         uX/q5URh0Ojxi1F+LcioWWdj6ZcTefjjW1YMjdq/w2flA/8ooxXBtlHCGBlpBq85kiQj
         yFPv4Js1lOsN+UYqyE707YoV2ETBZ/s+auC8wZ86GmEqxQWqdktyVyAOHAFv6yXMd3jl
         WLm9X19P6EmG1EQTJMsNxOU7rh2WBvejdzmVLwMeziIlxf6jJ/wVcTKDSrzZPUNoKVHc
         BLntOZm44hCfFEFxA0ekLuDbDLg9y+c00LrGRt4fggVYxb0oN3byyhBN0mVwxk9zyvfx
         UUUQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5VWMCdrRUdjHPe+tcxISPBdg77hf5bFnwXpHtDS7vL4NDos5dHb5C2uw3i7fwGe2IvmnsQjTwXGa07ySeEPiL+RLz
X-Gm-Message-State: AOJu0YzB1fi6FY3eyOIwDPrYVCllqGMSxh183Iy3lK1JJA79+oAAPSJB
	7JuobPPwZDV3MmTi+DuJSR9cE/SH2mHYX/sVY9UlnXNMTIeqce1H
X-Google-Smtp-Source: AGHT+IHpT3x1k7Yl76sIU5S73lOzJzohSvxtXrbwREKBxSypGoBzMraHbv9rKz6vrQH1xspLTi3+0g==
X-Received: by 2002:a05:6358:6422:b0:178:6211:871 with SMTP id f34-20020a056358642200b0017862110871mr9628406rwh.0.1708942382645;
        Mon, 26 Feb 2024 02:13:02 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:13:02 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 07/32] powerpc/sprs: Don't fail changed SPRs that are used by the test harness
Date: Mon, 26 Feb 2024 20:11:53 +1000
Message-ID: <20240226101218.1472843-8-npiggin@gmail.com>
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

SPRs annotated with SPR_HARNESS can change between consecutive reads
because the test harness code has changed them. Avoid failing the
test in this case.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/sprs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index 8253ea971..44edd0d7b 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -563,7 +563,7 @@ int main(int argc, char **argv)
 			if (before[i] >> 32)
 				pass = false;
 		}
-		if (!(sprs[i].type & SPR_ASYNC) && (before[i] != after[i]))
+		if (!(sprs[i].type & (SPR_HARNESS|SPR_ASYNC)) && (before[i] != after[i]))
 			pass = false;
 
 		if (sprs[i].width == 32 && !(before[i] >> 32) && !(after[i] >> 32))
-- 
2.42.0


