Return-Path: <kvm+bounces-71525-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wBMXGmm3nGkqKAQAu9opvQ
	(envelope-from <kvm+bounces-71525-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 21:24:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CEBF17CD3E
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 21:24:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2BDB73026338
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 20:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03E8737756C;
	Mon, 23 Feb 2026 20:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ufi05Hr5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5C037754E
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 20:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771878243; cv=none; b=IiP+fMtDWkz/06my4fnxSjY3B0ODbdZNyYBweC1F633tdA0isAElfnzyJnb1iSOtFu2eF3k5ckBrz33zKluEHRCMiCZeZqkVuvCettXr0VTlqjJ6eBODm5ZojyIVF/KvQRO0omw6VbkI/twnKjOTv7djCyC2wnxKgtrlqVgHXb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771878243; c=relaxed/simple;
	bh=pSFoekhb79w/9Q6oqn583+qO2wXFWypE1LjbHB7K14k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tAk/cb4KpMtKDViXytBNTayiOc/dCZ66r7sqMkwk9bbQE6TZcTQ9BTKmdrG938UmNYpT+z58Hdej0cTQ+FmZv5sC2M53aR+rPims48gEZduEEzXfDMQIP7rhW/FG3HNTrKhygE/S0KDKhdvBJesD1cM8fz0h/JPMSSsv6+1GIhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ufi05Hr5; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6e24ee93a6so3233528a12.0
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 12:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771878241; x=1772483041; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GD99/y0vYgITqywbHvEch3hhxD8ZoR8xSwqLHAkhMgQ=;
        b=ufi05Hr54980tzktMyleYB9zBLpL0uVSokSQ9EPTNzmtpMfyuuIHlarzuXhO041krD
         ufHR/HtHACxJo6w04FbFnNuqz7ni4UJelO3ih5p1ArcgqAnMB2qKPch3ACTpbrWyU3vH
         tYI9ilgqKfxjP4+IOoWY4wdgOGf2PIdtScGsyxoUmK+Ws4fa8Q+FEFdD8vnB4EaRlwNQ
         51WcEkFGqk01T9HJcAvsFEgfay87uuUCs4Ie8hdjHV65SfdKwlvzMttx8j60Jf0MK/uh
         k42jjlNeg5gyleKl88pRaM9JYBkt6NpjUB43OlJQtFVh5bkjULo+1gVIMlbUYc6mP2yy
         Kn3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771878241; x=1772483041;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GD99/y0vYgITqywbHvEch3hhxD8ZoR8xSwqLHAkhMgQ=;
        b=E48USbnis3CPvTWPdPo2b1Ob1PeEkQMDcqbSwGEVGNPjwFs58GIeLUFuLjZVHkKnbt
         +ACpGmEn1wKY9+wrMjYKxGsmzlFt6Ikzs+VeyhIBqeGmxnTMJgMbbK6CzRCXnRMXDWwu
         5JQx8+H/m9lwDH5sNp4wdm8dCM4CQGrGcasw+hGAouyauLFdHXqbKBsZ5FdgRvJQ3p4p
         MN6pPOJw5iyuSLbj/9H2S2kKvzsWtFpvXmQ4ycfa6bGdXNaa0pEI08yl2G7nB6d1O5gJ
         cJbqRK7jRiSzhTOA28ud433S4iVtjbv0ZxFfVJsiFTwwlPASIz0cgZ6JQcYT7MqTnkxR
         neGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXaw9vgKbN5hn3Pk2hLy3hO1nt15Z22FbpOuoSSva3EChl+oln3rZAlqVL5JoQkV48l0Qg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzS2dF+W3Btv9aJEubwC18zqLP/qmp6AeRLNhyfj/N+w17Cjz5v
	Bm/gazdrGsjkolOQRrEh5HLmuV7Zc5rPPCVs5Sdhomv38EqZ/QW/VtZGycPyUn+RsJcsHNaJNoM
	74snBuw==
X-Received: from pgda17.prod.google.com ([2002:a63:7f11:0:b0:c6e:28c3:dd61])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:a395:b0:34a:4b04:3c70
 with SMTP id adf61e73a8af0-39517e11fdamr13193721637.25.1771878241255; Mon, 23
 Feb 2026 12:24:01 -0800 (PST)
Date: Mon, 23 Feb 2026 12:23:59 -0800
In-Reply-To: <CAO9r8zMm185sTzhSZL4pfi5GAT2z33W-nPOaxDVq+AF-wePHUA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aYuE8xQdE5pQrmUs@google.com> <ck57mmdt5phh64cadoqxylw5q2b72ffmabmlzmpphaf27lbtxw@4kscovf6ahve>
 <aYvIpwjsJ50Ns4ho@google.com> <mxn6y6og34ejncnsvdapcoep4ewcnwnheszhwkp2undkqcu5zv@bpmseexuug5z>
 <aYvPwH8JcRItaQRI@google.com> <smsla7jgdncodh57uh7dihumnteu5sgxyzby2jc6lcp3moayzf@ixqj4ivmlgb2>
 <aZj2V9-noq10b5CM@google.com> <ftjb625b4wsz5vdty3fcxqanuxriiqcewqkzp2ml2hc4eojuoc@ewhboiiqmcd4>
 <aZyHeKp2Dzzrjb5C@google.com> <CAO9r8zMm185sTzhSZL4pfi5GAT2z33W-nPOaxDVq+AF-wePHUA@mail.gmail.com>
Message-ID: <aZy3Xwi931tynnPx@google.com>
Subject: Re: [PATCH 1/4] KVM: nSVM: Sync next_rip to cached vmcb12 after VMRUN
 of L2
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71525-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4CEBF17CD3E
X-Rspamd-Action: no action

On Mon, Feb 23, 2026, Yosry Ahmed wrote:
> > > > > > Oh, good point.  In that case, I think it makes sense to add the flag asap, so
> > > > > > that _if_ it turns out that KVM needs to consume a field that isn't currently
> > > > > > saved/restored, we'll at least have a better story for KVM's that save/restore
> > > > > > everything.
> > > > >
> > > > > Not sure I follow. Do you mean start serializing everything and setting
> > > > > the flag ASAP (which IIUC would be after the rework we discussed),
> > > >
> > > > Yep.
> > >
> > > I don't think it matters that much when we start doing this. In all
> > > cases:
> > >
> > > 1. KVM will need to be backward-compatible.
> > >
> > > 2. Any new features that depend on save+restore of those fields will be
> > > a in a new KVM that does the 'full' save+restore (assuming we don't let
> > > people add per-field flags).
> > >
> > > The only scenario that I can think of is if a feature can be enabled at
> > > runtime, and we want to be able to enable it for a running VM after
> > > migrating from an old KVM to a new KVM. Not sure how likely this is.
> >
> > The scenario I'm thinking of is where we belatedly realize we should have been
> > saving+restoring a field for a feature that is already supported, e.g. gpat.  If
> > KVM saves+restores everything, then we don't have to come up with a hacky solution
> > for older KVM, because it already provides the desired behavior for the "save",
> > only the "restore" for the older KVM is broken.
> >
> > Does that make sense?  It makes sense in my head, but I'm not sure I communicated
> > the idea very well...
> 
> Kinda? What I am getting at is that we'll always have an old KVM that
> doesn't save everything that we'll need to handle. I think the
> scenario you have in mind is where we introduce a feature *after* we
> start saving everything, and at a later point realize we didn't add
> proper "restore" support, but the "save" support must have always been
> there.

Yes.

> gPAT is not a good example because it's in the "save" area :P

Oh, I don't think I realized this is only talking about the control area.  Or I
probably forgot.

> But yeah, I see your point. It's not very straightforward now because
> what we save comes from the cache, and we only cache what we need for
> the current set of features. So this will need to be done on top of
> the rework we've been discussing, where vmcb02 starts being the source
> of truth instead of the cache, then we just (mostly) save vmcb02's
> control area as-is.

Yeah, it's not urgent by any means.

