Return-Path: <kvm+bounces-20570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6424A9189E5
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 19:14:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C0E3BB2286F
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 17:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CD4618FDC0;
	Wed, 26 Jun 2024 17:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NI3jKCgH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EA418FDAF
	for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 17:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719422028; cv=none; b=JDrQAiBoyaWSLFA3OD4q+VSZOcWjR0Y3WlDLYD936R2QzbTElexUDs61OGcuFxBJ0QkDthLwPojL+t+j/nXjwh1B1C9YorjWR9R+rNa1cUxSwTjkZeHvUC4+85d8b3dOiimGq3/mrnbXWS2KAayIDXjofwjyALZgu7eaLl17cYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719422028; c=relaxed/simple;
	bh=7+9pW6VPOl8JWdal9zejXeZCcwzeiZ8F+LDpocNBT84=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=STlyyjX+v+v2vl5jHjpRUFD6OVFNig1il4yOGJYvnJYgY1CVNXGKhPLmsAhbpX+iDELfd4Kytht4ekidkUIR2BiT0csBtF0wmJJtnxjTwD91W0cx+G9EQdHDUNfxylkPsstf5I1RTjxLNquB3hSJZQ5kILz1aBOX9tGatn8F8mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NI3jKCgH; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6313189f622so154364207b3.2
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 10:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719422026; x=1720026826; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sq1NG/a/h0TZsAI2XZ3QDBZsq03pVAcY6r8Z/zu7ZOc=;
        b=NI3jKCgHWDPJ8N3WzMeXg11jiVPrj0WW8SH0INy/Dtg4ZGo8cszRAadwBVe50/qLyb
         Ec1vQ8sBjjJpuYAXdWlt/B6Y1bMzvDl6pWO9NXdT+kTXNOTsRszLIizS0erYZcaYM+Aw
         P39F/W4zcSS8Tg9yHhyGOwGoJWXFoM6q2hrtwKHUNc7yE17GkkpE6+aUpSQneJOFkQt6
         koW1gvhK1ADbi1ExAVmfFexBQXVcfzCRmwQXXg4o2VFmuZvhvsAqqCiZ5eDLhGfPd/cu
         UMzSyS0hdoncAdCxjorx41Rvtg3/TmKuRdyR5RJKb/clAmJuj0vHSxJiVuBnZ59/EuAl
         X93A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719422026; x=1720026826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sq1NG/a/h0TZsAI2XZ3QDBZsq03pVAcY6r8Z/zu7ZOc=;
        b=CoJ81AcbpR7YAgAyB6fYjYwy54jaXh19Bc56EMzotdkeg1o6YofAca+g073cpr+Q5o
         IlJiwuq/v4XiELAIJSqBpaFhInKQFd1OrQkhPXEX6k+o4F8OAlE4/yKbO6pfjNrj6ezr
         W7G09x0b2KpWyOLR2RxIvJdDP2bFkwdIqxz/egOPHU7DOz+mWLPUXOh/fA926AdCp36k
         fJlsghST1A6Pf4dGbtZCTBtWHlaCIJ0sKOukG1F+6p8zjIDyeqT4s3bPcOIMl2tYq2pc
         IvG2rZy3E5RV6IK6iODeB0bRcbz36eZomVyFV2sYtLnJfleIYFd3LYWvTrKOb7tmsHRp
         Q1FA==
X-Gm-Message-State: AOJu0Yy38ifM7Ffto4zhzuEOtcX9WRZJzgiJtCvG2R0xbpwTUy2Ho3I2
	UoCmuNKqGhM14S0qNRQAIbQu01NDK5fU6hMc67F5RGAS8sAqf59TEUrBoVRVQnvZ8gqVuRfw3oL
	7LA==
X-Google-Smtp-Source: AGHT+IHHUDL9hDTLZC5TAs8wuSJPSHFY0Nrwjw6weKSINDSTSt97JYC+ahGMUQji6YGhsKw/AdUVsE713nI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6e0d:b0:631:d4ea:3749 with SMTP id
 00721157ae682-643abe41014mr1520537b3.4.1719422025649; Wed, 26 Jun 2024
 10:13:45 -0700 (PDT)
Date: Wed, 26 Jun 2024 10:13:44 -0700
In-Reply-To: <6sczq2nmoefcociyffssdtoav2zjtuenzmhybgdtqyyvk5zps6@nnkw2u74j7pu>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-2-michael.roth@amd.com> <ZnwecZ5SZ8MrTRRT@google.com> <6sczq2nmoefcociyffssdtoav2zjtuenzmhybgdtqyyvk5zps6@nnkw2u74j7pu>
Message-ID: <ZnxMSEVR_2NRKMRy@google.com>
Subject: Re: [PATCH v1 1/5] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, x86@kernel.org, pbonzini@redhat.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, pgonda@google.com, 
	ashish.kalra@amd.com, bp@alien8.de, pankaj.gupta@amd.com, 
	liam.merwick@oracle.com, Brijesh Singh <brijesh.singh@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 26, 2024, Michael Roth wrote:
> On Wed, Jun 26, 2024 at 06:58:09AM -0700, Sean Christopherson wrote:
> > [*] https://lore.kernel.org/all/20240229025759.1187910-1-stevensd@google.com
> > 
> > > +	if (is_error_noslot_pfn(req_pfn))
> > > +		return -EINVAL;
> > > +
> > > +	resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
> > > +	if (is_error_noslot_pfn(resp_pfn)) {
> > > +		ret = EINVAL;
> > > +		goto release_req;
> > > +	}
> > > +
> > > +	if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true)) {
> > > +		ret = -EINVAL;
> > > +		kvm_release_pfn_clean(resp_pfn);
> > > +		goto release_req;
> > > +	}
> > 
> > I don't see how this is safe.  KVM holds no locks, i.e. can't guarantee that the
> > resp_pfn stays private for the duration of the operation.  And on the opposite
> 
> When the page is set to private with asid=0,immutable=true arguments,
> this puts the page in a special 'firmware-owned' state that specifically
> to avoid any changes to the page state happening from under the ASPs feet.
> The only way to switch the page to any other state at this point is to
> issue the SEV_CMD_SNP_PAGE_RECLAIM request to the ASP via
> snp_page_reclaim().
>
> I could see the guest shooting itself in the foot by issuing 2 guest
> requests with the same req_pfn/resp_pfn, but on the KVM side whichever
> request issues rmp_make_private() first would succeed, and then the
> 2nd request would generate an EINVAL to userspace.
> 
> In that sense, rmp_make_private()/snp_page_reclaim() sort of pair to
> lock/unlock a page that's being handed to the ASP. But this should be
> better documented either way.

What about the host kernel though?  I don't see anything here that ensures resp_pfn
isn't "regular" memory, i.e. that ensure the page isn't being concurrently accessed
by the host kernel (or some other userspace process).

Or is the "private" memory still accessible by the host?

> > resp_pfn stays private for the duration of the operation.  And on the opposite
> > side, KVM can't guarantee that resp_pfn isn't being actively used by something
> > in the kernel, e.g. KVM might induce an unexpected #PF(RMP).
> > 
> > Why can't KVM require that the response/destination page already be private?  I'm
> 
> Hmm. This is a bit tricky. The GHCB spec states:
> 
>   The Guest Request NAE event requires two unique pages, one page for the
>   request and one page for the response. Both pages must be assigned to the
>   hypervisor (shared). The guest must supply the guest physical address of
>   the pages (i.e., page aligned) as input.
> 
>   The hypervisor must translate the guest physical address (GPA) of each
>   page into a system physical address (SPA). The SPA is used to verify that
>   the request and response pages are assigned to the hypervisor.
> 
> At least for req_pfn, this makes sense because the header of the message
> is actually plain text, and KVM does need to parse it to read the message
> type from the header. It's just the req/resp payload that are encrypted
> by the guest/firmware, i.e. it's not relying on hardware-based memory
> encryption in this case.
> 
> Because of that though, I think we could potential address this by
> allocating the req/resp page as separate pages outside of guest memory,
> and simply copy the contents to/from the GPAs provided by the guest.
> I'll look more into this approach.
> 
> If we go that route I think some of the concerns above go away as well,
> but we might still need to a lock or something to serialize access to
> these separate/intermediate pages to avoid needed to allocate them every
> time or per-request.
> 
> > also somewhat confused by the reclaim below.  If KVM converts the response page
> > back to shared, doesn't that clobber the data?  If so, how does the guest actually
> > get the response?  I feel like I'm missing something.
> 
> In this case we're just setting it immutable/firmware-owned, which just
> happens to be equivalent (in terms of the RMP table) to a guest-owned page,
> but with rmp_entry.ASID=0/rmp_entry.immutable=true instead of
> rmp_entry.ASID=<guest asid>/rmp_entry.immutable=false. So the contents remain
> intact/readable after the reclaim.

Ah, I see the @asid=0 now.  The @asid=0,@immutable=true should be a separate API,
because IIUC, this always holds true:

	!asid == immutable

E.g.

static int rmp_assign_pfn(u64 pfn, u64 gpa, enum pg_level level, u32 asid, bool immutable)
{
	struct rmp_state state;

	memset(&state, 0, sizeof(state));
	state.assigned = 1;
	state.asid = asid;
	state.immutable = immutable;
	state.gpa = gpa;
	state.pagesize = PG_LEVEL_TO_RMP(level);

	return rmpupdate(pfn, &state);	
}

/* Transition a page to guest-owned/private state in the RMP table. */
int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 asid)
{
	if (WARN_ON_ONCE(!asid))
		return -EIO;

	return rmp_assign_pfn(pfn, gpa, level, asid, false);
}
EXPORT_SYMBOL_GPL(rmp_make_private);

/* Transition a page to AMD-SP owned state in the RMP table. */
int rmp_make_firmware(u64 pfn, u64 gpa)
{
	return rmp_assign_pfn(pfn, gpa, PG_LEVEL_4K, 0, true);
}
EXPORT_SYMBOL_GPL(rmp_make_firmware);

