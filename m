Return-Path: <kvm+bounces-35612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04F56A131D1
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 04:50:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02B7C3A5E24
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 03:50:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32F4113C914;
	Thu, 16 Jan 2025 03:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EzSiDSDX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C508345005
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 03:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736999412; cv=none; b=TEBIWjqDphm8hQ2JEODFib8HaAM3qPRkJAOz9g7U7KsBAxlhmYMqWUabHtTbhUdnv1hBN7DuBVUG2WdEjVWNwWhk98Jo7Ky5tYcN98aoHhJi9/fK3gVRE+NBIdRvsWJTEoNHrVIopgTwoubn8rLrMZLnFm53zjwzKnsAtEZ2xSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736999412; c=relaxed/simple;
	bh=7q1yUP629ObLLLXqGGHHOtjDzmse1+f1ChpkEVcC+1E=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=sLidRwmpW03Ld+jlGatTG1U2hUuny1wp0D4qd3esVO1NoZHZg+8/JmKLALWE2w4Mf0qs9186udmceDYiGvIu4PJMJDYj3LTshweQj51VqXdEDmKUbiNpef/3KdI0r9i/uoXEWQabZKfS2oBhFG2Qvh9jjczoTzIdxc7mLOSEjEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--yosryahmed.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EzSiDSDX; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--yosryahmed.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2efa74481fdso1106061a91.1
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 19:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736999410; x=1737604210; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=W4sXeDICrV0cm0i67qgUPrVWuOlwpzyLRiBHpod7GZU=;
        b=EzSiDSDX3yIhJXT1WpYyDdYJjxYsM/9FwtKWH7+25XRWH2cYrsfnu90Wc0UcvK2m4+
         fCGsXX5k/ZJxr58I9Klbssybb1lc9F/PDN+SHpvL3MfpbJit/wmynQ/H9SElXo/Gir3w
         osIGe67dl4yVg38iGba0Ueazfpz9N/AIXD0oEJVVqzE+TkMTN6FANDH/BI17DQRXszQZ
         hMiH+X47HO0aR10fVL0W6+j+qW0vK+DfCn98oi6E4WW2qG06uzdAwfYuO6mshQ7KdlWK
         Oi+T8d2IHY7mpcPJ9sXGPA2PTu6Bry/2Hn14o1rDCec3q15FG2L8w2xKgKJXtpURv1QU
         ntJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736999410; x=1737604210;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W4sXeDICrV0cm0i67qgUPrVWuOlwpzyLRiBHpod7GZU=;
        b=MEhiFeTE/N0O+FZuLspbeX9PyFSfeEozvGBDMsiDXTHbxjhLk+7ju5fOcewZ/+V2K3
         WrmelkHXjRNu+6ayH0Og1r+fWRktaoJby+onAD0OKkw8omDFBa7kdsPA9KE93cHP4nbs
         E2rzXdyzEYEwTqWUlkbk0vPiCXKZIyxdNpdvsN0dkf3LDP/ksjfLYElK/Z+x97Pwo9EQ
         8qc7ziz2bP0aE/0E7wIojvvNRmRQxhRwPxsxNBnrLxipZnV3KgZzv2Sz3Bs+fommXtAf
         /VSLbcdH7+Gq88hKY1zkPS4CgAXrhnV5x5BuOo1Bp447A6KYDDS+j4m5fQywm266sRYn
         O+Ug==
X-Forwarded-Encrypted: i=1; AJvYcCV3s5krcjAuLeu/MzSnI8euWLOK2ZTA/4K1VvLKz8HrLDPhYIqivr5jNXdSapftuORemnA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGpP9RyYB6nDDd2NnnTfI/I5Nilzjim+t8CNDsR3JEdxtQk+Em
	vINZVjwHxYARcAJ0uqtw/Tp36inSprOJ5l84oqh4VI7N++4ez3pmf2HYEcJlUL2Of+o3Pz4Y1Z/
	UOtlM+Q6A5Crta3jJDg==
X-Google-Smtp-Source: AGHT+IGEObInsqWnbwb4eyr+laMG+KXi1mpj0zN6BUCFzwBKKGEEkzjBRUWr9lFtmrA9hQikZ/S8kv4x0NNw2dz4
X-Received: from pjyd12.prod.google.com ([2002:a17:90a:dfcc:b0:2ef:8f54:4254])
 (user=yosryahmed job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2e0b:b0:2ee:ab29:1a57 with SMTP id 98e67ed59e1d1-2f548e9a5b7mr47382689a91.2.1736999410220;
 Wed, 15 Jan 2025 19:50:10 -0800 (PST)
Date: Thu, 16 Jan 2025 03:50:08 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250116035008.43404-1-yosryahmed@google.com>
Subject: [PATCH] KVM: nVMX: Always use TLB_FLUSH_GUEST for nested VM-Enter/VM-Exit
From: Yosry Ahmed <yosryahmed@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"

nested_vmx_transition_tlb_flush() uses KVM_REQ_TLB_FLUSH_CURRENT to
flush the TLB if VPID is enabled for both L1 and L2, but they still
share the TLB tag. This happens if EPT is disabled and KVM fails to
allocate a VPID for L2, so both the EPTP and VPID are shared between L1
and L2.

Interestingly, nested_vmx_transition_tlb_flush() uses
KVM_REQ_TLB_FLUSH_GUEST to flush the TLB for all other cases where a
flush is required.

Taking a close look at vmx_flush_tlb_guest() and
vmx_flush_tlb_current(), the main differences are:
(a) vmx_flush_tlb_current() is a noop if the KVM MMU is invalid.
(b) vmx_flush_tlb_current() uses INVEPT if EPT is enabled (instead of
INVVPID) to flush the guest-physical mappings as well as combined
mappings.

The check in (a) is seemingly an optimization, and there should not be
any TLB entries for L1 anyway if the KVM MMU is invalid. Not having this
check in vmx_flush_tlb_guest() is not a fundamental difference, and it
can be added there separately if needed.

The difference in (b) is irrelevant in this case, because EPT being
enabled for L1 means that its TLB tags are tagged with EPTP and cannot
be used by L2 (regardless of whether or not EPT is enabled for L2).

Use KVM_REQ_TLB_FLUSH_GUEST in this case in
nested_vmx_transition_tlb_flush() for consistency. This arguably makes
more sense conceptually too -- L1 and L2 cannot share the TLB tag for
guest-physical translations, so only flushing linear and combined
translations (i.e. guest-generated translations) is needed.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---

I tested this by running all selftests that have "nested" in their name
(and not svm). I was tempted to run KVM-unit-tests in an L1 guest but I
convinced myself it's prompted by the change :)

---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index aa78b6f38dfef..2ed454186e59c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1241,7 +1241,7 @@ static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
 	 * as the effective ASID is common to both L1 and L2.
 	 */
 	if (!nested_has_guest_tlb_tag(vcpu))
-		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
+		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
 }
 
 static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)
-- 
2.48.0.rc2.279.g1de40edade-goog


