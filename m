Return-Path: <kvm+bounces-59956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 67727BD6C7D
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 01:50:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF38D3BB2D9
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 23:50:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7FB82EA46C;
	Mon, 13 Oct 2025 23:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZGQt1CdM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BC029B22F
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 23:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760399402; cv=none; b=AJHiSzjRRS7zrw1l7xF6Om46WYx2AEOCCqZOaENpY3huziL/RMW2L3Q7OePpXC6t4L4aIn8I6EBCb1CQVSuO5qsbFSZklhDRBYrnfCGKUCrnKGxDX2nsjzPm25fcKnH429mOFhJXqKCgJjkVEW0pvHZ5CeS+AIOw7g5jyB4OmQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760399402; c=relaxed/simple;
	bh=p1/z9JXn/6u67zL4YtuE3iecUE2DhRP6BHFknbwMdZs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rw3tSxL/9KQglJ69M5+uNw6P7I3tvmi7T0dExixwMGvU4fNItpM9B/N7lgcwzJYVmxZZgnm3FEazyuxUjaTNx+zhX77qRcOTJd+7THFn9/xXHugjz1eOAkFr5ZPw7LCeeq/fhlvSTogpjIpKdmmw93G9LYbnTTBGisI5KadJRm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZGQt1CdM; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-78427dae77eso7432518b3a.3
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 16:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760399401; x=1761004201; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xOsqthpgUN+7hMYU4tdGq9Dk1J6tZ/phPwfI6EdZH7w=;
        b=ZGQt1CdMy96UwU17HoLyfkacLk4tu8gtHU7+TprMpNa6AbLyaJCouT4S+d47ePyBYB
         rovl2wuKOOiZp5/ncwkDsWSmQA1hGce3u+0XcP98qskZtFWthTl7GO9QuupLcsNjC8Gu
         7pdJglaKJLNg5ieSDVVf0drfukcPL++H/lpKKFv+BsuZvMammX6t0MgPrvdRCM2yj+jv
         Fai0Hm0i9HvSaI5xNo24lqCmO/fRKVsSdSUrXOyAVp5UIRKUaRoz1GeGCNc0HlCg4EZr
         9nFnaXAC+ue8UCsx4ydmOACd5DT13rbdp8KIGSSWi5/aXKO6sFnUA4RvHKMZjASRGBXZ
         72rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760399401; x=1761004201;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xOsqthpgUN+7hMYU4tdGq9Dk1J6tZ/phPwfI6EdZH7w=;
        b=IZn/yxSl4y6MUznabiDdAr1pnLlPT/riyuz7Z8oqYNZ7zWWHaaOiLyZ4mIsSrWW2hR
         9DA+Ru8joLQ3AXlpvkt+f9Jm47JtSvyC3TeBipaBj/irEvSD/HVPC5PbbrgACBqqqHeM
         i0RZgXjd/kEqhrReCTZ94JcBoX1JZi0O5eoU2f8nIFi5To/bCYOURyrfWELqA7moLVj2
         nqGopQzN02IbU8jVOkjlgyf43UvFDiQMhpRW75Vz692oWJ0Ewrtfs0K9aOKXK9i9Huoc
         4VJjWMYYKQFqpW095YSO+lFnktMZoSnTEdLPXTaT2jrkIl4pQAR1p7WYw4UYDEJozHvm
         /3lw==
X-Forwarded-Encrypted: i=1; AJvYcCWntbGffbDG9GRq2nOCFHbZf8JJr6HT3QwPLEDqroGXkmD8s6u4nwN6y5bkd0RDE8p4cEM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3p0VkZ+o8PV/BX1DumO/z/v+bMo8Qj9qR760rNLLYj/fIN/mi
	q4q7ER+x/SzZwgT/xh83FlNkBBVabqVgSrxCObR9dsq5CVj/+l3QkFA/IDgWQx4ZKFqRSJ7GuwK
	/fXBP+w==
X-Google-Smtp-Source: AGHT+IGzRn21y2SOJv+cqH5j2+OiAKh5F8oTXvdefE1kD/L60D8YTn/fnpdk+gNG0UEKzZnXP8ieD//uQt4=
X-Received: from pjbgt20.prod.google.com ([2002:a17:90a:f2d4:b0:33b:51fe:1a76])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:258f:b0:2f6:14c6:95ea
 with SMTP id adf61e73a8af0-32da8130d99mr30976889637.20.1760399400534; Mon, 13
 Oct 2025 16:50:00 -0700 (PDT)
Date: Mon, 13 Oct 2025 16:49:59 -0700
In-Reply-To: <68ed7bc0c987a_19928100ed@dwillia2-mobl4.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251010220403.987927-1-seanjc@google.com> <68ed7bc0c987a_19928100ed@dwillia2-mobl4.notmuch>
Message-ID: <aO2QJ-YapvJXxE1z@google.com>
Subject: Re: [RFC PATCH 0/4] KVM: x86/tdx: Have TDX handle VMXON during bringup
From: Sean Christopherson <seanjc@google.com>
To: dan.j.williams@intel.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"Kirill A. Shutemov" <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Xin Li <xin@zytor.com>, Kai Huang <kai.huang@intel.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, aik@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 13, 2025, dan.j.williams@intel.com wrote:
> > Emphasis on "only", because leaving VMCS tracking and clearing in KVM is
> > another key difference from Xin's series.  The "light bulb" moment on that
> > front is that TDX isn't a hypervisor, and isn't trying to be a hypervisor.
> > Specifically, TDX should _never_ have it's own VMCSes (that are visible to the
> > host; the TDX-Module has it's own VMCSes to do SEAMCALL/SEAMRET), and so there
> > is simply no reason to move that functionality out of KVM.
> > 
> > With that out of the way, dealing with VMXON/VMXOFF and EFER.SVME is a fairly
> > simple refcounting game.
> > 
> > Oh, and I didn't bother looking to see if it would work, but if TDX only needs
> > VMXON during boot, then the TDX use of VMXON could be transient.
> 
> With the work-in-progress "Host Services", the expectation is that VMX
> would remain on especially because there is no current way to de-init
> TDX.

What are Host Services?

> Now, the "TDX always-on even outside of Host Services" this series is
> proposing gives me slight pause. I.e. Any resources that TDX gobbles, or
> features that TDX is incompatible (ACPI S3), need a trip through a BIOS
> menu to turn off.  However, if that becomes a problem in practice we can
> circle back later to fix that up.

Oooh, by "TDX always-on" you mean invoking tdx_enable() during boot, as opposed
to throwing it into a loadable module.  To be honest, I completely missed the
whole PAMT allocation and imcompatible features side of things.

And Rick already pointed out that doing tdx_enable() during tdx_init() would be
far too early.

So it seems like the simple answer is to continue to have __tdx_bringup() invoke
tdx_enable(), but without all the caveats about the caller needed to hold the
CPUs lock, be post-VMXON, etc.

> > could simply blast on_each_cpu() and forego the cpuhp and syscore hooks (a
> > non-emergency reboot during init isn't possible).  I don't particuarly care
> > what TDX does, as it's a fairly minor detail all things concerned.  I went with
> > the "harder" approach, e.g. to validate keeping the VMXON users count elevated
> > would do the right thing with respect to CPU offlining, etc.
> > 
> > Lightly tested (see the hacks below to verify the TDX side appears to do what
> > it's supposed to do), but it seems to work?  Heavily RFC, e.g. the third patch
> > in particular needs to be chunked up, I'm sure there's polishing to be done,
> > etc.
> 
> Sounds good and I read this as "hey, this is the form I would like to
> see, when someone else cleans this up and sends it back to me as a
> non-RFC".

Actually, I think I can take it forward.  Knock wood, but I don't think there's
all that much left to be done.  Heck, even writing the code for the initial RFC
was a pretty short adventure once I had my head wrapped around the concept.

