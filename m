Return-Path: <kvm+bounces-22305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ABD393CFDF
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 10:51:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1E472829CE
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 08:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 621C9179652;
	Fri, 26 Jul 2024 08:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="CxFFVRmF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A80179201
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 08:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721983800; cv=none; b=LyoS+pyKnrOIhu2B5967srrzOLpHKSLjCcLeis+1lKikI5YhyzXSc17EmO49rMNqovSksSassmg0O1aTnxKCYbi5SDwSCjKSGWsRkLoVn4Hh2j5To4lPSYteNla1Jae1EFQIg+nBFEZdty07jEmhYbeF9aDd+/PWX63nnbLNJyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721983800; c=relaxed/simple;
	bh=kmSTht2ay/WaraC9QeCfGlPsOABUHyhKUYCSzPBi1L4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=nI073MtrdYJhPsp1agh90RdShgHNVS6Yn4VtNxm1/OmcC+8IrLtxxbe1S0pj0oKgkqhQtn8PmIiFlyjccReyZmyEGqUcHR4mPUPBRM1Z6a0K2zQdP7duyhO5Pv4k2iqv27rECbF+1N4dCjDSvJ1nrFyCsegberi0ozD+wW5sACU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=CxFFVRmF; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-70d357040dbso645565b3a.1
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 01:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1721983799; x=1722588599; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3dXGB9M68kLUD7MhXnrJa0QNMQINVnKrW/fzYtIxsFQ=;
        b=CxFFVRmFHFy6MxsDV+oQVaL+MsLkLMOD65lg+QUK/kYEnqJ1Ffku2st1o6fh3cQzQ5
         cZanjUhP+a4FgL/X8pwVdI9k94GbgMgYGY7LushkSGYr2wxZVV1DkxdQNiXh1r1JDBS9
         44SSz/fTCrDR5m3ObmsqFCe4ktHzR7irvZQsC1cVi7IRJJ4nQT7RRxIR6MtJZbkODvag
         0aT06NpshgvmPRSZkKTXdyBxF3XcdjttW2TFyv79FVsJob1tLD6NomGLmnm7Q8DTsPsy
         QwzX7S11KTAsrUF40PN/msYGaU0K16ALDjy0H06GhTe/nUfZH3r6a2ChWohMjt302b1W
         H91w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721983799; x=1722588599;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3dXGB9M68kLUD7MhXnrJa0QNMQINVnKrW/fzYtIxsFQ=;
        b=QphXucFKlqXlm58VSSyvfrjxBhs5zRW+s5FxV0dTDozoBwE5Zf1wtYhfPW/afi+IX9
         YrL+RTpOgv+hIBM+vCqZDD47L/AxJykncAkFgDSHo+l4iuG5xZhdPwJ3nOZbpts1zDag
         mS8wvhd4yfNqc4mz37u4V6y8o56S1kXsNPvaV2IjzwUjMmRBf9S3WYKhdMkhygwE3Bb5
         R1lIKTUzokgRoeiDk70KMyHOmZgghq8eQ4w3l9mGTnhe9biyZtgj+kTnqUMbr2GsCkO7
         Et/Z53hg5BjunqBNHDwKYj9EfGdfmDJ/6pGVg7S11jFfORWA6AkxhwMxdAlDNlRR14ff
         fzlQ==
X-Forwarded-Encrypted: i=1; AJvYcCUODkM3rm9VK7STrpu6ZTeVHDBy95UqM3a7xecFUGSbGirwbM7aPEaoziphiu10up5OH5fxqY76MX/9t35i5BTT9CLZ
X-Gm-Message-State: AOJu0YybLFJ7YrQr7DS7VqSgJnL52L+iuOA5pC+mSeM7EmoDN0dGB490
	TcmnBC/2H8+akaaGPLprVTVw3lsRVuD4nr6/N5qA43ZnHXa/eR/hfHXtoVK14Fw=
X-Google-Smtp-Source: AGHT+IGznbiFSiAI8Fl6vXmZOoRo3AgApK1TPweDDMBRdHNs5h5IX0DOrE9eMPt7tTokhtzC2+Ebew==
X-Received: by 2002:a05:6a20:2451:b0:1c4:7d53:bf76 with SMTP id adf61e73a8af0-1c47d53c6c7mr4526810637.38.1721983798630;
        Fri, 26 Jul 2024 01:49:58 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7a9f816db18sm2049645a12.33.2024.07.26.01.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jul 2024 01:49:58 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v8 4/5] KVM: riscv: selftests: Fix compile error
Date: Fri, 26 Jul 2024 16:49:29 +0800
Message-Id: <20240726084931.28924-5-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240726084931.28924-1-yongxuan.wang@sifive.com>
References: <20240726084931.28924-1-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Fix compile error introduced by commit d27c34a73514 ("KVM: riscv:
selftests: Add some Zc* extensions to get-reg-list test"). These
4 lines should be end with ";".

Fixes: d27c34a73514 ("KVM: riscv: selftests: Add some Zc* extensions to get-reg-list test")
Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
---
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index f92c2fb23fcd..8e34f7fa44e9 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -961,10 +961,10 @@ KVM_ISA_EXT_SIMPLE_CONFIG(zbkb, ZBKB);
 KVM_ISA_EXT_SIMPLE_CONFIG(zbkc, ZBKC);
 KVM_ISA_EXT_SIMPLE_CONFIG(zbkx, ZBKX);
 KVM_ISA_EXT_SIMPLE_CONFIG(zbs, ZBS);
-KVM_ISA_EXT_SIMPLE_CONFIG(zca, ZCA),
-KVM_ISA_EXT_SIMPLE_CONFIG(zcb, ZCB),
-KVM_ISA_EXT_SIMPLE_CONFIG(zcd, ZCD),
-KVM_ISA_EXT_SIMPLE_CONFIG(zcf, ZCF),
+KVM_ISA_EXT_SIMPLE_CONFIG(zca, ZCA);
+KVM_ISA_EXT_SIMPLE_CONFIG(zcb, ZCB);
+KVM_ISA_EXT_SIMPLE_CONFIG(zcd, ZCD);
+KVM_ISA_EXT_SIMPLE_CONFIG(zcf, ZCF);
 KVM_ISA_EXT_SIMPLE_CONFIG(zcmop, ZCMOP);
 KVM_ISA_EXT_SIMPLE_CONFIG(zfa, ZFA);
 KVM_ISA_EXT_SIMPLE_CONFIG(zfh, ZFH);
-- 
2.17.1


