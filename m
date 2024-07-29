Return-Path: <kvm+bounces-22494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B1ECC93F408
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 13:29:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32EA81F22368
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 11:29:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF07D14659D;
	Mon, 29 Jul 2024 11:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CnOEfumS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0F41448FA
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 11:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722252547; cv=none; b=MpMjmj8VjKC1pXYcj0B2QsRgjI5zhzGS4vS6eg/ojHeiRcqys1gfT7on7OAd58ckRdwNTvqFHsDSHK3wCsPSraWRIM87FwcFruWaAk+oh36ipMBTHYY6w4m5LLXts9yU35eLjElDHurYsa1mBjGTXnNAiy3o8vOi0HcxHnZjhDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722252547; c=relaxed/simple;
	bh=StCXvZflCF6jjibzVOUmevg903F9llVCMo7Ecvzo9Vc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DGvL4iyxj+fl92hOQd8oGWx3q0fPhsziw1/N/I3yNCTkdNHy5PIDiZogjw+I1dJw9gmTxcVwT9FcTF2APaVHI2DUgRKyu2SUalSuE5T+rkPTAJl3klFAsCOVRCrY3cCukhVMdV4c65ZlmiOWvMqws7N5pqu8IwWNQ+CgR3QZM0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CnOEfumS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722252544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=StCXvZflCF6jjibzVOUmevg903F9llVCMo7Ecvzo9Vc=;
	b=CnOEfumSbnlWNBZPgi3yNEkXHzWlha9tXXSMpKsTEdeRrSWX1Z+2qZDNurOYfjbrufy+T9
	AWgtuD+8NXJstOSsk9Qf+a/haRnmeDX92zTxhcb7trzjzmW657f8daddiX1Gzcle2C6nOX
	grT7EJHosd90Ep4fFTP4GrBVK9NnqhE=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-s-DEuTXbNauriJwt9WmbKg-1; Mon, 29 Jul 2024 07:29:00 -0400
X-MC-Unique: s-DEuTXbNauriJwt9WmbKg-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-44ffb762db6so47586421cf.2
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 04:29:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722252540; x=1722857340;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=StCXvZflCF6jjibzVOUmevg903F9llVCMo7Ecvzo9Vc=;
        b=q1W8Zu9FOnf0hha2pvExEzhxN4LmFf2BOwKwFg9HIw78GaJP80116/dA3AhxUGAEd2
         ZVjf+8Ekwh6BaZFca4wdNrCTTerZdAgllC8qpV7m43lj4+irMqWKgKJJlqGG5+N11M2l
         /hHrV6J2+maoOnu+3W7ZdwUZbKjweFxpzlfH/TKWluoCDAAhu7vSPZJCC5eKi2hF34Ou
         ett6dvzlGLCeFM5YsYomcdqJD3DfYAsk452kRtY4UdR/s6qCzfb27CFlivgViqFfHJNU
         QqH4l9j4rXbjUzZkivPR0dM6ThEz2oJ4aoa8cxFesMXmZnPRZwA1UOl7mfYnW1tSuMx9
         P2QQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtH21/wB1zl5tV3E/8fL2LISF+vh9KJRJiBszv5C/AKhwh6XqrtOhRpqblyfy+iaRT+OScbe/E3ANQSElHBZ2yAvuE
X-Gm-Message-State: AOJu0YzYHqEUyYZPpKLfthpVKledezvFLA8zcfqUI9zRG1IZIAcJFdh/
	TaTvf5+R+kUfQZ4XtnGfF1eR7u86S6TOQJp16D+ziRnni+4xHA4Ucao70qbfLgLv0PuYzYugyC8
	Sj87+iC5KCJL6Q3RUiIN5zTOB6QaO/Kyq/YU52jgJctDUkfhKC6q7OaW8jrnbc0yzMUoFzDmstD
	7xFWIDMjTvBUwznUXvQGH4un8x
X-Received: by 2002:a05:622a:1350:b0:447:e079:af12 with SMTP id d75a77b69052e-45004da2ff3mr100665261cf.19.1722252540284;
        Mon, 29 Jul 2024 04:29:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbx/ZrP95YyKrIrfA7D8LaXMTVzKviYgVxeZyKZ+tvxVxMuiUN3x2ObkaxCERoSK6l8Y2nlO7weNdkSFwvIc8=
X-Received: by 2002:a05:622a:1350:b0:447:e079:af12 with SMTP id
 d75a77b69052e-45004da2ff3mr100665121cf.19.1722252539996; Mon, 29 Jul 2024
 04:28:59 -0700 (PDT)
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
 <ZpGL1rEHNild9CG5@LeoBras>
In-Reply-To: <ZpGL1rEHNild9CG5@LeoBras>
From: Leonardo Bras Soares Passos <leobras@redhat.com>
Date: Mon, 29 Jul 2024 08:28:47 -0300
Message-ID: <CAJ6HWG75LYS6UtWebznZ-9wXZCJep_pj3rf-gt-W=PfR-D9b9Q@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] kvm: Note an RCU quiescent state on guest exit
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, Leonardo Bras <leobras.c@gmail.com>, 
	Sean Christopherson <seanjc@google.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 12, 2024 at 5:02=E2=80=AFPM Leonardo Bras <leobras@redhat.com> =
wrote:
>
> On Fri, Jul 12, 2024 at 05:57:10PM +0200, Paolo Bonzini wrote:
> > On 7/11/24 01:18, Leonardo Bras wrote:
> > > What are your thoughts on above results?
> > > Anything you would suggest changing?
> >
>
> Hello Paolo, thanks for the feedback!
>
> > Can you run the test with a conditional on "!tick_nohz_full_cpu(vcpu->c=
pu)"?
> >
> > If your hunch is correct that nohz-full CPUs already avoid invoke_rcu_c=
ore()
> > you might get the best of both worlds.
> >
> > tick_nohz_full_cpu() is very fast when there is no nohz-full CPU, becau=
se
> > then it shortcuts on context_tracking_enabled() (which is just a static
> > key).
>
> But that would mean not noting an RCU quiescent state in guest_exit of
> nohz_full cpus, right?
>
> The original issue we were dealing was having invoke_rcu_core() running o=
n
> nohz_full cpus, and messing up the latency of RT workloads inside the VM.
>
> While most of the invoke_rcu_core() get ignored by the nohz_full rule,
> there are some scenarios in which it the vcpu thread may take more than 1=
s
> between a guest_entry and the next one (VM busy), and those which did
> not get ignored have caused latency peaks in our tests.
>
> The main idea of this patch is to note RCU quiescent states on guest_exit
> at nohz_full cpus (and use rcu.patience) to avoid running invoke_rcu_core=
()
> between a guest_exit and the next guest_entry if it takes less than
> rcu.patience miliseconds between exit and entry, and thus avoiding the
> latency increase.
>
> What I tried to prove above is that it also improves non-Isolated cores a=
s
> well, since rcu_core will not be running as often, saving cpu cycles that
> can be used by the VM.
>
>
> What are your thoughts on that?

Hello Paolo, Sean,
Thanks for the feedback so far!

Do you have any thoughts or suggestions for this patch?

Thanks!
Leo

>
> Thanks!
> Leo


