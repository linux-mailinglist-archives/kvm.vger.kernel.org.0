Return-Path: <kvm+bounces-70250-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YGYnEu+Ag2nsogMAu9opvQ
	(envelope-from <kvm+bounces-70250-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 18:25:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E08F0EAF94
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 18:25:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 03D2130191B7
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 17:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A88E234A3DC;
	Wed,  4 Feb 2026 17:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aXyttUVw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE2031B107
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 17:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770225889; cv=none; b=SnaChZSstx6gZxTWyRDwQHtqsd+Q5t5GYvt7JryYlBjIfDEyJuUE2A16ozlRxzmAI16gP2CePrhGDz8c6Fc40i8RjiMGzU9imZ+d9+qVid1m5yIV90ULGTXDp/HfInQ45knCcWpvvwi9+C/8/DGKYYQm5MBezU4Sl8//LhXMOvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770225889; c=relaxed/simple;
	bh=SNaM5eVChdUFa9hwhFxnLa1khBMv9YEYp00Fph58/eE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TwkgxXmg396/AayK+vCAaXd4HFrzyUTJUODguN1q5QVwZ6SSgUP25TLloe5I9IfNBQTlN6zLIuVX5T5/IvX0H7VMnFbS/VYFz4SeeXt+bKGN3rwH97Gxfv+8zItOg7+Boh/lkp5zh/pjIaRK437fy+NapaTMIOihODRYgNXr/Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aXyttUVw; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34abd303b4aso18330874a91.1
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 09:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770225889; x=1770830689; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ryh/AczkED/nUvo8c2PeHyj7TeQyCkqwe+hFGMfApuI=;
        b=aXyttUVw+KfV6g/jo221NE/L+C2KKmGEn7Y9Td5XF0kdWWBaZetP/E87UB1KSS/wRj
         TB9z7fyhJCsFOXJLZ7ZGT6x+NKsc6Ecj1CR6EtOKO0HXoMMJ3s0o+TwiZapLtD4VCjFx
         mPRAZNQ9S+uy7pvzuot3y6Ukj8r90GZ76M1l5GW3nR6l9mQvZZVbsvzLpPQBuvQjwF8A
         0Y6h97D5wv5tSfIBiGdFaB6doVK8Sty1xfpymkCKvOMr08ukN3h38q/AYhdrCwn2u/JS
         +4sy9sEOzRRLMbDGrDva++DR2VQ6e4C+bMVyB+VxRimrzdaP+gGenH1NGUi7jWXT0HyT
         uzaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770225889; x=1770830689;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ryh/AczkED/nUvo8c2PeHyj7TeQyCkqwe+hFGMfApuI=;
        b=UtnOhcFutaCmMEw1Fh46P4FWn7CMXhf9JFpKXh7JX/5wLMrvXjWG1T9SRhSAWnbXeL
         BTNJu5apG1WxaH6Ts4hmoTSPCHTSELM+HvLVILj6URachq5qUH4BhXxRJKzYTpVzxKwv
         JNO8ZDtZ/8+oqiEaDo+tDASKDNaMqQlc4Jhl8M6WT5yRzNsMuhZcW6U7opgrLu+54c7O
         AMpz5JUx+anSzy09gw5XhdLulg5hgVCEuCmlGI/qx5Ehp0Bvq1KNEz3xKje3awtBoPzM
         aeLrx4tmvg1/c/91ZsOg0dC7ylb/bd/H3z9aKc1tB+oqeh2wqQvgzSO74rB5tymvm2/p
         dnFQ==
X-Gm-Message-State: AOJu0Yx4OYoPUomb/vVAFanGI9nXw2n1uJy8rJwcH2sGqWAtwU483lYz
	6CeUvv/IDmi0P8LdJHqKbcn3knyRYBMFSrxzFs4HM+w9GBlZcy85Xr+Qoybj+xAtccZuYH1c7fI
	XoWvyqg==
X-Received: from pjbml9.prod.google.com ([2002:a17:90b:3609:b0:34c:e971:cfb1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d88c:b0:336:9dcf:ed14
 with SMTP id 98e67ed59e1d1-35487193865mr3359774a91.23.1770225889209; Wed, 04
 Feb 2026 09:24:49 -0800 (PST)
Date: Wed, 4 Feb 2026 09:24:47 -0800
In-Reply-To: <aYN7s_WTAp9Nr3U6@iyamahat-desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1770116050.git.isaku.yamahata@intel.com>
 <aYNP5kuRwT33yU8Z@google.com> <aYN7s_WTAp9Nr3U6@iyamahat-desk>
Message-ID: <aYOA303zHQY4CUf1@google.com>
Subject: Re: [PATCH 00/32] KVM: VMX APIC timer virtualization support
From: Sean Christopherson <seanjc@google.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: kvm@vger.kernel.org, isaku.yamahata@gmail.com, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,redhat.com,intel.com];
	TAGGED_FROM(0.00)[bounces-70250-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Queue-Id: E08F0EAF94
X-Rspamd-Action: no action

On Wed, Feb 04, 2026, Isaku Yamahata wrote:
> On Wed, Feb 04, 2026 at 05:55:50AM -0800,
> Sean Christopherson <seanjc@google.com> wrote:
> 
> > > [1] Intel Architecture Instruction Set Extensions and Future Features
> > > September 2025 319433-059
> > > Chapter 8 APIC-TIMER VIRTUALIZATION
> > > https://cdrdv2.intel.com/v1/dl/getContent/671368
> > 
> > What CPU generation is expected to have APIC-timer virtualization?  DMR?
> 
> CWF.

What P-core CPU generation?  No offence to the Forest family, but I don't think
most people are chomping at the bit to get their hands on CWF :-)

