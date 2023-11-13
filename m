Return-Path: <kvm+bounces-1583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E07B7E97B1
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 09:30:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F28A280A06
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 08:30:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D7A21A5B1;
	Mon, 13 Nov 2023 08:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Uhi49yrp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sMu/ETcA"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CB018C0F
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 08:30:09 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C0310EB
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 00:30:08 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 7CFF61F45E;
	Mon, 13 Nov 2023 08:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1699864206; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vbXjgXdiSDa0vGaBjMJpibdxQZYoKoWdEvdyztopZ4c=;
	b=Uhi49yrpGAi47x3bbpOw29yAha5x59wWBljx+OVa5OhttYhrrXXhom3UhN7Ea58OKoXAkJ
	w/23uH2j1ZvFVB4NTNItVm5o9Gfr7XQcMlwF9ErIBTxD6kS/qHxuP4sLsFCVPXyqPFP20g
	ALH5XZAKkygqBa9owWQedYyG3D5EJ6Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1699864206;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vbXjgXdiSDa0vGaBjMJpibdxQZYoKoWdEvdyztopZ4c=;
	b=sMu/ETcAxUKtbKM7MOAnXBFevtU+vXgRURWOy3o9TYn6x4XB9A/aE2Fb/SgXQJxqITRipc
	5nKcLKtQwnWYxsBA==
Received: from hawking.nue2.suse.org (unknown [10.168.4.11])
	by relay2.suse.de (Postfix) with ESMTP id 557372D38A;
	Mon, 13 Nov 2023 08:30:06 +0000 (UTC)
Received: by hawking.nue2.suse.org (Postfix, from userid 17005)
	id 63D9F4A0363; Mon, 13 Nov 2023 09:30:06 +0100 (CET)
From: Andreas Schwab <schwab@suse.de>
To: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Cc: kvm-riscv@lists.infradead.org,  linux-riscv@lists.infradead.org,
  kvm@vger.kernel.org,  anup@brainfault.org,  atishp@atishpatra.org,
  ajones@ventanamicro.com
Subject: Re: [PATCH 1/6] RISC-V: KVM: return ENOENT in *_one_reg() when reg
 is unknown
In-Reply-To: <5d60b71e-d470-449c-b23f-77ae0a6528bb@ventanamicro.com> (Daniel
	Henrique Barboza's message of "Thu, 9 Nov 2023 16:33:25 -0300")
References: <20230731120420.91007-1-dbarboza@ventanamicro.com>
	<20230731120420.91007-2-dbarboza@ventanamicro.com>
	<mvmr0kz469m.fsf@suse.de>
	<5d60b71e-d470-449c-b23f-77ae0a6528bb@ventanamicro.com>
X-Yow: I HIJACKED a 747 to get here!!  I hope those fabulous CONEHEADS are
 at HOME!!
Date: Mon, 13 Nov 2023 09:30:06 +0100
Message-ID: <mvmfs1a3vjl.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Nov 09 2023, Daniel Henrique Barboza wrote:

> Which QEMU version are you using?

The very latest release, both host and guest.

-- 
Andreas Schwab, SUSE Labs, schwab@suse.de
GPG Key fingerprint = 0196 BAD8 1CE9 1970 F4BE  1748 E4D4 88E3 0EEA B9D7
"And now for something completely different."

