Return-Path: <kvm+bounces-35142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 49863A09F31
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:21:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26A1E188CC84
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:21:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E239D20322;
	Sat, 11 Jan 2025 00:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GrrCx9Ns"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917479454
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736554830; cv=none; b=O44GmZ3NjmSgd2cFFnGMjITm3BYOEZ68unBpBdyaSxHhc4XL/UcFPpXKR9edoHmwnvJ/4Nm4UF9wHewVopdKw/wwdpkAs1cAuC7o0HE9SduP9WTaO1boHhPpOj27n3GQNzs4jGt1K3m6b1zhO6OX+ZFeSBtcbB6vS9e/L/jezQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736554830; c=relaxed/simple;
	bh=TPYIUhk66icLn4klFzPb+dLqocxeMl6d1T8cmhRTu/I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BG89Gv9pnOPBKTZsJBuFmlDivAOhURXSo/IGPOO1Ak08Zpa+IRlaQ3CiOuMOdD4CGkLpPc/2U6Tk/0tzjcMNbsr7u8CsPsHf1+nDiY52fgwqJjmdLJVj9Hmb49HEU6+0edb/hp1U67stBJEYZ/iw/9XiojpwnRTcNz7OMR5OYAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GrrCx9Ns; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21648ddd461so50546405ad.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:20:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736554828; x=1737159628; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=895F/8HOIoZ/1RnH4XNznGAUJfeM7NK0SPEGQvgpER8=;
        b=GrrCx9NsvhM8oo8APdth4Pd8sEjnkDyGQ9LaG+tqk2jn9zgnuUNkYeNZ4keEO9HXHG
         tshnaSH+WxWNDAC1jzlObwhRJhB5P4xf85z0FFeoGehs7bE95/wbaf3jdeqfio4vZHia
         SA7LinFBIQjf5JyA/uUx3IQcY4C0WF2z9YU/87vy8klX/zlbbSbiP9toeoURbP4EDYF6
         M5ubTtfu4K00DV2qWcyy4AuEJPwvJtaIYvOkPAif8CSDTL2iyOdzS7a0LJmL77uDKcEd
         Texddq4QwsHcgDBIf3OcLCRGD05bUGXxaFgAOb/krTeIT0dceD3nVRaJ/E4quxek7Yuc
         QoqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736554828; x=1737159628;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=895F/8HOIoZ/1RnH4XNznGAUJfeM7NK0SPEGQvgpER8=;
        b=rdt+nLga+pw1EkmkmipUaa6kzP4GTMzKJUNYdghV7wl4NxLe48AKXafA6L0Y/nualS
         Dk+Lz4hwocbdmun8ILPHFzKe8AISNkzD6eA9uT3e6oDKFDpcF3Q0AxE7KxloQYpl9NtS
         PQKOxqbsJbGodkXGAIjxzmRPqEuzkNBKGKLmGFz324TWtwzZ42sc48pyMW9uh4Ear49n
         OsyNhXkB0FmT/GwWubzkIbXPlGlCpFCH3hG6M6gbWWDIaMj6T2I7eF5dY4Oj6OR1L6pc
         TJL/qDRtu7EZbPNQU1jfCEFaiefy2Rg3maXFy9fWrZVQaPcDGNwqVXumN5287vtvyTIh
         GSJQ==
X-Gm-Message-State: AOJu0YzTdrxUeBfJTuf4TfJBibExYNts0jv1tnVJAX/HXxAJ7/2qprEe
	2l0qhT5CmI6b/PHm0k29WxUENBpS/osA5/X/wUwmAfFiEWCAVrx1I3xuwFoBp7FgTuc1v3nab4D
	4UA==
X-Google-Smtp-Source: AGHT+IHCA/ETl/3gcC8jDf9XvD+nlajF/u7s1VZSF3c8VsdM1o/ROmNiXPwd+PqoNaqHkoH9I4bjiYtp/o4=
X-Received: from pfbfa27.prod.google.com ([2002:a05:6a00:2d1b:b0:725:d033:af87])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:918d:b0:1e0:f05b:e727
 with SMTP id adf61e73a8af0-1e88d0e63a6mr20310025637.2.1736554827806; Fri, 10
 Jan 2025 16:20:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:20:19 -0800
In-Reply-To: <20250111002022.1230573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111002022.1230573-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111002022.1230573-3-seanjc@google.com>
Subject: [PATCH v2 2/5] KVM: Assert slots_lock is held when setting memory regions
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tao Su <tao1.su@linux.intel.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@de.ibm.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"

Add proper lockdep assertions in __kvm_set_memory_region() and
__x86_set_memory_region() instead of relying comments.

Opportunistically delete __kvm_set_memory_region()'s entire function
comment as the API doesn't allocate memory or select a gfn, and the
"mostly for framebuffers" comment hasn't been true for a very long time.

Cc: Tao Su <tao1.su@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c  |  3 ++-
 virt/kvm/kvm_main.c | 10 ++--------
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1b04092ec76a..a861287a67bd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12793,7 +12793,8 @@ void __user * __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	struct kvm_memory_slot *slot;
 
-	/* Called with kvm->slots_lock held.  */
+	lockdep_assert_held(&kvm->slots_lock);
+
 	if (WARN_ON(id >= KVM_MEM_SLOTS_NUM))
 		return ERR_PTR_USR(-EINVAL);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index eb3d0a385077..7d25b50cb298 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1926,14 +1926,6 @@ static bool kvm_check_memslot_overlap(struct kvm_memslots *slots, int id,
 	return false;
 }
 
-/*
- * Allocate some memory and give it an address in the guest physical address
- * space.
- *
- * Discontiguous memory is allowed, mostly for framebuffers.
- *
- * Must be called holding kvm->slots_lock for write.
- */
 int __kvm_set_memory_region(struct kvm *kvm,
 			    const struct kvm_userspace_memory_region2 *mem)
 {
@@ -1945,6 +1937,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	int as_id, id;
 	int r;
 
+	lockdep_assert_held(&kvm->slots_lock);
+
 	r = check_memory_region_flags(kvm, mem);
 	if (r)
 		return r;
-- 
2.47.1.613.gc27f4b7a9f-goog


