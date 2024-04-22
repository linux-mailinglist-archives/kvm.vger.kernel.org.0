Return-Path: <kvm+bounces-15553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6FCD8AD538
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 21:52:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B7ACB21E93
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 19:51:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16061156880;
	Mon, 22 Apr 2024 19:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V2MQFhMa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18F1156248
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 19:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713815435; cv=none; b=QSD7HPRZKd30/jViGKauxikraK1mmfGAkEIV1s5x8CUbtOhToaG88VNL4aB7GcmziRG1quar4pCZFWCg/t7h2JFPoqhXfZh5zld/ruB0e+PJ889lnhqCNZd3+a0UuqP/uiVrMjyiNedZI+d/ZUnxH/WOqxjpD9MBYuYjoANNpa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713815435; c=relaxed/simple;
	bh=U+b7pU5cDdsFy0gBnEHx5mcf6OCQLyZ6PHnEwR5GEhU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SVYFxLsdgc+V37FJWsB0w8RxhcmbvyKfaNdykHbhmWz6WV0QY8KF4Hd5drIg4iRCzx4/c83A2ILrNXumDCKn5WDieWf8EJjP2I/FUsj3muUUYESLTAD9CCCqV2OVfXhvjJAf0SlAgjWpSw4XMBMNdGn5QeXVVw9/TbLBvIubucM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V2MQFhMa; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1e8d6480f77so41895775ad.3
        for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 12:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713815433; x=1714420233; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=40a3MchZu5mMTZq1b5V3FW0T182EE5PXteHrxGlZ8Bk=;
        b=V2MQFhMaCT4yP/ZyTOsHDThmIJyrhKUlWB4Nlr5MM4Z7NsfmIYORdP90W1J0n52ECC
         eb7zZL1Oe9Zezk75dwVvaOxyKwYo+suc/Tyu0zMs235iPRz53yxuZDFx/e5s8Q4Ot9rm
         bFQiRfSrhzDhfRjR6J4NmzY8it69OCJKwXzYR9Bw1Di43GqHZLXpHwZh2hy2tXL61dH5
         J1Cx7cwmiPUNFZJgNCI/uxtwmZ/JWRXGOxU+Lg2RMWsEYJFFk+Yv61w3iHU1nR1qsBLx
         zh4Arw6stzauoM+aJryYZO6NaVBDPr5myUcbLxyeA4IN4zo2G54dT6ASh2Qa9kJhVs7T
         WuBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713815433; x=1714420233;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=40a3MchZu5mMTZq1b5V3FW0T182EE5PXteHrxGlZ8Bk=;
        b=HHE9HJnJgqQ8jJN+GjVVw9blpnAtA+K0LI9k9vNx6ICmvprOzCbv8HvtY1v8GFUQW3
         QGFQvnrAOty8i3UsjZzZNdhq8G91GQ5cTG00HenF88nBEf9KbdMpJ4pSe6ud03fU+Pkx
         lozF9GcLiIQdBppv5VT2VjxtmQKrwJJWrQG1PCjXQvZfSZsP3CNPuULR3+NVMidzMLi2
         JOrbTft3zaZBb5P9cDumPCLKzKM7lRgC82NEKpKp+ulLLPFjHiA4SC7Mt6UdWc0in7F3
         fjDZvi0ZofpBI8qsGmbZnAlGvgHsCbksvc2wBxq1qjUnKPDag/P+2ZPVEmZwgmRtSBry
         Ho8A==
X-Forwarded-Encrypted: i=1; AJvYcCVbjW7GpqLL+our/PHHa8bcfHGFAK5TRyUWRG1Bw6UnuDcfQMrxLZ1BMNtu8zaTICqHEdH30+fRxbjaPOvBMaZLDuw2
X-Gm-Message-State: AOJu0Yy3jUPpmEb+jVI0NKLOUJGfqFwkba4M7Y9clLi+0Yv44JIDT15M
	gtRv/bG15apHwwnE5T8Ju+7jLJ6sJYXWuprEvs7Ae5fkzZq4wmZXjfOCertJewUGVQxFu4g0kNE
	bIA==
X-Google-Smtp-Source: AGHT+IHh/tcpf6E5zcUFZo+Mo526dAuFc63v04ewJY7Y0ZelD59VrlJ39qXu3A9Q1SsovDeNEVHE0leHrSE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4c5:b0:1e8:6d56:b376 with SMTP id
 o5-20020a170902d4c500b001e86d56b376mr606835plg.6.1713815432988; Mon, 22 Apr
 2024 12:50:32 -0700 (PDT)
Date: Mon, 22 Apr 2024 12:50:31 -0700
In-Reply-To: <ea77e297510c8f578005ad29c14246951cba8222.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <54ae3bbb-34dc-4b10-a14e-2af9e9240ef1@intel.com>
 <ZfR4UHsW_Y1xWFF-@google.com> <ay724yrnkvsuqjffsedi663iharreuu574nzc4v7fc5mqbwdyx@6ffxkqo3x5rv>
 <39e9c5606b525f1b2e915be08cc95ac3aecc658b.camel@intel.com>
 <m536wofeimei4wdronpl3xlr3ljcap3zazi3ffknpxzdfbrzsr@plk4veaz5d22>
 <ZiFlw_lInUZgv3J_@google.com> <7otbchwoxaaqxoxjfqmifma27dmxxo4wlczyee5pv2ussguwyw@uqr2jbmawg6b>
 <3290ad9f91cf94c269752ccfd8fe2f2bfe6313d1.camel@intel.com>
 <no7n57wmkm3pdkannl2m3u622icfdnof27ayukgkb7q4prnx6k@lfm5cnbie2r5> <ea77e297510c8f578005ad29c14246951cba8222.camel@intel.com>
Message-ID: <Zia_hxSH1p_8qB8L@google.com>
Subject: Re: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, Tina Zhang <tina.zhang@intel.com>, 
	Dave Hansen <dave.hansen@intel.com>, Hang Yuan <hang.yuan@intel.com>, 
	Kai Huang <kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>, Bo2 Chen <chen.bo@intel.com>, 
	"sagis@google.com" <sagis@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Erdem Aktas <erdemaktas@google.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 22, 2024, Rick P Edgecombe wrote:
> On Mon, 2024-04-22 at 14:46 +0300, kirill.shutemov@linux.intel.com wrote:
> > On Fri, Apr 19, 2024 at 08:04:26PM +0000, Edgecombe, Rick P wrote:
> > > On Fri, 2024-04-19 at 17:46 +0300, kirill.shutemov@linux.intel.com=C2=
=A0wrote:
> > > >=20
> > > > > Side topic #3, the ud2 to induce panic should be out-of-line.
> > > >=20
> > > > Yeah. I switched to the inline one while debugging one section mism=
atch
> > > > issue and forgot to switch back.
> > >=20
> > > Sorry, why do we need to panic?
> >=20
> > It panics in cases that should never occur if the TDX module is
> > functioning properly. For example, TDVMCALL itself should never fail,
> > although the leaf function could.
>=20
> Panic should normally be for desperate situations when horrible things wi=
ll
> likely happen if we continue, right? Why are we adding a panic when we di=
dn't
> have one before? Is it a second change, or a side affect of the refactor?

The kernel already does panic() if TDCALL itself fails,

  static inline void tdcall(u64 fn, struct tdx_module_args *args)
  {
	if (__tdcall_ret(fn, args))
		panic("TDCALL %lld failed (Buggy TDX module!)\n", fn);
  }

  /* Called from __tdx_hypercall() for unrecoverable failure */
  noinstr void __noreturn __tdx_hypercall_failed(void)
  {
	instrumentation_begin();
	panic("TDVMCALL failed. TDX module bug?");
  }

it's just doesn in C code via panic(), not in asm via a bare ud2.

