Return-Path: <kvm+bounces-26272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC896973B03
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 17:09:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A83E1C24517
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 15:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69AE1199920;
	Tue, 10 Sep 2024 15:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DRi9Aai4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6CF143C4C
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725980938; cv=none; b=X6fW162VIAXLSIwDvKvcqMc5+I6uzmDf0LOuDldRuWxB85KtfBBYJ3bTdaRDwTyG5Te14KHFfsVYVn6xTqUVtfWIRHqiml6seQn62lYcdnww526jX3cIXLOdem30ECH+4RmVDYWlcQttHVfbg5erMYyrZczjOe8cka7W2arA26E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725980938; c=relaxed/simple;
	bh=GP7YBizU25UjnjcLuyjK7CcQeDNRydnkOONMejo61nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qd3tccAsdLRctX/vBAGiIq23pp8zpqUk/pV4n1nim9CVyjLmxn5F+XhCaFH5eF4EbvIGYqXwAp6DxcavHsN6EIbDyC85awKim+vJyw+HoAPWocs/Kk+Vv7C6P75UIQHPot/AfLKh3+EAVvO0ztorHdckYLZr9xvMmibw21H1maY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DRi9Aai4; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-7d4f8a1626cso4469155a12.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 08:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725980936; x=1726585736; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dKkukmFzFJFkn3rVsStvRJ2uYdXcPgH+kgvBIoj+O80=;
        b=DRi9Aai4s1ac05B0bI81v0+WxnMbvpFt5Xa3mGaRs2jc7BQqnmM2JABf3zTgFCZb9u
         DQW2yMXsdSX3oHG711aCgDybsu7hrmPYttTb70x/bvIpgNwTl/zro6llKkfpSZrFWCI1
         H7d+RMLDmIHLg4ZbdIAc53xgGJfhhoi8zWj+vr7qCwvHN8QBBZ1iZJ32QcGFDABsr9QY
         3dJiRI38JCUq1VP8CygnISOWzV2tsZg3z2B5bzPvR4KsMUHIj7Wdn072DLBckxIvVOmR
         mMo8GQFSuNj2Plj3ACdpLdKnB4XxYty5+kEmksTUTJG3yZhjrY4UxSbRZ31+L67g3uNI
         LxKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725980936; x=1726585736;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dKkukmFzFJFkn3rVsStvRJ2uYdXcPgH+kgvBIoj+O80=;
        b=PWUI2iMAogUlM+XEpyNOdYWlSI9wK2mYdhtrgME0lBdC5crq5xmICcD8tirjl1LWKz
         jYpo8eoQ5uGUI7oWGodxZItJcvVpSJA1BvKBtTuBLlBHg4QpDSaXURb0Xs+CMeuZ+dG/
         jNI8PHSRaeFGk8oraNc8hRRMYH8KXFB82l6XG0sfoxqP30fgxoEtU6ZyOFwuAbHcGGd4
         p4tnZZcgVAO6wK4k1YBxWJUUV8EYUq+ifZotY1wZ9Rbv4QuRGSDALYBaUVW3YXGPzywp
         BTkZY3D00K6BH5JpMJW0MGjZBU4BJxpDndthaWJlAMrlpeVjli6VEX6I/ihfjsG94luC
         S6BA==
X-Gm-Message-State: AOJu0YxrkWqf5HK6jZ8pzKGjL9VPZMui3vshOo8lctz0RYw8UTlxDzjn
	kUn+DdAi3FFjKy/gh4npwmtdSJGxisoxdbrmY30BEBIMnLpNNAfS+wCuvyhT
X-Google-Smtp-Source: AGHT+IEGZcXTcz2h4CbaEl/cleH4vN1BKO6qlw1FxnHuERF2zHUnX9hQ464X7raS4vTAERDNjZDpkQ==
X-Received: by 2002:a17:90b:1084:b0:2cf:cc0d:96cc with SMTP id 98e67ed59e1d1-2dad4ef0be1mr15259932a91.9.1725980935761;
        Tue, 10 Sep 2024 08:08:55 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2db041a02c7sm6615120a91.19.2024.09.10.08.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 08:08:55 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH 0/2] riscv: sbi: Clean up multiple report prefix popping
Date: Tue, 10 Sep 2024 23:08:40 +0800
Message-ID: <20240910150842.156949-1-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The first patch of this series adds a helper method to clear multiple
prefixes at once. The second patch then uses this new helper method to
tidy up the report prefix pops in the RISC-V SBI tests.

James Raphael Tiovalen (2):
  lib/report: Add helper method to clear multiple prefixes
  riscv: sbi: Tidy up report prefix pops

 lib/libcflat.h |  1 +
 lib/report.c   | 21 +++++++++++++++------
 riscv/sbi.c    | 17 +++++------------
 3 files changed, 21 insertions(+), 18 deletions(-)

--
2.43.0


