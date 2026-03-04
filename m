Return-Path: <kvm+bounces-72638-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wF2wNuiIp2nliAAAu9opvQ
	(envelope-from <kvm+bounces-72638-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 02:20:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C6951F92FC
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 02:20:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6C728306DFD0
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 01:20:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 208E530C610;
	Wed,  4 Mar 2026 01:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gLHrAYRY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D191448E0;
	Wed,  4 Mar 2026 01:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772587220; cv=none; b=sr7Mo1O9NtS+X+1v8fQNqW6i5sbBWFB+LjczYD83dlSLEGiFAkMdJy23UXi62s/YuhVEy/oAZhNxDxYqNfAvKuI/bnhwwnoZZ21eZ1TONkrAHWeWKHZx/6zcZi1y5z6O4uyn38N1P1lSWTu1EXoFrVUPgjwjAzue6yPCFa24POU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772587220; c=relaxed/simple;
	bh=ur4Enw+0NKH+vSelRxAT0CBqk0JFdyNWgPT6pZVUufE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fB51zrGxvn5efdJu74EvLHjE1OGUPVrkXpIVgceKePn3BBXPFbdXurQWOPyE8IaJvq/9OjzsCvJ4myRW9FIF+Mq7fHUFpVCClAZANuZxQPK+Eadf6e8EVa4Mjji8+LxbUJejTIFwZ7Pv3oh34b4Eex/gj+nFTZpZC4iUEq45urM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gLHrAYRY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1AEC116C6;
	Wed,  4 Mar 2026 01:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772587219;
	bh=ur4Enw+0NKH+vSelRxAT0CBqk0JFdyNWgPT6pZVUufE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gLHrAYRYTYGo31ZHmqiglWRcXWBjMovsG8BffPCHw0zH9ihgqfnE8kQUHvT8hZ2BA
	 eEJhASUttzQD3oiyBXc8+9TloIqkiwWml0XsRdlVoJTy6pRp0I6haj7xtdu+Pevtn1
	 Fld0wnV5Z3gOZntQC55/xyW4qXnhsSSH7CpQb1HDkRdZcUipwRBL0XSqw8UuVbBZpy
	 7z/2v2Wn03xE82qxFgSz6p+XkbPlwYpQ4VGUnVtNzhgbA+027SMzcVv7KgdG8x5zqK
	 QMkphwn8D6dF+GbKgKVZ70JyvvAwjRg1C+3BMJc4iwBaTQvkziObveCLGxlxchf5y2
	 5xh8kvmJXi2EA==
Date: Wed, 4 Mar 2026 01:20:18 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kevin Cheng <chengkev@google.com>
Subject: Re: [PATCH v5 2/2] KVM: SVM: Recalc instructions intercepts when
 EFER.SVME is toggled
Message-ID: <djl44uol34n6abkad57n55fas63bnkenfxe2vc6rh4x35hwt7s@azkgjk4dibzy>
References: <20260304003010.1108257-1-seanjc@google.com>
 <20260304003010.1108257-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304003010.1108257-3-seanjc@google.com>
X-Rspamd-Queue-Id: 8C6951F92FC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72638-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 04:30:10PM -0800, Sean Christopherson wrote:
> From: Kevin Cheng <chengkev@google.com>
> 
> The AMD APM states that VMRUN, VMLOAD, VMSAVE, CLGI, VMMCALL, and
> INVLPGA instructions should generate a #UD when EFER.SVME is cleared.
> Currently, when VMLOAD, VMSAVE, or CLGI are executed in L1 with
> EFER.SVME cleared, no #UD is generated in certain cases. This is because
> the intercepts for these instructions are cleared based on whether or
> not vls or vgif is enabled. The #UD fails to be generated when the
> intercepts are absent.
> 
> Fix the missing #UD generation by ensuring that all relevant
> instructions have intercepts set when SVME.EFER is disabled.
> 
> VMMCALL is special because KVM's ABI is that VMCALL/VMMCALL are always
> supported for L1 and never fault.
> 
> Signed-off-by: Kevin Cheng <chengkev@google.com>
> [sean: isolate Intel CPU "compatibility" in EFER.SVME=1 path]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Yosry Ahmed <yosry@kernel.org>

