Return-Path: <kvm+bounces-12299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE7F18811B8
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 13:35:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97776285A11
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 12:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B8643D97A;
	Wed, 20 Mar 2024 12:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UHMhLYBk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D980F1EB4A
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 12:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710938140; cv=none; b=OnlBEl4nr+FVj0YmPThGZeTYyqFfrCHkoAFaEKBbpntJYAk6i5iLOAIj2UfDxcVZ/rs7JNL6kP01tpnH61iUixRxhp3VWFd2Uz8auA+jNPShwoxpXs3k1ZZsXlsn8/P3zj7dhBjQ2rtzkIjktwmdhz14iAup0aolySnfMo+lloo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710938140; c=relaxed/simple;
	bh=Dyh9ENLsGqyrwH2fleHr0fcnETga9NC+06V+5+wTNl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ONaYqoQlgLf9y768nqGTyLJdtuI32vzGEHcaBZP7d30hWgaKiRHBWxDHlxFZR5RWenUVaCv5x3ZtcLxq4QM5lXbO0Fi7g3m7wXVe3kEj9eheF9ZtlrbqwjDtmlGWT9ng1sZeipHYA5Hvwl6z5HqfYai419ruLsmDlziYVxocG5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UHMhLYBk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710938137;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=K5bhn2dwTvZHL2QD2WfC2AZX9DEbxPOtGZ1fjXI2/e8=;
	b=UHMhLYBks2Mep5SHngCUwtp479npVCkgUM64G/Q039XqMWXIGBRV5W2gGVyanatJ3a2HQV
	UZxlX4GlBw9lVxNWxUsrDo7ZQ51Sl9WWabCwCLBgCm9xHwE9qAipjMV+Z125zs1gEmyR/7
	LfdlSLVAluddBfUpLdnG6zGwFy5w3rw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-199-OTNDOuB8PoG4MEsZYgcqHQ-1; Wed, 20 Mar 2024 08:35:34 -0400
X-MC-Unique: OTNDOuB8PoG4MEsZYgcqHQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F237885A58B;
	Wed, 20 Mar 2024 12:35:33 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.205])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 14E7640C6CB3;
	Wed, 20 Mar 2024 12:35:31 +0000 (UTC)
Date: Wed, 20 Mar 2024 12:35:09 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Isaku Yamahata <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v3 23/49] i386/sev: Add a sev_snp_enabled() helper
Message-ID: <ZfrX_SkgXPF1FbCp@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-24-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240320083945.991426-24-michael.roth@amd.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

On Wed, Mar 20, 2024 at 03:39:19AM -0500, Michael Roth wrote:
> Add a simple helper to check if the current guest type is SNP. Also have
> SNP-enabled imply that SEV-ES is enabled as well, and fix up any places
> where the sev_es_enabled() check is expecting a pure/non-SNP guest.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  target/i386/sev.c | 13 ++++++++++++-
>  target/i386/sev.h |  2 ++
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 7e6dab642a..2eb13ba639 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c


> @@ -933,7 +942,9 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>                           __func__);
>              goto err;
>          }
> +    }
>  
> +    if (sev_es_enabled() && !sev_snp_enabled()) {
>          if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
>              error_report("%s: guest policy requires SEV-ES, but "
>                           "host SEV-ES support unavailable",

Opps, pre-existing bug here - this method has an 'Error **errp'
parameter, so should be using 'error_report'.

There are several more examples of this in this method that
predate your patch series.  Can you put a patch at the start
of this series that fixes them before introducing SNP.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


