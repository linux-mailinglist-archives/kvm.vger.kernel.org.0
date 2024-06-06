Return-Path: <kvm+bounces-19012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 978588FE694
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 14:34:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3277E287C81
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 12:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDF10195B0E;
	Thu,  6 Jun 2024 12:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="oEsl7eiT"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C75D195981;
	Thu,  6 Jun 2024 12:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717677284; cv=none; b=g58V7m5/QTB7M8Ia2+o1zIAppNtOELSKsa7c67UxRkFTdLfPdJoIkld9tNB92uZiexpmj6wHkFh+GuZZRinNAQC7ztWqURrf3jFniAjiJUEWmWRjvWyZB6FRvWDNBd+j8vsglF+40UpOPRnKCHxk7ZzblRDiq7WIYs1qnDglF4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717677284; c=relaxed/simple;
	bh=0fkLbR9p2dhDQA9cJ5BSp3dEFl9lCYxyftDR53eNukM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JF+Khohkc6hst0MRQBO/e886DwXnLMSS9u1Ull/tKus306/zfsXFpXXy8gHh081pxztJVC9TVtsi9fpQVfMZw/jXBVETXZ/rfnXkMqRX/QPlPOFrb3+pKEbfCyXBr72t7Zu5vrQAkHwR/KECum5V5XMRRMe0FL3GG1UzcL+nKZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=oEsl7eiT; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1717677281;
	bh=Q0C01R8stQPACIN05Xp2WxJuZeUd9lyUWWYpiuOc0io=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=oEsl7eiThFrFIbhjFPRoknZn3lcd9zfJh52Jwh28BbLdmGM7ud1eMT4QsMasuTtU1
	 8WVdZmhtNttTQOfEjE+U+UU5qmjCibY3NComOGyhqyJwhGzgJvtXVluKO1Q+E6VR1Y
	 QmzlEa1Phw1f94t+itlcx6BXZGWRhIznjLq/X6lrcW+lKuhSdNLXqxG2duiE/uKVxu
	 wIt93FSpTxyGzbLfhrph/oyWSAfP2ESuutcDSmegZ1AOFCMxoNn01gF8RlOJL+VkHO
	 0CZhnUZHZlzdFln9kDIXI11heYP3wDiWnxsJN9LP3AFAcNkJG6tYjrN4zUNjKIjHUy
	 Yt7t2VXWmqnPg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4Vw3gN3lbXz4wc3;
	Thu,  6 Jun 2024 22:34:40 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Gautam Menghani <gautam@linux.ibm.com>, npiggin@gmail.com,
 christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org,
 naveen.n.rao@linux.ibm.com, corbet@lwn.net
Cc: linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Fix doorbell emulation for v2 API on PPC
In-Reply-To: <yzixdicgdqcten6eglcc4zlhn3sbnqrax3ymzzqvdmxvdh63zx@xymyajel3aoh>
References: <20240605113913.83715-1-gautam@linux.ibm.com>
 <yzixdicgdqcten6eglcc4zlhn3sbnqrax3ymzzqvdmxvdh63zx@xymyajel3aoh>
Date: Thu, 06 Jun 2024 22:34:40 +1000
Message-ID: <87le3ip7vj.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Gautam Menghani <gautam@linux.ibm.com> writes:
> On Wed, Jun 05, 2024 at 05:09:08PM GMT, Gautam Menghani wrote:
>> Doorbell emulation for KVM on PAPR guests is broken as support for DPDES
>> was not added in initial patch series [1].
>> Add DPDES support and doorbell handling support for V2 API. 
>> 
>> [1] lore.kernel.org/linuxppc-dev/20230914030600.16993-1-jniethe5@gmail.com
>> 
>> Changes in v2:
>> 1. Split DPDES support into its own patch
>> 
>> Gautam Menghani (2):
>>   arch/powerpc/kvm: Add DPDES support in helper library for Guest state
>>     buffer
>>   arch/powerpc/kvm: Fix doorbell emulation for v2 API
>> 
>>  Documentation/arch/powerpc/kvm-nested.rst     | 4 +++-
>>  arch/powerpc/include/asm/guest-state-buffer.h | 3 ++-
>>  arch/powerpc/include/asm/kvm_book3s.h         | 1 +
>>  arch/powerpc/kvm/book3s_hv.c                  | 5 +++++
>>  arch/powerpc/kvm/book3s_hv_nestedv2.c         | 7 +++++++
>>  arch/powerpc/kvm/test-guest-state-buffer.c    | 2 +-
>>  6 files changed, 19 insertions(+), 3 deletions(-)
>> 
>> -- 
>> 2.45.1
>> 
>
>
> Hi Michael,
>
> This patch series is to be backported for all kernels >= 6.7. So the tag
> should be 
> Cc: stable@vger.kernel.org # v6.7+
>
> and not
> Cc: stable@vger.kernel.org # v6.7
>
> Should I send a new version of this series or can you please make this 
> change when pulling in your tree?

I can make the change when applying.

cheers

