Return-Path: <kvm+bounces-24244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 98A8A952D2D
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 13:05:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 193661F24F5E
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 11:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FA571AC8A5;
	Thu, 15 Aug 2024 11:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hW3/hiSq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595281AC88A
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 11:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723719938; cv=none; b=Amo3jrjxDsAH1e9K03YyBMdFOgz9um2QcT/0Ts6ZipMooJ1RoUhnJNVEGu11ppQzWhPTH8Azyi1S2b8xZrE9Tld47+WQurDmgZ7pjbNtAQysFvfDbzKLevdyRKmdGhdAX0ImxdsESscK11lJpQvkaZ9DcH7eeJfHFtQQ+oNIWlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723719938; c=relaxed/simple;
	bh=th2+i5SvfW/BIJpAWHGTvbZQkiLTSWuSe90id39jZHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PaNxb0+TOchJ3LmJcHbRFWp0eIEvClm/zFrL/3P0CoyEleVbNukkIhwf1fe2a/8rJeQGIBkN227dS+2PjBrx4ylB99kO8MPh0RkfSSzDRAe4X9AVVkytvj2ncb2rurUB1S/ByX7oZ67wd1sFza2Tvy3pKp3mWP6NgGGOqtt5SXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hW3/hiSq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723719935;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HHa9aFfTkq9W9zMlo50Xq2DohN++dzLZD2cadlzl9xQ=;
	b=hW3/hiSqAAisRb30ImQHNA1BxX8TVkCjGYEspz1csDtZxGmZS8JcUXcK32YTqQ+vcnsYxZ
	gdRQfMrMgFBGI7ncXYmAPJ5//O90u2+BUnlyrcHoEsTBYFRWXJXHw/dlP9gRGymFF8BChX
	+U1aco/rWWTVqlwDM4CCTAn+gO7fo4E=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-343-e2hN7Z13Pu-XyTKFdIjgMA-1; Thu,
 15 Aug 2024 07:05:31 -0400
X-MC-Unique: e2hN7Z13Pu-XyTKFdIjgMA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA7311956048;
	Thu, 15 Aug 2024 11:05:29 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.137])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 723D71955DC6;
	Thu, 15 Aug 2024 11:05:22 +0000 (UTC)
Date: Thu, 15 Aug 2024 12:05:18 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org,
	Beraldo Leal <bleal@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
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
Message-ID: <Zr3g7lEfteRpNYVC@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240814224132.897098-1-pierrick.bouvier@linaro.org>
 <20240814224132.897098-2-pierrick.bouvier@linaro.org>
 <CAFEAcA-EAm9mEdGz6m2Y-yxK16TgX6CpxnXc6hW59iAxhXhHtw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFEAcA-EAm9mEdGz6m2Y-yxK16TgX6CpxnXc6hW59iAxhXhHtw@mail.gmail.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Thu, Aug 15, 2024 at 11:12:39AM +0100, Peter Maydell wrote:
> On Wed, 14 Aug 2024 at 23:42, Pierrick Bouvier
> <pierrick.bouvier@linaro.org> wrote:
> >
> > When building with gcc-12 -fsanitize=thread, gcc reports some
> > constructions not supported with tsan.
> > Found on debian stable.
> >
> > qemu/include/qemu/atomic.h:36:52: error: ‘atomic_thread_fence’ is not supported with ‘-fsanitize=thread’ [-Werror=tsan]
> >    36 | #define smp_mb()                     ({ barrier(); __atomic_thread_fence(__ATOMIC_SEQ_CST); })
> >       |                                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >
> > Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> > ---
> >  meson.build | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> >
> > diff --git a/meson.build b/meson.build
> > index 81ecd4bae7c..52e5aa95cc0 100644
> > --- a/meson.build
> > +++ b/meson.build
> > @@ -499,7 +499,15 @@ if get_option('tsan')
> >                           prefix: '#include <sanitizer/tsan_interface.h>')
> >      error('Cannot enable TSAN due to missing fiber annotation interface')
> >    endif
> > -  qemu_cflags = ['-fsanitize=thread'] + qemu_cflags
> > +  tsan_warn_suppress = []
> > +  # gcc (>=11) will report constructions not supported by tsan:
> > +  # "error: ‘atomic_thread_fence’ is not supported with ‘-fsanitize=thread’"
> > +  # https://gcc.gnu.org/gcc-11/changes.html
> > +  # However, clang does not support this warning and this triggers an error.
> > +  if cc.has_argument('-Wno-tsan')
> > +    tsan_warn_suppress = ['-Wno-tsan']
> > +  endif
> 
> That last part sounds like a clang bug -- -Wno-foo is supposed
> to not be an error on compilers that don't implement -Wfoo for
> any value of foo (unless some other warning/error would also
> be emitted).

-Wno-foo isn't an error, but it is a warning... which we then
turn into an error due to -Werror, unless we pass -Wno-unknown-warning-option
to clang.

>               At any rate, that's how gcc does it
> (see the paragraph "When an unrecognized warning option ..."
> in https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html )
> and I thought clang did too...
> 
> thanks
> -- PMM
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


