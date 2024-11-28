Return-Path: <kvm+bounces-32686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFC589DB10B
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:43:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3F245B25FC8
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:43:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEE6B1C0DED;
	Thu, 28 Nov 2024 01:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="myU7Zt4J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6763E1BDAAA
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757734; cv=none; b=JgF5T9d/LcXVC3gpDGXTzHGGDGJmJnGRbxww+jjWTKcgy01W/Chyxg34IirTTZXVIl8v/w/J/L5gIup4ttGrtNQWcKzXm8+9QVtgPwpE3AXJyVAvhRuV4mytXS7o/n5QkOE8aPG4G0NDgggI4NcgwLYcgJt0G6YIl7nHtAXxAYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757734; c=relaxed/simple;
	bh=dmANShCgt8TBaYCJdM9bvuNmFYoQV0bXx+2YV2AZHIY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GCI5+WNfvhy+8dgJ4PdfZ05Bpx8ydf0RmwNIMepHVTzlAKQ7UPVDcZpdfm867RTxF6aEDuG4NKyfIp2fQx4c21UlonjlTF/yXI5wXoQ0AQfnpg+HJmWlyXwGTm5N0WMbVJvCNfzJrhoxRa33dp7mrxvdb0tSEoh0/wf5ZR/Crpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=myU7Zt4J; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea33ae82efso362470a91.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:35:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757733; x=1733362533; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=d27fglAEZdmCFt7lZZWr0B6WUdudB3vEjO/vTpHdmOI=;
        b=myU7Zt4JPtvLg5f4HXY4JvSmGVA0hBshJV0A6kYJE8C6L19DEaUqcTwE0PuNJKfIrj
         h2cxc56ab1syygdvgst7j9q4H2EDSM3a6uUC9UcrrfNlS2nvazUwWEZmquI4gXo9qj9N
         1agnPgJYnKgB01Iu7NMJr8ZcwWUUt4O4NlN1Y6QYVqRT+U+ruzWHR4MJVmkdqgYv+Imi
         zp4DvUn+V3KVQzPgOoh4lILxgJUtzZ3Absrl39GcYjFEzPhaFb82ihkNOmyLl+WSZvjm
         q0YDSajhFualvXlM+asigZyoj4cuTyPbhe8AV2PK9l0QpP7AyxozWRK3h4UplB61OEco
         r/+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757733; x=1733362533;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d27fglAEZdmCFt7lZZWr0B6WUdudB3vEjO/vTpHdmOI=;
        b=QxD9l4m3ksXQIj3qdAXGeT5CCgTgpJ7JEBvC+P0yZixiXotk1AXBKNOexdwh+y3rgU
         XrY+eLWUM2gqG8iJEcZqQ0HJzihUHPBuyH1bJ4dKUnH2LtW2IGRg5fO/KXGQYvgxepr5
         RDh7A0uKsRUsF9yBgVN+UjoEhbiZD3OJ0nf6u/nebeKytIqZdhJ20CaI3TJlvk+d7q+m
         alVCYdMQmAE9bWaSqQOdrIcp0v21u6SA3uX35u6hNg+UUEnScCXmWXPzfXcQJRDhVr0H
         qkbPFCJVyB4nVQ8iWGJPC/Fgocs6lHKx3hfH2mCs4aZ1LFg1t8Noh+l/nFqQBO2aUHF8
         RV1A==
X-Gm-Message-State: AOJu0Yz9xEwlFUymYwpVbtFBKEQ0taHkPqa76iheMIT5btuJVYhx2dFP
	T0a6Wv+vYXWQhe9b01RAcXPXn0LBVVHrKOPrKhcyR8g3Bfy3c7MZXYqEL/nM/yjJ2lmiEPgNieu
	THQ==
X-Google-Smtp-Source: AGHT+IGnxVUWBO7YupB29jJ/tSdtlBsbs6lN4f+B3+fX3YxFu7CEBseh4FCdW27RJ5F2vsaKMBwJEbVHbjk=
X-Received: from pjbsp6.prod.google.com ([2002:a17:90b:52c6:b0:2ea:5dea:eafa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c87:b0:2ea:3aeb:ecca
 with SMTP id 98e67ed59e1d1-2ee097c2965mr6144095a91.31.1732757732886; Wed, 27
 Nov 2024 17:35:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:34:02 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-36-seanjc@google.com>
Subject: [PATCH v3 35/57] KVM: x86: Move kvm_find_cpuid_entry{,_index}() up
 near cpuid_entry2_find()
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

Move kvm_find_cpuid_entry{,_index}() "up" in cpuid.c so that they are
colocated with cpuid_entry2_find(), e.g. to make it easier to see the
effective guts of the helpers without having to bounce around cpuid.c.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index af5c66408c78..fb9c105714e9 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -121,6 +121,20 @@ static struct kvm_cpuid_entry2 *cpuid_entry2_find(struct kvm_vcpu *vcpu,
 	return NULL;
 }
 
+struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
+						    u32 function, u32 index)
+{
+	return cpuid_entry2_find(vcpu, function, index);
+}
+EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry_index);
+
+struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
+					      u32 function)
+{
+	return cpuid_entry2_find(vcpu, function, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
+}
+EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
+
 static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
@@ -1735,20 +1749,6 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 	return r;
 }
 
-struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
-						    u32 function, u32 index)
-{
-	return cpuid_entry2_find(vcpu, function, index);
-}
-EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry_index);
-
-struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
-					      u32 function)
-{
-	return cpuid_entry2_find(vcpu, function, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
-}
-EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
-
 /*
  * Intel CPUID semantics treats any query for an out-of-range leaf as if the
  * highest basic leaf (i.e. CPUID.0H:EAX) were requested.  AMD CPUID semantics
-- 
2.47.0.338.g60cca15819-goog


