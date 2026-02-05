Return-Path: <kvm+bounces-70313-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4OZ7F9BdhGnS2gMAu9opvQ
	(envelope-from <kvm+bounces-70313-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 10:07:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 19105F04CF
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 10:07:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9FABA301C573
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 09:00:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15A173ACA53;
	Thu,  5 Feb 2026 08:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t+Jh54xm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF56392806;
	Thu,  5 Feb 2026 08:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770281858; cv=none; b=UaRK8Tg6bXIUjuGoH3jmF0izI+R8L376ekxuSgAYs/KPjBPCho/q6i5My2BpRM0RW3b+Xo4A7EynlPt+bSh6X7dAKwKaYIjbelUGmWw4itIKU0hZv8vcvtC19lWYypqeh+Z4sm5lJpjhKVQvzBUWDA1OoCH1Amu6D4sR4EkkrTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770281858; c=relaxed/simple;
	bh=NMpINejUDk41lLVnO0baNt+n3V31uNWLnmlfSOm3zmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I2CoM5ObtEFMVKT3BAY4tbHmcbdBzpyI2K0J9JkiWlwOwg4Qs5yDXMl3UYngTftgRpNXj8ZNlG6KQa/JqDHoLSRoWK5oMfmgeR5SNGSDMqsV6MDUbH0oI9xpc5hmC9AY2rKAEvvH7NaAFvxd/0RqNsVRC7sBEXrfBorunnieknc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t+Jh54xm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E522EC4CEF7;
	Thu,  5 Feb 2026 08:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770281858;
	bh=NMpINejUDk41lLVnO0baNt+n3V31uNWLnmlfSOm3zmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+Jh54xmNkIHHGxBrC7IqS6P87tiotu9H6iVNJshyTNRzvuagX5mNzntr9/mMxZnp
	 fzhsxEazwM31R+rBoX8Rvl2w8D9kHRk23eMXgcva+QxjiQDrQCu35vD/3qMPqIaQqq
	 eOdg9BDIZK1sI+gYyarlWvoe9G8+TlNDbJPfu6ZKViIzOQ9CdKGG3+Jhc99PNwuZGp
	 h/qYF0dtUVFcBUR/Ufw/S8lFPsaJrJBGBgFQqYe4d96CmV4nez23K03VHj5dRE9sg1
	 K2Pl8FaJUXK9MoilYFz7rXQ6/mrR/cxWjqHsJOHKBHIh7y2TrnCUKA/2wrIZ1ACOhz
	 v+jXWXit+mX3Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vnvB9-00000008kjb-1Jfv;
	Thu, 05 Feb 2026 08:57:35 +0000
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
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v1 0/3] KVM: arm64: Standardize debugfs iterators
Date: Thu,  5 Feb 2026 08:57:32 +0000
Message-ID: <177028184517.3559278.15033024966094248612.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202085721.3954942-1-tabba@google.com>
References: <20260202085721.3954942-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, tabba@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, oupton@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70313-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 19105F04CF
X-Rspamd-Action: no action

On Mon, 02 Feb 2026 08:57:18 +0000, Fuad Tabba wrote:
> This series refactors the debugfs implementations for `idregs` and
> `vgic-state` to use standard `seq_file` iterator patterns.
> 
> The existing implementations relied on storing iterator state within
> global VM structures (`kvm_arch` and `vgic_dist`). This approach
> prevented concurrent reads of the debugfs files (returning -EBUSY) and
> created improper dependencies between transient file operations and
> long-lived VM state.
> 
> [...]

Applied to next, thanks!

[1/3] KVM: arm64: Use standard seq_file iterator for idregs debugfs
      commit: dcd79ed450934421158d81600f1be4c2e2af20bf
[2/3] KVM: arm64: Reimplement vgic-debug XArray iteration
      commit: 5ab24969705a9adadbc1d3cff4c1c15df174eafb
[3/3] KVM: arm64: Use standard seq_file iterator for vgic-debug debugfs
      commit: fb21cb08566ebed91d5c876db5c013cc8af83b89

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



