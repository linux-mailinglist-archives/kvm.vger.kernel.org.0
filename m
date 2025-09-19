Return-Path: <kvm+bounces-58252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B12E1B8B81C
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:39:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90F4B5A7CE2
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:39:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 929292F90F0;
	Fri, 19 Sep 2025 22:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4QTlCx8A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA172F7469
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321229; cv=none; b=IEarIQlMk3ooxYWAFGFTcsseFITho2lDSvSo7TCOoMzWgJREtacOBpfb+J6Dv5G0V0s70EEgIAkwwGMNkK2lwPPj8RkrxINHvNy/OQ5hdz6vaIeKxDQS8OTtcrTtaNPHYwzEjxOWtKHDTwaQD1TNE52MQ8hmNX03Nz3wHJvlWGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321229; c=relaxed/simple;
	bh=YXWxcN5ooFHzqnHIABGYf8Ki0nUZbdPJHRUwd/y69Sg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZJ2uriONA7zmPl/OZDxJVzF3SBb1rSzUawdj+LoBXuqBCFt+VFQhu/0/bNZw5rYxK5L5vYB8d2DtcvTzgyji+ZU/coH9iF2m1OHcBY4Sobu7V+s9y0TQHsJJPt+uuZZuaNM5/N2R6RMMWz7AIhBskeJVgIoOqT4SG3sR9XrxPaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4QTlCx8A; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-77f18d99ebaso190986b3a.1
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321228; x=1758926028; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oawoE6LRs/Nu1QjyiEx29qtiXpbR7RT6KFUgBZxZwV4=;
        b=4QTlCx8A31fyzt+7lNI+vatJqLddodmJHpWdBbhpqZMbX6N5BVUiRaDBkZkErDM8JV
         h/Yg4vqRNiaU4c3Gjhsrf93lF6LVM+2vvW6wanS3QHAKWG5Ewat9wDlaEHUK//bQtAcb
         QsOh/+KPbEpSeAZrCatAG0NiLr9tSfj4kZQw38bzPh/5YBjqpxxJrgZ35h97IdVmAwvQ
         fgbY5HOzM6k2CmdSL1f4TgPwH/g2qjSS0S95w0Sr3jj92Sck15OoOWny8rtXHbG5iSlP
         gsvhZDMuqMTQelAcCP8sbwASpPPo5i1x84fH5lR+pwD5TCQHLC9+fxr0S5MRd7uE1c0I
         k6dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321228; x=1758926028;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oawoE6LRs/Nu1QjyiEx29qtiXpbR7RT6KFUgBZxZwV4=;
        b=jlfCUR6hdG+y5XsUdMNxq6eMfRQoWsr2QZoAIV2u4SnnPeQHc/bB+mYQvO6nuBCq93
         xXzF5gacnljEGfnmiRH42ZxoOCIG2Wtyo+1xU8ZCGCSF7YOyJ51gBrW2idplCq59XYvf
         SSa+bu3TpPQ/PRE+tzmOXeqm3edGBni9bVXjAMzUsbtVgmSTh5P1NMggjppuZqoeaw5b
         tQnICCSHPnqthU9mBGVLnd8I6Z6B0/oJ0rd2TUaacO0GvpMl+2GN8rS3u+0CgX9t/qh9
         fWM8MHe55MiCbb8Th6Bl23gCD9GK+llCI+meIHdQLO9i6JHh6DFLrbPgSg7HkMvxKI8u
         lwEA==
X-Gm-Message-State: AOJu0YzPJ9Nnc+A7/TJpCEhPYfX+db7cetgsM39AxKrDeyqdkn6mZVCP
	q8LKFr3yeyC5ZWex8zmteoPggFZ9wAtqLlviNzW8SkWRma/fXxbQGO4y2XgYPkAvIa2MGVUKlUx
	/lZ8azA==
X-Google-Smtp-Source: AGHT+IFK38KbNfStRa0r2xJb1UUQc4eKGeyf9ZN8JeCGEzXGI61Mb/D8u/wHGdl8K0ljHHIEwrJT9LOA6Js=
X-Received: from pjes22.prod.google.com ([2002:a17:90a:756:b0:330:acc9:302e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7d9d:b0:246:3a6:3e41
 with SMTP id adf61e73a8af0-2925a79eb77mr7834170637.6.1758321227737; Fri, 19
 Sep 2025 15:33:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:31 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-25-seanjc@google.com>
Subject: [PATCH v16 24/51] KVM: nVMX: Always forward XSAVES/XRSTORS exits from
 L2 to L1
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

Unconditionally forward XSAVES/XRSTORS VM-Exits from L2 to L1, as KVM
doesn't utilize the XSS-bitmap (KVM relies on controlling the XSS value
in hardware to prevent unauthorized access to XSAVES state).  KVM always
loads vmcs02 with vmcs12's bitmap, and so any exit _must_ be due to
vmcs12's XSS-bitmap.

Drop the comment about XSS never being non-zero in anticipation of
enabling CET_KERNEL and CET_USER support.

Opportunistically WARN if XSAVES is not enabled for L2, as the CPU is
supposed to generate #UD before checking the XSS-bitmap.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2156c9a854f4..846c07380eac 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6570,14 +6570,17 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
 		return nested_cpu_has2(vmcs12, SECONDARY_EXEC_WBINVD_EXITING);
 	case EXIT_REASON_XSETBV:
 		return true;
-	case EXIT_REASON_XSAVES: case EXIT_REASON_XRSTORS:
+	case EXIT_REASON_XSAVES:
+	case EXIT_REASON_XRSTORS:
 		/*
-		 * This should never happen, since it is not possible to
-		 * set XSS to a non-zero value---neither in L1 nor in L2.
-		 * If if it were, XSS would have to be checked against
-		 * the XSS exit bitmap in vmcs12.
+		 * Always forward XSAVES/XRSTORS to L1 as KVM doesn't utilize
+		 * XSS-bitmap, and always loads vmcs02 with vmcs12's XSS-bitmap
+		 * verbatim, i.e. any exit is due to L1's bitmap.  WARN if
+		 * XSAVES isn't enabled, as the CPU is supposed to inject #UD
+		 * in that case, before consulting the XSS-bitmap.
 		 */
-		return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENABLE_XSAVES);
+		WARN_ON_ONCE(!nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENABLE_XSAVES));
+		return true;
 	case EXIT_REASON_UMWAIT:
 	case EXIT_REASON_TPAUSE:
 		return nested_cpu_has2(vmcs12,
-- 
2.51.0.470.ga7dc726c21-goog


