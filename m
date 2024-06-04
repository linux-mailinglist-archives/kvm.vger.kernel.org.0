Return-Path: <kvm+bounces-18756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0E978FB123
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 13:30:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 709CB283AEA
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 11:30:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EBB61459E8;
	Tue,  4 Jun 2024 11:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="XZqcErSZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6408C1442E3;
	Tue,  4 Jun 2024 11:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717500600; cv=none; b=rHcBlNHf5oEtp7pR7bikzhViU7e+sxHreEE0kEPYg+8T+oceMb6l2QtkmrLC3qf2jaXPZCobIo9wJe3h9IsD4QJnWDyCWb7mdj9bjR9OjljAAbn17JqDSJhIYWyh3l/7hWOMkTAoVjCkKvMX+m/d4XZE+GfmCR8dMK2HzHmsdlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717500600; c=relaxed/simple;
	bh=CkXqB/W1Qbp/5OZYxT+hejxuua+z0I9tF5oNHkdf8Nk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=OwR1jKsoaJUM35gQyZ2lTf1T796N6/7nV6qhk2CJ1wnp/o6jqmEXCwldVWNAyX8URErwFfa3oWCeozAORT64RX3gCXoMK1+bFl979veXH6BWUtcMz8EBAxifejdZIA/xQLsaQwFRqorznqyjM2obqfI3h7S6kdArpph/r3qrZ2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=XZqcErSZ; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1717500596;
	bh=CkXqB/W1Qbp/5OZYxT+hejxuua+z0I9tF5oNHkdf8Nk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=XZqcErSZTKY9i6Vxk3+j2oeG5ra12SJJxGe1VKv11TltFC+rKfH0usdgvZIOtRR47
	 7Xu0xxtROrz3H5vHpOZJMKyP9nI4A2OrOFkjavTEGVoz+duAOfh3eJMdo1YPjWC72W
	 Mm9MJeKaS87oCf5zS/cDMASiZF6KfTmFyElLCQaLVFa4apDci72Od8AO8o1n5mdh2E
	 PTlixsfc+R0cl8cO3gTK93YVKTUKdAUpnoiN6KZdqsdoMHK82go2ykT+DvPVNmBleu
	 ARldjpaL+Bd/fS1RpSmJ/kRkeAN41KLjs/YA+vFlcRt3maQqSdqfWknqERoga/mSBP
	 oEJqXO0UhrVsg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4VtpKc3tZFz4wc3;
	Tue,  4 Jun 2024 21:29:56 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Nicholas Piggin <npiggin@gmail.com>, Shivaprasad G Bhat
 <sbhat@linux.ibm.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org
Cc: pbonzini@redhat.com, naveen.n.rao@linux.ibm.com,
 christophe.leroy@csgroup.eu, corbet@lwn.net, namhyung@kernel.org,
 pbonzini@redhat.com, jniethe5@gmail.com, atrajeev@linux.vnet.ibm.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] KVM: PPC: Book3S HV: Add one-reg interface for
 DEXCR register
In-Reply-To: <D1QZRTRK2WWI.20TJKC3RK1K9C@gmail.com>
References: <171741323521.6631.11242552089199677395.stgit@linux.ibm.com>
 <171741327891.6631.10339033341166150910.stgit@linux.ibm.com>
 <D1QZRTRK2WWI.20TJKC3RK1K9C@gmail.com>
Date: Tue, 04 Jun 2024 21:29:56 +1000
Message-ID: <87a5k12bez.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

"Nicholas Piggin" <npiggin@gmail.com> writes:
> On Mon Jun 3, 2024 at 9:14 PM AEST, Shivaprasad G Bhat wrote:
>> The patch adds a one-reg register identifier which can be used to
>> read and set the DEXCR for the guest during enter/exit with
>> KVM_REG_PPC_DEXCR. The specific SPR KVM API documentation
>> too updated.
>
> I wonder if the uapi and documentation parts should go in their
> own patch in a ppc kvm uapi topic branch?

I'll put the whole series in the topic/ppc-kvm branch, which I think is
probably sufficient.

cheers

