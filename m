Return-Path: <kvm+bounces-59416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29139BB358A
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 10:52:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C037D563141
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 08:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC96C2ECE83;
	Thu,  2 Oct 2025 08:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zLl95qKa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D372FC873
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 08:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759394597; cv=none; b=WLiq6mP2BPTuVIjfngnhrl2pNjuvZfjbGwmB4VAIXp0OowMpj+Dn+CHaG1FO/KEMopNH1r+bl8zsnt1vszU80N5nSvHkYkYlgmM7pzo8C9oT8GzToBIckm9Y9RQ0mUVz6JpsD/QanoTm81pBYuioYXMj0b46vacJSRUqaw9jMqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759394597; c=relaxed/simple;
	bh=aR6ULLpG0i8EBO6eD7g++RXHHBlVlt3yIb5BST7YLkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e78H0pIcjHMdRc3idctWKCMX3ahOiIAgOJNY+1DRCos5dSf+gfTXA3tui7qdP75d4gNMn28A4F5cQ1hpgKTb22ENpTdLDD/N8+f/uahojoY/gxWejyqRunlAZQxwBW8XimScyk6Wltixhxc5vGUxhVxtL5vdht3/UfvvVIew334=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zLl95qKa; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46e37d10f3eso4821145e9.0
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 01:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759394592; x=1759999392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=32KTyTEIv4S+xafyswExVd2MIXheWFL9qAvbf+ZRZFI=;
        b=zLl95qKag+3Hp3qAWn21pJH0k/4kNPjXck9XkdvPt11Qnh0h3E4agzFpVkA3S9+H52
         hL27uQyS1XPsFRjklhgmXdQVeW1Hibhd+zvK/xTJcve8zLUcSz5dOgxQI73g7IDlY+MU
         SJziNk2Z+4fQq2MXl+OXnQliaVaEavn9jySfDeXJb6RZO7HmmsOo/qTxIKyuG8Mw7nv4
         rbRSsOJrP8nvJEtvf/Q924Tyv28kPDeWCiU7Ku05fJXMqKNNZDbLIkrTDGICuXxdQmuH
         VLuQqByaO4xgHTShG1ms5sFiG6NPxPMhWDnjTAcIw87QALARlcqkb05jYSSuGcE+9uK8
         6F2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759394592; x=1759999392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=32KTyTEIv4S+xafyswExVd2MIXheWFL9qAvbf+ZRZFI=;
        b=t3OTVhaAA0EIyVtXTqftl/UKx8+P87hQwFk81uKqsky8xEEd9d/eFSj0ueAMmizTPi
         Y/aM+z8YaDD7v5kkhzPkkEsqgPYokVvqCVjnG5cQPV/D6sWDYOEV3wnjeF23kDipqfQo
         X/pRi0rLXM7dYbEXlKlTIxhISlQZUUxWhbiy0TYCRpaoGgcg7KPowycCZd68whK+G+L4
         Zwt9HZxhPQ9h23Qtp+5iXCowy1TydSKUOzIxYUaBpkdaXiUG06lEncU2he2RkFejgVAi
         LCLAYs1WPruLUDpb9pzGoYB25UrIjZjxfWKrvvVDB0fXpMbnXP55XB1n7YKra6FrQGuy
         5eUA==
X-Forwarded-Encrypted: i=1; AJvYcCUDSzjOOigjc58y5rvyStu3ypoq8IQSd2n4K2Zs1M6FCjkBlkrQYaEDlmrqvx6y8YhIvlY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnF0DW284xpeczQG1DcBnrCjHSfiMfVNIG0ckFyLZGgzQqEBUn
	XI7+b6jXBzPT5SbaBB6JTv9m/izBeGTmOkICwpZg0nlApSgE+g9s011qbbib8rg1sOU=
X-Gm-Gg: ASbGncuB8IZ8d/fmL/vgyCn7lPAEyNQ/CM9ewkwQgHglm+pDBYLSqJsJ7ZEwwRcIqS2
	hucb1FtTfGrV26Gnm1YE9K0+CZ9eA/91bHPtip4UGMyfmkqqLW1txPoYEX3IcaFh2Qpi5A/ULIZ
	50f3Ejgo0VaxoChxH/HIokNgKNFhTuqemRLuem4OAeR8gECGme3zcEXEsNBcvVE4LjRsSdvCfix
	DKgrveszOYLVs7agV9FnPa2Alilo6+JbuWVPUFrZI/5hYm4iEHvpUZ2Ob5CavNMLS4QLVDbUDSK
	4Gi7rhmqajCEZJRSzxDvneeA9pLpfO02Nk8C36WdYgZ89CFD+O8rekjv0T/lAQpjoZ8JapfW5xS
	Bi8QpDA4sq14OzlTwmpzmFyJup6qIB0Ch2tE4aFeT/oAnqeRqbFq4NrDg22RVZUmSX9AHauWtoU
	Qqh1JuoUgplQsuxYDZkuGWesqxZ+9/Qg==
X-Google-Smtp-Source: AGHT+IEZQOIEqlGUv6pO69td5pzAzxUa79bMkjYW9qkw21+3BvVHY7MhQ8EnUXVp5wD/RikWOGCbpQ==
X-Received: by 2002:a05:600c:8b37:b0:46e:4329:a4d1 with SMTP id 5b1f17b1804b1-46e61202280mr56814795e9.4.1759394592450;
        Thu, 02 Oct 2025 01:43:12 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e61a0204fsm73877065e9.14.2025.10.02.01.43.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Oct 2025 01:43:12 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v4 14/17] system/physmem: Avoid cpu_physical_memory_rw when is_write is constant
Date: Thu,  2 Oct 2025 10:41:59 +0200
Message-ID: <20251002084203.63899-15-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002084203.63899-1-philmd@linaro.org>
References: <20251002084203.63899-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Following the mechanical changes of commit adeefe01671 ("Avoid
cpu_physical_memory_rw() with a constant is_write argument"),
replace:

 - cpu_physical_memory_rw(, is_write=false) -> address_space_read()
 - cpu_physical_memory_rw(, is_write=true)  -> address_space_write()

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 scripts/coccinelle/exec_rw_const.cocci | 12 ------------
 system/physmem.c                       |  6 ++++--
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/scripts/coccinelle/exec_rw_const.cocci b/scripts/coccinelle/exec_rw_const.cocci
index 1a202969519..35ab79e6d74 100644
--- a/scripts/coccinelle/exec_rw_const.cocci
+++ b/scripts/coccinelle/exec_rw_const.cocci
@@ -62,18 +62,6 @@ symbol true, false;
 + address_space_write(E1, E2, E3, E4, E5)
 )
 
-// Avoid uses of cpu_physical_memory_rw() with a constant is_write argument.
-@@
-expression E1, E2, E3;
-@@
-(
-- cpu_physical_memory_rw(E1, E2, E3, false)
-+ cpu_physical_memory_read(E1, E2, E3)
-|
-- cpu_physical_memory_rw(E1, E2, E3, true)
-+ cpu_physical_memory_write(E1, E2, E3)
-)
-
 // Remove useless cast
 @@
 expression E1, E2, E3, E4, E5, E6;
diff --git a/system/physmem.c b/system/physmem.c
index d5d320c8070..23932b63d77 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3190,12 +3190,14 @@ void cpu_physical_memory_rw(hwaddr addr, void *buf,
 
 void cpu_physical_memory_read(hwaddr addr, void *buf, hwaddr len)
 {
-    cpu_physical_memory_rw(addr, buf, len, false);
+    address_space_read(&address_space_memory, addr,
+                       MEMTXATTRS_UNSPECIFIED, buf, len);
 }
 
 void cpu_physical_memory_write(hwaddr addr, const void *buf, hwaddr len)
 {
-    cpu_physical_memory_rw(addr, (void *)buf, len, true);
+    address_space_write(&address_space_memory, addr,
+                        MEMTXATTRS_UNSPECIFIED, buf, len);
 }
 
 /* used for ROM loading : can write in RAM and ROM */
-- 
2.51.0


