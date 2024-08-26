Return-Path: <kvm+bounces-25023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5BA295E7F2
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 07:33:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92A132814EE
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 05:33:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E5BA6F303;
	Mon, 26 Aug 2024 05:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c1OP9fE7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0208B8837
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 05:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724650404; cv=none; b=sVySez35kwCYlEBGv59Av+/BLA0O+zIx5e4GRXd0RD/Yvp5/DBter8KyTr/s2dK1fscU1X9PPlSPzg4Te0gZmEEKUwnYpJMrHkbIuuXFViPDyfRS05TSKkZowZk6wKh59z0CGR1I6A8oV+5x3z/KWpqqapP/WsOT2G3Kxn9Hokw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724650404; c=relaxed/simple;
	bh=d8Nm7TYPFq1Y1drL9PQYrfAuaqftnUVMMvDSgOIJ97E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aRB7CnWWLwU2fFW40PfQGkAAu9yYWQs/IjH4aecrdDAwGK45s8zyoj4+H+dVMEoRSIhuLyQ2x6tglzWL0w6dFHb97BC7qdBGESpDq7bTKdTfqGtOcFyn8HP4m/WkaIjLd1PtWHiVGVJ3KLNGNIRCk8FuBQYhz7VQb4q0+ZbOfKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c1OP9fE7; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2d3d382de43so734310a91.0
        for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 22:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724650401; x=1725255201; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LG6ECt2BSy6hKks/OidyJbciz95FSOmzfNaZ+zacW0c=;
        b=c1OP9fE7kdJovxjafJFCLxkzYaQ9joFxec26ibY2dwarLbnk7To8rUQxxDXdXtmAq/
         UUtff4IJi2DJ9HHE31j5MbFLoP6StOylpIIjhUeiiTPHp3O8CODyU53Xz2EbUAKPT7LH
         XZgSsRwe+QwWqpz9cnzmkzVyxFJMkQewEl3VEl1ejzbbAFunkI6kie/Ez4Bd8vQ/58M+
         alFAOxrGFXLfue/ZREyY9HIM39t2eXIiHGDVL5qbld95G0SM2xj0fnRTbVYysmNGQQSk
         rIRCDZeyiVf42YI4Or5rgBlZK5xJbgQz5Kqlw104ZArsTYdY03x/xXHWfjjisDAK0tk9
         evlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724650401; x=1725255201;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LG6ECt2BSy6hKks/OidyJbciz95FSOmzfNaZ+zacW0c=;
        b=Uj9CVhhhYmui8hLfeSAKEjBtOu1cJCCyTTnDiVex0IUgyJVisYUbqJvX2m0PoY791J
         NPJeCqUjHVJ7J1yyEG7rl7+8hDzCbjx5mPAbcrt1SW8qU8CBS8GSug0ch+I6dT4ZVMkB
         EDFhwS36dUIuV9eN2QDIY5ZfOne050Cf7cqcf0Haqc+OATYbkJ6wBwJap7r191YSWxZL
         vL8RBHqf0AZ3C3e2CeuyxB3UFMBRDNW0dkywNcTRGbp4Qyq+TBGXAbPu4Um6Np6It48h
         s6i8g6L+TdY4xof2NlRZixqHzchRpF96NvbQK0kQETIFMAx0+t3QoMLp3W8jFU4NQCNu
         RtRg==
X-Gm-Message-State: AOJu0YySPuN4WrMpP7lwW1RlA1TGlM3rlyYfX8uaM/L84erViZ5yd1B0
	Qhwn/2OjGfZ3wH8UWSixRvCJGF/9wGvMFgnvTpNX0xdgHh0ZqU5tCtZbCGZf
X-Google-Smtp-Source: AGHT+IHO6eHemEk1Deyr80stU6eSAg1kwZClmJ/uuY/XxbM6I9zKGhZ9VJWuLDn3QBfXYP2+804DWw==
X-Received: by 2002:a17:90b:108c:b0:2d3:d6fd:7218 with SMTP id 98e67ed59e1d1-2d646bc8757mr5873840a91.2.1724650401147;
        Sun, 25 Aug 2024 22:33:21 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-75-144.hsd1.ca.comcast.net. [73.185.75.144])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d6136fd167sm8792728a91.5.2024.08.25.22.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2024 22:33:20 -0700 (PDT)
From: Cade Richard <cade.richard@gmail.com>
X-Google-Original-From: Cade Richard <cade.richard@berkeley.edu>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH] Added prefix pop at bottom of DBCN test function.
Date: Sun, 25 Aug 2024 22:33:09 -0700
Message-ID: <20240826053309.10802-1-cade.richard@berkeley.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Added report prefix pop at bottom of DBCN test function.

Fixes: https://lore.kernel.org/kvm/20240812141354.119889-10-andrew.jones@linux.dev/#t

Signed-off-by: Cade Richard <cade.richard@berkeley.edu>
---
 riscv/sbi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/riscv/sbi.c b/riscv/sbi.c
index 36ddfd48..01697aed 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -418,6 +418,7 @@ static void check_dbcn(void)
 	report(ret.value == 0, "expected ret.value (%ld)", ret.value);
 
 	report_prefix_pop();
+	report_prefix_pop();
 }
 
 int main(int argc, char **argv)
-- 
2.43.0


