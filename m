Return-Path: <kvm+bounces-20520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C1C29176BD
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 05:23:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 457AA1C21464
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 03:23:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 105BD6E613;
	Wed, 26 Jun 2024 03:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EIAJ+4VJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4E6134C6;
	Wed, 26 Jun 2024 03:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719372196; cv=none; b=f+mToGGoLNGPjiEsq+VXsnVA/S0fGIXihft5sMvIH0zskYPsSkKS+lV6HUuniwKZgzOyQFarQybhbdX2nQfqQhs4+LSSppYb0VbJsO7+MPajH7SoDfcbpBa/ckXDQXmPoge4zW2kQ2tALZYYMBxiC1AWDMm+0/TozkhRWRveTps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719372196; c=relaxed/simple;
	bh=aWjn1rK90uH7zvPoIIMTcC/De3KqAp6uqTomLwmzbzw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=UbacriuboTcOTatmoqMvCPGNJgK4J634fQc9ECDtedJhsbH9h9gFfiyAso4aOfbN5x62GwVsn8ZGr2fU94VhuMOCSUyuMwCm0PPzlWNjK+ASIC1E/fU8kUDAQNilB32s3+vVwpfHC+9RiyP0j5BEMK98dEp7ey4OwA3pxRz0t2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EIAJ+4VJ; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-dfab5f7e749so5602486276.0;
        Tue, 25 Jun 2024 20:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719372193; x=1719976993; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iv3u99b064y1TsWE2viRxdT9uyZ/YeMIpIqbTIyfWg0=;
        b=EIAJ+4VJHaiG88h03wNC0yS1EifAq+sp2+ZoaAr1MC4Ccyn1GPhpmie1HS86Jif9EF
         MzIVk29fXpcky6cA7EDBn6sxJAh1DNFVN0znaTmmuGWY8xG9DS48I2pPPEVhH4kIKzBo
         19sI0VJBuikRSgmuPCB3KIguXHIn4im/RLJ2p2wRIHwa5o1vJ26k92gGdXwYtsemnflc
         vBZU7XJLE5OhLx+/Wjwk+EiQU5R1n3WPIeZ1icLo7HQiAoB1oY+yUGDRLTFXHGIHR5tN
         K/Chp894g1mh9nsv5o57LH7jFhfXdDcM9llXVpaY0+Fe4S8nDUaQl3rd1wk312QBcJMQ
         LhYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719372193; x=1719976993;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iv3u99b064y1TsWE2viRxdT9uyZ/YeMIpIqbTIyfWg0=;
        b=gz5RhwsPfJPdnXFr7ftX5z/snkNJVG3nAlA7dqajZePOmRG+i6HoLgLyxUXN30yW1q
         VlqSWxQGcksoir8jn7eY6vstxTYIVFnlh6sMgYyZqQe4OjUc2AGAgaFfxm8+iSdBrstk
         X/WUYyEdiuLswChHM5wgjcvJbI3piNvLtmSqbi0G8S1B65paTaZjfMlBf95GOas8NVO3
         Mc1z37Q9fIia7dYaiMmg50qU5/MMb4jkNcW3gQI01hP4AFpFy01YSr2a50skKcFfZfvM
         eaIaOZVMCU8/cZaaau9+ZeXZUpqO2O2Fld8pQRE86g+jlnDXk3DDWqdap/Jym3gwjJYR
         MsQw==
X-Forwarded-Encrypted: i=1; AJvYcCUYurq0MbMqsX3mX+JQO3G/VIrAe4VUtARZvUMcqSfRDIoLCgJuWN05hs0OnT/sR96OVaq9o/hpH7idDEwCeexig6PeWFiev/89R4QG
X-Gm-Message-State: AOJu0YyMC+NQPQBv5CmFSrZTFx2KxUFnSQVoSnK7gEuJqZdLsl5gQGra
	w51O+oe10lmTI1QvF7X2r7pQ+UWrrExQVhnPNpsChqDnvAzKkTi0+3qWbV8o
X-Google-Smtp-Source: AGHT+IHb3wM9H5WMVTrsE2syyBb82TfzvE2pNvRpcgKYhK4WGjMD50iPrm/hNpnspsj/and9mebuWQ==
X-Received: by 2002:a5b:f90:0:b0:df7:7437:5801 with SMTP id 3f1490d57ef6-e0300ef0111mr9909472276.13.1719372192697;
        Tue, 25 Jun 2024 20:23:12 -0700 (PDT)
Received: from [127.0.1.1] (107-197-105-120.lightspeed.sntcca.sbcglobal.net. [107.197.105.120])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e02e62655b1sm4165494276.36.2024.06.25.20.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jun 2024 20:23:12 -0700 (PDT)
From: Pei Li <peili.dev@gmail.com>
Date: Tue, 25 Jun 2024 20:23:10 -0700
Subject: [PATCH] kvm: Fix warning in__kvm_gpc_refresh
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240625-bug5-v1-1-e072ed5fce85@gmail.com>
X-B4-Tracking: v=1; b=H4sIAJ2Je2YC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIxMDMyNT3aTSdFNd0xRjY6Mk01RTQzNDJaDSgqLUtMwKsDHRsbW1AFox/cJ
 WAAAA
To: David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 skhan@linuxfoundation.org, linux-kernel-mentees@lists.linuxfoundation.org, 
 syzkaller-bugs@googlegroups.com, llvm@lists.linux.dev, 
 syzbot+fd555292a1da3180fc82@syzkaller.appspotmail.com, 
 Pei Li <peili.dev@gmail.com>
X-Mailer: b4 0.15-dev-13183
X-Developer-Signature: v=1; a=ed25519-sha256; t=1719372190; l=2384;
 i=peili.dev@gmail.com; s=20240625; h=from:subject:message-id;
 bh=aWjn1rK90uH7zvPoIIMTcC/De3KqAp6uqTomLwmzbzw=;
 b=MhQKsSHjCelN+0W7sTUon0XvADfhupXmPz82SKJtr4qpcJEbC7Ig+R8b4TLKewDK8R6Hdy/qN
 zggzvVEplRSD2cYhuGn0i+u8jsC0aJEzwjSfa9ZDZGdUpktFKblDp8Y
X-Developer-Key: i=peili.dev@gmail.com; a=ed25519;
 pk=I6GWb2uGzELGH5iqJTSK9VwaErhEZ2z2abryRD6a+4Q=

Check for invalid hva address stored in data before calling
kvm_gpc_activate_hva() instead of only compare with 0.

Reported-by: syzbot+fd555292a1da3180fc82@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fd555292a1da3180fc82
Tested-by: syzbot+fd555292a1da3180fc82@syzkaller.appspotmail.com
Signed-off-by: Pei Li <peili.dev@gmail.com>
---
Syzbot reports a warning message in __kvm_gpc_refresh(). This warning
requires at least one of gpa and uhva to be valid.
WARNING: CPU: 0 PID: 5090 at arch/x86/kvm/../../../virt/kvm/pfncache.c:259 __kvm_gpc_refresh+0xf17/0x1090 arch/x86/kvm/../../../virt/kvm/pfncache.c:259

We are calling it from kvm_gpc_activate_hva(). This function always calls
__kvm_gpc_activate() with INVALID_GPA. Thus, uhva must be valid to
disable this warning.

This patch checks for invalid hva address as well instead of only
comparing hva with 0 before calling kvm_gpc_activate_hva()

syzbot has tested the proposed patch and the reproducer did not trigger
any issue.

Tested on:

commit:         55027e68 Merge tag 'input-for-v6.10-rc5' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16ea803a980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e40800950091403a
dashboard link: https://syzkaller.appspot.com/bug?extid=fd555292a1da3180fc82
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=16eeb53e980000

Note: testing is done by a robot and is best-effort only.
---
 arch/x86/kvm/xen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index f65b35a05d91..de5f34492405 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -881,7 +881,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 			r = kvm_gpc_activate(&vcpu->arch.xen.vcpu_info_cache,
 					     data->u.gpa, sizeof(struct vcpu_info));
 		} else {
-			if (data->u.hva == 0) {
+			if (data->u.hva == 0 || kvm_is_error_hva(data->u.hva)) {
 				kvm_gpc_deactivate(&vcpu->arch.xen.vcpu_info_cache);
 				r = 0;
 				break;

---
base-commit: 2bfcfd584ff5ccc8bb7acde19b42570414bf880b
change-id: 20240625-bug5-5d332b5e5161

Best regards,
-- 
Pei Li <peili.dev@gmail.com>


