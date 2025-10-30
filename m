Return-Path: <kvm+bounces-61554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EFA41C22321
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 21:19:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EB091886ECA
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 20:17:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F15EA37DBC7;
	Thu, 30 Oct 2025 20:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ioCOFbnP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C0233E34B
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 20:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761855063; cv=none; b=HC8Hb6e2UMUumNbvoAXjMbasYWrS7yXS7L3d7Ms01/DC8hKYRdIRRcrfIN9gxWKLiGz7KnYA9e0YUSIWvYP0kUp6jWQsKR8TXoGiiIXwI1rmqBUA28dVLyWaIQqb+KjnRzxqOHh/OYXywODHVVTohJWczoTtwR92HoBTzPf/Tk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761855063; c=relaxed/simple;
	bh=dmFGy64Opu9Mkjf3vfnnmQEC763oF8Lj2ACAU4D9x+8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jog9SXyokw6tJj4yIwsTQRX+oKAxK3UyceGFF/XRQQGhDxwNcorz/aUUIT9mKikMaOKsYkkcvVSOiYrullan45DDI0xfYb/Al7hxSitJJ9NqyfvnCawDL95SUvIPkWwcwbdpddXq+rU5oQy8FTA+WqGCDJrUFy/gwS0tqQ+myUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ioCOFbnP; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29520b8e248so1196135ad.0
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 13:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761855061; x=1762459861; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pcGBUMDBt4QrK3gZ63mWxwFVf8xhoPzw9YjzqkGrLic=;
        b=ioCOFbnPjht5hMODgh5BDdCHoAWbcB6ldCqCu3+zwSLxeKmbSX5AWce7jNEaxbj3Wh
         OKxg2920qDhgK42yD4Lb7se8WyCxKEBOWId/u+jZTBSLpXvEsgPD+0AjNgu/0YZ8LBPK
         k8RTpkis2SAM6ILviLwkYaE9058lhf+wT+2DiAdL6rulK1LpGCC99INKDC+2G+NjBl63
         9n5hzdIBZCiBWY07L3E6UgBjlTmv+lF1/G/pXcRQ/4jK1FnBZaP+Ano6nJEx6h6z83OD
         umdPHHMhY5uuDBQzgjJCQjFUb0AuFlrDAjkJH5lRoLpaDyrc+iSswE6QIrlchk2pclxt
         GJ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761855061; x=1762459861;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pcGBUMDBt4QrK3gZ63mWxwFVf8xhoPzw9YjzqkGrLic=;
        b=d/fvT0F8Wvbj5uR3aPvSKp+xSUcPhkce6lrVS6bx6Y8LYBFNjCuIuHLvcs26umHjyx
         2svk6SgMq5p1s1JiXJ3k8WCEB7Kjjmie9+FMQfeg/awQHv0mwOM75RjfbwXbL7LT9CA6
         kLhKGJmO0X5nMH/P4w/efzij4I7WFGI92wkiU+ebJ2uYD0jtl2QS7eFWfUO2WsVoN0Ge
         KvSe0ha/eZUmc6TnkDRx4Xo1JXDuzKQpxbb3Tme3Zk7lXioTSFGTQitmNVN+2//M8fZS
         Ju5tHZzPYe+Ou8GWqUQAruC1P1hIxYU4q7zgvyUe6Pb1CqhfsUE3jORXJkPii+CzaPJu
         uZBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXM8iGFnFR9MsEIV/jqRTyI2wcjBO7V7VjoDl/Tfk2zbuIfmGPK6f3Mvd3glW28FW+eOH4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmkE2c9Xr9sfW4S2i7kn7Yz4sUKJMLuwWnB844WokvqXkeYcP1
	5o6PipPpDrM2i8s8wTN4yKrsdlRqSOGA3EP0A+Hy0tE6eysro4rWz+p3FC9/22MVemosxeYGRqy
	E5Qqdsg==
X-Google-Smtp-Source: AGHT+IE/OfQCQRYqXElzN+OeKvwnTKdqn8Aa5qkU15JwMNXReTeV5Yh/81ZcfUEIC9p/s1OTRodzv1oDE/0=
X-Received: from pjbms9.prod.google.com ([2002:a17:90b:2349:b0:33d:69cf:1f82])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c401:b0:295:21ac:3540
 with SMTP id d9443c01a7336-29521ac3a29mr3509295ad.33.1761855061339; Thu, 30
 Oct 2025 13:11:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 13:09:48 -0700
In-Reply-To: <20251030200951.3402865-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030200951.3402865-26-seanjc@google.com>
Subject: [PATCH v4 25/28] KVM: TDX: Don't copy "cmd" back to userspace for KVM_TDX_CAPABILITIES
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't copy the kvm_tdx_cmd structure back to userspace when handling
KVM_TDX_CAPABILITIES, as tdx_get_capabilities() doesn't modify hw_error or
any other fields.

Opportunistically hoist the call to tdx_get_capabilities() outside of the
kvm->lock critical section, as getting the capabilities doesn't touch the
VM in any way, e.g. doesn't even take @kvm.

Suggested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 037429964fd7..57dfddd2a6cf 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2806,12 +2806,12 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	if (r)
 		return r;
 
+	if (tdx_cmd.id == KVM_TDX_CAPABILITIES)
+		return tdx_get_capabilities(&tdx_cmd);
+
 	guard(mutex)(&kvm->lock);
 
 	switch (tdx_cmd.id) {
-	case KVM_TDX_CAPABILITIES:
-		r = tdx_get_capabilities(&tdx_cmd);
-		break;
 	case KVM_TDX_INIT_VM:
 		r = tdx_td_init(kvm, &tdx_cmd);
 		break;
-- 
2.51.1.930.gacf6e81ea2-goog


