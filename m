Return-Path: <kvm+bounces-16097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F0E78B4415
	for <lists+kvm@lfdr.de>; Sat, 27 Apr 2024 06:28:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 98AC1B21A83
	for <lists+kvm@lfdr.de>; Sat, 27 Apr 2024 04:28:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 797563C489;
	Sat, 27 Apr 2024 04:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Oin/18el"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39313D0AF
	for <kvm@vger.kernel.org>; Sat, 27 Apr 2024 04:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714192074; cv=none; b=A+fHrqZJw3pAK+JyXRKJPZDh2tf7aVDRgjcuGbIT41GlvZxNTOhcNEo6nponnAiwrjrFual41cmwv06tH8vXCh2Wu4RUsJUj6CbrOusFfx/zl35iuWSsH4fQxJ6qEHfjQWCriDS6z/VsMrgt+eNDa1j055ywIEgHOLgy/OE5MNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714192074; c=relaxed/simple;
	bh=f53YyNgHFfr2Pti2LpwbC3+pp0zF/9peFUyLFTOu7lE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FWkloeEtJnERki338ozZ9XD+Cxrs0jDeYdAkM6VgTgmhWIvAboDy6Kvs8TiuATBIgQ1X8EJrIPBDcgXK7v8XbQD7QZy15ECbuL02EmJTX7Hz/Y3LyzEu/L1rSV6tHbUkzMcPpG8KfZkiJrfd9gwygE3tLg5O3EVZH0s776fzxak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Oin/18el; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43R3rsNb032147
	for <kvm@vger.kernel.org>; Sat, 27 Apr 2024 00:27:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=mime-version :
 references : in-reply-to : from : date : message-id : subject : to : cc :
 content-type : content-transfer-encoding; s=pps01;
 bh=nPff8iA2Lw5jgt1m970vtSJb0RshZCwYJtp71l5TQu8=;
 b=Oin/18elGTrOF+uYXlAkoj6K4gzrs4yM13LRKu9/JUk+RForh4WQe5IhTPOeuffFRVyJ
 lA/pKP88s3woyF62q1mh0HDv1csR+U+KcQ7l3VPwTKBmPks4vw0YWgmTu4yefuc+4rtF
 zFJ0JZ6P4FNQcXPyjOTkTGq4iSVE9j2hu3rJAO+0oWXCrH1Ktckgfy+iqbGII+RN7gkS
 kwwLMlhGjETcSYRP1YZd2et0TU1wP8H0oMosQlJuDAJJ3vrSUzf8ypQeO+x+aDlRT6zL
 UWaeNaPLErxlWc8sSKmiJXEHExj+dmaQN0dCgslZYA4zrADTW8b98WjjDHl18d5j+Rmb Tg== 
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 3xm9s6xm09-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Sat, 27 Apr 2024 00:27:45 -0400
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7d63e86d231so53902639f.0
        for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 21:27:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714192065; x=1714796865;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nPff8iA2Lw5jgt1m970vtSJb0RshZCwYJtp71l5TQu8=;
        b=r8TPhE0o6BL0yEC3ZpAcpEalDHhhLjLfOjJO1ml+bHVYXPrQxPsZb1ImZcfFRH0Rkt
         GM7yYxm3bfz9OV7ny0jSrnPCNRGTp5TxawaKh7wa30Q31TvYDTgiFs7kqHnE3gtsdfaI
         l+DNwg7WHtGynXcrs5tRfQ7wwOrVuBpp5yIVDWbggPvLNtJ2otQQMGRRhLaIjLYaq/Wd
         HDv0bPXbmU9Ylk18Gj1clQzPJjCADXy8JjU2y7/q/AoedsKP4Pm5YU4ogtNxWCT62hOd
         DUm6i6p+rWDe+xQ9WaR9oEkHO7HXQiAFDBHkpIbV3pncGjngSMvFt3tOxIzQO6VaEojb
         NmHw==
X-Forwarded-Encrypted: i=1; AJvYcCWGXjsSoAIfvowd3lhx5iXyeGcDLUKt+h0fHdBUxMdLpxxQX3rlmQsQYfKCrkQ3ax/h7jsHty4mkwMIJ7P37k94KmBn
X-Gm-Message-State: AOJu0YxfePxAo9DencDNsVh3QheqHXLr0u0L5VcG1JoMiMcYBmY/L+kj
	2FM+U5HHEpQLkQcqVACYh5RJAqm6aL6OvUm4Pc3SOCBhl6X4ilLGund5dSBym+9uKDV0443LB6r
	gtuFkCFu6qPH9iQllyIkjY3Rn6lKy5sWjFR6MHuT220JBwrqr94FYS63fVqYWud7/HvfhbkHtlt
	pbGj3lP/0e6snsvN0fqCx/
X-Received: by 2002:a05:6e02:1fe5:b0:369:f53b:6c2 with SMTP id dt5-20020a056e021fe500b00369f53b06c2mr5735040ilb.1.1714192064829;
        Fri, 26 Apr 2024 21:27:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGjuLJktU2wfGT4hASFIEcTHZwBkdlpPm2IWdVZfSYMDNKAx2vOti+FIQlU7EcSMGG55dA3z69yTeZBjwSUO00=
X-Received: by 2002:a05:6e02:1fe5:b0:369:f53b:6c2 with SMTP id
 dt5-20020a056e021fe500b00369f53b06c2mr5735033ilb.1.1714192064523; Fri, 26 Apr
 2024 21:27:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240423024933.80143-1-kele@cs.columbia.edu> <de0096bf-08a8-4ee4-94d7-6e5854b056b4@intel.com>
 <CAOfLF_L2UgSUyUsbiBDhLPskt2xLWujy1GBAhpcWzi2i3brAww@mail.gmail.com>
 <CAOfLF_+ZP-X8yT7qDb0t57ZZu7RNhdOGyCNfR2fheZG+h_jZ7w@mail.gmail.com> <ZivTmpMmeuIShbcC@google.com>
In-Reply-To: <ZivTmpMmeuIShbcC@google.com>
From: Kele Huang <kele@cs.columbia.edu>
Date: Sat, 27 Apr 2024 00:27:33 -0400
Message-ID: <CAOfLF_L+bxOo4kK5H6WAUcOeTu5wFiU57UtR5qmr1rQBT5mAfA@mail.gmail.com>
Subject: Re: [1/1] KVM: restrict kvm_gfn_to_hva_cache_init() to only accept
 address ranges within one page
To: Sean Christopherson <seanjc@google.com>
Cc: Zide Chen <zide.chen@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: Yb7ggcxvfwArK0LXE9kvwDjth1KYcRcD
X-Proofpoint-ORIG-GUID: Yb7ggcxvfwArK0LXE9kvwDjth1KYcRcD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-27_01,2024-04-26_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 bulkscore=10 phishscore=0 spamscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=10 priorityscore=1501 clxscore=1015 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404270029

On Fri, Apr 26, 2024 at 12:17=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:

> Please don't top post.  https://people.kernel.org/tglx/notes-about-netiqu=
ette

Thanks for the tip!

> The exports from kvm.ko are intended for use only by KVM itself, e.g. by
> kvm-intel.ko and kvm-amd.ko on x86.  Anyone trying to use KVM's exports i=
n random
> drivers is in for a world of hurt, as there many, many subtleties through=
out KVM
> that bleed all over the exports.
>
> It's gross that KVM has "internal" exports, and we have line of sight to =
removing
> them for most architectures, including x86, but that isn't the easiest of=
 changes.
>
> If there is a real problem with in-tree upstream KVM, then we'll fix it, =
but
> changing the behavior of KVM functions just because they are exported isn=
't going
> to happen.

Yes, I agree with this.

> > For example, function kvm_lapic_set_vapic_addr()
> > called `kvm_gfn_to_hva_cache_init()` and simply assumes the cache is
> > successfully initialized by checking the return value.
>
> I don't follow the concern here.  It's userspace's responsibility to prov=
ide a
> page-aligned address.  KVM needs to not explode on an unaligned address, =
but
> ensuring that KVM can actually use the fast path isn't KVM's problem.

Yes, you are right.  For the cross page address range, the return value 0 d=
oes
not mean the cache is successfully initialized, but the following read and
write to the corresponding guest memory would still check if the ghc->memsl=
ot
is nullified before directly using the cached hva address.

> > My thought is there probably should be another function to provide corr=
ect
> > cross page cache initialization but I am not sure if this is really nee=
ded.
>
> If there were a legitimate use case where it was truly valuable, then we =
could
> add that functionality.  But all of the usage in KVM either deals with as=
sets
> that are exactly one page in size and must be page aligned, or with asset=
s that
> are userspace or guest controlled and not worth optimizing for page split=
s because
> a well-behavior userspace/guest should ensure the asset doesn't split a p=
age.

Yes, I agree.

> > Nevertheless, I think we could at least make the existing function
> > more accurate?
>
> More accurate with respect to what?

The correctness of the whole gfn to hva cache init logic looks good to me n=
ow.
Thanks for the clarifications from all of you.

Although, it is a bit not straightforward to me because it needs to
call designed
functions to do the guest memory read and write even though people assume
the cache is initialized, or need to do the ghc->memslot checking manually
before using the fast path.

