Return-Path: <kvm+bounces-69474-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kPyKC1O2emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69474-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:22:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A38F8AAA48
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:22:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5F03430C0336
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:18:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2220034AB15;
	Thu, 29 Jan 2026 01:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ff/6Xpj+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98082346E75
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649376; cv=none; b=jP9sNF4OHPaSMVigkTbyvY/PIQY4h/WAc8S/m91cKMb+I86Iik/YWi6h5Uv3hR4e90dtIqvH7lh8GqrHcXT9RbR33xXON9ayKbrLB0Q8UhoG/+pQJqj7ETOUFhySGeEtwennUP/2P44c8AEZ9ZB9Z2wrQZID+AphrKnYDCyIquQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649376; c=relaxed/simple;
	bh=EJA7XKSAHRGSswQQXcHnUMuba3R8D9sqLu/XxynOWLo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VHN4DHJldFn0I4Fqcn1qSvxbTQ25cZ5ENG+gaFCZtK1zg7MEPe1kPov76PM53/g09lvtOVmHTGmK34jr+Tc3MwTlEAwkR7GDtVNdNW+nzGy/RIOHG1VdN8GBYVolaRSVcinZzvJSC9RelKz/MEW3ojUXYEM6/4AmfRW5pxxBKcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ff/6Xpj+; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-352c79abf36so319990a91.2
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649374; x=1770254174; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1krQa7Jk7W59zRdRjLWbI+ZDvWi8VJAVMG8mEFH1axA=;
        b=Ff/6Xpj+vVRGLtSWAW8NM97AymcBmXePAsKwwO0hZbU2oJ/1OwDq5niySedVhiZwQk
         r8MSPu5iYBixrJiFwKfu1fmo1LMpf33zVyMnQaTfV/mggyAqWYzMBQ5m7FDpFMwJFB/L
         An4AXuA5Gd6Xs6sb5oCgYnacYU/e0eMeVr5jBVTQ3LGSYZT9UPzEbXaW1iTG/xizgO2L
         t9ZLnGFoYxDC/v2tE9MjjbkmOObA9Z/nxrJOAmWvp1PZF2iNfjn6BORECmMRsjCIwQ1F
         LTKkGQfJRojtq9GrYvUpTCDWhDbKR0T62P4S/Ukjj+ENbl5IkfperRxg549Iy1YIIEIv
         Hj3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649374; x=1770254174;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1krQa7Jk7W59zRdRjLWbI+ZDvWi8VJAVMG8mEFH1axA=;
        b=CNsIAkoY3fpP7iziGfMs/iWC0cbsuqWvZPr7Beb2a+gDpBxm8s4x0nTC/riYKiFRNd
         WO+d/sD/MSIMqP7dmkUaSr9EaBoYDcB/Q1oAxCKlhQqayglGJHKfpzEfd9/FdqHb/Eqt
         NPE6rSUu7ZAo9GJvEl9WQd2NQmD75FnDrl3FbDFcGfg+xVX5hSeQgSybOm7kAQ3FhKYK
         A8cjXs3OqdTy+uVCE+0omgmxsFTYKEmMhBXNd7Gv++XFsVE/4e2OGrY1tuSZAJNXn9UG
         gbXFsh054TBVzI3x99ZCsFPxYmpYLkbpNcXZOiC9CHPFe730JBEbPAey0ZCJo4RxMvKt
         guIQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6Oq2bu7nSaM7o2svZOzulrDUEcBxqggxPpmOuG5U6brsssW+jokgkepKh7iVmoY9Sgwg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8iSn4BPLnEpHCNqSLrupwBgD9ATbbXl9GT58cyRj/AMlXG+Nw
	XTdpYIMZLPv9Of12tpjtN/wzuDCGG1B8kb4U0Ya9NW3XBiQh/3JNrR6K6lid4NVl/f0T6ShkJrr
	tEzpccw==
X-Received: from pjph21.prod.google.com ([2002:a17:90a:9c15:b0:352:c3aa:9e08])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:270e:b0:34a:b459:bd10
 with SMTP id 98e67ed59e1d1-353fed7104bmr6156493a91.24.1769649373991; Wed, 28
 Jan 2026 17:16:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:14:56 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-25-seanjc@google.com>
Subject: [RFC PATCH v5 24/45] Documentation/x86: Add documentation for TDX's
 Dynamic PAMT
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Kai Huang <kai.huang@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69474-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: A38F8AAA48
X-Rspamd-Action: no action

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Expand TDX documentation to include information on the Dynamic PAMT
feature.

The new section explains PAMT support in the TDX module and how Dynamic
PAMT affects the kernel memory use.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[Add feedback, update log]
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Tested-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/arch/x86/tdx.rst | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/arch/x86/tdx.rst b/Documentation/arch/x86/tdx.rst
index 61670e7df2f7..8d45d31fee29 100644
--- a/Documentation/arch/x86/tdx.rst
+++ b/Documentation/arch/x86/tdx.rst
@@ -99,6 +99,27 @@ initialize::
 
   [..] virt/tdx: module initialization failed ...
 
+Dynamic PAMT
+------------
+
+PAMT is memory that the TDX module needs to keep data about each page
+(think like struct page). It needs to handed to the TDX module for its
+exclusive use. For normal PAMT, this is installed when the TDX module
+is first loaded and comes to about 0.4% of system memory.
+
+Dynamic PAMT is a TDX feature that allows VMM to allocate part of the
+PAMT as needed (the parts for tracking 4KB size pages). The other page
+sizes (1GB and 2MB) are still allocated statically at the time of
+TDX module initialization. This reduces the amount of memory that TDX
+uses while TDs are not in use.
+
+When Dynamic PAMT is in use, dmesg shows it like:
+  [..] virt/tdx: Enable Dynamic PAMT
+  [..] virt/tdx: 10092 KB allocated for PAMT
+  [..] virt/tdx: module initialized
+
+Dynamic PAMT is enabled automatically if supported.
+
 TDX Interaction to Other Kernel Components
 ------------------------------------------
 
-- 
2.53.0.rc1.217.geba53bf80e-goog


