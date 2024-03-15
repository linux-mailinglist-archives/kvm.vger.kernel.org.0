Return-Path: <kvm+bounces-11900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F8EA87CAB5
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 10:29:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35FEF2843F0
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 09:29:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FDF617C76;
	Fri, 15 Mar 2024 09:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e++MNO9Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0431C17BD5;
	Fri, 15 Mar 2024 09:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710494958; cv=none; b=M37x8QgE0i3T2q4OYXMeox4ZZCxBNx1KHTSCv06s7icblnKhZaeqxpWoukmhQ4JzANTe5rcjks6Oq0hhnPaQROiMsPzSxPVjb3gGZSHtXfjMA1QqDqPEVdDrWAYL7W2hbed+zLB5aQ0cEngHGu+vy1BVdjps9BIPUOsvpeU80ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710494958; c=relaxed/simple;
	bh=wqJicanmbWrVswkMM+X7rKf99P006pSFr8h80mtjKJc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=HN7Py8e3W8dB7mawBQcLUeqBLcHjRONyK17WV0tySmWkL5bckhWWbTAxeMhT4p5W4IzfUCMN2KXGSTwq1UGqL8DC2nkVUMkE7xbG5cct7f2lneKFzVcgMZGU63HJUQ/EFIe6XGtwdVnGMXGHfKk8rGqH0sYLd90VHikIdfURGx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e++MNO9Y; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-33ed5b6bf59so93346f8f.0;
        Fri, 15 Mar 2024 02:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710494955; x=1711099755; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yy9UuaOwwnjmkLdHpJLRJuDPkF6dNfVXKVVIwe8goJw=;
        b=e++MNO9YyG3uV5e56fOZWgKSfc2rsbw+djjlTr2/AMFJWsKpXJxOC2D7sfoPXqFg+I
         WVy6DDWqgL2LEqeY7DDEe8ZJK32xY+qH4jpG+A9Acst7dstahrGa/zSeE3Yrp//AuPeS
         lLV2ckXOwXmeri+Uh9KMMqG1y6FeTe6CjW1Ee3ZR+V5IwJU5dJqIgUzapvkFpyuZRobA
         XtOHDs3ERj/ESCGf5SadkY1KSiGhEFhPerxim8EW7Kta3M89XluIQjIG0Uuy6gq9ox5P
         h4U1s0mdML8g8lrvI4nPbsqzjp0Q+3jxxAcGJE9HENTWHCtHWidXMOv/+6bukkKjUaf4
         FvXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710494955; x=1711099755;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yy9UuaOwwnjmkLdHpJLRJuDPkF6dNfVXKVVIwe8goJw=;
        b=kL3o68vsGoG9mRcwuaNK/bjQiMCo/xzt70TyFecoDLa10ffbzTSv/BD7bbNF3UVUEj
         a+/hKInBbrgFcUd2pLhz9GcXu+m72Sd8g24lRP/37JfQiaMPkt2Ldd6YIp15HIoU+jG2
         wwX8uAGcHWHj12NHYLDrzJW7HSE3CTIjGxv0mtwmifl0L+Kwncry8VGvRf2HOQwpmX+c
         6rEtC4mP9/LxVkoOcZlL60fEAiFexifeSePYRpvw6jEWlcTvhc47ChOyeETcCotKbriS
         nrZxEvWYlwIL6YY54DlG+rKR0qkWtegRXHwarbrsirmhqfSw0Gmg+stA3nQMucNkApqo
         EuIw==
X-Forwarded-Encrypted: i=1; AJvYcCWVTzORYXgrtprHhyaUEGTiGGEWc7AWDfz78dmo7bVjIsBSx5PyQJsiPNmJdopVNuaJ8ipz/z0JyCdfHNEecpLEy2K9TWQMbnhLTTuFNPk0xXWCtlsTY+OTAJtBbQYnPy9F
X-Gm-Message-State: AOJu0YzPaHin0EjL7Wg6wEzrcnOEAdpFFQCJADuJykVpvUWssPkeVerp
	eciAhAbhciDKkTiKJfxUI4IuFMDjY7IHgoy8AA3zjvc9YnPW2428
X-Google-Smtp-Source: AGHT+IEmfGjtXZvqB0qQ0wkuzU6/qV0BfQY1EeQ8qHol34BJoU6SPpfV0XTqiH0QZzTBWkH99PXJpg==
X-Received: by 2002:a05:6000:4e4:b0:33e:78c4:3738 with SMTP id cr4-20020a05600004e400b0033e78c43738mr3615149wrb.54.1710494955224;
        Fri, 15 Mar 2024 02:29:15 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id x11-20020a5d60cb000000b0033eca2cee1asm2736644wrt.92.2024.03.15.02.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 02:29:14 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] RISC-V: KVM: Remove second semicolon
Date: Fri, 15 Mar 2024 09:29:14 +0000
Message-Id: <20240315092914.2431214-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a statement with two semicolons. Remove the second one, it
is redundant.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 arch/riscv/kvm/vcpu_onereg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index f4a6124d25c9..994adc26db4b 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -986,7 +986,7 @@ static int copy_isa_ext_reg_indices(const struct kvm_vcpu *vcpu,
 
 static inline unsigned long num_isa_ext_regs(const struct kvm_vcpu *vcpu)
 {
-	return copy_isa_ext_reg_indices(vcpu, NULL);;
+	return copy_isa_ext_reg_indices(vcpu, NULL);
 }
 
 static int copy_sbi_ext_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
-- 
2.39.2


