Return-Path: <kvm+bounces-52217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E7C0AB0275C
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 01:05:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A9183A7923
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 23:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5D7F22256B;
	Fri, 11 Jul 2025 23:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0nKtppeL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C631F63C1
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 23:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752275138; cv=none; b=laRIeFY4CDL687v8VXXuDSd552tfqatkRYnWKcnlyrTPE4U6lfg1H+N/pPcznb2PuZ5VGs9J/MCs/+piPxwdXWzQQii/F/oTMf01hYZdUWXHRhHQ7eQdBP2dNtS3B8y8Xmr9/jV9ac1mQ7K9mWBaIKmpL7s+0LEx3vjQdhq+2C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752275138; c=relaxed/simple;
	bh=4Bs5SqTUY3Q4P4/q3DDE8Asi3dU/+HcJjGHK1BPmIps=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aj3xGHh4dFSiOM12/A6Jp9pTsmsCHgKunpM+K4hftnetpqvJ7oiW9w8CicXr2vSN7NmYLK/fFaqSy4XcElbVgEOxc6gOMkmcyjdLkg1UsKNOSb6jgECLzI276RTSRTn9qV7lp8mnvy/5D2T9HujrMrEMSuHOWdq6ZShRi8QNtjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0nKtppeL; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3138f5e8ff5so2747155a91.3
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 16:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752275137; x=1752879937; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NqcyLGxIFUK8WWTsF+7z0v9HoFqFccJotlk3guwsLTU=;
        b=0nKtppeLRATHUSKJG67V+l3SfK+m5I0Qvwj5KdzVFmABB0BHMG8UPo7dq8cg88SZ0p
         WZky3aZsZOTz4tOlp87UHJLzwqEUMorhLgDaOFVZFPBFhXHfQvVDlGDmAlTUAsswZYvs
         KydQR09v0HT0kakwcZvj7QX1pLNVPpFIo+pYbY8amWetVvFGOcVUbmvdr47/HDAonUel
         TT6rvJYYQjFYM7RkRQvffce957hyzfiJhNHmr14qMPHq02KQLaTpNPZ1vko1kNa5+0cW
         XjT483T6g8+M4VJl9wU6Q9m68ByZCgWy3or8frldVzLZsYvW/XldTbSI3thEBDdmpVD2
         5q8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752275137; x=1752879937;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NqcyLGxIFUK8WWTsF+7z0v9HoFqFccJotlk3guwsLTU=;
        b=LVjWg+RhdcKatv8ALgt2IYUi7aXSCSq61Unp51BwvljLzgFL6Ql00ElH4yft5xnlqd
         J9VNBf4t3f4TzDx2VMjwJHrR7iD19vZHy62p7T8ggE5aEdCIe/vfLiZEoxTZPB76ooLc
         ilsCW/xxtKPN6jRkWy9bRYZ7Ma/UKNFdEk8I7PLNDfp6a51HJHKCj6bvquLvjHe1BnPC
         3ku+YbeOgP+0e8JLBozHxSocsKHfsYQ91oA1cOvGF+8PYKo14QncoNcE7JljOpYYRFL0
         9q2BYUquA6P7BE8g/jJQfG20hJy+tJIQ5HzmdUAU9uc4z6aVjcmuupqKeOfcCerQp20D
         IZ8w==
X-Forwarded-Encrypted: i=1; AJvYcCVqPjIDLcv6+8dDdfMuZY5FVBE6aluM08ukSIUPkicIPGH3XQPLT5RxI/BIJ3UtQIPK7o4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJMAO4gWOBIrPy+ohf/AdhylmnqqT4REfosVaicvQvolRPh0sB
	Y3X0iVGhR4I6RzzbFAGX3PAR0qVExm6dhfAAqqvEAes4DtEvm79KUsNqSYkGq5cczmGJOJWtBbJ
	9t/Ii+Q==
X-Google-Smtp-Source: AGHT+IHJS4NYEGdNVSCubE3H0tM+nH35otXVHe/B14UXjQoS/iyHp2xCF6S4MKDSQhqkXVqrclfIfjnfgAk=
X-Received: from pjbsd11.prod.google.com ([2002:a17:90b:514b:b0:312:df0e:5f09])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1850:b0:313:33ca:3b8b
 with SMTP id 98e67ed59e1d1-31c4ca848dfmr7233660a91.9.1752275136707; Fri, 11
 Jul 2025 16:05:36 -0700 (PDT)
Date: Fri, 11 Jul 2025 16:05:34 -0700
In-Reply-To: <b5df4f84b473524fc3abc33f9c263372d0424372.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611095158.19398-1-adrian.hunter@intel.com>
 <175088949072.720373.4112758062004721516.b4-ty@google.com>
 <aF1uNonhK1rQ8ViZ@google.com> <7103b312-b02d-440e-9fa6-ba219a510c2d@intel.com>
 <aHEMBuVieGioMVaT@google.com> <3989f123-6888-459b-bb65-4571f5cad8ce@intel.com>
 <aHEdg0jQp7xkOJp5@google.com> <b5df4f84b473524fc3abc33f9c263372d0424372.camel@intel.com>
Message-ID: <aHGYvrdX4biqKYih@google.com>
Subject: Re: [PATCH V4 0/1] KVM: TDX: Decrease TDX VM shutdown time
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Kai Huang <kai.huang@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2025, Rick P Edgecombe wrote:
> On Fri, 2025-07-11 at 07:19 -0700, Sean Christopherson wrote:
> > --
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index f4d4fd5cc6e8..9c2997665762 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -181,6 +181,8 @@ static int init_kvm_tdx_caps(const struct tdx_sys_i=
nfo_td_conf *td_conf,
> > =C2=A0{
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int i;
> > =C2=A0
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memset(caps->reserved, 0, sizeof(=
caps->reserved));
> > +
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 caps->supported_attrs =3D td=
x_get_supported_attrs(td_conf);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!caps->supported_attrs)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return -EIO;
> > --
>=20
> I started to try to help by chipping in a log for this, but I couldn't ju=
stify
> it very well. struct kvm_tdx_capabilities gets copied from userspace befo=
re
> being populated So a userspace that knows to look for something in the re=
served
> area could know to zero it. If they left their own data in the reserved a=
rea,
> and then relied on that data to remain the same, and then we started sett=
ing a
> new field in it I guess it could disturb it. But that is strange, and I'm=
 not
> sure it really reduces much risk. Anyway here is the attempt to justify i=
t.
>=20
>=20
> KVM: TDX: Zero reserved reserved area in struct kvm_tdx_capabilities
>=20
> Zero the reserved area in struct kvm_tdx_capabilities so that fields adde=
d in
> the reserved area won't disturb any userspace that previously had garbage=
 there.

It's not only about disturbing userspace, it's also about actually being ab=
le to
repurpose the reserved fields in the future without needing *another* flag =
to tell
userspace that it's ok to read the previously-reserved fields.  I care abou=
t this
much more than I care about userspace using reserved fields as scratch spac=
e.

> struct kvm_tdx_capabilities holds information about the combined support =
of KVM
> and the TDX module. For future growth, there is an area of the struct mar=
ked as
> reserved. This way fields can be added into that space without increasing=
 the
> size of the struct.
>=20
> However, currently the reserved area is not zeroed, meaning any data that
> userspace left in the reserved area would be clobbered by a future field =
written
> in the reserved area. So zero the reserved area to reduce the risk that
> userspace might try to rely on some data there.

