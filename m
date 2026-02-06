Return-Path: <kvm+bounces-70463-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GEYtLiEihmm/JwQAu9opvQ
	(envelope-from <kvm+bounces-70463-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 18:17:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id D2086100D84
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 18:17:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2FA57300B8DD
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 17:17:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 087473B5315;
	Fri,  6 Feb 2026 17:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FZRxE9Lx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9BC32ABF3;
	Fri,  6 Feb 2026 17:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770398224; cv=none; b=qssaF9Mh8ph+1CdTxSqc0MGt2PvGFHSbvcUogOUu8bVxhG0erzS6GmBrmXy7jacNgMCaF1RNwBpkPUiD8L+1EpoLM/MTciYXiWeMuM1CL47ztr+SJb+x7TeTjhaZITRnl0+hjkE4D8bEoe8+g098nco12h7WM31/ouG+uAOvCJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770398224; c=relaxed/simple;
	bh=nslo59HpsStxkkvpmnYaM61zjTKZmzGv2Es+Qv5bb8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KlHLfdQMRQL+miyUs/BKwK7lkr3pEeMeS/pFxwO7H0u4T2zV8L7Kv8jS+IC092DkIa3PCgUtWGS+LIwvQykLfBvK1CzrMlHrFWSntqbKLjbUrWKsTCBNlYH+Zyqb+R407aaNWH+yIPwIPQE9H2Vx20rbln9IWAl0tJ/zTVfHhOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FZRxE9Lx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A05C116C6;
	Fri,  6 Feb 2026 17:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770398223;
	bh=nslo59HpsStxkkvpmnYaM61zjTKZmzGv2Es+Qv5bb8k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FZRxE9LxwHGrjNngUz3EraGHiKOkJTbEqVyF0pnv81HrfDES/mFN0zh2P2PLv6WBA
	 etKIun6qF5uODF/749WEY58MekgX4Bg+dBHnnnJNlP/q9FGezw9fXc2yJvY2d1pKOA
	 lzbewZGz8wU0u0kgY+vduT7ZDHrIzNBKwZU+rgFIP33b2nkOGYoKoGVJ5b2TPWMFov
	 Ec6kc9ibyOLRX+4VVUDRb1et9R/sbBPHtgc4iWWzuJ9pXg272cLJ/dv5tSimwm4bYW
	 2ddnUnIN4Gq0hpZrCSSN9wf//3wtIVPPZifD3g2EQAKCiVxFo7YfF5OwOPjzy1JesC
	 je77dbQRlMR/g==
Date: Fri, 6 Feb 2026 22:41:14 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	"Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH 2/2] KVM: SVM: Set/clear CR8 write interception when AVIC
 is (de)activated
Message-ID: <aYYgShD2-47P51ZM@blrnaveerao1>
References: <20260203190711.458413-1-seanjc@google.com>
 <20260203190711.458413-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260203190711.458413-3-seanjc@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70463-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[naveen@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,oracle.com:email]
X-Rspamd-Queue-Id: D2086100D84
X-Rspamd-Action: no action

On Tue, Feb 03, 2026 at 11:07:10AM -0800, Sean Christopherson wrote:
> Explicitly set/clear CR8 write interception when AVIC is (de)activated to
> fix a bug where KVM leaves the interception enabled after AVIC is
> activated.  E.g. if KVM emulates INIT=>WFS while AVIC is deactivated, CR8
> will remain intercepted in perpetuity.

Looking at svm_update_cr8_intercept(), I suppose this could also more 
commonly happen whenever AVIC is inhibited (IRQ Windows, as an example)?

> 
> On its own, the dangling CR8 intercept is "just" a performance issue, but
> combined with the TPR sync bug fixed by commit d02e48830e3f ("KVM: SVM:
> Sync TPR from LAPIC into VMCB::V_TPR even if AVIC is active"), the danging
> intercept is fatal to Windows guests as the TPR seen by hardware gets
> wildly out of sync with reality.
> 
> Note, VMX isn't affected by the bug as TPR_THRESHOLD is explicitly ignored
> when Virtual Interrupt Delivery is enabled, i.e. when APICv is active in
> KVM's world.  I.e. there's no need to trigger update_cr8_intercept(), this
> is firmly an SVM implementation flaw/detail.
> 
> WARN if KVM gets a CR8 write #VMEXIT while AVIC is active, as KVM should
> never enter the guest with AVIC enabled and CR8 writes intercepted.
> 
> Fixes: 3bbf3565f48c ("svm: Do not intercept CR8 when enable AVIC")
> Cc: stable@vger.kernel.org
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Naveen N Rao (AMD) <naveen@kernel.org>
> Cc: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 6 ++++--
>  arch/x86/kvm/svm/svm.c  | 9 +++++----
>  2 files changed, 9 insertions(+), 6 deletions(-)

LGTM.
Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>


Thanks,
Naveen


