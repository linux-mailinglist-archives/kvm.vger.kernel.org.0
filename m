Return-Path: <kvm+bounces-30723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D290F9BCB4C
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 12:08:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F71A1C235FC
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 11:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 588581D362B;
	Tue,  5 Nov 2024 11:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ijs5XE6y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEA81D3564
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 11:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730804887; cv=none; b=TOj4bx1uxJrUbYSfh4jpDFOxyBxKD1gWXdUPfL+MVRfAkv4AohAfaNRFFSpgVnSvEKOyxCNwdRMSMvOH1Lvovhoibfox4vc6DZ06PxxEu/mKTzVE0rMHarsDoJTWozu1dxhDeYHGiChGS9RfojfZdOB6h+6zjxdA1l3Hii8agOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730804887; c=relaxed/simple;
	bh=VHfpHDtLbZ+67i+8S4GPE0ftPAaW7c/LlJCovyHFkH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BcG/z0D1PC7PMXnlr+y486Iv8a8gddIten9twyY3jMUs9GcIGXBI/Gg6KXKO1ZxFvxxmYb0UT/WSOBPdFvYCIwrDO1Ii9C7j60GyncA9jzPo2wQkTwDa5C/vWCCOYSnERWVk/TqGpFq5UjI8uqeJ7wdTKC0i4n5acaryvQSdScM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ijs5XE6y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730804884;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=fFlpBvsbBPoFcpImpRRKJS4XnWpYyAeG6Jhz2wg2Hp8=;
	b=Ijs5XE6y5rYcTfJEbTq+FrpGQhHiSWCjIBKT8LGGhIbEdlNw8I3qxtMLt8fz6G8qsrXYJG
	zFFBLKNqdNkE+RShGUbkZcSkRz33HhL3CoKTUKySnnzZjkM7RrY6VonQbVk+q4wMZV8/is
	e4TcLuDCHGHW2Z8RTb0Bl60cX5UaNZk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-212-3Z_Fto3vPTalG53sC869AA-1; Tue,
 05 Nov 2024 06:08:01 -0500
X-MC-Unique: 3Z_Fto3vPTalG53sC869AA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 55F171956064;
	Tue,  5 Nov 2024 11:07:59 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.52])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4335F195607C;
	Tue,  5 Nov 2024 11:07:51 +0000 (UTC)
Date: Tue, 5 Nov 2024 11:07:48 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v6 56/60] i386/tdx: Don't treat SYSCALL as unavailable
Message-ID: <Zyn8hHs7x18aMrLi@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-57-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241105062408.3533704-57-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Tue, Nov 05, 2024 at 01:24:04AM -0500, Xiaoyao Li wrote:

Preferrably explain the rationale for why this is needed in
the commit message.

> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  target/i386/kvm/tdx.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 9cb099e160e4..05475edf72bd 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -734,6 +734,13 @@ static int tdx_check_features(X86ConfidentialGuest *cg, CPUState *cs)
>  
>          requested = env->features[w];
>          unavailable = requested & ~actual;
> +        /*
> +         * Intel enumerates SYSCALL bit as 1 only when processor in 64-bit
> +         * mode and before vcpu running it's not in 64-bit mode.
> +         */
> +        if (w == FEAT_8000_0001_EDX && unavailable & CPUID_EXT2_SYSCALL) {
> +            unavailable &= ~CPUID_EXT2_SYSCALL;
> +        }
>          mark_unavailable_features(cpu, w, unavailable, unav_prefix);
>          if (unavailable) {
>              mismatch = true;
> -- 
> 2.34.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


