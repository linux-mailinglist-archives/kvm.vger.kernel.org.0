Return-Path: <kvm+bounces-24174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DC2AF9520BD
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 19:12:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6879FB2382D
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 17:12:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A55861BC075;
	Wed, 14 Aug 2024 17:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gNMf/F4P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3171BBBCD
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 17:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723655528; cv=none; b=M1Vo6nWx3fuO3asyLUFm2NhZSIRdN6V8jkiMYPh9Bnfov9R1tqgDOFGjCqBYtFpZ/6MuuTkW90ZwK8Po3V8Ql5C4VCuvw7uXpiUYMsTJeem3jeA9QtDqVhL/DDtt3QejO5Zcqvnt1tAbei8Nm6eoCx8gdsOoGIz1PpqZChNx1Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723655528; c=relaxed/simple;
	bh=hT5qG+TrOMm+Kj1E+B54mE+KRv2ZFH0KeUlk/ny15Oo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pk2cgS/trIApdfMEwr678Y26ZB1iLb+vQIKcHOFdJypJH+US3wB+TdV7CXPd+nNYFfmO8BZth06PEl0P3+5Z6BraIJLEftiWK8tWyXrTML60MVh3vtUsHt6E+Ovs+NWZrQHTQ7UnwsBoUeQeqfdMzTPM0dhKsmRhoA0XdgPjk5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gNMf/F4P; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-201df0b2df4so842475ad.0
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 10:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723655527; x=1724260327; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C8jtLk0rS0EhtRCVLy6d5dSWwHGsq2dL7mHB8O5U19E=;
        b=gNMf/F4Pg57oKYu/y9IlSa3uROlajIBU9eXn6Rdyp/g6LdaqPNjXMKN6KO0c3+8qZW
         eXu+pGqLIRfNh3eJR3YtNB1oHxZG8DnIQWwOoOUKjrADAm0lDxL/tm+Xh9bV2iNkhioI
         6ssLnn4eQzY56NwGl2XSiczhffO2JV54m4TbCTM+6cR0GQbqupuvpHVu7I2A+NvhwoZz
         3TZNg6gsVy9RokrDmp6wYfrwvl+u+Fw2u6xVV7cg8aY4mOok9E9aREnF5KSYhSR9nqWZ
         HtTehZDpDASyOgmW+NDzgvrQ41sPDykN388fshA+JPOyoxk7fcltr32CcPaa67wEF0Nh
         w9xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723655527; x=1724260327;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C8jtLk0rS0EhtRCVLy6d5dSWwHGsq2dL7mHB8O5U19E=;
        b=XiPeY9WZpD8AUglc/mBXwi6+KnapKwjpqnv+yDbfIQ28P5ublZCImlfR3snienuaeh
         gapCeDYh09dTa7/yjgeBi1bsENcDt1waXLa7VEia15YfmxKogT9N36/PYD052t6VXkT8
         FM67rbvRdqr1Np/1hfFnaH/gRNIgbeGHj3PAtGGPkWmQXbbbdflZD0cPPf/qigIJgboH
         SvzoxohX+1d5low9kxDbVwtc2+Yq3a/mHJaaubnNexqurUM5mFaHhQetHDRdv6t8qzmK
         vRmaiIAZcjgg0UZp8Q8Pqt5mdT7kbU+zlq0ujW06OW/1v4RniuCftjKCBjjySkBOmWaZ
         AlGg==
X-Forwarded-Encrypted: i=1; AJvYcCW65EvYQi4EThA0tFh0oEZO6MiCBqpnLBO+cm2GmVB5kodf0uo3r2+rC7gpR5qTD7KKl/EkqrMxIoABqDtP2zN/E8BV
X-Gm-Message-State: AOJu0Yy79xxH9uJkh8K+idR28m282ZCjIWNiRE/w3041fqH7OiD5LOUa
	66+RfLRv7T/Vs9RE1ff/t1sxnSyqDTqAcjSCQZNqtyicfaEjkRlN+WA2GlJfkow=
X-Google-Smtp-Source: AGHT+IERRzizD6WdFAWCfPZg6Om1n+JiPPLwp3B/FbS7ZNeztWagWFiwUGTp5QjIt2c2704zR89fkw==
X-Received: by 2002:a17:902:b68b:b0:201:cdfb:2919 with SMTP id d9443c01a7336-201d638d821mr32538115ad.8.1723655526725;
        Wed, 14 Aug 2024 10:12:06 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::b861])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201cd1c8783sm31813895ad.245.2024.08.14.10.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 10:12:06 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	qemu-s390x@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Beraldo Leal <bleal@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 2/4] target/i386: fix build warning (gcc-12 -fsanitize=thread)
Date: Wed, 14 Aug 2024 10:11:50 -0700
Message-Id: <20240814171152.575634-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240814171152.575634-1-pierrick.bouvier@linaro.org>
References: <20240814171152.575634-1-pierrick.bouvier@linaro.org>
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


