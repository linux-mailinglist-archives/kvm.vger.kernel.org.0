Return-Path: <kvm+bounces-67561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B74C8D09D60
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 13:40:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 15B1D303D6B0
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 12:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8674935B13F;
	Fri,  9 Jan 2026 12:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U7f4gKtt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44EB33B6E8;
	Fri,  9 Jan 2026 12:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961929; cv=none; b=WzEs+KdUXYqCBbQC9ke36qrny1wmKY6+yxjh6beIAGFwT8ZAAM9KbP3vjSpGp6BaofahpZtsK1qza9lB+GqdjsmbjzYvP6sGW8Gh9YPsOMihDVYVMaqsO+YDwWhHCwRJLNTF3N5EndqoHVMPFHhYWIVL/4tKnZ5dPcDzuffrhzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961929; c=relaxed/simple;
	bh=Gnps4QAJzsWyd1d0flxw0wp7BrfKE6qbMDYhxNfwSCg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=OFx/+fj8HqnfhBcCUVLEheLSTQyTm0vDwj+yRqwGYnPXEv9dxktVZUvySeI/C+fnMXlmdXS5HmNnVtGG31eVdA7KlKNX1FueKTsWHXX89HKiFlaVOruKB9y+pk40CGR7u75kDpXxiI4CK6DOWh1rcXovg4kHWqCnqJicCrLDu7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U7f4gKtt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38B0C16AAE;
	Fri,  9 Jan 2026 12:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767961929;
	bh=Gnps4QAJzsWyd1d0flxw0wp7BrfKE6qbMDYhxNfwSCg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=U7f4gKttWVnObpRY/GMglbRkuMybrifWFIEJzZgU7rW/Ttk+ji8HEmmhi1xVTyrH2
	 3so17F46G1on/a17UJxoocOnOjrkpAMX+PP5V+sGRDSODavGwnYh8lyEiHOdSkuo4Q
	 JNnfMseyLIna1/3L7JeaEj/PcjHQuURETTS7QhFUPLXZjxeY+SOkrNUueuoKolkWiA
	 cm4PQhrFSM1W8OqxC6p3Ux8HTDA6GZYnDbQ8GNouKd6TTfHX41e6RJxboEUtPuQlaC
	 QqzSauz4nHc7lIFQkccJ0YT1NzdGmpU/7sq9fudS2yN2JbvF9pLYD5ku0s6jKBSZts
	 7N2lVCziHIsGw==
From: Thomas Gleixner <tglx@kernel.org>
To: Anup Patel <anup@brainfault.org>, Xu Lu <luxu.kernel@bytedance.com>
Cc: atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] irqchip/riscv-imsic: Adjust the number of available
 guest irq files
In-Reply-To: <CAAhSdy0dcMhmENZ9cMkE7Rh8u93sRiYozxEWgJ0tvHVUiRdykw@mail.gmail.com>
References: <20251222093718.26223-1-luxu.kernel@bytedance.com>
 <CAAhSdy0dcMhmENZ9cMkE7Rh8u93sRiYozxEWgJ0tvHVUiRdykw@mail.gmail.com>
Date: Fri, 09 Jan 2026 13:32:05 +0100
Message-ID: <874iovrmpm.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 04 2026 at 18:46, Anup Patel wrote:
> On Mon, Dec 22, 2025 at 3:07=E2=80=AFPM Xu Lu <luxu.kernel@bytedance.com>=
 wrote:
>
> Reviewed-by: Anup Patel <anup@brainfault.org>
>
> @tglx, Is it okay to take this through the KVM RISC-V tree
> since this change focuses on guest files used by KVM ?

Sure, if there are no conflicts against tip irq/drivers.

Acked-by: Thomas Gleixner <tglx@kernel.org>

