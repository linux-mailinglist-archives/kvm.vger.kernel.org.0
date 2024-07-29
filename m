Return-Path: <kvm+bounces-22485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 177E893F2B9
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 12:31:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A9B76B23C9C
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 10:30:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A72BB13D296;
	Mon, 29 Jul 2024 10:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kx9sfTFe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429632F5A
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 10:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722249050; cv=none; b=WZEOxgfhd9katIekDXrmLZam2abo5f5FRoJY3r00iLXsPEhoN63os+EFWjmRd4c9gD2NJ0AS3qCdL/jH+aAxKjw0GUXgJkWG3kJhdpuZKEzKmmdQjdu02oURImqNlkeWrLIKLYjcVgbOVXOrWgCF/j/XcGn0e7o4Ci+1WfDOZPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722249050; c=relaxed/simple;
	bh=u334+T1SSdYfPfNVmFDVR0LH132wKgIjOBjUYC5VVw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oiB+UV8p5AFYIw8lTDToZKm4by6AvDSta3BQVT4W4l0iMNU5NKixXcctGVxDRHHI+037cFzRw1UCBcv5mQLTsrhnuOTyr1fc//ffQSLwsT+5219RzyTvjnfZSkKpEbsXqcl7hpSYnIZmLNYRokUphy0bti2JoKzEScBjecXwiek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kx9sfTFe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722249048;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=E/v307qrJPqbG9EmIQvCRmaOD0J7mX5czZH3z26/3Oo=;
	b=Kx9sfTFe9zVU650zaTUPdCdkGlz5aG07/AIi5n4X/M5vbqkR4Qb/3uFd9SDqbkdo923Za3
	rFNbbaIZAy0BBZT5rEZ38LzqXhjLCvMkOyyu6adWkFLdYqgxgM/RTHbBaPsmrVkXA/eTDh
	sMLiS1OXTHfvs0hx8hzRpdBIAXviJmE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-70-g733LZZ5PF-0JSc1Znuxmw-1; Mon,
 29 Jul 2024 06:30:45 -0400
X-MC-Unique: g733LZZ5PF-0JSc1Znuxmw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C2951955D4E;
	Mon, 29 Jul 2024 10:30:41 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.58])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 04B55195605F;
	Mon, 29 Jul 2024 10:30:34 +0000 (UTC)
Date: Mon, 29 Jul 2024 11:30:31 +0100
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
Subject: Re: [PATCH 03/13] tests/avocado/intel_iommu.py: increase timeout
Message-ID: <ZqdvR3UFBCAu8wiI@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240726134438.14720-1-crosa@redhat.com>
 <20240726134438.14720-4-crosa@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240726134438.14720-4-crosa@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Fri, Jul 26, 2024 at 09:44:28AM -0400, Cleber Rosa wrote:
> Based on many runs, the average run time for these 4 tests is around
> 250 seconds, with 320 seconds being the ceiling.  In any way, the
> default 120 seconds timeout is inappropriate in my experience.
> Let's increase the timeout so these tests get a chance to completion.

A high watermark of over 5 minutes is pretty long for a test.

Looking at the test I see it runs

   self.ssh_command('dnf -y install numactl-devel')

but then never actually uses the installed package.

I expect that most of the wallclock time here is coming from having
dnf download all the repodata, 4 times over.

If the intention was to test networking, then replace this with
something that doesn't have to download 100's of MB of data, then
see what kind of running time we get before increasing any timeout. 


> Signed-off-by: Cleber Rosa <crosa@redhat.com>
> ---
>  tests/avocado/intel_iommu.py | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tests/avocado/intel_iommu.py b/tests/avocado/intel_iommu.py
> index 008f214397..9e7965c5df 100644
> --- a/tests/avocado/intel_iommu.py
> +++ b/tests/avocado/intel_iommu.py
> @@ -25,6 +25,8 @@ class IntelIOMMU(LinuxTest):
>      :avocado: tags=flaky
>      """
>  
> +    timeout = 360
> +
>      IOMMU_ADDON = ',iommu_platform=on,disable-modern=off,disable-legacy=on'
>      kernel_path = None
>      initrd_path = None
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


