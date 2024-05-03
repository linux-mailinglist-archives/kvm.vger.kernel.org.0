Return-Path: <kvm+bounces-16510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0D988BADB0
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 15:25:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C42A01C21900
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 13:25:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 559AF153BE1;
	Fri,  3 May 2024 13:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kW3w76/r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7AD153575
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 13:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714742691; cv=none; b=FmvO5csMId0igVEyvmkWuJUnAQ3JCWu0yyv81EJ5zbM4FOWds2dIwhjRFIK3C783QDN5RW1iinnmf2msYYDn837OMxh3C8/ufRJQNPbryu7sLBDDXrAnUmwgI+jIRRkf1MeipWT1Mj2FXo+a7ISTYI2OJawDwzmb+dFwdqgY0m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714742691; c=relaxed/simple;
	bh=LnQBqRowOn/mmqH744BQ56CUkrHMmmG7pILmr2k3FwQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=unr1vNcSSdsZwDjhhG1Kv8NWQNnMzPqT/R/ZNfjBIabKgcZnAM2y1j7PrL8KqN8iGp7pNU5/WNta/oLOzJi7dEsJiNHSa9JVMKr60Id3mIcpo1lzQdl27jWvvPWPOK+HG2IdVgiwflsNIvvzPB8OiYtCxxUAGDWlUkT6NQBUYhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kW3w76/r; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6ee128aa957so11096353b3a.2
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 06:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714742688; x=1715347488; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+ccOeukr23e3h6a0N8DffRaB2MUtEUXB1eb2oExcKkQ=;
        b=kW3w76/rsYjB2Aw2hH5w+q98JKgzG+DyYm6qhv9gF2jS+2J8EE6ZiUxcYdjIDfKZV9
         hVeJCOICkGQGIa1vyzFmb8v3+7sNDVjcl6XPCcxof2AC2y5hWgIHADeaEuSnM5Ehbzd+
         r2X75cvehYAW/hljvHI4wCTg2bAvHOZ+Fg5eJuEIM0MdAQFtfyKnmohkcgQN8Q3wwUr3
         5ErAGQX+Eqjc++Vv4kwhqRcMIELSk4MSqQiYZxFYEx+YWR+s0gAD2xzhN0FaiQExpZUI
         arorupLC/GMjgPEjZaiOc9BQYj8vS2VWw9ZFWUMO1mAD8LHstE1ut1SO2cZxLbIORbXL
         F6Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714742688; x=1715347488;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+ccOeukr23e3h6a0N8DffRaB2MUtEUXB1eb2oExcKkQ=;
        b=G3SQ3UjFa7Zz9yDL1H5xZ7KWFIAkoT9epMlrR3cttP/fA4wpF42zeyIgOReS5taGLA
         ihKiNUvPeRzGSPjPJ51j9xgEckAnHpxnnq/xIW5RWJxt7S4qAk/ftrID1VSoJVuADQwb
         J8yoyKWoBvOx94Scw8ndH4MEj4RU64T/k0TyUmoWtc0H6dlaZMV25ighVBJfCLSYBwLw
         mMrxoYjy8n3AijlZHQs9jC3lA9Btc61gOu6aJMDHC3FE48wTbhqok/NAIjDcs5lZ0PmQ
         t5ogEnIgX1jBD3kvUDNqQ9MlGM4ubDlVVT8ml/v8d6sG4caBaUm1F/HzgiNr4c8Urx7L
         +RCg==
X-Forwarded-Encrypted: i=1; AJvYcCXa48UC3LnehpITZTVP5RrfM6BzH79AHVjhZCKKaudt17uMTelEY9UJvZOIqGt9wFtJRjeA1T5cSwKJv9PY56NjAn9E
X-Gm-Message-State: AOJu0Yw522rJINIddPd54lzSmzpqhQm61guC1WNk4FvR1lNQW4kslTy2
	GukdDYfTUHzdz8IDX+7Szh1uu6Snt3Uz5vIUXTrt2kdwTfIROlsn+wEvWrq31u3tmEedB39Wf0C
	aBg==
X-Google-Smtp-Source: AGHT+IFqaqDYUgUT1sFW3BILdnSLhDiEXyo5YaoA9nj8RUO7yNSem5r8cA469uOkvhX2zmIw7iPay/E5mxs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:181a:b0:6f4:42d7:fe02 with SMTP id
 y26-20020a056a00181a00b006f442d7fe02mr106073pfa.3.1714742688288; Fri, 03 May
 2024 06:24:48 -0700 (PDT)
Date: Fri, 3 May 2024 06:24:47 -0700
In-Reply-To: <DS0PR11MB6373EA67C70B8579A194089EDC1F2@DS0PR11MB6373.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240425125252.48963-1-wei.w.wang@intel.com> <20240425125252.48963-4-wei.w.wang@intel.com>
 <ZjQjYiwBg1jGmdUq@google.com> <DS0PR11MB6373EA67C70B8579A194089EDC1F2@DS0PR11MB6373.namprd11.prod.outlook.com>
Message-ID: <ZjTlkSi9jYn2e9oc@google.com>
Subject: Re: [PATCH v3 3/3] KVM: x86/pmu: Add KVM_PMU_CALL() to simplify
 static calls of kvm_pmu_ops
From: Sean Christopherson <seanjc@google.com>
To: Wei W Wang <wei.w.wang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, May 03, 2024, Wei W Wang wrote:
> On Friday, May 3, 2024 7:36 AM, Sean Christopherson wrote:
> > On Thu, Apr 25, 2024, Wei Wang wrote:
> > >  #define KVM_X86_CALL(func) static_call(kvm_x86_##func)
> > > +#define KVM_PMU_CALL(func) static_call(kvm_x86_pmu_##func)
> > 
> > ...
> > 
> > > @@ -796,7 +796,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
> > >  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> > >
> > >  	memset(pmu, 0, sizeof(*pmu));
> > > -	static_call(kvm_x86_pmu_init)(vcpu);
> > > +	KVM_PMU_CALL(init)(vcpu);
> > >  	kvm_pmu_refresh(vcpu);
> > 
> > I usually like macros to use CAPS so that they're clearly macros, but in this case
> > I find the code a bit jarring.  Essentially, I *want* my to be fooled into thinking
> > it's a function call, because that's really what it is.
> > 
> > So rather than all caps, what if we follow function naming style?  E.g.
> 
> Yep, it looks good to me, and the coding-style doc mentions that "CAPITALIZED
> macro names are appreciated but macros resembling functions may be named in
> lower case".
> 
> To maintain consistency, maybe apply the same lower-case style for KVM_X86_CALL()?

Yeah, for sure, I should have explicitly called that out.

