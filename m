Return-Path: <kvm+bounces-70257-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0FkILS6Jg2lDpAMAu9opvQ
	(envelope-from <kvm+bounces-70257-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 19:00:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 57FA0EB4C1
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 19:00:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 625FC307652B
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 17:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 229E33B52E4;
	Wed,  4 Feb 2026 17:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Dypw55Br"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DD93A7F66
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 17:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770227738; cv=none; b=D8pV365XdB3musZAOMLi4RxJOqTtoLK4mIEkOS48dOZkMMgWgiPQ25gVSxutAyXdoxlf0cnu1KTTW4h4JpXmvQir1fTjRijh4oRKtVZThWX1Sex/VAoxvagSD4hkqa5pilIoWfzusQz0NmigbZ4oL5D82EM2Xe3yPIx9o5NNPVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770227738; c=relaxed/simple;
	bh=wmLGMdl85U3iS+OGDVctdAgaAZJQVJFyTP6hhfPFj8c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gxX8Zu6GScrvv5B9P+uhTKC9iqcM0gCJc/WbIhqiLLs7lHnW6whrG8t32/+ZbmPxEnWKx5abozD4ifFwvc7AGGff2N5R4dlYtMLmCEtq5mlO4zx4iv1Yq4X2yxhyxdQBv2BFD1Vx9DctyO87jo7daG52sPOt8Bdor+sr01c416s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Dypw55Br; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a784b2234dso2501075ad.1
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 09:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770227737; x=1770832537; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hATAnt3UH8manJo7IENnqEuwqz+p1IgqH3fjHujQfG8=;
        b=Dypw55Br5EWkpQCpB/58Xr3iAayXmEvU90LQSz8wrUCZrMpywJDzGk/V9gZzQNZQ8d
         GaDMNPZuNtaj250xbvVyJJ8pvV9mA4NbW/cHVEwo+unVGg1VIOnRQR4X6o3KVOJ9Wo0i
         CqlaZEz6uLv00xusQ8A/IZY5zQ+Y2AFnYnq2NBmzYmYvYYuNNL4XfnRIewbV56YBuj0Z
         2gJHnM4d0hrE6/SFLBejhWDsyVJrL6m4gH83L5kuUZIkuXeNiJBv9GUIHt8nB0O7Sf5h
         mQ03oeKkEcKEIMdGhc+Fmf/fI73/F9gXTBfDOlTT4W6pLJeSwXmKnbpbJijVAgl40ct7
         KSaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770227737; x=1770832537;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hATAnt3UH8manJo7IENnqEuwqz+p1IgqH3fjHujQfG8=;
        b=gPU1l4jvjTDG/lJ0causqKYB95+n9yRyTfehdb1+4sbwXUG3Yypn/iTntz7RU3lmLs
         WkrKfcpXnsZHZ73NSbXSg+FN78dFRF98r5KvgoerqQZGpCBprQ8GWLHrxLFKNH1ryCQS
         Wtt2iqfzqyqy5AY8N80n0ICmhMKcGJ/GhujerbLW9HT2Dsc5xmC0zf4mcGyI9m7KTqhi
         EWoPTsz0AA4A3R9J8wvS9tIdhtC6G9hzsxhPPJv2s6GPC50zfK/gBoTp6pmd9Kl88iT8
         UKKoSNY+IRvGDokw7iieKnBisFsIHz5E+7XFqmDRTbAk58m/lzBHKQcfxe2k0CKKWJP7
         SgFw==
X-Forwarded-Encrypted: i=1; AJvYcCXWiQtOmEHCUlbIqbaIoUv2VmhF7mY13jSfhO49hxVysR887AZeqs+g+7jx34H7wn2LIR4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzrPM7YEzylcf9jk9Ajjcyn53Lx0BEjEe4wZxV5/7YfJ61OFO6
	hdcHImtXHtu/0cclbq9m9ByoMpsbGrueMvTbUDgb7T7ty5Wg+qXxPyjw61A9w4Pot++s8aGbwJb
	XGugTZQ==
X-Received: from plyw11.prod.google.com ([2002:a17:902:d70b:b0:2a7:6cb8:a982])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ebc6:b0:2a2:caca:35d2
 with SMTP id d9443c01a7336-2a933cf9653mr42239015ad.16.1770227737614; Wed, 04
 Feb 2026 09:55:37 -0800 (PST)
Date: Wed, 4 Feb 2026 09:55:36 -0800
In-Reply-To: <gmdou4cp47vpx72tw3mwklwixpd3ujcdcomoplosv2u2tzfub2@wtqgzkhguoap>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260112182022.771276-1-yosry.ahmed@linux.dev>
 <20260112182022.771276-2-yosry.ahmed@linux.dev> <aYOCAH8zLLXllou7@google.com> <gmdou4cp47vpx72tw3mwklwixpd3ujcdcomoplosv2u2tzfub2@wtqgzkhguoap>
Message-ID: <aYOIGDlPs3bHLVo4@google.com>
Subject: Re: [PATCH 1/3] KVM: nSVM: Use intuitive local variables in recalc_intercepts()
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kevin Cheng <chengkev@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
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
	TAGGED_FROM(0.00)[bounces-70257-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 57FA0EB4C1
X-Rspamd-Action: no action

On Wed, Feb 04, 2026, Yosry Ahmed wrote:
> On Wed, Feb 04, 2026 at 09:29:36AM -0800, Sean Christopherson wrote:
> > 
> > >  	for (i = 0; i < MAX_INTERCEPT; i++)
> > > -		c->intercepts[i] = h->intercepts[i];
> > > +		vmcb02->control.intercepts[i] = vmcb01->control.intercepts[i];
> > >  
> > > -	if (g->int_ctl & V_INTR_MASKING_MASK) {
> > > +	if (svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK) {
> > 
> > I vote to keep a pointer to the cached control as vmcb12_ctrl.  Coming from a
> > nVMX-focused background, I can never remember what svm->nested.ctl holds.  For
> > me, this is waaaay more intuivite:
> 
> I agree it reads better, but honestly all of nSVM code uses svm->nested.ctl,
> and changing its name here just makes things inconsistent imo.

Gotta start somewhere :-)  In all seriousness, if we didn't allow chipping away
to at historical oddities in KVM, the code base would be a disaster.  I'm all for
prioritizing consistency, but I draw the line at "everything else sucks, so this
needs to suck too".

I'm not saying we need to do a wholesale rename, but giving at least
nested_vmcb02_prepare_control() the same treatment will be a huge improvement.
Actually, I'm going to go do that right now...

