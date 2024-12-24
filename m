Return-Path: <kvm+bounces-34366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BEEFF9FC273
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 22:05:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0FE447A1B36
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 21:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C30E4212D96;
	Tue, 24 Dec 2024 21:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="k5fIu+Ab"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE16B3EA76
	for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 21:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735074301; cv=none; b=gViaQNnsrHwrcA0HozdOdfJXJmjczQtQBqZXWpItt594qEMhF/oeF7PC+YbviREW//7C+Zh6ukXLVY78BzkGlNCH0ZL/mKBEwT9d0H3c+dsl0OZ3ZjGpRUjTuVBLKN9MHRdgfZHXwxcbKjYj6zfYOwUCwGWyH9yTLy70DUDBBsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735074301; c=relaxed/simple;
	bh=ioVvC8eg4qJkoimf2UXWNQMWPpTA0Ez9yimmyjBlhgc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=q1CfYyP7haYBxFgUOB6RFh/ey18OLs2V4dxm1LDlKbK27AsIdPcAWoWeNsD3DH5S5u8AZyTVH+oac1dVJpZLen1jKf7zVptzka4wDpiKa4RxxedYy/skB1crQKHae0xRj+BcKpMD6Ox/0LE7FqB2qw5bp1DtSVynkfqi+fob9fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=k5fIu+Ab; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-216401de828so55240025ad.3
        for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 13:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1735074299; x=1735679099; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K7Pb5Vxtmu1FY9/J9EKk+mhOADazj56h0vKNA3c2QKo=;
        b=k5fIu+Ab7Z1B/GGb/nXhoC+5TzRZBKJTpAZld0QORT+VRDpFsLr0v1bmtgiWCInuMh
         yHKZbUfti1Q9a/m0tfc8Q+T21wqKM6ENPt2rEDtjODdVFSS1mp3unl62UTnitZL9lbjK
         haTQv7wC0ScghKVtDli4ieOj2lI3Ov8UGuOBDL00S47ZJboDu+4kCWrgPHFGfDsOUidl
         uINj3K5jzdx3ITExGvJBPe/Txyq5otDrlafaiDCMepLAZus/fqpyZ7ZfOtCRbuXoMsXb
         5C9rE/uJ6/PbriMAo8llxhgo1znlLvojeCIvCMoU+B+uoj+q9Bz11QmLlOy6Fo1Jg3vu
         Kclg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735074299; x=1735679099;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K7Pb5Vxtmu1FY9/J9EKk+mhOADazj56h0vKNA3c2QKo=;
        b=qjpkF73/0zc1BfCYrewXbemcD89ad+bDNFXnSBe7j4Bh8hqWEkxm38Ebg6+/ROWL1p
         hUxJZ+jVb6XuZilqsE2pmAJQSYzvZe1GcWxyqXuXXGzgD/HlyWcs2DkYU8wujG4yrc3C
         8U8g20/srXuZRnRNH1/hkpITWQL0yVGFkkebBB6HEbx6ZRrsI1BbwHc0JmYUxZ8m1xrq
         V7hYy7b7gAYEzWPXYPBCXxAMhNL736JS05AcPVTwusj7882ngOjEENickQ55QANsMcSG
         cEI6ztVozlutmsGLpiSZ3qdsr+ErLt9kdl9RfATRYQkBUQBz2NjJFFJWFQorQbGIS07V
         Jjkw==
X-Gm-Message-State: AOJu0YyazyreGnzCbnkuCzee3RMXNe46Xz2EHesQ84BE9EqRWyVSuOpP
	EHJdwGNq1r3V53VmSwGpYc+xGaSurIVU+E5WSw1gazS8cM5QGas1nvr4M0mG/4I=
X-Gm-Gg: ASbGnctJiUCFvbIsMFnupebU1+6SDd4mmsgwdzcJfYMEbKx3TVxJIuA03OcdSxpC4RT
	ZsXtqB6Fx4i5gJvQUzG9Iy0o2j0ZLQuQv8Q8BVKdNSIv/hxlIxC7+aFwlIcBj3lNshZObXQ6b/w
	VBIqZALT+xolDna3txQ8pruvbyYcvMGXN0yGN1w7QPj7LPgG+WBDBeyCGi/tS4n9P1CJCvfkKun
	AAoQBi3HYSGBMy8GMdFvA1ddeThZ1Nn/dckawgpUvv5EHJKUC6iLjl1jMGsG9BgJ1LfYQ==
X-Google-Smtp-Source: AGHT+IEINBS2wMAKPXcEeiQvMr4mHt6N/s5a4KNXcdkRoepKl+xENIOeQWFga5Ts/3lf9tV+pKQhqg==
X-Received: by 2002:a05:6a00:3905:b0:725:e73c:c415 with SMTP id d2e1a72fcca58-72abde8fd6fmr24905523b3a.18.1735074299238;
        Tue, 24 Dec 2024 13:04:59 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad90c344sm10445925b3a.186.2024.12.24.13.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2024 13:04:58 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 24 Dec 2024 13:04:53 -0800
Subject: [PATCH v2 1/3] RISC-V: KVM: Redirect instruction access fault trap
 to guest
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241224-kvm_guest_stat-v2-1-08a77ac36b02@rivosinc.com>
References: <20241224-kvm_guest_stat-v2-0-08a77ac36b02@rivosinc.com>
In-Reply-To: <20241224-kvm_guest_stat-v2-0-08a77ac36b02@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>, Quan Zhou <zhouquan@iscas.ac.cn>
X-Mailer: b4 0.15-dev-13183

From: Quan Zhou <zhouquan@iscas.ac.cn>

The M-mode redirects an unhandled instruction access
fault trap back to S-mode when not delegating it to
VS-mode(hedeleg). However, KVM running in HS-mode
terminates the VS-mode software when back from M-mode.

The KVM should redirect the trap back to VS-mode, and
let VS-mode trap handler decide the next step.

Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_exit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index fa98e5c024b2..c9f8b2094554 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -187,6 +187,7 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	case EXC_STORE_MISALIGNED:
 	case EXC_LOAD_ACCESS:
 	case EXC_STORE_ACCESS:
+	case EXC_INST_ACCESS:
 		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV) {
 			kvm_riscv_vcpu_trap_redirect(vcpu, trap);
 			ret = 1;

-- 
2.34.1


