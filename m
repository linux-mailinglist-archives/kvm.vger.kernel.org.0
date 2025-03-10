Return-Path: <kvm+bounces-40555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A9C68A58B5B
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 05:59:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5424B188BC38
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 05:00:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B9161D5150;
	Mon, 10 Mar 2025 04:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qUq3XVEe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661EA1CD1FD
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 04:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741582742; cv=none; b=L766WDBVZTJoa6eqq99Y2D4wYTOkX0+xXgK1Z/Gw22C1PMzue1rDTJwallNGfuWPH7nhgp9qN9cjwGuq7zspd+5LVbW2p/oiHcfF1XKJE06Q+JINikDtF4oqzeWQrmw1nCukuK2rCk5dC/EnQUsedFpXlC9i/y9WLGqPQ4E57kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741582742; c=relaxed/simple;
	bh=IznGBUwVS5HxvRJlmh2ZSMDATYkDh51AdD480vemYnY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RnliHgIiUxyvuWMH9P/KxsszjcRcf1cVwiv/9tHOV2oPUrcyjA8q5dr4WoB2AUHSVp9elhgfpicen8iIxcWg6GJTQ0gYnOvprrAdTyBCW2mU1EjpAF+IdC3d8pFqGBFWLdwZJVyvD46WXYIlPegSuuT0mbkGNJ3wPSvoP67Hrx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qUq3XVEe; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-22548a28d0cso35993185ad.3
        for <kvm@vger.kernel.org>; Sun, 09 Mar 2025 21:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741582741; x=1742187541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IPEDYJNluDpPES/gm3SGsU7HvgYj8dBtSrlHoVBQ0cc=;
        b=qUq3XVEeo37EIPqBcuGyKuN4jAeFcFKiSFhV4THmrvNLeSmu6vLs7w2j3p46rq9qvo
         tulufJVeGoxGXi5NiDzhi2mqfLW+CrqTQkKqMN4Faad3UmbVmMWE5Zl9owwzaWKdx4rs
         vQ4R9b50FEq0w+gyGtISvRl8UqFSJN76qws2C9fFZ4qn7EA9FcDtD+j7pfro1tz+9Wk/
         V+PhjFADd+z3DMWWfW/diQ2TuTSk2MD/ZwTZeYPrOCFoZa37wgBPNaoi9bzSu4/ID+rS
         rEGdUxBfduHDhn4nlYiRQAx4qwSkP82vh3Ve650lS8wzsz+XhiFcohV5qTU+6dMvgbfZ
         QIKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741582741; x=1742187541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IPEDYJNluDpPES/gm3SGsU7HvgYj8dBtSrlHoVBQ0cc=;
        b=uIELd+PpbUc3EDgRGsCihRCdIgqg5aS2r1yn0wevBS1qKkYpHVirkSjv27ipibhjDc
         5BymcE+2WuJUTt4umpv3ggopLyVe0JB6x2PnSp7HYG3iKzNxA/ymhbQJ6XrS3Re2796K
         FKSTsp4dB+pN3A3HR8lksdVPLaz2rst+LpRsJy8+KOOV7hUBAykV7R4usr0Sydz6VGdF
         KJGWrJLqg0LXerc4oII4dkSJ7Xf53wlk39of09sBCs+2WWE9BFJaJFinsr13e8FERc8I
         6op/2rHQccLda2n9A9A1tZoo0nNSzp6Sy89JIOvpgw/YRcAr39Xa5zeCanvgoBh81YzW
         kSsg==
X-Forwarded-Encrypted: i=1; AJvYcCVPzZTx34tSCyuRfmctAV+vKc9Bo6qZHx9mW0YDBzOLWl6dGLPBYvC4RuuqUP8IqtoG5ko=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUQbhdSJOlBGeyaPuq0GQ5wVEgTpinUKNLWKrJ4nRBURnsIh2d
	oxX0yyl4hEuFARPka7WtlkecQqWDx59MuLh0ofyjFRMjDIfjI+jWT+zO6scVJ4Q=
X-Gm-Gg: ASbGncuWnidABhWci4v+2XXPsiguQdR19Ys+VFzXBbAIRtNBqRJMfvG1ttdLMgoT2dt
	xDfVE5MLD7ReSJUfb7TJSHUjct8M4Rh5fVLDz/NedFpVfF4TZnLXU54SonCS7VF/Z8Y7GGqUxsY
	z6Eg+pSgL4PRnp7Kk7KDz4gUCJzE8QwxfqtLj9rYtGYVfHhF7xuXcwTzAv6oYLb6dbNyWeP1Zbk
	YpK97jMFEnU8bz9vuN+AgQbip6JEJHGokTc+llwug3DgpLdpaPqLRT2Xwv4sKiigfSuFcbOJBWW
	kAwv6yjUgnQKIQHwNsO2HNk2jL52QHQSZzsyiuedD/um
X-Google-Smtp-Source: AGHT+IGnRL2uatBuqKhV40BV7IK05QSeZki08kFFlneJ+DA+/in0OuYiAmS5NbuJabl8/7CaVrRM1Q==
X-Received: by 2002:a05:6a00:cc2:b0:736:4704:d5da with SMTP id d2e1a72fcca58-736aab14d5amr19552625b3a.22.1741582740826;
        Sun, 09 Mar 2025 21:59:00 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736d2ae318csm1708308b3a.53.2025.03.09.21.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Mar 2025 21:59:00 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	kvm@vger.kernel.org,
	Peter Xu <peterx@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	manos.pitsidianakis@linaro.org,
	qemu-riscv@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	xen-devel@lists.xenproject.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 09/16] exec/memory-internal: remove dependency on cpu.h
Date: Sun,  9 Mar 2025 21:58:35 -0700
Message-Id: <20250310045842.2650784-10-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
References: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/memory-internal.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/exec/memory-internal.h b/include/exec/memory-internal.h
index 100c1237ac2..b729f3b25ad 100644
--- a/include/exec/memory-internal.h
+++ b/include/exec/memory-internal.h
@@ -20,8 +20,6 @@
 #ifndef MEMORY_INTERNAL_H
 #define MEMORY_INTERNAL_H
 
-#include "cpu.h"
-
 #ifndef CONFIG_USER_ONLY
 static inline AddressSpaceDispatch *flatview_to_dispatch(FlatView *fv)
 {
-- 
2.39.5


