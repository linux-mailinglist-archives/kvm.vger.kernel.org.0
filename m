Return-Path: <kvm+bounces-22486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2964C93F2F3
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 12:39:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DB521C21D4A
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 10:39:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAB481448C0;
	Mon, 29 Jul 2024 10:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h9szyC93"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC8A1527B4
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 10:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722249275; cv=none; b=bZ6aIi3t85lBENdgmLb4/C3gmp/w4ZCYY4tOiOZOLT5iMTYFHNX68F2F1gi5T2y+5wr1JR+Qa0h4SGo+EHVG9l2zKnCF6JEOs8aGuIS1fWkEOlmB1JNKtLXwleS7eTfdfR/yUslGX5FEPS8Z+44K2Sgvj1IowtBopRrtwYJsC0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722249275; c=relaxed/simple;
	bh=FjXzq+5R/+/x6+yl+u+ufGQD4czNH8LN4P4PfV8EyDM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X1EyBWfMLRCFTCPPFiqyYpK0jfxR5Y5EjDX896nH7OHX2H47Nj2R2Ybq9grW68CRth9bemQhbobqia5ZONvh7nvZ3KWDhXJVpvc1KnRVzRoUTlbo0Yoey68AW/EGSNgyuAM53yM64OSK6qb65VjzFYKsN+e06oo0PX4wGTsYn00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h9szyC93; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722249272;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=jrsIQdxPsAZhxdWinFuSjToBMhcCX2rBPI5tFjYosOQ=;
	b=h9szyC935bBybkh26yxW48gxglK0KktjP5QAIJKOuiVY7+msPvL8OV5LJ4bYYBiwZTkXZm
	4CDMdSmuaKaLwLAiAEi9Su2RjJwJBFTlZiDu8oGvpd+qKMYV0uuY41LncLSd4qr4O7zJ69
	lgZdWOHDaUavNbVKxvliZHEJHSwCuas=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-99-kSaR1ZIRMG6tWIK5qN8daA-1; Mon,
 29 Jul 2024 06:34:26 -0400
X-MC-Unique: kSaR1ZIRMG6tWIK5qN8daA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A9D4F1955D4D;
	Mon, 29 Jul 2024 10:34:23 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.58])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5160A300018D;
	Mon, 29 Jul 2024 10:34:17 +0000 (UTC)
Date: Mon, 29 Jul 2024 11:34:13 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Cleber Rosa <crosa@redhat.com>
Cc: qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
	Thomas Huth <thuth@redhat.com>, Beraldo Leal <bleal@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Leif Lindholm <quic_llindhol@quicinc.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>, kvm@vger.kernel.org,
	Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	qemu-arm@nongnu.org, Radoslaw Biernacki <rad@semihalf.com>,
	Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: Re: [PATCH 05/13] tests/avocado: machine aarch64: standardize
 location and RO access
Message-ID: <ZqdwJRRBjj5DsWh8@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240726134438.14720-1-crosa@redhat.com>
 <20240726134438.14720-6-crosa@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240726134438.14720-6-crosa@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Fri, Jul 26, 2024 at 09:44:30AM -0400, Cleber Rosa wrote:
> The tests under machine_aarch64_virt.py and machine_aarch64_sbsaref.py
> should not be writing to the ISO files.  By adding "media=cdrom" the
> "ro" is autmatically set.
> 
> While at it, let's use a single code style and hash for the ISO url.
> 
> Signed-off-by: Cleber Rosa <crosa@redhat.com>
> ---
>  tests/avocado/machine_aarch64_sbsaref.py |  6 +++++-
>  tests/avocado/machine_aarch64_virt.py    | 14 +++++++-------
>  2 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/tests/avocado/machine_aarch64_sbsaref.py b/tests/avocado/machine_aarch64_sbsaref.py
> index e920bbf08c..1275f24532 100644
> --- a/tests/avocado/machine_aarch64_sbsaref.py
> +++ b/tests/avocado/machine_aarch64_sbsaref.py
> @@ -129,7 +129,11 @@ def boot_alpine_linux(self, cpu):
>              "-cpu",
>              cpu,
>              "-drive",
> -            f"file={iso_path},format=raw",
> +            f"file={iso_path},media=cdrom,format=raw",
> +            "-device",
> +            "virtio-rng-pci,rng=rng0",
> +            "-object",
> +            "rng-random,id=rng0,filename=/dev/urandom",
>          )

The commit message doesn't say anything about adding virtio-rng.
If that's needed for some reason, do it as a separate commit
with an explanation of the bug its fixing.


> diff --git a/tests/avocado/machine_aarch64_virt.py b/tests/avocado/machine_aarch64_virt.py
> index a90dc6ff4b..6831d2c0ed 100644
> --- a/tests/avocado/machine_aarch64_virt.py
> +++ b/tests/avocado/machine_aarch64_virt.py
> @@ -37,13 +37,13 @@ def test_alpine_virt_tcg_gic_max(self):
>          :avocado: tags=machine:virt
>          :avocado: tags=accel:tcg
>          """
> -        iso_url = ('https://dl-cdn.alpinelinux.org/'
> -                   'alpine/v3.17/releases/aarch64/'
> -                   'alpine-standard-3.17.2-aarch64.iso')
> +        iso_url = (
> +            "https://dl-cdn.alpinelinux.org/"
> +            "alpine/v3.17/releases/aarch64/alpine-standard-3.17.2-aarch64.iso"
> +        )
>  
> -        # Alpine use sha256 so I recalculated this myself
> -        iso_sha1 = '76284fcd7b41fe899b0c2375ceb8470803eea839'
> -        iso_path = self.fetch_asset(iso_url, asset_hash=iso_sha1)
> +        iso_hash = "5a36304ecf039292082d92b48152a9ec21009d3a62f459de623e19c4bd9dc027"
> +        iso_path = self.fetch_asset(iso_url, algorithm="sha256", asset_hash=iso_hash)
>  
>          self.vm.set_console()
>          kernel_command_line = (self.KERNEL_COMMON_COMMAND_LINE +
> @@ -60,7 +60,7 @@ def test_alpine_virt_tcg_gic_max(self):
>          self.vm.add_args("-smp", "2", "-m", "1024")
>          self.vm.add_args('-bios', os.path.join(BUILD_DIR, 'pc-bios',
>                                                 'edk2-aarch64-code.fd'))
> -        self.vm.add_args("-drive", f"file={iso_path},format=raw")
> +        self.vm.add_args("-drive", f"file={iso_path},media=cdrom,format=raw")
>          self.vm.add_args('-device', 'virtio-rng-pci,rng=rng0')
>          self.vm.add_args('-object', 'rng-random,id=rng0,filename=/dev/urandom')
>  
> -- 
> 2.45.2
> 
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


