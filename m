Return-Path: <kvm+bounces-40794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 155DFA5D02A
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 20:58:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 582D8171449
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 19:58:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB7AA263F48;
	Tue, 11 Mar 2025 19:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HxSloSRd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77385264A76
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 19:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741723100; cv=none; b=e7N9ss6IWPooNBZTEFo17N0DfO0mG3gUmFdAQYbvmF5pBrnrhL/b9mtpE/9VjGpfVl+CnsuB2kjO0dxPzfIteQUZ81fdwwRgOZMeDJgXDCAu8LsK3tSjmo28l7AReEC3wQebfIZmP9bRQgkD8RtLKaGPQmqSRDIVt2eeKd3Ktkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741723100; c=relaxed/simple;
	bh=aHcHDSCEQG/Lxg84jg/rjAhvQowTiiMszTRoQh+zwoY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mV57VUx7BDjs4BZ2wtG4KF1T0wT1tEiBPOylI6I965h+yBraoI81gzTUDO9FeEe4z0fv25vu7/Ausj9s1cbjrXYZbJrBcGqPLPdzAbWyfW9QCxOO+eXVc7Yr4VuMSWn9jDxH0L6EXzSTr0buubMRSYatwKUgsAjvEKPOmpC4CQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HxSloSRd; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22113560c57so111409165ad.2
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 12:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741723099; x=1742327899; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bYYGOsy+zcSjxVOnigwMonGaAhWbZB7W76ZyOX5Jlgc=;
        b=HxSloSRdQGXpmdOswZJXBI4nv40Zz/Iy/WrmIH0THSFa/DwS/y+w/SWizn3dUh0f3k
         xiHPOF+DxDbmcCkBtvxYum+BzWcO5sIaMxR5CaLrZemR42usY1YNDKyQLmlidpoPzSpM
         OKZ483qnGDkSMTuLw5duFzMSPA7jPX2dr9xl3sjKoGbH2ElFCjMtvcD67cpIrAlhamo0
         2qWFrf/HrF1UcmPUf4IA0/ounWdqfUdc4DUdlloKZOZoSrhAfd5l9YHpQfbOx+1X9Xv6
         ro9+2QdT2SfIZeTOQMyvcO4A9FwMAuVkP5pqBCyno0rF48f9O1lPG3elL46+Hsjg3BUs
         GT+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741723099; x=1742327899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bYYGOsy+zcSjxVOnigwMonGaAhWbZB7W76ZyOX5Jlgc=;
        b=UnoHaHaqHvfdevs6pS+qfZmuttlL9NLduYeXC+CjnXe8BsHAwe4+ksm01s6AHmqAkt
         d8Att4s4OYa0fGnlX9FWn1U30DguFLJ+vux3+ktczPozpT/qphNw8N3LSTGjRCFj+Ie/
         oCG7za43e83ZFXwC2GZdMThGt69E7iY3EUVjHievBrT8Qtj6uzqdMTt5LB10mLAv6WSw
         c5KDBef/GPHruRl+lSJ3To6IeVNKiJkzK3C2V/b9EXsK1lREXBo0jsLV33LaU5B+pOyK
         K+aBfmXChzj9Lb37PycNMyJnzPme1keXFDTI2/m2vHcmpZcWQTeAwSmZASEIcaHGAhrE
         I1aw==
X-Forwarded-Encrypted: i=1; AJvYcCWv6fDKyvbyLAGf/R1MbHHCJX3OYF/M+kpREhdwUPeeWKbuSqhAE1/9/jGu5Ju6FCa9zhQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZvJmoeiajoY+HDh6nr/HoAGB1xascxxTxuk4kbDB4Dtqw0e/X
	hDgjf2UuSCaTsgO7CqMRbO1QIu2h/ENVLw4ZZobj/cQY6OTwZlisZ/ofVrBc28s=
X-Gm-Gg: ASbGncsvu05aT8UUl4/Cfwbawd8B0cDVM7HVOaORrgbEKXDT8Qjv9x0omth0AXuLB1z
	iFCKJLp3XPPRP5JAJbtKLp0r8TiTk6+Kq2mKji6ZUzm1AZcZuLLzS8MOgSdERETaSc9yIR9AbpV
	DmO7xLyLaU9U+hVmI286nM3Lmd8Q8V+9NK3ytMN2NZ9ssODaS44zngoGx+BwGW7ixUS/WuBy6oX
	FmmJGUmBgNxnDR+50qtiR3s0ApUmFTUReo6OiHyBzz2iZ4JQ3fHHxRTS3yaxjBobfBsvU3UMWfc
	xu+2p6zcuX9PAIDSSQ1WBIP0LY/wKM/gdZPAIBa8orV7pmkdy2KTtds=
X-Google-Smtp-Source: AGHT+IFbL/EikEqHmQH7/+hOB9jflYFjv2fXkewmYVpLTsSrUYTiBJ9zTgGhdqBywi26rV+yUM0nVQ==
X-Received: by 2002:a05:6a00:1708:b0:736:43d6:f008 with SMTP id d2e1a72fcca58-736aa9f0b0cmr27815913b3a.12.1741723098739;
        Tue, 11 Mar 2025 12:58:18 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736a6e5c13asm9646981b3a.157.2025.03.11.12.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 12:58:18 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Anthony PERARD <anthony@xenproject.org>,
	xen-devel@lists.xenproject.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	kvm@vger.kernel.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paul Durrant <paul@xen.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	manos.pitsidianakis@linaro.org,
	Peter Xu <peterx@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	alex.bennee@linaro.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 07/17] exec/exec-all: remove dependency on cpu.h
Date: Tue, 11 Mar 2025 12:57:53 -0700
Message-Id: <20250311195803.4115788-8-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250311195803.4115788-1-pierrick.bouvier@linaro.org>
References: <20250311195803.4115788-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previous commit changed files relying transitively on it.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/exec-all.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/exec/exec-all.h b/include/exec/exec-all.h
index dd5c40f2233..19b0eda44a7 100644
--- a/include/exec/exec-all.h
+++ b/include/exec/exec-all.h
@@ -20,7 +20,6 @@
 #ifndef EXEC_ALL_H
 #define EXEC_ALL_H
 
-#include "cpu.h"
 #if defined(CONFIG_USER_ONLY)
 #include "exec/cpu_ldst.h"
 #endif
-- 
2.39.5


