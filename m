Return-Path: <kvm+bounces-5074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A44581B9B2
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 15:39:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3FB2EB21DAA
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 14:39:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12FC736086;
	Thu, 21 Dec 2023 14:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BIeVcr/I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EBD1643D
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 14:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-548ae9a5eeaso10384a12.1
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 06:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1703169556; x=1703774356; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rjcA0ZHCISKFLd/dhu8u4Y90/L5gD9s8eTEB1hR8ro0=;
        b=BIeVcr/IKELXEmmHxqDHv6z8zM8YyEmKwR+w9WfKabjsW3PS4/UdM/VkOyY/J34h+0
         WwI2UtNRq1EFXYzQoSDcTQU2Z5qZ0h3j1914PSAzg/eGhU6mxSwjbxwMETlNpF+TqnmL
         w79XygQcY0l3eGR9CTEi2dGYiFjta0kkuCv6r4R6WfrednET6XzCvRADfwVmc1Y6PCyq
         xU3lhC/zU6cGwvT4DUQTbz5kFcuPD00ic+wswanV33xnnAQdh911jYQDRiwWbSqZP8b6
         T0Xae89ZYODyi0BgnzchWxOxFHRcupH2KzV10Y9JBVMuQHZSg+haHcVIkpRj61QxRj5H
         jaKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703169556; x=1703774356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rjcA0ZHCISKFLd/dhu8u4Y90/L5gD9s8eTEB1hR8ro0=;
        b=bxgMPYfoPmaMwa2LvsjARADFdVfcEq5WJNROYFlVzxibOUAbMXocCsGo/iSFZcvpoD
         kaD9AroDwdd57eHPqEqBZVXlDbu7eHgjSRGKlJMiC9ZqOg1tIcNV1v4FstNshoAnIToq
         WdQ1MDGGftzAzRdYo1aKKy+I9UmSFcBthTQ8NASLivpLm2jIBYIBqDSPxZ8/ZkCtZoGo
         nsCGWdCWivRbG14hFlAqNaxpHjHSbgMKHrZ9ES7lx4JigfT4GInJanhdUNNRSoS5oPfY
         fbtZuWV+hczMljOMULDpMxWnirk77yO9brALFTmrHm2H+256c7j3gmOst2tSA3YrPulf
         ucrg==
X-Gm-Message-State: AOJu0YzeX5oQDOx7yy4q6Pa1z4E2FDgNAF2WgYlRvflZatcpaUO9Q6hP
	lagrGR+hG9SaJYLl1rFYcw3sr07P+70ywiFP/V/1LOVB+0N4
X-Google-Smtp-Source: AGHT+IHadjkxej2zeqN8fIo7mtrLDexZz9HuN8LRIdrgV5tCw5yHEITs55wde2zBc3MpKO0nkT81+bMWqsG0mRCI6U4=
X-Received: by 2002:a50:c109:0:b0:551:9870:472 with SMTP id
 l9-20020a50c109000000b0055198700472mr78217edf.1.1703169555925; Thu, 21 Dec
 2023 06:39:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1699936040.git.isaku.yamahata@intel.com>
 <1c12f378af7de16d7895f8badb18c3b1715e9271.1699936040.git.isaku.yamahata@intel.com>
 <938efd3cfcb25d828deab0cc0ba797177cc69602.camel@redhat.com>
 <ZXo54VNuIqbMsYv-@google.com> <aa7aa5ea5b112a0ec70c6276beb281e19c052f0e.camel@redhat.com>
 <ZXswR04H9Tl7xlyj@google.com> <20231219014045.GA2639779@ls.amr.corp.intel.com>
 <CALMp9eRgWct3bb5en0=geT0HmMemipkzXkjL9kmEAV+1yJg-pw@mail.gmail.com>
 <20231219081104.GB2639779@ls.amr.corp.intel.com> <ZYNlhKCcOHgjTcFZ@google.com>
 <5cf35021-c81f-43e3-9d0d-69604fc4fa59@intel.com>
In-Reply-To: <5cf35021-c81f-43e3-9d0d-69604fc4fa59@intel.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 21 Dec 2023 06:39:04 -0800
Message-ID: <CALMp9eRqQqOK8n7jSiop9J2NORWVM-0bztbjMmo3npp4W1Tm8Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: Make the hardcoded APIC bus frequency vm variable
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Isaku Yamahata <isaku.yamahata@linux.intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com, 
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, 
	Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 20, 2023 at 9:44=E2=80=AFPM Xiaoyao Li <xiaoyao.li@intel.com> w=
rote:
>
> On 12/21/2023 6:07 AM, Sean Christopherson wrote:
> > On Tue, Dec 19, 2023, Isaku Yamahata wrote:
> >> On Mon, Dec 18, 2023 at 07:53:45PM -0800, Jim Mattson <jmattson@google=
.com> wrote:
> >>>> There are several options to address this.
> >>>> 1. Make the KVM able to configure APIC bus frequency (This patch).
> >>>>     Pros: It resembles the existing hardware.  The recent Intel CPUs
> >>>>     adapts 25MHz.
> >>>>     Cons: Require the VMM to emulate the APIC timer at 25MHz.
> >>>> 2. Make the TDX architecture enumerate CPUID 0x15 to configurable
> >>>>     frequency or not enumerate it.
> >>>>     Pros: Any APIC bus frequency is allowed.
> >>>>     Cons: Deviation from the real hardware.
> >
> > I don't buy this as a valid Con.  TDX is one gigantic deviation from re=
al hardware,
> > and since TDX obviously can't guarantee the APIC timer is emulated at t=
he correct
> > frequency, there can't possibly be any security benefits.  If this were=
 truly a
> > Con that anyone cared about, we would have gotten patches to "fix" KVM =
a long time
> > ago.
> >
> > If the TDX module wasn't effectively hardware-defined software, i.e. wa=
s actually
> > able to adapt at the speed of software, then fixing this in TDX would b=
e a complete
> > no-brainer.
> >
> > The KVM uAPI required to play nice is relatively minor, so I'm not tota=
lly opposed
> > to adding it.  But I totally agree with Jim that forcing KVM to change =
13+ years
> > of behavior just because someone at Intel decided that 25MHz was a good=
 number is
> > ridiculous.
>
> I believe 25MHz was chosen because it's the value from hardware that
> supports TDX and it is not going to change for the following known
> generations that support TDX.
>
> It's mainly the core crystal frequency. Yes, it also represents the APIC
> frequency when it's enumerated in CPUID 0x15. However, it also relates
> other things, like intel-pt MTC Freq. If it is configured to other value
> different from hardware, I think it will break the correctness of
> INTEL-PT MTC packets in TDs.

LOL! That suggests that no one is really using KVM's Intel PT virtualizatio=
n.

This is certainly a compelling reason for having a variable frequency
virtual APIC. Thank you!

> >>>> 3. Make the TDX guest kernel use 1GHz when it's running on KVM.
> >>>>     Cons: The kernel ignores CPUID leaf 0x15.
> >>>
> >>> 4. Change CPUID.15H under TDX to report the crystal clock frequency a=
s 1 GHz.
> >>> Pro: This has been the virtual APIC frequency for KVM guests for 13 y=
ears.
> >>> Pro: This requires changing only one hard-coded constant in TDX.
> >>>
> >>> I see no compelling reason to complicate KVM with support for
> >>> configurable APIC frequencies, and I see no advantages to doing so.
> >>
> >> Because TDX isn't specific to KVM, it should work with other VMM techn=
ologies.
> >> If we'd like to go for this route, the frequency would be configurable=
.  What
> >> frequency should be acceptable securely is obscure.  25MHz has long hi=
story with
> >> the real hardware.
> >
>

