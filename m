Return-Path: <kvm+bounces-24210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 254509525E3
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 00:41:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 575F61C21111
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 22:41:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 512D414D2B8;
	Wed, 14 Aug 2024 22:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="boBzll+X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0585614B08E
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 22:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723675300; cv=none; b=iniL7WnkDivx1BQn3T1dsDQyBIK7Fr1t/0qziluHhhLl25gdOfFhGCzvQZsvlkXkc5cgQQXA3XA5c3sst6tPSwS0k4xZ6RkUDAWuGW/rdciTymz4O8lrYSefZcXlycAdADvNLuRoKjSP/3ljOgTXQXf5FTlvDoocUQo4YcwHnSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723675300; c=relaxed/simple;
	bh=VEOWyN+y5Vy4QgY9/GPHx/njJikrmq525E7VBVdGZy4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HiZSgLY33eLNpoJS8k1+ld4s3Y5uWT8SE7NwA/8l3I/6Qwi6mf8YPIs3CLxc8PHnf5ayDhylRG+wNhgqc64v2suHN11xyfM3wrvjAl34OSl1XHEGZANS3kwx9as6YB0+OF5+ZEvOjCFro+eTU9Dc251i/wqj6h6Jz4dig13OYn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=boBzll+X; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1fd65aaac27so9959315ad.1
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 15:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723675298; x=1724280098; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lkpyTpSOlqu0+QkwYEsdEX4Fr7KToSSmbcU9XazMmXA=;
        b=boBzll+XjcnkJrXJmWL3cNYsq5Vh/KId1Hou0sAc4cY9WSru9UggRTscouiC0T35dl
         NllvkgQD4Bj+jZffIuu5tnR7uIPzXvzU06xcgDz4WcaszLiyH2OjL1jtOlL9b0gJ/S3d
         ka+uulZcQklN1t/YBcPqDL8dcilR6hlLUIn5iC3e7MI14PWM+C+RTa+UPyWUa/loSzfI
         CN/FRemsXWjz8iUH6JZODOGFc9gx26DqyCONh+4B0T3dWkGnUQufFEbNi2IXo/V1uKtg
         xIW+Y1cmjsvGFws26QWbktfbs1xn1gGELT+rbLSUKKxZEcw9iMbFansEiuia9x42mTSj
         2nFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723675298; x=1724280098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lkpyTpSOlqu0+QkwYEsdEX4Fr7KToSSmbcU9XazMmXA=;
        b=XKZbkX1Ry6rDAB/iKcsMx/8xlgZ++Plx04+CE7l0YFwKLX9/+U2LJTbmp2Dv0EQrXZ
         j0Jeqdcdp3PgzzKg6QBK2q4/T64WHrWVIuxsA0enlDFMfoF4irsEnU4fOYAgSowcyBNT
         RLEzsgUYRa88jl6W8Z7ZdPGn1Wcf9GAxXMrL928mFyLKPy7bHulAxXgEyXgo3ZDesu2N
         P42WwGnYcYRJnOYyTmnzkwSA51zf+/AXWHPMR+vOQFDLQIuw6fOFRCNLYedZEcEY9XfP
         f+cnroBUqmoQ9JnSRJDRnH/nhtdn3l91nLcQk+BlWXLpjNYpRJO+CVfc4pwGQutnb9n+
         +HVg==
X-Forwarded-Encrypted: i=1; AJvYcCVWB7VRA8CfnodxE3+Udq62iPVei2AH+yLdR9nalUr3sXsJienti1Ed39o6ViR0j8If9C/2m9LvisZqFoDGEZVRrCH/
X-Gm-Message-State: AOJu0YzcEmjiQ90Gx7IMb0NUo76r57su7B7g+0xwPueIEs6GTJGiaa5F
	3tmsbHtXDQZDavoft6HpGSQ7gaCwpRHvnJ+rCuFYIM5RSGMoLgdlyHRnWONQv7M=
X-Google-Smtp-Source: AGHT+IGkesrW/K1rSLk7UrsKDf2/qUa/M6f0mBcupHt3koifZY7D+XvsN9EVSwi1JJN5HwVBtak53g==
X-Received: by 2002:a17:903:41ca:b0:1fd:a412:5df2 with SMTP id d9443c01a7336-201ee515b17mr15782565ad.29.1723675298210;
        Wed, 14 Aug 2024 15:41:38 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00:5b09:8db7:b002:cf61])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f03b2874sm1225595ad.308.2024.08.14.15.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 15:41:37 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Beraldo Leal <bleal@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	qemu-s390x@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 2/4] target/i386: fix build warning (gcc-12 -fsanitize=thread)
Date: Wed, 14 Aug 2024 15:41:30 -0700
Message-Id: <20240814224132.897098-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240814224132.897098-1-pierrick.bouvier@linaro.org>
References: <20240814224132.897098-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Found on debian stable.

../target/i386/kvm/kvm.c: In function ‘kvm_handle_rdmsr’:
../target/i386/kvm/kvm.c:5345:1: error: control reaches end of non-void function [-Werror=return-type]
 5345 | }
      | ^
../target/i386/kvm/kvm.c: In function ‘kvm_handle_wrmsr’:
../target/i386/kvm/kvm.c:5364:1: error: control reaches end of non-void function [-Werror=return-type]
 5364 | }

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/i386/kvm/kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 31f149c9902..ddec27edd5b 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5770,7 +5770,7 @@ static int kvm_handle_rdmsr(X86CPU *cpu, struct kvm_run *run)
         }
     }
 
-    assert(false);
+    g_assert_not_reached();
 }
 
 static int kvm_handle_wrmsr(X86CPU *cpu, struct kvm_run *run)
@@ -5789,7 +5789,7 @@ static int kvm_handle_wrmsr(X86CPU *cpu, struct kvm_run *run)
         }
     }
 
-    assert(false);
+    g_assert_not_reached();
 }
 
 static bool has_sgx_provisioning;
-- 
2.39.2


