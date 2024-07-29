Return-Path: <kvm+bounces-22492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D4F393F39D
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 13:06:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 435B0284240
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 11:06:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1989D145A18;
	Mon, 29 Jul 2024 11:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NkZ9B/Nu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C8E145334
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 11:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722251134; cv=none; b=u7ty36o6cNSAH4sdMyXVq4lwetW0SUafjZLjFm+1OEXsNhKKOniy/J1IZX13539GOmJfYvONMRYc0Z+M8onD92wqfR0kVSNMYye9rBP/vl8qr53EVtE4eRPfok/prr1LPD7kOVChgKA5TJeB3D9yyB7jBbj0eF/dD4qL56Lhnv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722251134; c=relaxed/simple;
	bh=I9XzQvd6zooYddh6s3Jm/abBPUL6VTpUzyaNADqg6Sc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hy50ps1OODro1maw8YWhI/8nh6rWfvJwBH/cAN5KNG8I6CHIMNxeGcEVBKZ6vhI9wmRaKUp0HiCKCvfHZ8JSLZ9mirqramLrZimNKh9iAg2ZRTo0LiYozFKXqZC2QPIQZM60dFMOeuD9alZ/v5Hvi3N6P9A2LVDdkssoB5DupvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NkZ9B/Nu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722251131;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=3r1mIKK4V5hBTdmzUpz7ldC7D1ViTAzELfJkPVXxRLw=;
	b=NkZ9B/NuQy0YEwL5Ac+o9ISSgFiSkznmcojdaGPwgIo/KIv+25hedj0FGM02kej4Y0qcT5
	Y3S0tagLWCAUAru4tjLYoKEUc4sE1QC6fP5V31xYLwsNGytzDLCoSpz7FOhVR2p8JYxGdl
	tUnNahuNiW9sAOnp+QZ6kDnLHpRXEQQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-5ACTjvxFPseuOWQTfHarKg-1; Mon,
 29 Jul 2024 07:05:27 -0400
X-MC-Unique: 5ACTjvxFPseuOWQTfHarKg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 31E321955BF7;
	Mon, 29 Jul 2024 11:05:24 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.58])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9AE401945113;
	Mon, 29 Jul 2024 11:05:12 +0000 (UTC)
Date: Mon, 29 Jul 2024 12:05:09 +0100
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
Subject: Re: [PATCH 11/13] tests/avocado/machine_aarch64_sbsaref.py: allow
 for rw usage of image
Message-ID: <Zqd3ZeNIo3dMTzHl@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240726134438.14720-1-crosa@redhat.com>
 <20240726134438.14720-12-crosa@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240726134438.14720-12-crosa@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Fri, Jul 26, 2024 at 09:44:36AM -0400, Cleber Rosa wrote:
> When the OpenBSD based tests are run in parallel, the previously
> single instance of the image would become corrupt.  Let's give each
> test its own copy.
> 
> Signed-off-by: Cleber Rosa <crosa@redhat.com>
> ---
>  tests/avocado/machine_aarch64_sbsaref.py | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/avocado/machine_aarch64_sbsaref.py b/tests/avocado/machine_aarch64_sbsaref.py
> index 1275f24532..8816308b86 100644
> --- a/tests/avocado/machine_aarch64_sbsaref.py
> +++ b/tests/avocado/machine_aarch64_sbsaref.py
> @@ -7,6 +7,7 @@
>  # SPDX-License-Identifier: GPL-2.0-or-later
>  
>  import os
> +import shutil
>  
>  from avocado import skipUnless
>  from avocado.utils import archive
> @@ -187,7 +188,9 @@ def boot_openbsd73(self, cpu):
>          )
>  
>          img_hash = "7fc2c75401d6f01fbfa25f4953f72ad7d7c18650056d30755c44b9c129b707e5"
> -        img_path = self.fetch_asset(img_url, algorithm="sha256", asset_hash=img_hash)
> +        cached_img_path = self.fetch_asset(img_url, algorithm="sha256", asset_hash=img_hash)
> +        img_path = os.path.join(self.workdir, os.path.basename(cached_img_path))
> +        shutil.copy(cached_img_path, img_path)

Again I think we should be using a throwaway qcow2 overlay rather
than copying the full image.

>  
>          self.vm.set_console()
>          self.vm.add_args(

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


