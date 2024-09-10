Return-Path: <kvm+bounces-26330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEC0A9740DC
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 19:42:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B8D1281BD3
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 17:42:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34ED71A76AE;
	Tue, 10 Sep 2024 17:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DLzaqKa8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8241A7063
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 17:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725990027; cv=none; b=GRv5w/xdtYkwnmj9WrblvLNcYnRNmNn+l1Wh0uOviLozE+s79uQiijywd9SZw539IhtGihU/EatMkZ5AGQG7amRznQPaxaz1HWz6acJDCrjSMMAQnVwS4gWb4sCkPA6gjmLAkSWvoxVDf5whz7IzQ75NUNDnm61symXmqkDmPIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725990027; c=relaxed/simple;
	bh=yBjdXAtnte4NW3LwRNXWR5icfGV4Bb+iEw3W8CIUl+c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RqbILZr/pZnFWqwxuhvhuFMX8sLPyZpjx6BNh1QraPCtlv7Cd0TnXDeT89u+QCsCyU1Z6btFeBOiHMeuxwB2885ZicmXloSsi7abT+QZ7OA2NyE2C5fnBG+sbOQ6MxglirJ+hT82hm/DLD2QCHoMmD6oEl8PxMlEZ8K46S6QgX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DLzaqKa8; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2d8b96c18f0so4564116a91.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725990024; x=1726594824; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PxK/kUedWi76nv9Z4j6eZ6ETsIVX17z0F3roB87C/Q0=;
        b=DLzaqKa8/kRZExX43MQPiQjxLiJotx1qVSxdsfdqtgfw2uKXNpy+TcbdxR/kamIGwO
         7NrT6Sndvf9QJ78YZ95n6QcjzRtqGfBqgoXxDRJ328SyQkZVIBIa0kK128Y1Onm30O0p
         /GqSsliuMgoQ+rZj/XT4on2xYWKrOo9q+qehz6T/FUOvozJf3rpM5qBaLads8au9b2Tm
         FCQ6cTcKN/1F56srN/9ovFEDzNdbTwAH/8WwizmnCYbdBoCk/uTQ43RVSmId9Me4/KvW
         sVuufF5+FEncVupEMjs7TeiqBnnJxWnOwH+HNY4tjlY5y1/R+i7P3oLKzYnr//L3S+GU
         WZgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725990024; x=1726594824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PxK/kUedWi76nv9Z4j6eZ6ETsIVX17z0F3roB87C/Q0=;
        b=Kq+Y9iWXH85p1EVBUJjloJKRUzUfQcqUDP2LCEorx2jiqXMZUXIh/H1j9IZrMOYKjB
         uEw/3QY/3b5Uje30NHIRjTFm9w1sq9wevKQ8q0Stb3L1kzOL4qxkF9SyiE99NKrPLPp7
         DmYFSd9lm5U9ue3oPy/TQNhIHGvWzYAY/bTx8LBD4JHNm6gxoWDTbiHF5SQcHB0fqNYB
         m6eq00y/yhvsDE+BWaRPiSuOBpWpKla2O/+gH5yipGyG5M2SSN1Kt+1L6jl4aDUnX1yV
         +U7k7wcaXaE4t9aHSDQowFhWypiEOBoKh4McXp+chAwWi9SkfSNSPhiYNz5CdMDTyXRE
         s4bA==
X-Forwarded-Encrypted: i=1; AJvYcCUTFL5l+cDb1C0hNKt3BZIOw0IUTatMXdjSGrluTI7gUihPkKwwAG5XYrzYT6QZlBq7Uak=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZxwOtMQ/l1JKakArugnvWKaBQv3wB4pkHg60s//Qz+3tC85Zz
	hNKSzVQqMYYYep31e5WX6PFg7PeFwYGSdd5IYfhBpaANZC91rgFuNUlioD1fjpg=
X-Google-Smtp-Source: AGHT+IHIEh2gOaDV+kP/9BofpfisOSSU+8HsXyUxQbN5hvDsWwuXez7jJ9Dt81kkjIr+UHHAmLwAYg==
X-Received: by 2002:a17:90b:3c43:b0:2da:5156:1253 with SMTP id 98e67ed59e1d1-2dad50141cbmr5998023a91.21.1725990024249;
        Tue, 10 Sep 2024 10:40:24 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2db04966d3asm6682751a91.38.2024.09.10.10.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 10:40:23 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Thomas Huth <thuth@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-s390x@nongnu.org,
	Beraldo Leal <bleal@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 2/3] target/i386: fix build warning (gcc-12 -fsanitize=thread)
Date: Tue, 10 Sep 2024 10:40:12 -0700
Message-Id: <20240910174013.1433331-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240910174013.1433331-1-pierrick.bouvier@linaro.org>
References: <20240910174013.1433331-1-pierrick.bouvier@linaro.org>
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

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/i386/kvm/kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 2fa88ef1e37..308b0e1cb37 100644
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


