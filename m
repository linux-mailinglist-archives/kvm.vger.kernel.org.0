Return-Path: <kvm+bounces-36444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6755AA1AD61
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 00:44:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 273EF3A2C9E
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 23:44:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 102BF1D5CFE;
	Thu, 23 Jan 2025 23:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UNHnuNRL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF8C1D5AB2
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 23:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737675893; cv=none; b=QPlHxUYJf9oEl3uMb/RS44K9U7NYP9XQMO9FV2EQcMSN1ug9DSnPLNPpRlIbvRp08IhCxLdiD7X+SmIFW8gk9Tbk0YZagQbzppJY5z1JwooNlqEfeE/Hk3VehdbfLIqhFit0PGTpR8tZXEFk56hRPGDoVPMEN8/xPQ2cEyKOcy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737675893; c=relaxed/simple;
	bh=eo8IJSEOw86/rfcioZNtTvsqeN9aNAr23CZR4oAoiiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DyNC8kGYswp+YbckQmmHAAU4dZN6ujRTlNl+6W2r8ZDUy4qC/LHrgh2xpjGLw3QndDE2gz8FzYfg2crPF+pRTTNWNeep0DXC6d2JCNCqEs6Z8YmbC+K0SV/LNOWz0ynlGxpRydE+9sgJGw87RcMkSgF4JXYA5AOSU6X4K8K5rq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UNHnuNRL; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-38632b8ae71so1133768f8f.0
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 15:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737675890; x=1738280690; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VK0JABDJF/QMP4ClWDlwjdLf62KvnH3DnM23ZO9feXo=;
        b=UNHnuNRLKg6XS2nzYre+Cu1KHobhTH7v41aTvT0zmUUu8s3bQoTZ+WwqLk7F20tYkb
         AOJ42eYqwViFXIeu9O/b3sFuKUdJBDyxW2uI7oJFojlhvaCOROmPibo5g1rYDA1uo0Dr
         qbllyy9+2YZQpk2DEoRudru1vaB4eKd/eU/LkoPPLrzeOmStwc2WvV+jXwWqmMhiZIXz
         p/ysEpl5xl20S6LP1PhFrFd6AlXvFRVhdGR5o76UsnabMuJ5tCeXOcjmaRrhTeIAjp1V
         NkL1S5nVrzTGyMoSa1voos8krSH8HJ8xQTniGSlzyqiSiJZfSW5di7m1qtZISpwWg+jk
         oZmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737675890; x=1738280690;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VK0JABDJF/QMP4ClWDlwjdLf62KvnH3DnM23ZO9feXo=;
        b=XGFu4ScQj3z7Gd7+x8ksQiOpQKYsC+fCpJLQBSX4GRxd9sjw7wb2xpUvf+9Ws3N1QX
         MEKddg1jvpPwqXIc6HOG3V9TvF5RtYJ/C8lvXSUoyf66LoT3QKZhLTnFZ48TRAyEryx4
         +9c8GEGtee1VoVEY4b/29FmguooemZn4soGOsdeZ3u9iasV+xkx6ctlhQGfD2iD7Rsfa
         qJnUyD/lbStCxdRBp3SHocHVt4VzeSw1WlI0/nKhfadbndFjywlIDNfXerXhRsX2KZGm
         ElQYK7O7zEMhKr5Dsz+ec1roUyBJ4lai4P0pi+hpoyiJ5nrTCUFCYmsFB28wADdJ5w8J
         rTkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZbHIaz3cFk79E8zvXsykNcYlqdGZ6Z1fLE6B2t2iKocRW47ieskXv5oOt/oB5QyoziMg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0pw1+JWqMZrRlLIJcTQrxS5DZo5mmU7tDdtYXs6PGxD64Km4D
	ZYTU9dg7StPsJ28Mh/ALcA1iOQ1V3jifzh3KL20PzTc6ZaVxKDmlqNOrnwxf03Y=
X-Gm-Gg: ASbGncvhNfBhqPVuu+0MTlhFsZYyIHrl4znPkeJxnoQ8v6rqAieFEZHuxR6kPqCpUQt
	6wzRnu+iMSmF+9Ftq+Uqna6bzkKi9SFD/UHb5jLnNoEZut375HJL9KkNyzhfJQku0P7U1QSqAf7
	W3+PMiLsf9fK3uojUPerA4JImBaEZIzXwOxVuV6n6K+LhKUHouV2t5O3zkgJkGSCB12q0u+e9H4
	it33tS3jEL5drZkOSEY/asC9ievsPVCgNrzKGyzOITnZ7UmCXN8Inubpejd+7BavjXU6lw+Or7N
	YWuNRMYWFL9v7lEE3/5eswvHNMdVjxjKmD6fjXcm+InpM1HyHHTMTwg=
X-Google-Smtp-Source: AGHT+IGSMRqXknIm20dxUVJ6YnBSj5qdwQEIsknPsDpqx1Ro9qYQKL2SDEG840LoeQHivalI7LVk8Q==
X-Received: by 2002:a5d:64a1:0:b0:386:3262:28c6 with SMTP id ffacd0b85a97d-38bf5677c09mr24857649f8f.5.1737675889741;
        Thu, 23 Jan 2025 15:44:49 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1c4161sm952291f8f.88.2025.01.23.15.44.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Jan 2025 15:44:48 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-riscv@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	qemu-s390x@nongnu.org,
	xen-devel@lists.xenproject.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 06/20] accel/kvm: Remove unused 'system/cpus.h' header in kvm-cpus.h
Date: Fri, 24 Jan 2025 00:44:00 +0100
Message-ID: <20250123234415.59850-7-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250123234415.59850-1-philmd@linaro.org>
References: <20250123234415.59850-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Missed in commit b86f59c7155 ("accel: replace struct CpusAccel
with AccelOpsClass") which removed the single CpusAccel use.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/kvm/kvm-cpus.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/accel/kvm/kvm-cpus.h b/accel/kvm/kvm-cpus.h
index b5435286e42..688511151c8 100644
--- a/accel/kvm/kvm-cpus.h
+++ b/accel/kvm/kvm-cpus.h
@@ -10,8 +10,6 @@
 #ifndef KVM_CPUS_H
 #define KVM_CPUS_H
 
-#include "system/cpus.h"
-
 int kvm_init_vcpu(CPUState *cpu, Error **errp);
 int kvm_cpu_exec(CPUState *cpu);
 void kvm_destroy_vcpu(CPUState *cpu);
-- 
2.47.1


