Return-Path: <kvm+bounces-15869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 49E258B147F
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 22:24:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 27A05B24B1B
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 20:22:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41B7713DB8C;
	Wed, 24 Apr 2024 20:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LJWhaOBS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3728D13C9DE
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 20:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713990113; cv=none; b=HdwX2hUgzGa2XUB9Lwr9pPCEHMpvzfsitAzNTgmOSGRa2p2EpNHH1VosopceS4RiXDb6Wt9opQjf45I0afjlUfx1IUP3v0vPRobUWhekutQ9lEnBDLnzBJwKgpFYNbAcwvrYDuiI1qHCXHcGsPg/+eZAwKxvTIS2v7ghuvBvMq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713990113; c=relaxed/simple;
	bh=TGEtv5XOiits4mamBa9OAfqfGV4U4S70ayjHE1cLPf0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JCHJ37JrnPRE3m53YZO/KBF6X4w4/wOoqpHXo5pyGJBibTNWrV8AOlZqouL/X/zcgF6vvy3dJ6FPKcocv3Pe3pjetYV0IdyJMe9qYRArQSkrphoBDDwLdnWJ73CTvsFOqXFO5uN6ZSdgXLJKNHiJXhkIs/PyhMqpYrInFk0MBfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LJWhaOBS; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61b3b02f691so3824827b3.2
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 13:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713990111; x=1714594911; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kJKivmW0J/DCohVbY4PLH/Gsm5HkrpKk4PumvPQkGTk=;
        b=LJWhaOBS23+m4cbeffQxfBi2+LhQiaxH0g4aN0wnbucjwJjOE43th6w3x5Kshx4k/1
         ksdbN/ffqddNeAOLSEXHRP0jRaxbX7Mq5pLjMASW7l7reMdVrUCcm+1JmbqVCFgWqa6p
         9ypcuIzdQkWkyknbyeg6yjMPyGOoNk4dhRDK7Z1TCPMrFznKIsUS0C4Bczwd6AiKEm2L
         /XNvlN3itMS4rlQRGCrMoJhRQ/mlJsBw/sgDL59KZ4FEC+zL/5qTDiNpzkah+Emu0cp8
         XPFettXTUNO68E+4Yu30UQGHJvKxs/khMkvXnaALWx8vrx+nPO029a34YdOxWqbOF1ey
         GfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713990111; x=1714594911;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kJKivmW0J/DCohVbY4PLH/Gsm5HkrpKk4PumvPQkGTk=;
        b=tcrd2fPIairQhSZIJnEBip2J+A53KxQJ27LSRaJ60p2X9Jq9PtRdpnGsMpyD6ZAZyu
         EyiT+RcbFMS1R2keFLUkxEof8PGRDvySJaxGOJUTqJJH97UMsIsMInovXAN5g0iNK0Oc
         dvfjwRiMoVXkJTJzORwf9yyyAcevs/AjkeDvxGps3Z5UJdnsq3tDgJjw9CvsgeMGP9Gk
         reo8YaCF88HGn60ihweixVaIY127wPT3T93MS5Wp3wg3RYFmkKgDiNs4Sdrnk/8JeVn0
         p+yeuPRgzYIOrHAdpbRgMxLihN3uc4yqjerfohQgaPbxCphfncDLt+BSpdXfid/f2dD1
         l75g==
X-Gm-Message-State: AOJu0YytjwBpREq2wb+vZUKME2BBt54rVFzyQpGHMF6KAcm8zPUhXN7I
	7s+W7O+HtTEkUQc8pl/GsrZj/DPmwbNr0XRn8UiDyJXEVCTgJzHtvaUn1y95HfIPJPDXjrGK2a2
	abw==
X-Google-Smtp-Source: AGHT+IET29Be+TqLLxR1el2WX7B1TltJHuVLHw4XBc2UEobX1IG760KHrKW5Mr9mGqY0ZbBfjntc+5CKv7o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c54c:0:b0:de1:d49:7ff6 with SMTP id
 v73-20020a25c54c000000b00de10d497ff6mr385878ybe.7.1713990111258; Wed, 24 Apr
 2024 13:21:51 -0700 (PDT)
Date: Wed, 24 Apr 2024 13:21:49 -0700
In-Reply-To: <20240421180122.1650812-4-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240421180122.1650812-1-michael.roth@amd.com> <20240421180122.1650812-4-michael.roth@amd.com>
Message-ID: <Zilp3Sp5S-sljoQE@google.com>
Subject: Re: [PATCH v14 03/22] KVM: SEV: Add GHCB handling for Hypervisor
 Feature Support requests
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
	pankaj.gupta@amd.com, liam.merwick@oracle.com, 
	Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Sun, Apr 21, 2024, Michael Roth wrote:
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 6e31cb408dd8..1d2264e93afe 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -33,9 +33,11 @@
>  #include "cpuid.h"
>  #include "trace.h"
>  
> -#define GHCB_VERSION_MAX	1ULL
> +#define GHCB_VERSION_MAX	2ULL
>  #define GHCB_VERSION_MIN	1ULL

This needs a userspace control.  Being unable to limit the GHCB version advertised
to the guest is going to break live migration of SEV-ES VMs, e.g. if a pool of
hosts has some kernels running this flavor of KVM, and some hosts running an
older KVM that doesn't support v2.

