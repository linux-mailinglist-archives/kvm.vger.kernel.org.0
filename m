Return-Path: <kvm+bounces-13372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BC7CE89569B
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 16:28:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 72AFB1F22BB3
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 14:28:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27304126F3C;
	Tue,  2 Apr 2024 14:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ax2cEWme"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87B78662E
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 14:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712068100; cv=none; b=Tde/sFenPY/JKtWYLh0I98TwWkn231DJNu68+OnFSmdpRM/HpYXXujBTYxSSFck1Pd4CBi2rSQwt/y2YFOIrgBeJIXua2I0tybDcscnEEW8odCQPNfrRsYYrWuAmnAhtuyZ+yyANWWAL7E9flVDDDUFPyQPhFkg6dnGlK3Gu+z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712068100; c=relaxed/simple;
	bh=Vp59S/BRUwx8heCW01K/HF3d9RO3DPhfddRZZZM8hE8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NuOFuSl7V6I6aS3Hy3fcEEf8aCiFi4loLUMMhxk16GsQQu4OMHSOb/crAuaXexyZxtdaH7u4y+PMC5+Z0b02BsguO1knbW43SCkfu92V2E4u45isPX+Jo1ELpkUDJGH3VBqPaw97Iw0D0QaVELYZrNkHq+xBgMYFWZY+DilijHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ax2cEWme; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-ddaf165a8d9so8313319276.1
        for <kvm@vger.kernel.org>; Tue, 02 Apr 2024 07:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712068098; x=1712672898; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pvty4VU9dwSIYWYyoQMKQj2eOKjnYj2wbCRcmV3R/+U=;
        b=Ax2cEWmeLUnykJm7kRaH2Mz2V9Prrt+9HezigGhg17hzD38mjH+1aYuhf+9osF0vB9
         xNOa/eDbUm0QYPiUewjrtQgxt3NpdtDycVwh/N0jzrWqRDT97gjemzUHn/hp9QQLLWLf
         aqNIUFwRgbc5sQ69nky6TCfzR81D/LWF7h1aoosvXaRdKNdkaULZOTCMIT+Mzwy0FjYl
         Q0PRAUIUlk3Mz6tuPXw6hgyktdf1QRREb+eptnv6aB7T8u+VyNk6I0GiPPgkSfqT+Lca
         CQ/yMnpNEpNQRC/iEIoPyZ5PV6X99V8nZ0846qvVWSVQsqkUiGv3EZgV/15l6iQ9z5wu
         DhAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712068098; x=1712672898;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pvty4VU9dwSIYWYyoQMKQj2eOKjnYj2wbCRcmV3R/+U=;
        b=cRqY7k+HrhdRdSm2/FiE9DyeqcDdYnzMFoHnqPPUNjNY9lfygAFVhkyhNHTFmR8Zga
         sfxTD2yhQ9JMlHK1DVav5jtkQ0d0UhFFJ9Cj73JincnbkMMiQU6HogIuH5UYTSjiScLG
         7Nm/n61TgCZpp/yQ+9mr/4JanZ5hnVGe2xHMZ556MjY52xqLqWh8Q013gARHLiyBz1sU
         J/iYJJJxjGi+wxBblmPdl5DJ8cMu2wyGdo72J+tTjJE9QPvMx6RbYW+vBDEEBNRXbMaq
         yUNNUvzWbdh5U0srmZOcprpZAGTXPMRxblLchi6dcCWQAw+O8uaVNE+WKFTyyDQjpei/
         fWKA==
X-Forwarded-Encrypted: i=1; AJvYcCUpQW7c3sb+sb0q7cR2vwTyyCWwQsVwKIpAsHd0AzpmLirxvwLS49RGNsriF/L9PN9kbyclYA+2C2npSaVam5H7Es+P
X-Gm-Message-State: AOJu0YxJwVyWHn725DnpKKB0YBNO49e4Pw0KGPrWxbHvD5YefIeYli9P
	+u4aYnpInkRO3TVl3nJJDISYBj0diwPNKVM+3xJotUwADfHJx15GRPBfHCPVLrrB+MbGgbzQUap
	hvg==
X-Google-Smtp-Source: AGHT+IE5DWyZW3NJXq8I1ZQmG4VCqgeU4gkFdlQBBPDIQKDg6eLVRquADyrFRzizfUGry+Ln02o7otcHOhA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2601:b0:ddd:7581:1234 with SMTP id
 dw1-20020a056902260100b00ddd75811234mr1016878ybb.11.1712068097831; Tue, 02
 Apr 2024 07:28:17 -0700 (PDT)
Date: Tue, 2 Apr 2024 07:28:16 -0700
In-Reply-To: <SA1PR11MB6734752BAB8F6E77FE6F9082A83E2@SA1PR11MB6734.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309012725.1409949-1-seanjc@google.com> <20240309012725.1409949-5-seanjc@google.com>
 <05484613-0d02-4ab6-a514-867a0d4459bf@intel.com> <SA1PR11MB6734752BAB8F6E77FE6F9082A83E2@SA1PR11MB6734.namprd11.prod.outlook.com>
Message-ID: <ZgwWAGHE7KmrLk5K@google.com>
Subject: Re: [PATCH v6 4/9] KVM: VMX: Move MSR_IA32_VMX_BASIC bit defines to asm/vmx.h
From: Sean Christopherson <seanjc@google.com>
To: Xin3 Li <xin3.li@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Shan Kang <shan.kang@intel.com>, Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 02, 2024, Xin3 Li wrote:
> > On 3/9/2024 9:27 AM, Sean Christopherson wrote:
> > > From: Xin Li <xin3.li@intel.com>
> > >
> > > Move the bit defines for MSR_IA32_VMX_BASIC from msr-index.h to vmx.h
> > > so that they are colocated with other VMX MSR bit defines, and with
> > > the helpers that extract specific information from an MSR_IA32_VMX_BASIC
> > value.
> > 
> > My understanding of msr-index.h is, it contains the index of various MSRs and the
> > bit definitions of each MSRs.
> 
> "index" in the name kind of tell what it wants to focus.

Heh, there are a lot of files with names that don't necessarily reflect the
entirety of what they contain, I wouldn't put too much stock in the name :-)

> > Put the definition of each bit or bits below the definition of MSR index instead of
> > dispersed in different headers looks more intact for me.
> 
> You're right when there is no other proper header for a MSR field definition.
> 
> While the Linux code is maintained in the manner of "divide and conquer",
> thus I would say the VMX fields definitions belong to the KVM community,
> and fortunately, there is such a vmx header.
> 
> BTW, It looks to me that some perf MSRs and fields are not in msr-index.h,
> which avoids bothering the tip maintainers all the time.

Ya, there is no hard rule that MSR indices and bits/masks _must_ go in msr-index.h.
Like many things, it's a judgment call, in this case to balance between keeping
a single file maintainble, usable, and readable, and making information easy and
intuitive to find.

There are many more examples, usually for things that are extremely "platform"
specific, e.g. the perf MSRs (especially for uncore stuff), synthetic MSRs defined
by hypervisors, etc.

In this particular case, I agree with Xin that putting the bit and mask definitions
in vmx.h makes the most sense.  Nothing outside of virtualization code is likely
to ever care about the bits of the VMX feature MSRs, and putting all of the info
and helpers in msr-index.h would add a fair bit of noise, and would make it more
annoying to tweak and add masks for KVM's usage.

