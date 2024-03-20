Return-Path: <kvm+bounces-12287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DE5E88112F
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 12:48:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B2E31F22C08
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 11:48:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 756033EA92;
	Wed, 20 Mar 2024 11:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f5EEAcYZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF2C3DBB7
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 11:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710935278; cv=none; b=HiHeoUPxTOff+mR7+PzIF96SWK3hTypEKTrKU7d7poxPYqdAsUjYDuUeRqjZO4thNYwoQUF4I8eznd92CVtt0P387gVbWY/8n0KxA5Ma/SsZ24KxpXYqKQj6ecrkghBcYUs3GDRF+GBMmBflrxGZyoyttJMgIPeo6veFIQ0K2dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710935278; c=relaxed/simple;
	bh=t0wbpGPq6tFZIJB1EfsS1gk22ankSxA80jgr1PosOIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JPGY6EgoMXr+P2c+wTet5fGJlfq6KlFEih+O3XGMdVvQU+Lx1S4hjfu7Ue1SbeNTkepVfXVfe1rh5X6MHqRnFKn76CS9uI6/8OIAgsoogaM4ewDv5NX3rIuBwZikktlYmU5X3euSRg8KzmzUJmp3AQrEfj6lnxhPcSHwpeEh+T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f5EEAcYZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710935275;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=ACO5J+apt9WhWRslXtiw90ds41xUnNimB5Qm6zHOcsY=;
	b=f5EEAcYZjXHAf4Ztx+mHunph1Pv9RDOEl5Gx8rHtEY2xAQbYi7sXi/XtNz9US1oNqOg+8H
	psiNbLRCPxOVVFLayrJU1qQs/VWguOr9Y8G8UdveaTadodEw5JV8A5lVKTcoMKBWOoF6V/
	pydkNGk1CpeSY/DODbpE0aIXPu+njMw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-88-XebOVlXENP-3nSagFdA4EQ-1; Wed,
 20 Mar 2024 07:47:52 -0400
X-MC-Unique: XebOVlXENP-3nSagFdA4EQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 140412800C2C;
	Wed, 20 Mar 2024 11:47:52 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.205])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D206B40C6CB3;
	Wed, 20 Mar 2024 11:47:50 +0000 (UTC)
Date: Wed, 20 Mar 2024 11:47:28 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Isaku Yamahata <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v3 21/49] i386/sev: Introduce "sev-common" type to
 encapsulate common SEV state
Message-ID: <ZfrM0KJ78pv53O4j@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-22-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240320083945.991426-22-michael.roth@amd.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

On Wed, Mar 20, 2024 at 03:39:17AM -0500, Michael Roth wrote:
> Currently all SEV/SEV-ES functionality is managed through a single
> 'sev-guest' QOM type. With upcoming support for SEV-SNP, taking this
> same approach won't work well since some of the properties/state
> managed by 'sev-guest' is not applicable to SEV-SNP, which will instead
> rely on a new QOM type with its own set of properties/state.
> 
> To prepare for this, this patch moves common state into an abstract
> 'sev-common' parent type to encapsulate properties/state that are
> common to both SEV/SEV-ES and SEV-SNP, leaving only SEV/SEV-ES-specific
> properties/state in the current 'sev-guest' type. This should not
> affect current behavior or command-line options.
> 
> As part of this patch, some related changes are also made:
> 
>   - a static 'sev_guest' variable is currently used to keep track of
>     the 'sev-guest' instance. SEV-SNP would similarly introduce an
>     'sev_snp_guest' static variable. But these instances are now
>     available via qdev_get_machine()->cgs, so switch to using that
>     instead and drop the static variable.
> 
>   - 'sev_guest' is currently used as the name for the static variable
>     holding a pointer to the 'sev-guest' instance. Re-purpose the name
>     as a local variable referring the 'sev-guest' instance, and use
>     that consistently throughout the code so it can be easily
>     distinguished from sev-common/sev-snp-guest instances.
> 
>   - 'sev' is generally used as the name for local variables holding a
>     pointer to the 'sev-guest' instance. In cases where that now points
>     to common state, use the name 'sev_common'; in cases where that now
>     points to state specific to 'sev-guest' instance, use the name
>     'sev_guest'
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  qapi/qom.json     |  32 ++--
>  target/i386/sev.c | 457 ++++++++++++++++++++++++++--------------------
>  target/i386/sev.h |   3 +
>  3 files changed, 281 insertions(+), 211 deletions(-)
> 

>  static SevInfo *sev_get_info(void)
>  {
>      SevInfo *info;
> +    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
> +    SevGuestState *sev_guest =
> +        (SevGuestState *)object_dynamic_cast(OBJECT(sev_common),
> +                                             TYPE_SEV_GUEST);
>  
>      info = g_new0(SevInfo, 1);
>      info->enabled = sev_enabled();
>  
>      if (info->enabled) {
> -        info->api_major = sev_guest->api_major;
> -        info->api_minor = sev_guest->api_minor;
> -        info->build_id = sev_guest->build_id;
> -        info->policy = sev_guest->policy;
> -        info->state = sev_guest->state;
> -        info->handle = sev_guest->handle;
> +        if (sev_guest) {
> +            info->handle = sev_guest->handle;
> +        }

If we're not going to provide a value for 'handle', then
we should update the QAPI for this to mark the property
as optional, which would then require doing

  info->has_handle = true;

inside this 'if' block.

> +        info->api_major = sev_common->api_major;
> +        info->api_minor = sev_common->api_minor;
> +        info->build_id = sev_common->build_id;
> +        info->state = sev_common->state;
> +        /* we only report the lower 32-bits of policy for SNP, ok for now... */
> +        info->policy =
> +            (uint32_t)object_property_get_uint(OBJECT(sev_common),
> +                                               "policy", NULL);
>      }

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


