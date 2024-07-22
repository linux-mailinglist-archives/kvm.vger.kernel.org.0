Return-Path: <kvm+bounces-22045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A32CF938ED4
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 14:07:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3A711C210DA
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 12:07:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A72E16D4CA;
	Mon, 22 Jul 2024 12:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="TpU2SiNt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C1B17C69
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 12:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721650043; cv=none; b=cA4qiu0bRNhzIPHo8UBN1MP12U9uw4udAMfYUjCy86F1rJ3wvvzRyU2j1ozEkomzWUOaI/yfH2tknG2K+OPLy6tLQUURPxU32b6fypJEdMjpZXUbeZRQr0smzKu7grgMXuMVjq8nGXCSwcxGsChoheOVJRX5VhcmYDSGpIAPYJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721650043; c=relaxed/simple;
	bh=IEbsXy+k7f5D0xsBlR4UT2arrloZFYZU3if/JsZvi04=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hTK3HPHnxfNdRBD/lFD48qWJFYxS0N+rl7C6q+asZX32la4HeZ0r8xz6DiW0R66bOVkLPns9lp4+FsJGI7a5E1SxDs2uQ4zwJO/3eiQ5TtVD1/e1D4gc7AiMDmtIOlixgp2vkgY1s86MeJr+XwfHDrOTzHTyh2+Wo330fi5pr9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=TpU2SiNt; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-5c74f6e5432so1694896eaf.3
        for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 05:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1721650041; x=1722254841; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fqfgb4n9ei4IH2SLsy2K8O548sxs6UuXTrnjgb6zslg=;
        b=TpU2SiNtbGTdLoJtAKXb2Mvm3/xP8qZPoecSsgBHdgQ1D3lpYKJJzjIxDqdej9Zlhd
         hwBuSxI8LK+Rfobn9iitYWgrugbZudpwndCtULwN7P3bmAaCDA3OAmuL1CPg2GOyzCKq
         2CZG53dre8TWJLG1JEewCCsUi5kkfucJ3JlkLQfcct7Cr29uYGhWnzdu/WbnptYMVwlM
         8kS9z3opZjZnewWzxTcFv5wnXZDJ1j8DXkniPCV/29MEsYvAmzMYeZGac+vW9dCYxEW7
         XGR9TsLucRQxq41rxaoKDg+SFBiUPde573iA0wmLvEZAO1NCdax+NfszpX2Nq5ImPEh0
         zkaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721650041; x=1722254841;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fqfgb4n9ei4IH2SLsy2K8O548sxs6UuXTrnjgb6zslg=;
        b=JkyjSoitdNub283vbwn9X/r0O1TklIb15OVp+mJ86cWI/oBmGtgmlJ8d4JAVLtphOr
         XTeuuv2jJR2WH8L9f19zxWRMbwXYfRkhONAnC8WKGGp1jeq58z65TzGONXUd85n1Js1k
         cFmUXq5nfNRqQ8hIqvapbyfuZ8oTk9gSgAmcwNzTmD9DVqdIbQCw/C2mPjE8AxI7/aRo
         SAwofyXKIYNenQbkFtTb3Nd3wlc8x3SA3xjQUVJchP2LDXgzluD0Mq37OR6SWXcDoIRb
         aTnf1no08B3o07JhEO1eOOp2LYVyeNj+mVrxS3N2dy8Al78yTkRVJOS4loUfL7D2IBlm
         n4vw==
X-Forwarded-Encrypted: i=1; AJvYcCXELJqjtguO7oaAUiO2xkg4lbtH4YPad7+YrYEbRhKzTDn6r92ol8c7jrYWpuFln2rW5yxfkGf+A4O60iyjCArlFKmh
X-Gm-Message-State: AOJu0Yx5VCqilQC+U6usrlqK6Pt7DAWP7/ayI8OwzzSq7dbKNG0t7pyh
	oQUJOYBGlw1HISmRDBtGoEj6hotOkZh6P4EoPBKENb83gvv5HFkhfuLXWEdlJDE=
X-Google-Smtp-Source: AGHT+IEdC3pKQH4Cw+JJS/4y6oZgvTdDqSuATEvTpkRhBwe5M8Zwx8z+Eno+04M2wneD0NcnQpVhgg==
X-Received: by 2002:a05:6871:42cd:b0:261:20f:c297 with SMTP id 586e51a60fabf-2638df894eemr3724005fac.11.1721650040843;
        Mon, 22 Jul 2024 05:07:20 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2610ca48ca7sm1637855fac.42.2024.07.22.05.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jul 2024 05:07:20 -0700 (PDT)
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
Subject: [PATCH 0/2] Add RISC-V ISA extensions based on Linux-6.10
Date: Mon, 22 Jul 2024 17:37:08 +0530
Message-Id: <20240722120710.417705-1-apatel@ventanamicro.com>
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

These patches can also be found in the riscv_more_exts_round3_v1 branch
at: https://github.com/avpatel/kvmtool.git

Anup Patel (1):
  Sync-up headers with Linux-6.10 kernel

Atish Patra (1):
  riscv: Add Sscofpmf extensiona support

 include/linux/kvm.h                 |   4 +-
 include/linux/virtio_net.h          | 143 ++++++++++++++++++++++++++++
 riscv/fdt.c                         |   1 +
 riscv/include/asm/kvm.h             |   1 +
 riscv/include/kvm/kvm-config-arch.h |   3 +
 x86/include/asm/kvm.h               |  22 ++++-
 6 files changed, 170 insertions(+), 4 deletions(-)

-- 
2.34.1


