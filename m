Return-Path: <kvm+bounces-23263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCD8094853D
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 00:02:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 55821B2295C
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 22:02:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05B2116EB63;
	Mon,  5 Aug 2024 22:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U2LQTN8q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE64714AD30
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 22:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722895318; cv=none; b=ev0QxHWKQDAUWZSmO0m2PT88Ns5rpnzR+eXYAmmryYTFv4SXHsE4LwQYHqK4yu1RQdGKb6LtemPMag8x33BUpxC+x41bz24NbVLdfOXYzbQBJiWsTzQ/R8mD8C+wpJyq3E60iLittrtlvTzHbKEp63LapDTXKe9PB3YwrgToaV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722895318; c=relaxed/simple;
	bh=0QTVvuFhkFu+eTehBCww96huZmKE7doBtfDRlhV9LAg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mDNdQolRYYAadV0GkHiANwe9dzpRkKjWMrdIKIiUevo9imKG3z50q08vZVP9vqeTwaxcP/tjEnDQ9FFszBZHfNPrvu4dYahLTeh880TmZFxTmYMXNAsqltFkofZFcxiHNrggzVXfRAUu4RDNa13oLMRvuchmkLSgtFaRmLvyY+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U2LQTN8q; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6886cd07673so1908627b3.3
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 15:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722895316; x=1723500116; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+tTcruptCIoj12cTqEoTGilRxDa1qYZ3l/I23+t2P0c=;
        b=U2LQTN8qnVm1jR/Mo0N2lZnf+e7Dl9LbHDHxX1WYIzrR79FND2cVNuFa4iuW27BEj8
         D7nZykz55dhfqf9Hv0DobuP/ViHu1JMMQNGGpZLiPQzblgGEQuetr9/mfUGIa1xWkl+E
         QiV0QA5GlYPqy2uy6Cm571v6Gonkuh2oacuzhLH91f8S0A4QH8t7o7jzsc1gd34ML57N
         6doMjs0E8E8Ya5O+odlvtkZh8S0zf5xXKUocO/rvDeiU/wt4jNawgXAZx/kfcVIj1LmL
         z19VYY7IXuw+OljCpOxmbq3tWn3ZlJT0mvHcAQnjS0oNNFZ82GC/7hnkkQgddjddDWXP
         HUvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722895316; x=1723500116;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+tTcruptCIoj12cTqEoTGilRxDa1qYZ3l/I23+t2P0c=;
        b=UbFvHSC5MwqzF0meMssimDAt19nqmhGgYnfqVqCZ8Z1a8WvGrVOjpKv5pUsoNbUL3U
         S4C1Sr8FgQNzjhSAyxXHmj9wIYBd2Vn+83cpjosmDiTRdhc3IRbPScwbAdXNCNY3WX8w
         DBBNV6fp168FICFQL+qN+D4O2pb7sxepfVha1qfTFLJW0XIc0amGbqjDuHdq3irpwfxy
         YEx5/2jl2Wi+qGZOs0dFJdmBdlAgXEKmKsF/froA+6IGAlh1ZlSsNRJ1Cz5erGvqfkFq
         Qmg61w5iI6fr5dgEbK88END6FogBZkDUkjxrsQRfvFj97OFuiSAycaoWk2TGmIQYzx5s
         N83Q==
X-Forwarded-Encrypted: i=1; AJvYcCXwzangrUDiocLbG9sN91JgUSfPhQSpSXPLWPdUZMvwe6PuqrEKSBKiv+RjKgnI7g3cIkFO3fSNbofsdQ5TklHrQ3Zl
X-Gm-Message-State: AOJu0Yy6Ui8+X50XsihEEfvumzUDErTKn8COAzriBnvz84YEebpyoz30
	3EGj3F4FiQkBRCDABKCqaaxc2sLdYi5NacniRnSGLUmuIqWRf8E64XvY2t/ws9QiBlxvh3wA14G
	x8A==
X-Google-Smtp-Source: AGHT+IHaHOrIgxF/rksi2iQa0AIH+qkRju5aGm/FXjHUKWkBgUU5NmreeeOnPmN3fbb7f0PZ+ibNm2Guh4Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:d8d:b0:648:db87:13d8 with SMTP id
 00721157ae682-6895f60e7c9mr5514987b3.2.1722895315787; Mon, 05 Aug 2024
 15:01:55 -0700 (PDT)
Date: Mon, 5 Aug 2024 15:01:54 -0700
In-Reply-To: <ZrCQSXmbBK5XZqd8@linux.bj.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802205003.353672-1-seanjc@google.com> <20240802205003.353672-3-seanjc@google.com>
 <ZrCQSXmbBK5XZqd8@linux.bj.intel.com>
Message-ID: <ZrFL0g97IGDTDdWS@google.com>
Subject: Re: [PATCH 2/6] KVM: Assert slots_lock is held in __kvm_set_memory_region()
From: Sean Christopherson <seanjc@google.com>
To: Tao Su <tao1.su@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 05, 2024, Tao Su wrote:
> On Fri, Aug 02, 2024 at 01:49:59PM -0700, Sean Christopherson wrote:
> > Add a proper lockdep assertion in __kvm_set_memory_region() instead of
> > relying on a function comment.  Opportunistically delete the entire
> > function comment as the API doesn't allocate memory or select a gfn,
> > and the "mostly for framebuffers" comment hasn't been true for a very long
> > time.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  virt/kvm/kvm_main.c | 10 ++--------
> >  1 file changed, 2 insertions(+), 8 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 0557d663b69b..f202bdbfca9e 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1973,14 +1973,6 @@ static bool kvm_check_memslot_overlap(struct kvm_memslots *slots, int id,
> >  	return false;
> >  }
> >  
> > -/*
> > - * Allocate some memory and give it an address in the guest physical address
> > - * space.
> > - *
> > - * Discontiguous memory is allowed, mostly for framebuffers.
> > - *
> > - * Must be called holding kvm->slots_lock for write.
> > - */
> >  int __kvm_set_memory_region(struct kvm *kvm,
> >  			    const struct kvm_userspace_memory_region2 *mem)
> >  {
> > @@ -1992,6 +1984,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
> >  	int as_id, id;
> >  	int r;
> >  
> > +	lockdep_assert_held(&kvm->slots_lock);
> 
> How about adding this lockdep assertion in __x86_set_memory_region() to replace
> this comment "/* Called with kvm->slots_lock held.  */" as well?

Ya, will do, I didn't see that comment.

Thanks!

