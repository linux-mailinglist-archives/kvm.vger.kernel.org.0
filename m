Return-Path: <kvm+bounces-13648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BC508997F5
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:37:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AFA6CB21BE1
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A17E515FA85;
	Fri,  5 Apr 2024 08:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g+/qOJYz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BE1145B09
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 08:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306182; cv=none; b=MUHllgYLL3j6wJFWyOxRVNWE7N0qxZoKvQydgByVcFicDG/RdcL+q2uSd99Iqzn6DP3dVc8KJSQxllaCxg3RaCWYugFRb8KUJOHReOdIY5ZIlgZ6PQQvvpz+ZehW2fumRaHBhRttQme9pf7BX2ZZfvML/6HaPj9Yp1mR3GAoVnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306182; c=relaxed/simple;
	bh=gFmslkjdvBftVZKNo25zHhViDGQwBoSHrkDQIoKH+fI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IakosNo6ld0WBmTEHl6TX0mwPsanBV8UMO527cZHf/wwzGX/gcQY9ZD5s79T0sb8Z+COJ6tAVZPUdFjKayoCX8wxPXAfWxRattSzpuNW37S/IvteOGaaxFV7GjL0kr4Aj0I4AxJcq1EgUcl8lFsvRaVfGY10/V0KXrAzqxyI6O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g+/qOJYz; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6e6b01c3dc3so1164713a34.2
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 01:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306180; x=1712910980; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=30fh0yQBw6PorNxnoqOiIeKlx1L7d0w5kZn3MakUxVY=;
        b=g+/qOJYzqMA+TLt1Hs23MdjaMdtsFlWd/EuucNFnyRn4lrWY42Onm1VsjQoO5hLM1o
         56xGTF33lZ+Dq0DwCqXzI8YF5rHFz25CubCLzBskNNNKRTZuAeyKuCZjQVZNXJfy5sqS
         b1ISR8cdhIKUIENYiCE6wooNVrYPz3FX60wzFB5DvKziyBjckTBd2kUHRIM0njmimQQL
         8t/rWdd5qII5huLTUSQo6K0TXduB4wdXefizENhGRXFxHn6AImWCUHXawNqZfxug1AKh
         6F1tG0oDN9bbtq11QW+FOlzZ6n4woMx/65E69zJx49A/0nUppnNfBjZMRQMwiCkoPtLy
         VEKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306180; x=1712910980;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=30fh0yQBw6PorNxnoqOiIeKlx1L7d0w5kZn3MakUxVY=;
        b=m4fchm12xayAelk15wOOran1z+4otT0RVQLImrdFAyOyYpdushMWtUgZxBDhVcha8h
         E19W5XOAmE9PYXSBF/oJcuC8ehZirHrprtXek+dmjYsu1KKtqE01qCRdRKoMzh7/tIfe
         oRAEUMowwlS1j/W2Wqy/gGsIxX2BfF7z7IUSQuXsaD0QliyQwvDNAd2FP9FZr/nFpkht
         LhajH9S8cq34yra1i3Yh81GjNuZmhTsY9MGpnPH6/kvEzUgkfH/OOTn7vDtqnQNjsrrt
         Zx1X5oNxVkXX4Hq+PZ8RQKYtEr+1ycek4bHAHvE7BLrbQuOFFexA7O0LCRmG864jAtJs
         vbpw==
X-Forwarded-Encrypted: i=1; AJvYcCWy+Z8xqq/0f79Sym5Uu1qczdl5KFRUUNARsln69MTBgMNFCVjaA9Az0Uokt7c5uSQJWGg/DyyjKCf5hi6NqUvpOiRk
X-Gm-Message-State: AOJu0YzZQdNOnRrt1LAFVkGClHvB5GGML70r34HtDgiFD8SwkHgyXMzD
	nPD1SqoDPo6Ur+FXW9/YX1jqYLq/fFD8eBMTvkvQuYULLIG4j4vG
X-Google-Smtp-Source: AGHT+IEwX93vy9dusFaTBUm3Gcf/pVzsUgPfOt6akJEEck/mPBQYY9e4koetiEicEH6zUiyf1R+O7A==
X-Received: by 2002:a9d:674b:0:b0:6e6:ce61:3ee3 with SMTP id w11-20020a9d674b000000b006e6ce613ee3mr736377otm.18.1712306180480;
        Fri, 05 Apr 2024 01:36:20 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:36:20 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 08/35] powerpc: Fix KVM caps on POWER9 hosts
Date: Fri,  5 Apr 2024 18:35:09 +1000
Message-ID: <20240405083539.374995-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405083539.374995-1-npiggin@gmail.com>
References: <20240405083539.374995-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM does not like to run on POWER9 hosts without cap-ccf-assist=off.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/run | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/powerpc/run b/powerpc/run
index e469f1eb3..5cdb94194 100755
--- a/powerpc/run
+++ b/powerpc/run
@@ -24,6 +24,8 @@ M+=",accel=$ACCEL$ACCEL_PROPS"
 
 if [[ "$ACCEL" == "tcg" ]] ; then
 	M+=",cap-cfpc=broken,cap-sbbc=broken,cap-ibs=broken,cap-ccf-assist=off"
+elif [[ "$ACCEL" == "kvm" ]] ; then
+	M+=",cap-ccf-assist=off"
 fi
 
 command="$qemu -nodefaults $M -bios $FIRMWARE"
-- 
2.43.0


