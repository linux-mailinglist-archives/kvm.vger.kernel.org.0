Return-Path: <kvm+bounces-18951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F0E38FD7BA
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 22:42:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D0582841F5
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 20:42:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31A0C15F311;
	Wed,  5 Jun 2024 20:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D6nF7eOU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C735214EC65
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 20:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717620151; cv=none; b=agJNAPo46T8iHqec5TtUBQxI1V/1K6Lh8fviidmMP7ajKZNaLBFhLTtkgrFGhhtlRLLokUbNszXj71ncxSyE0g75NbrBqthWzWJawVq/RdlbbO7AmoBnBku3MNyvODIICSJGK23PzWQS3ChRW/UKt5MJalVvM1Xa/ajumsbNhJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717620151; c=relaxed/simple;
	bh=mrcPVHvvCNX9pKlb1e9kvFdVYrO4YyHw/Sk2tS356ok=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VrSZ457Ucj8vVch4A073fwAytNkrkZ9aNUP63yj7LOD9i1U9YGmr/pgl9ePXY2PqB2P0vjOU6UvyYUGa7QneRVr39W0s2sWrNAGrpqij2XEXvN8A+QT3lSEmFkCRUYEHTU/rr7txBOUOUrgZ/oOMDOJBQkiadhess6hLbqo/m7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D6nF7eOU; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-52b87e8ba1eso343374e87.3
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 13:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717620148; x=1718224948; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mrcPVHvvCNX9pKlb1e9kvFdVYrO4YyHw/Sk2tS356ok=;
        b=D6nF7eOUd+P3MFAcTNFjBZ9XEspzyHLGN33kZ1plO9v/AWX4dD2BKINpOEghOPiSUN
         ch1rVIhXTkIZMuFk1QZzWJW5kcCOm4xRn1TTmKgaPwE1Obp+XoUtrhBFdXcvpAyot6ND
         Hl+bjFw7Hi70VFS0PJHVbmId9dxCASWFnrrXjI0EUuztwKfP2wWkHnh6xFfYFkYn2he8
         zpsxMLU1NoBqOiCAwIcB6HelXdPKVTs44db/L/78ZnPqKfMHDgeLjYQ+OZbFfjDvZwLE
         z5/tAuOLdb+H258ijN++wQxx5sRydmZxEf43WSLpfbXQhNUwxBakPecNmvVgyImACRt1
         kQLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717620148; x=1718224948;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mrcPVHvvCNX9pKlb1e9kvFdVYrO4YyHw/Sk2tS356ok=;
        b=UfY6FMIERI0d+rZokvkURtYOBdjiP3NapknDNK26mQrQx6UqBnnUfegcijD8Eftlbk
         LB5Gtgm3Zc2LA7FdxaKCklwQ3jzg8hJPHIpAm1+YV1isYzQmnbRLGMXnGqjfaNBfMHAS
         iq5qj+3uXBw7vTXdJZf2b8CDQtghU5KaiMLN0EeZ4HtQ7kjoNfJUMXSjpmB47Cx3mknh
         6o11aBv2Gqw4dnzKgRpopJ2ccNsyx8FKHQteC1XBJP45zVt2Bx2rFiYuTZ9dNqhh6oXP
         YV2tt9oIQ7UwszqNK/5FpxY7tf5lFmTP8fIf4BxsCopDPP7c3JE5cD1xCMapWgDi5h6+
         dYAg==
X-Forwarded-Encrypted: i=1; AJvYcCXO0CllJsX+dCu5/tyXVEwAYBAXxMKbBSvNOJJSV/WGL48oI4sSx8BxNXHzsEhwhOgiP+ShODMylokt3Z+H02qGFC6A
X-Gm-Message-State: AOJu0Yz3GYrnl7ridkUXEBwUeBFgYsoYe3YwXhDOL0TYtA25KVnDcUcx
	Ln3VAxVOtcckC5cmJWwOTFMu7rrFujK38ZK3yiCteB3mh5o/G2JEC0fF/fjMVZasMR4uJOOrHf0
	SDJzvgyyFpkgVWeXsGTyTmPFPt3VY1qHBIeYW
X-Google-Smtp-Source: AGHT+IGmCpgKWs9HzI7BHjD0N+cxvlO675UiwlocG7NwR6PK+YVSsXxsmetDw/kfR1C4ad6r/GOAH4AIlHrJieXNb3c=
X-Received: by 2002:a19:ca59:0:b0:523:8723:32de with SMTP id
 2adb3069b0e04-52bab5078f6mr2278150e87.53.1717620147678; Wed, 05 Jun 2024
 13:42:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231212204647.2170650-1-sagis@google.com> <ce967287157e830303fdd3d4a37e7d62a1698747.camel@intel.com>
 <CAAhR5DFmT0n9KWRMtO=FkWbm9_tXy1gP-mpbyF05mmLUph2dPA@mail.gmail.com>
 <59652393edbf94a8ac7bf8d069d15ecb826867e1.camel@intel.com> <7c3abac8c28310916651a25c30277fc1efbad56f.camel@intel.com>
In-Reply-To: <7c3abac8c28310916651a25c30277fc1efbad56f.camel@intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Wed, 5 Jun 2024 15:42:16 -0500
Message-ID: <CAAhR5DH79H2+riwtu_+cw-OpdRm02ELdbVt6T_5TQG3t4qAs2Q@mail.gmail.com>
Subject: Re: [RFC PATCH v5 00/29] TDX KVM selftests
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "vipinsh@google.com" <vipinsh@google.com>, "Aktas, Erdem" <erdemaktas@google.com>, 
	"shuah@kernel.org" <shuah@kernel.org>, "Xu, Haibo1" <haibo1.xu@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Afranji, Ryan" <afranji@google.com>, 
	"dmatlack@google.com" <dmatlack@google.com>, "seanjc@google.com" <seanjc@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "jmattson@google.com" <jmattson@google.com>, 
	"Annapurve, Vishal" <vannapurve@google.com>, "runanwang@google.com" <runanwang@google.com>, 
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, "pgonda@google.com" <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 5, 2024 at 3:18=E2=80=AFPM Verma, Vishal L <vishal.l.verma@inte=
l.com> wrote:
>
> On Wed, 2024-06-05 at 20:15 +0000, Verma, Vishal L wrote:
> > On Wed, 2024-06-05 at 15:10 -0500, Sagi Shahar wrote:
> > > On Wed, Jun 5, 2024 at 1:38=E2=80=AFPM Verma, Vishal L <vishal.l.verm=
a@intel.com> wrote:
> > > >
> > > > On Tue, 2023-12-12 at 12:46 -0800, Sagi Shahar wrote:
> > > > > Hello,
> > > > >
> > > > > This is v4 of the patch series for TDX selftests.
> > > > >
> > > > > It has been updated for Intel=E2=80=99s v17 of the TDX host patch=
es which was
> > > > > proposed here:
> > > > > https://lore.kernel.org/all/cover.1699368322.git.isaku.yamahata@i=
ntel.com/
> > > > >
> > > > > The tree can be found at:
> > > > > https://github.com/googleprodkernel/linux-cc/tree/tdx-selftests-r=
fc-v5
> > > >
> > > > Hello,
> > > >
> > > > I wanted to check if there were any plans from Google to refresh th=
is
> > > > series for the current TDX patches and the kvm-coco-queue baseline?
> > > >
> > > I'm going to work on it soon and was planning on using Isaku's V19 of
> > > the TDX host patches
> >
> > That's great, thank you!
> >
> > >
> > > > I'm setting up a CI system that the team is using to test updates t=
o
> > > > the different TDX patch series, and it currently runs the KVM Unit
> > > > tests, and kvm selftests, and we'd like to be able to add these thr=
ee
> > > > new TDX tests to that as well.
> > > >
> > > > I tried to take a quick shot at rebasing it, but ran into several
> > > > conflicts since kvm-coco-queue has in the meantime made changes e.g=
. in
> > > > tools/testing/selftests/kvm/lib/x86_64/processor.c vcpu_setup().
> > > >
> > > > If you can help rebase this, Rick's MMU prep series might be a good
> > > > baseline to use:
> > > > https://lore.kernel.org/all/20240530210714.364118-1-rick.p.edgecomb=
e@intel.com/
> > >
> > > This patch series only includes the basic TDX MMU changes and is
> > > missing a lot of the TDX support. Not sure how this can be used as a
> > > baseline without the rest of the TDX patches. Are there other patch
> > > series that were posted based on this series which provides the rest
> > > of the TDX support?
> >
> > Hm you're right, I was looking more narrowly because of the kvm-coco-
> > queue conflicts, for some of which even v19 might be too old. The MMU
> > prep series uses a much more recent kvm-coco-queue baseline.
> >
> > Rick, can we post a branch with /everything/ on this MMU prep baseline
> > for this selftest refresh?
>
> Actually I see the branch below does contain everything, not just the
> MMU prep patches. Sagi, is this fine for a baseline?
>
Maybe for internal development but I don't think I can post an
upstream patchset based on an internal Intel development branch.
Do you know if there's a plan to post a patch series based on that branch s=
oon?
> >
> > > >
> > > > This is also available in a tree at:
> > > > https://github.com/intel/tdx/tree/tdx_kvm_dev-2024-05-30
> > > >
> > > > >

