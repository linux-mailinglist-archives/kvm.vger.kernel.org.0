Return-Path: <kvm+bounces-31994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4EC19D037B
	for <lists+kvm@lfdr.de>; Sun, 17 Nov 2024 13:08:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 584AFB23B8B
	for <lists+kvm@lfdr.de>; Sun, 17 Nov 2024 12:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8490A187FE0;
	Sun, 17 Nov 2024 12:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="Vyj/UwD4"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADE2A937;
	Sun, 17 Nov 2024 12:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731845321; cv=none; b=lpmW7z8Q+NqOdOJTVjrppUeN9D2JTtpUekaOkbrblPPxxVbiVwMhW6nOXPiSFddtFGcUXY/6cNrXuu3g1Y4N/WkmNCaM/lSSTv9Uvtanr6g6tJYis11RAsUt8T6LyLBLxrfW1qLgPEnPbB4WeTTfohD08KFvJz65NmNG9gWovgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731845321; c=relaxed/simple;
	bh=TZY7uqQ/eVQa9YrKLF5xjKxP9nj6MjDMxq0OBwvNoHI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=eeD0U4mbztU3XJUvrPHpfWVDEhdFMXgV4waH+eH/uBFSp8OlXMAaM+nFLNuQbtbDnguo56svDFuNl7TqAb881uCZgqGM54U34E11/sOO96jkmcdDR1Fvk631bbLhk3TO7KtUjXcBHOM378T3ykVZ9lWBYHi9pbfKvOaW7xzpRaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=Vyj/UwD4; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1731845315;
	bh=ZxjmofktqP+h19RoqLD80A6n6Rgg6iMYO3CZ43bpgOQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Vyj/UwD4q1XzhdVaQ8hX5LCKvemZxst/sv3OhOht9p714Z5/TOM8+D+tSCMdfxLN1
	 DN4QDmA0TPqEbdq9Qa7ZKFwittBMlYOyVBDif+o7U39XGOiwpnkDxZddLeOAlBuZth
	 LFElXNFkRMXig/XecEFxqnEdjlpcThQkYVXqXMyi+MHAn+/O1IrNzzWiM+J+4s7Srv
	 0dG1GEGBEqaHVg961dBhgWS9XCnr4oD1B/G9u/7C98Sz8s+wxw6RdUaCHaVknrUNaM
	 dpiyYrXU4G+KeovwuWDpkxepWRC8qiIDfU0906OAr1JULUYyqqQh6E2tEIC3pdWcB9
	 YwlpLtf4KKmvQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4XrqKb4j4cz4wbr;
	Sun, 17 Nov 2024 23:08:35 +1100 (AEDT)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Gautam Menghani <gautam@linux.ibm.com>, npiggin@gmail.com,
 christophe.leroy@csgroup.eu, naveen@kernel.org, maddy@linux.ibm.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: PPC: Book3S HV: Mask off LPCR_MER for a vCPU
 before running it to avoid spurious interrupts
In-Reply-To: <20241028090411.34625-1-gautam@linux.ibm.com>
References: <20241028090411.34625-1-gautam@linux.ibm.com>
Date: Sun, 17 Nov 2024 23:08:38 +1100
Message-ID: <87jzd2xdtl.fsf@mpe.ellerman.id.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Gautam Menghani <gautam@linux.ibm.com> writes:
> Running a L2 vCPU (see [1] for terminology) with LPCR_MER bit set and no
> pending interrupts results in that L2 vCPU getting an infinite flood of
> spurious interrupts. The 'if check' in kvmhv_run_single_vcpu() sets the
> LPCR_MER bit if there are pending interrupts.

Applied to powerpc/fixes.

[1/1] KVM: PPC: Book3S HV: Mask off LPCR_MER for a vCPU before running it to avoid spurious interrupts
      https://git.kernel.org/powerpc/c/a373830f96db288a3eb43a8692b6bcd0bd88dfe1

cheers

