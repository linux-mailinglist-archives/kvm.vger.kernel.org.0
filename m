Return-Path: <kvm+bounces-70341-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wIwYE/a8hGnG4wMAu9opvQ
	(envelope-from <kvm+bounces-70341-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 16:53:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AC438F4CEA
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 16:53:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 35D28305ACAB
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 15:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADC8A4266AC;
	Thu,  5 Feb 2026 15:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q+tFbijU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1B53570C4
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 15:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770306611; cv=none; b=pdY1i7W16iXFg/mzkk7wv2hn0dzVmeCQ0fSHTK7ZMa83npI3EVeDiFxQb5q0I7R1e6yrdPgDEssW9mdh/HWUzIm/KxU4j2zzgnyirlaqiYRnCWk6ucHDjTs+ep5ny3/JnNGU7B+v65TNMZzN93fCha3WAot+OLxsbKbDNfA6Imo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770306611; c=relaxed/simple;
	bh=iUZ5tnMQyhw9uCy640eejDGHzA+wNQ5AYMIrZOw3mCQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZlXOZGTHQnzy1+pPmfH0jr0lyZ8YfMTrhKeV//kGzyrKw/mqr+NVRfU2+K+miUxPfvf+L7lkKo2QzzPUi7Wcj3e+htoemZmqg24J9xoA2DG7z0qwFpFNXo2Jy6FWWE/O1COWMH8qE87d3jSxQIHcV7hEITsL3ebXIvJzU6t9uMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q+tFbijU; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34cc88eca7eso927427a91.2
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 07:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770306611; x=1770911411; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JhwK1VS71v2DkiCt5Bja3+qO4VJWz2Pt2URd2uZcACk=;
        b=Q+tFbijUIZ0KN7eFv6kvu/OGDbfybROYLOoq535qiSmhWt0Qo7Qy57QuTy1R/d31oE
         oxdUXuLU2aREzoFcoHzoBbvLs0ziGdVH42v2QKkPlCURV9ePVAoacEK3U6Njs2IvYDhp
         E3gEkVIWp51y6u7GTcfPy7q8SO6s+atcS8Rwk8zFGcaKm4Sb91/oSWtYl+bSPYWBWlid
         BflVmujolrdWrKvCVWiugVZZUVDxQGyRFI+HA32HiA5B/qxDqvTKZORhraOVbQHVsDeL
         zY0iQYZEWAmaPHxDCrBdQROvf+v9Lt9aYolOJrAgYYkFZpmX6nVqVhcVbuCSgeD6Bq0j
         TkiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770306611; x=1770911411;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JhwK1VS71v2DkiCt5Bja3+qO4VJWz2Pt2URd2uZcACk=;
        b=EoZsqEZadRm3OqnC00mvqWeMmV7mjMbhmr1TJJ05cytb43Nz2Wtv62mAdrsmS19L/a
         EyRFuSs8UhPWV0NvKz6To6UXbyX6lTkbqSDXElagDDWhJNKGRcoB+fTNW4AnuY7EvB+x
         gxstBZqZf9gZuXjBe3z1mQ6VPFBUnOGVRcdDOaeaGbix43JyacbAIPoKkGsuvN3yJZFb
         iHYSMhyBFg6K734mpbpMyWtyYkWSfvlEMS2Y/iMZZaWT+tLYL6plX33spKhgY2jRyiu9
         97w88QEnglurnEsZ/fB0cOo8uMGuxHaLLdlA6JfbqlaBgXjbtZ/+mXtw7WPqp0kZDuUT
         4jwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZeIET5c5FCP6hHESdSZPs+dFomn4WtrHJJLFtWrmlS0VpRQ+9dlu3UdGEIwW1B6xC/2s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfyoTmGx7arLAgWiWq2XL0ardrCh6p+7Bp0SxHqROyR65w78OD
	pyOJIUvFaUjuxUW3KZvAEwRfQefYBDMjFnDyiLxzHLW+fPCcTRPrul0gRWf9TmuYxXzf1qy05Ay
	uL9fJ0w==
X-Received: from pjps6.prod.google.com ([2002:a17:90a:a106:b0:352:ba61:b351])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5102:b0:354:a332:1a61
 with SMTP id 98e67ed59e1d1-354a3321ccemr1617875a91.5.1770306611136; Thu, 05
 Feb 2026 07:50:11 -0800 (PST)
Date: Thu, 5 Feb 2026 07:50:09 -0800
In-Reply-To: <2026020546-wrongness-duplex-bccd@gregkh>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260205051030.1225975-1-nikunj@amd.com> <2026020559-igloo-revolver-1442@gregkh>
 <59781811-a98b-4289-89e4-58e8247241f8@amd.com> <2026020546-wrongness-duplex-bccd@gregkh>
Message-ID: <aYS8MQLcGs08PxYK@google.com>
Subject: Re: [PATCH] x86/fred: Fix early boot failures on SEV-ES/SNP guests
From: Sean Christopherson <seanjc@google.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	bp@alien8.de, thomas.lendacky@amd.com, tglx@kernel.org, mingo@redhat.com, 
	dave.hansen@linux.intel.com, hpa@zytor.com, xin@zytor.com, 
	pbonzini@redhat.com, x86@kernel.org, jon.grimm@amd.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70341-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[15];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:email]
X-Rspamd-Queue-Id: AC438F4CEA
X-Rspamd-Action: no action

On Thu, Feb 05, 2026, Greg KH wrote:
> On Thu, Feb 05, 2026 at 11:40:11AM +0530, Nikunj A. Dadhania wrote:
> > 
> > 
> > On 2/5/2026 11:25 AM, Greg KH wrote:
> > > On Thu, Feb 05, 2026 at 05:10:30AM +0000, Nikunj A Dadhania wrote:
> > >> FRED enabled SEV-ES and SNP guests fail to boot due to the following
> > >> issues in the early boot sequence:
> > >>
> > >> * FRED does not have a #VC exception handler in the dispatch logic
> > >>
> > >> * For secondary CPUs, FRED is enabled before setting up the FRED MSRs, and
> > >>   console output triggers a #VC which cannot be handled
> > >>
> > >> * Early FRED #VC exceptions should use boot_ghcb until per-CPU GHCBs are
> > >>   initialized
> > >>
> > >> Fix these issues to ensure SEV-ES/SNP guests can handle #VC exceptions
> > >> correctly during early boot when FRED is enabled.
> > >>
> > >> Fixes: 14619d912b65 ("x86/fred: FRED entry/exit and dispatch code")
> > >> Cc: stable@vger.kernel.org # 6.9+
> > >> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> > >> ---
> > >>
> > >> Reason to add stable tag:
> > >>
> > >> With FRED support for SVM here 
> > >> https://lore.kernel.org/kvm/20260129063653.3553076-1-shivansh.dhiman@amd.com,
> > >> SVM and SEV guests running 6.9 and later kernels will support FRED.
> > >> However, *SEV-ES and SNP guests cannot support FRED* and will fail to boot
> > >> with the following error:
> > >>
> > >>     [    0.005144] Using GB pages for direct mapping
> > >>     [    0.008402] Initialize FRED on CPU0
> > >>     qemu-system-x86_64: cpus are not resettable, terminating
> > >>
> > >> Three problems were identified as detailed in the commit message above and
> > >> is fixed with this patch.
> > >>
> > >> I would like the patch to be backported to the LTS kernels (6.12 and 6.18) to
> > >> ensure SEV-ES and SNP guests running these stable kernel versions can boot
> > >> with FRED enabled on FRED-enabled hypervisors.
> > > 
> > > That sounds like new hardware support, if you really want that, why not
> > > just use newer kernel versions with this fix in it?  Obviously no one is
> > > running those kernels on that hardware today, so this isn't a regression :)

I disagree, this absolutely is a regression.  Kernels without commit 14619d912b65
will boot on this "new" hardware, kernels with the commit will not.

> > Fair point.
> > 
> > However, the situation is a bit nuanced: FRED hardware is available now, and
> > users running current stable kernels as guests will encounter boot
> > failures when the hypervisor is updated to support FRED. While not a traditional
> > regression, it creates a compatibility gap where stable guest kernels cannot run
> > on updated hypervisors.
> 
> Great, then upgrade those guest kernels as they have never been able to
> run on those hypervisors :)

As above, *upgrading* from e.g. 6.6 to 6.12 will suddenly fail to boot.

> > Other option would be to disable FRED for SEV-ES and SNP guest in stable kernel.
> 
> That's a choice for the hypervisor vendors to choose.

No, because the hypervisor has no clue what kernel version the guest is running.

