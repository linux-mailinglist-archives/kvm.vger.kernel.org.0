Return-Path: <kvm+bounces-72635-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UOdTBm2Ip2nliAAAu9opvQ
	(envelope-from <kvm+bounces-72635-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 02:18:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A00721F92B8
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 02:18:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5F36130DDE38
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 01:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C58930AAD0;
	Wed,  4 Mar 2026 01:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rxc3NKAW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E774336894;
	Wed,  4 Mar 2026 01:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772587098; cv=none; b=seGaMAkUgNgbJZmf6u9nfMq83W+nO/h5WiQf0EnbNFXIivwfl2QRHHwmqtSmQe54ylWWzrQwYhmqJ1PSIQGcivz2nknb63NZJhp/Pr32K6ktT8d9wvTsmfPamrfwNkZ3jIY9MdARzJLUloq5mVThhercZUEbrx0h7yv42QP6ChA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772587098; c=relaxed/simple;
	bh=G3xmD+O4jZ6ETBRFP445HsaMwNRqdrmI0/Dp3CAPHCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mNlFYvMY4Xt86VHxjy1w//qsuBBISBiBAN2FVYGTWu+GM92ortsiYJyQoZkTAI5vBUKOPsIyS4VsamDLJWmaGu4ONqKZf3QQhgq2meM/1sYtSSdXQE2r3CunnyrNYN8qKU13UPdRnHrQgL3DBYZ5IJuCLh0rjV6SLYWBI3m2ngQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rxc3NKAW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E141FC116C6;
	Wed,  4 Mar 2026 01:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772587098;
	bh=G3xmD+O4jZ6ETBRFP445HsaMwNRqdrmI0/Dp3CAPHCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rxc3NKAWW8OypUJqutudzBu6bSm7PhXNgaeaILhjnQDqq50zLD8BsbraO91PKjuPB
	 8sptGm86Wf8sZRR4QsiAv2dRQf3inQNFbFDtmRNFt70BWK4sxwe2AySVqo4MFxn4+v
	 QkQjTTFoTiOHK7w9oMuaj7rqqTYzzExY0QGFujv+1EcBr0QEyJqFair72F9nuAzOI/
	 gCSOt2ua5001454U+QMrNToQ1FGVq4Wibnudm/2l9/+1YJIY1cGvfiyLu3UE6u+bmF
	 2PwVYsZsh9c2+uF3U8uWRfHQTm+PlLyxnkILeyQGUUIAMyWJWrfrY7yM8RqS+qozpl
	 VDCUpvU4oPlgA==
Date: Wed, 4 Mar 2026 01:18:16 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Cheng <chengkev@google.com>
Subject: Re: [PATCH v5 1/2] KVM: nSVM: Raise #UD if unhandled VMMCALL isn't
 intercepted by L1
Message-ID: <ibl5efdoqub3mgpien2yn7ml4ne5wjx5rsot3tgydk27k7cwuo@zz5pvhg4n6mh>
References: <20260304002223.1105129-1-seanjc@google.com>
 <20260304002223.1105129-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304002223.1105129-2-seanjc@google.com>
X-Rspamd-Queue-Id: A00721F92B8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72635-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 04:22:22PM -0800, Sean Christopherson wrote:
> From: Kevin Cheng <chengkev@google.com>
> 
> Explicitly synthesize a #UD for VMMCALL if L2 is active, L1 does NOT want
> to intercept VMMCALL, nested_svm_l2_tlb_flush_enabled() is true, and the
> hypercall is something other than one of the supported Hyper-V hypercalls.
> When all of the above conditions are met, KVM will intercept VMMCALL but
> never forward it to L1, i.e. will let L2 make hypercalls as if it were L1.
> 
> The TLFS says a whole lot of nothing about this scenario, so go with the
> architectural behavior, which says that VMMCALL #UDs if it's not
> intercepted.
> 
> Opportunistically do a 2-for-1 stub trade by stub-ifying the new API
> instead of the helpers it uses.  The last remaining "single" stub will
> soon be dropped as well.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Fixes: 3f4a812edf5c ("KVM: nSVM: hyper-v: Enable L2 TLB flush")
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Kevin Cheng <chengkev@google.com>
> Link: https://patch.msgid.link/20260228033328.2285047-5-chengkev@google.com
> [sean: rewrite changelog and comment, tag for stable, remove defunct stubs]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Yosry Ahmed <yosry@kernel.org>

