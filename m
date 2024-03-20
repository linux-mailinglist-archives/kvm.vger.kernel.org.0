Return-Path: <kvm+bounces-12297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B87F8811B2
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 13:32:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FA0E285E7E
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 12:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48BEA3D97A;
	Wed, 20 Mar 2024 12:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RWlo4Jbd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A06E2E821
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 12:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710937953; cv=none; b=RKOOgY7slAzIWCpfvpxfUH0dAIXI4TgMhAWYwqORL91C0jmm72IWKUXaMdgRjus32Bo/USSirbBmqypnLX/6XemmcY+/4VrkAPHBjfCxZ4drAROgBHEbGfq0YSAK3cfBx7jxoysfD1cXYoTswHqRK/3mshrdzB5/xDuhxxWrzzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710937953; c=relaxed/simple;
	bh=/Tp/nvQWGN6HSWzqtiyOeOAhS7K5k8sPrrrYSY0p99k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oiVjrZ/sQ9dCrbILJWbA4ZaaQCrJ1ynSdmiiU4Py58Ea0X1k1lzMTR/rmAGxbmjJOh0ON46UuUhjNqJC4w+U2daqDHXyBZfxawwF046C+fDxwI8bPsyGP1EdIN95291hS6HeigHoLShvSEjiAAwAn8KNn+E7KYuxtcGvcobvN94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RWlo4Jbd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710937950;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=bRCs6pJZlFIY6ep11w8M2fUuPY6eTctoVDx3pBqwico=;
	b=RWlo4JbdFEO+8s/mhLXcnbkZW+UbAN171bkUa4xctx/I4GEgm4Fd3w/i2yK4/TyK7Oq5mg
	t017T7das9OLHKJpKkEaY51gaw83uKhvyURqZF3645vzivRMZno0ojsKXhYjGhP3wblg8L
	qwXZ7APxiFPa9VKrl1RkKveISPEqq4Q=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-527-HyhpaZ7BPIapRW4mNxVJ6g-1; Wed,
 20 Mar 2024 08:32:26 -0400
X-MC-Unique: HyhpaZ7BPIapRW4mNxVJ6g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70D651C54460;
	Wed, 20 Mar 2024 12:32:26 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.205])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FA37492BDA;
	Wed, 20 Mar 2024 12:32:25 +0000 (UTC)
Date: Wed, 20 Mar 2024 12:32:19 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Isaku Yamahata <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v3 28/49] i386/sev: Disable SMM for SNP
Message-ID: <ZfrXU1VZVak-OHIs@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-29-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240320083945.991426-29-michael.roth@amd.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Wed, Mar 20, 2024 at 03:39:24AM -0500, Michael Roth wrote:
> SNP does not support SMM.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  target/i386/sev.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index b06c796aae..134e8f7c22 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -881,6 +881,7 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>  {
>      SevCommonState *sev_common = SEV_COMMON(cgs);
>      MachineState *ms = MACHINE(qdev_get_machine());
> +    X86MachineState *x86ms = X86_MACHINE(ms);
>      char *devname;
>      int ret, fw_error, cmd;
>      uint32_t ebx;
> @@ -1003,6 +1004,13 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>  
>      if (sev_snp_enabled()) {
>          ms->require_guest_memfd = true;
> +
> +        if (x86ms->smm == ON_OFF_AUTO_AUTO) {
> +            x86ms->smm = ON_OFF_AUTO_OFF;
> +        } else if (x86ms->smm == ON_OFF_AUTO_ON) {
> +            error_report("SEV-SNP does not support SMM.");
> +            goto err;
> +        }
>      }

This method has a 'Error **errp' parameter, so you must use
error_setg, not error_report.



With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


