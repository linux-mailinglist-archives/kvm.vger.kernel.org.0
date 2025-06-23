Return-Path: <kvm+bounces-50378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47172AE48F7
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 17:42:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95DEA3AC286
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 15:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A09C727C17F;
	Mon, 23 Jun 2025 15:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ESr4kiMi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393D629B768
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 15:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750693186; cv=none; b=US4cN+2oaATMEPUk2el53PUjZ/ZZIxxQPAK2RAlvyXtezx9+L0iwoqtX9YyHS0Sgz0d29UHcB0kS4eRuE/aWeqDCEXITWGG7o8XbqaxZFoqadvLKf5x1D4Bsnp6uUIoHTsdQh0SNSCXa3jZzL7xJG8383dhMauzCPiK+gUn96qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750693186; c=relaxed/simple;
	bh=hzweejx2tV391E/xHsALnrKjfTLLQ1qXqDpwudaH8wY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NrQEAWzZmnK9nLDOgL6FFoeT9kyQEddZ2jSCset4HZxmDpIAGCdWm0GIzCR+zPXefmSiu15QLfIxwOXqErOo2cb1erF2dhVsMnqg1devoiBPQDC77dCRvin+cV/ehu/m/GgYttJqRiiZ1pz1kC9/umEEOsy2z0ePH+LAg8BStbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ESr4kiMi; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7491814d6f2so2800200b3a.3
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 08:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750693183; x=1751297983; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mohC5VFo2Khyq7uJVLtUEQiLH3jaozZVPkYc2uzJvvA=;
        b=ESr4kiMifBbwCFUjQmmN6/s/2xF3LHDxBNye0yGKEE42uI1wxSgzgXukjKxeNEIS2w
         u6idNOj3CErYWfNyKPx42xIj2BrafdNq8QgCzqDorQ34ICZk/Pbpu1sLIakqy/IBIcwS
         gJlLrX731SmHqRxaawl0MEGS8C89SNrtqFPSO/pLa7c730lH8Km2Nsy60EhDNBiOPdJe
         gKksP/RzW+KKyowTT9IIJEy80fTK3rwfPxX06Zt2XrTo2VUErKHMa8712Vb10CBmyodA
         Kf2F9v/qSDhA0YW5JaByzMDhmFggTfDFqTDbHRvq9G2V+THs//ApWgZFy6xVKMPVFVBR
         ubuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750693183; x=1751297983;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mohC5VFo2Khyq7uJVLtUEQiLH3jaozZVPkYc2uzJvvA=;
        b=dytqmSZdovIoMV0jEdxRHNDTqZXFGQllUhlR7Rxqqis5qN3skFeVzKwQlZtHRlUyQF
         bY0kbDTBS8E1QZB1iJxV0yUVwi1vUIKHzm2TuJ1Zz71OXQgIWUUUzEHtS+GuTsZErslM
         MsYSvI2Ge74oFF7bOmdyPMG+vL/x6wPKFlSX4fQopwvr9VGbhTLFOK1DolQZfJIMHNU2
         CPM7hm58FbLXzhhCkNnT+eXE/d2AFkR6QTiTucelkLxfzzunmOYnfFHcDromR8uZr5Gn
         APevv0TX60EvjJK4zZENVRkNF++Fo+lxe0nw69gOXYZ8K+a+x9bRvPfo9d9M0mJhJ6fm
         t/EQ==
X-Forwarded-Encrypted: i=1; AJvYcCUB0HOnz95jVBKiTr9iEDtOJIaw1s89FpqX4qlVX0BFqHhCOpMdgj6p4Z0UzILJ94iDEJw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwHq2FT60pxJlr2clr6J8Mr4HPKcscyIBF6tdOisPNBZzav7jM
	+7Ery3QA8WYFBcejf8Cz244PASiQ6IgSyo/Q3lfoh1tzNkrzkVLIZs1VR9FT8KKnJSmxwJ/Uo+M
	BkhE7iQ==
X-Google-Smtp-Source: AGHT+IEtzfUGiXMebcgTMM/d+ycTT8KreG0zM+7jUxln2kINdcl11Cpifn/EmOu0VDMQqH0ZnY2khiJd4sw=
X-Received: from pfblm18.prod.google.com ([2002:a05:6a00:3c92:b0:748:f16c:14c5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1a8c:b0:749:9c2:e154
 with SMTP id d2e1a72fcca58-7490d4788d9mr18371573b3a.4.1750693183347; Mon, 23
 Jun 2025 08:39:43 -0700 (PDT)
Date: Mon, 23 Jun 2025 08:39:41 -0700
In-Reply-To: <1713a225-44e0-4018-bf5f-64ffd7746167@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
 <20250612214849.3950094-3-sohil.mehta@intel.com> <7525af7f-a817-47d5-91f7-d7702380c85f@zytor.com>
 <3281866f-2593-464d-a77e-5893b5e7014f@intel.com> <36374100-0587-47f1-9319-6333f6dfe4db@zytor.com>
 <39987c98-1f63-4a47-b15e-8c78f632da4e@intel.com> <7acedeba-9c90-403c-8985-0247981bf2b5@zytor.com>
 <aFXsPVIKi6wFUB6x@google.com> <1713a225-44e0-4018-bf5f-64ffd7746167@zytor.com>
Message-ID: <aFl1PcnVuYuELvRQ@google.com>
Subject: Re: [PATCH v7 02/10] x86/fred: Pass event data to the NMI entry point
 from KVM
From: Sean Christopherson <seanjc@google.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sohil Mehta <sohil.mehta@intel.com>, Xin Li <xin@zytor.com>, x86@kernel.org, 
	linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
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

On Fri, Jun 20, 2025, H. Peter Anvin wrote:
> On 2025-06-20 16:18, Sean Christopherson wrote:
> > > 
> > > So I was thinking about this, and wonder: how expensive is it to get the
> > > event data exit information out of VMX? If it is not very expensive, it
> > > would arguably be a good thing to future-proof by fetching that information,
> > > even if it is currently always zero.
> > 
> > It's trivially easy to do in KVM, and the cost of the VMREAD should be less than
> > 20 cycles.  So quite cheap in the grand scheme.  If VMREAD is more costly than
> > that, then we have bigger problems :-)
> > 
> 
> LOL. Since it is up to you, Paulo, etc. to decide how to do the tradeoffs
> formaintainability, debuggability and performance in KVM I am guessing this
> is a vote in favor? (You can always take it out if it is a performance
> problem, until such time that the kernel itself starts consuming this
> information for reasons currently unknown.)

Unless you can pinky swear that vmcs.EXIT_QUALIFICATION will provide event data
for IRQ exits, then I'd prefer to pass '0' unconditionally.  '0' will always be
safe, if potentially suboptimal.  But passing what could in theory be something
other than FRED-formatted event data could lead to buggy behavior.  Per the FRED
spec, Revision 7.0, exit-qualification doesn't hold event data for IRQ exits.

  For some events for which event data is defined (see Section 5.2.1), the event
  data is saved in the exit-qualification field. (This is done for #DB, #PF, and NMI.)

