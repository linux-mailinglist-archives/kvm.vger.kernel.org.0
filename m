Return-Path: <kvm+bounces-32652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E0F29DB0C4
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:34:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E781281DA1
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:34:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0EEE51C5A;
	Thu, 28 Nov 2024 01:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4C3zKq/e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D62F2E628
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757675; cv=none; b=BaQma0vtPxJ8W2EEe0+OYV6qtWp9JpIUdPyvpLzhHe1UFACrxzXeaNDDjyfai+SoMlT2uJZhJp/BI49fT94i2zuv7XiXynch/merxxKCPXhbPz+3DSj5M0xOVgAjodWP6w53KU6fvzqjevJoRq4vrsG5vNs7H5RQzvz1YuThQVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757675; c=relaxed/simple;
	bh=qUOOQRdxqzW0iWtWBhZyxD40r+KxBbQyVzxJr0TNPM8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QTN9jr+cNQHRWrQFCxRZ29e4aJ2yTDguzS8h9BShYki5+UWk3QYEqJ08tKblBUJUJr8cf3OBnhMQ2OLwTYK7qzBtLiyB2LKGKAQgPv1L3dg1CSxDjYeWtu2kpYK0nt0mBnJH1OHP6lJv44i1lSM7SJf3FUqUqgfGrarXtDtWooc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4C3zKq/e; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2eaef95f0d8so442344a91.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757674; x=1733362474; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8PwmW/45ueQJahzHJJm7h5RjQBp4aZ3CpfBvMjYYokI=;
        b=4C3zKq/eL8aNPiGlFpon+1a7IxPxMNZtRN5E4LhXA/A99YMJU50nPSeh+Zy+CUsIMB
         8/GTHMcPH/DCcKPbCcbE/V6vYwMSXTnUD+5vZlu5+E1Y9X3KfLVudNXZl0pf/rgrEEGe
         FJ5PDtV7Y690RD66ezgHlhOK+PFRKJZeMRK3P6hk/3sw8npIYlVvI3c5RZyvk4qMEpN3
         3XbPfiMxfqlV2OIBjc1ZyEBYgrfQ7L1W6oz+LSgaFVJDpK3PO/Iar/FiohsDh4fsOjh6
         GvVj0ZKdM06n67tF/ahUpGGnXJN7bXqMf+qZLlcPBWdxGA0OGryUdFzWAzsbndjkgX/t
         eznA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757674; x=1733362474;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8PwmW/45ueQJahzHJJm7h5RjQBp4aZ3CpfBvMjYYokI=;
        b=toMjR532SIZpZh9Zrh659lHfkgnqKgKaMAxkdZzT7el2lx3/Zk+ojNj+H9e7vSmeGw
         +X7xDhXmcaVMUFxsTngCTflkh7Ta409CfsnEZYHXCOowOBK5pKVbt252U1b/mmtsh7FX
         yuJFXxbHAV6UGpTQRoPmQsGYlGvTM08O6T5xeumwD/3bcE9zcaL/zfnx6RznQXLyJP7c
         H/habRvWK/7VB84bHaRrU7SzAPhzn5GddaHnJ3cXho94uBc6HdWEihCS3a/0ebUr76aJ
         J41wPNoMjw/yw7ln4LUcgr5BEfBUYy/NQxtkQ/SsIAM9aO/uqvBEE/7sipr5piYtQcLA
         3amg==
X-Gm-Message-State: AOJu0Ywx73+sgnW237TJJbqNUq1AsJG/4x8iZoyMFgMbzQ+8c4yi4Q9Z
	dEO1nxPLuMJ2NQqMDVlPuTySB0xovXLL9iOy78NLSVunQ0G3N2FvOxWK2aipK+jRS4OpDhEanGF
	TRw==
X-Google-Smtp-Source: AGHT+IHpXO85otaKd+k0LVF4CVKFisDTeercgU4ixevU+UUIJ0Tx7jcVkyEwl+8jlB2oryYpavN1dvJ2J/A=
X-Received: from pjbqj4.prod.google.com ([2002:a17:90b:28c4:b0:2ea:839b:bb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:35c9:b0:2ea:77d9:6345
 with SMTP id 98e67ed59e1d1-2ee08ed4430mr5846693a91.22.1732757673761; Wed, 27
 Nov 2024 17:34:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:28 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-2-seanjc@google.com>
Subject: [PATCH v3 01/57] KVM: x86: Use feature_bit() to clear CONSTANT_TSC
 when emulating CPUID
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

When clearing CONSTANT_TSC during CPUID emulation due to a Hyper-V quirk,
use feature_bit() instead of SF() to ensure the bit is actually cleared.
SF() evaluates to zero if the _host_ doesn't support the feature.  I.e.
KVM could keep the bit set if userspace advertised CONSTANT_TSC despite
it not being supported in hardware.

Note, translating from a scattered feature to a the hardware version is
done by __feature_translate(), not SF().  The sole purpose of SF() is to
check kernel support for the scattered feature, *before* translation.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 097bdc022d0f..776f24408fa3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1630,7 +1630,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 				*ebx &= ~(F(RTM) | F(HLE));
 		} else if (function == 0x80000007) {
 			if (kvm_hv_invtsc_suppressed(vcpu))
-				*edx &= ~SF(CONSTANT_TSC);
+				*edx &= ~feature_bit(CONSTANT_TSC);
 		}
 	} else {
 		*eax = *ebx = *ecx = *edx = 0;
-- 
2.47.0.338.g60cca15819-goog


