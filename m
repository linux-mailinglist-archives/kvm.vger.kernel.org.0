Return-Path: <kvm+bounces-67817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F1D44D1482A
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:48:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7D33330CE4F6
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:45:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9022230F556;
	Mon, 12 Jan 2026 17:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="woJbRchq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D999737F0EB
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768239952; cv=none; b=DwLf8VEKhlbkjWDsAX1mHcFLHdouNpnQI+FVl4TVhtbMXWpyRwRjCrJfcAGyWFloPpPX8CVoIdfxFTDFEJgRg1oGdawL324y0bfc30s8DQAjTHqcotyOPTiPMJMnHV/4nYxVifUJcOWsfAv2SV+pKlwD7vOYEpAf0w77fdF80Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768239952; c=relaxed/simple;
	bh=kp2jK6zr4mIn9+6tKF3+TyYc1ZCdNqo89o7bQOtSKw0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oOr5pPz+slpbEUmASlkTeN9BT9BMO7akfWfU/bE0qk0DF1ZgLXJLflV0bAjGT7ZLX+XPIdtSsD0fmJjXAbMYeEKN3NKVKlerm8hNQY6kY+Mct0NY0Sb9bown4KFSCLZsatWtFeY/E8xgy47UgRgkXCN79QQxkGyKikHmOHm6qJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=woJbRchq; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0d59f0198so72501355ad.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768239945; x=1768844745; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DtWYxGviUfVuSB56QpF39Fiy0UYOG6eTR6xOLrjXEgw=;
        b=woJbRchqesWJKbJEspbeUuyRsKhgImpkyWwLiI54NMBSa8toyDiVY8Sf3AYrkLTtWj
         pgBR2Ut0jUkiD9Q28/Ay+E8l/NQbHd08xZ4crz3CVCmCRmx0dmSQlJ9G9EBagmjw6UYt
         HPfR3MHTlN6+dPNRDsAgqoUnkahiV+XjkMPPpOUy9wKcXOAqOScJejS/JNRfyk9E+Dax
         pe+7qY10p00lhOKYqQnZ9kYW7b54qcfzfGP0i4LVT5+M/D5ZjUTQ1d0gnIzrHKSEq8Wg
         xA0dY7inh1NjAQ9DscZwDEuW3NxK9KhNvHxLglDTu1PVaJiyOuqM5fExNYIAzfrnNO22
         CQpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768239945; x=1768844745;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DtWYxGviUfVuSB56QpF39Fiy0UYOG6eTR6xOLrjXEgw=;
        b=a8vRsdiEgSko5s1RjFzpklB2lVV0srOcc73vr6oeTIfLuZZnM+EsR8/NGcbq45VFBs
         /KwlRUTtB/u3nMbzqZzeFjUAO1qDJokXqkzUPXFmaWhKB4PMJXxJ+CXZZGTTPjBWT2Rj
         SEQaDTbGb7ts2qfPxnnF5JFd1TEZQKQgqdPGANYtMC27NY8uTD2tqaljWFitAHt2ZTWp
         vvc3O+u7bnHOmB9XYIOP6/4CrWDakvHzPCbH8syElXFr/L/p7S2mcgoMqHbDI8GtcmOz
         natrmcSYNMCdNRFuYqezrgbr1L8odyno3xiu6u9KIWvtkzZMgoZAH52IAdsg8+VHNWnh
         Xx8w==
X-Gm-Message-State: AOJu0Yzzqd8NlLRSkyRiD0sjQEKNCqfDRPn9OMjsqOAq/JGutuh2gU5W
	0DWKJhpGHn3Kf1SYNoGh0OKBlOKtOjeIFNEmym072sLsYXU5WK8zpHxy2+Kp4UU37WUKtyORopF
	eM8iyRTswBoV6fg==
X-Google-Smtp-Source: AGHT+IFgF8FJPYnB7e+8ftCWYYaXPtH5JLdDI4hu+IyCGEqUJbhPdnq97S24ZckmQdHtVzXwLNoJ4pWTB+QNcQ==
X-Received: from pjbpm6.prod.google.com ([2002:a17:90b:3c46:b0:34a:c039:1428])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1dcd:b0:343:87b1:285 with SMTP id 98e67ed59e1d1-34f68c02239mr16322380a91.18.1768239944735;
 Mon, 12 Jan 2026 09:45:44 -0800 (PST)
Date: Mon, 12 Jan 2026 17:45:33 +0000
In-Reply-To: <20260112174535.3132800-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260112174535.3132800-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260112174535.3132800-4-chengkev@google.com>
Subject: [PATCH V2 3/5] KVM: SVM: Inject #UD for INVLPGA if EFER.SVME=0
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

INVLPGA should cause a #UD when EFER.SVME is not set. Add a check to
properly inject #UD when EFER.SVME=0.

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 arch/x86/kvm/svm/svm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 557c84a060fc6..92a2faff1ccc8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2306,6 +2306,9 @@ static int invlpga_interception(struct kvm_vcpu *vcpu)
 	gva_t gva = kvm_rax_read(vcpu);
 	u32 asid = kvm_rcx_read(vcpu);
 
+	if (nested_svm_check_permissions(vcpu))
+		return 1;
+
 	/* FIXME: Handle an address size prefix. */
 	if (!is_long_mode(vcpu))
 		gva = (u32)gva;
-- 
2.52.0.457.g6b5491de43-goog


