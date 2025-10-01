Return-Path: <kvm+bounces-59298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 19CBBBB0B7E
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 16:34:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A23D189F36C
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 14:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 936FA23E32D;
	Wed,  1 Oct 2025 14:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QGw3iwTK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448721D5CC6
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 14:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759329245; cv=none; b=GlZktYrPmiBOA26c84ZPchOYawj/uAq6qeGJGc7Y40jKmkK7EqJXl8+VZP+EsWigVTIBw2b6EwXiF5bvRVE9CFDx7LYKt8S7zC0GFp7PnQv1oqRov2XS76ffYvFfr95QWoyJg6ZXG/Bk7+z/qB5FiMdl5hTiy2+TMl9HvUHuls8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759329245; c=relaxed/simple;
	bh=lzO+uzIHmPeyolszS9MPHAlX74KFD9pfJL5QmKl+GoA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IGTPs2vMcsz2ckuHEVrj0c2eEq89B1M2smpFjwAtH3ptSr9NV3GccJjW2TN0c+qyrcf1irrxqCnFLq9LrDV2A5oCM7ZHw86EPX5BH0aEMBHFk+tVd6c0820tgkCOQavYDgr990KKXjlDW+5u7fRA2Fq6ulDyJj9mv46mudDgFaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QGw3iwTK; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2731ff54949so157185ad.1
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 07:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759329243; x=1759934043; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YakcHEVTGq2IcLc0TeWbio4V719Lk392vundEy8wJyI=;
        b=QGw3iwTKTLIOMoalK1mZ+K9cm0Ql1JFHSQgaYbLwxKk9nEeEc4fG+/OGxYFxuaBrgr
         aG66cK5Qc5ex3UYPGhI6XsEJvpn9nr2cr8lTdaowqhsvJEE4ltLrHD4UVf24Q9DCEzdU
         /BjHqx7Ri2WxVUPWBkXIiOKwFlUIs9xAo2sIbC1JpYAIGVheAghxn1ufrxx3bQRimuVN
         sFuP2BxM6ispMrYiYYmo/f62sW5wYRxPwy3uDM9cnCQ5DBg6oPiYcFjBEwdJwzVKIitg
         ttEO+X8ySuRBTsCz+Nqw0OZrljDPxuOK/E9Ixtrk3e/zj0zUfkrYoKNmE1VczW2VzaA6
         9Zgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759329243; x=1759934043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YakcHEVTGq2IcLc0TeWbio4V719Lk392vundEy8wJyI=;
        b=b5KrfTJZYkeEWSlnjr+uXP13b9EMXZFoEoT7BSO6c1F37lC0iAAbBJYPZEe694LUly
         tAaq/HVmJfG6IFd025rhO1NzigFjSkXhc5GwaJPxNn+vVNMnpQAgtLgslVNrJ+Ign3ob
         ZGZvnXokT382Ca3OsiDLq4oeYn+uAVsn4My33VX8pWPMqJjL7ZFgYEi2hKuLM7YoL2ku
         657wFCKAoNBSJJURSsRpiXerTxVbTqahM2v8iZZ8RH40Sd4+0Qv76J9YGusES/rrSU/W
         CE86+JN9rDB6sRmb8jfRhHwulAK9NaV0u5wp1VsL7kQridBuw9OD09a9zajCyg72IsZ2
         vtTg==
X-Forwarded-Encrypted: i=1; AJvYcCWPU7FBW3SwYRO4gR+ZvMLarqZ7OhfHMSFY5XEklWtqheLx0NmKfvASAnaJx68DnLgTrXk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPOCUzV5JraL25/IE/U2YRPizG4NReFbZI13tsaTNoiKRe+z1I
	J/I6B1XdCTQJ60UP9zkkwp0ydHkVDZFdjrR3RvmZ2HtanYFSdj5DQ8WO2if2QHJcxAxeX84h2j5
	k8j1HXKUtTnOEJIbrKppow/LYYaaaMZu3sbGMA+D+
X-Gm-Gg: ASbGncvwmPEr/FBzhFQpiDICR2Uoe4TbAW2a1dlnMLrwUuFlU4akQEWmdev1VJYQBKk
	GjC1qF9ug2tY9/vXkAi2Wyz8v1ARlGgvFwOHRTUjUKDqS3umhiEGUlrQDrs49S1dpRnuyVVycGu
	/l/AuK5JaMrS7YPHDVKjRqEdVUfjwNKxEmzFozoFCjv2ITcD6g2ZHF263V/+WLcgakcHHq8n2iT
	Irhxiq9xiIEBvNeKpI1rshvWFblEU8sEHneNKhYOnvVDqZwwfOAgrFI9t6rFYgxsxa2Opg=
X-Google-Smtp-Source: AGHT+IEcZ0QxEZyX/+eRrevKbme4sMONzVwGE1+JZ6/Kk+4dmhH2QsBi/Hx53NbWRtg6nJMImE5VXYIt4ZNYQVLOaD8=
X-Received: by 2002:a17:903:19e6:b0:265:e66:6c10 with SMTP id
 d9443c01a7336-28e7fdd9d85mr4532255ad.4.1759329243082; Wed, 01 Oct 2025
 07:34:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com>
 <aNxqYMqtBKll-TgV@google.com>
In-Reply-To: <aNxqYMqtBKll-TgV@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Wed, 1 Oct 2025 07:33:48 -0700
X-Gm-Features: AS18NWDq-lmC-95Rb2AKRRmqNbI7VM1OPfV3LS5-mBc-a7aEICWR5gMtQnvUsAM
Message-ID: <CAGtprH9sU7bA=Cb11vdy=bELXEmx6JA9H5goJUjPzvgC2URxAg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 02/51] KVM: guest_memfd: Introduce and use
 shareability to guard faulting
To: Sean Christopherson <seanjc@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>, 
	Fuad Tabba <tabba@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Ira Weiny <ira.weiny@intel.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, David Hildenbrand <david@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 30, 2025 at 4:40=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> > +};
> > +
> > +enum shareability {
> > +     SHAREABILITY_GUEST =3D 1, /* Only the guest can map (fault) folio=
s in this range. */
> > +     SHAREABILITY_ALL =3D 2,   /* Both guest and host can fault folios=
 in this range. */
> > +};
>
> Rather than define new values and new KVM uAPI, I think we should instead=
 simply
> support KVM_SET_MEMORY_ATTRIBUTES.  We'll probably need a new CAP, as I'm=
 not sure
> supporting KVM_CHECK_EXTENSION+KVM_CAP_MEMORY_ATTRIBUTES on a gmem fd wou=
ld be a
> good idea (e.g. trying to do KVM_CAP_GUEST_MEMFD_FLAGS on a gmem fd doesn=
't work
> because the whole point is to get flags _before_ creating the gmem instan=
ce).  But
> adding e.g. KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES is easy enough.
>
> But for specifying PRIVATE vs. SHARED, I don't see any reason to define n=
ew uAPI.
> I also don't want an entirely new set of terms in KVM to describe the sam=
e things.
> PRIVATE and SHARED are far from perfect, but they're better than https://=
xkcd.com/927.
> And if we ever want to let userspace restrict RWX protections in gmem, we=
'll have
> a ready-made way to do so.
>

I don't understand why we need to reuse KVM_SET_MEMORY_ATTRIBUTES. It
anyways is a new ABI as it's on a guest_memfd FD instead of KVM FD.

RWX protections seem to be pagetable configuration rather than
guest_memfd properties. Can mmap flags + kvm userfaultfd help enforce
RWX protections?

