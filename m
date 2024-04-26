Return-Path: <kvm+bounces-16079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F8E38B408F
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 21:57:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9FFC11F24252
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 19:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BEDD22F02;
	Fri, 26 Apr 2024 19:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DUJoHdQg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79935208AF
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 19:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714161432; cv=none; b=ssAEyfQkIcuxuEMAUsCvQOIsWwzGjJCTGsQ0/P/kNWkBmYy4vqZm/1wHGc9EDoUNxvRQcPPNi/HkXtIqSfn6grujZD0k3jD+rwydX1nMYKu/89IAdW1gRV/taTQC/hi4r3JYzREKaS/40mYuCqEOv+ELA9b9Qs0ZcR7q2JARpPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714161432; c=relaxed/simple;
	bh=4Tl6Q7eOW4o1xylpHfLT20dEfliDc3ACOmwo+d+76q8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sl3qHIAXzbyR9ldWv6zliZgznq2US2XbNsXGcisBbKpOmCyvTzKH665Qae30cRYK8OrK3RYfhzRJxZyTfJdA6yxafTtzEnsm/Udm/Jl9rUm1IyZwwsv0AmaTLhI1ieqRBvsoljcTz7o6h4WQBODCJ72RJX1B4+RNTBBu5fCrN24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DUJoHdQg; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61acc68c1bdso38189177b3.1
        for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 12:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714161430; x=1714766230; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7JHOwynv12T0Y/tQm4DZx8daXixOsghTKfdQCt+IwUg=;
        b=DUJoHdQgSkNEv5FFc8d+51AkMU+KSLEf78ghN7IpvWkZ5WN1FWM6w5GzUr2KJKHUbr
         xAo42I0B9Jqc/lZeeIx3HPSVaoNuOqcqpRY8wonTdKJM6ER64qrQ+CYXuvETyBK4n8I8
         COoXCR10OC7ZU3ShH9dzB9wgVdWV6wqXO/dSLeNWhjbKuXxkzO0iyHg8Ad6iuI1CcOP7
         EiYsnfGWMAb4YNxPTjAyhtIgSIsGvYNaFwZpHpNqd7yG6nlhAtrx6VmwaxIXxLR/wPcY
         9OGStJ5EAuG7qgqV10d/7DDMve6LOSUA1dAynGbSieZYe4PVCorFHfPkzhCHgjtTmMbf
         8dyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714161430; x=1714766230;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7JHOwynv12T0Y/tQm4DZx8daXixOsghTKfdQCt+IwUg=;
        b=J2FrRknrndepJvO7eqfFAzK8EypuhkVkw8rUzD7npZLrzcMeDaOonsnPsrHKdu5iLs
         j+mOjxBAWdyHX/TaVX93P6sS4e2sMKBkgUEtthr9VCoeRb0N73n4/Mnh215MtU2T8CKZ
         XQaxegdtwXchFnoSPxuE0K2xPvymdrvAoOQ8+4v2VefMNIQbtzKpySNQ+pvQ/mshCAsQ
         ZxmMxFSthwdNjhFOasIVlwL0BA7scKOtPpUfY7UXKzvDfLfvZpScmAfE6kH9CQS+ZZ62
         m20G7IgIyoBtsNUHlnpT8GwLc6hh53a2yDjOPQ6svvkSzm7K2dCIX/zCrAFJTi4pkkTS
         IqHQ==
X-Gm-Message-State: AOJu0Yy5XpUpmBQ/29QmQyTBUBsFdzFYIPbFm01s3E1p1QQHAgtXqN8B
	ZbRTbyEDjyoekKcEWIrqS6WLE00JVQ8ljGd71JfbZ6SCVzHJFjAs2jdRVNsVAE0hcz7GfL1iIjO
	nrQ==
X-Google-Smtp-Source: AGHT+IGVs0AhQC/2tCuBf1vwuuUKjoCfCrLrEQi6QfgrOK53aglDlk7/orKA5npkCNzcOFKzvJ7EPkWyDNk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:9e13:0:b0:61a:d420:3b57 with SMTP id
 m19-20020a819e13000000b0061ad4203b57mr174224ywj.0.1714161430548; Fri, 26 Apr
 2024 12:57:10 -0700 (PDT)
Date: Fri, 26 Apr 2024 12:57:08 -0700
In-Reply-To: <20240426173515.6pio42iqvjj2aeac@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240421180122.1650812-1-michael.roth@amd.com>
 <20240421180122.1650812-22-michael.roth@amd.com> <ZimgrDQ_j2QTM6s5@google.com>
 <20240426173515.6pio42iqvjj2aeac@amd.com>
Message-ID: <ZiwHFMfExfXvqDIr@google.com>
Subject: Re: [PATCH v14 21/22] crypto: ccp: Add the SNP_{PAUSE,RESUME}_ATTESTATION
 commands
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 26, 2024, Michael Roth wrote:
> On Wed, Apr 24, 2024 at 05:15:40PM -0700, Sean Christopherson wrote:
> > On Sun, Apr 21, 2024, Michael Roth wrote:
> > > These commands can be used to pause servicing of guest attestation
> > > requests. This useful when updating the reported TCB or signing key with
> > > commands such as SNP_SET_CONFIG/SNP_COMMIT/SNP_VLEK_LOAD, since they may
> > > in turn require updates to userspace-supplied certificates, and if an
> > > attestation request happens to be in-flight at the time those updates
> > > are occurring there is potential for a guest to receive a certificate
> > > blob that is out of sync with the effective signing key for the
> > > attestation report.
> > > 
> > > These interfaces also provide some versatility with how similar
> > > firmware/certificate update activities can be handled in the future.
> > 
> > Wait, IIUC, this is using the kernel to get two userspace components to not
> > stomp over each other.   Why is this the kernel's problem to solve?
> 
> It's not that they are stepping on each other, but that kernel and
> userspace need to coordinate on updating 2 components whose updates need
> to be atomic from a guest perspective. Take an update to VLEK key for
> instance:
> 
>  1) management gets a new VLEK endorsement key from KDS along with

What is "management"?  I assume its some userspace daemon?

>     associated certificate chain
>  2) management uses SNP_VLEK_LOAD to update key
>  3) management updates the certs at the path VMM will grab them
>     from when the EXT_GUEST_REQUEST userspace exit is issued
> 
> If an attestation request comes in after 2), but before 3), then the
> guest sees an attestation report signed with the new key, but still
> gets the old certificate.
> 
> If you reverse the ordering:
> 
>  1) management gets a new VLEK endorsement key from KDS along with
>     associated certificate chain
>  2) management updates the certs at the path VMM will grab them
>     from when the EXT_GUEST_REQUEST userspace exit is issued
>  3) management uses SNP_VLEK_LOAD to update key
> 
> then an attestation request between 2) and 3) will result in the guest
> getting the new cert, but getting an attestation report signed with an old
> endorsement key.
> 
> Providing a way to pause guest attestation requests prior to 2), and
> resume after 3), provides a straightforward way to make those updates
> atomic to the guest.

Assuming "management" is a userspace component, I still don't see why this
requires kernel involvement.  "management" can tell VMMs to pause attestation
without having to bounce through the kernel.  It doesn't even require a push
model, e.g. wrap/redirect the certs with a file that has a "pause" flag and a
sequence counter.

