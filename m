Return-Path: <kvm+bounces-49336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6616AAD7F8E
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 02:18:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D99917A5A45
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 00:17:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E0091C3F0C;
	Fri, 13 Jun 2025 00:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v0bVswyv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B551AA1D5
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 00:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749773906; cv=none; b=bPE3yuNvUXqhYhp9Uh6t0SOK+bNGnsShd1Jc96MT26g1ChR0i9WtuvwaAeiabtp2SFO/cSDQ+U4LbNrx1sMB4samcVjTOE4RdGhF93j4EGzXdsB1l9phjH6Zi9Tfr4SYZKpLfJDuJKPYmdplFNhzJYXhT1IN3Ko6WF+q1AZzl/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749773906; c=relaxed/simple;
	bh=5i/Kz9zGPQ4r2PwKaFldoSkJCG5Brxf1/boOz8euMfE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=puiL6nuF6zfVP9AWtCHxZObZ3BvSVf5MrVo6GfdUcd6bMO8RAyTFVZnFrhAneKedLqB4HR2jnFtOcZCbe0WxPlpyIzpyxaH+1tZjc4TSktNrmkn+2VwE66dvzL/17Gn2531ncPWj0M4E42DluKzBLteiS679gncIcrsTURAfyXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v0bVswyv; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-234906c5e29so17640765ad.0
        for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 17:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749773904; x=1750378704; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H43IbeUL3QFdvA9+BVZkV6ea988HyH6lrK+/f8SpcHA=;
        b=v0bVswyv2MwfI6R407WGrzE/AeLvfGDRbjiW8fslXmdOoexLf9lMuJ+HH4GSdVuckF
         3DbtCOi1S02wFPJ0DmTyp/j9ch2bKyHuvXNRm0gMRb33am55qwXQ1ilGAhEHl30gnkUg
         sX11YyrGsLY1n+SU59vwItsg7BS7C4vrABjkBUvaHfNHI2slynFjSDJpq3fE/0V2YhKv
         bqgnt6nVwYxE+yUfa44qNKJ2Wof+Lic9pVLZqgmhfIU0rKMA2Gl0LlHZH06Ik5RsFY4F
         5WdmxaTce9pGLTH7IXsihmkNrDpWsXoe2SbiYNYbhoF4N+Xbl45yQGPUP3RodtlWXr5h
         oXkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749773904; x=1750378704;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H43IbeUL3QFdvA9+BVZkV6ea988HyH6lrK+/f8SpcHA=;
        b=eBqjeCiiXe5cHwy2Xk5r80LM6ryvHTdGIvmaUcZUPRpIhIFcyYbFivUb6B01rhJTR/
         XSL7ifNDPmEgEJZOrj3KRpNIDJe31213SY046KHjGPQiUBw7NvyKpgMcIe63eoUCAATM
         Yi/BOsGErgMb7HLez6EaOVbHbMOiJ9RNHuEOudepMvvNKqbFNFdr9x+mCEY9VGTYVBWZ
         Ml1K8N4Ci609K64DF1OIzmwLH6rGhts/9yLwsNAleUcFp3vRXlzOhsuGmR2TJ27wfVdN
         kZBAAfe2ydAZWit/xx+xudCzmk8c7EoQY4398nBapPc4WKFXhmmbjYTFxPqWjTMt69hi
         h4aw==
X-Forwarded-Encrypted: i=1; AJvYcCV1NZxBGxVpqXnk1KI+zbmC0lUf1fE8A50qxbtzjPIGJWkPYenWXHayeqKS1Umo1XCZvLc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSuVZQCNltq9SLmhd8Jh6dYHb6qRM9kgOnYTw+1PhV4CVfO0TK
	dzMszXqr2XRVYPPaJjwSskrxuL7yamcPVg3B6eHJA+0XQPe/1GAM2FBofMSw0wJe0Z60q4apn43
	GL3nUVw==
X-Google-Smtp-Source: AGHT+IFztzIN+LhXHtkHmf4/zD8JypbwgxvzBHTruUdV5ogDCnmgwrGuDq/b/wwTYKI3W48kBDJVSoH+wA0=
X-Received: from pgbfy15.prod.google.com ([2002:a05:6a02:2a8f:b0:b2e:c15e:3eb7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2352:b0:234:ef42:5d5b
 with SMTP id d9443c01a7336-2365d8a170amr13173945ad.16.1749773903965; Thu, 12
 Jun 2025 17:18:23 -0700 (PDT)
Date: Thu, 12 Jun 2025 17:18:22 -0700
In-Reply-To: <20250612214849.3950094-3-sohil.mehta@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250612214849.3950094-1-sohil.mehta@intel.com> <20250612214849.3950094-3-sohil.mehta@intel.com>
Message-ID: <aEtuTrybjLKiNctB@google.com>
Subject: Re: [PATCH v7 02/10] x86/fred: Pass event data to the NMI entry point
 from KVM
From: Sean Christopherson <seanjc@google.com>
To: Sohil Mehta <sohil.mehta@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Adrian Hunter <adrian.hunter@intel.com>, Kan Liang <kan.liang@linux.intel.com>, 
	Tony Luck <tony.luck@intel.com>, Zhang Rui <rui.zhang@intel.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Andrew Cooper <andrew.cooper3@citrix.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>, 
	Sandipan Das <sandipan.das@amd.com>, linux-perf-users@vger.kernel.org, 
	linux-edac@vger.kernel.org, kvm@vger.kernel.org, linux-pm@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 12, 2025, Sohil Mehta wrote:
> Extend the FRED NMI entry point from KVM to take an extra argument to
> allow KVM to invoke the FRED event dispatch framework with event data.
> 
> This API is used to pass the NMI-source bitmap for NMI-induced VM exits.
> Read the VMCS exit qualification field to get the NMI-source information
> and store it as event data precisely in the format expected by the FRED
> event framework.
> 
> Read the VMCS exit qualification unconditionally since almost all
> upcoming CPUs are expected to enable FRED and NMI-source together. In
> the rare case that NMI-source isn't enabled, the extra VMREAD would be
> harmless since the exit qualification is expected to be zero.

Nit, instead of "is expected to be zero", something like this 

  harmless since the exit qualification is architecturally guaranteed to be
  zero on CPUs that don't support NMI-source reporting.  Per the SDM's
  "Exit qualification" subsection of "Basic VM-Exit Information":

      For all other VM exits, this field is cleared.
--

to make it very explicit that reading the exit qualification on older CPUs is 100%
safe, e.g. even on non-FRED CPUs (see https://lore.kernel.org/all/aBUiwLV4ZY2HdRbz@google.com).

> Suggested-by: Sean Christopherson <seanjc@google.com>
> Originally-by: Zeng Guang <guang.zeng@intel.com>
> Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>

