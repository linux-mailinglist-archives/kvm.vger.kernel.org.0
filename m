Return-Path: <kvm+bounces-52640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 865B3B0768D
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 15:04:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EEC617A1BA6
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 13:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C01AA2F50A2;
	Wed, 16 Jul 2025 13:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gevHEozb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920B4290D95
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 13:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752671058; cv=none; b=UvG2iiClyYGTwxN5nisxnq9Yu69/69gp2BSL8JhjyGKewY0lc/gA1WBRSg3PP5JvzrBstKCR0LmhMRKo+wuLNCtwaw545+C6/kR+f6dBORps/gdkzTfnHagYOiUcTMVV2dNP3PK5lA2tKhkdrRDgl60CJAD6VrTV8eGfrjPLkUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752671058; c=relaxed/simple;
	bh=8dZCYt6w2wIjaNRKHHb72EVPPX9qA4w+IQejlPvMmwQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XKSTfwfAS662+k+DvM19GSeYVsw4Jrlg3MgVKgCcbbI2rGScVJ5mqnFhf8BlrMOrfWkfI9TbSPe2+/0wsiFJ6itALKkG7QPX4cMDwA3m1XVWa4X67lwBld6gMIiWP+iINLygz4UJSImxHLSN2ChN3v5GIbVbOQVjeE99chxAuME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gevHEozb; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-235e389599fso228365ad.0
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 06:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752671056; x=1753275856; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LLAVZJBXA44yj6VwhHi0/bIpO+wiOkRvcyjNUHb7iac=;
        b=gevHEozb2wGZa/PAXLtoH1M7N2mzEsg3+3uuaFTGyh1zwRh6Rylg+Jd96hghPtBuri
         aesbnkNAtlXa2fV9WyotLEEJqkwRUKjO93STm0q796laogzcHUeLe46opzz7hmT6MqB2
         6+zDIHO4u3aCOGahNSZQ3N+lTxNEZ6gkTAmeLBidPxLUgNRYzp4aDGaTRo88Rsrn9Y0v
         4NuOelzM/kFhlGNYdXrJAbVAdwiCjIcZvVTMQ+Gj/F0aFkS0VaVCI+04lJjiueM1w+CN
         FOqMiqvnrTDWVrDwplPgfoQ+ELyb8MoIuz5D+vyQwe8mTxl+EjlqApkN9TkhqjdXruey
         1UsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752671056; x=1753275856;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LLAVZJBXA44yj6VwhHi0/bIpO+wiOkRvcyjNUHb7iac=;
        b=OtyDucfLeyVbWa9U1B6DxAg37byiJ2A6/C45oIy5THFwRnfzY4bc7K12BgEYXu/GA1
         hF6K3NQTpEeYFboA0u28uWHBX/weDFpHzoS6gGcTI+rqqr6I8Ng3AfVmV7Z0t/Lx4kun
         ICr2bokhAKki3tWM/AXL7eCr6kYvvYUc4BHJC9BvqFivXMpDJFfnu1KYv6oec1TCF9gY
         ldIu1dh4MdJ8OxJK91v6yQeHpKjmhyXv+AkJn6Ki4iWVd/9Q4dDep/QL4B/Ir8CY77AN
         u3TIJ22KMIClrlxViqJcB2gi5WeppxjlYIUe+FTayvYfmyZTlCrwWZeLje4chCloGUUO
         tKsA==
X-Gm-Message-State: AOJu0Yx85di+tTfH4kJdwKZ3apZUNYnisx1zlj38PjW9gne/RYjSRYqv
	X1+lIrNgb1VUs2IGWyuZb/CJFOF8UEwItPnf+I3RtRY6aUtGFDomEkeNzcXp6S4zcJeGvJphuPY
	HI3g/+ISGYCFPj5Sh6Kwk1Hugp0rqspWCNyO9Yuhn
X-Gm-Gg: ASbGncsUi6S1ODTIq9+dn6KzopX3Bugzim327QlkJLErlBRfPt4YCWY/e+OyBw/eQlg
	u+ajhkfwR4USbWButxEFXdyV/tWqOQTVRAibTriKY1Mw4yl1Xf7fbErM39jOM2JOLy/y9WmWsZN
	MnZ+m8QiNJ70m7g8/gFQ5c5fKUTOaBj+N8Z8L4+aGkTLiJEJFz+LpscbtHyD7n/MLM0T2mEjeT0
	l2gAkp7LLgW9KjyED8syFUs8YEibzKXSfAmj+z2
X-Google-Smtp-Source: AGHT+IFbLmFCf84DLgEZTrPnlX/z0jXT7rSCFSdJKQ9nbT3+zWzNNW5RpYO5vzltezW/SP2qsLvtJkBHsbSo1JZDMwI=
X-Received: by 2002:a17:902:f644:b0:234:a734:4ab9 with SMTP id
 d9443c01a7336-23e2644e3e6mr2258645ad.20.1752671055278; Wed, 16 Jul 2025
 06:04:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250613005400.3694904-1-michael.roth@amd.com>
 <20250613005400.3694904-4-michael.roth@amd.com> <CAGtprH9gtG0s9ZCRJXx_EkRzLnBcZdbjQcOYVP_g9PzKcbkVwA@mail.gmail.com>
 <20250715224825.gfeo5jdqjlvtn66l@amd.com>
In-Reply-To: <20250715224825.gfeo5jdqjlvtn66l@amd.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Wed, 16 Jul 2025 06:04:03 -0700
X-Gm-Features: Ac12FXw7GwQzMGCZjvuciUapFIHKHiW0DMmU5GVoQ0ZpnRjLUR7h_Expq8imx0o
Message-ID: <CAGtprH9Ucr-i_T7pdCFRq63GQY6nWy8668gFoG7NSGdLuzpzRg@mail.gmail.com>
Subject: Re: [PATCH RFC v1 3/5] KVM: guest_memfd: Call arch invalidation hooks
 when converting to shared
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@redhat.com, tabba@google.com, 
	ackerleytng@google.com, ira.weiny@intel.com, thomas.lendacky@amd.com, 
	pbonzini@redhat.com, seanjc@google.com, vbabka@suse.cz, joro@8bytes.org, 
	pratikrajesh.sampat@amd.com, liam.merwick@oracle.com, yan.y.zhao@intel.com, 
	aik@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2025 at 3:56=E2=80=AFPM Michael Roth <michael.roth@amd.com>=
 wrote:
> > > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > > index b77cdccd340e..f27e1f3962bb 100644
> > > --- a/virt/kvm/guest_memfd.c
> > > +++ b/virt/kvm/guest_memfd.c
> > > @@ -203,6 +203,28 @@ static int kvm_gmem_shareability_apply(struct in=
ode *inode,
> > >         struct maple_tree *mt;
> > >
> > >         mt =3D &kvm_gmem_private(inode)->shareability;
> > > +
> > > +       /*
> > > +        * If a folio has been allocated then it was possibly in a pr=
ivate
> > > +        * state prior to conversion. Ensure arch invalidations are i=
ssued
> > > +        * to return the folio to a normal/shared state as defined by=
 the
> > > +        * architecture before tracking it as shared in gmem.
> > > +        */
> > > +       if (m =3D=3D SHAREABILITY_ALL) {
> > > +               pgoff_t idx;
> > > +
> > > +               for (idx =3D work->start; idx < work->start + work->n=
r_pages; idx++) {
> >
> > It is redundant to enter this loop for VM variants that don't need
> > this loop e.g. for pKVM/TDX. I think KVM can dictate a set of rules
> > (based on VM type) that guest_memfd will follow for memory management
> > when it's created, e.g. something like:
> > 1) needs pfn invalidation
> > 2) needs zeroing on shared faults
> > 3) needs zeroing on allocation
>
> Makes sense. Maybe internal/reserved GUEST_MEMFD_FLAG_*'s that can be pas=
sed
> to kvm_gmem_create()?

Yeah, a set of internal flags in addition to what is passed by user
space looks good to me. i.e. Something like:

-int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
+int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd
*args, u64 kvm_flags)

>
> -Mike

