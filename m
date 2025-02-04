Return-Path: <kvm+bounces-37241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A0326A276C8
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 17:05:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EEB93A3C96
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 16:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3768B21519C;
	Tue,  4 Feb 2025 16:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EL6Ax0KX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31A3215184
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 16:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738685126; cv=none; b=O5ZrWgYij4NRmmOaMTtNwLTHB8W1vJ/90B8F3g2CaV94hjI8encFeHWOA60bB6qnE1pPFusaCewdQiPdW3BWPwX7XqWO6G1QoqgLFsLlAm/cWTC5fMWL6OxzAzODN/WaeEd33LrI+lTLQQIW/ssXXQ41yr7CRAWiBfuDFYEg1q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738685126; c=relaxed/simple;
	bh=9S/Jsl9iZrO+/Bup4Wa899HOJVXQVIorM6lS3gKkxpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aYVhdl4BqNspW3XPKl/1cbUw4UjF4fc16kI2Mg23dyAU1V61+xYPNd+yzrYiaKqPWy/1vYJiKTmJTBg+8bzobUidBtLf9+Z4TB789SBBpfaPmGDUxVk8vh3CovzzL7rNZ+e9wmf/ZIxYiwX3zkvcgkWVi1H8FZLDO27k2AWs8tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EL6Ax0KX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738685123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9S/Jsl9iZrO+/Bup4Wa899HOJVXQVIorM6lS3gKkxpg=;
	b=EL6Ax0KXoF0HafLx4akVqNtW0E12xa3mP0qs+749jIjgmMfZfxm0J6iqDrEC0dmThSX6Is
	W7Z1gVHcfJ5hUosEURV46v8jxVbt1C4YiSq982TkkqCJOVef0OkD7kICdvw953mVWN6LXg
	/41fbnHwhFIblJjpxpLunZTjNp0mGk4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-489-AZqHvi75PBiRSRDpBxk8cg-1; Tue, 04 Feb 2025 11:05:20 -0500
X-MC-Unique: AZqHvi75PBiRSRDpBxk8cg-1
X-Mimecast-MFC-AGG-ID: AZqHvi75PBiRSRDpBxk8cg
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4362b9c15d8so29186325e9.3
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 08:05:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738685119; x=1739289919;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9S/Jsl9iZrO+/Bup4Wa899HOJVXQVIorM6lS3gKkxpg=;
        b=FCfOvlARg0Kp/oLNWjlnVKFtkslRMTJQ3o2Bb0Pe6q4KiYm8uW6l5TJUsyv9Kgfvib
         jVJTwLt45p9LVJRBN0D0G+ATnC+EL0tuo3lZvl3GvzhF7NiXbQl43nVEJHUDSlADPAtj
         tNw456AM8vWeGHtCNYkPakyv5D8ujHhwupwHHk1na1IEx+xSy9LfPoxVtXAT3tyOF+XU
         OQjpIG/64cXLnUMjqfartzg72oUWAuMaXSsZmUk2ZlvItdEamF397BQZr48Il6d8Qs9C
         hfblbZ7SiOS6/CXcCJGAFq+nUy0/aiypZHpxSvMxHVBkNuq+kUW7FM/XV4kGcqQzFc+2
         v/6w==
X-Forwarded-Encrypted: i=1; AJvYcCWHPcV4BXTDmk20pCh7oPZwtjxvznHLEt6QdRMGJUp6ftFbckFSC22nAq3jOScy+hQD5UQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGTMFRugVwGDYpj3gGhvMKRX//XJEkl+ZDPNMXURh3QjEUotRW
	XUZvIRsKH0j7o7zRiowVXst2pn/8+85lZzzto1l66yUHgpWSBO9GwcQ/dcjnNFaf8qfKhgRHDZy
	sQvTehQVsgpSMY/hHaDYBy/aBjcPWfLdPzPzWlFddCBwO9L9iPmFRbjeNRDK4b8uOnqDrZD0lht
	2G4oKoA0jM3y3Y5REfr9mMhEu+
X-Gm-Gg: ASbGncsvMNM/MT7RrhuEMYxyhVeKTdO5w2LPDEeXWhQndkLEs+outv41qNpjLmWyxsX
	svCmxOJo6HcdioSTbhFTejkxcrL5oCvaCKKIO7cucGkT5Yq7+CHKA5yt65htS
X-Received: by 2002:a05:6000:1869:b0:38d:af20:5f25 with SMTP id ffacd0b85a97d-38daf206192mr1976758f8f.29.1738685118861;
        Tue, 04 Feb 2025 08:05:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEwaWzXVak280B85ArrjCFrUz02WwwEtsT242TiysJbuk+XtRUVzfEto4aIoAc0mUfIQAQs1mQgLIMWq94LkmM=
X-Received: by 2002:a05:6000:1869:b0:38d:af20:5f25 with SMTP id
 ffacd0b85a97d-38daf206192mr1976690f8f.29.1738685118379; Tue, 04 Feb 2025
 08:05:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124163741.101568-1-pbonzini@redhat.com> <CAHk-=wg4Wm4x9GoUk6M8BhLsrhLj4+n8jA2Kg8XUQF=kxgNL9g@mail.gmail.com>
 <20250126142034.GA28135@redhat.com> <CAHk-=wiOSyfW3sgccrfVtanZGUSnjFidSbaP3tg9wapydb-u6g@mail.gmail.com>
 <20250126185354.GB28135@redhat.com> <CAHk-=wiA7wzJ9TLMbC6vfer+0F6S91XghxrdKGawO6uMQCfjtQ@mail.gmail.com>
 <20250127140947.GA22160@redhat.com> <CABgObfaar9uOx7t6vR0pqk6gU-yNOHX3=R1UHY4mbVwRX_wPkA@mail.gmail.com>
 <20250204-liehen-einmal-af13a3c66a61@brauner>
In-Reply-To: <20250204-liehen-einmal-af13a3c66a61@brauner>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 4 Feb 2025 17:05:06 +0100
X-Gm-Features: AWEUYZm64mwKLg6NjahAsD5Hi2sO80t05w3PJ4Q7RlO6xle2aHkFrCzoMQbba_M
Message-ID: <CABgObfaBizrwP6mh82U20Y0h9OwYa6OFn7QBspcGKak2r+5kUw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for Linux 6.14
To: Christian Brauner <brauner@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 4, 2025 at 3:19=E2=80=AFPM Christian Brauner <brauner@kernel.or=
g> wrote:
>
> On Mon, Jan 27, 2025 at 04:15:01PM +0100, Paolo Bonzini wrote:
> > On Mon, Jan 27, 2025 at 3:10=E2=80=AFPM Oleg Nesterov <oleg@redhat.com>=
 wrote:
> > > On 01/26, Linus Torvalds wrote:
> > > > On Sun, 26 Jan 2025 at 10:54, Oleg Nesterov <oleg@redhat.com> wrote=
:
> > > > >
> > > > > I don't think we even need to detect the /proc/self/ or /proc/sel=
f-thread/
> > > > > case, next_tid() can just check same_thread_group,
> > > >
> > > > That was my thinking yes.
> > > >
> > > > If we exclude them from /proc/*/task entirely, I'd worry that it wo=
uld
> > > > hide it from some management tool and be used for nefarious purpose=
s
> > >
> > > Agreed,
> > >
> > > > (even if they then show up elsewhere that the tool wouldn't look at=
).
> > >
> > > Even if we move them from /proc/*/task to /proc ?
> >
> > Indeed---as long as they show up somewhere, it's not worse than it
> > used to be. The reason why I'd prefer them to stay in /proc/*/task is
> > that moving them away at least partly negates the benefits of the
> > "workers are children of the starter" model. For example it
> > complicates measuring their cost within the process that runs the VM.
> > Maybe it's more of a romantic thing than a real practical issue,
> > because in the real world resource accounting for VMs is done via
> > cgroups. But unlike the lazy creation in KVM, which is overall pretty
> > self-contained, I am afraid the ugliness in procfs would be much worse
> > compared to the benefit, if there's a benefit at all.
> >
> > > Perhaps, I honestly do not know what will/can confuse userspace more.
> >
> > At the very least, marking workers as "Kthread: 1" makes sense and
> > should not cause too much confusion. I wouldn't go beyond that unless
> > we get more reports of similar issues, and I'm not even sure how
> > common it is for userspace libraries to check for single-threadedness.
>
> Sorry, just saw this thread now.
>
> What if we did what Linus suggests and hide (odd) user workers from
> /proc/<pid>/task/* but also added /proc/<pid>/workers/*. The latter
> would only list the workers that got spawned by the kernel for that
> particular task? This would acknowledge their somewhat special status
> and allow userspace to still detect them as "Hey, I didn't actually
> spawn those, they got shoved into my workload by the kernel for me.".

Wouldn't the workers then disappear completely from ps, top or other
tools that look at /proc/$PID/task? That seems a bit too underhanded
towards userspace...

Paolo

> (Another (ugly) alternative would be to abuse prctl() and have workloads
> opt-in to hiding user workers from /proc/<pid>/task/.)


