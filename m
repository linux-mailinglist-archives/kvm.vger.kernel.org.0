Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E452FABB2
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 21:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388308AbhARUjb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 15:39:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25545 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727415AbhARKfq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 05:35:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610966059;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=s+e7vZqKRgz+P9p93AaFif74eexCFytOYcwt/WFV9W4=;
        b=bNBc1/0D8D0Xvw9oWFHHicsLDSAEWIAeenXYa+d44brw8v4hIv6v6KHPoaSLEvi/msFrV7
        XHPSTgZHXlbXeEgB3Dr0m4mlWQLYExd4NTzx9vXfjID3vIBPI9eEeMa2sDzIYtpdiRGM8T
        Ac6fhHOnOtOR07Cmtq3QoVDWoScuzSM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-1QaHYPbaOiexR0QYRMrBGQ-1; Mon, 18 Jan 2021 05:34:01 -0500
X-MC-Unique: 1QaHYPbaOiexR0QYRMrBGQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14EE6B811D;
        Mon, 18 Jan 2021 10:34:00 +0000 (UTC)
Received: from redhat.com (ovpn-116-34.ams2.redhat.com [10.36.116.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 53A7D5D9CD;
        Mon, 18 Jan 2021 10:33:47 +0000 (UTC)
Date:   Mon, 18 Jan 2021 10:33:45 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     qemu-devel@nongnu.org, Fam Zheng <fam@euphon.net>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        kvm@vger.kernel.org,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Alistair Francis <alistair@alistair23.me>,
        Greg Kurz <groug@kaod.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Max Reitz <mreitz@redhat.com>, qemu-ppc@nongnu.org,
        Kevin Wolf <kwolf@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH v2 8/9] tests/docker: Add dockerfile for Alpine Linux
Message-ID: <20210118103345.GE1789637@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
 <20210118063808.12471-9-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210118063808.12471-9-jiaxun.yang@flygoat.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 18, 2021 at 02:38:07PM +0800, Jiaxun Yang wrote:
> Alpine Linux[1] is a security-oriented, lightweight Linux distribution
> based on musl libc and busybox.
> 
> It it popular among Docker guests and embedded applications.
> 
> Adding it to test against different libc.
> 
> [1]: https://alpinelinux.org/
> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>  tests/docker/dockerfiles/alpine.docker | 57 ++++++++++++++++++++++++++
>  1 file changed, 57 insertions(+)
>  create mode 100644 tests/docker/dockerfiles/alpine.docker
> 
> diff --git a/tests/docker/dockerfiles/alpine.docker b/tests/docker/dockerfiles/alpine.docker
> new file mode 100644
> index 0000000000..5be5198d00
> --- /dev/null
> +++ b/tests/docker/dockerfiles/alpine.docker
> @@ -0,0 +1,57 @@
> +
> +FROM alpine:edge
> +
> +RUN apk update
> +RUN apk upgrade
> +
> +# Please keep this list sorted alphabetically
> +ENV PACKAGES \
> +	alsa-lib-dev \
> +	bash \
> +	bison \

This shouldn't be required.

> +	build-base \

This seems to be a meta packae that pulls in other
misc toolchain packages. Please list the pieces we
need explicitly instead.

> +	coreutils \
> +	curl-dev \
> +	flex \

This shouldn't be needed.

> +	git \
> +	glib-dev \
> +	glib-static \
> +	gnutls-dev \
> +	gtk+3.0-dev \
> +	libaio-dev \
> +	libcap-dev \

Should not be required, as we use cap-ng.

> +	libcap-ng-dev \
> +	libjpeg-turbo-dev \
> +	libnfs-dev \
> +	libpng-dev \
> +	libseccomp-dev \
> +	libssh-dev \
> +	libusb-dev \
> +	libxml2-dev \
> +	linux-headers \

Is this really needed ? We don't install kernel-headers on other
distros AFAICT.

> +	lzo-dev \
> +	mesa-dev \
> +	mesa-egl \
> +	mesa-gbm \
> +	meson \
> +	ncurses-dev \
> +	ninja \
> +	paxmark \

What is this needed for ?

> +	perl \
> +	pulseaudio-dev \
> +	python3 \
> +	py3-sphinx \
> +	shadow \

Is this really needed ?

> +	snappy-dev \
> +	spice-dev \
> +	texinfo \
> +	usbredir-dev \
> +	util-linux-dev \
> +	vde2-dev \
> +	virglrenderer-dev \
> +	vte3-dev \
> +	xfsprogs-dev \
> +	zlib-dev \
> +	zlib-static
> +
> +RUN apk add $PACKAGES

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

