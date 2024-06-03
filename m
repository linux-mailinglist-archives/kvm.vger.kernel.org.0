Return-Path: <kvm+bounces-18603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 447A38D7D06
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 10:06:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6695B1C21030
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 08:06:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1062A56458;
	Mon,  3 Jun 2024 08:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ghEdjv20"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FC34EB30;
	Mon,  3 Jun 2024 08:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717402006; cv=none; b=enB3jlLMeWa4STOg9D7yDkG74ymbZiH5IF6bKvGm2TRV0fYbMiEd61jI1KxLzOgkNNLpitj7lcEeird6si2cr8wPdYDEk69AlA1OCliDI/lOXwX182WOV0iisYsX4JRdfFLQbQw0k1O8t+VdYQSVlDQeTp0DtMYQCZrOGPH6lSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717402006; c=relaxed/simple;
	bh=Tw661DcLrL32BiuFUViIhHCb+H0PLMasetFtQXJTuE0=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=ga9I1F8DxRAEgUGi2ngPQjR4ideL9i+XET/Z7R1i7YiF8MriStGlrWablNr07y0VbNuqWwAFwdA0gxyr2DQ+HT6S3zYU3rWOuAii7DpzKvYKVy7rmUq/i+CTiWstJlcODifeTmzX08FYXhwCrGehfH5y6mABIFhIYndmX+IhCoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ghEdjv20; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7026ad046a2so501501b3a.2;
        Mon, 03 Jun 2024 01:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717402004; x=1718006804; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7+YI0NLfFFhJ1Ir8e+Xv+54jNSfB0DM2jKBTzfdKYSc=;
        b=ghEdjv20CO2EjShT5mNaXCyiQJ6rVavKCGfWRBW6DFci7PJTDMKE95NGROerlqg/Vk
         d0W6LcttXlBgNbapQlLizhmumPn/O8buzf9kAeyLhyH/7Uk4Y6oPebPe+TCPuhv9XuLx
         UZ8FYb2k3kzpDa52jX5It5CDPFIJjcUuHS+iZDeupm5CspDQC9RzN+yOTm9RVUKKUjb7
         /RItVVpW1xweJoCUXzdOZ6EJ2tRcw7POmivqQW1CP6tb0eDiEyN4DkXnJ64lLaeDr3gb
         qjti5s/EdHeZxV+Ssb+I1qtK95Z07O87c2BdKQW9DfmaeWt5NKq/0Yvzqb2gG8Izyzs0
         Z5DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717402004; x=1718006804;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7+YI0NLfFFhJ1Ir8e+Xv+54jNSfB0DM2jKBTzfdKYSc=;
        b=dyUTh0zLhB0dG8+HQOVhl5C/xuhFrAPXD/5wJLmlJHOtbRlPcBAjqlRY6veR9hcLZq
         Fpk4Pi4Z+SA0EzjLi2OkHYeug5xnJMuoFrqBDmquhPrXERv6wFgfLsk6bPKTP59rMcRV
         2Qq/z5qWs2G7Nn7E0yW5Wlx6ESb/m30+IgX6LZk1MYPZd/ztNLlSkIm98P8b7W/Kzpwa
         v1AfuUBKvJ74nXQ3SNvJCoLL95TH0bySvGaBMQoU0M8JKsrtHgeiyTZdwTDUGmCdPNd8
         8Aw+5urdciecclnuA25KKdIaqig8Cy1GOElnCiYesNtwbVumwY+Oh5wLhIH9TL0uMx+f
         ZLPw==
X-Forwarded-Encrypted: i=1; AJvYcCX0M9AROeMQ2LDKG7hNRaDTA6Zc5fDctU5Xx1WaZFmf+4xJoDI2M8qvur2iMvZkKUY9h+uQzOSVI6EsxUVXLwPz3HPv99CJwP8G3jlx5BGlpItGFtMQjYtAiTCk3d5q8b6O/YZltKGyMX2q27U7IFvB0uIP9D4I0TPPPfq6tWPCyII13ofqMoR6pU5LN//eigNdX8xQ
X-Gm-Message-State: AOJu0YwBo8MkDtsqgZGs5xdKa8vSEeyAIw80Du+plHi0ApmY+s09RuAs
	u4aFnuy71St3/lUocXJSdEo5zaGCbsgFfStqnUKjGAb6Res7gaWK
X-Google-Smtp-Source: AGHT+IFaSCiBLUqxuj94VGdEbKH32ndbrZ5lhrXNp1WeqlQIk5zQGJLCHuJbczmyaB3iwXX3V10u8g==
X-Received: by 2002:a05:6a20:1585:b0:1b2:5674:2225 with SMTP id adf61e73a8af0-1b26f205176mr8935937637.28.1717402003835;
        Mon, 03 Jun 2024 01:06:43 -0700 (PDT)
Received: from localhost ([1.128.198.72])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6323dd824sm59986955ad.128.2024.06.03.01.06.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 01:06:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 03 Jun 2024 18:06:34 +1000
Message-Id: <D1Q874JKY23A.3LB0GHUQQEEAW@gmail.com>
Cc: <mpe@ellerman.id.au>, <christophe.leroy@csgroup.eu>,
 <aneesh.kumar@kernel.org>, <naveen.n.rao@linux.ibm.com>, <corbet@lwn.net>,
 <linuxppc-dev@lists.ozlabs.org>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
 <stable@vger.kernel.org>
Subject: Re: [PATCH v1 RESEND] arch/powerpc/kvm: Fix doorbell emulation by
 adding DPDES support
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Gautam Menghani" <gautam@linux.ibm.com>
X-Mailer: aerc 0.17.0
References: <20240522084949.123148-1-gautam@linux.ibm.com>
 <D1Q54PY40E3B.22QS5DMQRA58N@gmail.com>
 <r74chlv6bgs5csvuf4nxxtylmgartvibftp3xuztyfuynqetp5@ythddpzo6yfi>
In-Reply-To: <r74chlv6bgs5csvuf4nxxtylmgartvibftp3xuztyfuynqetp5@ythddpzo6yfi>

On Mon Jun 3, 2024 at 5:09 PM AEST, Gautam Menghani wrote:
> On Mon, Jun 03, 2024 at 03:42:22PM GMT, Nicholas Piggin wrote:
> > On Wed May 22, 2024 at 6:49 PM AEST, Gautam Menghani wrote:
> > > Doorbell emulation is broken for KVM on PowerVM guests as support for
> > > DPDES was not added in the initial patch series. Due to this, a KVM o=
n
> > > PowerVM guest cannot be booted with the XICS interrupt controller as
> > > doorbells are to be setup in the initial probe path when using XICS
> > > (pSeries_smp_probe()). Add DPDES support in the host KVM code to fix
> > > doorbell emulation.
> >=20
> > This is broken when the KVM guest has SMT > 1? Or is it broken for SMT=
=3D1
> > as well? Can you explain a bit more of what breaks if it's the latter?
>
> Yes, doorbells are only setup when we use SMT>1 and interrupt controller
> is XICS. So without this patch, L2 KOP guest with XICS IC mode and SMT>1=
=20
> does not boot. SMT 1 is fine in all cases.

Okay good. Make that clear in the changelog, ideally if you can give
a recipe the reader is able to recreate is good too, (e.g., run the
guest machine with -smp 4,threads=3D4 and xive=3Doff boot parameter).

> > > Fixes: 6ccbbc33f06a ("KVM: PPC: Add helper library for Guest State Bu=
ffers")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
> > > ---
> > > v1 -> v1 resend:
> > > 1. Add the stable tag
> > >
> > >  Documentation/arch/powerpc/kvm-nested.rst     |  4 +++-
> > >  arch/powerpc/include/asm/guest-state-buffer.h |  3 ++-
> > >  arch/powerpc/include/asm/kvm_book3s.h         |  1 +
> > >  arch/powerpc/kvm/book3s_hv.c                  | 14 +++++++++++++-
> > >  arch/powerpc/kvm/book3s_hv_nestedv2.c         |  7 +++++++
> > >  arch/powerpc/kvm/test-guest-state-buffer.c    |  2 +-
> > >  6 files changed, 27 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/Documentation/arch/powerpc/kvm-nested.rst b/Documentatio=
n/arch/powerpc/kvm-nested.rst
> > > index 630602a8aa00..5defd13cc6c1 100644
> > > --- a/Documentation/arch/powerpc/kvm-nested.rst
> > > +++ b/Documentation/arch/powerpc/kvm-nested.rst
> > > @@ -546,7 +546,9 @@ table information.
> > >  +--------+-------+----+--------+----------------------------------+
> > >  | 0x1052 | 0x08  | RW |   T    | CTRL                             |
> > >  +--------+-------+----+--------+----------------------------------+
> > > -| 0x1053-|       |    |        | Reserved                         |
> > > +| 0x1053 | 0x08  | RW |   T    | DPDES                            |
> > > ++--------+-------+----+--------+----------------------------------+
> > > +| 0x1054-|       |    |        | Reserved                         |
> > >  | 0x1FFF |       |    |        |                                  |
> > >  +--------+-------+----+--------+----------------------------------+
> > >  | 0x2000 | 0x04  | RW |   T    | CR                               |
> > > diff --git a/arch/powerpc/include/asm/guest-state-buffer.h b/arch/pow=
erpc/include/asm/guest-state-buffer.h
> > > index 808149f31576..d107abe1468f 100644
> > > --- a/arch/powerpc/include/asm/guest-state-buffer.h
> > > +++ b/arch/powerpc/include/asm/guest-state-buffer.h
> > > @@ -81,6 +81,7 @@
> > >  #define KVMPPC_GSID_HASHKEYR			0x1050
> > >  #define KVMPPC_GSID_HASHPKEYR			0x1051
> > >  #define KVMPPC_GSID_CTRL			0x1052
> > > +#define KVMPPC_GSID_DPDES			0x1053
> > > =20
> > >  #define KVMPPC_GSID_CR				0x2000
> > >  #define KVMPPC_GSID_PIDR			0x2001
> > > @@ -110,7 +111,7 @@
> > >  #define KVMPPC_GSE_META_COUNT (KVMPPC_GSE_META_END - KVMPPC_GSE_META=
_START + 1)
> > > =20
> > >  #define KVMPPC_GSE_DW_REGS_START KVMPPC_GSID_GPR(0)
> > > -#define KVMPPC_GSE_DW_REGS_END KVMPPC_GSID_CTRL
> > > +#define KVMPPC_GSE_DW_REGS_END KVMPPC_GSID_DPDES
> > >  #define KVMPPC_GSE_DW_REGS_COUNT \
> > >  	(KVMPPC_GSE_DW_REGS_END - KVMPPC_GSE_DW_REGS_START + 1)
> > > =20
> > > diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/inc=
lude/asm/kvm_book3s.h
> > > index 3e1e2a698c9e..10618622d7ef 100644
> > > --- a/arch/powerpc/include/asm/kvm_book3s.h
> > > +++ b/arch/powerpc/include/asm/kvm_book3s.h
> > > @@ -594,6 +594,7 @@ static inline u##size kvmppc_get_##reg(struct kvm=
_vcpu *vcpu)		\
> > > =20
> > > =20
> > >  KVMPPC_BOOK3S_VCORE_ACCESSOR(vtb, 64, KVMPPC_GSID_VTB)
> > > +KVMPPC_BOOK3S_VCORE_ACCESSOR(dpdes, 64, KVMPPC_GSID_DPDES)
> > >  KVMPPC_BOOK3S_VCORE_ACCESSOR_GET(arch_compat, 32, KVMPPC_GSID_LOGICA=
L_PVR)
> > >  KVMPPC_BOOK3S_VCORE_ACCESSOR_GET(lpcr, 64, KVMPPC_GSID_LPCR)
> > >  KVMPPC_BOOK3S_VCORE_ACCESSOR_SET(tb_offset, 64, KVMPPC_GSID_TB_OFFSE=
T)
> > > diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_h=
v.c
> > > index 35cb014a0c51..cf285e5153ba 100644
> > > --- a/arch/powerpc/kvm/book3s_hv.c
> > > +++ b/arch/powerpc/kvm/book3s_hv.c
> > > @@ -4116,6 +4116,11 @@ static int kvmhv_vcpu_entry_nestedv2(struct kv=
m_vcpu *vcpu, u64 time_limit,
> > >  	int trap;
> > >  	long rc;
> > > =20
> > > +	if (vcpu->arch.doorbell_request) {
> > > +		vcpu->arch.doorbell_request =3D 0;
> > > +		kvmppc_set_dpdes(vcpu, 1);
> > > +	}
> >=20
> > This probably looks okay... hmm, is the v1 KVM emulating doorbells
> > correctly for SMT L2 guests? I wonder if doorbell emulation isn't
> > broken there too because the L1 code looks to be passing in vc->dpdes
> > but all the POWER9 emulation code uses doorbell_request.
> >=20
>
> Yes launching SMT L2 on V1 API fails with a kernel Oops, I'll see if I
> can fix that as well.

Okay then I didn't miss something. Thanks v1 fix would be good too.
I think it should look something like putting doorbell_request into
hv_guest_state->dpdes that make the H_ENTER_NESTED call with.

For v1 you will need to restore the state back from dpdes back to
doorbell_request on exit, because the L0 doesn't keep it for you.

Thanks,
Nick

