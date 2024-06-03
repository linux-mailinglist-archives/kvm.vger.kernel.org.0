Return-Path: <kvm+bounces-18642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C0F58D81C3
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 13:58:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 128C2289DDA
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 11:58:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24DB1126F2C;
	Mon,  3 Jun 2024 11:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RhJg2RV2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA01126F0A
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 11:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717415886; cv=none; b=bSqhumefZiSQGiWs7/wHe/5OudQE2Dp5hfUqxL4jFnrX1wrVdevXOxohmffGL00ZWjt7q6kyxNwcNOlflaFNJkSI3nenROoI0fZeqDwxXK8xNnZQL/h21hXTwXLHMQ2k8ZU4WpJvXzCsJl9YqHHmhW97av05Y5aL0AJ6/KnCLBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717415886; c=relaxed/simple;
	bh=oBfnoV8+f2yskPzu8mbv8pMdUoye0Ox1CkCVo3Ev4Eo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hOQvpV+X+R/b/kmoIXPup6EZvpl6fCtfF6QI7PsHNznYi5FaDd+naWv0D8hMlf8C6+A4jP7B6wsoM9NorTXF/xM9lrxjWi21KMYQp4+ywapSK/8XgiW/Q4N4ssH9PuWuMFDRFWR5bh+klvq46uwC26AQSJpnzjdvnEaUmnhJaMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RhJg2RV2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717415883;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=WlmUAlHGosEIpwll4yW/dypoKgrXT7D6koa4wWvyO/E=;
	b=RhJg2RV2FKP8kMa7df0AImwnGrrY146dAp5P9YONJM8KjsKoVsYsSevVYKqKbp7N/8erzh
	04RHz8CBTYyVDQFGQIvCnJfZyEOWeCpRHQhy6xykZvaexEfrO0sahGCnlRwbSCT2Enq+2i
	08S5hILg443PF1xL/dPeiI/Bq6H879g=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-381-77oZJ-SjO563gVbg7UQKng-1; Mon,
 03 Jun 2024 07:58:00 -0400
X-MC-Unique: 77oZJ-SjO563gVbg7UQKng-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C03D4191DB61;
	Mon,  3 Jun 2024 11:57:58 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.80])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5B58230000C3;
	Mon,  3 Jun 2024 11:57:54 +0000 (UTC)
Date: Mon, 3 Jun 2024 12:57:50 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: qemu-devel@nongnu.org, brijesh.singh@amd.com, dovmurik@linux.ibm.com,
	armbru@redhat.com, michael.roth@amd.com, xiaoyao.li@intel.com,
	pbonzini@redhat.com, thomas.lendacky@amd.com,
	isaku.yamahata@intel.com, kvm@vger.kernel.org, anisinha@redhat.com
Subject: Re: [PATCH v4 01/31] i386/sev: Replace error_report with error_setg
Message-ID: <Zl2vvp2Wztpm4yu-@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <20240530111643.1091816-2-pankaj.gupta@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240530111643.1091816-2-pankaj.gupta@amd.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, May 30, 2024 at 06:16:13AM -0500, Pankaj Gupta wrote:
> Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
> ---
>  target/i386/sev.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index d30b68c11e..67ed32e5ea 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -952,13 +952,13 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>  
>      if (sev_es_enabled()) {
>          if (!kvm_kernel_irqchip_allowed()) {
> -            error_report("%s: SEV-ES guests require in-kernel irqchip support",
> -                         __func__);
> +            error_setg(errp, "%s: SEV-ES guests require in-kernel irqchip"
> +                       "support", __func__);
>              goto err;
>          }
>  
>          if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
> -            error_report("%s: guest policy requires SEV-ES, but "
> +            error_setg(errp, "%s: guest policy requires SEV-ES, but "
>                           "host SEV-ES support unavailable",
>                           __func__);
>              goto err;

While changing this, I'd suggest removing '__func__' frmo this - including
internal function names in an error message is not useful to the end user,
as this is a private impl detail, and the text message is sufficiently
clear of the problem already.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


