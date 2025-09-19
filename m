Return-Path: <kvm+bounces-58269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CC1CEB8B88D
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:44:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B66E21CC25FF
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04B8A2D97A6;
	Fri, 19 Sep 2025 22:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m2ZhzMXN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0333064A0
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321261; cv=none; b=GcSXRbmqTl8Gmj3Jp9hkXudryI1XHb7YJtTY+r5Zu21anevNOn1ctyo8vIrlTaRGN7GbbXFJFVsVMOjBsjYl6lZ5aFqLtu81fkiUmJjZK+N/xyAs/YguiqhEujnB0H813MzZZPBJuN/jWyqb3QMIfA7aH1daLXCeBMw5voxhIZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321261; c=relaxed/simple;
	bh=CYruM6/nLA6BHSIVAXqcCI2n0dhqEb8nlIv2iRzLL/I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RzKd+Kmekv0SMME7IbEaEalF34u5AN5VXEitU3EJ6XomBxHkR27wUd8kmN7ZZqe8Fd+X8kO5MgEfdreIoIn9vrUJHn3ofFufqAXPpNASf7wHBBM7gBoK0nX0GSjW/9Oa2EAzQBvigXI/YtevafOedAGMGDlXyOqaTYCvj8VtQvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m2ZhzMXN; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32edda89a37so2552256a91.1
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321259; x=1758926059; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=v3/gIRcH16msBI7YOF0B/Y3P7fFolZGAQR2AF4CuYpQ=;
        b=m2ZhzMXNaXXOdK2+NX/JSpzmFGLN+8Uqlfv1yF9MSRs9/se4Ewft4HfPCpFx/TOo+W
         HLCJKjBtUoMPiMlpb7U2mvO7jkNNsbGmdg628kOMxfjC1ZZJFtWoNRRsAQ/ejfq+oBGJ
         PxDwKeTRi3o3GOJOdgaYsaUnSIH+xzt/U6PRtH0RVc+zktSLyyRTxlQjaPqPxTE0dmvu
         iNn6OPn0PZuW9sJyshWBNKjW2vbO/fNrUNEV6H7rfIZ4Vx0QUzHLyrHyWKgPqI5gVzB1
         uTrQy7qBejjQ6Qrj8HSeDwqSDu24HQQGzXd3LrWREOeUjPhGzblnFtO7zFsTdMM+eo4d
         9w9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321259; x=1758926059;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v3/gIRcH16msBI7YOF0B/Y3P7fFolZGAQR2AF4CuYpQ=;
        b=w1+85AuNDMqww2DOhzsmP7OAntQulUcL8DWJKKZ5aYo++cKJHXGiPsSgC4fltjx37s
         agHrj+bvC6inaN54Lto7MS5UFSY6s7uGnP0tJ3nlsPzCN6nJq3lr8dKippE9XyxhVhR3
         P2HGMgoT2S/C37W97OeRYY6YeFN+5wNR8l9xlcN4iqHWic4Y1Gy1nJh0tlGvBNZssV/c
         cGGPdgvH269sk4UYXIy+6QsTX/DEjLkrvBZXR0n1h73ukTkNji/kWopqrZfrq4lnTan1
         cwAHSChXWLZJSfCufZ2zdslvHzm08/c5M5gopo8BrHg636lSNPSBiwYOx+vgYit43Enp
         WjQQ==
X-Gm-Message-State: AOJu0Yzs7935kBeA0fp/bQYGZBuXFGU5KRCA6clHjdX092340hoNSU5I
	+8ZORqnH/X1xwfLD3eD6UxoK95Izbb02D06CiwEqz01ymcpZTCu4VTB1GYE/TFo1FMOvscsdlrp
	IyYUtZw==
X-Google-Smtp-Source: AGHT+IEpSlLooVqKUswOjccVv6JWUDP6SUs5HYzHzopl1fOGKza6IACwwFb/k/4itYpqFLBy5elmXgRTGmw=
X-Received: from pjes22.prod.google.com ([2002:a17:90a:756:b0:330:acc9:302c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3dc7:b0:32e:5cba:ae11
 with SMTP id 98e67ed59e1d1-3309836d2cemr5015556a91.28.1758321258948; Fri, 19
 Sep 2025 15:34:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:48 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-42-seanjc@google.com>
Subject: [PATCH v16 41/51] KVM: x86: Add human friendly formatting for #XM,
 and #VE
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

Add XM_VECTOR and VE_VECTOR pretty-printing for
trace_kvm_inj_exception().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/trace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 57d79fd31df0..06da19b370c5 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -461,8 +461,8 @@ TRACE_EVENT(kvm_inj_virq,
 
 #define kvm_trace_sym_exc						\
 	EXS(DE), EXS(DB), EXS(BP), EXS(OF), EXS(BR), EXS(UD), EXS(NM),	\
-	EXS(DF), EXS(TS), EXS(NP), EXS(SS), EXS(GP), EXS(PF),		\
-	EXS(MF), EXS(AC), EXS(MC)
+	EXS(DF), EXS(TS), EXS(NP), EXS(SS), EXS(GP), EXS(PF), EXS(MF),	\
+	EXS(AC), EXS(MC), EXS(XM), EXS(VE)
 
 /*
  * Tracepoint for kvm interrupt injection:
-- 
2.51.0.470.ga7dc726c21-goog


