Return-Path: <kvm+bounces-52901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A7C73B0A6AE
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 16:54:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56391188D498
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 14:55:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1A102DBF46;
	Fri, 18 Jul 2025 14:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QPw+nkJ0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB4472613
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 14:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752850482; cv=none; b=sEl7M8WriF33KiQwvih41O14iyf2ZjSit9Id2JxIp+tJ/3eATJ/Z3p9W973VtLt2IVzMGivjVntfNORZdOWGGTW5doDxQb+wpIfJurQiolP190UmTNsxfBuXOqskvNC0Pr8BBekPrkVimqV5dXuSxRealm7ZD+V0yFpGeyxZsFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752850482; c=relaxed/simple;
	bh=R+uHC0rNFoe7/WMDlNej4tXX+jCmeBQ+xIZb2iEFRn0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QLDakNGiv1T6srmYV0mVDAF22Pq8M4lERqxP+XJRpf0QpTx/DYZ7X15RSGN/18GdwzWMtjQ5sL83eIjkRs/ffDNQpZlrcPuSY7GRpGEp5ivnfTOswCJt7UVD4FdUdqJi0n9PIJRNv/4QpEzWQinCspgQm3euOXpB6Yoo5cXDFmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QPw+nkJ0; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31366819969so2135545a91.0
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 07:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752850480; x=1753455280; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N/TCALKPJKMHZD91lUzJU6dW6O+HUemIHHtXfTjzh2o=;
        b=QPw+nkJ0kv8iwna5Drj2cw1oWXO2i9x761mJemFsZVGnlHJC0ZlzjtZ28bBDoyEwqo
         WkaMp+cuKttbC0gG3C523ANzkcIpSIPRaNcDpfoB00Pyte4heZQITgjMPHtqj+Nhou9/
         RPPyJSWMbn5iioQ+tPhF8yfGpu7h4tZGWpGf64+NgL8tAha5k//s7mnide+Ig6h4SpFd
         LFEhCWxHF5jjZwmpRa8seK9yIPf+kZqEjbZzGjVk1W+AFHQcC19JZBKYF+jCAQew41dd
         6FImuwZ0slhmxLClSGxw8HpGNP11wWxfjBevnLMzave5RZ6O1VndNOnrytMb/qPMmYGQ
         iwsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752850480; x=1753455280;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N/TCALKPJKMHZD91lUzJU6dW6O+HUemIHHtXfTjzh2o=;
        b=XuiusDhIYC407teaPdP9qChk1pfXgVJ1AOsRi267fCu1SC4RI8Jj+/poN0MpXP/YaD
         48S5d5cqqoLaHLViOpfkZ1mKxgkPbH+0Ee4zghq8BWEABQPJHahiGefIFmHKiuXifT63
         8U806WxEdE4bAkZXUif9QmZ1lhwdeW4/plG9rdtczgfhSOkt423wJKDZfOg++yuLioFC
         b7ok/U32bJqURTheRDTD6a23DQgjTyTL96t2q6OT7u79swR3XtzrQuyKsy+0oUHMM+U4
         nN0BM+S6f0C3kXoTpMXuSpWI6wGHFGnytRwMtocOOQua7RRqzhwcIBf52FZtdjxzPuYS
         U2FA==
X-Forwarded-Encrypted: i=1; AJvYcCUTGQ9e0NeENw6R+dd+049OmbZ3kBOSDUf6wlKdmXsB0E5j/dcykCd9cgQllo9yUK4bhMo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwL45iF96WKEFBfoNGqWpWsV51ORSMAq50bJ2++eKWRFK/IzBjN
	41kg6fjtApgZQLl7IN5Tkrrk3ILgo6Qwjx7pG7sDdKQV02kbAwKuYvK7GMX58M+sywWg/bAS9nQ
	9Yw9i4Q==
X-Google-Smtp-Source: AGHT+IHg7OQ4Sa3hUw44fFRrqCCRNCdoEM6sGbznGmflFsSooOxKsLp700fJMAwy7HaVB0l9Tq8sTcWYBQ4=
X-Received: from pjxx3.prod.google.com ([2002:a17:90b:58c3:b0:313:2d44:397b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d08:b0:311:c93b:3ca2
 with SMTP id 98e67ed59e1d1-31c9e6e96fdmr15276081a91.6.1752850480100; Fri, 18
 Jul 2025 07:54:40 -0700 (PDT)
Date: Fri, 18 Jul 2025 07:54:38 -0700
In-Reply-To: <ndwhwg4lmy22vnqy3yqnpdqj7o366crbrhgj5py5fm3g3l2ow3@5s24dzpkswa2>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250716110737.2513665-1-keirf@google.com> <20250716110737.2513665-4-keirf@google.com>
 <ndwhwg4lmy22vnqy3yqnpdqj7o366crbrhgj5py5fm3g3l2ow3@5s24dzpkswa2>
Message-ID: <aHpgLnfQjp3qdZOL@google.com>
Subject: Re: [PATCH v2 3/4] KVM: Implement barriers before accessing
 kvm->buses[] on SRCU read paths
From: Sean Christopherson <seanjc@google.com>
To: Yao Yuan <yaoyuan@linux.alibaba.com>
Cc: Keir Fraser <keirf@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Eric Auger <eric.auger@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 17, 2025, Yao Yuan wrote:
> On Wed, Jul 16, 2025 at 11:07:36AM +0800, Keir Fraser wrote:
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 3bde4fb5c6aa..9132148fb467 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -965,11 +965,15 @@ static inline bool kvm_dirty_log_manual_protect_and_init_set(struct kvm *kvm)
> >  	return !!(kvm->manual_dirty_log_protect & KVM_DIRTY_LOG_INITIALLY_SET);
> >  }
> >
> > +/*
> > + * Get a bus reference under the update-side lock. No long-term SRCU reader
> > + * references are permitted, to avoid stale reads vs concurrent IO
> > + * registrations.
> > + */
> >  static inline struct kvm_io_bus *kvm_get_bus(struct kvm *kvm, enum kvm_bus idx)
> >  {
> > -	return srcu_dereference_check(kvm->buses[idx], &kvm->srcu,
> > -				      lockdep_is_held(&kvm->slots_lock) ||
> > -				      !refcount_read(&kvm->users_count));
> > +	return rcu_dereference_protected(kvm->buses[idx],
> > +					 lockdep_is_held(&kvm->slots_lock));
> 
> I want to consult the true reason for using protected version here,
> save unnecessary READ_ONCE() ?

Avoiding the READ_ONCE() is a happy bonus.  The main goal is to help document
and enforce that kvm_get_bus() can only be used if slots_lock is held.  Keeping
this as srcu_dereference_check() would result in PROVE_RCU getting a false negative
if the caller held kvm->srcu but not slots_lock.

From a documentation perspective, rcu_dereference_protected() (hopefully) helps
highlight that there's something "special" about this helper, e.g. gives the reader
a hint that they probably shouldn't be using kvm_get_bus().

