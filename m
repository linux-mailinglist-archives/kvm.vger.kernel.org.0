Return-Path: <kvm+bounces-40459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 29421A57435
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:57:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DAA16189A272
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43798258CEB;
	Fri,  7 Mar 2025 21:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Jdk28EUQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFC22586CA
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 21:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741384602; cv=none; b=f9yOvatWUKUY+97pdpzSLA0MGnRXnY/wVK1YkwKSXmORKWKs/n58z/sMac8rWr27ysDdi64+GVi380VCR5/golzN22Z15giWhbOXvVkEvw6q5cxWnLsY6phA86csPD3Yq5fddSCr/8KoPOn4U8OCfMfe3FPcwnTJBYK8mKRvoIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741384602; c=relaxed/simple;
	bh=yY9+XTJM0pOnsUYB702ihOubwlN9+6GRoxh8d7LHLcw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P/2t1Z3x0oTiu4W/39Gmmo8zSDWpv2H5gOtuAbS1eKmdjUgFyUDjyEcHr8J8Nvv+m4tKj5UmLnIRja+uQYFQi8Mfe9DtDyR/fpsCuId7LXTSA9UkxTEdNggsJaFAFqlZba2tykELMM/eACyYtNtY8BskwaJ1L3TLGZsqe8164Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Jdk28EUQ; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22398e09e39so44399755ad.3
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 13:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741384600; x=1741989400; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9F27FfUGwswIcGWG8chjG9ToIwjCIEVz8dw0HLVPgHE=;
        b=Jdk28EUQR4j2Hgl6i0Rngj05z7SJVr9+diBJ7bfe/F5fy/5KQlh/XwvDEuRMZO/mhE
         6FDweP96u9WXheyr2sunurCZh4xrECg3pFQJg5gm7Gb9Wn7wTmQqSe7lUxg6pRJA93RC
         AEOx0CdZdaXv0nlJKNM9mnPGwbPZLZ5E5DcTjxcDPHGBLtYd7b14KmhD9Kmtya+CqO0M
         ILy0d0t9/QEiqW1PXr5ejPSOEm8jA8hjMC1za4MIDMIQF9KCRsSePoz0GF9QGpL8BUh5
         spaRvh7BXKKHpsRufJM9czyYIKGvgwD0jnt+SdjYQOYUH5mFUxW/60LxDNLwVUW8wEGW
         rDDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741384600; x=1741989400;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9F27FfUGwswIcGWG8chjG9ToIwjCIEVz8dw0HLVPgHE=;
        b=GoE6cithDu2HysRx1o+NzBOLDmSKqu2dzhCqTRPtjaaStNhHlZfoSnHMmjAuwtqUPD
         LSiMjyuOqnpsZm9+BbdSqSyGd/HiS5oOm51y7idGgXdmMkognfEfqHmlY1Wu1U2ss5DW
         MTi54eIgphFlKAi65h6gw5LiDqmR5iKYUa8YqkhIe+GXM3EM8W0hLtZDuPeQ1aJirbWC
         XC4CdbOV27Fy5tVGbA0A83F8Ga8rwO8HwqE67ommYZ2j5QBkuA6N9vmKds+ga+xzc4Qw
         uSocnEIPn95EnNrLb+51yyb4Uj0AKXoI0cws7bEuaz5ztQKyKWaRVBoO1PK4bUK+fzSz
         iRLA==
X-Forwarded-Encrypted: i=1; AJvYcCV2tLmmqVk4zns60O+xMRe8oXQ5boGco1suIo4yermlIho+PkFPBlZ6zyKJ7AZi+eIh+4I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6wif8QU/Hql5SyJioTlzfBe1KrjT3p6kSiV6G765Xji7/Ar7H
	KPEACLAgcZaiHKjsCaDkmq16sh35SbLKgF6/Qnqg2/5W7dLST5UH1F6VX2G7IjA=
X-Gm-Gg: ASbGnctxFUDL3OqrfAle8LVUrwMWW+Hxqv69kGALuDHxzZdHQqNwPUmMCM6711JGP/0
	gn1rEhnnLtCmKqn+u8ojHztY1XqaRkC5HL3luSSZN38sYhIR5axsZcrZQkXKjqA4ShwYLzRbm2J
	hi6LDsqctQAz8YupZcroj82MD2T0qA4P5OXMtxv1CeoKsm8/ZWhj3hF3FsBMFFKG9b8fGfYgEMf
	T45fU2ST/uOdHp5aQ3PeFZqLcOjUamWQHDa6cijusi5GtyuxH1PbA8ZP9Tv08M+P7BGL5nChGO6
	p756fBYI1b+XWsICEFmI68woJ/u2gWpo2dzwBGecv8ZL
X-Google-Smtp-Source: AGHT+IEpBLPbNDwbFWHbtDFWg/F3o2uXMTLWPQlQ0zMSbaU7eLTdBBkOHLlJs+mEDdjKeNRx4XKwJw==
X-Received: by 2002:a05:6a00:3a0d:b0:736:362a:6fc8 with SMTP id d2e1a72fcca58-736aaae41d7mr6920551b3a.15.1741384600200;
        Fri, 07 Mar 2025 13:56:40 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736ac9247dcsm2000927b3a.125.2025.03.07.13.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 13:56:39 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: philmd@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	pierrick.bouvier@linaro.org,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	richard.henderson@linaro.org,
	manos.pitsidianakis@linaro.org
Subject: [PATCH v4 7/7] hw/hyperv/hyperv_testdev: common compilation unit
Date: Fri,  7 Mar 2025 13:56:23 -0800
Message-Id: <20250307215623.524987-8-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
References: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
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


