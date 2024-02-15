Return-Path: <kvm+bounces-8731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4EF1855CA3
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 09:40:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53FD7284563
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 08:40:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8966414006;
	Thu, 15 Feb 2024 08:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oy65GiHF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3D9134AF
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 08:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707986378; cv=none; b=Vj8eo0hgSYaBQ/TQx5EXMV/JTWw4ubFcJler8F0UfUVYY75Q3FmzlVjNz2sL6VhlQD5dIGLZg5XHTaccYWZqyihCz0XdjgvIaBr+qZS5DUMxNYapiDYejavKLYjT230YeRh/8lkbIjGurcllJJVV+28rcoGUM5GKwY4xZwkzbg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707986378; c=relaxed/simple;
	bh=nU2GWl8pjQTzoRKcy5LbXTwzOcvRte+6I5y9OLsNnfc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oSgZzSf8Ap5ufStocPXV2DD1scCuX8p1dXKRUscgnKzTpditXShfjCX5zOOSScF4+fADXQdRGtEaZ62iYoLgin6TLaoh6EaBigTaetdKMVq1wuMVgUsZFn79KbnM1EnkGfxQZGZiH0Gl+3SySBTgL5TYUHs1a7Xf24eyEcoRCj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Oy65GiHF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707986375;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=bakj0FATNvoSdsfDbqmxKCUpth/6U6kxf5U1T4MpHTM=;
	b=Oy65GiHF3n1MqHhGE6GPSJfWgwS1Tae5ZiemPq8wocRDQeeTyksLgiKYNVv80ppR07iaQa
	XprdqsI8Wqwprk9PgubyJ7vQKnc2JDvMKu+amfHS2hk4s2qUSB1gMvBDtezQ9NdX/HAlmg
	kzQ0fRzu8jgFSHqm3IijCW0yKIA8mNI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-594-AvOsWZVoPEKLoWO4iKeIkQ-1; Thu,
 15 Feb 2024 03:39:32 -0500
X-MC-Unique: AvOsWZVoPEKLoWO4iKeIkQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B67BA280A9A8;
	Thu, 15 Feb 2024 08:39:31 +0000 (UTC)
Received: from tucnak.zalov.cz (unknown [10.39.192.8])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 73F0E20110C4;
	Thu, 15 Feb 2024 08:39:31 +0000 (UTC)
Received: from tucnak.zalov.cz (localhost [127.0.0.1])
	by tucnak.zalov.cz (8.17.1/8.17.1) with ESMTPS id 41F8dR9K1207786
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 15 Feb 2024 09:39:28 +0100
Received: (from jakub@localhost)
	by tucnak.zalov.cz (8.17.1/8.17.1/Submit) id 41F8dPiY1207783;
	Thu, 15 Feb 2024 09:39:25 +0100
Date: Thu, 15 Feb 2024 09:39:25 +0100
From: Jakub Jelinek <jakub@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Uros Bizjak <ubizjak@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Andrew Pinski (QUIC)" <quic_apinski@quicinc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] Kconfig: Explicitly disable asm goto w/ outputs on
 gcc-11 (and earlier)
Message-ID: <Zc3NvWhOK//UwyJe@tucnak>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <CAKwvOdk_obRUkD6WQHhS9uoFVe3HrgqH5h+FpqsNNgmj4cmvCQ@mail.gmail.com>
 <DM6PR02MB40587AD6ABBF1814E9CCFA7CB84B2@DM6PR02MB4058.namprd02.prod.outlook.com>
 <CAHk-=wi3p5C1n03UYoQhgVDJbh_0ogCpwbgVGnOdGn6RJ6hnKA@mail.gmail.com>
 <ZcZyWrawr1NUCiQZ@google.com>
 <CAKwvOdmKaYYxf7vjvPf2vbn-Ly+4=JZ_zf+OcjYOkWCkgyU_kA@mail.gmail.com>
 <CAHk-=wgEABCwu7HkJufpWC=K7u_say8k6Tp9eHvAXFa4DNXgzQ@mail.gmail.com>
 <CAHk-=wgBt9SsYjyHWn1ZH5V0Q7P6thqv_urVCTYqyWNUWSJ6_g@mail.gmail.com>
 <CAFULd4ZUa56KDLXSoYjoQkX0BcJwaipy3ZrEW+0tbi_Lz3FYAw@mail.gmail.com>
 <CAHk-=wiRQKkgUSRsLHNkgi3M4M-mwPq+9-RST=neGibMR=ubUw@mail.gmail.com>
 <CAHk-=wh2LQtWKNpV-+0+saW0+6zvQdK6vd+5k1yOEp_H_HWxzQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wh2LQtWKNpV-+0+saW0+6zvQdK6vd+5k1yOEp_H_HWxzQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Wed, Feb 14, 2024 at 04:11:05PM -0800, Linus Torvalds wrote:
> On Wed, 14 Feb 2024 at 10:43, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Based on the current state of
> >
> >     https://gcc.gnu.org/bugzilla/show_bug.cgi?id=113921
> >
> > I would suggest this attached kernel patch [...]
> 
> Well, that "current state" didn't last long, and it looks like Jakub
> found the real issue and posted a suggested fix.
> 
> Anyway, the end result is that the current kernel situation - that
> adds the workaround for all gcc versions - is the best that we can do
> for now.

Can it be guarded with
#if GCC_VERSION < 140100
so that it isn't forgotten?  GCC 14.1 certainly will have a fix for this
(so will GCC 13.3, 12.4 and 11.5).
Maybe it would be helpful to use
#if GCC_VERSION < 140000
while it is true that no GCC 14 snapshots until today (or whenever the fix
will be committed) have the fix, for GCC trunk it is up to the distros
to use the latest snapshot if they use it at all and would allow better
testing of the kernel code without the workaround, so that if there are
other issues they won't be discovered years later.  Most userland code
doesn't actually use asm goto with outputs...

	Jakub


