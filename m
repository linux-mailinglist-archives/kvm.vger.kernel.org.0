Return-Path: <kvm+bounces-42936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D4526A80C1C
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 15:26:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A4DD1BC2489
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 13:21:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F4D045027;
	Tue,  8 Apr 2025 13:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mld8XBw+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FC279F2
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 13:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744118465; cv=none; b=BxSzX4afmv1826hzaUPkzlTo8kXM/a9ewZXhGqvOxzNxhDMuSXSY1OdRN/8r/HBMpwOV2/7VwW98YQ9gurU7dNs6pH3BOGHxWbSLhwi/3qkYnCr4QCCMVPs9b3eRvIagDkQx5BRttYQT7xReGzLxRV4OOfdBICGXX85hmbBp9dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744118465; c=relaxed/simple;
	bh=KcTfiSOyKCaCnQHcVlRQ6JHTHx9LGVQ9b/cadvjGZ/A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sZx6qHBvPM5fYBGn48iJ08bGk45l14UPlGDDgngQ8scg1pfLF63ubdPtqcT5SKYgq/gSbaaHsqxxNc95eDSLeXRhHTFWQzRN5VGHwYbo+X7qLfAuALF60eBqcU7CJQNqEvPT4pmyXwmezMQBd99GocV66MTj+QzVcaeXZbB2jJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mld8XBw+; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-39149bccb69so5186267f8f.2
        for <kvm@vger.kernel.org>; Tue, 08 Apr 2025 06:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744118462; x=1744723262; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tLzGVjfFwFoyJPuo3LFygEBdjW+ximdrgVz6RHGw44k=;
        b=mld8XBw+137ldX+p6MqgdaAXeOBbu8H3ceLSmfZai9VUtXPwP3s6g+Tj8PEThjWQ3v
         8gk7xDEqSBtS+MaisU5yJglxlPeEgTNENIvtgOhh9M7a/aljztFUz1H3PiZvMNZpUfnI
         nP7yKf+B/d7ouOwOoRPcEcdxcaZaEfrb7RGLB7SKcUZcs7oi0JGLFSmvzcirB/bs6cBc
         r6xxcPmkKZ2rJsIRSmYWLi3cscpk6YxyPpJQQhZeZbQAkSIGoZk6XANpMzDsSh0/VtSH
         xF15UaylBceM3p8P5I+IfiyYYKTtOQRi6KAx7SArHuQkOJ8dPAHZNr+o+9VvLBy7lSqQ
         moiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744118462; x=1744723262;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tLzGVjfFwFoyJPuo3LFygEBdjW+ximdrgVz6RHGw44k=;
        b=wwPgRQ7pBSnzu2HgwdYp/fyPRwQfJRE3rrrSrFxXfrSFagIKXQFYWY1u64s0I8U7We
         5r0NwZYWD0auZCdJHH4DuFiMQ9MqA7D5AZsiMXV+Vy9MJ0N2Ue6VzB8bmCll4X1htmfC
         +FAGLZW+bKD9ox654Je15Hd4bEYGPHyIcmyEkCfoi7UqqFX30ZmhceuIoII80YA25IUE
         5muxtWyvUbL/jDHDuTeGBGGl3WEtOJ/G0tmCp28gek9s7QixOQKG4/p+UTfSjNiltIKb
         ipyZXmDUylTk+tWiEEpD6e7FVYVLZ8LwbvQtmpXVXR/5o1y6Su03izZ8sR7xK97JzYCS
         d2Dg==
X-Forwarded-Encrypted: i=1; AJvYcCWkEHIGN/3g6bGKWT/fVvfezcNcgTi0lExmrS0E2kMYHI3hE6H3Ss5Qghrv1kIHD7XCR6k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFWKxkcqdGM2d7eJbKFFljbiBBqyAMw+y14HJr5aBnhT3Oo0pl
	u2q+aXi98ElrCTRj6RGQjf4m6nvUlYPU1aGHxRndzdtAlaAjb8Z7T+ZTVxEnhkY=
X-Gm-Gg: ASbGncuwcpa8SX4LQhTwTbJVksguaW0RTc+kbau+u9x6vi8RL3vuQ6nZGtfJ4SOy8XD
	lvQlFLO5p8e+cWH932sOoz0qX7tVgpAJhRr2iroUQsFwqh9NJ/YDEtpgC86M9Yw9uNLpAivQG1I
	emASBRU/WlXXV+Bev2MRbePfomew5AOSpT2KAmfBgaYp7tLdGkJ0xATWgdspJ5FpabxWYpeNmTJ
	wliMqFK2g5xywuXPvhPCFcmlyclNj2Elg5kcKtzz3Xey/5FyPDIvdlWXXi38oorCWizJdJFBjOy
	uf91WnTmZFjTZ/fiTZdEQ0ani0L2J+EPrJxSletnSpMuP4vymctCPs7LMXcNXLk=
X-Google-Smtp-Source: AGHT+IFUXJbj+KVBhVs4CmMtvIJd0GuXCkofSH+KbPfymhQIkFcV7EPYfaSIBB6hI0EIGOuLDwtPXQ==
X-Received: by 2002:a05:6000:1849:b0:38f:6287:6474 with SMTP id ffacd0b85a97d-39d6fc49319mr11362861f8f.15.1744118461994;
        Tue, 08 Apr 2025 06:21:01 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec36699e0sm162159705e9.35.2025.04.08.06.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 06:21:01 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v4 0/5] arm64: Change the default QEMU CPU type to "max
Date: Tue,  8 Apr 2025 14:20:49 +0100
Message-ID: <20250408132053.2397018-2-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v4 of the series that cleans up the configure flags and sets the
default CPU type to "max" on arm64, in order to test the latest Arm
features.

Since v3 [1] I renamed --qemu-cpu to --target-cpu, to prepare for other
VMMs.

[1] https://lore.kernel.org/all/20250325160031.2390504-3-jean-philippe@linaro.org/


Alexandru Elisei (3):
  configure: arm64: Don't display 'aarch64' as the default architecture
  configure: arm/arm64: Display the correct default processor
  arm64: Implement the ./configure --processor option

Jean-Philippe Brucker (2):
  configure: Add --target-cpu option
  arm64: Use -cpu max as the default for TCG

 scripts/mkstandalone.sh |  3 ++-
 arm/run                 | 15 ++++++-----
 riscv/run               |  8 +++---
 configure               | 55 +++++++++++++++++++++++++++++++++++------
 arm/Makefile.arm        |  1 -
 arm/Makefile.common     |  1 +
 6 files changed, 63 insertions(+), 20 deletions(-)

-- 
2.49.0


