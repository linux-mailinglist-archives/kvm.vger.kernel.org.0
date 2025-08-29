Return-Path: <kvm+bounces-56214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D427B3AED9
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 02:09:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 065A0582D6F
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 00:09:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E75B6219A89;
	Fri, 29 Aug 2025 00:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fDvguf3x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C21C13AC1
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 00:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756425999; cv=none; b=R4C9pHr6Skbb1+QW3KxRy47tOuyUunvk5BwUG0TvlXPAZD/f0QRSaUcrse3VfzV2zUW6shDogInqT1LZzirFWIONWVPpRk1JjgIpqivWQ0l9/x5WAd2BWhSzGk4NHsDN331avyOkmO2jZ+bCaOI3jpsnyNVvFh9pE7gxK1A9zko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756425999; c=relaxed/simple;
	bh=f3WKeCxN8el5k5LrAboMphhH9rXooGmaPRmdkWif71U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o9z3/CXvkg9f+ymisSOMbDiFWxzBuMPDv8ZWDyf4ZvrE74JpzcZH8uof4eXQVQHlW3W5ZCQ6So1GOPboXdkeXfZu0aVuswjNQ8MR/N1h6mmNR7Melu67W531fVK8w5SHv74TL/SwYEojGv71ywdrsXO2fEhXDqZzxxTPHu9LKeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fDvguf3x; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b4c32f731e7so1168615a12.0
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 17:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756425997; x=1757030797; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4vFObST+7ZlqgxAzKSnwUtFLpnriAXTWXVO/mc38gG8=;
        b=fDvguf3xTaXUj/7eMva20CV20zom1ivQbtzX4XSrEczWsbaOvTIu748zZGfQz02Mrv
         3om5ov8zdIokmJUghjpJdxQEt+jcq5KZLtcs9ykQC2shCO22vCYIoYAq2ABDVq60lROW
         ghtBz+BcvWMNZuIRXeaHJxJondQJSRsKqe2/zNs8Nsr3zXtC8/7KoZSW8modSmNzYUFw
         H3qToRpGuqLV74vHee1ttymDZR1vEw3m5hpt/V5w6j1RXGnkTUOIU+eoNG5XBei5nfUJ
         2/I351mtQ9xWBV70129km/2NCtQ38KDt94ieCrF+Uc9yn9czyJ5H1j5XYbgivXFUhies
         If9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756425997; x=1757030797;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4vFObST+7ZlqgxAzKSnwUtFLpnriAXTWXVO/mc38gG8=;
        b=Xh67CaZEGxE5WB8lHrR5wtqc/9f22MjonkNDJNhGeIaFH++QXqiHxMFbySrKw0T7z3
         z2uGeZ7R+DO2ssYKcQpHOF7PVCORuQYd/lY0m3OGsuMjfT48LzXq8oXK0rN5EclxGGh6
         +PJStQNY+WGCxeB/QqzUr+k1yilQeFedHKPgoUjKtAV7PNzjOPnkM7HyUqtLGILl2bM1
         zNAyK3gmK7MmnqXPeHAm5RLPA+lqCXsK93N/Q3iVVlTtGrI/hbpoNk+mOhH98Kyjw92V
         CeI8Cgb29Ty1jUqh4suGHegslWYlJBuoNmYR+TTy3v5ue9WsRYociBkcgrci6O0qNSIP
         kQ7Q==
X-Gm-Message-State: AOJu0Yxdx1C8qu5H1oJtIcE4OF2B1e1GaCq0XskfYAD/bgO/sDQ3TPjJ
	JLKpKrDz4KXtDU9IzhhD4I6smJ1+ySxQIUbej/O/g1RvX0S7w2diUBCORxR2+GqA1fLmIsv4kCf
	6lIPotQ==
X-Google-Smtp-Source: AGHT+IEG9WztooY4bnn6abzlnsjj0dOg/1Kl7H1cw1QcQlPgDxUccZQ1mG0Culs2cO/x0pGpmGMyNJwe/+c=
X-Received: from pgww7.prod.google.com ([2002:a05:6a02:2c87:b0:b47:8e6:9c33])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7488:b0:243:9b05:ac7d
 with SMTP id adf61e73a8af0-2439b05b008mr14000596637.36.1756425997067; Thu, 28
 Aug 2025 17:06:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 28 Aug 2025 17:06:09 -0700
In-Reply-To: <20250829000618.351013-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829000618.351013-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
Message-ID: <20250829000618.351013-10-seanjc@google.com>
Subject: [RFC PATCH v2 09/18] KVM: TDX: Avoid a double-KVM_BUG_ON() in tdx_sept_zap_private_spte()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Return -EIO immediately from tdx_sept_zap_private_spte() if the number of
to-be-added pages underflows, so that the following "KVM_BUG_ON(err, kvm)"
isn't also triggered.  Isolating the check from the "is premap error"
if-statement will also allow adding a lockdep assertion that premap errors
are encountered if and only if slots_lock is held.

Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 07f9ad1fbfb6..cafd618ca43c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1724,8 +1724,10 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 		err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
 		tdx_no_vcpus_enter_stop(kvm);
 	}
-	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level) &&
-	    !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
+	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level)) {
+		if (KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm))
+			return -EIO;
+
 		atomic64_dec(&kvm_tdx->nr_premapped);
 		return 0;
 	}
-- 
2.51.0.318.gd7df087d1a-goog


