Return-Path: <kvm+bounces-17771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E1E238CA091
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 18:13:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80DEB1F21734
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 16:13:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EEB013792E;
	Mon, 20 May 2024 16:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wkz158jb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B80F28E7
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 16:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716221572; cv=none; b=ilcTo0bUT8oY1UUWxREnf2yF6e8yxZef1CRwSNDfeHDIdrPKC2opDuVlDAkiondA4fozycOxQP9/N2BaoU9V2NrGh8yzoijwB5W2dlETGrrJdCJuAmju9prCjPQCU0DuGWx8bsykIHviDkqtcglhlmOlBvgFxgYvlXTFNdM8LJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716221572; c=relaxed/simple;
	bh=ndSvp5o7Uyu7m5CFUsdC1gDLc9bJxe151OXDAGHCzcE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SYv04MWoTvt3gQx0K2YPwKioOePNni72NpoxcO4pj8qnFjIcvfCrwSvUrS/mO56d1cZZuSNXs4dluzZ5xQsUSa4gXhBAPWBognmBqUnhENrug/vBgWbuoILB9LOiOTWAZvpflAv0awgR4T1XmeSb/3l/AnUvtynDgvory7H49Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wkz158jb; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61be325413eso142806977b3.1
        for <kvm@vger.kernel.org>; Mon, 20 May 2024 09:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716221570; x=1716826370; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YqAox3vnnp1RHk0CTlnjLBK+5bX50Kf7v7eduSyk3HQ=;
        b=Wkz158jbBtWDZNYr9DalK5GwmDWq1va+vfofipsDAM68Sg70FSO3Elwv4IqpBY9LlP
         2Cf9FqXAZYTrnqoump6/pThHErEz7EEZ4q8JnpvtK7bAC6kNrhRi8fOcw+42Z9A08ck9
         3HM/dwacx0NJH8w8U4o8MmbLXAX23uPRsoVkVLyidcQ/8//qUpf8B2I4yQHxRdvUeHqR
         LqKO9DWMKkAtsB1V76SonrVXZqrOqlYGJcmt2NsuSThVYahN4fqZkrR40XGvPCBSJPfM
         QIX3ECtxUm5i+ZYIK/Kekt00MrqnXnVmhiSGmL4xR6A6XR9Z+CJlbvKiFuCg2e391KRV
         4f5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716221570; x=1716826370;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YqAox3vnnp1RHk0CTlnjLBK+5bX50Kf7v7eduSyk3HQ=;
        b=eSVdqBmOpKRs+VX16FDMtwgotj309eg/sNM8c9Lz1S+vv7WwlU/llG9bKMHU4DK1zo
         DUbyyTR5cH+daTw+7/FiCyhNSxIgokrU2Run7A6sQdS8lCETWFhEBeVPvMWFeSvGU1Kl
         AfqNS5YHRzGrDzPLXs88IClssWYsiAz7Ox++PVyuTARqXBOrBlV4RcFjtktEhm67WZrh
         KYEzbLkKbXVtdU2YCER7kxxvkzoTZVIksjubrmuUwC/cptkiuSO2HN3ZU//GPOWzu2Zg
         69nuMw7Wm/GPWEzy3lSlwlQnjZBIFvokDEDlMZN8MARkXWGysxOGI4gdsacF+z90V0nF
         zQ9g==
X-Forwarded-Encrypted: i=1; AJvYcCWwmmwQmzgjICljTLHe26VYSic0xJ9feOYp/v2ESpwvvqBiefMh0z9v9yhPCDRApxkDpA2kJ8qj4EVix8R9swub3ZGg
X-Gm-Message-State: AOJu0YyPhSCfwbY/CZ0K3XRDpfRIbVVul6YzbWZDQQw1Wawt7La5HAvG
	13igTlnpNBxbaGpIti0iPihgujt79DKkMv8DEtwii3vE5Pp0OY84XSKK5w6etjVyPju6Iflj6aG
	VPQ==
X-Google-Smtp-Source: AGHT+IFa2e5VGEJDNAknJpQM25yGMEzP0LmXW0vucAxwnkceDX3CFZ9s8rn661BS5hKCJ0z/mz+8q95JKLo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:8494:0:b0:61b:ebf1:77a with SMTP id
 00721157ae682-62796f670f8mr16949897b3.0.1716221570151; Mon, 20 May 2024
 09:12:50 -0700 (PDT)
Date: Mon, 20 May 2024 09:12:48 -0700
In-Reply-To: <c2baeb4b-5cad-4cb9-a48e-0540f448cb15@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1715017765.git.reinette.chatre@intel.com>
 <a2f7013646a8a1e314744568b9baa439682cbf8a.1715017765.git.reinette.chatre@intel.com>
 <c2baeb4b-5cad-4cb9-a48e-0540f448cb15@intel.com>
Message-ID: <Zkt2gNFxC0MHyIRb@google.com>
Subject: Re: [PATCH V6 4/4] KVM: selftests: Add test for configure of x86 APIC
 bus frequency
From: Sean Christopherson <seanjc@google.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: isaku.yamahata@intel.com, pbonzini@redhat.com, erdemaktas@google.com, 
	vkuznets@redhat.com, vannapurve@google.com, jmattson@google.com, 
	mlevitsk@redhat.com, xiaoyao.li@intel.com, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, yuan.yao@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, May 20, 2024, Reinette Chatre wrote:
> On 5/6/2024 11:35 AM, Reinette Chatre wrote:
> > diff --git a/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
> > new file mode 100644
> > index 000000000000..56eb686144c6
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
> > @@ -0,0 +1,166 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Test configure of APIC bus frequency.
> > + *
> > + * Copyright (c) 2024 Intel Corporation
> > + *
> > + * To verify if the APIC bus frequency can be configured this, test starts
> > + * by setting the TSC frequency in KVM, and then:
> > + * For every APIC timer frequency supported:
> > + * * In the guest:
> > + * * * Start the APIC timer by programming the APIC TMICT (initial count
> > + *       register) to the largest value possible to guarantee that it will
> > + *       not expire during the test,
> > + * * * Wait for a known duration based on previously set TSC frequency,
> > + * * * Stop the timer and read the APIC TMCCT (current count) register to
> > + *       determine the count at that time (TMCCT is loaded from TMICT when
> > + *       TMICT is programmed and then starts counting down).
> > + * * In the host:
> > + * * * Determine if the APIC counts close to configured APIC bus frequency
> > + *     while taking into account how the APIC timer frequency was modified
> > + *     using the APIC TDCR (divide configuration register).
> > + */
> > +#define _GNU_SOURCE /* for program_invocation_short_name */
> 
> As reported in [1] this #define is no longer needed after commit 730cfa45b5f4
> ("KVM: selftests: Define _GNU_SOURCE for all selftests code"). This will be
> fixed in next version of this series.

Don't worry about sending another version just for this, I can clean this up when
applying.

