Return-Path: <kvm+bounces-45254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E253CAA7A71
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 21:56:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7094A189619D
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 19:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB7361F584E;
	Fri,  2 May 2025 19:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mgBQaTZV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3E71F5423
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 19:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746215784; cv=none; b=C3i3Qe1Sir1ytLxEsP/XWmtjWfbaS09L2Tc0GIhGV8QvAMoAH08djx7z2rLFe/tmXq9iqbAvSzFIQm8U3lzwhXzqj4rRrymStHYY8KiEnuN5OEpCsBOnR74Pg4t1vfJUjbfO+HB+1ACQuYpKRcz1KrUWrat83240bF9u1oB66Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746215784; c=relaxed/simple;
	bh=ER1MlQCZgcZ5HQss2BU1Qhzm75YGKlHPb2NZ2hIuDEI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Xsfk4QWtMsrh2UevOmAQc47C6HAPfaOLl+zOSDLqCionWlt4T3v5gl5D2OoPoFYHFPSnqhByA4JwR+opP+scOxHuH8msQ0Qvy4vxf+J9myoOYxR5YFqEfxoVl/jko79kKWTxYfQGR4YWTplUzqn/zQ2ZdXwJAyST26gdBLQRaUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mgBQaTZV; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736b22717f1so1973741b3a.1
        for <kvm@vger.kernel.org>; Fri, 02 May 2025 12:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746215782; x=1746820582; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=652qg4L35jalUlfbZqx+h/hkyWTSRc4b96iuDy3YxSE=;
        b=mgBQaTZVQ2KzVNmhXZfjsfF3vyhxiWbJ6iJHEc5CZe92HjNb672zwWNESmPNynldfN
         wjRrpkKcVpTOfJPWSaP/2uh/ILKOAyboLnllSDtKki7l6FXEkMbIjECpdX82EbM043Le
         hdvb/lIUKL4V2eVjBySwX28nFAc3V0p1wqHEx+X4tQHQuW9U+Izay8Hoh92p9nPewCxg
         s5y9txKA3/q8uZ+yLjKjI23ehip27KuiqRhLshqgbHfhvONBYktNLTRL852bYr2rd+N5
         IBgU6gmpt1WUjbvF1d2QpFyhdtmOv+afWQzDSlwGszAWmQI5bXrmAWFfoOK4QrGgQa+R
         YwAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746215782; x=1746820582;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=652qg4L35jalUlfbZqx+h/hkyWTSRc4b96iuDy3YxSE=;
        b=sq+aRnY4MqB++wjN4LZ0KmpE87iLXLW+rYXDAl1FC6EPeED4QrmABqc1DWyx5tvJri
         Sw1T54+VT8HvbdjznRkPLG6l6cAu1ulF4T9H7ifiZqQDpJaaM57Jc8OrA6JtKmUTiH46
         gfifd0jit0pv6BcUawi7ZL9mQl6CgylKq6LZE2T9NSMw/TYfWdRPTVEJLVev0mjQt4tI
         NJmA2PLqkeRiIRQ1AiJ2etDgj3QRMF5cbkgpHLpnDnecPUZ3KERAN2N7A86XuOvgRWbG
         u5H9xJtXQpw2weWLfgpgWMesy9vZ2fc/ATHIEcrSq7zEfofrhG0aTX1wVbCqLg6YHKLZ
         IadA==
X-Gm-Message-State: AOJu0YxDpAcsXAvcJfPl5SHA+KNafRnpQBLtaof5ca84PgBeqC7XPys6
	RkOUpS2F8tl0kMaXU66gpJvL81YJBSm8St5MbGCWyCsFdpjI6+9px3NRrKM555pY4VLp285KXCL
	3CA==
X-Google-Smtp-Source: AGHT+IFyRFVCtVIvSGXeAnRp3cYo9W+dCXXCj7rDIYiODr51TYMnaCmQ/nrpE8Z7LcR72/bd/iP4sKrlq2M=
X-Received: from pjf3.prod.google.com ([2002:a17:90b:3f03:b0:2ff:84e6:b2bd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:548c:b0:2ee:c30f:33c9
 with SMTP id 98e67ed59e1d1-30a4e228570mr6223439a91.14.1746215782091; Fri, 02
 May 2025 12:56:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 May 2025 12:56:18 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.906.g1f30a19c02-goog
Message-ID: <20250502195618.848606-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2] scripts: Search the entire string for the
 correct accelerator
From: Sean Christopherson <seanjc@google.com>
To: Thomas Huth <thuth@redhat.com>, Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Search the entire ACCEL string for the required accelerator as searching
for an exact match incorrectly rejects ACCEL when additional accelerator
specific options are provided, e.g.

  SKIP pmu (kvm only, but ACCEL=kvm,kernel_irqchip=on)

Signed-off-by: Sean Christopherson <seanjc@google.com>
---

v2: Require the accelerator string to match the start and end, with an
    allowance for comma-seperate options. [Drew]

 scripts/runtime.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 4b9c7d6b..ee229631 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -126,7 +126,7 @@ function run()
         machine="$MACHINE"
     fi
 
-    if [ -n "$accel" ] && [ -n "$ACCEL" ] && [ "$accel" != "$ACCEL" ]; then
+    if [ -n "$accel" ] && [ -n "$ACCEL" ] && [[ ! "$ACCEL" =~ ^$accel(,|$) ]]; then
         print_result "SKIP" $testname "" "$accel only, but ACCEL=$ACCEL"
         return 2
     elif [ -n "$ACCEL" ]; then

base-commit: abdc5d02a7796a55802509ac9bb704c721f2a5f6
-- 
2.49.0.906.g1f30a19c02-goog


