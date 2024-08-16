Return-Path: <kvm+bounces-24360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AFAC9544AE
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 10:44:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C318D1F22CF0
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 08:44:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48C9913A276;
	Fri, 16 Aug 2024 08:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WjgLjJ0O"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B110B1DFFC
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 08:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723797887; cv=none; b=oG/9GsQbTPSMfdRvkxNCGDmRhcDrJg7bd2cW3SspwS/9Q5k07DcHhtkJy2g987eOaJ5nop9vworQ63Bdw3wdGg+rC4/ufav17Afu9bS5N4qSA3+7fOpgt2iFp5o3XSJ96W9Vm6iUsB7+dQPkg7U/RtA/nzm4IYzgr1Qr55Kbxf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723797887; c=relaxed/simple;
	bh=3dGK9RVkTMIiKhNkkvEWdQNA4twAu4r5HzjnWuKjYoc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iA0MNtYCZDrWXjbuT+3HcH6jfxUHqguFdUMNiX4Qzu3YPUaoySQYdhQh7bYDT4wf1Rc93+i9WVzViAkjUYN0Yq6O01NfHBgmlhZuDlbucuvVGaFO3oqTV5YBfqdbPM7kumjmgOUdPa8OxZy8sHKYLqQdzydjfk4Nftdg5MvNHyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WjgLjJ0O; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723797884;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gA5jdq5dLKzufFOVi0jOEI5ost4zThD+hb6Vt+IMbFc=;
	b=WjgLjJ0Od9LwPXS9FzeHiRztA7Jy4aS0huOY34nfKvGlCm2vuharORjfvU/wiOZ+V2hO0e
	5DYTPJU26y0O0a5RWhCe7gARyQ6nddjRGUcBk5F34aKpjPC36R7BYCvAG2Ws3qCFZFaLFN
	N6qoT1/fEoJWJuINM5lT+oLUXFVRPes=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-599-Sjs8SNsAMqait3Xiq3HaTA-1; Fri,
 16 Aug 2024 04:44:41 -0400
X-MC-Unique: Sjs8SNsAMqait3Xiq3HaTA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F0D81955BFC;
	Fri, 16 Aug 2024 08:44:39 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.143])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 659E81955F23;
	Fri, 16 Aug 2024 08:44:33 +0000 (UTC)
Date: Fri, 16 Aug 2024 09:44:29 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	qemu-devel@nongnu.org, Beraldo Leal <bleal@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	qemu-s390x@nongnu.org,
	=?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>
Subject: Re: [PATCH v2 1/4] meson: hide tsan related warnings
Message-ID: <Zr8RbcFVN0cgwp-H@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240814224132.897098-1-pierrick.bouvier@linaro.org>
 <20240814224132.897098-2-pierrick.bouvier@linaro.org>
 <CAFEAcA-EAm9mEdGz6m2Y-yxK16TgX6CpxnXc6hW59iAxhXhHtw@mail.gmail.com>
 <Zr3g7lEfteRpNYVC@redhat.com>
 <CAFEAcA8xMjd2w5tT-sMcHKuKGXbqZg4HtTerNFG=_YpNRVVhxQ@mail.gmail.com>
 <66f144dd-f098-443b-8a34-d68bbdecc48f@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <66f144dd-f098-443b-8a34-d68bbdecc48f@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Fri, Aug 16, 2024 at 07:44:28AM +0200, Thomas Huth wrote:
> On 15/08/2024 19.54, Peter Maydell wrote:
> > On Thu, 15 Aug 2024 at 12:05, Daniel P. Berrangé <berrange@redhat.com> wrote:
> > > 
> > > On Thu, Aug 15, 2024 at 11:12:39AM +0100, Peter Maydell wrote:
> > > > On Wed, 14 Aug 2024 at 23:42, Pierrick Bouvier
> > > > <pierrick.bouvier@linaro.org> wrote:
> > > > > 
> > > > > When building with gcc-12 -fsanitize=thread, gcc reports some
> > > > > constructions not supported with tsan.
> > > > > Found on debian stable.
> > > > > 
> > > > > qemu/include/qemu/atomic.h:36:52: error: ‘atomic_thread_fence’ is not supported with ‘-fsanitize=thread’ [-Werror=tsan]
> > > > >     36 | #define smp_mb()                     ({ barrier(); __atomic_thread_fence(__ATOMIC_SEQ_CST); })
> > > > >        |                                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > > > 
> > > > > Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> > > > > ---
> > > > >   meson.build | 10 +++++++++-
> > > > >   1 file changed, 9 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/meson.build b/meson.build
> > > > > index 81ecd4bae7c..52e5aa95cc0 100644
> > > > > --- a/meson.build
> > > > > +++ b/meson.build
> > > > > @@ -499,7 +499,15 @@ if get_option('tsan')
> > > > >                            prefix: '#include <sanitizer/tsan_interface.h>')
> > > > >       error('Cannot enable TSAN due to missing fiber annotation interface')
> > > > >     endif
> > > > > -  qemu_cflags = ['-fsanitize=thread'] + qemu_cflags
> > > > > +  tsan_warn_suppress = []
> > > > > +  # gcc (>=11) will report constructions not supported by tsan:
> > > > > +  # "error: ‘atomic_thread_fence’ is not supported with ‘-fsanitize=thread’"
> > > > > +  # https://gcc.gnu.org/gcc-11/changes.html
> > > > > +  # However, clang does not support this warning and this triggers an error.
> > > > > +  if cc.has_argument('-Wno-tsan')
> > > > > +    tsan_warn_suppress = ['-Wno-tsan']
> > > > > +  endif
> > > > 
> > > > That last part sounds like a clang bug -- -Wno-foo is supposed
> > > > to not be an error on compilers that don't implement -Wfoo for
> > > > any value of foo (unless some other warning/error would also
> > > > be emitted).
> > > 
> > > -Wno-foo isn't an error, but it is a warning... which we then
> > > turn into an error due to -Werror, unless we pass -Wno-unknown-warning-option
> > > to clang.
> > 
> > Which is irritating if you want to be able to blanket say
> > '-Wno-silly-compiler-warning' and not see any of that
> > warning regardless of compiler version. That's why the
> > gcc behaviour is the way it is (i.e. -Wno-such-thingy
> > is neither a warning nor an error if it would be the only
> > warning/error), and if clang doesn't match it that's a shame.
> 
> I thought that Clang would behave the same way as GCC, but apparently it
> does not (anymore?):

It is nothing new - clang has behaved this way wrt unknown warning flags
for as long as I remember.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


