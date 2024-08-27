Return-Path: <kvm+bounces-25197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D1101961839
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 21:51:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4EC021F239AD
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 19:51:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C30571D31BC;
	Tue, 27 Aug 2024 19:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ao/4mZiW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B28B2E62B
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 19:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724788253; cv=none; b=GpAQKapB32Fw9yd2ZDP0yeLxTyZ+t+SLZCcPn92lz5WXGh6/KfpAAWxc5rEhHAK8EYc++ngv4OxrjIf3/UrSH61cneExnBgN79vX3eonc+KiFmCDTaXm0jO2aV8lY9wcCd4iZfEaA4+skL7nWJu4kv5Uyu1EW4eqhSv3/Ono1A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724788253; c=relaxed/simple;
	bh=PAa2iphw1cbZ+4J0LvndlZUJT94QiQinotFdX3u//os=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uB8qPJu8Y6/38ud1MFFKu3mrWmZL40l6WX0mIuRVHpbQBXXEE8zcOHnd72VwtWqoOVyUZGDn+YB4U0pSpYpOgSU2+4Gb2G9SrAEisb1v7VqAY43Y0iZ9Nh1X1IL+arLkuyCQaidvWe7qGSOC5swDXs82B9XiYTGtlCjhoAkRnSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ao/4mZiW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724788250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PAa2iphw1cbZ+4J0LvndlZUJT94QiQinotFdX3u//os=;
	b=ao/4mZiW0sv6wV23T9uwtoISFZKcAA8/SkFnfB6GX3dKtVWKrAE+stdEaZv4SldFuo4EUD
	wvmWPv3wojaZ8eYry+ifxO+oDcCa4V7aJpn5bXtuJVe6mN7oEP2QtwrP/kF7D4GR5NmcW0
	BTMiEYRip3MuKBxBUoKByALrqmDSDQA=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-588cxUEoM9-9RbuL91EO0w-1; Tue, 27 Aug 2024 15:50:49 -0400
X-MC-Unique: 588cxUEoM9-9RbuL91EO0w-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4503564d2ebso85764341cf.0
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 12:50:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724788249; x=1725393049;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PAa2iphw1cbZ+4J0LvndlZUJT94QiQinotFdX3u//os=;
        b=XogHzS/OUif6YHFa6FZhnYj3SX+3h3+sbAXN89UFqRB6FLkziBOyTK+Zn57z89aA6f
         hOKth5Uf0vg0N9vefBTmijE1oUYB02dav1j7itC5knoPORSBXQc6SksqXWV+Q78orBC8
         fTM3USy2UfUAezIWhB/yOOMKQ52vkooA2kspCxxNYB3DGhE7Q5ubtvLyb0xEp6ZoUoun
         Il3CpcaxBeGfffQOV0dxVUCpfnDbGc4C1h9pH3PkXHsDcluySuvtXiUwzYCgZy1/HaSJ
         v0CWx3gXoqtTeH5iyj7q1NJ1coFNYC4fx7KFZYwz7muwvw1o/MCeAs4l+5UrcEr7AM2M
         6mGg==
X-Forwarded-Encrypted: i=1; AJvYcCXr5ySwcMRoDmTbbuOGJcsGSFwmPEK999Rd8dsFWysEcqz+2P5FbHqwBVfQCIC0UftWFNI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWpa2rqg0Pb7pYXDtf9+u4W9hcJ6HV7LdVnSylCGaziZCCLoXh
	qa6F8+TKAcWTNqo85DtenPb5GbWYf8rAPn0zn6USCSbjboSFqrgTcirMA4O7dwVhIXotls5AXlX
	GwbWwPgP/WeSaa/CylEMBxWoqd2q6KgkTy9wrAt/vnToXtQtx3aHqBKsAv33VWwkNnLXwG/9lKM
	BGvFyiE+KCeYFJfiwXGrokQEq8
X-Received: by 2002:a05:622a:5c0b:b0:451:caeb:8cfd with SMTP id d75a77b69052e-455096eb4b8mr188637101cf.31.1724788248797;
        Tue, 27 Aug 2024 12:50:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFh/NuO46jyeabBgVTwTRwBQN4Upju2mh5cSkfpCWefpOcvdaKPzrnmLAnbpxWRE2R3FjdE8DPdMiNEDPoVjDg=
X-Received: by 2002:a05:622a:5c0b:b0:451:caeb:8cfd with SMTP id
 d75a77b69052e-455096eb4b8mr188636811cf.31.1724788248324; Tue, 27 Aug 2024
 12:50:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJ6HWG7pgMu7sAUPykFPtsDfq5Kfh1WecRcgN5wpKQj_EyrbJA@mail.gmail.com>
 <68c39823-6b1d-4368-bd1e-a521ade8889b@paulmck-laptop> <ZkQ97QcEw34aYOB1@LeoBras>
 <17ebd54d-a058-4bc8-bd65-a175d73b6d1a@paulmck-laptop> <ZnPUTGSdF7t0DCwR@LeoBras>
 <ec8088fa-0312-4e98-9e0e-ba9a60106d58@paulmck-laptop> <ZnosF0tqZF72XARQ@LeoBras>
 <ZnosnIHh3b2vbXgX@LeoBras> <Zo8WuwOBSeAcHMp9@LeoBras> <f06ef91d-7f8c-4f69-8535-fee372766a7f@redhat.com>
 <ZpGL1rEHNild9CG5@LeoBras> <CAJ6HWG75LYS6UtWebznZ-9wXZCJep_pj3rf-gt-W=PfR-D9b9Q@mail.gmail.com>
In-Reply-To: <CAJ6HWG75LYS6UtWebznZ-9wXZCJep_pj3rf-gt-W=PfR-D9b9Q@mail.gmail.com>
From: Leonardo Bras Soares Passos <leobras@redhat.com>
Date: Tue, 27 Aug 2024 16:50:36 -0300
Message-ID: <CAJ6HWG53vjhAKjPAFeyjdbopAWzSJTBDz5t5YY+2B13MUdPYfQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] kvm: Note an RCU quiescent state on guest exit
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, Leonardo Bras <leobras.c@gmail.com>, 
	Sean Christopherson <seanjc@google.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Sean,

Have you had the time to review this?

QE team is hitting this bug a lot, and I am afraid that it will start
to hit customers soon.

Please let me know if you need any further data / assistance.

Thanks!
Leo


On Mon, Jul 29, 2024 at 8:28=E2=80=AFAM Leonardo Bras Soares Passos
<leobras@redhat.com> wrote:
>
> On Fri, Jul 12, 2024 at 5:02=E2=80=AFPM Leonardo Bras <leobras@redhat.com=
> wrote:
> >
> > On Fri, Jul 12, 2024 at 05:57:10PM +0200, Paolo Bonzini wrote:
> > > On 7/11/24 01:18, Leonardo Bras wrote:
> > > > What are your thoughts on above results?
> > > > Anything you would suggest changing?
> > >
> >
> > Hello Paolo, thanks for the feedback!
> >
> > > Can you run the test with a conditional on "!tick_nohz_full_cpu(vcpu-=
>cpu)"?
> > >
> > > If your hunch is correct that nohz-full CPUs already avoid invoke_rcu=
_core()
> > > you might get the best of both worlds.
> > >
> > > tick_nohz_full_cpu() is very fast when there is no nohz-full CPU, bec=
ause
> > > then it shortcuts on context_tracking_enabled() (which is just a stat=
ic
> > > key).
> >
> > But that would mean not noting an RCU quiescent state in guest_exit of
> > nohz_full cpus, right?
> >
> > The original issue we were dealing was having invoke_rcu_core() running=
 on
> > nohz_full cpus, and messing up the latency of RT workloads inside the V=
M.
> >
> > While most of the invoke_rcu_core() get ignored by the nohz_full rule,
> > there are some scenarios in which it the vcpu thread may take more than=
 1s
> > between a guest_entry and the next one (VM busy), and those which did
> > not get ignored have caused latency peaks in our tests.
> >
> > The main idea of this patch is to note RCU quiescent states on guest_ex=
it
> > at nohz_full cpus (and use rcu.patience) to avoid running invoke_rcu_co=
re()
> > between a guest_exit and the next guest_entry if it takes less than
> > rcu.patience miliseconds between exit and entry, and thus avoiding the
> > latency increase.
> >
> > What I tried to prove above is that it also improves non-Isolated cores=
 as
> > well, since rcu_core will not be running as often, saving cpu cycles th=
at
> > can be used by the VM.
> >
> >
> > What are your thoughts on that?
>
> Hello Paolo, Sean,
> Thanks for the feedback so far!
>
> Do you have any thoughts or suggestions for this patch?
>
> Thanks!
> Leo
>
> >
> > Thanks!
> > Leo


