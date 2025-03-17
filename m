Return-Path: <kvm+bounces-41265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D28CA65A10
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:14:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CE5E18891DA
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:09:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A57771B393C;
	Mon, 17 Mar 2025 17:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="G9r4nN38"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8ED191F6A
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 17:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742231292; cv=none; b=TPudg401p0EYC37NgWefs7tQp7TA58n9TqlsaJHitohVASbSiEK0vtm2MIOq2LmAvnhhoGEGlmH1KfuAAdJtR7Js9um/cG3EEdxeyIMcg6FDNR5TqThHhMeIB7puHBPjpuqLP/ZHnD19jiWcRpWZT7TUDd9Z3V5bXTQ8gSifDAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742231292; c=relaxed/simple;
	bh=EqhrCUXSdf6zw+zQLcTnzOZbj5bYjW5BfE2OxtlTOLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=azBy+BjQT5GOSr2gN/HNdKJRowHZyUU0DldYoFju2W6tewmGvh4yyt+depNsWyAybmGmSbrEq6rnwAquHNUBblw9oDheIMdvyw2jBMfqarSBSgth349W+mCpL1RopAEZhjJBullh7u8tNEz1YarSBl7fSWveFiVzqc0jzCG1fuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=G9r4nN38; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43cf848528aso19930955e9.2
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742231289; x=1742836089; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xMypehTPr85TSV6ycxYis0bFMGhRtQvpG8E21HWF2pk=;
        b=G9r4nN38XyH2HTtuBkVy9W+NwDz8Moo4aI4gGr+EwLsKq9NWxXkoYdQ9ubj4p5jFR9
         xe1kaDy58L2wL0ItOboKlW9kEIKc63BTQBcyKin+WJl/61p8w9QXJqJaREw4yv7XGf64
         xHqKGDaai+CyTVAOqD2Yh3URz1TITAzSfRn3eI2zrw4UyIVafIBi9hZOSgyfoT0Kk9JC
         xd9tvfVbZUu+8bM0foI7EsfzUIcddT1VcjI8HYvuxKbNWo0k6GhuK+IXNegiOImnCaBH
         qtL1yFi+1QxvIqRqJmc5h9Lr3749QGvWMym2uKi6Ne5EVrtEv5/oU3mVVYSlHlVUwe36
         9x9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742231289; x=1742836089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xMypehTPr85TSV6ycxYis0bFMGhRtQvpG8E21HWF2pk=;
        b=MAyqZfpziqLnBFpYh1M+VWT2hr3784RBz2zJOe5Wg9Fb5uLf5YbJHSdt62AZdm0SR0
         q6fHG9aAumsmunGsb9OfhIuMiOetXWeI5H09b6dsIva0kZW1Gb2Doqzkq0W+OJfSQJLb
         tC7c7b4PX2uVsQLEW0zaTiYKOEYS0kkUjCZU9jkWPZ27XbPANxnlQIsUab3XbywGrPgm
         Leh3vI2/uzGQ8CFcvIC1TSgup+sWl/jkXz4ZMvqK74vC8Byco6MaxIWV1YB9NgSRUyqC
         jYQfWjxHkw6CzbyFM70wOm5kMrTvyWq+m5DQgK6JOnXdheTn/TVoxe9K7EX+6n/81scK
         jWtg==
X-Forwarded-Encrypted: i=1; AJvYcCWX6jw2Yz6Rdg3DUZmcP2O8lPKN6OstAHwaOa1TTWYBfFf9aKxQYEddcfsS38At+sK8Tpo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEWR29Ni3Ypo17m9rFwSQsiNJLrvWD1EstB2qFFtyCSLQfMkfK
	ikyMRGNCW8Rs4RVeAQ9y73252kchsn+UKkOc3F5WJAK/FJdtD8B6IjGWt4EoLus=
X-Gm-Gg: ASbGnctsvfXDX9J6Sbni95Z+XGTnFx4cae4vq/LKw8T/LjZclMq7UbOe7THXm92OLrS
	BhhoG5uUYGqoSsBlQQxxFBnlV+2uf/mmtTqWNj2OnLV/E+RWsyRM2Vd/heCuA1mMWGKkxWXeuem
	aDIJh+HyAiBo/EPaRy1q1nPVgJ1ebpcrAZvF2yqBY6Plb2QYw++SK81Po7VGHfpyagx4f5zgIPO
	DWznmjgsb64WIGBvPgN7BpctPs/I9fXkCZ/rVY78Ut1OLJfcuPdcidKRBHuHsYA1BF+C07+pKsE
	HMiJpA1v4npnFjCy32naMWraaDHg658rHmVc7/CZGfgf2Q==
X-Google-Smtp-Source: AGHT+IHUEfWy8vRElctY1RJYRY/dHWRIdTIpUq+PBDo9gX+Yv3PK1rGyecjDgc1lfv0PGC4CYGx5Ng==
X-Received: by 2002:a05:600c:1392:b0:43c:f4b3:b0ad with SMTP id 5b1f17b1804b1-43d389d441dmr5431565e9.19.1742231288764;
        Mon, 17 Mar 2025 10:08:08 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d23cddb2asm96014505e9.39.2025.03.17.10.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 10:08:08 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH v4 02/18] riscv: sbi: add new SBI error mappings
Date: Mon, 17 Mar 2025 18:06:08 +0100
Message-ID: <20250317170625.1142870-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250317170625.1142870-1-cleger@rivosinc.com>
References: <20250317170625.1142870-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A few new errors have been added with SBI V3.0, maps them as close as
possible to errno values.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index bb077d0c912f..d11d22717b49 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -536,11 +536,20 @@ static inline int sbi_err_map_linux_errno(int err)
 	case SBI_SUCCESS:
 		return 0;
 	case SBI_ERR_DENIED:
+	case SBI_ERR_DENIED_LOCKED:
 		return -EPERM;
 	case SBI_ERR_INVALID_PARAM:
+	case SBI_ERR_INVALID_STATE:
+	case SBI_ERR_BAD_RANGE:
 		return -EINVAL;
 	case SBI_ERR_INVALID_ADDRESS:
 		return -EFAULT;
+	case SBI_ERR_NO_SHMEM:
+		return -ENOMEM;
+	case SBI_ERR_TIMEOUT:
+		return -ETIME;
+	case SBI_ERR_IO:
+		return -EIO;
 	case SBI_ERR_NOT_SUPPORTED:
 	case SBI_ERR_FAILURE:
 	default:
-- 
2.47.2


