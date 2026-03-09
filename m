Return-Path: <kvm+bounces-73360-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WMHpGlwjr2n6OQIAu9opvQ
	(envelope-from <kvm+bounces-73360-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 20:45:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DC386240490
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 20:45:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6055B31087F5
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 19:39:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA04C40FDAC;
	Mon,  9 Mar 2026 19:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AI+hUl4U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE69363086
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 19:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773085194; cv=none; b=F1qbJkjuAwNqN3/1cBj6eWfkUel8XtC2avPclL9ZkYtEjZdKjwoctq6ltKqqClxoPqu1e6e0AY4p6E4ATXng6G48D9ojsDdThR1veZnN6KqmBUEPUEMdcSHSfDjQxk/+G6Auwz5QXRqq8lZxC5Rme0uSlfTqZ5tiqVoTo2ViC8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773085194; c=relaxed/simple;
	bh=trMV9FTe0tYlLcTyWzCsqlhyck4J2mO/d/Q5YX2oJew=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RKj/Gtg1qTYWx8ko28fGsNuDrzSA8pSR0wJ2k0U5s/xXeF2KzpyEpMuuU6lhcdF4dhL7Y6q/WNYnk52AdBVowzCkbeO54fchWOZ0F/5P163gFjMFMi8w2mRIxo3yyLIpWdQ929X7tkt0gtMEXpwT5sl9PPeZ0Srk3sxubWomzHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AI+hUl4U; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c738563e61eso3367063a12.2
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 12:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773085192; x=1773689992; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a4DxRweYw8uA/HgZIB6znpH45HCk/CxYPK4Mt6RfBlg=;
        b=AI+hUl4UNOEcxSHi+C/yp/GJ4axxwigeK4/Sxqw78jQf1iFKxXgdobVCwhrV1nJPB7
         uUWPJfQI9g+FC3kap6nZL3COSSLHYfhCdVwJFWUlhvtzYB0kqQzbxIvZMHWm6HD8zNAm
         756jcRUX5VonKqbDEX/3GwYxYq/79lxwze5XpXj4i8OYtIZ+nVF8kzcfZZCDxI0Tq/r2
         IITl3unix9hMvN+1/LWD/9oyZUBdLkbknOyxnZJGJNnluf3hVHfwvQxwRgUAXLAe7Owh
         y+njxG5gotTc+hQvv6W4stZufS9mJxeVGmYnr9GIDxzR3TgiQ/eT80o/2ta8sfLj4QjI
         XAoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773085192; x=1773689992;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a4DxRweYw8uA/HgZIB6znpH45HCk/CxYPK4Mt6RfBlg=;
        b=KTJnQvWKdr5RgSCnACevX3h7nl67f2Eaa7FmQfGhWRZ4hSlfgmNSW8khThxRGk8fIA
         LwlW6hSoE0d4/eXhWTofxYSwuKzVFUNGYoOMdf7WPe18MN4VabDHO8RPJz0axcCyCoDY
         NleRgi+I+/NLIIO3jC7B+Y5+qfbW48OZQXISZ9U6sxAgP9vuvJLg8Ac9qUGBvaQ2Ry0X
         mE5JLmZZpIXkqXp9GrG4agONAg77ZRTgB9MMfw90H4Z7MJe6fRMuKOD9Q0xpugpjeKKn
         HDM+Dk2hKEtvdRBYFtT1PRT8iRVju1uwESfdA1kNCS1u/wtzn2Pt9sq0nhwkUsea5WFX
         urwg==
X-Forwarded-Encrypted: i=1; AJvYcCVZVi5ix9CVxErP37uJm8JnwMF8Iu9H6I9355vW/g6XNb1fsDFvxhK/fgHdQKmrSuKfHBQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLOxyA78/yv6CEESK8nt8OUYRAEd8YzKoApi5+tY4Lm3tvWM2x
	kxLkcTXim3l4IViCm9iZYxuXqLRR9/myVcYPvdwNQvNpXahAtp6/eLFcSdMijpxGY71iaB7q4Vj
	UDyL01A==
X-Received: from pgg23.prod.google.com ([2002:a05:6a02:4d97:b0:c73:8295:1401])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a126:b0:398:809d:93de
 with SMTP id adf61e73a8af0-398809d9c52mr5520617637.14.1773085192155; Mon, 09
 Mar 2026 12:39:52 -0700 (PDT)
Date: Mon, 9 Mar 2026 12:39:50 -0700
In-Reply-To: <d550c85e-a149-4cc2-8519-d157226097e2@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260309075629.24569-2-phind.uet@gmail.com> <aa7bjEJ_ICGjuiy5@google.com>
 <d550c85e-a149-4cc2-8519-d157226097e2@gmail.com>
Message-ID: <aa8iBu9BcJbhdAB8@google.com>
Subject: Re: [PATCH] KVM: pfncache: Fix uhva validity check in kvm_gpc_is_valid_len()
From: Sean Christopherson <seanjc@google.com>
To: Phi Nguyen <phind.uet@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	syzbot+cde12433b6c56f55d9ed@syzkaller.appspotmail.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: DC386240490
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73360-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm,cde12433b6c56f55d9ed];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 10, 2026, Phi Nguyen wrote:
> On 3/9/2026 10:39 PM, Sean Christopherson wrote:
> > On Mon, Mar 09, 2026, phind.uet@gmail.com wrote:
> > > From: Nguyen Dinh Phi <phind.uet@gmail.com>
> > > 
> > > In kvm_gpc_is_valid_len(), if the GPA is an error GPA, the function uses
> > > uhva to calculate the page offset. However, if uhva is invalid, its value
> > > can still be page-aligned (for example, PAGE_OFFSET) and this function will
> > > still return true.
> > 
> > The HVA really shouldn't be invalid in the first place.  Ideally, Xen code wouldn't
> > call kvm_gpc_refresh() on an inactive cache, but I suspect we'd end up with TOCTOU
> > flaws even if we tried to add checks.
> > 
> > The next best thing would be to explicitly check if the gpc is active.  That should
> > preserve the WARN if KVM tries to pass in a garbage address to __kvm_gpc_activate().
> > 
> > diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
> > index 728d2c1b488a..8372d1712471 100644
> > --- a/virt/kvm/pfncache.c
> > +++ b/virt/kvm/pfncache.c
> > @@ -369,6 +369,9 @@ int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, unsigned long len)
> >          guard(mutex)(&gpc->refresh_lock);
> > +       if (!gpc->active)
> > +               return -EINVAL;
> > +
> >          if (!kvm_gpc_is_valid_len(gpc->gpa, gpc->uhva, len))
> >                  return -EINVAL;
> In this reproducer, userspace invokes KVM_XEN_HVM_EVTCHN_SEND without first
> configuring the cache. As a result, kvm_xen_set_evtchn_fast() returns
> -EWOULDBLOCK when kvm_gpc_check() fails. The -EWOULDBLOCK error then causes
> kvm_xen_set_evtchn() to fall back to calling kvm_gpc_refresh().
> 
> IMO, if the cache is not active, kvm_xen_set_evtchn_fast() should return
> -EINVAL instead. It may be better to check the active state of the GPC in
> kvm_xen_set_evtchn_fast() rather than kvm_gpc_refresh()?

That'd be subject to the TOCTOU race I mentioned.  gpc->active is guarded by
gpc->refresh_lock, which as the name suggests is taken only by __kvm_gpc_activate(),
kvm_gpc_deactivate(), and kvm_gpc_refresh().  Checking gpc->active outside of
those paths can get false positives, e.g. in this case if there's a racing call
to deactivate a cache via KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO_HVA.

So no matter what, kvm_gpc_refresh() needs to check gpc->active.  At that point,
I don't see any value in having callers check, because they can't be trusted to
do the right thing, and even worse might give a false sense of security.

