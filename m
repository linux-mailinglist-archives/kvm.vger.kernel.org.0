Return-Path: <kvm+bounces-40165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D742EA502EE
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 15:58:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0B063AB175
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 14:54:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AE1924BBFD;
	Wed,  5 Mar 2025 14:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cGdJTAee"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABAA2356C2
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 14:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741186464; cv=none; b=JM0TQUx+90jL2lfJ0r5+XddQp5Sht3oE0OVQKCIR2u847TpgpHT0FapDEM8RSSgDvYEY7lnz9EYjMC/jiG57c/oing7zd2oQjGqbDCA1dDqGHO/S0MNZoqgLVz8f3F0OKuLMYvIAkw8coeOfP/biD2MxMSV0dMvrMP7TuidE24M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741186464; c=relaxed/simple;
	bh=p4UtG3lt8etjyR4QSuHV4b+bVzVCE8Zwt/muQtfpYVU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TNT0BoQ7D2quPNKvLA4bARwrfrI2JixxX1LOd3TYegti+LMftO4KTlU3BfDaw/gHBMKl/VEKOjmtXkrhcyIYVc5cHEtewroUEykFmSnH5ELQ5lblUr3Gr8Ywd7z0G1Tw4fiNP5SF2n42T7Q6Ah6RtHD77sPsyfZAJDOGKECu58k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cGdJTAee; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741186461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cox8z8lPi8h9WF637SHJRl9fGGbJ29Arrtfjq01tB+8=;
	b=cGdJTAee/InGllWE3PP9mF4DYwY54Qw72BYnIswWyrvy1aoiBu5sylxU37zZXQRZLPcDQU
	d1uED4FS8GxDzudTX3kKVUAxpz9eAos8XhDcLcWdJLb/zpQqQ04vMWg0QyXscUyMLu/KCb
	OK6fhSAo8+ChPiiGjehL10MmnW2MQ6o=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-351-aM0V3KucP0SG-ViWCnQXsQ-1; Wed, 05 Mar 2025 09:54:20 -0500
X-MC-Unique: aM0V3KucP0SG-ViWCnQXsQ-1
X-Mimecast-MFC-AGG-ID: aM0V3KucP0SG-ViWCnQXsQ_1741186460
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-390ddebcbd1so4107375f8f.2
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 06:54:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741186459; x=1741791259;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cox8z8lPi8h9WF637SHJRl9fGGbJ29Arrtfjq01tB+8=;
        b=AMQPEALBkss7MJcDhDZmzbRcHO1PCFwnp2io6qDwmpqZNwECp3LrdBIxrMAlpC8nfH
         qoAiD1wRnHXxP30bWCfJBtGwNtK+E/sITts+x1F//kAEAis5xmZofIRKB8moQlOG7lOX
         YhcaoNfQrWolxo/xqf81/xWBYA4a4r0zIfdYMfc0cTavXxFvdj93DJ78M9QI/4oJm89K
         hdQpjqke0CvYF/nX93kiQ1AljzY+APjht0p2JbjRVXHN5cN8HAeMbOnt6YP6iiHyO+0h
         ZlAzp5IRn8zlYE5D+iYtG3dlXB+Vqc+igf0hmVcenUMQbEW+N9l4iHDIDsaRBD9ws1A4
         aLQg==
X-Forwarded-Encrypted: i=1; AJvYcCUV3k0DhQYo4Co5PnWRtON9Jtuxv/wiwx7ZO1QD5abZ5Z7wB2zBtNYinjZxvh0nGyVqZFw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxjD0C1KB56X1++NXpEGWVcdYTeDJi3BytkJ5/HKvnMApUjypt
	pqH54FKKFtD5/buhX5XhVRGxSUNhm/766RKVxysR+lGVS5zrSkwrcHDaM8RyB5A1fvymqw2IlEa
	bqiCSwcbSu/komd3yJtq/oiUGxGbUW34kbPiO2q0Oi4oAcmm6rEPSRAW1qO2f0jpq8Yk+TJ7bxG
	olNDRptKZS508yuci5xJ0crCOQ
X-Gm-Gg: ASbGncuV/0HnJOGof+aHnPi9rKi9zHeTXBwtiMaz/4dY4c1eJ8Jm4tznNyFWvGvHDVD
	caSpjMHJnwTDSYnw8em8WyMPBT7T+DIhA3Z0v6uMb7Rc3r/C7lBI3F900ZprAHdCJqwLDFsRY
X-Received: by 2002:a05:6000:136f:b0:390:e1c5:fe2 with SMTP id ffacd0b85a97d-3911f7bac6bmr2620724f8f.38.1741186458843;
        Wed, 05 Mar 2025 06:54:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE4PvVuGKTxjn5+5ksdqhrhoFlLx86CRmMyFCnvhKsn1bSfHEsAqd2/zQT4R+Gyx1q0iDsSyD24ytNHcUzKCCU=
X-Received: by 2002:a05:6000:136f:b0:390:e1c5:fe2 with SMTP id
 ffacd0b85a97d-3911f7bac6bmr2620699f8f.38.1741186458470; Wed, 05 Mar 2025
 06:54:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250112095527.434998-4-pbonzini@redhat.com> <DDEA8D1B-0A0F-4CF3-9A73-7762FFEFD166@xenosoft.de>
 <2025030516-scoured-ethanol-6540@gregkh>
In-Reply-To: <2025030516-scoured-ethanol-6540@gregkh>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 5 Mar 2025 15:54:06 +0100
X-Gm-Features: AQ5f1Jq9Q6hjcyw1JQehTB9dj5tz1yQanFW326sta5ahk4Wq43oLtxt1PyaZ6q4
Message-ID: <CABgObfb5U9zwTQBPkPB=mKu-vMrRspPCm4wfxoQpB+SyAnb5WQ@mail.gmail.com>
Subject: Re: [Kernel 6.12.17] [PowerPC e5500] KVM HV compilation error
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Christian Zigotzky <chzigotzky@xenosoft.de>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, seanjc@google.com, linuxppc-dev@lists.ozlabs.org, 
	regressions@lists.linux.dev, Trevor Dickinson <rtd2@xtra.co.nz>, 
	mad skateman <madskateman@gmail.com>, hypexed@yahoo.com.au, 
	Darren Stevens <darren@stevens-zone.net>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 5, 2025 at 3:19=E2=80=AFPM Greg KH <gregkh@linuxfoundation.org>=
 wrote:
> On Wed, Mar 05, 2025 at 03:14:13PM +0100, Christian Zigotzky wrote:
> > Hi All,
> >
> > The stable long-term kernel 6.12.17 cannot compile with KVM HV support =
for e5500 PowerPC machines anymore.
> >
> > Bug report: https://github.com/chzigotzky/kernels/issues/6
> >
> > Kernel config: https://github.com/chzigotzky/kernels/blob/6_12/configs/=
x5000_defconfig
> >
> > Error messages:
> >
> > arch/powerpc/kvm/e500_mmu_host.c: In function 'kvmppc_e500_shadow_map':
> > arch/powerpc/kvm/e500_mmu_host.c:447:9: error: implicit declaration of =
function '__kvm_faultin_pfn' [-Werror=3Dimplicit-function-declaration]
> >    pfn =3D __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, NULL, &page);
> >          ^~~~~~~~~~~~~~~~~
> >   CC      kernel/notifier.o
> > arch/powerpc/kvm/e500_mmu_host.c:500:2: error: implicit declaration of =
function 'kvm_release_faultin_page'; did you mean 'kvm_read_guest_page'? [-=
Werror=3Dimplicit-function-declaration]
> >   kvm_release_faultin_page(kvm, page, !!ret, writable);
> >
> > After that, I compiled it without KVM HV support.
> >
> > Kernel config: https://github.com/chzigotzky/kernels/blob/6_12/configs/=
e5500_defconfig
> >
> > Please check the error messages.
>
> Odd, what commit caused this problem?

48fe216d7db6b651972c1c1d8e3180cd699971b0

> Any hint as to what commit is missing to fix it?

A big-ass 90 patch series. __kvm_faultin_pfn and
kvm_release_faultin_page were introduced in 6.13, as part of a big
revamp of how KVM does page faults on all architectures.

Just revert all this crap and apply the version that I've just sent
(https://lore.kernel.org/stable/20250305144938.212918-1-pbonzini@redhat.com=
/):

commit 48fe216d7db6b651972c1c1d8e3180cd699971b0
    KVM: e500: always restore irqs

commit 833f69be62ac366b5c23b4a6434389e470dd5c7f
    KVM: PPC: e500: Use __kvm_faultin_pfn() to handle page faults
    Message-ID: <20241010182427.1434605-55-seanjc@google.com>
    Stable-dep-of: 87ecfdbc699c ("KVM: e500: always restore irqs")

commit f2623aec7fdc2675667042c85f87502c9139c098
    KVM: PPC: e500: Mark "struct page" pfn accessed before dropping mmu_loc=
k
    Message-ID: <20241010182427.1434605-54-seanjc@google.com>
    Stable-dep-of: 87ecfdbc699c ("KVM: e500: always restore irqs")

commit dec857329fb9a66a5bce4f9db14c97ef64725a32
    KVM: PPC: e500: Mark "struct page" dirty in kvmppc_e500_shadow_map()
    Message-ID: <20241010182427.1434605-53-seanjc@google.com>
    Stable-dep-of: 87ecfdbc699c ("KVM: e500: always restore irqs")

And this, ladies and gentlemen, is why I always include the apparently
silly Message-ID trailer. Don't you just love how someone, whether
script or human, cherry picked patches 53-55 without even wondering
what was in the 52 before. I'm not sure if it'd be worse for it to be
a human or a script... because if it's a script, surely the same level
of sophistication could have been put into figuring out whether the
thing even COMPILES.

Sasha, this wins the prize for most ridiculous automatic backport
ever. Please stop playing maintainer if you can't be bothered to read
the commit messages for random stuff that you apply.

Paolo


