Return-Path: <kvm+bounces-11162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 97D6A873C85
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:45:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1AF2B1F21EAD
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 16:45:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D6F7137934;
	Wed,  6 Mar 2024 16:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oT3UjOFp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E889135418
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 16:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709743521; cv=none; b=Kl7LFafq0O7o4BfcogLnPapofy8TrQ3eV4cj+wZtSem9tyTfesaRMqnCIZLDxUrlFByPNq2KsW6di09rbGi2T+60RfPTMSO+hsHFfo5xZJTlKgIeYZHLFV4OSN5/ArH4amJyuLkqgah7nUlkQ50ED65l7NDcoj2gP97btow/Wjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709743521; c=relaxed/simple;
	bh=4h2+ccgnnm7BOvBn+5jjhRD3CpCSaSxs1q/2EbjETd0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K8xxO2oVcCl4SicAhB6AZ8XTawjzdBPYWwlGtm06rXPtkMcOcL10z8PwXIeOG3JzwV/bJsFDPTTA6epilZUBp0FphjF5z/qABt9YVJpnYtCigMVJMoLkX+5CjOUSpn7KF8IcmBa+eMsb+45Z+otttaHrahWjtAjfFH2vu9i43K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oT3UjOFp; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60802b0afd2so10154057b3.1
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 08:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709743519; x=1710348319; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nIsCFmhpWTW8fxuoFcfHLz0Rx4rMwL+WRCdnBbQqrps=;
        b=oT3UjOFpJPOUZ718+iKA8cKCe106L4rLrqikIiwuKEcJ35Erj9pNoN/puCfWnEnBUq
         wxSOJfE/5TkCceANj6AqO3W3/A0HbAkV+P4DLPnmfRa1/pBRy3qSoX9kXvznZFwktNZt
         5rgkG/pUj7kDG/wRDQZ1n1CdG03YxNzTUXXzYfOvYNREqCMfSVVH3Hos24LWpeUy2mJl
         XuqEnWM6drDAIIuqPhB4/aWqSRMpxgQqIpVGpof/5GzOzAgFEg7df3MY6yUqkWnJBokh
         6AKN8VPtMQz84hEIbBJlx9YJSEFb5MvG441FfmlAHjN8HpDRQ9vsdpiV3dewjnjUo0WY
         vJWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709743519; x=1710348319;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nIsCFmhpWTW8fxuoFcfHLz0Rx4rMwL+WRCdnBbQqrps=;
        b=bi263RJWLqtvo/tquOuH+U/l3jFqf9cyfx6qbNiBRNmToWwwS2qfNwllDbk8SRC3NW
         cfQMajJ7lxOuagM6JdJg9DIcb1hkuhOHgbCuInTnMBHtbI0+hh85J4pKI6dJkVYMcNYf
         MKUUG6dmT+hHF21cCpzhPNJLZqy+kR4iwwsKAQdJk0/SM8NK8coeqGCvmF8AzVxQqldZ
         HUeqrZAQySZe++VjoqVEPzD/rV0+5CHcKXKpz5f1uIzMWQiiQTimxLwR7a/fsbXqZNVl
         3U8qs85KHNhJp+du9eaNpierw+AU68fKTTqoWhyZ7LiaRzKGsHDQ/f19X8cTLfu0Ap8W
         nb4A==
X-Forwarded-Encrypted: i=1; AJvYcCXtPVZLTkLlLsZz5tH+sH4aaPOO+HFC/+tFOayb7SUMKDNNmfh5KsEirQMfLH6kCZoHqbqLG5C3ZYPE1C1o/3rmex1r
X-Gm-Message-State: AOJu0Yzyl44ZWRJqKVeq4ER2HFFPkjKJcjRXcz90qekNGadw64EDeI6i
	+qKMqcTvOc8Iv1zR1XPPzFAuJHWID73K/KSkej6mvADxF3bIMnOGcpqdIsh9OhOm/3cdFvX8wSY
	vYg==
X-Google-Smtp-Source: AGHT+IFjfJotvxJ8vPf8sI+9CDo37YHTT6sLO5DzRvYUKGyGWuNZ8zheCdzzRe+bcWeuAf9lBuohBf98uEg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:d104:0:b0:609:82e7:c0b with SMTP id
 w4-20020a81d104000000b0060982e70c0bmr1162866ywi.3.1709743519455; Wed, 06 Mar
 2024 08:45:19 -0800 (PST)
Date: Wed, 6 Mar 2024 08:45:17 -0800
In-Reply-To: <76744e4b-361d-43ae-9a52-6a410ed57303@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <1880816055.4545532.1709260250219.JavaMail.zimbra@sjtu.edu.cn>
 <ZeYK-hNDQz5cFhre@google.com> <edd86a97-b2ef-49e6-aa2b-16b1ef790d96@amd.com>
 <Zee2ogAOl8cR4vNZ@google.com> <76744e4b-361d-43ae-9a52-6a410ed57303@amd.com>
Message-ID: <ZeidnSrRcRkUe7gh@google.com>
Subject: Re: [PATCH] KVM:SVM: Flush cache only on CPUs running SEV guest
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Zheyun Shen <szy0127@sjtu.edu.cn>, pbonzini@redhat.com, tglx@linutronix.de, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Mar 06, 2024, Tom Lendacky wrote:
> On 3/5/24 18:19, Sean Christopherson wrote:
> > On Tue, Mar 05, 2024, Tom Lendacky wrote:
> > > On 3/4/24 11:55, Sean Christopherson wrote:
> > > > +Tom
> > > > 
> > > > "KVM: SVM:" for the shortlog scope.
> > > > 
> > > > On Fri, Mar 01, 2024, Zheyun Shen wrote:
> > > > > On AMD CPUs without ensuring cache consistency, each memory page reclamation in
> > > > > an SEV guest triggers a call to wbinvd_on_all_cpus, thereby affecting the
> > > > > performance of other programs on the host.
> > > > > 
> > > > > Typically, an AMD server may have 128 cores or more, while the SEV guest might only
> > > > > utilize 8 of these cores. Meanwhile, host can use qemu-affinity to bind these 8 vCPUs
> > > > > to specific physical CPUs.
> > > > > 
> > > > > Therefore, keeping a record of the physical core numbers each time a vCPU runs
> > > > > can help avoid flushing the cache for all CPUs every time.
> > > > 
> > > > This needs an unequivocal statement from AMD that flushing caches only on CPUs
> > > > that do VMRUN is sufficient.  That sounds like it should be obviously correct,
> > > > as I don't see how else a cache line can be dirtied for the encrypted PA, but
> > > > this entire non-coherent caches mess makes me more than a bit paranoid.
> > > 
> > > As long as the wbinvd_on_all_cpus() related to the ASID flushing isn't
> > > changed, this should be ok. And the code currently flushes the source pages
> > > when doing LAUNCH_UPDATE commands and adding encrypted regions, so should be
> > > good there.
> > 
> > Nice, thanks!
> > 
> > > Would it make sense to make this configurable, with the current behavior the
> > > default, until testing looks good for a while?
> > 
> > I don't hate the idea, but I'm inclined to hit the "I'm feeling lucky" button.
> > I would rather we put in effort to all but guarantee we can do a clean revert in
> > the future, at which point a kill switch doesn't add all that much value.  E.g.
> > it would allow for a non-disruptive fix, and maybe a slightly faster confirmation
> > of a bug, but that's about it.
> > 
> > And since the fallout from this would be host data corruption, _not_ rebooting
> > hosts that may have been corrupted is probably a bad idea, i.e. the whole
> > non-disruptive fix benefit is quite dubious.
> > 
> > The other issue is that it'd be extremely difficult to know when we could/should
> > remove the kill switch.  It might be months or even years before anyone starts
> > running high volume of SEV/SEV-ES VMs with this optimization.
> 
> I can run the next version of the patch through our CI and see if it
> uncovers anything. I just worry about corner cases... but then that's just
> me.

Heh, it's definitely not just you, this scares me more than a bit.

Doh, I realize I misread your suggestion (several times).  You're suggesting we
make this opt-in.  Hmm, that's definitely more valuable than a kill switch, though
it has the same problem of us having no idea when it's safe to enable by default.
And I'm not sure I like the idea of having a knob that basically says, "we think
this works, but we're too scared to enable it by default, so _you_ should totally
enable it and let us know if we've corrupted your data" :-)

