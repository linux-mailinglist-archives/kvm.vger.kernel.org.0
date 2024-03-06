Return-Path: <kvm+bounces-11083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB5B9872BBE
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 01:26:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C3A1285DE7
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 00:26:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1CA6FC18;
	Wed,  6 Mar 2024 00:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q6eOSqPL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1859DDBE
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 00:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709684757; cv=none; b=VHQvVUFi3HcZeGcY3xhfAUT4zHpMT/SaJ15L/S90wUknoM7rgWQ10fnoG4vxTylm6wM868bmGYdO0izDWM/s/hD+9+ahrRE4n9BKA8GDMFfdDn/VWigsyPEfU0AMcuwiP+6YJGUuU8TiWwcFatp515S8DYLn0zUyeAjE0MILSjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709684757; c=relaxed/simple;
	bh=cOzX46HPtdjFrZDrmpp1FEEiEuyKrMsxVJ0ppoHR8yE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mM26ugfuxBODyB0Mh6LmL0cydn9pRhoWsXqfd42bJ4mpymIvmLt4L02LrTCk3oAU/Ar15oWZfcv+nB76XxhkQzEf4kfCuWZNbLXTX5sdRwyjFDSy4b03dKTqNgsZBX94Pju8JIHBY8abEFrbRfCPicXHUxoMd9T04ceteVHxVKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q6eOSqPL; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1dd01e6a1beso38841415ad.1
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 16:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709684755; x=1710289555; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9f6NA83OzYo58HbjFCzlBsiK2gdKmrkemt55OHdw4EM=;
        b=q6eOSqPLilYflk66Uy3hgvRicweV/WWinCVNQAd5C+ki6SnQRZ8RMBoYwa4PJa18zG
         7C6we2TtBfXgUmSgZ0COYeVZa7X1zc7DpeGMfH97mVjCgQjK8xoOprfGfHMdATBywrQE
         h8WzDHHM6UWpQ0PM/Tw15j3mM5a1dr+rFKFO/Egfmwu/StqHYj7laTtmW4HV3uxED3lE
         boWuEylNO1IFv+nsILdlZpPHYIl9n3qzxxOrYe5wHQLhYRC+37es/j5R1Ja1WtuLTAml
         5wtQ4ukWqyrc/6GLigQEMLg69eKARkEFpFwVrJLd0IWphW4jFKkjpS76tfyyRmINqfTI
         OEYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709684755; x=1710289555;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9f6NA83OzYo58HbjFCzlBsiK2gdKmrkemt55OHdw4EM=;
        b=hTMKUVAqPMhmvlkV/JSwQPpzvZ4RCVAZsd4Wlsh7gelIGQpQ/g+31BWwVGuD6LkBig
         gs8uDRY0dUMO2hCDkKQoCYU+63bs/9ukWojQk9J/MMaRKuLdeP4lxm53TKSadQaxnyrZ
         ZoUTOmn0jLAdoM8GZNfi8jvQEeHsPBPG/2R1LD/Bdudmkdaqe5HjBKU+s8G2wXMZz8zu
         V3eSY1CYIZs7eUnOlBuZGa4ByvLhllu1gxHuShcAxR8ZTwxwhN1djSQPLC5YmX8pM/F0
         YO/GL8LQSOkb6U2zoD2FeSdzCNd09eU/VLCz+fE9CpHEB+5gbvyma5O2um7ZB4lHAkwm
         bz4A==
X-Forwarded-Encrypted: i=1; AJvYcCVcj/RLdFfDexeY/cIfc2YgrnqUwGOEd4yOLNbVcRRwd+hxzsNVWY+UYjGI+xZoDVuQOoln08/hdrTd5K2v1dOCKdwG
X-Gm-Message-State: AOJu0Yx8Zq2XzlXQC2gfTgtGEWSIOdHO2vullSN+SiEwEUkSF76ihiUP
	NHTbpx4gZrcA4VeS6H4r4AXG0U+d3Z+jVXdDvYaY4iK6wOYdKloyV33oidbcLGEIvaE5i1JWC72
	X6A==
X-Google-Smtp-Source: AGHT+IHa+wYIcVWQIi2qj7G4ce/GINBo8H3/5p7Fgm0qZOtwL5sMbDfa9aT2DWbZNJVs9LrRZT8zY5/DrAQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e544:b0:1dc:9220:5e7 with SMTP id
 n4-20020a170902e54400b001dc922005e7mr26207plf.0.1709684754732; Tue, 05 Mar
 2024 16:25:54 -0800 (PST)
Date: Tue, 5 Mar 2024 16:25:53 -0800
In-Reply-To: <420cf8e8-88de-40b1-91a3-6660f7568494@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com> <20240228024147.41573-9-seanjc@google.com>
 <2237d6b1-1c90-4acd-99e9-f051556dd6ac@intel.com> <ZeEOC0mo8C4GL708@google.com>
 <05449435-008c-4d51-b21f-03df1fa58e77@intel.com> <ZeXt6A_w4etYCYP7@google.com>
 <420cf8e8-88de-40b1-91a3-6660f7568494@intel.com>
Message-ID: <Zee4EVTp77S2GLRW@google.com>
Subject: Re: [PATCH 08/16] KVM: x86/mmu: WARN and skip MMIO cache on private,
 reserved page faults
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Mar 06, 2024, Kai Huang wrote:
> On 5/03/2024 4:51 am, Sean Christopherson wrote:
> > In other words, KVM_EXIT_MEMORY_FAULT essentially communicates to userspace that
> > (a) userspace can likely fix whatever badness triggered the -EFAULT, and (b) that
> > KVM is in a state where fixing the underlying problem and resuming the guest is
> > safe, e.g. won't corrupt the guest (because KVM is in a half-baked state).
> > 
> 
> Sure.  One small issue might be that, in a later code check, we actually
> return KVM_EXIT_MEMORY_FAULT when private fault hits RET_PF_EMULATION -- see
> your patch:
> 
> [PATCH 01/16] KVM: x86/mmu: Exit to userspace with -EFAULT if private fault
> hits emulation
> 
> So here if we just return -EFAULT w/o reporting KVM_EXIT_MEMORY_FAULT when
> private+reserved is hit, it seems there's a little bit inconsistency here.

It's intentionally inconsistent.  -EFAULT without KVM_EXIT_MEMORY_FAULT is
essentially KVM saying "something bad happened, and it can't be fixed", whereas
exiting with KVM_EXIT_MEMORY_FAULT says "there's an issue, but you may be able
to resolve it".

The ABI is a bit messy, e.g. in some ways it would be cleaner if KVM returned '0'.
But doing that in a backwards compatible way would have required a rather ugly
opt-in, and it would also make it more tedious to extend KVM_EXIT_MEMORY_FAULT,
e.g. pairing it with -EHWPOISON didn't require any new flags.

