Return-Path: <kvm+bounces-28239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF9D5996B84
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 15:15:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DD70283143
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 13:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 929B1194141;
	Wed,  9 Oct 2024 13:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2OLGGWjI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4891D192D80
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 13:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728479679; cv=none; b=icoolXOV2vpAdeIDqHkUiTV/Oup0ScKjIKi/lk0bSG5N3GowknM4j+n8Onh5nJSPHfC3zQEJd5kBtSS886zp/OTtjbhxfEEPqbc59+TQpVfoCJ6t9R18v0N7DMzGI1MKwMer5lt34LC36VqpXcHSFBXgA1CHM0r93K7iD+d086g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728479679; c=relaxed/simple;
	bh=d3uSPZxORKmVlB66mNShAQmiJU7ra9Q4AGAbI3fZ8z8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZhCQrrj84kIe0qKsBeg9kPM7ER9HtCO9NlLH2pPrrulPeeXBTLP9vdSmTLowuBA0BxxrOnOrfihsAqO7pZsBH1oIclIo3bdU2zYvYZNjUUmpqhG5ECrjvDhgihmFvlZdyUywk/rXHSbdftNDpFy0oIU1VTpGx2NYdvCNtuyHcfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2OLGGWjI; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e29097b84c8so119869276.3
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 06:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728479677; x=1729084477; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EgsDKPkC09+Onhv3ZGoUVeFgaBkjKnGI6VWOvKgtHCM=;
        b=2OLGGWjIXihdPod7b4tSfNInoBC8yJmZNH6CYCushwdRcewN7n3QlUGi/H6WCDinRe
         emVcio9Srhl+AMsXeafWucSlq6n04sxs6j5sxwr1BYyXf143E37Kel6aTqCn84ON1COB
         +ELmx+bWmfAUlgrtSJJ9v82SCVLp+j1Ps2LZP3wJHcY4LThZ0qcvDIVADz6my826yi2f
         /MEPjCwJ56o9oMN2rwrYmu/RDGVrKC7GojfgTNtkoX98PGIPONIblo6KGBqqQ11vvSgY
         fU/eVAzP7/koFQsPq1U254MVgwiWVsCktULFnuAYk+IYQQXW+6YBn7lZog5m07COdsgn
         r2ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728479677; x=1729084477;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EgsDKPkC09+Onhv3ZGoUVeFgaBkjKnGI6VWOvKgtHCM=;
        b=cgcW/BmjM6kSgAkrPfAUA3hj3sL27lgVaspMDe2d2PqENC1gKTQ735XlOhO7/N4yrV
         FCP/zbVFVr4sMDADqtd8NHu5sGXq4B6PQpNU3E19RfkoJsn0rYcvWoS3beO1+Ia70I3C
         KZju1+R0GhzPl63spNhAB/WIAscgK22YZZU3zDpnrwqPFvhw6pFHGp5UDNKXBTW7f+qF
         OG7WOAfcn9kafdNk62jiNo8/tEXlNS40KCN9zKpHCWrQ/ESxYzzIzikcDfhu6EpMLly5
         0CG2ceNCR8lJFq5Lfwgv+vF0l+CbXxAqzPj4khxVj7G4mh2+zvzx/cNfSCWK48CJCDKn
         SG+A==
X-Forwarded-Encrypted: i=1; AJvYcCUfNsU8m7TU286noWJoVck01NDzUQZREVAk/ss2LWsOlSxUNBmGMRMjfNtXEOtouLrasgU=@vger.kernel.org
X-Gm-Message-State: AOJu0YznEreIMCvwY98+7VzxFRTVHr8uCx4c5K58IP6eoHkRjVEPQAmV
	PX7ElgHC3/7WE/9VVJa0qC/dAY1BgJi5wg+Nw3BU2h9Zrz6czTptUj/YzFxFdcPeKKoGM0SY5XQ
	2oQ==
X-Google-Smtp-Source: AGHT+IEO0k4jXJioiSmPAvdcWPAQJDTNJQQZHdjpBAGmJ2rcmUcV4emzzrWNTnFXRkQogPoiWl6B2lJBrJw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:6c05:0:b0:e24:c3eb:ad03 with SMTP id
 3f1490d57ef6-e28fe540170mr478276.10.1728479676345; Wed, 09 Oct 2024 06:14:36
 -0700 (PDT)
Date: Wed, 9 Oct 2024 06:14:31 -0700
In-Reply-To: <ZwZLN3i3wcJ4Tv4E@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <6eecc450d0326c9bedfbb34096a0279410923c8d.1726182754.git.isaku.yamahata@intel.com>
 <ZuOCXarfAwPjYj19@google.com> <ZvUS+Cwg6DyA62EC@yzhao56-desk.sh.intel.com>
 <Zva4aORxE9ljlMNe@google.com> <ZvbB6s6MYZ2dmQxr@google.com>
 <ZvbJ7sJKmw1rWPsq@google.com> <ZwWEwnv1_9eayJjN@google.com> <ZwZLN3i3wcJ4Tv4E@yzhao56-desk.sh.intel.com>
Message-ID: <ZwaBt0BzzG6Z0UGN@google.com>
Subject: Re: [PATCH] KVM: x86/tdp_mmu: Trigger the callback only when an
 interesting change
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org, sagis@google.com, 
	chao.gao@intel.com, pbonzini@redhat.com, rick.p.edgecombe@intel.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 09, 2024, Yan Zhao wrote:
> On Tue, Oct 08, 2024 at 12:15:14PM -0700, Sean Christopherson wrote:
> > On Fri, Sep 27, 2024, Sean Christopherson wrote:
> > > ---
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index ce8323354d2d..7bd9c296f70e 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -514,9 +514,12 @@ static u64 mmu_spte_update_no_track(u64 *sptep, u64 new_spte)
> > >  /* Rules for using mmu_spte_update:
> > >   * Update the state bits, it means the mapped pfn is not changed.
> > >   *
> > > - * Whenever an MMU-writable SPTE is overwritten with a read-only SPTE, remote
> > > - * TLBs must be flushed. Otherwise rmap_write_protect will find a read-only
> > > - * spte, even though the writable spte might be cached on a CPU's TLB.
> > > + * If the MMU-writable flag is cleared, i.e. the SPTE is write-protected for
> > > + * write-tracking, remote TLBs must be flushed, even if the SPTE was read-only,
> > > + * as KVM allows stale Writable TLB entries to exist.  When dirty logging, KVM
> > > + * flushes TLBs based on whether or not dirty bitmap/ring entries were reaped,
> > > + * not whether or not SPTEs were modified, i.e. only the write-protected case
> > > + * needs to precisely flush when modifying SPTEs.
> > >   *
> > >   * Returns true if the TLB needs to be flushed
> > >   */
> > > @@ -533,8 +536,7 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
> > >          * we always atomically update it, see the comments in
> > >          * spte_has_volatile_bits().
> > >          */
> > > -       if (is_mmu_writable_spte(old_spte) &&
> > > -             !is_writable_pte(new_spte))
> > > +       if (is_mmu_writable_spte(old_spte) && !is_mmu_writable_spte(new_spte))
> > 
> > It took me forever and a day to realize this, but !is_writable_pte(new_spte) is
> > correct, because the logic is checking if the new SPTE is !Writable, it's *not*
> > checking to see if the Writable bit is _cleared_.  I.e. KVM will flush if the
> > old SPTE is read-only but MMU-writable.
> For read-only, host-writable is false, so MMU-writable can't be true?

Read-only here refers to the SPTE itself, i.e. the !is_writable_pte() case.

