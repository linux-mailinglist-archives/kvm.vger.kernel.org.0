Return-Path: <kvm+bounces-40223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B85B9A54400
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 08:54:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56295166989
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 07:54:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 640ED1DDC1A;
	Thu,  6 Mar 2025 07:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a1EJ4upn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF47199935
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 07:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741247672; cv=none; b=IeR7/7ZX9G3LrlPoQd8daDwbAZKMMCFw/AaDdYhkqzFty9jVhb0sS+ti1CZ1ZbcduNOKHZZLl+85OPNrMYY2HtL2g6dGpHacdb8sEKlUa5+4omKy+a6HpOI+Ggjiw9P0HLkfm+v17ouKZqLHyNxlYgyhC18Od5CUiazHnXDshac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741247672; c=relaxed/simple;
	bh=MLjTLNn3zemgzyuwNIvmYcRldbosYH/BEkjjHB0xIkw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pZUskQr+hs2vftbf8OePW+kCU+ikTsBQtvQVnufbVe8hQB4xf+TGQmlamVoRrKvJvx/JrqU6szmDV3dlBRtAGOqpTfbAN6naouMXjBQFiWu6sqZReS5H1a0yRPAU5NGg8RBba0HRi08ItvygOFyQXFYOuBgmtE7zNalQSYyTkhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a1EJ4upn; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-224100e9a5cso5152895ad.2
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 23:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741247670; x=1741852470; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hr92WoH/YzhfrdGwNh3+AlDSfi41zIQ/ouvgdawGbxQ=;
        b=a1EJ4upnSJqLu0An/rhvRyECDvAw41tpMrPzFU0B0fFonrgH9v9s2Y7LYNaH4F2LHA
         3kOqkA1PaYnUeSmkbU4jzU7ALJjEg02Y3r+lLuKAhnCa0/rSBPgvBeftvyt7NSC0Gx+2
         XohgiyKGd+NGqaqlbs+uxaRZBENW7YY/NHUCJtqHgOHWTXbYudkJnTDu8G5GZt2+3G+B
         3Ph82/PTl6ft+cPaWpGHVvER3ejitP2LFHgzvDxF3STpp9HjhSs+ji11zn1tZKTPeVfN
         KT+CUpVeySMS1SsGyem4XvgAf2nH5oy7d8FY0vNiMyLmXDSicE4TreR8d41WV4GOe0v4
         3neg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741247670; x=1741852470;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hr92WoH/YzhfrdGwNh3+AlDSfi41zIQ/ouvgdawGbxQ=;
        b=WwxVTB780IioEvedR83xfyKkXoBwbRPtIAOTx+YxS8bZZtV0YfTIqnQXZALw7GBLzO
         Tq+JdRe5TvlG/Fli0CY+AnXKE6WlScWHLlm7TmvWXxOlS6Y6bDd9v365khhx5Ido2j3K
         62j6tkhKCiLnPOVYLL2sqYKR81IkeSUulAbh02bFJ9NFXXjjWcIjfYlnMM5Ih3kJWZfA
         AoEuMm1+HPChjQUyuJCoSMxXdGK3zJTxGg+bj7Uh6E0iHOXtGgpzaP5r96vyeOjK8i7s
         N604WG7XdTcKjVlatY+pUW+FnqFIOkr+o5m9LQz83bMShAkN2KmgIReWI4ohzA6lG5j4
         0jtQ==
X-Gm-Message-State: AOJu0YyJAsmZ4VIoG7JOOBeHtEXfy6jSKwRdfHMYLJAnvVmzQEBiJutH
	2VN3jUOd3cX5nx8xZUHZYbSVFsIhyFMdwsRWjab79LV+Y0V0jF4o
X-Gm-Gg: ASbGncuCY8B8KRyxPDWh/FHtJMsq8X/JTeNSoapa5aZkyYcauEI/xM/XfeJAKE0ezy5
	kNoGhoHdiQv8wR9HlK/cj2F4y9+Px+amfj0TVdXtL+Nju2y7j2Ujw6WEZVfq65ECbaNhFpW7s6w
	Gpiur7953Xb8XRY8MZDSaQDSM5tCy1J5L/yRCuEg553ToM/uz2IFrNkPFlavRimJkGpVpgoM03s
	Dh68Ji09Htz0KmVmIBObPLx7EHWOCdB+MBapsCYlRL0wgvq/tLUQSx/edYwiXIx8gdpCd3JegQ9
	IMsFb/qPpHd6eqePoYZNeKs9Ns5Es5GB/Z75T1n17rAsr/e0+LPQODuGVRBBA5WzP/nvEb6xnzu
	26QuhqSCuQXs8
X-Google-Smtp-Source: AGHT+IGzBL2/cLNbYLPPk99KS3EzS8HKbrHJA6emTFuv8lvjsQ/a2aNLHCkn6BjY6RoO94Ktdj+bEA==
X-Received: by 2002:a05:6a00:84d:b0:736:450c:fa56 with SMTP id d2e1a72fcca58-73682b4ad51mr8158284b3a.5.1741247670200;
        Wed, 05 Mar 2025 23:54:30 -0800 (PST)
Received: from FLYINGPENG-MC2.tencent.com ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7369824554bsm716134b3a.69.2025.03.05.23.54.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Mar 2025 23:54:29 -0800 (PST)
From: flyingpenghao@gmail.com
X-Google-Original-From: flyingpeng@tencent.com
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	Peng Hao <flyingpeng@tencent.com>
Subject: [PATCH]  KVM: SVM: avoid frequency indirect calls
Date: Thu,  6 Mar 2025 15:54:25 +0800
Message-ID: <20250306075425.66693-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Peng Hao <flyingpeng@tencent.com>

When retpoline is enabled, indirect function calls introduce additional
performance overhead. Avoid frequent indirect calls to VMGEXIT when SEV
is enabled.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/svm/svm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a713c803a3a3..79d031fe2253 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3508,6 +3508,10 @@ int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
 		return kvm_emulate_halt(vcpu);
 	else if (exit_code == SVM_EXIT_NPF)
 		return npf_interception(vcpu);
+#ifdef CONFIG_KVM_AMD_SEV
+	else if (exit_code == SVM_EXIT_VMGEXIT)
+		return sev_handle_vmgexit(vcpu);
+#endif
 #endif
 	return svm_exit_handlers[exit_code](vcpu);
 }
-- 
2.27.0


