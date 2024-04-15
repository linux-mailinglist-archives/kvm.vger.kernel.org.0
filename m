Return-Path: <kvm+bounces-14654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 191228A517A
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 15:34:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A53E1C225AC
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 13:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0883912EBF0;
	Mon, 15 Apr 2024 13:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ij6vwJpf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C3212AADA
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 13:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713187342; cv=none; b=sQJOLzu3OZTzePdztmtTyb+1nptQfO9pSiKzZqh2iDolcTtJfpB7uWDnGY9eFHu2PiIaNwcdTDOkcnEyynBzJXdo2l7o4iRVRt4UIWmSmKmx/U15WBAAV4rEqezLX1ZZMX1tyuuD/IsDtZEwqb/RGfnm9CiNTLWu+Re5mwYQqng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713187342; c=relaxed/simple;
	bh=iNs9eWuzvCSmYnGjO4U5FW11YOhrbtSIyWYrcpZhTho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ItWheXzk75FgTrIrBuZhB0zZKaBYbW5t3WX2t70W3sqHkeIk1tVZFQN9/44Mpag3UBGJ1aOusJ6HD++Kkeh3zZSRXzL9WUBbLF/SlWksXiAFjR/R7eSSbp7LD5OFyT1zwzaynsIECICdSnNEQPWDzLpJ+PJ+4wfC6GpohqOBX/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ij6vwJpf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713187339;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ut7g0fG9FN+JvJ9jStuB8+1aO7rWRaxgmZOeef9k/q0=;
	b=ij6vwJpfLFONTEJfu9kI7iHPh3WjmvOmFKwOsDfwQxNg09lFAFIWqyjHuj133soB4Js1fp
	CqywwIetTC9wuN8zXNgsOm0iPIRALcPrdXlQGKs17VyXkrSvPDb+8+c5H7uJgIN3Eh4jp4
	0B95vs1Xq/M2gEmRANSk/PNqRDxv1x4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-119-PBW4fwqMPLK_PPge6oOjXA-1; Mon,
 15 Apr 2024 09:22:16 -0400
X-MC-Unique: PBW4fwqMPLK_PPge6oOjXA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07E3738116F0;
	Mon, 15 Apr 2024 13:22:16 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.103])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 67E71C15771;
	Mon, 15 Apr 2024 13:22:15 +0000 (UTC)
Date: Mon, 15 Apr 2024 14:22:09 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] gitlab-ci: Fix the cirrus pipelines
Message-ID: <Zh0qAfYWGpORIGTl@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240415130321.149890-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240415130321.149890-1-thuth@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

On Mon, Apr 15, 2024 at 03:03:21PM +0200, Thomas Huth wrote:
> Pulling the "master" libvirt-ci containers does not work anymore,
> so we have to switch to the "latest" instead. See also:

We explicitly changed to publish under the 'latest' tag.

> https://gitlab.com/libvirt/libvirt/-/commit/5d591421220c850aa64a640

This commit is the root cause:

  https://gitlab.com/libvirt/libvirt-ci/-/commit/6e3c5ccac77714be70c0dc52c5210c7cda8fe40f

The effects were dormant for a year as I didn't delete the old
':master' tags until two weeks ago.

> Signed-off-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>


> ---
>  .gitlab-ci.yml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index ff34b1f5..98177cdb 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -308,7 +308,7 @@ build-centos7:
>  #   https://gitlab.com/libvirt/libvirt/-/blob/v7.0.0/ci/README.rst
>  #
>  .cirrus_build_job_template: &cirrus_build_job_definition
> - image: registry.gitlab.com/libvirt/libvirt-ci/cirrus-run:master
> + image: registry.gitlab.com/libvirt/libvirt-ci/cirrus-run:latest
>   before_script:
>    - sed -e "s|[@]CI_REPOSITORY_URL@|$CI_REPOSITORY_URL|g"
>          -e "s|[@]CI_COMMIT_REF_NAME@|$CI_COMMIT_REF_NAME|g"
> -- 
> 2.44.0
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


