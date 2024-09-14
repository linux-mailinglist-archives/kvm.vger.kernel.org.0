Return-Path: <kvm+bounces-26923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21A16979102
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 15:35:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45FEB1C2192A
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 13:35:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBA181CF7D7;
	Sat, 14 Sep 2024 13:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V9t/S0Yf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBF81482F3
	for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 13:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726320891; cv=none; b=t0A30oXRA+IJ9zDeoTYcMAioxawxGMxVZzcH9uvWBbZbpkkfRIQZBdDfKQwsSJSHlRQ+mFqKDZV5Fclo2aqUODousDz+AMcaFpp1plhB18sIFlELsP7A2huItOgipU+q+jyaKVqqbbwvzOx5UFsOmuXIiXxkkxwMHAhf844E0b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726320891; c=relaxed/simple;
	bh=dHM/9nGeV0kB5TjHKKHKGDZ6zh5A8DGqa4bFzJrKT/U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NWNNBLzE0m9F1RJgtU2xr+y86OwTV9LyOGt2GTJM056sNfm5BD1macDYG809+gNxvznjYj9q4iiHo736CrzU1pD52wbeZXy1KDiEoTiINyFQduXElE/V1QGF9bLr5PmNVNDAMBFEw9y6fC+3rYf3CvkqbncRmiS9aU8J+oaZdsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V9t/S0Yf; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-42cae4ead5bso11835e9.1
        for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 06:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726320888; x=1726925688; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dHM/9nGeV0kB5TjHKKHKGDZ6zh5A8DGqa4bFzJrKT/U=;
        b=V9t/S0YfvqGt18n1LGGsMgqgKHI5SlP4OdMcEzXgOFMe1ICK4kLgk5lR4+VqXze3Oi
         Ns6rU3WQmZhEmBqKYMlNQorw8BrBwesnjBWTJGU1denCkuYgF+0s2pZVNtv0WjC87LIw
         MANdkrNi1ADdjYZdd3BM75uuinL1jfbae4jx6E0UalYwNfII0A0FGKlWutl1QX8O2OVR
         p5+hq3m6KnFQtxWXulZnr8vZ2uRKiYsyFeh1ICHj9oStUOwSJB7ehbPMccrNt7VZpImT
         cCX7bYX/VITDInLxtfA+D8y58Tl1yn56z7+KfM7SeqrN0aDRUgrgkIjuIzbA45rwnxha
         I/Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726320888; x=1726925688;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dHM/9nGeV0kB5TjHKKHKGDZ6zh5A8DGqa4bFzJrKT/U=;
        b=oruVmbnJLs18f9LincRz7RHCiTpe1ESmVnyHn6G9b7v3zhuOfciuMrmg5um6XvErRB
         yBVc0XP4Yr84Lw5VCj7tbcEv79QnxFuanrzvBVdBhsCQcAG5n1NFOZgO9PFgclK3eiU4
         QKqOYVHCstV22OegS6EoLuAFd0yLf86ojM1dRQ9dUW3r0MyvYr9P/oF7bfYpnhnfRfya
         jzqfxRd9JcI4ZDhFgW90X4K3afq690kiyizAq+SujsYLdY2vHgGM2tZKM8lvVVA5xNGb
         CyQ4YJqTNruzJE+lbu3mXhyGkgWm6ujLWDXGy8lhhhM7EdME8y6V92MpR401d+qHUBk1
         RuVQ==
X-Forwarded-Encrypted: i=1; AJvYcCX1JxDT7rO1hMpRQSUk32Sr6mJVVzRKmE1rqGq5bVQXwVzomjmbdDKFoPvwNPTxEbZF3FY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzs8hwiL4ajBJwZm12ZK7/QcAH71FtKWOB0ftf/g6AjMDK0Pg+n
	0CE/kyJAgNJUdsQbZ0TS1X4CsAkdQSh4kvXfwi62l7eLwA6x5C9tjIgiHJyhXBt3UUGMkwNb+Qa
	xZ240U21FYLfrFHmdNmyIKy940isH0Pse2HS3
X-Google-Smtp-Source: AGHT+IEU9079HmdtThcsiN8JY3iJ1eHKyBPsG+CZSLZMAH2usfwIpF0g9bdh4YwDboVE3ql8z1EaPMYZFS9J2snJ4E8=
X-Received: by 2002:a05:600c:1da5:b0:42b:a8fc:3937 with SMTP id
 5b1f17b1804b1-42cdcd1ec3amr514975e9.4.1726320887370; Sat, 14 Sep 2024
 06:34:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1726009989.git.ackerleytng@google.com> <MN0PR11MB61813367958D393369C0AD8399662@MN0PR11MB6181.namprd11.prod.outlook.com>
In-Reply-To: <MN0PR11MB61813367958D393369C0AD8399662@MN0PR11MB6181.namprd11.prod.outlook.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Sat, 14 Sep 2024 06:34:36 -0700
Message-ID: <CAGtprH-GczOb64XrLpdW4ObRG7Gsv8tHWNhiW7=2dE=OAF7-Rw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/39] 1G page support for guest_memfd
To: "Du, Fan" <fan.du@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, "tabba@google.com" <tabba@google.com>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "roypat@amazon.co.uk" <roypat@amazon.co.uk>, 
	"jgg@nvidia.com" <jgg@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"david@redhat.com" <david@redhat.com>, "rientjes@google.com" <rientjes@google.com>, 
	"fvdl@google.com" <fvdl@google.com>, "jthoughton@google.com" <jthoughton@google.com>, 
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"Li, Zhiquan1" <zhiquan1.li@intel.com>, "Miao, Jun" <jun.miao@intel.com>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "muchun.song@linux.dev" <muchun.song@linux.dev>, 
	"mike.kravetz@oracle.com" <mike.kravetz@oracle.com>, "Aktas, Erdem" <erdemaktas@google.com>, 
	"qperret@google.com" <qperret@google.com>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"willy@infradead.org" <willy@infradead.org>, "shuah@kernel.org" <shuah@kernel.org>, 
	"brauner@kernel.org" <brauner@kernel.org>, "bfoster@redhat.com" <bfoster@redhat.com>, 
	"kent.overstreet@linux.dev" <kent.overstreet@linux.dev>, "pvorel@suse.cz" <pvorel@suse.cz>, 
	"rppt@kernel.org" <rppt@kernel.org>, "richard.weiyang@gmail.com" <richard.weiyang@gmail.com>, 
	"anup@brainfault.org" <anup@brainfault.org>, "Xu, Haibo1" <haibo1.xu@intel.com>, 
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, 
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, "pgonda@google.com" <pgonda@google.com>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, 
	"linux-fsdevel@kvack.org" <linux-fsdevel@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 13, 2024 at 6:08=E2=80=AFPM Du, Fan <fan.du@intel.com> wrote:
>
> ...
> >
> > Hello,
> >
> > This patchset is our exploration of how to support 1G pages in guest_me=
mfd,
> > and
> > how the pages will be used in Confidential VMs.
> >
> > The patchset covers:
> >
> > + How to get 1G pages
> > + Allowing mmap() of guest_memfd to userspace so that both private and
> > shared
>
> Hi Ackerley
>
> Thanks for posting new version :)
>
> W.r.t above description and below patch snippet from Patch 26-29,
> Does this new design aim to backup shared and private GPA with a single
> Hugetlb spool which equal VM instance total memory?

Yes.
>
> By my understanding, before this new changes, shared memfd and gmem fd
> has dedicate hugetlb pool, that's two copy/reservation of hugetlb spool.

Selftests attached to this series use single gmem fd to back guest memory.

>
> Does Qemu require new changes as well? I'd like to have a test of this se=
ries
> if you can share Qemu branch?
>

We are going to discuss this RFC series and related issues at LPC.
Once the next steps are finalized, the plan will be to send out an
improved version. You can use/modify the selftests that are part of
this series to test this feature with software protected VMs for now.

Qemu will require changes for this feature on top of already floated
gmem integration series [1] that adds software protected VM support to
Qemu. If you are interested in testing this feature with TDX VMs then
it needs multiple series to set up the right test environment
(including [2]). We haven't considered posting Qemu patches and it
will be a while before we can get to it.

[1] https://patchew.org/QEMU/20230914035117.3285885-1-xiaoyao.li@intel.com/
[2] https://patchwork.kernel.org/project/kvm/cover/20231115071519.2864957-1=
-xiaoyao.li@intel.com/

