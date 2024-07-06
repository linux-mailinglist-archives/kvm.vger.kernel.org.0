Return-Path: <kvm+bounces-21062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75F559295C6
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2024 01:09:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DEC91C20F7C
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2024 23:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69F9441C63;
	Sat,  6 Jul 2024 23:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SG3pRaDP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D03200B7
	for <kvm@vger.kernel.org>; Sat,  6 Jul 2024 23:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720307388; cv=none; b=nvMRbTz99hCJIjfXvv0K/0wYe6EK64jN8QvScTUaAi0y9x079MXdGD5+o9PtxG9CC+dhtBMoZ6poIgJgAYnlldxLAn1FB5mzt2Biq84YAcTWwvc81qmeasPnrpjV7rSm/E+CcYFQlwACvBo5ihGm88vUZ70gzpqVWA+PBAkkOps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720307388; c=relaxed/simple;
	bh=2n8+TgqvjCKyFBaqxI6biZt0BF3PVNWoErLFSou1NjQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=YJxJEsBgJHVOSRYX1ab9p9P3FCLMhRv3hFs9iYSR1mhyOeyhLbzrzQAFp9apwuGj8gwdg26NeGGPTkriwtCuPHKapg6vV2LMYvLYAFHEGu+yjMz4P7EB8Q216GuQNF2f04nG5cBMA0EGvs9kusfXOlv+m/XqR6fsYEMX0qoyNgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SG3pRaDP; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-25dfb580d1fso1392236fac.2
        for <kvm@vger.kernel.org>; Sat, 06 Jul 2024 16:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720307386; x=1720912186; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wB803YkDqRx4XmZe4PWS19Pv3OtpO0g7MWwyOSWFGp8=;
        b=SG3pRaDPdnOPhgDwRFAjEIpj7+MCHCzo3DQ5wxqiATLFiFRXAZS2WDe80PvamvCxYA
         pqvnHsviAqHzq/mrpLptmlHZ735F9MSKWgDePUQzNKOwbxGHGEJezCibab15ddOQ97Rg
         NXLpKF/r9yoXUcd9dVA+T+m0+J+ezBc+c5I4UDlvdBYAG83Xt7VW0vLQmnefnTt4HumF
         tGk/gK5A6aTFbb8V+qpw4rqzpQ1ZXUwFVBltEbNdeA4CeqoYYEs5xvN/jKrqur2ccxRu
         VGI9kBvKcHl8UzKaph5zw3LbVKx7/12Shq9tpRc2qqy/xx38etKNsO9MOF28mKORpEOp
         fo2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720307386; x=1720912186;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wB803YkDqRx4XmZe4PWS19Pv3OtpO0g7MWwyOSWFGp8=;
        b=CHdFLkY5RzG5PMuSrYt4iHsMT5Ul+xrglO4SQqteQixqK9twTO1Fpd2UDUT/Q614Yf
         CVUyHZGqwjnqCSY3E1sKjApPgIAPL77K+GLyD+G29wA9kA5C4Cjwnpl20IJtfS1MQnWW
         oKIZCbcVpzX3zwYN1WkRSQNM4GuFsNbE3GJsxDOoJTRhVOdw2zoITJBtjDdoDrSKLFTi
         i1J8kF1iQKX8Bf9Yyj9K+lrAVr7u7zJjBL0P6i2nJrbaOnZsn9xwGMQNxweOYhu+cB00
         2wwqympXEsibhLmXUT4HllBjOn17DRfUROWBGkt7i7ZGTS0PdBXitOp/dK+p787JoElp
         sbeA==
X-Gm-Message-State: AOJu0Yw+ac8zu/dfF0NMpKEQSWKrnKOJ+4DHc3FTiggB7qc39fWXCWDK
	8vIRVACM+1Y5NCDbrOfdjRJhVKJe+sXv9bV64mKQFwz+sUMAGVlxgctUo3YQxpU=
X-Google-Smtp-Source: AGHT+IE2k8hXCJX/bj9om1UweOjA25Pz4jUU6lss7nk52A61GIxcZcxIn04hwz+n1bH8ozX47cenoQ==
X-Received: by 2002:a05:6870:1d1:b0:25e:c7b:ca8f with SMTP id 586e51a60fabf-25e2bea6a78mr7691995fac.46.1720307386324;
        Sat, 06 Jul 2024 16:09:46 -0700 (PDT)
Received: from [127.0.1.1] (23-93-181-73.fiber.dynamic.sonic.net. [23.93.181.73])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b10abeb23sm3362934b3a.72.2024.07.06.16.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jul 2024 16:09:45 -0700 (PDT)
From: Cade Richard <cade.richard@gmail.com>
X-Google-Original-From: Cade Richard <cade.richard@berkeley.edu>
Date: Sat, 06 Jul 2024 16:09:44 -0700
Subject: [PATCH kvm-unit-tests] riscv: Fix virt_to_phys()
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240706-virt-to-phys-v1-1-7a4dc11f542c@berkeley.edu>
X-B4-Tracking: v=1; b=H4sIALfOiWYC/x3MMQqAMAxA0atIZgM1iKJXEYegUbO0JRVRpHe3O
 L7h/xeSmEqCsXrB5NKkwRc0dQXLwX4X1LUYyFHretfhpXbiGTAeT0Ji6nmgVjZiKEk02fT+d9O
 c8wdsGzirXgAAAA==
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev, atishp@rivosinc.com, cade.richard@berkeley.edu, 
 jamestiotio@gmail.com
X-Mailer: b4 0.13.0



---
Signed-off-by: Cade Richard <cade.richard@berkeley.edu>
---
 lib/riscv/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/riscv/mmu.c b/lib/riscv/mmu.c
index bd006881..c4770552 100644
--- a/lib/riscv/mmu.c
+++ b/lib/riscv/mmu.c
@@ -194,7 +194,7 @@ unsigned long virt_to_phys(volatile void *address)
 	paddr = virt_to_pte_phys(pgtable, (void *)address);
 	assert(sizeof(long) == 8 || !(paddr >> 32));
 
-	return (unsigned long)paddr;
+	return (unsigned long)paddr | ((unsigned long) address & 0x00000FFF);
 }
 
 void *phys_to_virt(unsigned long address)

---
base-commit: a68956b3fb6f5f308822b20ce0ff8e02db1f7375
change-id: 20240706-virt-to-phys-2a27a924ef2a

Best regards,
-- 
Cade Richard <cade.richard@berkeley.edu>


