Return-Path: <kvm+bounces-33219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E72279E763B
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 17:37:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1D3E16B243
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 16:36:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C308204564;
	Fri,  6 Dec 2024 16:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NU6NuoZy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79C21FFC66
	for <kvm@vger.kernel.org>; Fri,  6 Dec 2024 16:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733502884; cv=none; b=NngwZCaoiNKMjDYzkmYKA7+5Wi2THFTJsjJ2boLCIXFQZJtmnXj/ptzDGkdOombFBwzDFbA/DjZYJJBupdh8NNiw+fdxdB7Mk32C9l0GJ0mQN82e3U5v37ZubI5mdiyaVmg7i4afaRv1LnI/dUXqClrBwv4gWx4xyiSHxuuVMKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733502884; c=relaxed/simple;
	bh=X/j7a1AVVEbEIsus9GgwJm7rtls7Wp7Nn7vlOuWizNM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YDIcU1WrKpnt4hZjcANqdDIrI5iqANL2xYNJLVEECS8cO7POhFG3qUJoRtJ+l4Nzfpe7Vu2M4UaxXJl3OmBp4HQtbzKKVmcWcE9n+T8txk7u7ekfdI3g6bnR2AD2+ZSpHOoy8VtKDPaa/fPOggs3esLWgSDBXlpOII22k4g7s+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NU6NuoZy; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7fd312feb10so168342a12.1
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2024 08:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733502882; x=1734107682; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gdOhbbudcsT18ChsyehuzpKH7u9A/Whi1QSUHUKo4+Y=;
        b=NU6NuoZy9DCICJreU2FW58c/e/w/TZyvMtChADpm9jA4S9h21xuRmsV5qNyC3WVoiO
         zlI7km9E89b0bnxDxU9Am1c+xjhlqqfhNn8biSw8csTuWOi0b2JYtlip/LLz+B9DZ5lI
         Bb2gesgKgwwQnH2xhkcrLJbe3R39wDGc+dgyOY/rBxl6ANqtudoFb9e4imyUO8YMv5/Z
         AIscqjyLSU/jo935utTZYyIJvir/IqiFjknmeWffWDTZL1J7516KG1EIGgDGISGVqaK3
         Uy0Z00kZ03FOIzu5p/R3mx8r8JVhBSv8uTmv9oGhYZoYKj499iQ7eWnvmU9PCpuwjilw
         xamQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733502882; x=1734107682;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gdOhbbudcsT18ChsyehuzpKH7u9A/Whi1QSUHUKo4+Y=;
        b=X1kOMe7bItg7CV+KWfxT1u/HYrLKZcAOTNFWK1LzSoERPkAlesdE6Y1BxQ4IFV9aE1
         hyScEySStLto+LBxlO1w7OWuou0OAYBNxyZPkDUAySyhxnZ0Tkjfsk6LSWUmmg83fCM3
         d5QJ9ocHjavqdgSelgWOFLJdkb2dySmmf5hSRasuKgW0ZISacGLq2Z6tQ5SViwq3fSH1
         byXGVaWd+YpB4aJBy4vuzfLsDdbqpseePDwC6gPijcu+v/sGOVHhOlHhSm2bvtAePMeP
         LMQ+g5qYU0q3mG89GrHQpFPpCEWHVe7edI/mR4fiPeT7yRYsJpvymujHrDMOxkBqtPo8
         OoVw==
X-Forwarded-Encrypted: i=1; AJvYcCWpLzo1PN2Y+mhQdQWE0xSSKHsNQ1teWx6bQX8riQwiYBA8NCGFVGOOgMiOdYI9Wklv8Co=@vger.kernel.org
X-Gm-Message-State: AOJu0YylK19S+8FQh5n5bgQXg30osVdu0HxXMNuQDgE+4trRADK9ECG4
	x1BfB+OqSf+Aqut8NofkeovB6AWkFb28k94y8+C18tsSRgoIbfV+XaGvdITZQCMz8k4n1EEeeAq
	P8A==
X-Google-Smtp-Source: AGHT+IEjRw7QnXc1P/zcq6HHCb1Idg91IQ175oHpS+xymlvayAU568Tah/7yfMxhEt8DbssELS7lXeZX1d0=
X-Received: from pgct14.prod.google.com ([2002:a05:6a02:528e:b0:7fd:113b:ea45])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:114f:b0:1e0:c56f:7daf
 with SMTP id adf61e73a8af0-1e1870a8df8mr5765535637.6.1733502882145; Fri, 06
 Dec 2024 08:34:42 -0800 (PST)
Date: Fri, 6 Dec 2024 08:34:41 -0800
In-Reply-To: <CALMp9eRqHkiZMMJ2MDXOHPbGx1rE9n5R2aR-F=qkuGo0BPS=og@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121185315.3416855-1-mizhang@google.com> <Z0-R-_GPWu-iVAYM@google.com>
 <CALMp9eTCe1-ZA47kcktTQ4WZ=GUbg8x3HpBd0Rf9Yx_pDFkkNg@mail.gmail.com>
 <Z0-3bc1reu1slCtL@google.com> <CALMp9eRqHkiZMMJ2MDXOHPbGx1rE9n5R2aR-F=qkuGo0BPS=og@mail.gmail.com>
Message-ID: <Z1MnoQcYpzE-4EZy@google.com>
Subject: Re: [RFC PATCH 00/22] KVM: x86: Virtualize IA32_APERF and IA32_MPERF MSRs
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Mingwei Zhang <mizhang@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Huang Rui <ray.huang@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Perry Yuan <perry.yuan@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 04, 2024, Jim Mattson wrote:
> Wherever the context-switching happens, I contend that there is no
> "clean" virtualization of APERF. If it comes down to just a question
> of VM-entry/VM-exit or vcpu_load()/vcpu_put(), we can collect some
> performance numbers and try to come to a consensus, but if you're
> fundamentally opposed to virtualizing APERF, because it's messy, then
> I don't see any point in pursuing this further.

I'm not fundamentally opposed to virtualizing the feature.  My complaints with
the series are that it doesn't provide sufficient information to make it feasible
for reviewers to provide useful feedback.  The history you provided is a great
start, but that's still largely just background information.  For a feature as
messy and subjective as APERF/MPERF, I think we need at least the following:

  1. What use cases are being targeted (e.g. because targeting only SoH would
     allow for a different implementation).
  2. The exact requirements, especially with respect to host usage.  And the
     the motivation behind those requirements.
  3. The high level design choices, and what, if any, alternatives were considered.
  4. Basic rules of thumb for what is/isn't accounted in APERF/MPERF, so that it's
     feasible to actually maintain support long-term.

E.g. does the host need to retain access to APERF/MPERF at all times?  If so, why?
Do we care about host kernel accesses, e.g. in the scheduler, or just userspace
accesses, e.g. turbostat?

What information is the host intended to see?  E.g. should APERF and MPERF stop
when transitioning to the guest?  If not, what are the intended semantics for the
host's view when running VMs with HLT-exiting disabled?  If the host's view of
APERF and MPREF account guest time, how does that mesh with upcoming mediated PMU,
where the host is disallowed from observing the guest?

Is there a plan for supporting VMs with a different TSC frequency than the host?
How will live migration work, without generating too much slop/skew between MPERF
and GUEST_TSC?

I don't expect the series to answer every possible question upfront, but the RFC
provided _nothing_, just a "here's what we implemented, please review".

