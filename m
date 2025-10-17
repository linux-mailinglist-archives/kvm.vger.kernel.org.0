Return-Path: <kvm+bounces-60358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CCB32BEB0FA
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 19:25:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F385C4E5698
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 17:25:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D533305E26;
	Fri, 17 Oct 2025 17:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iXdyYkAC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477BD302CBD
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 17:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760721926; cv=none; b=e61f0qcwA2TnysTsucipy4ySheKd6P/q0osoWKEq0oqyqqJAx9/g/jvKtX/NLByb9kb5LFL5jfFAyPeME+R99BqJpjJMknn+u4isk25Au8egauC9SnnbQ2HCxAYub3ogq/uj7fEcBkUq85cjE1MAiLj8CylmyXsNmiz7SZlZntk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760721926; c=relaxed/simple;
	bh=/u6Jj/K3X377HoMDRDTQUL339ASOgHeTN5C+ZSo8+2I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fo7Tyk+ayx3/19NNF7FzaM9fG0FjRtD553muN+LFwz7/ZrrfSJL+61Rj2d6FjhfZUuEGdlzYqto7mmWkkpl4Z38GFMPI3nJXl+f4JZlWJNANwZcQQtp6tt1Uxvsw+FKWIcfbN6uIvanzatLypENowlpaW8CLVSHS2WjSx00yPuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iXdyYkAC; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-28a5b8b12bbso47345055ad.2
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 10:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760721925; x=1761326725; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0sq+f9rcJxZK92I68akrKLlI6rzfeTYAt1+/TrDWouI=;
        b=iXdyYkACGVHPrwLXRc/8s89TuDS2GA35h/sh0F4oqcODGT00LUwEq4PlwUK1tqjmdz
         8hrfp8VjU/JGT52hZhpiCSp6l7aTpcne/b+hRD5eqZ0qx6eWZckLKAzTO9jaA4sIdw1F
         DQ/yB4kmKbFAI1yxFVLVrfLoyVEyvZ5Ce4t4cpmZUYPbjgKLpLjz3PamOu2AUSX1m6xg
         Z4FND7+r7H8ahoDnfV27ZaroZbxYPEAfzODIPf9Uuk5Gr6epa0ZyASi507+Wo2iHDbBS
         Y5hBnR1CuHb52jK00Aj+7AP9zBngp5rLmRZvuwZrs5xKBCZKrbA+y3ulb/1CtQtPDebB
         tAhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760721925; x=1761326725;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0sq+f9rcJxZK92I68akrKLlI6rzfeTYAt1+/TrDWouI=;
        b=G0PhOseveKiuWRzpyQgWUy/FZDxA9nBgtQ8eHgvZQZxZqfpltJQzX4YgaHG+1nB6UJ
         KFx++5NJzBOiAaE3aJDTae1fIc4b+6hxGyOwJHmHh958uZASMMER1EBmFYxA8+oJ6kJ4
         ox6L/Mjm8XyamUIZir18n3bPZIE4Mn2ePJrHPOY9O2bJrQKVGe+ak4/Kjt9gglo/VKk1
         VcNX2D/mgUtkIS4Mgzrgyy5v0rhOx8JnBdgQIdnfxDbAXTncZ+auPr03lEAi89DQpdnN
         XEe8zT05B8EVkWK+HUdBQFCdK42puW2yIQt+4SWTiKsiCst1n+ShIL+V1+nxWPQqEU7x
         yRqA==
X-Forwarded-Encrypted: i=1; AJvYcCWjkgAttjEe5y861oC4F+29BfMKztrk5q1DLLhob62i9BZ/hm53B22EHK9ADDaJ3V+xFso=@vger.kernel.org
X-Gm-Message-State: AOJu0YwccVBkpEWhede83ZdtOXKgZqV4VXmuxVOOrASeYLx28uIGDiIH
	JwLo0PYedoW4qC9rea0fjMIQvVyuBTQQ4e+Y+vExx3Lk82p+AroF9oyQEbu2VRvt8CDARvhzPcH
	cwFYcBg==
X-Google-Smtp-Source: AGHT+IFgsZ+PT6XKCcMr8esc9OEt26E9mJR+4QgjzskkcNHiCpFVcpZMsFgsuZFvfj6HgaTGt+NqFXCZ5XU=
X-Received: from pjbhg4.prod.google.com ([2002:a17:90b:3004:b0:33b:c15c:f245])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:8c6:b0:290:c0b1:edb8
 with SMTP id d9443c01a7336-290cbb4a2ccmr58854435ad.40.1760721924728; Fri, 17
 Oct 2025 10:25:24 -0700 (PDT)
Date: Fri, 17 Oct 2025 10:25:23 -0700
In-Reply-To: <46eb76240a29cb81b6a8aa41016466810abef559.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016182148.69085-1-seanjc@google.com> <20251016182148.69085-3-seanjc@google.com>
 <46eb76240a29cb81b6a8aa41016466810abef559.camel@intel.com>
Message-ID: <aPJ8A8u8zIvp-wB4@google.com>
Subject: Re: [PATCH v2 2/2] KVM: TDX: WARN if a SEAMCALL VM-Exit makes its way
 out to KVM
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Dan J Williams <dan.j.williams@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 17, 2025, Kai Huang wrote:
> On Thu, 2025-10-16 at 11:21 -0700, Sean Christopherson wrote:
> > WARN if KVM observes a SEAMCALL VM-Exit while running a TD guest, as the
> > TDX-Module is supposed to inject a #UD, per the "Unconditionally Blocked
> > Instructions" section of the TDX-Module base specification.
> > 
> > Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/vmx/tdx.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 097304bf1e1d..ffcfe95f224f 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -2148,6 +2148,9 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
> >  		 * - If it's not an MSMI, no need to do anything here.
> >  		 */
> >  		return 1;
> > +	case EXIT_REASON_SEAMCALL:
> > +		WARN_ON_ONCE(1);
> > +		break;
> > 
> 
> While this exit should never happen from a TDX guest, I am wondering why
> we need to explicitly handle the SEAMCALL?  E.g., per "Unconditionally
> Blocked Instructions" ENCLS/ENCLV are also listed, therefore
> EXIT_REASON_ELCLS/ENCLV should never come from a TDX guest either.

Good point.  SEAMCALL was obviously top of mind, I didn't think about all the
other exits that should be impossible.

I haven't looked closely, at all, but I wonder if we can get away with this?

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 097304bf1e1d..4c68444bd673 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2149,6 +2149,8 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
                 */
                return 1;
        default:
+               /* All other known exits should be handled by the TDX-Module. */
+               WARN_ON_ONCE(exit_reason.basic <= EXIT_REASON_TDCALL);
                break;
        }

