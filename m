Return-Path: <kvm+bounces-22487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF99293F322
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 12:49:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E27672827E4
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 10:49:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72BDA1448E7;
	Mon, 29 Jul 2024 10:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ajbou0FW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA30C140E30
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 10:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722250173; cv=none; b=Nv0vsLnec11WmC/wLC778U7bu++beuBFEfDpOOFeL+5p7ANeXRINwRkcS1MRw9NRUZ3cmUACNa78HqaWOchGeWt1et5NOseRD1bkrnJL71E9EvvLwuxXIa14o4L8i5eX+U5KyDgM08YjCxuYB2nXZnIHtHHpYGcbUHKT2o/ZZYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722250173; c=relaxed/simple;
	bh=40fFv39hWBpnPRmmz6QxRNL5qM0UXsen+11rPtCW/7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rA2MosIlxQepXwV5ngBFFRUQqNFc117Q14R3nrwom5uZJLA/mQZNmLQTpE87YBldU/Sh0ocwx7cv99gPF2Dcb4dE8rU4mw2lfn+2vR2oosKqapPLXvqVvLVFnTupXj4mrtMU3UU9cD3cK5AiT+TWd1Tutd8w8xux1xO9tg6LuVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ajbou0FW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722250170;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=qQ7xkN0cdQZbYI9uQhnUACRFNfA0JuF9jlkfQ15glpU=;
	b=ajbou0FWH1o3u+6hQa3IZQmzV7MYyOme1TyTes9BcenzSPwWTKlbjo12c5tNNH6iBq8ERs
	gUipI5RoiekWqsvrjro5nyygvcJCRazmVFnFXl+9SYAijFT7LvGVT5NPvR/hp9e3dcApf8
	hBwrNHbNxswsdElE3ztCZ8N3T7NKEqs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-575-3PQORB1hMRaLQJELvBW9fQ-1; Mon,
 29 Jul 2024 06:49:27 -0400
X-MC-Unique: 3PQORB1hMRaLQJELvBW9fQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 33F441955D4A;
	Mon, 29 Jul 2024 10:49:25 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.58])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CDE46195605F;
	Mon, 29 Jul 2024 10:49:17 +0000 (UTC)
Date: Mon, 29 Jul 2024 11:49:14 +0100
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
Subject: Re: [PATCH 06/13] tests/avocado: use more distinct names for assets
Message-ID: <ZqdzqnpKja7Xo-Yc@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240726134438.14720-1-crosa@redhat.com>
 <20240726134438.14720-7-crosa@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240726134438.14720-7-crosa@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Fri, Jul 26, 2024 at 09:44:31AM -0400, Cleber Rosa wrote:
> Avocado's asset system will deposit files in a cache organized either
> by their original location (the URI) or by their names.  Because the
> cache (and the "by_name" sub directory) is common across tests, it's a
> good idea to make these names as distinct as possible.
> 
> This avoid name clashes, which makes future Avocado runs to attempt to
> redownload the assets with the same name, but from the different
> locations they actually are from.  This causes cache misses, extra
> downloads, and possibly canceled tests.
> 
> Signed-off-by: Cleber Rosa <crosa@redhat.com>
> ---
>  tests/avocado/kvm_xen_guest.py  | 3 ++-
>  tests/avocado/netdev-ethtool.py | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/avocado/kvm_xen_guest.py b/tests/avocado/kvm_xen_guest.py
> index f8cb458d5d..318fadebc3 100644
> --- a/tests/avocado/kvm_xen_guest.py
> +++ b/tests/avocado/kvm_xen_guest.py
> @@ -40,7 +40,8 @@ def get_asset(self, name, sha1):
>          url = base_url + name
>          # use explicit name rather than failing to neatly parse the
>          # URL into a unique one
> -        return self.fetch_asset(name=name, locations=(url), asset_hash=sha1)
> +        return self.fetch_asset(name=f"qemu-kvm-xen-guest-{name}",
> +                                locations=(url), asset_hash=sha1)

Why do we need to pass a name here at all ? I see the comment here
but it isn't very clear about what the problem is. It just feels
wrong to be creating ourselves uniqueness naming problems, when we
have a nicely unique URL, and that cached URL can be shared across
tests, where as the custom names added by this patch are forcing
no-caching of the same URL between tests.

>  
>      def common_vm_setup(self):
>          # We also catch lack of KVM_XEN support if we fail to launch
> diff --git a/tests/avocado/netdev-ethtool.py b/tests/avocado/netdev-ethtool.py
> index 5f33288f81..462cf8de7d 100644
> --- a/tests/avocado/netdev-ethtool.py
> +++ b/tests/avocado/netdev-ethtool.py
> @@ -27,7 +27,8 @@ def get_asset(self, name, sha1):
>          url = base_url + name
>          # use explicit name rather than failing to neatly parse the
>          # URL into a unique one
> -        return self.fetch_asset(name=name, locations=(url), asset_hash=sha1)
> +        return self.fetch_asset(name=f"qemu-netdev-ethtool-{name}",
> +                                locations=(url), asset_hash=sha1)
>  
>      def common_test_code(self, netdev, extra_args=None):
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


