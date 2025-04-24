Return-Path: <kvm+bounces-44235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAADAA9BB3F
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 01:29:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76F5D9268F4
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 23:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EC542918E2;
	Thu, 24 Apr 2025 23:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A9qw4K7X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5765E290BAB
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 23:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745537325; cv=none; b=E9eg7pclcF3XO04Nv7fSsntEWNMfxE64l36uyN4WACMHTuxV41R2/pwIixwPbu/SxJV+ANt13GaHt0v0D6S2DnZ4r0XBEv7dXPrB1zho4X/WsWXqwKNx6SBeRa4BUZ0OdZN+/yte8k96bB0x1V0Q9Rxswj61rS91C2PH+ywkewA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745537325; c=relaxed/simple;
	bh=yY9+XTJM0pOnsUYB702ihOubwlN9+6GRoxh8d7LHLcw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XKAU4ozEQpBzJZQC5LeV/+WbwANpPUw+tXkZPlYuTCgJebTvwsOA1ckkZgRHRIALbI8SDzd+5YJ36t/ZOvYXVXHOOQNenSfALxQsr154/VwDbic4J1Spu2O18jOdBGzV2V7IkCxZpDcovdNgUvfFlh4NpXKk89lRo0us2jQzrxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=A9qw4K7X; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7376dd56f60so1198266b3a.3
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 16:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745537323; x=1746142123; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9F27FfUGwswIcGWG8chjG9ToIwjCIEVz8dw0HLVPgHE=;
        b=A9qw4K7XShm0bBULBYdAT7WcQAOldj57y5Sgw3cG771p0oaw8RvHKgT5UU1vBtPuHD
         H6ZujFqKdY0bN/heT+NEB2czQL5FAIH3eCNMBM8vmsLx7KkpxlzWecZP5ZpDztqahgd1
         DuQyL9Ex0f5/JayRz5TNZWFS2i1eRDVl99+q9jT+MG7pfP36SSBpcsdsWlXu0mWaKVLs
         y1v/h7j9MDUkc5nIKBKH3DT33kH2OHGgRovypF78o9k8D070kDofsCJAVqS8BgSxENbg
         cU3i1n46TRafFwmOee9yM6oddmtKrqBUwp0hEJRSsQB0HjvGlTFa/WpSGJUZArjMh8va
         syog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745537323; x=1746142123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9F27FfUGwswIcGWG8chjG9ToIwjCIEVz8dw0HLVPgHE=;
        b=R/UUUmDSrQKwfBA7ZIfF160bAtAFxh2zUpFDfvACuB4RCY2IMSJuJAA8+JSwv2cATb
         6UCeSvEVWIsPa7acK5nzzcpV0lbCCVC/CeddxjL1wI5XgxDB7+VaeeRuQyiJz1Wp22Dq
         j9dd79kQrXL/DzeeyLF/NjooXWd8gbcYa4U29kVgH1D1xG2pIMMNkDQHJ1KY41YGGYkr
         HaJgApif7ol5wcxGlQMMfLYw14gnxarpZ6VjtJ9tTR7Kw9vdRiVH3XynNqI5mCKzMW08
         gIGoWOzA3Y7zU4H5KE2ViPINhhdE5pQiqldJr20hxNa3CKTZftFkEuPUyPRkkLRcDWkL
         RuLw==
X-Forwarded-Encrypted: i=1; AJvYcCXt3DHeHo7ESwP+zRP0CKyzMuUC/aNry5R89D4ylPrpiO9ZsBb8dLKkf/kh/EkEzeqPxmY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJbB6cfOxH7L89NO3y4dSsEmMGr5PcqrnPl5Ms66/fyQZwBAw9
	sW7emQ7fvRFB+yRPk+/fS16IwmLOThsKE6b3QWZQlCvh6zkjV38Xxb5ZAm5Eq+M=
X-Gm-Gg: ASbGncuOnZ9m1JJCeqkT/jX8cGIYM3/jKtBU1QF55+t0ezmaFuI2NbURByqrNz5/LfM
	LxT4f+IxE9yi+3dSi1jkoaxzJWY5EhYYfMMSGXwyX7zS9FwB5ekiOSL/vT0n/oIam2XPvHUHd4f
	rUuP9fMJYHiA6BFYbXrqRqjyIxXsoAb0pUSM5q39gik/mf+ywPBvm4PLKce2jczFKhAYf4nVuuQ
	LEXL3+oLjRuC5uKPkFyqzWPF11uvmEwrziSeVFOGLPo6+Ly/y4VjiszWY+1zBQskTg777WIhQLM
	tZDJcv7zNeNxFudFf/SWPRrioOM5TlDLgGmzFu8D
X-Google-Smtp-Source: AGHT+IGTEY7MSJpredylN4itwF9/84/LanVtitV9Z2CqdqmWmpF6ViT61vcHfc8hWB/Eeei44AL6kg==
X-Received: by 2002:a05:6a00:cce:b0:739:4723:c4d7 with SMTP id d2e1a72fcca58-73fd8e53d55mr114431b3a.22.1745537323708;
        Thu, 24 Apr 2025 16:28:43 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73e25accfbesm2044318b3a.177.2025.04.24.16.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 16:28:43 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	philmd@linaro.org,
	manos.pitsidianakis@linaro.org,
	pierrick.bouvier@linaro.org,
	richard.henderson@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: [PATCH v5 6/8] hw/hyperv/hyperv_testdev: common compilation unit
Date: Thu, 24 Apr 2025 16:28:27 -0700
Message-Id: <20250424232829.141163-7-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424232829.141163-1-pierrick.bouvier@linaro.org>
References: <20250424232829.141163-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/hyperv/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/hyperv/meson.build b/hw/hyperv/meson.build
index 5acd709bdd5..ef5a596c8ab 100644
--- a/hw/hyperv/meson.build
+++ b/hw/hyperv/meson.build
@@ -1,5 +1,5 @@
 specific_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'))
-specific_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
+system_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
 system_ss.add(when: 'CONFIG_VMBUS', if_true: files('vmbus.c'))
 system_ss.add(when: 'CONFIG_SYNDBG', if_true: files('syndbg.c'))
 system_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'))
-- 
2.39.5


