Return-Path: <kvm+bounces-15879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 56A1E8B170B
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 01:27:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 896F41C25308
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 23:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F4C316F0EF;
	Wed, 24 Apr 2024 23:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b5+WrySM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC6D157467
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 23:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714001220; cv=none; b=Iz0wKCebo73Z6kQ94uFpjTf6Z1lsamKC8tUE7QDoGcZfI4lXOdbJtVOhf6jj29lJp40iIcZx7HJorFbBMbC8Nx+CRf6zLdmnQnnwkR4swiWhX3pnaf7XFY7X0hkt2SwAeG5piMiytWY0srujyZBlW+I5VPEXUM7Eb3X6RcMG0W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714001220; c=relaxed/simple;
	bh=QtOdWdlOdeRyzFugEhg6e9ksqQi4BaU2ioPkhsidgEY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ePnADdJdPOs9yOJgHjXWpYmHfHYQtX92vQxD29XTA3OcfFCdFRkaMF7AfRDeHD2sQbRe0MwDtKfsi4nctIGH964LwaAsdwVHmmSLewIme5Dl0Nvp2ux6VFzYjNXhQoI0lk1p9MA5hTVyJKLAnnXvFAdFU0IWdX7rLkRmOgsZiwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b5+WrySM; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-618596c23b4so6752557b3.0
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 16:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714001218; x=1714606018; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9CmG+3iHB+1BxNgRQoZJ+SwJOKBGJtBG8Ri4d9VDnrA=;
        b=b5+WrySMkvLaTYMw1QIOcbKG7DRhwAbXJtA6hCiOoAnYV6ZH2JS4PzcyrGLciWffY2
         Zk6JEWojNcXAXaS8OzuRG8/5C8XMtXOnm2lS2PNJZ9NwLXFd2Q0pvq5cZ9oozsTUJwNH
         eK9tBSDe9bd+3B09kGEZdTMk/E5ml3ViiYdVRNv4NRCwAp+UOGFrwZ3+QaydUeccBV7w
         rXefzKAquju+l4+Q6qc1r8Ih2B4AjOH7LKvXKd6Q7l3Qp1XGFZSM5FlUq/7lFNQgGa1q
         HZmlKt3DyV37+2b15yWfNUzxbaj6maNPY9lIiaBXVTJNbwBsM8VwfU+u5yenJoxdEOQT
         EwLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714001218; x=1714606018;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9CmG+3iHB+1BxNgRQoZJ+SwJOKBGJtBG8Ri4d9VDnrA=;
        b=QR0SmDPPkp82gq1DM6vc0VlRpW6u7qb+0eDmbfTb082APLgjedabJGKSQa7aYx7Nel
         OcNHCLpYCzXGyjG7ueQaaeQLga3mVba7PwS6eGayopHQqa0xrVrHYjAEBFfGPk8OlFM0
         ASKMVoIjx99ImzC2d/wkO8jSnhm6768EEArJV5Wqbrk8gbm2XJNWblgnRa4KBEzhBR7Y
         fZ1Xb1/O095HD0Xy/0sRtAU/7iGC8QwU/XwiRSCPwDlWfh6KfJ1uikFhXSlV07qgSzgC
         DvtaVyPPPol2kLVqvywk/59nzzMBVhsrBqZYqf+Ed6NCNT/DED0buCz5C+rP8pdkyxBB
         Me9A==
X-Gm-Message-State: AOJu0YwCwbvhDzZA433gFew3Y1wna2Xp6jj5eM+H82Nd9jYpeTo4AgwE
	YOUP+MpgMBEsgFBnN+vWtmBaGTeC8jrxbeksekZXklUii9e+bx3eUv0ngtu3dUiyrjp6PRwcXRh
	aWw==
X-Google-Smtp-Source: AGHT+IG9AFP7hY+ukqMVBTl39cuNC0vrXBttEQiu5m8xciLOlctXbTTnNj1cEOBjn+Fu9BaNN6kY8VHwld4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:e288:0:b0:61b:649:ac90 with SMTP id
 l130-20020a0de288000000b0061b0649ac90mr769275ywe.9.1714001218264; Wed, 24 Apr
 2024 16:26:58 -0700 (PDT)
Date: Wed, 24 Apr 2024 16:26:56 -0700
In-Reply-To: <20240421180122.1650812-6-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240421180122.1650812-1-michael.roth@amd.com> <20240421180122.1650812-6-michael.roth@amd.com>
Message-ID: <ZimVQKWGZyju3RbT@google.com>
Subject: Re: [PATCH v14 05/22] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
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
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> KVM_SEV_SNP_LAUNCH_START begins the launch process for an SEV-SNP guest.
> The command initializes a cryptographic digest context used to construct
> the measurement of the guest. Other commands can then at that point be
> used to load/encrypt data into the guest's initial launch image.
> 
> For more information see the SEV-SNP specification.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Co-developed-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---

I somehow ended up in the v13 series and gave feedback on that version, but AFAICT
all of the feedback still applies to v14.

https://lore.kernel.org/all/Zil8MnPXkCbqw3Ka@google.com

