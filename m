Return-Path: <kvm+bounces-24729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65322959FCE
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 16:28:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9461C1C22687
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 14:28:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05F591B1D66;
	Wed, 21 Aug 2024 14:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="FTTWVTtt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68E61B1D50
	for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 14:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724250398; cv=none; b=YttiJ4V082F3fviE5jVUOsvLFW8EWwP0AxFBVYXpml9zxzjefrugfHuIw3H0mRK+A5ddqVxKbXSUfs2vQ0eI+TbBRzEEIMdF9fcesqOnUF7TwtkdeVTHWLCcgt3R/P3IN6dduYBq5mjhhSq1NKJUN84u8OexUBH1rUMlNK9vwPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724250398; c=relaxed/simple;
	bh=ZW1cuBGY6kprwb4ZgXG9HoiZbypy36sHRhE1zQlKdDY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YMM57DuGmwW+MbB9AqZxGSh7Z8dTGYOzwhFEloR4bZUNot/uZd//9jwQ1BepF/tNFixl8zSTrInHKu6Ljmq07CcFg8nyn1VnRkqlGI+MrVUQ5BO0o+3YlX/R2KGuS6eGTbt4UUBD33xFgeaPX5ij36zJoyeyxQ/zJTKKAh8D2Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=FTTWVTtt; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-428243f928fso74241535e9.0
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 07:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1724250395; x=1724855195; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d4mSF93PgiWpq+1B4knOfkPZtnBUjZVQq+MQgIG8XPo=;
        b=FTTWVTttRBJmbDlcK+JUrUkc0WoZrYGbc4cLIY0vAeKo1aeqiKO1Z4dV2WUF8wLYFu
         i2PNjBpi3cuPzejYXSUOzbgl7fzO7QZkrdpZysSFzjFm6+BpzHj3mI2ev13HWob8wUkk
         t2tty5gTd3n7y0j4sFk5exZBpY2voHCFcd4NeP7add2SKnL8z/W64twL/X4eFi0RlWYU
         or6pIUBzz0xsxSmMAGeI4i5QqlqDYWgeJsE9tIWQQl+mTwbIt+94SYUJ4lVDE3ZuG14b
         rvOjegaChxgubZUtf83nsdQNbm5YoDzRHn5paHq8SF1BWAjfzcSYtG51P6Bc11FeXoX4
         ZnSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724250395; x=1724855195;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d4mSF93PgiWpq+1B4knOfkPZtnBUjZVQq+MQgIG8XPo=;
        b=TIoabS2Pc5FGMAgE6uo5GTexDEALgWCb3uYcUWFvGgz3hd35tQHhAmxE1Zt7mXBY3F
         J+C87pnGjN8i0LWLwfOla2asth9CO+RnUHeqCvIeLGcma5JCD4kZWM2+7CkknTUMkxm+
         jMaFINXK57IWMesUinCmow3YB8yCFjfCtxNXQQQSFSfMLSmvLz5jjxORcKUlEhAP4zJx
         eWXp0w8+LLDQN48EjcUevNVuYQAbYlzyI7bM8iCI+RRUosfd5LvETobvkVzj32iBH0aO
         /eVJIi0BAAuCJe8aBws9qd0SiDVYf28bs1Diah/coILLuLWo2c+17H2gmJ3i+R3fz1LC
         5Kdg==
X-Forwarded-Encrypted: i=1; AJvYcCXzijL2rOYyE6enAlTyYT5+xBZsC/8NzHiM1BVVK6AJEM/ayh9OZVmcl2UcPCnV3d2Ojgg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPQbriA3EXTCE0bzTEDYpiAd3ehZilPiPSTF/5HBj3jib4Hi6d
	CF2edV2X90yLwXkKwOAgmo0kMwbSrIkMwzj4Yy+/xuTPEMA6F6l/nwctAZYIQos=
X-Google-Smtp-Source: AGHT+IFt+BUBh+6UCdvWym46Cb/EXnlUBn2S6PRSao4ssWJDwmgpWKnskaeNXKbTtH9i8sN5ZXPnOA==
X-Received: by 2002:a05:600c:4fcd:b0:429:d43e:dbc3 with SMTP id 5b1f17b1804b1-42abd25589cmr24119445e9.34.1724250394357;
        Wed, 21 Aug 2024 07:26:34 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abebc34ddsm28646765e9.0.2024.08.21.07.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 07:26:34 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v3 0/4] Add RISC-V ISA extensions based on Linux-6.10
Date: Wed, 21 Aug 2024 19:56:06 +0530
Message-Id: <20240821142610.3297483-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds support for new ISA extensions based on Linux-6.10 namely:
Sscofpmf.

These patches can also be found in the riscv_more_exts_round3_v3 branch
at: https://github.com/avpatel/kvmtool.git

Changes since v2:
 - Include a fix to correct number of hart bits for AIA

Changes since v1:
 - Included a fix for DBCN

Andrew Jones (2):
  riscv: Set SBI_SUCCESS on successful DBCN call
  riscv: Correct number of hart bits

Anup Patel (1):
  Sync-up headers with Linux-6.10 kernel

Atish Patra (1):
  riscv: Add Sscofpmf extensiona support

 include/linux/kvm.h                 |   4 +-
 include/linux/virtio_net.h          | 143 ++++++++++++++++++++++++++++
 riscv/aia.c                         |   2 +-
 riscv/fdt.c                         |   1 +
 riscv/include/asm/kvm.h             |   1 +
 riscv/include/kvm/kvm-config-arch.h |   3 +
 riscv/kvm-cpu.c                     |   1 +
 x86/include/asm/kvm.h               |  22 ++++-
 8 files changed, 172 insertions(+), 5 deletions(-)

-- 
2.34.1


