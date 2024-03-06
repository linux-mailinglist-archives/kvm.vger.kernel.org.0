Return-Path: <kvm+bounces-11082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E8EF872BAD
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 01:20:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 960D21C21830
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 00:19:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91B46C8C7;
	Wed,  6 Mar 2024 00:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ismIrwIF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77026320A
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 00:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709684389; cv=none; b=i+XjfF18j1MDDO+CjXCPj/QrjACVGRe3r87V11FgybRRVk/9WbV5Z327CbfIPZ8JyOurePAGFuIvJmWe0kJVuCK2uEAjnpBlhISYL8cC0IQH9Xmwfwv4J2oT+ugnz/DdM2xyX1pULuN2gFjhvSiVsHhwTEthd1zIAgZC2rotCB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709684389; c=relaxed/simple;
	bh=l5Z4UTiZAV0FnKHADONYXORI5k3mrUH4FrHUJ/WTslc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K5fXZpa2LH0siUbsM6MLPLa7ao5B6yaoUrPuDxof0r0CZyuUseFEqFHLpb6OeXduqhz1giD6uXSo1wpXK25hg0MPsiNrVn++OQPIdn2LcSG5a4vS3FeHRdfEfO4lSeF9astUP2IGgBtFkAGoNClK9i15WjOZNKjggZ8TQGdn9P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ismIrwIF; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5dc91de351fso237149a12.0
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 16:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709684388; x=1710289188; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OlafunnuQDmjQI6RGQQ8IG6bwWUsRoZnzCla50xupzE=;
        b=ismIrwIFvYMISOdBkmI7N5m/tcB87kkhyGIVzc6/DuXBo1KZlReryVhSBwUwyZQzv1
         GiwuJcHMILNr9RzHT4QGpxrFSsbBNhpKb/5zTt3AeV2MLpw40LYbiV16PowI7YIWOqT3
         cQEW6lYRc3tP9M+1l3slyaNBTpwRxDuYwD803IgBxDUqnEa+Srq8lrxQgWouvT14zXFe
         XfEHm6IzuB/1iPtw9v3Q9SUc0ChBDLSV0bttZbQyPKQrKAwTGV0fGiPiUCyt2B5XpCKv
         ScI06BMWPfNGlnZsHcaN33S2wslMwQnT9BvxsXXmJs3iTvU2FmnEb1EgSZpOlxhF3l+n
         CMCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709684388; x=1710289188;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OlafunnuQDmjQI6RGQQ8IG6bwWUsRoZnzCla50xupzE=;
        b=H83MXlDV+AyGayakIgqfEV+FrOsfXLre2PEzBRCu2A2SXmsL7h6DE3dCudtpwbZtDO
         ngoEwhgEnRMIG3F9M3KiWPKQzdusP7ThQyYZXFgOhS4uniQAdgGjrSYLPx2iSrB5w641
         U7czJO3ZM8NG0Sw1dwOqrtLAyKkuQTj8DarmyaoVaP5F0RG6vnTUk3erKpKx8CEN2euT
         mCrSltYTMhGwwokfNj8KVfXzp3IQgm89G5Bd+/bxcjanITmqMwZb/Iq7vRelB6qCQq6f
         BGAUMCSFAV1PfoOLg9gpNQGfS5p0QWmYt7CpGk1XKhgwWtGwWorckz3BaSTVEA4JDKmo
         1trw==
X-Forwarded-Encrypted: i=1; AJvYcCUFIHxA6gcuyi5WTGBw33KfmLTpUL+2FfdtHYbKuKozmStYIuQhlI55Je0TNu0aEMb6n6rtayJ66N5gL4Tj5lRwre+s
X-Gm-Message-State: AOJu0YwaU8dNL5SPIXqqQZw1xftHB9MI8FFn5NwWUx3EbO2eerl34lji
	Bfk6wjyqSxxPfThQaO8aFlAUlp3Zn15H0vRO309DkSOOyHSbCL/3KLBfCiZn+aRtCmG1aOmIh61
	N1w==
X-Google-Smtp-Source: AGHT+IGnRNghV9U0qTiTeThRt68W4kCSoa4n/bzHUjWD8qRkEmjsgFZT0aiuWc8DkWGKfbQn5Mz5agbV/hI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:f311:0:b0:5dc:4a5f:a5ee with SMTP id
 l17-20020a63f311000000b005dc4a5fa5eemr11899pgh.1.1709684387635; Tue, 05 Mar
 2024 16:19:47 -0800 (PST)
Date: Tue, 5 Mar 2024 16:19:46 -0800
In-Reply-To: <edd86a97-b2ef-49e6-aa2b-16b1ef790d96@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <1880816055.4545532.1709260250219.JavaMail.zimbra@sjtu.edu.cn>
 <ZeYK-hNDQz5cFhre@google.com> <edd86a97-b2ef-49e6-aa2b-16b1ef790d96@amd.com>
Message-ID: <Zee2ogAOl8cR4vNZ@google.com>
Subject: Re: [PATCH] KVM:SVM: Flush cache only on CPUs running SEV guest
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Zheyun Shen <szy0127@sjtu.edu.cn>, pbonzini@redhat.com, tglx@linutronix.de, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 05, 2024, Tom Lendacky wrote:
> On 3/4/24 11:55, Sean Christopherson wrote:
> > +Tom
> > 
> > "KVM: SVM:" for the shortlog scope.
> > 
> > On Fri, Mar 01, 2024, Zheyun Shen wrote:
> > > On AMD CPUs without ensuring cache consistency, each memory page reclamation in
> > > an SEV guest triggers a call to wbinvd_on_all_cpus, thereby affecting the
> > > performance of other programs on the host.
> > > 
> > > Typically, an AMD server may have 128 cores or more, while the SEV guest might only
> > > utilize 8 of these cores. Meanwhile, host can use qemu-affinity to bind these 8 vCPUs
> > > to specific physical CPUs.
> > > 
> > > Therefore, keeping a record of the physical core numbers each time a vCPU runs
> > > can help avoid flushing the cache for all CPUs every time.
> > 
> > This needs an unequivocal statement from AMD that flushing caches only on CPUs
> > that do VMRUN is sufficient.  That sounds like it should be obviously correct,
> > as I don't see how else a cache line can be dirtied for the encrypted PA, but
> > this entire non-coherent caches mess makes me more than a bit paranoid.
> 
> As long as the wbinvd_on_all_cpus() related to the ASID flushing isn't
> changed, this should be ok. And the code currently flushes the source pages
> when doing LAUNCH_UPDATE commands and adding encrypted regions, so should be
> good there.

Nice, thanks!

> Would it make sense to make this configurable, with the current behavior the
> default, until testing looks good for a while?

I don't hate the idea, but I'm inclined to hit the "I'm feeling lucky" button.
I would rather we put in effort to all but guarantee we can do a clean revert in
the future, at which point a kill switch doesn't add all that much value.  E.g.
it would allow for a non-disruptive fix, and maybe a slightly faster confirmation
of a bug, but that's about it.

And since the fallout from this would be host data corruption, _not_ rebooting
hosts that may have been corrupted is probably a bad idea, i.e. the whole
non-disruptive fix benefit is quite dubious.

The other issue is that it'd be extremely difficult to know when we could/should
remove the kill switch.  It might be months or even years before anyone starts
running high volume of SEV/SEV-ES VMs with this optimization.

