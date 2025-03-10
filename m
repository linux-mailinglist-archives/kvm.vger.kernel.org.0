Return-Path: <kvm+bounces-40560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E5C8AA58B66
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 06:00:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 89544188C015
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 05:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 884A51D6DA1;
	Mon, 10 Mar 2025 04:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qSoSJuxa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8781D5CF4
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 04:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741582748; cv=none; b=VlZQ+V8SWnoEqs9T4J/bHi9I0UgcRvZlN4cEi7au1L28bkQZmpkbbD+XfOYaj7pMxxqJoZKHs7l6RzYepIbalNwEgnQEFrvxOJ45LOyWpGumtFlV58tsccH4aAe7OWQ7a8gGygmoNbhxbdNtQ8pcYAewcXa0okBUCA9qukjbiYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741582748; c=relaxed/simple;
	bh=Pb63bG7wsSXbr9Dz4s9YlyOEu1r8ErrQY0nhgwBHCi0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VAcIa30B0UU/pcKavRaROVRdCzkJxuwCOwbcFDVjejbKxVO5CCAXkeeTgKKT6NjiRWSdDh9EV9cYcPCFjttQndaGCtT7pECgAgWLPJOcJITFtW0llfd7ygh0jlKr9NlF9fK9jMoWmbUxb+gLfwQdM8VkTfflGpSlTo67TfwQphc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qSoSJuxa; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22355618fd9so66594495ad.3
        for <kvm@vger.kernel.org>; Sun, 09 Mar 2025 21:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741582747; x=1742187547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GMZho2jTEznhsPIS6UESQksv+KrJv0rJOAa8ZMe9/mc=;
        b=qSoSJuxafaG0pnwCQlkqS/Oct8GHAvOMv+wIVAZTVBXjCGKNo3dI5B0PyscQzxXhEi
         sDV3Nx6M8kz3Rqu7tSecJPDKsn763chQ6l+Y6sx1fLQJ74JKqaMtz+vXph8zuAcwfaIv
         LhnGLSLA5gMetrvTETd8FmwCkNM9RIUE6FltuP5zSllSYskebotRzAUjlA1hnWH9w3iO
         1uo7eoJn6/WYYKbcxXGdcBFwsN8jcf4Ho2bBzjbbSb5eYZSwnHWTZX9nciSBVQU5j2v+
         DCWIPpBUlbdVZoE6FEc+0/ADprv5Vmt4nG6pRsudmtoEFdMAUP5uITrl+XRqYSORRUBM
         iCLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741582747; x=1742187547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GMZho2jTEznhsPIS6UESQksv+KrJv0rJOAa8ZMe9/mc=;
        b=EKJrrPwecWGswJwR/7abVTPdyYhS91hKBU6eKGOT10CLx9i/6jbvnFS6fpXk1Gs4x8
         9Qmf4L2YRSc12Iw2XMiIldFz/qptpex/m4eMFgZVvFNxOANzXph4TLXawel0iJfp7qmu
         hw6dYTFAbb7a1k0wMQNB9sBvPHD+FdWVqOXnI6v4q8Ci1UOJsSVGc3VecVBGowT13A21
         lqbOGnmWT4kHXh0G9eVnkb7XoqacNyfL/lauNG8r53aY8oo2U9e3NPh4taoUb1RXK62S
         UhuUByfItPv6jtt5PAr2xIWrCDHjS77zirp3D94OUZp8CoFxOAI9rJPnslBjVpTusVvs
         EeNQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/6FlWtOfwzJW2pFmZ2y1aq7O3Zac1I46lNUAiSAs1Dlnq4PA6JqoHNtzGcztLoe0rgYc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWtfXk8a7qANxYABfrFCb2OD4FXoX/zpWenZP1gAgW5CgXgUF/
	6v5bJ69JyoNem+fkRcY5fL/XZB9IvoiHoT//PiNPN87NhjAHGIcNhL4y1x3k33s=
X-Gm-Gg: ASbGnct6O5q/wxKU3/8FGT73ybZtdMmbnUAzKwHOwWWMX++XhuTVuCKdjqFvhacvSE5
	/6aHTjnbjU/EtIHkJtViSrTCqA2ygmPqXMiqsswrnzhsOmazRtC/0WCfVRR9knDprEjxOSUk6n+
	sN/PcJOSyma1O5IUf7jonxaozOs5vt5DbKBFf9R2OXFFK5NJPAkErsaQYnpGBEwgBvZ++p8eoSK
	Tc5cn/l7gAheMWpBP98UD6PeCrwdYsLmHZg6IqOG1QzhhA5iBSVfaaR4T7kCbhpHlxIq2hPkN24
	vsYoLMRjw+/ynjt2XdzFZINWSlvKWGMwzpYgBPIXQvq1
X-Google-Smtp-Source: AGHT+IHbQ1zJTyihYPTNnOdjfB7Sf4JwjgD8pBM833NXOATM0his3HUH4Ux5tSFbwWsuCfmQbH8fWg==
X-Received: by 2002:a17:902:d488:b0:215:4a4e:9262 with SMTP id d9443c01a7336-2242887fd5cmr174335945ad.8.1741582746784;
        Sun, 09 Mar 2025 21:59:06 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736d2ae318csm1708308b3a.53.2025.03.09.21.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Mar 2025 21:59:06 -0700 (PDT)
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
Subject: [PATCH 14/16] system/physmem: compilation unit is now common to all targets
Date: Sun,  9 Mar 2025 21:58:40 -0700
Message-Id: <20250310045842.2650784-15-pierrick.bouvier@linaro.org>
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
 system/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/system/meson.build b/system/meson.build
index c83d80fa248..9d0b0122e54 100644
--- a/system/meson.build
+++ b/system/meson.build
@@ -2,7 +2,6 @@ specific_ss.add(when: 'CONFIG_SYSTEM_ONLY', if_true: [files(
   'arch_init.c',
   'ioport.c',
   'memory.c',
-  'physmem.c',
 )])
 
 system_ss.add(files(
@@ -15,6 +14,7 @@ system_ss.add(files(
   'dma-helpers.c',
   'globals.c',
   'memory_mapping.c',
+  'physmem.c',
   'qdev-monitor.c',
   'qtest.c',
   'rtc.c',
-- 
2.39.5


