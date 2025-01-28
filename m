Return-Path: <kvm+bounces-36780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AE13A20BF4
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 15:22:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9C6827A33FF
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 14:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D93521A9B3B;
	Tue, 28 Jan 2025 14:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mZayt+7/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B65BE40
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 14:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738074163; cv=none; b=RbMwjR5yCNhuvZnFwUqdgVbOPMj9E+mkgoY6B/LvEqqIZHEpmugKNDUlj6BJ93pv6Jb1pyR30ZN/kiEkl+Z8+vNBraybg1Ky8rQREAYjl3CYz1t1mn9H6+vtlLZ01E63cfaOgv7k5DXRYttxeHqIzIH5KsfSgl+zQEk3HrMVDrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738074163; c=relaxed/simple;
	bh=5TgS81tlmP8UtIxJAetvffRGOG/PZQxZ0zBesx5Pcss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LEFt3TnMnXXkw6OYwp7iiUICvcvUvbsECetHfLwcVf1Jlgm2NCc01RKzsT17zoX9f6EaH1X6lKwX1/PWZlvEiWBTn9d74vz46sfJ8ezPrY4ZsV1ckZDoBzW1JIwfHezZeDfA8E2Yv5M2c+T00mi01hPYrdTCwbVHgrFVecNXoOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mZayt+7/; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-385e27c75f4so4969959f8f.2
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 06:22:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738074159; x=1738678959; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jN7tNGrfnQkH1jp+7zEAfhWZCNwGy2KakJL6oRXbHIo=;
        b=mZayt+7/17lpfZGHjJRp1UjG77qZDfPZmSeiRBg4BZv5bqc5P/8S+LtHxeuAtMaErh
         4ZPcKarGw+6z3Rij7CcFGV5HQ5CDXVfQpQBJFTq94+oqOluA4qU6y1tTEhNWs6OmKDs3
         AtjGE3D/ey6/01oTTVh1mjGJKyG+IBFCBlSi2nZkfJKF0Undz3YHQlqFJJW9iMLJRb4k
         3Zf251fqCIyZkDFJxNQpEH9/5US02R/3D4aBQG1d8BqxVf6HAiSRS6EFQJpmpXfIwwyw
         zyF/9DClhnokYbImwf3Q/o1vUjDMasyYwTdnlUzaXSyUQveg7DcB87CHdruu59sAf1Dw
         ikRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738074159; x=1738678959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jN7tNGrfnQkH1jp+7zEAfhWZCNwGy2KakJL6oRXbHIo=;
        b=gEFfEAXasj4GGS88LSCM7ZGE/F+7qESOF4JHFdb5uNBA92XrGabRtek6EbUxd0/OER
         DxsGD80Q4rYB96zKiY0vADQ3llp8QRdhxxrhZTEHd8tH7X6Veahq10OiWU0j6EUd2w2H
         zOeNKFpm7YhzqersJ0/hlSahRc8/EmufD3fHMJ+1FLGsgQ9W0DyJWgJwKS+a7ZAj1UhE
         007Lo2hQ2abTQvrU63ObE9hug43VoDqicHtdMXv+wy5ocvM8ofZTgrSD7bhS4BqBxKn8
         kTO3XUoGlENG6wdOTc3V/vO27ac6ZTFR4fJIH+bewLo4IVMRAwcRcSmGnTosF0Qyxjhu
         ZVkA==
X-Forwarded-Encrypted: i=1; AJvYcCVybEZYB3LM6AjqaT6rxd3D6skJIl7rVdqM5OIpUVFfsYfiFlvlg2VOMHg8RBQe+YQsc30=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4ytCdB7xmXkST0MDY4al3uAeuR1xcw18bW/kB8wfuDTjzQYQ8
	2X/ezXU0Coa1LVKsiCThqhRcLVNQ1+8dI94Lw61/93Gyk3ZxZV0M6FXXECksYPI=
X-Gm-Gg: ASbGncsJM9zA6Qu62S3ST62I8mW6zxjRk5ytIkua6sxsQF64WsU8DxskyS5KlW1omoJ
	NhaElUaevqugTsfvCEnbU8UTVZzMc3HU+brk5tdwC5azHHrj5NSMgIhW4fCTxSW8oNVMJorNDoH
	XIo77UkbuJL2rvUGYjE+Qz32BXWQvHVDUCVJZ3AOMnOdWMqJpAdfjdR6j9PdblI9OSVcxkWzy94
	VPo/GpWEQNx0pSy903rXxwFDIBRJwNZClJV/PXdilNlkbgoB9BYMsPlD8ZI/JYt+ULJ8bAUYlCo
	41Cjs+rsAYDWHExuEvZazoGUmrDfaKWw2sl8ovuGttqtMiukXd024NJhN5IMu8kiZA==
X-Google-Smtp-Source: AGHT+IHfjGCtubVM9RMAK88E03g9Q6/raB5p2ips8Ty3wdrHPHY423HNQ2wht5Ir+apIlpYx+7iAnw==
X-Received: by 2002:a5d:64e9:0:b0:38a:88bc:bae4 with SMTP id ffacd0b85a97d-38bf5784ab8mr43777014f8f.18.1738074159686;
        Tue, 28 Jan 2025 06:22:39 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a176434sm14462219f8f.13.2025.01.28.06.22.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Jan 2025 06:22:39 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH 9/9] accel/kvm: Remove unreachable assertion in kvm_dirty_ring_reap*()
Date: Tue, 28 Jan 2025 15:21:52 +0100
Message-ID: <20250128142152.9889-10-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250128142152.9889-1-philmd@linaro.org>
References: <20250128142152.9889-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Previous commit passed all our CI tests, this assertion being
never triggered. Remove it as dead code.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/kvm/kvm-all.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index cb56d120a91..814b1a53eb8 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -830,13 +830,6 @@ static uint32_t kvm_dirty_ring_reap_one(KVMState *s, CPUState *cpu)
     uint32_t ring_size = s->kvm_dirty_ring_size;
     uint32_t count = 0, fetch = cpu->kvm_fetch_index;
 
-    /*
-     * It's not possible that we race with vcpu creation code where the vcpu is
-     * put onto the vcpus list but not yet initialized the dirty ring
-     * structures.
-     */
-    assert(cpu->created);
-
     assert(dirty_gfns && ring_size);
     trace_kvm_dirty_ring_reap_vcpu(cpu->cpu_index);
 
-- 
2.47.1


