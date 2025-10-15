Return-Path: <kvm+bounces-60076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E1589BDEDE4
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 15:57:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EA7E04EFB39
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 13:57:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33B60946C;
	Wed, 15 Oct 2025 13:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R8yaAC/M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF336231A41
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 13:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760536659; cv=none; b=odwjIGrcCqfAmNGcsPg3SRNm/CbYGwoH2UtQOF+NuA983GqwvNwtB1mh+/YLxAg3tDyVn3BlsghP+nyQxwOkOzWRNVaDCDac7wvqjZkkI0F8NhOkZtFWL5Y0EQ+UA/3kk3Lgz3foNPgOrLlBlCkEw6jOqFJEunQIeFDWzaQcELI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760536659; c=relaxed/simple;
	bh=914YWKhORdAdREtonmghsM3z/MP7Mw+k1IVoaRAXaCI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i48wF+Bw4G51yeUgwB5jcFBNrOCPYLZd2jEvF1vS0XIMBTvLTwweHVhiEi0rp/dp19RiB5U/0u96sWZU21thsqgzMvprrxY4olGugR7dZmdBBlKq9vTB02z84Zh3uyDfyCNWbxVSyCbmDOndhMSlY6xB46bWipuV23lXMdDwbQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R8yaAC/M; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b67e14415dfso1745671a12.0
        for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 06:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760536657; x=1761141457; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qN/u3D1Ic2NfIT6zYQD+vHPHON5q0zRxCVjBfN7LZuE=;
        b=R8yaAC/MxgTA1fsrfoeliujYAK0ZKCX4Gj1NFFA+J9ApQUuvZrLLoZaBmTc9LWjzrU
         FjJBdhRrJEuV4yscFAHr+Y4cgevC1/Et4CIOivTd8KP1nZ4orKyHRgEWQZaPKdalwbYi
         fZph9fOQuo6l9HNr+a/pALcsW3y2yuZlQqTegqIKLM993HJ2m0ul0K36GU1HjgSc4b+R
         rVNeNRG/Uq5aRBlxLBjfR74ZlEblaDHT3IOSQRtJPR366gnYiGAG+GQuEhWA/kcgjOyD
         7jLi6Oj8NiiRBuuOU2Wpw1io4lUBTZiE7cFpmhJdrVNE/rC6AaPx1X9cTi//k4SXU3gJ
         IDng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760536657; x=1761141457;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qN/u3D1Ic2NfIT6zYQD+vHPHON5q0zRxCVjBfN7LZuE=;
        b=s7MwchZgjfIMGEPlZM+noAFeajrZzZlHO7N3ykT7RR254SuVrHCclpiazgVeZFMYNp
         skMqmBhCLyxVC/5adi9/tarFKKkHOHYu3JHCdME5YZ2VE/xFSwADiUE+873l02wJMtxE
         S056sMEJnVYPeQ9TFA+/AZWSjA+e47RFiN9Acz9ifirnQsB+3tEKKJrM1kxS6eyLmSiR
         BugvSV04kWqOUakE8dcBUbLMXLzsL4U0Rhd0x2QRNrt9qLqcjswITsBPAPDsw6nXMfaD
         4uWqugDw6qESfMpvYa7hJ9lMRaRpz5jPRbWHONne7yqchd3Swj0vQ2ooiaP3FPQ7ZZdx
         Ve6Q==
X-Forwarded-Encrypted: i=1; AJvYcCV1G4tD4m4OZl6Pz+fmEwVqkvwzPJbSr3IbjaQfx5tXx8mPZiMz7MCzNRpt3vnsVt/Br/M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaXo2ikYJaDf3EjNPBrtAAWT2rk/9l712um93yaM7hDv71+F1p
	lLEFpaKW+bjdCVIcoSsAdEbDVdf/WpoJtIBfpyOK3AEwSoYOC6oAxtOZ527VvFiQjrXJN78C58H
	a6cCg6A==
X-Google-Smtp-Source: AGHT+IEyIzQLWPhAYYB3gtJgp/BmJ24/oEbEbNVeRBVUNOIF4pnDsqkLncvGwTJJ1+Rn/DPUNhJxMmTiu40=
X-Received: from pjon8.prod.google.com ([2002:a17:90a:9288:b0:32e:b34b:92e8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b11:b0:330:7f80:bbd9
 with SMTP id 98e67ed59e1d1-33b5139a422mr36589740a91.31.1760536657007; Wed, 15
 Oct 2025 06:57:37 -0700 (PDT)
Date: Wed, 15 Oct 2025 06:57:35 -0700
In-Reply-To: <b12f4ba6-bf52-4378-a107-f519eb575281@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251014231042.1399849-1-seanjc@google.com> <b12f4ba6-bf52-4378-a107-f519eb575281@intel.com>
Message-ID: <aO-oTw_l9mU1blRo@google.com>
Subject: Re: [PATCH] KVM: VMX: Inject #UD if guest tries to execute SEAMCALL
 or TDCALL
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 15, 2025, Xiaoyao Li wrote:
> On 10/15/2025 7:10 AM, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 76271962cb70..f64a1eb241b6 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -6728,6 +6728,14 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
> >   	case EXIT_REASON_NOTIFY:
> >   		/* Notify VM exit is not exposed to L1 */
> >   		return false;
> > +	case EXIT_REASON_SEAMCALL:
> > +	case EXIT_REASON_TDCALL:
> > +		/*
> > +		 * SEAMCALL and TDCALL unconditionally VM-Exit, but aren't
> > +		 * virtualized by KVM for L1 hypervisors, i.e. L1 should
> > +		 * never want or expect such an exit.
> > +		 */
> 
> The i.e. part is confusing? It is exactly forwarding the EXITs to L1, while
> it says L1 should never want or expect such an exit.

Gah, the comment is right, the code is wrong.

/facepalm

I even tried to explicitly test this, but I put the TDCALL and SEAMCALL in L1
instead of L2.

diff --git a/tools/testing/selftests/kvm/x86/vmx_invalid_nested_guest_state.c b/tools/testing/selftests/kvm/x86/vmx_invalid_nested_guest_state.c
index a100ee5f0009..1d7ef7d2d381 100644
--- a/tools/testing/selftests/kvm/x86/vmx_invalid_nested_guest_state.c
+++ b/tools/testing/selftests/kvm/x86/vmx_invalid_nested_guest_state.c
@@ -23,11 +23,17 @@ static void l2_guest_code(void)
                     : : [port] "d" (ARBITRARY_IO_PORT) : "rax");
 }
 
+#define tdcall         ".byte 0x66,0x0f,0x01,0xcc"
+#define seamcall       ".byte 0x66,0x0f,0x01,0xcf"
+
 static void l1_guest_code(struct vmx_pages *vmx_pages)
 {
 #define L2_GUEST_STACK_SIZE 64
        unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 
+       TEST_ASSERT_EQ(kvm_asm_safe(tdcall), UD_VECTOR);
+       TEST_ASSERT_EQ(kvm_asm_safe(seamcall), UD_VECTOR);
+
        GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
        GUEST_ASSERT(load_vmcs(vmx_pages));
 

