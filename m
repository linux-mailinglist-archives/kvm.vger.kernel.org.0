Return-Path: <kvm+bounces-6838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D0A5383ADD0
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 16:54:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91BA328AB87
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 15:54:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2785A7C0BE;
	Wed, 24 Jan 2024 15:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pa0XpX3P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F0D7C099
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 15:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706111672; cv=none; b=HWp5tuDDzC0Eqxo8YEPqaXvyUx16dKyjuN+UUZgbccjmu4WE/j9dS0SaK3Rxgcnl9gDNLjyrCPTvGtweVg4pAY4ezXg3TmeOA++lRqlcEsdTpihNdnIMn2C0EwPoZZnXKLUCH9Cte28rZvpRlWwMrayC4+Qs8I7gzDdU8YRIpMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706111672; c=relaxed/simple;
	bh=RbqbZCIp07l5lmvZjXI3xa6wQBM2YLtpD34Zryh2DwI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=S1hZlGyhSIL3MgrXCrp5dyCbOseAwBqNtIfFPv9Xa439cn12NIFlW/K83Ho9ljiSsXoamnSLQmsiDbXR3lMhliEI1O5oKhFauh6kukw41GKNj/XOE5fU0l6UP3tB6Z86BZPdHKyRxSB8pav25m+kuyrVhZQA/4oBj3OKbs1fOXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pa0XpX3P; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-337cf4ac600so5240616f8f.3
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 07:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706111669; x=1706716469; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BK/V9dj5YhGk0iLWuoz8QxmPAwCjQLFlhcHGZGmRcrA=;
        b=pa0XpX3P4rqQCTbiF1i/gMefGpIRxn+VFO3uTH+1Rzx9e3g2vWko745YXXMcKhvHYM
         hgIefIXDsRG9yV2FgitLhZzISY2PDdixQwlEOOix0F9b301KeolMdWjdCI9owVoaVUFK
         B8dJpcTHsvl6W7TwEQ8lrEnUyZaVIjTThWcJbq9IO+k+N9tckxVGKRKqJ6ILd8EZWGUB
         uy8U5UaQA3K/70FoKDdQHG0Pt2Sjj5u7+EtbXI6SdsINyqZMbXbqK7CCgpp1Ee7lP9gW
         OBoMqw2UZBSclnsZNwohwm+wg9qQNTGwdtDssp6nJ+xdFiHR5Zfquzy5AkS2vUBtGS17
         B3ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706111669; x=1706716469;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BK/V9dj5YhGk0iLWuoz8QxmPAwCjQLFlhcHGZGmRcrA=;
        b=Af7x6PKHN/dgZ3v8V3gnuDE8q/a5RgZgdwbbfFOuU2Q2h4ybClH15hmeihK97cozW+
         4+xSLeFNE0umNhnRDmd3m/bueYwO/SqrWRTDLq99rlWYgLvjb9nCtgAMujwJvF/Lp/q5
         lE+c/WY0l1Y1BvQV0iOptwG5Ts/k9YhZ3v3QeC2fJQK0gpqsAbXA6AoQUSA6v9yLY46S
         gsPPVH3JrGMfio8TsgkRwybIHczzFmuu4wxQl7GdfSU+TiJV1/8UD7jP1DU5RNGlPtS1
         K/nwB3OOym4+/E4E/vGVH1oIzFN46mmAvIk7NVSBF5Xqowr1BAYmzYzIV6ZPTDhhyIqo
         tALw==
X-Gm-Message-State: AOJu0Ywt87+nSir+0+Bn+EPAx6pgGwwuK3yK0qBn03j9xnlAXIB4i//h
	U3C86edTLv5rIMthzb/rQAhhkjeFxhQaPUFhyv2dKK2K/sxerQe+u+H9rnmp67I=
X-Google-Smtp-Source: AGHT+IG2MtMetZMY4/fR+PXshiy11q1zfCHCJ3qkPsPw0ct+u49aNQGsO4wE8N5S1kr6GfY3ceeUyg==
X-Received: by 2002:adf:eace:0:b0:338:fcdc:ad19 with SMTP id o14-20020adfeace000000b00338fcdcad19mr698831wrn.6.1706111668791;
        Wed, 24 Jan 2024 07:54:28 -0800 (PST)
Received: from localhost.localdomain (lgp44-h02-176-184-8-67.dsl.sta.abo.bbox.fr. [176.184.8.67])
        by smtp.gmail.com with ESMTPSA id a17-20020a5d5711000000b00339273d0626sm11842179wrv.84.2024.01.24.07.54.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 24 Jan 2024 07:54:28 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	qemu-riscv@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 0/2] accel/kvm: Sanitize KVM_HAVE_MCE_INJECTION definition
Date: Wed, 24 Jan 2024 16:54:23 +0100
Message-ID: <20240124155425.73195-1-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Trivial replacement of KVM_HAVE_MCE_INJECTION by
KVM_ARCH_HAVE_MCE_INJECTION (not the "ARCH_" difference).

Philippe Mathieu-Daudé (2):
  accel/kvm: Define KVM_ARCH_HAVE_MCE_INJECTION in each target
  accel/kvm: Directly check KVM_ARCH_HAVE_MCE_INJECTION value in place

 include/sysemu/kvm.h         |  7 ++++++-
 target/arm/cpu-param.h       |  5 +++++
 target/arm/cpu.h             |  4 ----
 target/i386/cpu-param.h      |  2 ++
 target/i386/cpu.h            |  2 --
 target/loongarch/cpu-param.h |  2 ++
 target/mips/cpu-param.h      |  2 ++
 target/ppc/cpu-param.h       |  2 ++
 target/riscv/cpu-param.h     |  2 ++
 target/s390x/cpu-param.h     |  2 ++
 accel/kvm/kvm-all.c          | 10 +++++-----
 11 files changed, 28 insertions(+), 12 deletions(-)

-- 
2.41.0


