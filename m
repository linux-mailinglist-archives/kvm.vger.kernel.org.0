Return-Path: <kvm+bounces-59403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B991BB356F
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 10:52:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02CD34C6203
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 08:45:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0F052FFFAC;
	Thu,  2 Oct 2025 08:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ngfginz4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3580B2F360A
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 08:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759394533; cv=none; b=DqwIdeHoJnaXEmI+Esj9dPQ4j6Po8UoykjnJOfPbGM01XL1+bKgtc4BRgwPRc4Lo5kYWJUlPDUfgklgjesNkuUk6OV4o0YoHxKmds+hfZ0hSOGwFXmg+rXdCSa2++4zxbEmI0x38yn1Xf/OH1BEv+Vb7PVLmerH7tLWHgZV6Nqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759394533; c=relaxed/simple;
	bh=m2XlauSQwy6iP5O9cTVakYNdS+D0tVNg0YUz0E937M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pUKJrIzw9td+OVL9aT3nobGI0fWRP1rHraliSEZiKPgUzY92u/nYJPrvlLUx5AEst6d+rAb2lX8QTHbng+VlgjsH+F/SwSlLciRwB6GMSg1ytD6eO1acdhJbjOT8XAaeTHJzWT80Gpz+BqFPnqzrqUJpCobEXsFG0TVq7adosqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ngfginz4; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-421851bcb25so380475f8f.2
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 01:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759394529; x=1759999329; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I6r7ywVdtgg6puBO7GNeh9QBn+ePwbPPQeAATrRMKjs=;
        b=ngfginz4frEGEuwdBmwLakzAUWM2IRc4fTps5ZM0nDHc2zNJyfeOymWueqrVM3yIZt
         TmZkCHbsZjaZV/5xGKlUtJnPsS7NEm70FtBxZ8fkOsDa8nqS1Wnn9Cfy4cWihRJerez9
         09gSn9lk/hw27yEgGcvpa2xB9NgiWlNTQGbjbhkvrY2ry5AtB7hXVBV7SvGqr2sLOZii
         ZHPkN2K1sQR44V/2wobj5cQVYQojOnCgia7cHPMTdBym1kg9qMBB/CfPtCXqraWqyJH7
         i79I8bYMz2UiOG7tRVbxOnNfNwbstT8qeFtvJsUuk+euHSUGyrkCKnsJsXISS/ObkB2b
         qSGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759394529; x=1759999329;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I6r7ywVdtgg6puBO7GNeh9QBn+ePwbPPQeAATrRMKjs=;
        b=f/D5nbGbx0w9mtllD59h3TNAOpsPBx2wf0yjjGb4kWckMz7CLmsCTVi1w2/B1PP0I1
         vwlrlRFHuhVL+MnLC+rOFS0smTVA5Trgbv6XBm79Scj2gdB1rlaRVuPXnD0QLa69lV1+
         QAsltzHcx4WcvUZwyZSIW5pnZRp84qJJYCNYFnnXddQBPW9fo1wjBjk94Rzp9a/Kvfhw
         M+5moXeqg+a5T6rf/gtq0JHLMqRDZ1AzNSe11WT4gY+eTA3cnieBWGZQx5fy9Zf9N92m
         ZOH1bKbHr5siKVxA89My22SFI+/WaA/KvQnMHZ3tD3WP1iHNjfgEoBeaKshPFU8PtZEg
         xyMw==
X-Forwarded-Encrypted: i=1; AJvYcCXqzPKoEj0E1MC7pqyy6U0+ZwOYHyTbK58X/hxO5OuKl3PG53dOvf0YRJLnZZxEa//S9WA=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywd/NuFgnxHc2jrOvVvjhCL8RD98Uvhq19j2E45ffCVxIgYFm+2
	8MOvgvT7P0iKxzmEwimNXF710WjtsI7h6ZwY+eVxCwdCxvJJHJlpOfGv4YK5oCe/Kws=
X-Gm-Gg: ASbGncu+z2POr1e+LW0tMscEKaJQ1vuBGWPYCo+ITovHcwFiFl9fIvh4vy6Ro5OBPtL
	gUIfir/LbOGhEpqTqlvLPi3sxqbvVbGFMZsWEtS/tEfJsRds5HN2zwtOfCi0OeMKwEO5REEZ79h
	D2BGBVAQbIyq/ZR0tRYc8ktW4n2Qsj2bGXHignxBLYT19TdlvWyXu4VBXeQ4M9xoPVLt23f/KIc
	mBgBDgPteoqoGjDnge75UBo2DPwRoNT7aCKVQaPmfUsgg0Lett6cO3xtAFSBi2KVDFjmtWqssJV
	Dg1jkMXku4uAbZiBb4KZAJn3SLrfcaBQYDTSbJzMvro/qDOxcqnaJP11GGjEtZlNgmFFisFVL9G
	DaMEL36FeCKe+L8CUA4z8TYaD8sd/5RwdteBMnL/TEvoGiyMc3SQOnU+6d8Ibm7Q/b2INQPwSS5
	HVTYlVVNse9oeQbPUxQpJbGtV3Rr9cNA==
X-Google-Smtp-Source: AGHT+IE1u3COjNq+oE6xio5GRW1A/vqSgcySFumrJ67RNAp4nOAK/5HZJkMzy+g6L+RiVVekcEJmKw==
X-Received: by 2002:a05:6000:400c:b0:401:5ad1:682 with SMTP id ffacd0b85a97d-42557807a65mr5230357f8f.14.1759394529461;
        Thu, 02 Oct 2025 01:42:09 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8a6b40sm2649068f8f.2.2025.10.02.01.42.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Oct 2025 01:42:09 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v4 01/17] docs/devel/loads-stores: Stop mentioning cpu_physical_memory_write_rom()
Date: Thu,  2 Oct 2025 10:41:46 +0200
Message-ID: <20251002084203.63899-2-philmd@linaro.org>
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

Update the documentation after commit 3c8133f9737 ("Rename
cpu_physical_memory_write_rom() to address_space_write_rom()").

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 docs/devel/loads-stores.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/docs/devel/loads-stores.rst b/docs/devel/loads-stores.rst
index 9471bac8599..f9b565da57a 100644
--- a/docs/devel/loads-stores.rst
+++ b/docs/devel/loads-stores.rst
@@ -474,7 +474,7 @@ This function is intended for use by the GDB stub and similar code.
 It takes a virtual address, converts it to a physical address via
 an MMU lookup using the current settings of the specified CPU,
 and then performs the access (using ``address_space_rw`` for
-reads or ``cpu_physical_memory_write_rom`` for writes).
+reads or ``address_space_write_rom`` for writes).
 This means that if the access is a write to a ROM then this
 function will modify the contents (whereas a normal guest CPU access
 would ignore the write attempt).
-- 
2.51.0


