Return-Path: <kvm+bounces-43042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D23AA835DD
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 03:41:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB9E81895213
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 01:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACD581A5B81;
	Thu, 10 Apr 2025 01:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xjl9SCta"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70ABCBA33;
	Thu, 10 Apr 2025 01:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744249278; cv=none; b=VUXBS5y5MMSlq/oIFoOgV85KLEXZn2RqRRo4ykhDsi27OTS4FqNtbTxEQ4RqrnDkUlsm5hZ1WCN7A3ZuWSUy8BJ2bE7pW7gIa8+9t+EdVdP5lQnCLlUGSq6C3RUzcYup6NJku4HieQDTfW3cbqr65Jn22XOT8+7xzA6vy5s45sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744249278; c=relaxed/simple;
	bh=NZOqjVIP8FTzp7eUsV2btXyDyXn2O6WMAXOMgGE8vsw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r/Exflw+3au2InaMqIDNuQV9oFO/2WH825530B7TSdWgGcDWGRh81s3CVYp0ioGr2P4kXnMqRaxmHgHZbXfWWMZmeCDkAjWbXIm3YH+Cv8CaNTM416AA8FoTZHjLw+IrU4Xx8Zv4jcULMTV7bRED/WN6bIs1kF9aLLmXhLHymiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xjl9SCta; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-7fd581c2bf4so284114a12.3;
        Wed, 09 Apr 2025 18:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744249277; x=1744854077; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vDD7X444luuHXzTYN56HFF+TK19UXmr6Po1Ep1hi+58=;
        b=Xjl9SCtazbgnjRHWFk985pJuRdDplhT8pcTgOZD0HUiqv4PoO3ABZezFex1iWdfK61
         7xbzlUyuzTDgYDsMe3oiBc6gMOwubMpY204sfz3MMz/56nFoMQrG0W1huy2GV08hg1qM
         ZzYPR4eda7dkA17wOmDQm991W0T107Fyr2xt0eYxsahN5yRS4VWRZVKKR7hJR6QpZ0mr
         SYgINwuqaGw6Q8PhkiDWA9OMSYG0KD9b4FVB96JaTu/+tgZeNU6LDqprG7pSRWcjz2dU
         pcIx2YdqzWiiKIFl9r3XjMUqK389LuwR7EhjVEhzk/TyEmTsL5+05f9fevlCHZGwJ0gb
         /3Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744249277; x=1744854077;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vDD7X444luuHXzTYN56HFF+TK19UXmr6Po1Ep1hi+58=;
        b=gTxvSvf/1vii06Pa7QDBwjECZUddIeuKp/IY4LgfzjZkzXjrSlwbvMm9WaeTqwTKRX
         ZxaUKF2ELVRuNww4wO4oOyA8e0sHJdd30yytW/oHfeYkdLpDkz1oMgAN6ii+qQMXjMtR
         BTvu22F2gPb+Rd+baUy7AUHlvYufBLIvf++AnSFf2FwzifK8qNUduvdUNRgzZW8CKBVn
         CVgD7oU8AvGk07KoUmdyAE0GHJbXEmjjXO3t8PkFLtKzatIa0QDTgXPRXa86uokYxRp+
         dXtI4F9qlLARMlTehVRGfqnefM9qw54m3LqLwBhOTBqiVsnn6o/oQasQqZzpwsN1r9RQ
         1Bpg==
X-Forwarded-Encrypted: i=1; AJvYcCWgQojKHy3MdysCJvLfQU87WoGiiwQ/7gbqCBVeFeK65eMIww8ISYlJjYBV/evYIflyTQdDDojp8Kkf@vger.kernel.org, AJvYcCWh+nwq7gNw7zTX5sLHsZgAqa4ixP6J9Q7R6IhGpXMlaAyMDPUMigR+HQ4rT+hpRS/U2NE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxxb7Pv2BYJFzbvxeMZv+SNW7L8rRopweX/hi/xaYVE2IpaFwlf
	SC+xR6S8J4qW0r79BWj/P+7ptwK5nnRmZ96sZcsnNtzwJbHs3rwTpLKgzQ==
X-Gm-Gg: ASbGncsLdLX1hXLOgx+XXR64k6M4cH3cjWosX3oUdCc4ykBT+WUW8fB1Ld/6kS/EDiL
	sf3Bq8B9k6uFmTdsiVBtiXgN8aOAsm41Ayi9lBXjZsCNRVzydpj02yaI043CqAxg8y7s6K4czN0
	EtlnxmpbpW2HdHA9CdOptC9fpFvUCCwG+48Nkjb8xdllPGQfQCcMaNXFU4VLXr/hIgoPURE87PS
	F3SQh2tYkWzOwo/3NN1nT0VFsh3uyanMHdtc8YHM+uVuCQziQijaqNBQJ/ABfiUBsU2XCQ+5iEr
	occkhXQiwFLaogDTnCC3T/kTwkLH1UHcHH5mLm9L
X-Google-Smtp-Source: AGHT+IFzIZYW/Riouxld4wtklQ9cILVfI+Hgwq6OW1Qd9SzohazTfnMQVuo4HnaqwZSS1d0mEPs4xA==
X-Received: by 2002:a05:6a20:d50d:b0:1f5:67c2:e3e9 with SMTP id adf61e73a8af0-2016ce0ae56mr654635637.29.1744249276463;
        Wed, 09 Apr 2025 18:41:16 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b02a090f7fasm1927872a12.1.2025.04.09.18.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Apr 2025 18:41:15 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 7D6A54236D23; Thu, 10 Apr 2025 08:41:10 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux KVM <kvm@vger.kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] Documentation/virt/kvm: Fix TDX whitepaper footnote reference
Date: Thu, 10 Apr 2025 08:40:57 +0700
Message-ID: <20250410014057.14577-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1553; i=bagasdotme@gmail.com; h=from:subject; bh=NZOqjVIP8FTzp7eUsV2btXyDyXn2O6WMAXOMgGE8vsw=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDOnfFU47t19a0m93vljGQnnfhGLHCUvrZzWcn+NQYR+74 tTPj7bXO0pZGMS4GGTFFFkmJfI1nd5lJHKhfa0jzBxWJpAhDFycAjAR5miGP3xKsXmnmT2ljT+7 fRCp/aa46P5ziciWkNbvMs3CD4+96mH4ZxSSLfntXO6Jqfe/FUnteLxP8FR/s4jo1vu3M+8mfNq ozAMA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

Sphinx reports unreferenced footnote warning on TDX docs:

Documentation/virt/kvm/x86/intel-tdx.rst:255: WARNING: Footnote [1] is not referenced. [ref.footnote]

Fix footnote reference to the TDX docs on Intel website to squash away
the warning.

Fixes: 52f52ea79a4c ("Documentation/virt/kvm: Document on Trust Domain Extensions (TDX)")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/linux-next/20250409131356.48683f58@canb.auug.org.au/
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/virt/kvm/x86/intel-tdx.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
index de41d4c01e5c68..2ab90131a6402a 100644
--- a/Documentation/virt/kvm/x86/intel-tdx.rst
+++ b/Documentation/virt/kvm/x86/intel-tdx.rst
@@ -11,7 +11,7 @@ host and physical attacks.  A CPU-attested software module called 'the TDX
 module' runs inside a new CPU isolated range to provide the functionalities to
 manage and run protected VMs, a.k.a, TDX guests or TDs.
 
-Please refer to [1] for the whitepaper, specifications and other resources.
+Please refer to [1]_ for the whitepaper, specifications and other resources.
 
 This documentation describes TDX-specific KVM ABIs.  The TDX module needs to be
 initialized before it can be used by KVM to run any TDX guests.  The host

base-commit: fd02aa45bda6d2f2fedcab70e828867332ef7e1c
-- 
An old man doll... just what I always wanted! - Clara


