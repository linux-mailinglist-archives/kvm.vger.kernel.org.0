Return-Path: <kvm+bounces-44231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5DD8A9BB3B
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 01:28:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 636FD926949
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 23:28:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A3DA28F951;
	Thu, 24 Apr 2025 23:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WDIYc6oV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F407A2253EE
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 23:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745537322; cv=none; b=LIpmOX3euMeEjPXjWPZcqRhEamGxyDiC+z57IzbUnBRMrt/OUuQpTEuX7oETXDJ8WSc4fjT8Y2K430rU7lBU3WjcqFz+0gKAzDzJJkWl6Z3hkvcBmEiofw0KE/1G6ATEOuHhacaJNsuh90FEKSrZTfnLxDIawVhUVarGJb9diZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745537322; c=relaxed/simple;
	bh=rVAM4RcOXiP9Rg8Wb3t+nj5uTZPrfgRj2ddSkUBIJ/o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pwBJDrznr+kNtCMUZjz94vKIlRbcKOC6aYZN0CEKTZHlg9fsDFOeLaSe82Jc9fkfX1+b6s0VnkDNF5tIm3eD753jqWRlGEmHmrlAS6UtzKlHSpYIGCf9A9rBDGxorAi7yW3NfY+s51mAyfhRJ+2V+S0sMUPS72AC2I4kBLGzEHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WDIYc6oV; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-73bf5aa95e7so1511766b3a.1
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 16:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745537320; x=1746142120; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OOjC5KI63SbLoAcab6C0ugB2QHtpLUMoBslKkCj8HHw=;
        b=WDIYc6oVcKp1id2ujy5LBfOpwVY8xOhxxXn6UAvrhR+U+i9EhPyyBfKtz8I+RU30va
         3Dy7+GiBEf/zbFaSoBMu9o8YKW4jBTJxEUY5lrN4yBvTAkp3m4fsfLhsmIj7YeC06WMq
         N9UHen50//7woh1RVzmsVf2PywWEdSEy7i1QHPFeZBcobr78wUFqcu8zZk3KVSMaNZLI
         Q6uClF9TLGEFF/x3dhmbuJu96H9Q1oqwfh3t2cFs0HAfEt+Sib00W36nsDDd1bmHOQ5S
         aawnH5/Xm6AsRM5Q9i9xEMDxWdD7nlef2o8aBDm+Hut5/VXQQ38ajEVt1wl3pwgqMeGO
         fIQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745537320; x=1746142120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OOjC5KI63SbLoAcab6C0ugB2QHtpLUMoBslKkCj8HHw=;
        b=VOg7hEq8yky7gQXBejeS7AjvVpAKzXIg9Gn9b6TOrzCRHuebKFA2nyCugFxcTnHHD3
         BeUKFDRbLfGJTv+HsGOeAX7L2Y4IKVN8XZcFJdd2rlT8KQQFy9xU3qv8V9jOwqvpmRzO
         Cb6bMEBrP76Dea6dJEqHwJGBxYw5RNdRhX/QoorX/n6Zbnz0+jT/IPsBtehMkk/EqOs/
         dxuLZYmbT9g38afGkg0WpvMK0UCQJY85zABDEg8St+MJAOUGuzVTcHRIuYM6DVvAPQ5w
         zqvD1CoH4UxaDF6i6mI/GvLD45t3eVK3kmfMdV3vMigzbKExRupMA45/9YS6m8225ITV
         Aliw==
X-Forwarded-Encrypted: i=1; AJvYcCW9Ckb+KO5u1WovmAcE/UBiLuzq722LmeqcP6eFQB5hGqeM0oWXITidc3P6yHcYMxBC3Dk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxm0PO8kUVjDN0/xK2RhzuNuaxMpFXX6NptHdK6momC6SC7gEDx
	Xm+omnjnc9USh6h1pgrDuRWq5wiYpl5O+RH2Lg/Ns35ajlACWtZFogGbZBnRniw=
X-Gm-Gg: ASbGncuA0NJ72lmaApe7wtYjhQ3BKqOcA7qu2VTTS+88jsb9gQbtz8fSImv9fZo0rdD
	GtvIIwPwEcuD5YI1J9eQYqQje1Tu6PXwuNvRR0DePfmCat0+6r0FponyYqtO4d7Ors62INx1hEP
	0yOwDMrgjO+3nIoNaL5XcnSmCe8VED528aoAz+X0lKT/HXEszv6KFxcW2gsOYpR+M2xOdQanizt
	YjpCWhIkwzUoXeoZJ9MW2wd7+G3czsEVsrnE1cJFImB9SkbsBubpYGOdCfyLokSsv5O4QykEdw/
	KGXGeBKHvWaWL4v12W4fQU/UDLi0KVWxL2NYgD0a
X-Google-Smtp-Source: AGHT+IFPnpKAC5v02yvLHI0k01LSHqtveMDVKvXuJaN7IJsSzQTevCb+Ft+SlunLMTrDPlL/F0HptA==
X-Received: by 2002:a05:6a00:2da6:b0:736:a694:1a0c with SMTP id d2e1a72fcca58-73fd8e52315mr121872b3a.21.1745537320253;
        Thu, 24 Apr 2025 16:28:40 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73e25accfbesm2044318b3a.177.2025.04.24.16.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 16:28:39 -0700 (PDT)
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
Subject: [PATCH v5 2/8] hw/hyperv/hyperv.h: header cleanup
Date: Thu, 24 Apr 2025 16:28:23 -0700
Message-Id: <20250424232829.141163-3-pierrick.bouvier@linaro.org>
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
 include/hw/hyperv/hyperv.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/hw/hyperv/hyperv.h b/include/hw/hyperv/hyperv.h
index d717b4e13d4..63a8b65278f 100644
--- a/include/hw/hyperv/hyperv.h
+++ b/include/hw/hyperv/hyperv.h
@@ -10,7 +10,8 @@
 #ifndef HW_HYPERV_HYPERV_H
 #define HW_HYPERV_HYPERV_H
 
-#include "cpu-qom.h"
+#include "exec/hwaddr.h"
+#include "hw/core/cpu.h"
 #include "hw/hyperv/hyperv-proto.h"
 
 typedef struct HvSintRoute HvSintRoute;
-- 
2.39.5


