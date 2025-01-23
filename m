Return-Path: <kvm+bounces-36315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 64877A19C1F
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 02:13:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CCC83A379B
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 01:13:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB8921DFDE;
	Thu, 23 Jan 2025 01:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4qfB6XKh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C7417543
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 01:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737594823; cv=none; b=cmW3+W9xyTwKDPFD5G+FO7z1qGD9I8+fOzKx5CkPVmm3csUrnLwzSe//tLViM0iVWH/tFR3vKnq9UCgnaV+27EdzFNTme88Lt9l0b7SUa0X0MA6KkLO30g6OsFBfx3BXro85KV+vrHLfm4dz+07rECH0+3K+JbrrrbfwsUx+wjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737594823; c=relaxed/simple;
	bh=z3XvcgHnQ9BGL1j5mcuu+jWW51PKvqsfRMUpW2AUykY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aAydPczehwNwL/FeLAsr1g0bxFyEGq+hduQK+iwn7+dlIpItAYk9SCrnG0jwg5m8pwJhlhZv0ZjWI5qfvHpRzBlYusR7ri/0BJDJbb+hh45jFPS0K25mK9z0qMDvA4mjx/cq57B1T7RzeO1HMlm+lFSrVLzcjh4JhhoggC2n+ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4qfB6XKh; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-218ad674181so31549305ad.1
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 17:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737594822; x=1738199622; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NvEv9cs3fTtbrSpoe1Ar4GU1HJ9JC8Jd6SHafG80kvo=;
        b=4qfB6XKhyZqiwyIi+deTb3nRfDm33Vt6dgBtxWU7ZB4nYGhuDpFRXB3XXEE7j929U2
         BNaFWDkJpW8OXlyuIYTkJGxLnwKmQtBT3Bor3KBT3dXwRmmymNOQD7ADLpvU1rwbZSJv
         Qub4Fx/uf/tyeA2qSdXanfYwdUJGQEQO3g2qGVnf/VxQ+Dlu2SinxetivLF139ZihCHp
         vsgpfAy7K4Rs+7OykRUFIjSUktVaBQGXu+Ii5kE/o5CcoT3jl1KVcOvD+RVK7GjxDAr+
         n/okLjfbjssvvw8JFl/aS9D1H/8HbTz6kaIrZ/ZIQWbKP7twG2ycWUK5nW9O90aOQTie
         c7wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737594822; x=1738199622;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NvEv9cs3fTtbrSpoe1Ar4GU1HJ9JC8Jd6SHafG80kvo=;
        b=HqjYAgMjt2NSWPHaoSPQta4hvfGxzfEuR8Fg9dH6HbQzztziDQSioxYK7SmF5+AsC2
         4goXIK9aNENYxfn5XZWcwgibOq/tBcAH1h6VCC0xcnl8OuINWGnID7TZ2jaf9eun5qcR
         ReO2mqg/PAq4ooeQPyUNknO/+xJK9ZoRhXLhhV5s2G5aGPDfTcZfiMPhgp8NjAlhfueH
         K0umGaIXqeeZi4p/L2xds/Zhhsx+r79RkvvdqfpCn8IAXpO32sehYu04uRF3WrOieYy7
         e/WtPl++W3m4GJSPuHEcPIJOJV4T2OIOnrNzxx3l+zgspG3U5mkWoTRAGfs/HFeFg/4J
         tU8w==
X-Forwarded-Encrypted: i=1; AJvYcCW3mu9+3CarC/gcwp0s3L2VOtdYfmkCM9ZT49uCUOGHQnZYi+KUc8pEytDEZk0Ol9KuPaU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvVwtXn/+3alvOAcSYruuiaqpMgIykEM5Hw3NoDdLyWOgh7BGL
	OKDDCOLw8nmPt6dy8UN5mimT8ykx4Wmb33715WGn3sChhy0gOjj2Jos5pLckmPGEF+DLtS3ykOB
	C5Q==
X-Google-Smtp-Source: AGHT+IErH3eVKMmP7DxPuayYKJYnpcfrlOfVDZknHBFMbBBb8wDO8Y61Tj+jwzB3LnjN276vzYicptJCeDY=
X-Received: from pfbc5.prod.google.com ([2002:a05:6a00:ad05:b0:725:a760:4c72])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:240e:b0:729:425:fde4
 with SMTP id d2e1a72fcca58-72f7d2aa7efmr2196411b3a.11.1737594821755; Wed, 22
 Jan 2025 17:13:41 -0800 (PST)
Date: Wed, 22 Jan 2025 17:13:40 -0800
In-Reply-To: <87tt9q7orq.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250122161612.20981-1-fgriffo@amazon.co.uk> <87tt9q7orq.fsf@redhat.com>
Message-ID: <Z5GXxOr3FHz_53Pj@google.com>
Subject: Re: [PATCH] KVM: x86: Update Xen-specific CPUID leaves during mangling
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Fred Griffoul <fgriffo@amazon.co.uk>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 22, 2025, Vitaly Kuznetsov wrote:
> > Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
> > ---
> >  arch/x86/kvm/cpuid.c | 1 +
> >  arch/x86/kvm/xen.c   | 5 +++++
> >  arch/x86/kvm/xen.h   | 5 +++++
> >  3 files changed, 11 insertions(+)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index edef30359c19..432d8e9e1bab 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -212,6 +212,7 @@ static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2
> >  	 */
> >  	kvm_update_cpuid_runtime(vcpu);
> >  	kvm_apply_cpuid_pv_features_quirk(vcpu);
> > +	kvm_xen_update_cpuid_runtime(vcpu);
> 
> This one is weird as we update it in runtime (kvm_guest_time_update())
> and values may change when we e.g. migrate the guest. First, I do not
> understand how the guest is supposed to notice the change as CPUID data
> is normally considered static.

I don't think it does.  Linux-as-a-guest reads the info once during boot (see
xen_tsc_safe_clocksource()), and if and only if the TSC is constant and non-stop,
i.e. iff the values won't change.  

>  Second, I do not see how the VMM is
> supposed to track it as if it tries to supply some different data for
> these Xen leaves, kvm_cpuid_check_equal() will still fail.
> 
> Would it make more sense to just ignore these Xen CPUID leaves with TSC
> information when we do the comparison?

Another alternative would be to modify the register output in kvm_cpuid().  Given
that Linux reads the info once during boot, and presumably other guests do the
same, runtime "patching" wouldn't incur meaningful overhead.  And there are no
feature bits that KVM cares about, i.e. no reason KVM's view needs to be correct.

