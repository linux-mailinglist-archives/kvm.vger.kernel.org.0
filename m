Return-Path: <kvm+bounces-69870-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cNShFNjIgGl3AgMAu9opvQ
	(envelope-from <kvm+bounces-69870-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 16:55:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B39DECE79F
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 16:55:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8497A304F347
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 15:47:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D969424BBE4;
	Mon,  2 Feb 2026 15:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DfsrRkto"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE4245948;
	Mon,  2 Feb 2026 15:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770047257; cv=none; b=mQfGQI45wsN2raBa4a1ZSRwUb7ue7uQcG42OYzGD7Sauk60Rao6uSlRABIokx2XHj7n2BxNldrLXANZO6Iruh5peln6CtrHWgXouxc4Lg2LerlxeOl12DSxyclupqj2EnObdtpmzh/K3r1+vGmH6YEuEpHb9pgs8W8wWuZ/SO/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770047257; c=relaxed/simple;
	bh=DQHMSgsv3Ovvgk7wrUhAAoPFmN9TTDqtPHu6Cz7HA7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M7YE17e9tN0JY8z85njE0DaG5h7M18mDxqGrR+Dr9JWVJ+N8wGzQ60EsfXDl6xlbzuOR08yguAPyJWLTd1LRpLvsmPz1NnzUzceYzyHmhvyb0lJQVf9F4WGDZPLw5iq85fv+OMuuB+xcFRgAjbraJO/CBjwZLnbqXE8mYVZCiu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DfsrRkto; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5516C116C6;
	Mon,  2 Feb 2026 15:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770047256;
	bh=DQHMSgsv3Ovvgk7wrUhAAoPFmN9TTDqtPHu6Cz7HA7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DfsrRktoympOnvAdNukfodGNDG57OpTppFaeZUdDCTWc08e5pktKeeyIy6iMkaaF3
	 4J+6hXYdrb1E+IYZHxefkc/te9dqgZh7EMAWS/Vk8ITrBHA1IsJYQe7Zx2MXtDanlL
	 SNj+7YAA+pCre+3IUVjJFjRNoLSDgE9/iDyx4Pt4wAvwejiL8/M302wAwTKIqTAd9u
	 NCqG4KsaqtqZ7x0uVN3sVCVhNLMiMLh1GCFzmwvIyoRddjQ+J4zG0mMtcoS/gd9MhL
	 5N9NdEqIys5AkbDfDr+mDxI0B/q+vJuBkq3Zmh5QlGhSwKPNQOJ3rKth3itJFcpoL1
	 8ouC5IMV34uDg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vmw9G-00000007pPD-1BGL;
	Mon, 02 Feb 2026 15:47:34 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Fuad Tabba <tabba@google.com>
Cc: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	qperret@google.com,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v1] KVM: arm64: nv: Avoid NV stage-2 code when NV is not supported
Date: Mon,  2 Feb 2026 15:47:31 +0000
Message-ID: <177004724421.2704560.7699222325442161081.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202152310.113467-1-tabba@google.com>
References: <20260202152310.113467-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, tabba@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, qperret@google.com, oupton@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69870-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B39DECE79F
X-Rspamd-Action: no action

On Mon, 02 Feb 2026 15:22:53 +0000, Fuad Tabba wrote:
> The NV stage-2 manipulation functions kvm_nested_s2_unmap(),
> kvm_nested_s2_wp(), and others, are being called for any stage-2
> manipulation regardless of whether nested virtualization is supported or
> enabled for the VM.
> 
> For protected KVM (pKVM), `struct kvm_pgtable` uses the
> `pkvm_mappings` member of the union. This member aliases `ia_bits`,
> which is used by the non-protected NV code paths. Attempting to
> read `pgt->ia_bits` in these functions results in treating
> protected mapping pointers or state values as bit-shift amounts.
> This triggers a UBSAN shift-out-of-bounds error:
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: nv: Avoid NV stage-2 code when NV is not supported
      commit: 0c4762e26879acc101790269382f230f22fd6905

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



