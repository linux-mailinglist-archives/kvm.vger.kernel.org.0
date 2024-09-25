Return-Path: <kvm+bounces-27475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 385C698655C
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 19:12:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 697B91C24B7E
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 17:12:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08C1C12BF02;
	Wed, 25 Sep 2024 17:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="a3zzJWmQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8519B80C0A
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 17:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727284309; cv=none; b=dn1E17iZ8B3XOnAUgrqzdmrh4WKL7nFFOta8gOYo2EBRNrB/OsQquEVwLATJ9sWzsBnzWYLrcTYZ8zfbIPELh1S/Q/UvUNLVZPtLB46ByfVF1ChbKA5ucD0vT1dXeFj/BxDXRmVQof3h3xjZ2wxRUbopdsXoBFdyVlXtvvgD2AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727284309; c=relaxed/simple;
	bh=ahcnesimgw3QlHd8VJCV89oQxIg9QBH1LRBLnHOZ5T8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TFRxXzPwjI2RYgEbKrF4VpGEL4BEkJ1WfmEwlPXQhmQFmye0P1cfPy1WYQxNN+7TzkpdSMUmbzNDH0nFipHecZl8INk3IdVO638jJnJElfxvi/Duj58uptxWP2Dqclx2g/JONPe3E39rhdz296+v8uC9DlLqLuPOXIbLb+mAtLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=a3zzJWmQ; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-42e748f78d6so332925e9.0
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 10:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727284306; x=1727889106; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EDuKUu/6yQVewIifCo34+Vf5uNGO51ibdAtzIBiO5J8=;
        b=a3zzJWmQntuVVe//W4C35spLDx0I3DUq6cjrGItAwjnJX6LsN6ugNvHWk1unopz4J5
         XsXVKIYpws1efTrZJsqkabo+Qu/eJq0BBwkCU4Saw8ytx0EVFkhQseaIjWnv3XynTp0g
         Lyi7TFtvtHUWPPMpNwgrQAu4kyu0RvY3jK0JGA4bXaTqi/unTPQ4hdWETEoqFxKv0VgS
         aU7veeMDHV1ovuHS4Pyt0ySq7ssvyN6Ah2gWjW8WpuIqjt/F1Bl2s5XmsbsuNfTCgYS+
         +7/WQRIQRqHo3yJXfrXhKZhi/vSt4Pw6vb+TKVhjd77QYR3CLH+LAj3cuOfhVD78ecSD
         zyAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727284306; x=1727889106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EDuKUu/6yQVewIifCo34+Vf5uNGO51ibdAtzIBiO5J8=;
        b=N3pu12FWpEpITt6MWKZV9mhqj5c1dblUbQyPNE5SG5R/vzRyvJB9WEGuq1/kwmaQ5Y
         eHlNhJGvjeIXkyPv4jH6vId8YhYpK0evODTEaM59aNovW2RFCdoV1OFgCBJZHG8x9YQD
         54iwxQLTg8QLIYizOnLOmcOCl+OhqxypkIwZQVqfRgjpVel4nAamAe8dGeJ3GR/SNUBr
         xGuAj8Egd+1NsRqjjjdEvyrxBNXFGHEpar9y3dSZhljxN5WqZrSkt11RWke4jTqiYKkq
         DR0+aKPyZzXcRpz74tB7C5qdsH8WyclJMtXKD86Zc06Rd2ItIfl+v46EqrPp7fvz5UyR
         Uefg==
X-Forwarded-Encrypted: i=1; AJvYcCVq+/yG3XNTBNwi/iEOGp5jm2JUSp91xzX06b2GKXZ6DpT8nllRxRtpqX6Yboa/hlLU/yY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKjpsTlwVi/APs2mrhmQqMZw+bHNdyaXmigFngJtvgW9bqkzHr
	jImJa/yY3OWCtjJYFzM9XUSrkdojTQ/NfsjjcVG6SDmyu+cozaTTugqcDp4fvwM=
X-Google-Smtp-Source: AGHT+IEA9zk5J4EgLwcu9iKTkG6OebG0V871ScTHwgvkLHU/Z/qAW1uTvFwLsqIXWyXSVXC9pmkYyw==
X-Received: by 2002:a05:600c:a085:b0:42f:310f:de9 with SMTP id 5b1f17b1804b1-42f310f1005mr13936295e9.15.1727284305716;
        Wed, 25 Sep 2024 10:11:45 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e969e18f7sm24065735e9.5.2024.09.25.10.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 10:11:44 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id E015C5FA3D;
	Wed, 25 Sep 2024 18:11:40 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	kvm@vger.kernel.org,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	devel@lists.libvirt.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Yanan Wang <wangyanan55@huawei.com>,
	Thomas Huth <thuth@redhat.com>,
	Beraldo Leal <bleal@redhat.com>
Subject: [PATCH 06/10] target/i386: fix build warning (gcc-12 -fsanitize=thread)
Date: Wed, 25 Sep 2024 18:11:36 +0100
Message-Id: <20240925171140.1307033-7-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240925171140.1307033-1-alex.bennee@linaro.org>
References: <20240925171140.1307033-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pierrick Bouvier <pierrick.bouvier@linaro.org>

Found on debian stable.

../target/i386/kvm/kvm.c: In function ‘kvm_handle_rdmsr’:
../target/i386/kvm/kvm.c:5345:1: error: control reaches end of non-void function [-Werror=return-type]
 5345 | }
      | ^
../target/i386/kvm/kvm.c: In function ‘kvm_handle_wrmsr’:
../target/i386/kvm/kvm.c:5364:1: error: control reaches end of non-void function [-Werror=return-type]
 5364 | }

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20240910174013.1433331-3-pierrick.bouvier@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 target/i386/kvm/kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index ada581c5d6..c8056ef83d 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5771,7 +5771,7 @@ static int kvm_handle_rdmsr(X86CPU *cpu, struct kvm_run *run)
         }
     }
 
-    assert(false);
+    g_assert_not_reached();
 }
 
 static int kvm_handle_wrmsr(X86CPU *cpu, struct kvm_run *run)
@@ -5790,7 +5790,7 @@ static int kvm_handle_wrmsr(X86CPU *cpu, struct kvm_run *run)
         }
     }
 
-    assert(false);
+    g_assert_not_reached();
 }
 
 static bool has_sgx_provisioning;
-- 
2.39.5


