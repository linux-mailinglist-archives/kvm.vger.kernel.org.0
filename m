Return-Path: <kvm+bounces-40800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF38AA5D02F
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 20:59:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F33B816A31D
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 19:59:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99B35264FAC;
	Tue, 11 Mar 2025 19:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UkZk+kLe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDF7264FB3
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 19:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741723107; cv=none; b=qVHmlf6ZXmHTiaUt8JOHNb5VQANSzMtWIW2CC0DCOUER9YrjD2d7tgdQ+sKXuBXtrd5D49i8tosF9Ad5gg7srYIq/WWh9Y+yFZ6UIwpO18hGkrDOhwsad8n0JH0GqEoAZ+9pIjhU+j1vIEDq1h6MGe0HN1ASjzQKpQs/L/Ak0EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741723107; c=relaxed/simple;
	bh=CPSslnXnrG3PuOzhFaRqUdFyOZWqbvTYRwMrQTpy6Y8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BK7cGDM593IyNdvlBhcUdVmmz+vP37yjFATk2ZJGN1msECOL9iOs85ZxP8aBt1J5rcBnuR6x+cw3FJsHvLzGTuSkNmQeEP7mT5cRE4YqvHx+pzF4w2GILADzKX4PYm9k7nIOrsF412nlKUNYlvyWSrCPA5/oZsdwML1RHbRl8r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UkZk+kLe; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2240b4de12bso19846695ad.2
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 12:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741723106; x=1742327906; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q89mBu4b5JYOE58WB93/V2zR/jXmfpOvKMtRO3aXK0o=;
        b=UkZk+kLePq9NOErPoKpQtIlZqMxBv8JKhPnUOXM6Pm6+As81kU88yu4QxrNC8lFuir
         PWrGHGII8Cze+olPithsLSUSV9Vbe9JxdTqE9+E4gTHtpx2P2LX6U3nhW7+Q4DzZ7iRf
         hTLZoM/knfmoOK2VP35UAiBmcg4jz1UhSLNaIDMH6ViO4lZ6auDzrUgn2j5sEsNumImG
         eTgBrpG6glC3hnR2PTxY84CFV0Ut+2ZO5UnuKFxgX7ygSUXb/xzzrFQyfKkC2yEF1Qf9
         KlFynwR5EoYsPII3tU8tBdUu1fTp+SlSpeuWowbf1iDfVLNpzbgemRlZopSR4xwAGm85
         ayRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741723106; x=1742327906;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q89mBu4b5JYOE58WB93/V2zR/jXmfpOvKMtRO3aXK0o=;
        b=u5M0t536UBldTtE6RmiNSZUUBpF+w566Xhct7O+++VGZn/W+BJP3vw8cmOAZhkQWHZ
         LQWYEHzNmgTz4Ny92ZcTET72ZWjAz9JKUsFrt7jiwDOSon491yZXxLamplRwmCHfSlfz
         EqSVfoPD3uESBDkt/+foPNEZFlo2YTG1q5Xq4pyTFn4GMxZB2JvxgYnIeWxzsZ2U0MB9
         Fg5IGo1lL24yH0uvw5aCPNKMNwuXXVMTk8z7eR3HV4+BGxkHmgCL3KOiCkXAvTsG4c1O
         efJgPboxLbl5l3sxURMAsoDS6oEBr32BlmkE4aZaOOtaemkiJpoCwwl8FXXf1Q9OFg70
         IUIA==
X-Forwarded-Encrypted: i=1; AJvYcCVXVzEm+aSzUX9maHz7YgAYBg/vGzX9iC2PgpMxIS8WuNwzqPOImw2fNtIW1eh61Unr0jw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8cJ8Y2IYCAU/IwDNn1f2ZcNraJ0vb+ya4I1patzHt1wB8LrmS
	q00FQEdMwd+3gWXvDxegp4V5B7bMe3V4pTP4M0Co+l0s/JmIicKzumYwYmFGEao=
X-Gm-Gg: ASbGncvrurDh6IeBs2Ughb+WxlsrJnMJzQ1dujdPYJSLzZcL9SL853rQm1SU9MTOYc5
	83By/UJ2tu1OCfo+vcTQn6sJtHtKjJbveH33b3/AkEjD4ulSzotLqPoe1eY/LDD82NZ9rjat9MV
	5Q7W6hOlVtKcQSPSy/wSsgGD4oUQrBCWMYJkh7m3Ijeyh1Svc9V6oP6znu/0wgrOWyM/JXFvPbg
	SFHFQmmM0t+gptc6Iiqar6kXfOCqlTkHuNc6P+SPr685JS/q2CgbiY/yesKmXniqpxpnCvh0OlW
	03/rhutzUeQRU5tDZaWt5+8YZto4dosXYTsanvQKL35G
X-Google-Smtp-Source: AGHT+IGPxcxao/HSElseyaTLTAghrvJ2csxsBfbQ4Udwa0eEZtZIt5xFFqgWZBrC6WgJmJp7FceqHA==
X-Received: by 2002:a05:6a00:4b4a:b0:736:5c8e:baaa with SMTP id d2e1a72fcca58-736aa9bc0e9mr26082176b3a.2.1741723105679;
        Tue, 11 Mar 2025 12:58:25 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736a6e5c13asm9646981b3a.157.2025.03.11.12.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 12:58:25 -0700 (PDT)
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
Subject: [PATCH v3 13/17] system/physmem: compilation unit is now common to all targets
Date: Tue, 11 Mar 2025 12:57:59 -0700
Message-Id: <20250311195803.4115788-14-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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


