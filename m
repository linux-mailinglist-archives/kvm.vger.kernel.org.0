Return-Path: <kvm+bounces-25106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0640095FC8B
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 00:14:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 79A061F2254B
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:14:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7890619DF47;
	Mon, 26 Aug 2024 22:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HnyFN48k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2209019D079;
	Mon, 26 Aug 2024 22:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724710447; cv=none; b=LmbXP1zIAwND1SxK7/Z5A01+HXaB11Fth6WU6fnB/GylAYAqKVw+OiSzfOSWVZ0mBCTtMGp1z5uVI+XTxfGEhFvaKvRopfuei7zsAz5cwK2OW+Y+akfhtEO1x3ojIOOAjHHUg/5EPYl1UyxXSZalBDQ2Bfq8D0lbwpwBwRhUAvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724710447; c=relaxed/simple;
	bh=zwpBfgNIO88HbBaEDXGpa/LI2zBKT1BO/U4s1Sk7qiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qc0eCJssU6Ob1GIU/p87I04GCUDzNcBG9bGjn2KQGBRBi5qyu3kyWJzq89DE715bEDiau+RXZGf7bsGEsTRYVI3MBN6IJlnT0FzJdnEgJzbQMPMaygqRMPpDaBjtlzoil11g96S3sANwKUSGitQ4EQ7Wbv+CSyR46cmqgh272D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HnyFN48k; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-4fd0a012aadso1479185e0c.3;
        Mon, 26 Aug 2024 15:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724710445; x=1725315245; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wcjk2h/iH/KoUml+g/8LwbeRmveLqJ+O9vO+r1w3P5A=;
        b=HnyFN48kQhMergWAlV2RUofNQKxD5sAhSaH1uBDbgKappTt1GIZFGS2S464cUwyP4i
         bYTQK7j/t3NBYOIW/jbkNrXykufdvEzsbspk6Ai9jIOy9G6L5eSVy5wTbFo8TFyhmucf
         n2cE066GRyzfPqoY8862FP7LXdb6R+PfoLqtFkB+5OSH7QzofBHnVazh0qATZu8MKGjD
         0WqY8S9jYrySslXUK9fA4eeF+xzrT7L1t9WH94QtQRlIzRA01hZQ46vfsVrmdeG8uE67
         +7+6rtHyouXxpmgIB/5zm+N0plv0ohLOW7Z17nClxPoKngkR9VCtX2R9kRYqmK7YXVsM
         ss8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724710445; x=1725315245;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wcjk2h/iH/KoUml+g/8LwbeRmveLqJ+O9vO+r1w3P5A=;
        b=LtYyd6me5JQ6w8wnO8SWPZS8ySo+ouLpx2SMBQUdu0O2sbATJfPMkvYl1/HkZYCMfv
         eYux9McmVu+jaD88knUFT14BXps/uJsATUfI8D3iBj2Nv0fMOWr/ZpAJVkV6USNLGKO6
         G8nGPR2LdS3EKcZpQK9cvQW0UVBdLy6qOuWxXUwFrowCK9ZEZILfbNVIBHvIcQbthgTX
         SzA4A0Bqtv1ZuMIjlPbUAAFjhomRopph68RsiMk8Cawit+llyTMaMJ11LASgXr4zIp4a
         DcPHi1prmsw7pGqhFesJMtLZRNnnr0SnS9Q+O7RvHEBrF2+93yC7dBajlTvZXhTAfpqJ
         oGqA==
X-Forwarded-Encrypted: i=1; AJvYcCVbiT4X9rHRGx6RHBUcFjcrbMvL2FgctKjMwzM1xOwaWqW+0gaVKMaZEV3/9Cd5E3BL4qyMJCmMKsPZ86Go@vger.kernel.org, AJvYcCWP+MEWI/6eRr0Enmso2O0uszFtSONg1wfSuk7PaDhmLVBo21CCrJPIpNyoe8/299YJBbLjp7UH@vger.kernel.org, AJvYcCX9ehwKYWWZQsh4NDXHdcHom3QPSz8+8wwHhCNdbXNg47NkVg+zE1HhmlNT3fA93sFJ/NQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxemoaN8d4lC3mNosqC2ZrJIoVlLw9fry3DTwrNvSekuV4u7Mqe
	y73ogQk0GNgpdgRwVjTRadV2MkDCQFyaAXEPwyaoAm+hK6pUrkr5
X-Google-Smtp-Source: AGHT+IGjYlpIJZH+Sbpr6xRxOkDH5ZQYnxPANTXa2LX4x4yBhPNp39fud0oj76DMSz1wxbwmW6J2mA==
X-Received: by 2002:a05:6122:7d1:b0:4ef:53ad:97bd with SMTP id 71dfb90a1353d-4fd1a5106fdmr13792427e0c.3.1724710444811;
        Mon, 26 Aug 2024 15:14:04 -0700 (PDT)
Received: from localhost (57-135-107-183.static4.bluestreamfiber.net. [57.135.107.183])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-4fd0838111dsm1020351e0c.50.2024.08.26.15.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 15:14:04 -0700 (PDT)
From: David Hunter <david.hunter.linux@gmail.com>
To: seanjc@google.com
Cc: dave.hansen@linux.intel.com,
	david.hunter.linux@gmail.com,
	hpa@zytor.com,
	javier.carrasco.cruz@gmail.com,
	jmattson@google.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lirongqing@baidu.com,
	pbonzini@redhat.com,
	pshier@google.com,
	shuah@kernel.org,
	stable@vger.kernel.org,
	x86@kernel.org,
	Haitao Shan <hshan@google.com>
Subject: [PATCH 6.1.y 2/2 V2] KVM: x86: Fix lapic timer interrupt lost after loading a snapshot.
Date: Mon, 26 Aug 2024 18:13:36 -0400
Message-ID: <20240826221336.14023-3-david.hunter.linux@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240826221336.14023-1-david.hunter.linux@gmail.com>
References: <ZsSiQkQVSz0DarYC@google.com>
 <20240826221336.14023-1-david.hunter.linux@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


[ Upstream Commit 9cfec6d097c607e36199cf0cfbb8cf5acbd8e9b2]
From: Haitao Shan <hshan@google.com>
Date:   Tue Sep 12 16:55:45 2023 -0700 

When running android emulator (which is based on QEMU 2.12) on
certain Intel hosts with kernel version 6.3-rc1 or above, guest
will freeze after loading a snapshot. This is almost 100%
reproducible. By default, the android emulator will use snapshot
to speed up the next launching of the same android guest. So
this breaks the android emulator badly.

I tested QEMU 8.0.4 from Debian 12 with an Ubuntu 22.04 guest by
running command "loadvm" after "savevm". The same issue is
observed. At the same time, none of our AMD platforms is impacted.
More experiments show that loading the KVM module with
"enable_apicv=false" can workaround it.

The issue started to show up after commit 8e6ed96cdd50 ("KVM: x86:
fire timer when it is migrated and expired, and in oneshot mode").
However, as is pointed out by Sean Christopherson, it is introduced
by commit 967235d32032 ("KVM: vmx: clear pending interrupts on
KVM_SET_LAPIC"). commit 8e6ed96cdd50 ("KVM: x86: fire timer when
it is migrated and expired, and in oneshot mode") just makes it
easier to hit the issue.

Having both commits, the oneshot lapic timer gets fired immediately
inside the KVM_SET_LAPIC call when loading the snapshot. On Intel
platforms with APIC virtualization and posted interrupt processing,
this eventually leads to setting the corresponding PIR bit. However,
the whole PIR bits get cleared later in the same KVM_SET_LAPIC call
by apicv_post_state_restore. This leads to timer interrupt lost.

The fix is to move vmx_apicv_post_state_restore to the beginning of
the KVM_SET_LAPIC call and rename to vmx_apicv_pre_state_restore.
What vmx_apicv_post_state_restore does is actually clearing any
former apicv state and this behavior is more suitable to carry out
in the beginning.

Fixes: 967235d32032 ("KVM: vmx: clear pending interrupts on KVM_SET_LAPIC")
Cc: stable@vger.kernel.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Haitao Shan <hshan@google.com>
Link: https://lore.kernel.org/r/20230913000215.478387-1-hshan@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>

(Cherry-Picked from commit 9cfec6d097c607e36199cf0cfbb8cf5acbd8e9b2)
Signed-off-by: David Hunter <david.hunter.linux@gmail.com>
---
 arch/x86/kvm/vmx/vmx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 87abf4eebf8a..4040075bbd5a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8203,6 +8203,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.load_eoi_exitmap = vmx_load_eoi_exitmap,
 	.apicv_pre_state_restore = vmx_apicv_pre_state_restore,
 	.check_apicv_inhibit_reasons = vmx_check_apicv_inhibit_reasons,
+	.required_apicv_inhibits = VMX_REQUIRED_APICV_INHIBITS,
 	.hwapic_irr_update = vmx_hwapic_irr_update,
 	.hwapic_isr_update = vmx_hwapic_isr_update,
 	.guest_apic_has_interrupt = vmx_guest_apic_has_interrupt,
-- 
2.43.0


