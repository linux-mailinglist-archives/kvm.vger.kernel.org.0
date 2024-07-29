Return-Path: <kvm+bounces-22490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F4A493F375
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 13:01:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AABBD1F222F0
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 11:01:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AC4B142915;
	Mon, 29 Jul 2024 11:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UHubbtiU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A376523CE
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 11:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722250891; cv=none; b=RbQxesTLreBCtPIkz/Okd6/Ge1aw3YaWXNqAAy4woxED6j6FdCDDnYjm8y9EQPvttp11ZrjXqwDoLuDL9I5HEfVSANNCYnTTMVPn+VOCpx1Ixg0K0svNO6Yc/wuUPRHu1rruQNoFmCN+c3xxmcVPWbNNdZBYgqnekPLtp5mrI3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722250891; c=relaxed/simple;
	bh=P6MTxpWoEt3xOVMOPyO2GoJ5o2PMtdRcmXgbh/T8wkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nizN5ZzThfwkNZV3+zO65FOBtK0R3PJSSCgC2uTAcUwHQF9s3UyIOogPMNp7VRDc2dmciLwTvAF2jziSW+LsOEqjFmCq2+HlVBqH39Xo70U5K+my7oOvbczFIcm9tGWhMf90+9aw/9ymgSq+6q9mQOlR9InSdTVh4wlmVBx5X0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UHubbtiU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722250888;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=/136KuYSZeuOyvyvNzrmEgzKDOkJpPOyPtAP+U1yY4E=;
	b=UHubbtiUMYhpbQSzFv8X0iqCqAbMu9RcNVgGr1g8x01gzddwt3rCPV1oGW+2YCa+7a8L4l
	UWZUwmuMI7COaI1C6Xx75z345lK+AjsjtHt2CjAqwVBI80TXShxvnZhaOTWDGcW+/VxIHX
	XzT3n79hpx9t4UPMT6CxXHGm7IDiaKw=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-562-30K7-chHMJ-6wY0KsOPVSg-1; Mon,
 29 Jul 2024 07:01:25 -0400
X-MC-Unique: 30K7-chHMJ-6wY0KsOPVSg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 685781955D4A;
	Mon, 29 Jul 2024 11:01:23 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.58])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 020C81955F23;
	Mon, 29 Jul 2024 11:01:16 +0000 (UTC)
Date: Mon, 29 Jul 2024 12:01:13 +0100
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
Subject: Re: [PATCH 09/13] tests/avocado/boot_xen.py: fetch kernel during
 test setUp()
Message-ID: <Zqd2edn1-aNiVriv@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240726134438.14720-1-crosa@redhat.com>
 <20240726134438.14720-10-crosa@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240726134438.14720-10-crosa@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Fri, Jul 26, 2024 at 09:44:34AM -0400, Cleber Rosa wrote:
> The kernel is a common blob used in all tests.  By moving it to the
> setUp() method, the "fetch asset" plugin will recognize the kernel and
> attempt to fetch it and cache it before the tests are started.

The other tests don't call  fetch_asset() from their setUp
method - what's different about this test that prevents the
asset caching working ?

> 
> Signed-off-by: Cleber Rosa <crosa@redhat.com>
> ---
>  tests/avocado/boot_xen.py | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/tests/avocado/boot_xen.py b/tests/avocado/boot_xen.py
> index f29bc58b9e..490a127a3e 100644
> --- a/tests/avocado/boot_xen.py
> +++ b/tests/avocado/boot_xen.py
> @@ -30,23 +30,22 @@ class BootXen(LinuxKernelTest):
>      timeout = 90
>      XEN_COMMON_COMMAND_LINE = 'dom0_mem=128M loglvl=all guest_loglvl=all'
>  
> -    def fetch_guest_kernel(self):
> +    def setUp(self):
> +        super(BootXen, self).setUp()
> +
>          # Using my own built kernel - which works
>          kernel_url = ('https://fileserver.linaro.org/'
>                        's/JSsewXGZ6mqxPr5/download?path=%2F&files='
>                        'linux-5.9.9-arm64-ajb')
>          kernel_sha1 = '4f92bc4b9f88d5ab792fa7a43a68555d344e1b83'
> -        kernel_path = self.fetch_asset(kernel_url,
> -                                       asset_hash=kernel_sha1)
> -
> -        return kernel_path
> +        self.kernel_path = self.fetch_asset(kernel_url,
> +                                            asset_hash=kernel_sha1)
>  
>      def launch_xen(self, xen_path):
>          """
>          Launch Xen with a dom0 guest kernel
>          """
>          self.log.info("launch with xen_path: %s", xen_path)
> -        kernel_path = self.fetch_guest_kernel()
>  
>          self.vm.set_console()
>  
> @@ -56,7 +55,7 @@ def launch_xen(self, xen_path):
>                           '-append', self.XEN_COMMON_COMMAND_LINE,
>                           '-device',
>                           'guest-loader,addr=0x47000000,kernel=%s,bootargs=console=hvc0'
> -                         % (kernel_path))
> +                         % (self.kernel_path))
>  
>          self.vm.launch()
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


