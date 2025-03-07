Return-Path: <kvm+bounces-40389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6303AA5711F
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:10:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D601E1894369
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A38624EF9D;
	Fri,  7 Mar 2025 19:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YdzqtwD1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2396C241698
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741374613; cv=none; b=SFpBkx0Ew76dJY3nzXqsVtozYLxacIaeViO8wgK9sSZRZRuQCZHkclPSnWS6oXOJVfnpqPBJeHBk4BAb0HK8HV1odf83JtQEnK0X2b/IZi8+zbTCF21og1cW5hJH5qtuVBgoeznfyzR+nrQ4SJnvfjjYfqjsRxDyTIQLjH4WjMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741374613; c=relaxed/simple;
	bh=bMUfjPvXfN/tKkBw/WVniDJmAgFeqLIxrtzwYnfSHg0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BmV5v8GG297QEsw5SXJNWldhqmIxHCHQxzhK4Gqg0D2TPxLC4F8js1ygcMtR38sJzXFUA4o0YXl7ZmS+UBkvrg0OU+/3xqHH8Qmo8vstnLCqxr6tB1ExyBhx+W/7eiVsNbGgyEai/1fvQa93KyElMtE/89TMtOj++qc9kODYoP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YdzqtwD1; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-223378e2b0dso34770855ad.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741374611; x=1741979411; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wT8pzATX7z0g510B/bcUtetzdKIxpUlAXqTAPEA9Pmo=;
        b=YdzqtwD1skjVTKSYcpZSUlkB0m53SX6jQP0sQMMCGj8djSJty+eREp+MaqoPCd8zri
         ARW5FrCUzyqvg2g3PDc8n9Zg9FZpQpJLM5H6ZVrnO0ZfY/c6ZRF6oTXe6z05xOSC9Z0z
         izzHO9NhEVkOp0qxiKsQXd68/AKZAXWjE7ZLeJAfnFyPFKvVil4c0UFOc2bbxt0zEO/q
         1yVUw37s4I7Ju6FLpxC6Zp0ZsziVZBBINxEyYi8VR01gzaSU2giBh+AaYDTaObW6GTKJ
         XdBPuQ27mELd+DywDmSexWOWFne0ALcchIVqLxGxFllr242eWAtgdKSuxIzraRDVKMVs
         w1Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741374611; x=1741979411;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wT8pzATX7z0g510B/bcUtetzdKIxpUlAXqTAPEA9Pmo=;
        b=F/L9zjmSFssXV+cfji5cXooP47KaAsdJeFWRWdQrsJh1zZf3P12Zs3wZTBj5aCr5/r
         Qn6ljsjoL2ZTbZMCL/E7cOyvDb5H9c6vnHdDjkJJqngQHS1DVMj8XwYoGeirt9igOnvq
         uCgUXWFkdSwp/RBNjfSMenqQP/3aTJLtCooiu5Gf37TUwu9T6HbUeJbU77sNUVbhBxyY
         DQrBM4YQnkYzSJWfqwk0XuORVb8YUmQBQjVwBy0hLJdTnc+iSylGjDbMCJn53NTsZbFI
         XDp9Dv7g/4fHanaewjYj5DWv4rniKh84xNGRe66LKddnCFpvzo7XziEI7WKJ8Me/dtQ2
         N87w==
X-Forwarded-Encrypted: i=1; AJvYcCVY4+a98jJ2VsQAIoJ4fh7Q57X0eVYkG0IwSlt30Yz+/kKXg5B2VHeJujQGGXh2D1whBI0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSy7JRdV85obQC1UMpF5SGJwE8paWIy1DxfqBm4kfI5/myDjNi
	/7zIzEJwTalEXmgSfmxFgzPyRoPnfadJxwoHCV/rMy1raBcdw2xbzOLWdPuLKB4=
X-Gm-Gg: ASbGncvr0kMpZLfz2F3l0HJ+vrj5H1hI7xF5ir+Nv1tjQ4al2Qf2YeQ5WECLeR/Y50P
	O54Q9I6EWQfVM+dZJIziB+pwIzqbS45iTK/j1nGK2TE5zh2O1ULjktkeLSgKpVemAohjq3MAIX8
	sZ0kSCzydArqwon9Rn87Z+i2InQzW/29aBCgxGH7DAfzcnPA08twtLKwn2MoMJJCDd8GjqEow4L
	biq3abB7r8Kt5SDWzKJ0sHgH2f+hnnHBW4YjEu6VTNSfaz1794NG7MuyCNypSjqKsSyDUMLyyn1
	+QxzPaX1lsuVEe/zSGoKjza6u8g+hHiBivPGTuFUD7Rp
X-Google-Smtp-Source: AGHT+IEH7EsRMyLZCmYOauj7JToSFEANXbFzPetpi9H1zUtYRPDo3QJkFW/8iGfm/aLPKoNLrKiADw==
X-Received: by 2002:a05:6a21:b93:b0:1f5:5807:13c7 with SMTP id adf61e73a8af0-1f5580717dbmr263818637.17.1741374611193;
        Fri, 07 Mar 2025 11:10:11 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736b2da32c6sm1449895b3a.149.2025.03.07.11.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 11:10:10 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: philmd@linaro.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	pierrick.bouvier@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	richard.henderson@linaro.org,
	manos.pitsidianakis@linaro.org
Subject: [PATCH v2 1/7] hw/hyperv/hv-balloon-stub: common compilation unit
Date: Fri,  7 Mar 2025 11:09:57 -0800
Message-Id: <20250307191003.248950-2-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250307191003.248950-1-pierrick.bouvier@linaro.org>
References: <20250307191003.248950-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/hyperv/meson.build | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/hw/hyperv/meson.build b/hw/hyperv/meson.build
index d3d2668c71a..f4aa0a5ada9 100644
--- a/hw/hyperv/meson.build
+++ b/hw/hyperv/meson.build
@@ -2,4 +2,5 @@ specific_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'))
 specific_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
 specific_ss.add(when: 'CONFIG_VMBUS', if_true: files('vmbus.c'))
 specific_ss.add(when: 'CONFIG_SYNDBG', if_true: files('syndbg.c'))
-specific_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'), if_false: files('hv-balloon-stub.c'))
+specific_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'))
+system_ss.add(when: 'CONFIG_HV_BALLOON', if_false: files('hv-balloon-stub.c'))
-- 
2.39.5


