Return-Path: <kvm+bounces-12298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EE648811B6
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 13:33:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF5C01F2462B
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 12:33:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C19B3D97A;
	Wed, 20 Mar 2024 12:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="errFLGrk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904F02E821
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 12:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710938002; cv=none; b=TcsLuTN88JwZAhE0id1BIbbzZvDzVeRp6qXmhFRBN6tf5vilqB0OTDrK5eVMhsk1brviadnb/XgXOp2RlFLbNjw0MfE10n2HKereugv8EKrvfZUbbc8BBEhKQMZoatVW6opntcCfW+CVsVdpoyBsZ3uHJhEB9MBW6pLKaRvnAf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710938002; c=relaxed/simple;
	bh=032atrOwuW9yo3/SuiSJBmgyjzf3UfhiJ2p0uQEe5Jg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=omFpdLuG8JkKfsBApS/W/FitIz1g0QEcC88kdDveITOQ7zCVha0RWtS3B0JCUsG9qrdEVMw7eXI7VsCf76wWQHyuB8hZaTM/hQ1/MmirVaFzjgxf91oFt4M9RPdG9oSHw7I/OnFeLeiu+AZUOgBfZWV/8s2Bm6rb8TtKXLb3R9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=errFLGrk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710937999;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=LI54pxdGKEWVTWxWzs7S5KmA8mpkqqZDrOFVx2kvCH0=;
	b=errFLGrk9a/DFXzl8iN0OgBALGDqDWjMK7PpOSOo+mpjbLi4m+jO8bWyXWHvLPykrfKaWs
	Le8i+sgZ28xwmJ3RSGt/GAIQ/yhDC0GpDz1VBsDuode3Fu2hee5YHVgPk4VsrnyUfkiZLF
	M7/ruA2Kr3sgTlwtDh2ZTNxp213QF3U=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-220-URfAf05JNkG4lG_Pftr4Uw-1; Wed,
 20 Mar 2024 08:33:17 -0400
X-MC-Unique: URfAf05JNkG4lG_Pftr4Uw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2EE8F1C54460;
	Wed, 20 Mar 2024 12:33:17 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.205])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 10A69112132A;
	Wed, 20 Mar 2024 12:33:15 +0000 (UTC)
Date: Wed, 20 Mar 2024 12:33:10 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Isaku Yamahata <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v3 29/49] i386/sev: Don't disable block discarding for SNP
Message-ID: <ZfrXhhfvVEzPKMc5@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-30-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240320083945.991426-30-michael.roth@amd.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On Wed, Mar 20, 2024 at 03:39:25AM -0500, Michael Roth wrote:
> SEV/SEV-ES rely on pinned memory to back guest RAM so discarding
> isn't actually possible. With SNP, only guest_memfd pages are used
> for private guest memory, so discarding of shared memory is still
> possible, so only disable discard for SEV/SEV-ES.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  target/i386/sev.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 134e8f7c22..43e6c0172f 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -888,10 +888,18 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>      uint32_t host_cbitpos;
>      struct sev_user_data_status status = {};
>  
> -    ret = ram_block_discard_disable(true);
> -    if (ret) {
> -        error_report("%s: cannot disable RAM discard", __func__);
> -        return -1;
> +    /*
> +     * SEV/SEV-ES rely on pinned memory to back guest RAM so discarding
> +     * isn't actually possible. With SNP, only guest_memfd pages are used
> +     * for private guest memory, so discarding of shared memory is still
> +     * possible..
> +     */
> +    if (!sev_snp_enabled()) {
> +        ret = ram_block_discard_disable(true);
> +        if (ret) {
> +            error_report("%s: cannot disable RAM discard", __func__);
> +            return -1;
> +        }
>      }

Pre-existing code bug, but this method must use 'error_setg' to fill
the 'Error **errp' parameter.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


