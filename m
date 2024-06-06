Return-Path: <kvm+bounces-18991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B5FB8FDD2B
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 05:06:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 204141F23754
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 03:06:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BB461F93E;
	Thu,  6 Jun 2024 03:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TIMvQRHV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671E51C68E;
	Thu,  6 Jun 2024 03:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717643196; cv=none; b=U5yIqSOxQU1oyQVQCLxWpRfqCyDJosPdClljwdRruPCzq4efEwnn0rqNFNZVIxmTa2lwkrC6t13SIdcB5CLeMEZ6qvcE8wbC05+Ze28rTkBTJVDzTY1Zss8KkddIP/g8vVY8d3xJJfFeyNzKWE4Sc7HnfgQ4jkLxsA0yYUKvqlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717643196; c=relaxed/simple;
	bh=DvrsBmGuwD2ImyPbsOpP7Kxt6pcNYk1wwR6Wgnw6MGk=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=Pjikv+jnzFdkYLnTt+PJ2j5w7Ip6DryeOUtizZ6ojz/eop4E5X6MBZ0ijyO6oF1L/hNySmXsK8EpapTu5iyxw/3T6Cx7fI7OeOvZCNpG5esAQ+zHz8r/okMFJrKSNcKTGADM7tmX1n7w9WEFc9U+q+qUD0JjS67NsQh+1QDC0Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TIMvQRHV; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1f65a3abd01so4718425ad.3;
        Wed, 05 Jun 2024 20:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717643195; x=1718247995; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HjMuvcnH30KoyWBjd5euk3EXjF9nRQlbcgZhgbXTZgk=;
        b=TIMvQRHVzromOxD7n7W6qMyegpAmxqHHi6Z4En3Vhg1oyNeY9JqPiC1PDcCDuWNuy+
         7xxLd0OqgK2TFvlyXwAUDbG2nby6YHcKQoojHFX0OuVp2/C3FnQ/9ZXh0M3EUPuzpem2
         xu6IGspiutS6BPmeBqZqSP/lt535Jop1VUcJwswOVRIbnjwjRfXoZ1BAM71N1ORuaGGs
         8h9gnfYxQwjKLpSNNsllvmKGOaYjmIhITWnv3Z+52USsJa5s31+6Zta24pttdi/OO4vJ
         LR57qtoriPIS84/Qg9CrsUi6nFM2ngxazXmIxq3wzambEhXn/A/1eC2HD0+LC2jV9S0d
         hT6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717643195; x=1718247995;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HjMuvcnH30KoyWBjd5euk3EXjF9nRQlbcgZhgbXTZgk=;
        b=eNWrTrGomem8XiB6kbiKdLTXeh0wLVoy0Uhf0RAM33Ng+cMpNWNlKcmqR069LbBx1H
         ZSS31DR78IL6ptMd9NpGOp5sPao/g0gNDECKrE7k9C3hWKNPiWLcsJ3e+wotk+oUdrcT
         yWJ0tCzZuDO0LflyElYTU7ilezEgvP7+EjXiR/cq3cp92P5dK8iuQMvEkJFoN1P+egpP
         uqVckcxVYyhojMP6NKLsAMUNX2tUngr8tmuJEKd5bexB3/dPme0PtLWYWOfEDQsqE5ZV
         FVXgpJR5Ii41ky8NB+am3FoxEh2STyFxE3in4jTtVFiTOAZU4BbNPiLM7A02lYsVfVO0
         +2jg==
X-Forwarded-Encrypted: i=1; AJvYcCWYTDuZvzHgBWns4ocFuCWpi5/B9ZXgxoqKi4vUmPhUuIQLC4njp7anRaJsltQEW86Iutcfkhxx/lOSEaMy5x8lN8QKAPHA5cPBMT/JiCT6s/u6P+0zEUKxeP3j2Z5u+kf5Xmlb4ZLUpYQ6QncufYT+pAyvVughX2PD21/O
X-Gm-Message-State: AOJu0YzZub5He2d9Sfnoq9lgTyq2/Kk8VeHjtX2S0sxMHwsVuaF3tcOW
	HccCv4YUhbwlu4Zem0fQFj9q8kUXuNiBHwBhgomGTTIps79ArzrC
X-Google-Smtp-Source: AGHT+IFZESfAMwBlJNHmCynL0DhPXDEYi3w27GieK3vEDPShijCOjqUcQk+TWV8ZF55Do87jKArwPQ==
X-Received: by 2002:a17:902:e850:b0:1eb:fc2:1eed with SMTP id d9443c01a7336-1f6a5a33a69mr54209595ad.41.1717643194601;
        Wed, 05 Jun 2024 20:06:34 -0700 (PDT)
Received: from localhost (110-175-65-7.tpgi.com.au. [110.175.65.7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd7e07edsm2702695ad.214.2024.06.05.20.06.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 20:06:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 06 Jun 2024 13:06:26 +1000
Message-Id: <D1SLOYCQGIQ6.17Y5C9XJDHX33@gmail.com>
Cc: <pbonzini@redhat.com>, <naveen.n.rao@linux.ibm.com>,
 <christophe.leroy@csgroup.eu>, <corbet@lwn.net>, <mpe@ellerman.id.au>,
 <namhyung@kernel.org>, <pbonzini@redhat.com>, <jniethe5@gmail.com>,
 <atrajeev@linux.vnet.ibm.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/8] KVM: PPC: Book3S HV: Nested guest migration
 fixes
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Shivaprasad G Bhat" <sbhat@linux.ibm.com>, <kvm@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
X-Mailer: aerc 0.17.0
References: <171759276071.1480.9356137231993600304.stgit@linux.ibm.com>
In-Reply-To: <171759276071.1480.9356137231993600304.stgit@linux.ibm.com>

On Wed Jun 5, 2024 at 11:06 PM AEST, Shivaprasad G Bhat wrote:
> The series fixes the issues exposed by the kvm-unit-tests[1]
> sprs-migration test.
>
> The SDAR, MMCR3 were seen to have some typo/refactoring bugs.
> The first two patches fix them.
>
> The remaining patches take care of save-restoring the guest
> state elements for DEXCR, HASHKEYR and HASHPKEYR SPRs with PHYP
> during entry-exit. The KVM_PPC_REG too for them are missing which
> are added for use by the QEMU.

These and the qemu patches all look good now. I'll give them
some testing and send R-B in the next day or two. I'm trying
to write a k-u-t for the hashpkey migration case...

Thanks,
Nick

>
> References:
> [1]: https://github.com/kvm-unit-tests/kvm-unit-tests
>
> ---
>
> Changelog:
> v1: https://lore.kernel.org/kvm/171741555734.11675.17428208097186191736.s=
tgit@c0c876608f2d/
>  - Reordered the patches in a way to introduce the SPRs first as
>    suggested.
>  - Added Reviewed-bys to the reviewed ones.
>  - Added 2 more patches to handle the hashpkeyr state
>
> Shivaprasad G Bhat (8):
>       KVM: PPC: Book3S HV: Fix the set_one_reg for MMCR3
>       KVM: PPC: Book3S HV: Fix the get_one_reg of SDAR
>       KVM: PPC: Book3S HV: Add one-reg interface for DEXCR register
>       KVM: PPC: Book3S HV nestedv2: Keep nested guest DEXCR in sync
>       KVM: PPC: Book3S HV: Add one-reg interface for HASHKEYR register
>       KVM: PPC: Book3S HV nestedv2: Keep nested guest HASHKEYR in sync
>       KVM: PPC: Book3S HV: Add one-reg interface for HASHPKEYR register
>       KVM: PPC: Book3S HV nestedv2: Keep nested guest HASHPKEYR in sync
>
>
>  Documentation/virt/kvm/api.rst        |  3 +++
>  arch/powerpc/include/asm/kvm_host.h   |  3 +++
>  arch/powerpc/include/uapi/asm/kvm.h   |  3 +++
>  arch/powerpc/kvm/book3s_hv.c          | 22 ++++++++++++++++++++--
>  arch/powerpc/kvm/book3s_hv.h          |  3 +++
>  arch/powerpc/kvm/book3s_hv_nestedv2.c | 18 ++++++++++++++++++
>  6 files changed, 50 insertions(+), 2 deletions(-)
>
> --
> Signature


