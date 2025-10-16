Return-Path: <kvm+bounces-60214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 28998BE50A3
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 20:22:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A29A8359D5C
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 18:22:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6589226541;
	Thu, 16 Oct 2025 18:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DDFPWLE9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5557D23370F
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 18:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760638916; cv=none; b=tZx2am8BcB3GpcoLwZLE+vDdhYYh1C+uNxFWQXG/5IfLTOQAR72UgyMzXvvVpS5Xt2J6zIQh48Y2yb9gDRqmy7vhV6b+sN7p9CXopBmb8vyXG9vujkzdX7rUYRaAUPCsvifDEXadQ4cGBzfTXjzyOfQltybb272KYXUEKryTZkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760638916; c=relaxed/simple;
	bh=5E0C6i+nRm6fQLpXNiWJmnym7Onqera4NouEl8JYjVs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T2+wCl92RFQqZLp9QFH0spbrnKo8rU/FRUiZNgsDPREoe71UgSsYjhOSgEWXxMYROz6r1IOmaV2/zmGP1v1Ekue61Nc9Rq4kFZ+PjiOyhk71U1lJvUiJ59M2SGAcDJUk/0krgEhrueIX+YcpvzDgrja9JfmUyJF748Su91vTlJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DDFPWLE9; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-26983c4d708so9636725ad.3
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 11:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760638915; x=1761243715; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=dg+uTAFM7lbsn7WFz9CbnP/ajLiTUmOm0LwLzXdzdtE=;
        b=DDFPWLE9P74ecLSNE7DSPHOzLGwTdoG80kdDtSY3D5uWDVUFjkJmVnMaNg7HrF0766
         4q10AakPEociADNv0hiMCfjYN4oYbuHRVXFC/l9a87qYlq7JphgCx5a2gBkQgVQ0hLP/
         WezqzjE795hTpmlgJIMA+3SmvmqBKLmC98nkdyKusdP+Bp0MdZ3QFt++Q7AmJKNhzrni
         t3fhAI/E1TYYL4sMJwHlsVJjdhTLMK6bBbe8flDYjZUVY6sQUILdPsTkES/H061gksON
         oufwemDb0tgnchUsKY+QkmgZaHRQwf0hJ/nOw4hQe/bPmYA6orEfLzu7mrqiaLqocK4d
         U2AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760638915; x=1761243715;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dg+uTAFM7lbsn7WFz9CbnP/ajLiTUmOm0LwLzXdzdtE=;
        b=vfIjMC5OSozOWgSSIcWb32/y+mqxevGVM3uUrLJN/2BIwzqULJmCOzWLVBY1OgHMlq
         seSGU1/j3e0Crv5f6OSIGZcQPd9E0j8CVY2e9y+ZKa7Vwm65+6ipIEcXzb8UIrc2oLuZ
         WBhhsJ2VKMaGSHkjwXBR90TTCnd40Z1PPQ6dk6atGhFzDRYVrzVQAKKvbDE/ewerPXPd
         0JUrOlVjZ5le8/T48NbNx5o6kqpVO14JSe4ASj40fzKA2iP8jPkGsguRgC/oxvubKWWI
         JQaq40XGRLfMlgeLx26Ape+QiW9D7/7sb96XrrupRICEK+liQi1hKjqKwCNsJ0a0xpWj
         YVPw==
X-Gm-Message-State: AOJu0Yw1LBbqSCzbToeNtG6ylUNWgJea8IgRq8yw+uCLs3fdobET0Lg2
	c2qE/4gRRAFA9Y23FbNrZJTnT0JqGr64HwHaF3l/X7Ku5si97QDe2gVS59g+0nWKYSeuZTTYX5v
	eE2HWLw==
X-Google-Smtp-Source: AGHT+IHLX+JIJP/xpi0UAaW6TGcXgazhRaRJEBLzAroZBMicx8wFXjI+9H930mLGqANzA7DPXew0mwyUPZE=
X-Received: from plbmo5.prod.google.com ([2002:a17:903:a85:b0:290:b136:4f08])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:eccb:b0:276:842a:f9a7
 with SMTP id d9443c01a7336-290cba4db6emr10000875ad.57.1760638914703; Thu, 16
 Oct 2025 11:21:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 11:21:48 -0700
In-Reply-To: <20251016182148.69085-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016182148.69085-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016182148.69085-3-seanjc@google.com>
Subject: [PATCH v2 2/2] KVM: TDX: WARN if a SEAMCALL VM-Exit makes its way out
 to KVM
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Dan Williams <dan.j.williams@intel.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

WARN if KVM observes a SEAMCALL VM-Exit while running a TD guest, as the
TDX-Module is supposed to inject a #UD, per the "Unconditionally Blocked
Instructions" section of the TDX-Module base specification.

Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 097304bf1e1d..ffcfe95f224f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2148,6 +2148,9 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 		 * - If it's not an MSMI, no need to do anything here.
 		 */
 		return 1;
+	case EXIT_REASON_SEAMCALL:
+		WARN_ON_ONCE(1);
+		break;
 	default:
 		break;
 	}
-- 
2.51.0.858.gf9c4a03a3a-goog


