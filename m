Return-Path: <kvm+bounces-72636-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QDijNNCIp2nliAAAu9opvQ
	(envelope-from <kvm+bounces-72636-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 02:20:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FAA11F92EC
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 02:20:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7C33330FD75C
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 01:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FCA430BF66;
	Wed,  4 Mar 2026 01:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="csOaS06y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531B81EB1AA;
	Wed,  4 Mar 2026 01:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772587174; cv=none; b=dLwG4C/PMCpqNRADtcj12qoRT6ybW7QHNfj/klrP+lczrMne620QTYySXxGYLeSJTr0EybUofshX+jU0HWVLomcVuOThKBDKoARyY6G4+NxbHlLt2q3NyjgSxNglqUqm0j+/Ur05u1SToB24nAtipJ4mc8DA15WKlpg/YUOpHpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772587174; c=relaxed/simple;
	bh=oafWxqUCbAzpFiSaq3wucFKArq/mduWRauKmKYWFqa0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LQyJ4+JTwhpaJ1r+/ul6PcVeHYc/bsKDZakzitYX5ee8y3SctK7KjtIjAIAoDYFsYlHz3tyd23/Pet0Y/cWd4GsoVINbotTtlbOkPUZv9k2FtidtWAfHJwVbyhvGa8RSrH6KdrxIx2njxt/YQSiwj9RSyGnmlWLUXkPDl6fenlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=csOaS06y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3B5C116C6;
	Wed,  4 Mar 2026 01:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772587174;
	bh=oafWxqUCbAzpFiSaq3wucFKArq/mduWRauKmKYWFqa0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=csOaS06yKSZn99SOZB1CXThH5gFN1o39QQVwp5U9s5K7ImsTCg0PgwkyfIUC9X/mh
	 0/nZCcE1W8vIDCb2a1uJj/fYkWLCw60J3oRyIvBXbecQef1Rvly43QKUx34cRtiPUq
	 MiuV54NZCGlm8+xMAA5+JqojixBUJ5QYI26NuZf7AFvXDB8OVeTm1RtO0Xo3y7vTkY
	 slgUvPd0DH6SrRL8blMbVZU7Bt84PqKEKYHiJzf5JpoYm9x5JDhHoUejDxAJaZHu2K
	 ami5y/8zN80DT3dZbs++FIaFVsZW9hyFsULAQDDNOQ/r5d4NTlFHlTsVQdjWryIdzL
	 NGWY3TYC60LXw==
Date: Wed, 4 Mar 2026 01:19:32 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kevin Cheng <chengkev@google.com>
Subject: Re: [PATCH v5 1/2] KVM: SVM: Move STGI and CLGI intercept handling
Message-ID: <s32rv6jjrvlzoo3pkiseuzuo5nbw4rpneuqkq3ogwplod4ciif@bw5pwqrmaabg>
References: <20260304003010.1108257-1-seanjc@google.com>
 <20260304003010.1108257-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304003010.1108257-2-seanjc@google.com>
X-Rspamd-Queue-Id: 6FAA11F92EC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72636-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 04:30:09PM -0800, Sean Christopherson wrote:
> From: Kevin Cheng <chengkev@google.com>
> 
> Move STGI/CLGI intercept handling to svm_recalc_instruction_intercepts()
> in preparation for making the function EFER.SVME-aware.  This will allow
> configuring STGI/CLGI intercepts along with other intercepts for other SVM
> instructions when EFER.SVME is toggled (KVM needs to intercept SVM
> instructions when EFER.SVME=0 to inject #UD).
> 
> When clearing the STGI intercept in particular, request KVM_REQ_EVENT if
> there is at least one a pending GIF-controlled event. This avoids breaking
> NMI/SMI window tracking, as enable_{nmi,smi}_window() sets INTERCEPT_STGI
> to detect when NMIs become unblocked. KVM_REQ_EVENT forces
> kvm_check_and_inject_events() to re-evaluate pending events and re-enable
> the intercept if needed.
> 
> Extract the pending GIF event check into a helper function
> svm_has_pending_gif_event() to deduplicate the logic between
> svm_recalc_instruction_intercepts() and svm_set_gif().
> 
> Signed-off-by: Kevin Cheng <chengkev@google.com>
> [sean: keep vgif handling out of the "Intel CPU model" path]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Yosry Ahmed <yosry@kernel.org>

