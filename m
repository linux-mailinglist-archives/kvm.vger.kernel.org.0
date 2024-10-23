Return-Path: <kvm+bounces-29508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B1BC9ACAE5
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:16:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A12291F21EC2
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EFF31B4F17;
	Wed, 23 Oct 2024 13:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IUDvXMzL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42F41ADFF6
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 13:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729689270; cv=none; b=PvWNuyeVg9v8z2UcIB0V9SELyxSnIXFjDVbFUDNHpC40JOPUgzdysi0xS89MrOoHE5EiUbI/0LV3QvW2nGC/XYs/mMB7SbYtojCw6CxK4GP5zNOdTa7yLTkAN1xXm31Mbqc2TVqZXNB2mAtjufu6On5WYGnNbdwGvYMyAxc+Eak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729689270; c=relaxed/simple;
	bh=/btNsqEQnQ/iNt/aDbHjmjiynWq0WKf9q75Z2JF2lIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M6a44DGXTbHQJB0kSHcfS4eko8n5S9zjj0YGwL+DA+YvW0abcAlHUJWTPX405n5t8SLQIajtj/PLSzemBr9kolh2NoZss097vFdZjt163Bsuvp+bnIR/rpVLp1njqCoUn9MCD0a7nC9TUUhTF1LEHS5UIKnBBY2hfVWtEBlD90g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IUDvXMzL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729689267;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+b3DDwCyM3dIDJrog05I+Xx0Ggfa5QHIq1W48Um5CTU=;
	b=IUDvXMzLNlrQeY2GdSzifX/argW8vlrJUjNt1iA4fmGHSVanCDevL0c7rFKPTfBQNnq7Qw
	2lNXDEZdfcl8bOOtKbXIED5QMqd7pvB6JOhslC1GYUDsmjDy5AvbLfI+dqmPjXwUQ6SovA
	hF6jz8J1Ik1uwusSil1ipItTmF6y3WY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-679-sADDw2CRP-KNiv6bR-Payw-1; Wed,
 23 Oct 2024 09:14:23 -0400
X-MC-Unique: sADDw2CRP-KNiv6bR-Payw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E6A11964CC1;
	Wed, 23 Oct 2024 13:14:20 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.19])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CE38119560AE;
	Wed, 23 Oct 2024 13:14:10 +0000 (UTC)
Date: Wed, 23 Oct 2024 14:14:07 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, Zhao Liu <zhao1.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>, John Snow <jsnow@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	devel@lists.libvirt.org, Marcelo Tosatti <mtosatti@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>, qemu-arm@nongnu.org,
	=?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
	Cleber Rosa <crosa@redhat.com>, kvm@vger.kernel.org,
	Beraldo Leal <bleal@redhat.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v3 10/18] gitlab: make check-[dco|patch] a little more
 verbose
Message-ID: <Zxj2n0kxAtnIAd9A@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241023113406.1284676-1-alex.bennee@linaro.org>
 <20241023113406.1284676-11-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241023113406.1284676-11-alex.bennee@linaro.org>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Wed, Oct 23, 2024 at 12:33:58PM +0100, Alex Bennée wrote:
> When git fails the rather terse backtrace only indicates it failed
> without some useful context. Add some to make the log a little more
> useful.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> 
> ---
> v2
>   - keep check_call, just don't redirect stdout/err
> ---
>  .gitlab-ci.d/check-dco.py   | 5 ++---
>  .gitlab-ci.d/check-patch.py | 5 ++---
>  2 files changed, 4 insertions(+), 6 deletions(-)

Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>

> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


