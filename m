Return-Path: <kvm+bounces-65468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 131A1CAB1AA
	for <lists+kvm@lfdr.de>; Sun, 07 Dec 2025 06:14:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 46F0930B71FA
	for <lists+kvm@lfdr.de>; Sun,  7 Dec 2025 05:14:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 308F32DAFCC;
	Sun,  7 Dec 2025 05:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="OTM2ss6s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B8529D294
	for <kvm@vger.kernel.org>; Sun,  7 Dec 2025 05:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765084466; cv=none; b=dSOC3zZqPe43JNyZ1ylShxvZsWWKzZAPOPZQChahBzOBUshDNCdwFXW5feZQbBL5odsZbtW4pHYTxkuPU1h8oARuQoJgil8vvjauMUdPrc8iiMTDYUXPa4lHutMRIK/L1izPUsZqRi4G0M95Iddb3bSvgOHcnON3ZI9r8Lw3MRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765084466; c=relaxed/simple;
	bh=RLy871nN+PF6G/1eKPJpSvOsrDqcrcKVOdz8yZpUqkY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Sz8lAbEtUpWmNEl1rMqEtRu0mx7mpmLrqk1SpA671axe2wiS4v1Muv71eB1mk2JZwbSaGjIfXFzIGdUoVwgDeMrdoz/6GbIl7Ie+Gep/UZyIi3yCgNZJsjt9nBM5TBN2Y43BSbkRghsLCRyNvtnVDnD8vFiNamkENM3oUjqph1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=OTM2ss6s; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-657c68a08a7so1790158eaf.1
        for <kvm@vger.kernel.org>; Sat, 06 Dec 2025 21:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1765084464; x=1765689264; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gIr6vMU+1WXTpE+kuQ5XIOvR7lhOKuME2h0aehuNw7U=;
        b=OTM2ss6sG5EV1MeWI5Rv1Yw+E0pgoq5XVSlHWAby5BG+pZxolfd1iIeA1Ie9qwhFRh
         vPjW1XEy5VguHfcSxfmGe7OyreMSUTBR4xiAbIRGkLjik/Avzuu7NNIQa90VGF3go5EP
         GECcpOKUXl7EG9lEz7DZ3Mwl8cYVXh04C4gUE76d807KZqklls6BCzQU96DlzOT9pDB9
         Wv7rVFgzRoM/DCEtWhpwUWC6Joa3wmkiY8lspX43UzCVVo52zx5xsMmzQfFnASndNDK0
         dTdBlP9vXnMfAt9rd56sXEV5UWcWxoKF7bp5VDwcbI+lEWAib2pQ5JCR5Lk1kZpIFmxX
         gcrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765084464; x=1765689264;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gIr6vMU+1WXTpE+kuQ5XIOvR7lhOKuME2h0aehuNw7U=;
        b=KBJ3XbLPbQRxe7ySXPsgjv4TE2ue3qghSOYpMBqeuDH82Oby+kg8s6OKRfS/+OGvad
         rNZ8gZMAsVKm1Chf6t1U68PAvSha9dJY7Qjt531KdtkEv+1MlHTJXBbbZ6+Ie+HFcCcc
         fY2guHl1a4UQ3jcxcGLB/6WX6J9xIwzwSX3e0+P/7MZXdd6+jHvqDVZDZJ2K0M0k6t1m
         b+rr7X0EpV92yKKMwYXuZT3cIVYU5ajp6SlFtDUt/b79r1K/9x1Bwb4443oQXaFucZCZ
         tIIRBciHB+CjCInoAG/ZiZENFL/61I5en7HlZYMfdQPncVXTLySe18xH0HXlAQIEP4mu
         dnJA==
X-Forwarded-Encrypted: i=1; AJvYcCUP8Ekp1W1dVNVk67s3bVM6RKJjuKOZunqo5EbCb05tYr8SI0TJHMx7AbVPLdbqoLs2cmo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFSpscexj5FXxGp/MHbHsGxaLbN5ddv1gr3iGoT3nj7+9NXyFG
	UNMmAuQot/Zyxao/Y8N+MJAwFcvEaV1kxE0aDLm/WAOCgCrhlS8tLlsglZtNSTNd5peJ/AR3rDn
	qFLTLCoLZSPEMUDASgAa/ADieY2heSDIIfhiRUdeH7Q==
X-Gm-Gg: ASbGncu5o7K4i5bSK9EeR/ag3UsWbgbnPXVlpyY172dR/K4JleQmuzZv8cojv1/u3jY
	Zd1di8IBDodwHz6cpREK/okSP0jZa4t2QD23wgEGRc8/WYTC5MHalc8eMBVU9mQrg3xfznbfF4W
	S59itIInm/v3PsrANsP9lTqWo2TsG1LUqlxTp3alNs7RfzQyzL9VMhMlMRKdMeEMNRrgLDyOfWe
	cLLzvNQNV041WQti3olFPzBy+W+gbCgiMN5cut9dWH+t5xV1W+Aw5lJ7gUWxLDm+w9c3IQF
X-Google-Smtp-Source: AGHT+IH3teezYiglKMW0l9sCwPDXKzHK/uYMVzLl99zBL+8tY4BEmXzPQzc7f6ucWRYnVm2fOg07KrRcgASdUHrgci4=
X-Received: by 2002:a05:6820:f030:b0:659:9a49:8f73 with SMTP id
 006d021491bc7-6599a973da4mr2018657eaf.56.1765084463840; Sat, 06 Dec 2025
 21:14:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251205232655.445294-1-seanjc@google.com>
In-Reply-To: <20251205232655.445294-1-seanjc@google.com>
From: Anup Patel <anup@brainfault.org>
Date: Sun, 7 Dec 2025 10:44:13 +0530
X-Gm-Features: AQt7F2qP99gde5P8lRQoinF2DOSDMpaUpigWBx6hvnDvXPL66vGpk9e2egXMZ2I
Message-ID: <CAAhSdy1cPnxjntaR=cwZqG+oVgFpZKM0rKYAEdkHUCToMvN0Ag@mail.gmail.com>
Subject: Re: [PATCH] KVM: Remove subtle "struct kvm_stats_desc" pseudo-overlay
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"Gustavo A . R . Silva" <gustavoars@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 6, 2025 at 4:57=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Remove KVM's internal pseudo-overlay of kvm_stats_desc, which subtly
> aliases the flexible name[] in the uAPI definition with a fixed-size arra=
y
> of the same name.  The unusual embedded structure results in compiler
> warnings due to -Wflex-array-member-not-at-end, and also necessitates an
> extra level of dereferencing in KVM.  To avoid the "overlay", define the
> uAPI structure to have a fixed-size name when building for the kernel.
>
> Opportunistically clean up the indentation for the stats macros, and
> replace spaces with tabs.
>
> No functional change intended.
>
> Reported-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Closes: https://lore.kernel.org/all/aPfNKRpLfhmhYqfP@kspp
> Signed-off-by: Sean Christopherson <seanjc@google.com>

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Thanks,
Anup

