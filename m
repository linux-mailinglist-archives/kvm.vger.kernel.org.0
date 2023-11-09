Return-Path: <kvm+bounces-1315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 946437E66E7
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 10:37:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CBA92816D0
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 09:37:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55A0E13AC0;
	Thu,  9 Nov 2023 09:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sJDP/nIg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="EjdeUC7m"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB918125C4
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 09:37:11 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9412702
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 01:37:11 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 2A1F91F8AF;
	Thu,  9 Nov 2023 09:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1699522629; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pHAFms+aHcx4DCYQ0tYBa0dx6EiqlqFD35MEJDtihA8=;
	b=sJDP/nIgbKtH8wLLxADluvoy1q3AAIw6lsd555PjatdmHTMLCtkoFkCSuxE2/LjGVUW4pV
	kgdq+ZhRdFp4WICtBWMHWJXjxV6MzCL4Mo+lgcIZgW3avx/35GQrf8fFOpDjfEaLgZIlUv
	eSckj5n0K0dgQw6iq+pgQzySYJtENx8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1699522629;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pHAFms+aHcx4DCYQ0tYBa0dx6EiqlqFD35MEJDtihA8=;
	b=EjdeUC7mXio8SULkRjlqZYaAFaqzMKEU6z7zaPlPr71BUQgDYeh/+ea4dMIzskKRcMyedw
	26E4rdvqeHyImVBQ==
Received: from hawking.nue2.suse.org (unknown [10.168.4.11])
	by relay2.suse.de (Postfix) with ESMTP id E8A202C930;
	Thu,  9 Nov 2023 09:37:08 +0000 (UTC)
Received: by hawking.nue2.suse.org (Postfix, from userid 17005)
	id 0CC834AAD26; Thu,  9 Nov 2023 10:37:09 +0100 (CET)
From: Andreas Schwab <schwab@suse.de>
To: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Cc: kvm-riscv@lists.infradead.org,  linux-riscv@lists.infradead.org,
  kvm@vger.kernel.org,  anup@brainfault.org,  atishp@atishpatra.org,
  ajones@ventanamicro.com
Subject: Re: [PATCH 1/6] RISC-V: KVM: return ENOENT in *_one_reg() when reg
 is unknown
In-Reply-To: <20230731120420.91007-2-dbarboza@ventanamicro.com> (Daniel
	Henrique Barboza's message of "Mon, 31 Jul 2023 09:04:15 -0300")
References: <20230731120420.91007-1-dbarboza@ventanamicro.com>
	<20230731120420.91007-2-dbarboza@ventanamicro.com>
X-Yow: I guess you guys got BIG MUSCLES from doing too much STUDYING!
Date: Thu, 09 Nov 2023 10:37:09 +0100
Message-ID: <mvmr0kz469m.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Jul 31 2023, Daniel Henrique Barboza wrote:

> Existing userspaces can be affected by this error code change. We
> checked a few. As of current upstream code, crosvm doesn't check for any
> particular errno code when using kvm_(get|set)_one_reg(). Neither does
> QEMU.

That may break qemu:

$ qemu-system-riscv64 -cpu rv64 -machine virt,accel=kvm      
qemu-system-riscv64: Unable to read ISA_EXT KVM register ssaia, error -1

-- 
Andreas Schwab, SUSE Labs, schwab@suse.de
GPG Key fingerprint = 0196 BAD8 1CE9 1970 F4BE  1748 E4D4 88E3 0EEA B9D7
"And now for something completely different."

