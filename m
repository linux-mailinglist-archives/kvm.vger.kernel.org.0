Return-Path: <kvm+bounces-59957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C3DB9BD6CB0
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 01:55:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B3B764F6808
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 23:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5F952F39BF;
	Mon, 13 Oct 2025 23:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lZOCtGcb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9B1271459
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 23:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760399685; cv=none; b=I8diGVf+0LYgZa2I33fXzMkAi98N1o4sPKre3Khra4beyRup+kIStoQCklNR2MS2Qav/BtPXWqOwm/XlbN5UUXVIOzAha0b7i08mis8xSWM1rTQhMy4PqI6gr5082MRkUi2bfs7xNxJC791wyta7f8iTBKxzX4FpTr78zchT9Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760399685; c=relaxed/simple;
	bh=wt8ABhQBNkuDTssrmADKWdmhe2+xsFwQvydnfFEZuw4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eMk63LQmlHpwyhXLd3pgrUQadHyOQFhAhYkCrEVbMHctX2JkkfTPdGicvBKn6ZHAUInmeB1x+Kusl1kKW8DIltNu9uf/ULnsPKsIf7bD0n+S46EChuHXs8P/ZmQdF4rtEY0M4dtrkDfB6fFh7EL43IJH2t94WK/JHvL7X3hWci4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lZOCtGcb; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-27eca7298d9so222922645ad.0
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 16:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760399684; x=1761004484; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5eSzM1BbjacPfILv0jrYJHzJQhHV06H7cFKDBkrRkvg=;
        b=lZOCtGcb+hFCxLPKlNasSR1pn8YsATj2jdsl0LhBLh3LnYOCP41DQM/t1xjRbeKyO2
         GlhY3SCDfKje92lP6UIE1rZRdgru4y52z16sh0gsHa5PR72irecohXObMtBPnFk3xA3W
         gGj9amIh/53e2IkSdkTWcjkHm7AtsC7HXhuT2cQXJm7f1uyDUkLxaA33Y8dqg/kMaeer
         njIhfVS46t7COelKYPcpN5sLtBLRrKmRuREM3BJq76QjPaaD/nJqE8+iw6kzm5pw82M0
         dZJduz3JZBnt8pbDvRw187tsjcRkbHJj8ma3bjWEv7VYC1/sXQqMgT3wq4l9giTmbnvw
         Fudw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760399684; x=1761004484;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5eSzM1BbjacPfILv0jrYJHzJQhHV06H7cFKDBkrRkvg=;
        b=mCF4MXdXWdBLl41vXRjipLDcIzjltcdT4lTXt94o459MygNNditPSyg0jFzACNaH+g
         w/fh9cpDSiVPuuLpTtICcrVHVTaNAP0/yrFUMayBuhk/UEjyY1fNDBIhYYXqn/pF3TFi
         cJSIrzLWqQd2X5LepoGr4fi0RO01sTG23EncJ6QehAfqPlu9RbAwt8tK4dLs/VjC4D6C
         UWVYHvi7OzT65P5NHjvFJLAIg734Wq0vUGmsH/KYiKT64b+Z4/tDHChxHKgAA3Ck3ZEX
         DGCCLYHqHZbNFpGfPxRxYTBdCLx+wdR8ZoMyfSKsCGxK6cV9qqzYna/qMIqSp5VWsujU
         fv0A==
X-Forwarded-Encrypted: i=1; AJvYcCX/6CUSp98voD3E+c5P4fn9BL5LhItFZD+GHJzssE0itOU13C+LGeSBJV7t/IUs9XH8kSs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxG4MCQEfUi2VQh5Luf6/5l+uBdED7Xcv7CJ0nx1GNFwKgyTjhV
	cYPvOA/Eolk6ycuzhy5QMnU3YNohj1Uflo05w9UzMFrbl7AxOoiI7qzF325oTU7LDigZA38P/B7
	dR/I+zQ==
X-Google-Smtp-Source: AGHT+IFG+BjAtYLOX1KiZpqF3jGYRoMOZPFJ6jl35/04RXhu8tJ/N/pUxAQejmx4mm6AggTYbzBFwK4lnFo=
X-Received: from plsd3.prod.google.com ([2002:a17:902:b703:b0:27d:6f45:42ec])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:246:b0:24c:9309:5883
 with SMTP id d9443c01a7336-290273ecb35mr293031675ad.28.1760399683860; Mon, 13
 Oct 2025 16:54:43 -0700 (PDT)
Date: Mon, 13 Oct 2025 16:54:42 -0700
In-Reply-To: <d75130b0a0fb9602fa8712a620cb1f7e52606ea4.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251010220403.987927-1-seanjc@google.com> <20251010220403.987927-3-seanjc@google.com>
 <d75130b0a0fb9602fa8712a620cb1f7e52606ea4.camel@intel.com>
Message-ID: <aO2RQu-xuSC0GGnn@google.com>
Subject: Re: [RFC PATCH 2/4] KVM: x86: Extract VMXON and EFER.SVME enablement
 to kernel
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Chao Gao <chao.gao@intel.com>, 
	Kai Huang <kai.huang@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dan J Williams <dan.j.williams@intel.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "xin@zytor.com" <xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 13, 2025, Rick P Edgecombe wrote:
> On Fri, 2025-10-10 at 15:04 -0700, Sean Christopherson wrote:
> 
> > +
> > +int x86_virt_get_cpu(int feat)
> > +{
> > +	int r;
> > +
> > +	if (!x86_virt_initialized)
> > +		return -EOPNOTSUPP;
> > +
> > +	if (this_cpu_inc_return(virtualization_nr_users) > 1)
> > +		return 0;
> > +
> > +	if (x86_virt_is_vmx() && feat == X86_FEATURE_VMX)
> > +		r = x86_vmx_get_cpu();
> > +	else if (x86_virt_is_svm() && feat == X86_FEATURE_SVM)
> > +		r = x86_svm_get_cpu();
> > +	else
> > +		r = -EOPNOTSUPP;
> > +
> > +	if (r)
> > +		WARN_ON_ONCE(this_cpu_dec_return(virtualization_nr_users));
> > +
> > +	return r;
> > +}
> > +EXPORT_SYMBOL_GPL(x86_virt_get_cpu);
> 
> Not sure if I missed some previous discussion or future plans, but doing this
> via X86_FEATURE_FOO seems excessive. We could just have x86_virt_get_cpu(void)
> afaict? Curious if there is a plan for other things to go here?

I want to avoid potential problems due to kvm-amd.ko doing x86_virt_get_cpu() and
succeeding on an Intel CPU, and vice versa.  The obvious alternative would be to
have wrappers for VMX and SVM and then do whatever internally, but we'd need some
form of tracking internally no matter what, and I prefer X86_FEATURE_{SVM,VMX}
over one or more booleans.

FWIW, after Chao's feedback, this is what I have locally (a little less foo),
where x86_virt_feature is set during x86_virt_init().

int x86_virt_get_cpu(int feat)
{
	int r;

	if (!x86_virt_feature || x86_virt_feature != feat)
		return -EOPNOTSUPP;

	if (this_cpu_inc_return(virtualization_nr_users) > 1)
		return 0;

	r = x86_virt_call(get_cpu);
	if (r)
		WARN_ON_ONCE(this_cpu_dec_return(virtualization_nr_users));

	return r;
}
EXPORT_SYMBOL_GPL(x86_virt_get_cpu);

