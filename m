Return-Path: <kvm+bounces-38239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AD2A3A36ABB
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:16:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 053831896421
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57CC074E09;
	Sat, 15 Feb 2025 01:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZmQvAmy6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14ECB1514CC
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739582086; cv=none; b=G9iWhoM3cWRhwrXyXXJlX19NLgOB619U1BX2T+VKwM3g1y9mtL1hqokUgSxrs6rK+jsCLOaduBk7D8a+l/RafdF06pmhljUkdfQEvfG5rsm0NBPNvfflreBqOJuma7Dj7S1RRYLuJ94EYxWZHY3eB/N01l3/FeypquI0eDpr+hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739582086; c=relaxed/simple;
	bh=Nq45uqSKHEPg4dzpAAVHI0Nbkbth2NKJarH67mwYrqw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BfHE6bdpjW8oeydBgwBrBMAa/mDNimSnRvMDqnYtXP1mhe08kk36QuOdSve62eRvX81KPYau0gds2RXOLSHgV8wILNFq126+3cUFg660dVwFslTYQwOnDyglZf9gt+Af5m5u83U4cad7mu4uyoPL6Q2IBDOnOoVrbgFs5lzScPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZmQvAmy6; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc318bd470so2657809a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739582084; x=1740186884; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=6j/gglXJS1yN/9vw2FthXhPcheEiRDBsR2pbz8PXCNU=;
        b=ZmQvAmy6oVbzJNNwxqGkJh2wH+/p+6/WNgY+os8wZiVBuwL2jTlyen8C0Ya4W4dKfJ
         MQO+28RdiVXLZUBtUDefqx8KCG4ZyL5OPKWSjnS23gtS5QZBbCGnVXLWTq45krMqn/GF
         oRxyELLtllONZJ1U6u3sBs5Ax3zOqsKbuA6ySMlGM+f660Me3PB1O6c24PpsZAIMJ4DA
         vPQXHrqMaWLDRiocl3J5l6GaJBRmmMDz6dvI1w3uBNsffeNdPDFzdmLEwax7KPOdz/bs
         1SRMn6R5KQEJKLp920EY5IbJYmxKf+r59hXw+uaaQCsIVtgfd0rbB0qcmlBvi6aZIFde
         aDQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739582084; x=1740186884;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6j/gglXJS1yN/9vw2FthXhPcheEiRDBsR2pbz8PXCNU=;
        b=pOD/M3BD17KyaJKLzCXsWAImrCAqO81DbMFGknYWQILqV44agYB2kWX7YZjZah19+C
         cbDIB5jlKQXDmZeK5mu6+Olod2ZqodL+K1E0Q4TKIC9927uFDPtPl0VuON/A5gZumYJM
         zFy2tQoAORORETl7F2tVTeVcWT2plbKQNnKmu74pk7mGIIoB/eE/Up6MoIF8YZ/QOi0R
         JftDWq/CJV/fH5tW/2SSQ9U/YE7ecwdrzjilMp2BDh09CVBM6WyO/l/hKzsP3oO0zGoQ
         ACSDyJUY/KpZsb0YIXVXqTpG9xWbpEkaYoX1h03Epnzc+Akcda54tmXIvyWSHHlg5Pch
         zubw==
X-Gm-Message-State: AOJu0YxiE3iMzIKhrHDDEd6+pxW8yUNxKV8BlqXzssztEYNbIyjoHlZs
	6rAxdk7PzpXDSYiRoxvxYkV2JtDu+Z/6zOlnT+htqP456j1LV5Ae7/mZTh0wRBvIRr+h94dgNoC
	TRQ==
X-Google-Smtp-Source: AGHT+IHDz0saxK+uDPiFg1p1YwHS66b4lZqXWidBMXMNqLNQVQfSJrHTu3y8P9oy8wEHlGtCW8YLz5mUoCk=
X-Received: from pjbsi4.prod.google.com ([2002:a17:90b:5284:b0:2ee:53fe:d0fc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f06:b0:2fc:3264:3667
 with SMTP id 98e67ed59e1d1-2fc40d131bemr1894760a91.1.1739582084469; Fri, 14
 Feb 2025 17:14:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:14:35 -0800
In-Reply-To: <20250215011437.1203084-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215011437.1203084-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215011437.1203084-4-seanjc@google.com>
Subject: [PATCH v2 3/5] KVM: x86/xen: Consult kvm_xen_enabled when checking
 for Xen MSR writes
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Joao Martins <joao.m.martins@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"

Query kvm_xen_enabled when detecting writes to the Xen hypercall page MSR
so that the check is optimized away in the likely scenario that Xen isn't
enabled for the VM.

Deliberately open code the check instead of using kvm_xen_msr_enabled() in
order to avoid a double load of xen_hvm_config.msr (which is admittedly
rather pointless given the widespread lack of READ_ONCE() usage on the
plethora of vCPU-scoped accesses to kvm->arch.xen state).

No functional change intended.

Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/xen.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index e92e06926f76..1e3a913dfb94 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -58,6 +58,9 @@ static inline bool kvm_xen_msr_enabled(struct kvm *kvm)
 
 static inline bool kvm_xen_is_hypercall_page_msr(struct kvm *kvm, u32 msr)
 {
+	if (!static_branch_unlikely(&kvm_xen_enabled.key))
+		return false;
+
 	return msr && msr == kvm->arch.xen_hvm_config.msr;
 }
 
-- 
2.48.1.601.g30ceb7b040-goog


