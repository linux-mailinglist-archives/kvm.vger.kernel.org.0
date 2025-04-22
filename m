Return-Path: <kvm+bounces-43848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00473A97616
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 21:51:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 530367A751C
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 19:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A634298CC0;
	Tue, 22 Apr 2025 19:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sEsuM4T/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76AD328F944
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 19:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745351485; cv=none; b=ZIUDimOp5Mo8T2ukuh/2gPRnvtdHISOTkW3/jOOetkGqmiqrzKLhjIFbq49z9o+/4pasphpBCVFar3H4HMh9Z2IQFg6Q6K5GXYgEWDDcm+QXc0SJT84gD2eeNpXtscjYWJHjTaLqc6QcKwIWFhVbQPrPku2gRojhm0LA+82IBH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745351485; c=relaxed/simple;
	bh=G+t2v6BhLb+5vWztzdpssgwdNSlTOk90KThSVmnEfpo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GfRpcQCTG+IG/51UFuI9D/Bl35TgvhUDkshiHRGFms3wNv9UIhWy2sQvyR9BzrLjNGu8NNfQ28r9ptKzqeqfRtFKjagh5FWKwx3C8p51osMzqTPCpbyY+yDu3cJJGBrM5s1qScSqFCszzJO1+6egfvbvz78op1BdPpZTKm78dRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sEsuM4T/; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff6aaa18e8so4868469a91.1
        for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 12:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745351483; x=1745956283; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mH6UGx1+cJUt0+vdtDYj5GNgwh2+pJEonMo7kApLLOI=;
        b=sEsuM4T/6AiEfbcv6LEBX9nIBDT+43JI3MKdo3iKnkO2YqI70DcND2IDwLROe9Q4D5
         GArSdE4crjfrbQKmyHy1Els5AUgocKZZBhQ4ePOShvuMia5QfeqWQImCd0ooUy3J7eaq
         uQ6iKaiB9W6Oab+GGxn3MZLM2zo9IQaI7BW1VoDi98zqEoGP3JMAMBj5PRaUmpBLWtRo
         mjh4DGwfQSGSsttkwj1ptnNcpnPTSEHYTK8QeWv5i016xI7jxtl9m17cB/A22/f5mrtk
         Q0lgI2Pwnlfgiq4aj2EbhSZVbFNZn+LTprUdDBVTDrYPrI9CfkqS4laNY2dRY2mAg8i+
         vevA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745351483; x=1745956283;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mH6UGx1+cJUt0+vdtDYj5GNgwh2+pJEonMo7kApLLOI=;
        b=CYNWZfA4/eOEKj9myib2dPK7p+9gWlNMb7gaqPYO96Bhx2GQVbhyU+cnXHx7Sh2gmi
         G7za0ZKFN0/XtICHiiSSJ756YE7FGwY2/IGl6alBJUT/EVq5HUlZ5bPiEI16/aY7KFZi
         rAO7IUd6IMwVJ0XdJlY3sPC/nCM6RfpBBQiz2PhbuVMWQ9npy82E9Izmmnv4CQ2Y4pQ3
         c0YJFgF8BbzTWCq2vWcpKcrtW/A1jcM9Zls2F9oKgKxCD1mji1IxD5j8BvCiZVprb4jv
         HrK52tV+uOtlq5IA9Agl4eGFE9Oab/jucJoueLZ68aOusfar0KD7YR//XDMjz/iq4K2w
         p5pQ==
X-Forwarded-Encrypted: i=1; AJvYcCU19AWYaRT7A+5C+bGYyfd3e4wDTpCFk7hZqNFLEDO81EbZE9ztjdRRr5gLkcEbYBELfxI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTgZ8zXYAGuaCfLXj9FIwzRXWYSTLsnlq1mZ96JDa7WDskM5zh
	KgokwzfUDVc9Vr+CsHazcmsJEZDAwKh1BaaYBI6bwTr3ZQ6bYcvw3arAPoBoC3ek3mKy/QK6M/Z
	SMA==
X-Google-Smtp-Source: AGHT+IGkV0RcloCvNwgssDSlkXsqRo5n8/rzSZ0U6QUVt02K3Nbge8IReH8D+uHUWVsCRD28uFY//07FCPo=
X-Received: from pjbsr7.prod.google.com ([2002:a17:90b:4e87:b0:301:2679:9d9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b90:b0:2ee:bc7b:9237
 with SMTP id 98e67ed59e1d1-3087bb9ede2mr21004314a91.27.1745351482796; Tue, 22
 Apr 2025 12:51:22 -0700 (PDT)
Date: Tue, 22 Apr 2025 12:51:21 -0700
In-Reply-To: <aAfxuby_0eZZTrj-@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250422082216.1954310-1-xin@zytor.com> <aAevpauKYWwObsB7@google.com>
 <cb4e24a0-fdb7-46d2-9b0e-200f5e3e4c96@zytor.com> <DS7PR11MB6077B4D80EB7020C4D3FCD52FCBB2@DS7PR11MB6077.namprd11.prod.outlook.com>
 <aAfxuby_0eZZTrj-@gmail.com>
Message-ID: <aAfzOWnYzcPjZDEI@google.com>
Subject: Re: [RFC PATCH v2 00/34] MSR refactor with new MSR instructions support
From: Sean Christopherson <seanjc@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Xin Li <xin@zytor.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>, 
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, 
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, 
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>, 
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, 
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, 
	"linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "acme@kernel.org" <acme@kernel.org>, "jgross@suse.com" <jgross@suse.com>, 
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	"namhyung@kernel.org" <namhyung@kernel.org>, "mark.rutland@arm.com" <mark.rutland@arm.com>, 
	"alexander.shishkin@linux.intel.com" <alexander.shishkin@linux.intel.com>, "jolsa@kernel.org" <jolsa@kernel.org>, 
	"irogers@google.com" <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	"kan.liang@linux.intel.com" <kan.liang@linux.intel.com>, "wei.liu@kernel.org" <wei.liu@kernel.org>, 
	"ajay.kaher@broadcom.com" <ajay.kaher@broadcom.com>, 
	"bcm-kernel-feedback-list@broadcom.com" <bcm-kernel-feedback-list@broadcom.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, 
	"luto@kernel.org" <luto@kernel.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, 
	"kys@microsoft.com" <kys@microsoft.com>, "haiyangz@microsoft.com" <haiyangz@microsoft.com>, 
	Dexuan Cui <decui@microsoft.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 22, 2025, Ingo Molnar wrote:
> 
> * Luck, Tony <tony.luck@intel.com> wrote:
> 
> > > >> base-commit: f30a0c0d2b08b355c01392538de8fc872387cb2b
> > > >
> > > > This commit doesn't exist in Linus' tree or the tip tree, and the series doesn't
> > > > apply cleanly on any of the "obvious" choices.  Reviewing a 34 patches series
> > > > without being able to apply it is a wee bit difficult...
> > > >
> > >
> > > $ git show f30a0c0d2b08b355c01392538de8fc872387cb2b
> > > commit f30a0c0d2b08b355c01392538de8fc872387cb2b
> > > Merge: 49b517e68cf7 e396dd85172c
> > > Author: Ingo Molnar <mingo@kernel.org>
> > > Date:   Tue Apr 22 08:37:32 2025 +0200
> > >
> > >      Merge branch into tip/master: 'x86/sev'
> > >
> > >       # New commits in x86/sev:
> > >          e396dd85172c ("x86/sev: Register tpm-svsm platform device")
> > >          93b7c6b3ce91 ("tpm: Add SNP SVSM vTPM driver")
> > >          b2849b072366 ("svsm: Add header with SVSM_VTPM_CMD helpers")
> > >          770de678bc28 ("x86/sev: Add SVSM vTPM probe/send_command
> > > functions")
> > >
> > >      Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > >
> > >
> > > You probably need to git pull from the tip tree :-)
> > 
> > If possible, you should avoid basing a series on tip/master as it 
> > gets recreated frequently by merging all the topic branches. The SHA1 
> > is here today, gone tomorrow.
> 
> Correct, although for x86 patch submissions via email it's not wrong: 
> what applies today will likely apply tomorrow as well, regardless of 
> the SHA1 change. :-)

Yeah, but as Tony pointed out, when using base commit that may be ephemeral, then
the cover letter needs to call out the tree+branch.  This series applies on the
current tip/master, but there was nothing to clue me into that fact.

