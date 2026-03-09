Return-Path: <kvm+bounces-73342-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UPaZLk4Jr2lzMQIAu9opvQ
	(envelope-from <kvm+bounces-73342-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 18:54:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E94A23E00E
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 18:54:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5F69F30C3980
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 17:50:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 792372E0412;
	Mon,  9 Mar 2026 17:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="l6PNfcjL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1812DBF5E
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 17:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773078603; cv=none; b=URc7Zr2MWznEM4xgG+J/i+IYeWX4g+y8bVlHfJEIUNWItiXBUL/xTmudUkzA2yBjs+gpxfDi6FQoiEpu2yCyLSxIJ9+9Orphltqd3Ku61FfiUyogZaEA3mu/v6C2wqh74p7fjrKqbGUnRAZiIPc52Q9jNSWPFqOzVjzYMeUayig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773078603; c=relaxed/simple;
	bh=KqjERR5wIee502vzCRthd5KWLQbt9lZUmHUjzUY22So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A4cMIdxpKhi1jjccU3q58C/XcpPNCH/P9FyisVb4fRTxRqAbHaBKUhY51gYa0MKXuHu3voW1PM9d0GsM8UKkURzPkH5cpTqUEzwrvzfLJb2lyCH1rK1DywZltWBk4vqHfkOfDCQThxj0DWyq3eRTOJggIPmCeE9XaN/jjjdgvOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=l6PNfcjL; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4852e09e23dso20368155e9.0
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 10:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1773078599; x=1773683399; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EEfzPl78wZZuVCLa3XMkoO1IguwbQ5TCjrRQOGRXJK0=;
        b=l6PNfcjLBTpKgh3zT6xb2h0Km+fdHIPzsV0rsckiApqeS06tY4ZfDM4NS1fVtq8FDL
         AiKr/JOOh3XwolSYQbuG9gKJup/cUrmu3MTNen9d2WDLh8rLRKtCtitYmFb+epjo0xuZ
         QQwluFZ7AbGZrCF43+p3o4U/BtT+ejCMqFEjGZLCj4vNoveanhixwzlkbrMbX0coxzQa
         LLGTDat1yN+XyLFDV3FsFA86TL3ugNL0Go/gRV8d4Eki1HH0Zkbnzegw+FztE4BmkTdc
         OYCajzY1LYU3HuGu20S16UAnexe3uSGoHypNAE8UFcK0z2lHshz6M5Bt9O9Weiu/7ijI
         L07A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773078599; x=1773683399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EEfzPl78wZZuVCLa3XMkoO1IguwbQ5TCjrRQOGRXJK0=;
        b=F+bQY5e4aOylJeH0L6xkYJuOwlSvkyKqsxNTqY4qPKw21hwVmDEV9UFPLGdcgZ9jlb
         MxhZd3LtjsCpatJ47VMG7l49FjiwUkEFckIbmahEts9oZsEMmUXarhp8On4o8B4fprZE
         3VegJT6C8Jn9eOFnVtKd3DbznShpLMpul+BicVfzC/VGWIQJLKV4A/JOKORKHrHxXmY+
         IlZ8YFa9Xa1ka/bSeq+Zujzsx5KezjKxOZAlzXYJwx5VXwXdsuGIi8Cj+1mjLPSnQQ79
         Rw4PABuwVRt0NpuPyiZYZpWYmUxr8Rp8W7ZyNgaEDgPiiO17rKRJT557G3BJafXfukv4
         oCOA==
X-Forwarded-Encrypted: i=1; AJvYcCULihBmPrxZ2oAZU+sEYXnTvLAMnl/YJRAoIlPw+XHZVFLUM7AKuyzOKBagdaEkiTIjY4A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoJ0stWOdDydST2IvwEdkxgEROne0OJM9pbYB1DwXpafsLgghJ
	JN0r8y3NugCEwJqM5MmKNQU7lU7rli+vmxlyaHLxbDdy27KqYABASOUtP/XSPaoM63ORuqcuzB3
	UX76JxH4=
X-Gm-Gg: ATEYQzz3yUUHw4mFX+7/FyBXVLTUzfuRZYZVRKIe5y++qxTQQ928tkvePdtSHaJrrnt
	gFaKHD4Gy2SjnTvjFnfemVFF69eMKpXq3noE2dX4L3y5DD+ooLSrWSqA3CiQouEd6ccrIHCgDqO
	sgQ13S8g3yxawY5QfA0ksFtlWSTzXnxYvSjzsmIHfcAajopAanxT2aFzobibnUwx3KLmFMm0kNB
	UAhMyPV2NVgmkMI1h070LoBGSmmF2pCoIqiYblQp39hszet5e245jFJ6ep1UEZGbESvIABsPKCO
	1FIt6R+ytUDQxT81/+yliT2fum2EXIufT0zMLAyGOYTkg4GOK75n/D0zDED5xpKQ2IZJd8tUnMh
	DR1qrnM3ra5TJ7tk5WJAM/aFjGfverDnv8o/Fm39/1msONmWOGBKvszn3w49SI+fJmuzIUji7Aa
	thKjqUnON+Fl5/I+14Z/VuwYwDCBk74Hsbu35829ysi9CMmchNGU9BZ9/Khtxkw9OztZrXOXak
X-Received: by 2002:a05:600c:4591:b0:47e:e78a:c834 with SMTP id 5b1f17b1804b1-48526978664mr196326655e9.34.1773078599343;
        Mon, 09 Mar 2026 10:49:59 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48541a9e549sm6747245e9.12.2026.03.09.10.49.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Mar 2026 10:49:58 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 2/2] accel: Build stubs once
Date: Mon,  9 Mar 2026 18:49:41 +0100
Message-ID: <20260309174941.67624-3-philmd@linaro.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260309174941.67624-1-philmd@linaro.org>
References: <20260309174941.67624-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3E94A23E00E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73342-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[philmd@linaro.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,linaro.org:dkim,linaro.org:email,linaro.org:mid]
X-Rspamd-Action: no action

Move stubs to the global stub_ss[] source set. These files
are now built once for all binaries, instead of one time
per system binary.

Inspired-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/stubs/meson.build | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/accel/stubs/meson.build b/accel/stubs/meson.build
index 5de4a279ff9..ccad583e647 100644
--- a/accel/stubs/meson.build
+++ b/accel/stubs/meson.build
@@ -1,11 +1,10 @@
-system_stubs_ss = ss.source_set()
-system_stubs_ss.add(when: 'CONFIG_XEN', if_false: files('xen-stub.c'))
-system_stubs_ss.add(when: 'CONFIG_KVM', if_false: files('kvm-stub.c'))
-system_stubs_ss.add(when: 'CONFIG_TCG', if_false: files('tcg-stub.c'))
-system_stubs_ss.add(when: 'CONFIG_HVF', if_false: files('hvf-stub.c'))
-system_stubs_ss.add(when: 'CONFIG_NITRO', if_false: files('nitro-stub.c'))
-system_stubs_ss.add(when: 'CONFIG_NVMM', if_false: files('nvmm-stub.c'))
-system_stubs_ss.add(when: 'CONFIG_WHPX', if_false: files('whpx-stub.c'))
-system_stubs_ss.add(when: 'CONFIG_MSHV', if_false: files('mshv-stub.c'))
-
-specific_ss.add_all(when: ['CONFIG_SYSTEM_ONLY'], if_true: system_stubs_ss)
+stub_ss.add(files(
+  'hvf-stub.c',
+  'kvm-stub.c',
+  'nitro-stub.c',
+  'mshv-stub.c',
+  'nvmm-stub.c',
+  'tcg-stub.c',
+  'whpx-stub.c',
+  'xen-stub.c',
+))
-- 
2.53.0


