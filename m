Return-Path: <kvm+bounces-22493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A4F893F3A7
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 13:09:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 578161C21D75
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 11:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59D96145A17;
	Mon, 29 Jul 2024 11:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g1v9N+EK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC82145A01
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 11:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722251337; cv=none; b=hCUdCxJK9NAR5uCITPwgrhpYq+bDqkG6kBg9NXShbhwGX9zUUU+4X5MAW2tGXXlpW4hFN0gzYFD4x0LOVc195mtTh4JJTvtTP0bF0ToCEdINt6a0Cs86Yp+nNNRfiyKgMj1bcOiHXmk38lzCZNQiDxEUipthiA6my7fLXGAwFgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722251337; c=relaxed/simple;
	bh=HRk2Q4NIsCPzcOa/Tj5E9U7ir1I4c4ucOXry7ftXj24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ORfAavB6CPnJ6o4Z9NZbrE5CrbS36P5a7geu2VbIQhIMXJ5sttC2BQLsCS7hJPLhjH1/JVfocXE2nSBoZyHJYo/A6OCr9wj2N6UxRzKvbjpsDT97wMif3ZjOXNGOj3i+VRbj0/pQHFifAbNLGDkdozJ4b361lO++xhX1QEAw8QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g1v9N+EK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722251334;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=B1VdBTnyn5qt9IYla/ESU9CYnd0IBiOOUAW5rSXdVM8=;
	b=g1v9N+EK2tazg+XKlXagf2OuSg8PpVR44hgAK5xKfBHEOzHJS3sz3hMzJo1lRLAKfg7OTI
	2zwEdXlHDtoZOKc+db4t2CnpAqssQULvwI22IokO7K39zqIR658288N8X01YH0wGJG/wtr
	6CfgVgfDD5cUeScgD6YZoQw/eDHqgss=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-193-1lHYfOtrOJu55Ip7tXWDBQ-1; Mon,
 29 Jul 2024 07:08:51 -0400
X-MC-Unique: 1lHYfOtrOJu55Ip7tXWDBQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B32E19560B4;
	Mon, 29 Jul 2024 11:08:49 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.58])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 291E11955F68;
	Mon, 29 Jul 2024 11:08:42 +0000 (UTC)
Date: Mon, 29 Jul 2024 12:08:39 +0100
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
Subject: Re: [PATCH 12/13] Bump avocado to 103.0
Message-ID: <Zqd4N0udouYyI_d-@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240726134438.14720-1-crosa@redhat.com>
 <20240726134438.14720-13-crosa@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240726134438.14720-13-crosa@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Fri, Jul 26, 2024 at 09:44:37AM -0400, Cleber Rosa wrote:
> This bumps Avocado to latest the LTS release.
> 
> An LTS release is one that can receive bugfixes and guarantees
> stability for a much longer period and has incremental minor releases
> made.
> 
> Even though the 103.0 LTS release is pretty a rewrite of Avocado when
> compared to 88.1, the behavior of all existing tests under
> tests/avocado has been extensively tested no regression in behavior
> was found.

Rebasing to a completely re-written test harness while in freeze feels
on the risky side to me, despite the known problems we have with the
existing release. 

> Reference: https://avocado-framework.readthedocs.io/en/103.0/releases/lts/103_0.html
> Signed-off-by: Cleber Rosa <crosa@redhat.com>
> ---
>  pythondeps.toml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/pythondeps.toml b/pythondeps.toml
> index f6e590fdd8..175cf99241 100644
> --- a/pythondeps.toml
> +++ b/pythondeps.toml
> @@ -30,5 +30,5 @@ sphinx_rtd_theme = { accepted = ">=0.5", installed = "1.1.1" }
>  # Note that qemu.git/python/ is always implicitly installed.
>  # Prefer an LTS version when updating the accepted versions of
>  # avocado-framework, for example right now the limit is 92.x.
> -avocado-framework = { accepted = "(>=88.1, <93.0)", installed = "88.1", canary = "avocado" }
> +avocado-framework = { accepted = "(>=103.0, <104.0)", installed = "103.0", canary = "avocado" }
>  pycdlib = { accepted = ">=1.11.0" }
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


