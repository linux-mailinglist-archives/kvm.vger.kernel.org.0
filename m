Return-Path: <kvm+bounces-14078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DC5789ECBC
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 09:54:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF6B61C20AAD
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 07:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB42C13D2A0;
	Wed, 10 Apr 2024 07:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EYFyiLkh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6404413D293
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 07:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712735647; cv=none; b=WrEu0q6EHKm3op6Lkr/+kjYpREDjvGEpu5VBykafxJhn/7vr8bkONmcWupZm5Pl8ICKBs+12f+VS+K4n/ec5LGmcDUTYxCiR0M/CGAljmL50IaCxn8RmWFovF/Ba+s2OSum2nBrqQHOk92vHwNUl4/7Xhz/hB86IcFHJrEnusfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712735647; c=relaxed/simple;
	bh=TwUMo9+3hcaRJSwesaMm6D6P1JhA2/cWaZPzdCg7lks=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VgOEo6GeOlieP25dvXHmBCEJHnU+HBrC+sPudzQUceMMOOpAu6tHqjxvQClPBaeW2u+r8IAFXWiZQPHSZ3Y9jZqC/uf36QUZtQIWTw/M1slDDrgiB8iN+wWkp0FJEv08gPIlsjKUPKENE8kvWjpTnnxEKzd1CHjC6SX0KxpAUL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EYFyiLkh; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-346406a5fb9so884153f8f.1
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 00:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712735643; x=1713340443; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TzWpsPEwHMJ7LWVhaKRptx5M9+Upy/7c5xvO3Z/WvAU=;
        b=EYFyiLkhpgWjR+qaL+JQLyo9/i57qizEKtlcTLmDpz1xFNJPRpNfk6lan99SS9Vhkl
         zW53M2EUMEqOLjIpcBfmMgjxCzxaVDkaoSGdd7vHoXuRY6DyCsoOKduOF5J0eRKvbK/W
         PPqP+BfzMfWVKgXLTttu1boRT8mbLQO16+vu7o1wZuheQJ3oUfw4NYKxb0ack9ErB96w
         MYZuUyyyn/4Dudjs8XwXLxHRo3rTNitM0Xrsu4fgBDoKqBFWQZB3aNSt0zXJhr741PAa
         uxVdZcZm1AVAKEAnawkYgTqbcOpfzD6rEx2caPMKOniR9Py2J0UV5WGKQddsXnSOFbWn
         PUqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712735643; x=1713340443;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TzWpsPEwHMJ7LWVhaKRptx5M9+Upy/7c5xvO3Z/WvAU=;
        b=q8v3NLYvDM4P3AUUpYkfqd4lkEoRHkS6JZEMXnAezJPsHFDftCbnYf2UNF1MZkusSf
         rkGyg483/P+JhN/6HOntwCFdkjCGPikvOBDGnUGmaW2A20EU3iFxzwzRmWcceA1A7njZ
         3w8P3Xu9ikDf4J5sg0uRGiemN//EhlhzQyzUIbIgvF4afH3go9AwljzdJPo/K/53vIDW
         tsmgclzIZ0RoJ1GbekOsCcAQgy3q8dqRpemiT3wVqt2Yg9jSu7FJkYMFfwI/WJymdlkF
         MM4PDdGAjQ7AWBrKGoeDV5F2gChfoG+TtxtCjrLUm22HVJ3Il1JgyQ6356A9lyfs1EpY
         lbmA==
X-Gm-Message-State: AOJu0Yyem8HCjHaxyeaEFmaZXI8lUOrHtQVQWcteyUYiS1PSjfcIZl+6
	CQE9aeqWq/UBk+dl+FZaaI0x6EzoRb3QElGWtuL0tHpptY5JLaBThaOkaVcV
X-Google-Smtp-Source: AGHT+IFYiuAgF8jVy7vhwk63nWOXCGLjUUOO0NqrdJWNsg1NkH+ZRe7M19uyNiWJ8RP5KqfZS7WGrQ==
X-Received: by 2002:a5d:6d4e:0:b0:346:72f4:c805 with SMTP id k14-20020a5d6d4e000000b0034672f4c805mr584809wri.66.1712735642991;
        Wed, 10 Apr 2024 00:54:02 -0700 (PDT)
Received: from vasant-suse.fritz.box ([2001:9e8:ab47:b800:1a3e:a9de:af8d:2e91])
        by smtp.gmail.com with ESMTPSA id s26-20020adfa29a000000b00345660dafffsm9322005wra.80.2024.04.10.00.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 00:54:01 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: papaluri@amd.com,
	andrew.jones@linux.dev,
	Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests PATCH v1] efi: include libfdt header only for aarch64 and riscv
Date: Wed, 10 Apr 2024 09:53:58 +0200
Message-Id: <20240410075358.6763-1-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vasant Karasulli <vkarasulli@suse.de>

For x86, preprocessor fails to locate headers included by lib/libfdt.h
as they are missing from the include path.

Fixes: 9632ce446b8f ("arm64: efi: Improve device tree discovery")
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 lib/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/efi.c b/lib/efi.c
index 44337837..f396bd71 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -12,7 +12,6 @@
 #include <stdlib.h>
 #include <asm/setup.h>
 #include "efi.h"
-#include "libfdt/libfdt.h"

 /* From each arch */
 extern char *initrd;
@@ -205,6 +204,7 @@ static char *efi_convert_cmdline(struct efi_loaded_image_64 *image, int *cmd_lin
 }

 #if defined(__aarch64__) || defined(__riscv)
+#include "libfdt/libfdt.h"
 /*
  * Open the file and read it into a buffer.
  */

base-commit: 9f993e210064ba9f444b752f56a85bdafdb1780e
--
2.34.1


