Return-Path: <kvm+bounces-21126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBEAC92A9E0
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 21:33:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96E0C283097
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 19:33:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E46414D443;
	Mon,  8 Jul 2024 19:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nxoW+xBl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA271DA5F
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 19:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720467211; cv=none; b=N6h+U5U5m1PyFVMuqXPa+R6bSXKNtd2Xy39aiKf9nWK04JhNBZ7J94QpGhCLBjczfikGUTx9BKELF2dL9yPO53f+RFKgVHZ3E26cu9KLckxCnBsT0po0S5dE+06fc0gcMgAP1fP8V0q59SUfbY/0V+yG686GlieLMdJShEnUmfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720467211; c=relaxed/simple;
	bh=Lkct58u03qKX24GL/17oS13ObQaBn0gV67+onEUoBa0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HrfHqFjwnvUw85RBz6T1IvN2zYvUAqmd3wJFsMjm26+BFemc4W/6jlc5cT5vahXUrHdkYcOUAaxY8zN6i+RqH18s/Pzs4umJadvJzRRNYyANni+UVBMn+QymFZFK+tUtmWhWIn0CB95L0YPRHB5fGuQ65SMsaUl0rmpaH8N0uYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nxoW+xBl; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e039b77a040so7098943276.2
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2024 12:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720467208; x=1721072008; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0SsfUEhdZE3jvwQ557rvrdiT1mwqMCwVY9Pd8h40l2A=;
        b=nxoW+xBlNrd834SNYp2ya1Ktrhqw6FbKFdYgDCOYuxx6IY0k5rTe69cU1SGqG4fLP6
         h3WnxSkK81mQRzNqZpFHzsn8UUMf7HgnaY5oj7RG71/2NbMfkXtmiWMcImdl1/9GcC1u
         kdwUTpHLM+uQaCyFtow7zKdBYXHAHVcrcmTRj8E7MUzqIfHAujG8+yHDkjEId22vvzRS
         mYyeCfByyUV0jN5nNPnC8PxJPZIGRKq0Wxpj10PXU4TuQA9KqdY9rL2jMvRKDrpBx7Mg
         OSBQeVlwBuGL2WLo3cFyb+unxhtgky4Z3FYqYTo7J8baKpBl2DZI9xuSwdsEilDTVrja
         cbDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720467208; x=1721072008;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0SsfUEhdZE3jvwQ557rvrdiT1mwqMCwVY9Pd8h40l2A=;
        b=onLrijNY4SBc7CNhMhA/GKZGJKM8yeV76tZF2KgZWOgOI0rWU8lxRNXCGGxEHyHLeL
         eHJnLYGs8UR8IaS18XXHHleuFjVL0QLv5wRVg57qC0LCpZy44Val4gJIkei/uB3CRpQI
         atS1/Li6e5YDLMysPy1ggs9rRxBbWYT/a/cJF0ViNTOAAjMeXpfhvteSdunzMQ+WlGr4
         ndISrwzzpwoUQY0pBWmDmI6s6epOoblPpzyX4ZFGV1/UQP2eC/uj1B5wvKaBGd1l9U28
         nsiHAfenJqaPmdXJJYt6tPhZNzModhuBUSRe/KHdreNxViB9a7JgfXAqXmZn6ThZf1u2
         GN7A==
X-Forwarded-Encrypted: i=1; AJvYcCU9lmam9bx5FSbOvgcAtAvCFvQdas+xSWJC9iy895djdDBnHDC6+bdsXToFt3a/B9myoY/fDdrdS42kPhqDA/ehELkU
X-Gm-Message-State: AOJu0YzDTBomXNYS6fFZsANMRk8iGqE8Oox7CG2TuUOcvd7RqKolT0Ep
	wJrVqVu1ymJAo0RQcNkWR6xedPiY+wwKY888h1YZRhZIOGRfOa6g7ZUCvV/yuV85Htw4q9Z5o9H
	5Bg==
X-Google-Smtp-Source: AGHT+IFPQJJnHnF4cf4wxaeu/SR+dAHcuEg/KlRGY3vjBwuULSNbvnJdgljw2/q9IZ9gwxv615Wjeh5M4cg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1ac1:b0:e03:62dc:63de with SMTP id
 3f1490d57ef6-e041b0593efmr47626276.6.1720467207949; Mon, 08 Jul 2024 12:33:27
 -0700 (PDT)
Date: Mon, 8 Jul 2024 19:33:26 +0000
In-Reply-To: <6a8aee9425a47290c7401d4926041c0611d69ff6.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-6-seanjc@google.com>
 <6a8aee9425a47290c7401d4926041c0611d69ff6.camel@redhat.com>
Message-ID: <Zow_BmpOGwQJ9Yoi@google.com>
Subject: Re: [PATCH v2 05/49] KVM: selftests: Assert that the @cpuid passed to
 get_cpuid_entry() is non-NULL
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> > Add a sanity check in get_cpuid_entry() to provide a friendlier error than
> > a segfault when a test developer tries to use a vCPU CPUID helper on a
> > barebones vCPU.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  tools/testing/selftests/kvm/lib/x86_64/processor.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > index c664e446136b..f0f3434d767e 100644
> > --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > @@ -1141,6 +1141,8 @@ const struct kvm_cpuid_entry2 *get_cpuid_entry(const struct kvm_cpuid2 *cpuid,
> >  {
> >  	int i;
> >  
> > +	TEST_ASSERT(cpuid, "Must do vcpu_init_cpuid() first (or equivalent)");
> > +
> >  	for (i = 0; i < cpuid->nent; i++) {
> >  		if (cpuid->entries[i].function == function &&
> >  		    cpuid->entries[i].index == index)
> 
> Hi,
> 
> Maybe it is better to do this assert in __vcpu_get_cpuid_entry() because the
> assert might confuse the reader, since it just tests for NULL but when it
> fails, it complains that you need to call some function.

IIRC, I originally added the assert in __vcpu_get_cpuid_entry(), but I didn't
like leaving get_cpuid_entry() unprotected.  What if I add an assert in both?
E.g. have __vcpu_get_cpuid_entry() assert with the (hopefully) hepful message,
and have get_cpuid_entry() do a simple TEST_ASSERT_NE()?

