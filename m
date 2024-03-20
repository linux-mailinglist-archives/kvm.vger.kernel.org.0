Return-Path: <kvm+bounces-12291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D287881183
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 13:15:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 89D03B21A5D
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 12:15:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFAE73FB3D;
	Wed, 20 Mar 2024 12:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sn7BoaDg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2B0347B6
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 12:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710936914; cv=none; b=Vo2IhkKq+h54664nvO0seE1uX5jJbb7lEWyLKTeorAAxSxaiilbc1/UVMDl7lw80/NR0GlYPOXyc9+4Tvnb2jgIbpYbok6S8izGek2mbLXCEDtHcFKmtVas4Gz+0ffYBg5jQIK8X85BcYjho6avkFfp9CpAmqkbgOAsNa0t2kcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710936914; c=relaxed/simple;
	bh=PVD8Jr90yPWqJIs9Xj+gbFvX9OVO5sWl/9fy23BRnrI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dAiFNQrkqbPVsbX+xnYSb5DepvN3kjmVkG25qYoevDipEl2OT1kmkyrQ4NTKfQmR0VbiNujFfa8B+Nm+OhnRhRflqhjmhV3Mhvxihm3SxDSaf1S2vYnqzN4VH5GK17+eWHl9tILAJOCyvujP0e9Y3B1zuxfj0Ktt7zqYM6KzXvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sn7BoaDg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710936911;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=V9NFEISS+7LkO+X3NM8SEQ5cL8nXFeBIf+Ti9rAUnFw=;
	b=Sn7BoaDgERWaSnvs7LJQhnOXw9YWfmq7V0N82+fgI7szqgEljr+EcnEGVu6T4XAwCZNtYA
	wnO9bITPZlgDMw/hyzrCzL4+AJbU7BKOea31yvEaF+0QKBLkwy4RV8qfw68Uzv5pIbTxSB
	41WC8qalqlxbF4ACLoUbKFBN4aT0ABE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-356-re6iepRVMdaltkouaNRPiw-1; Wed, 20 Mar 2024 08:15:07 -0400
X-MC-Unique: re6iepRVMdaltkouaNRPiw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3717B80026D;
	Wed, 20 Mar 2024 12:15:07 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.205])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DC6E6492BD0;
	Wed, 20 Mar 2024 12:15:05 +0000 (UTC)
Date: Wed, 20 Mar 2024 12:15:00 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Isaku Yamahata <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v3 32/49] i386/sev: Don't return launch measurements for
 SEV-SNP guests
Message-ID: <ZfrTQyEHrxXBq1nB@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-33-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240320083945.991426-33-michael.roth@amd.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Wed, Mar 20, 2024 at 03:39:28AM -0500, Michael Roth wrote:
> For SEV-SNP guests, launch measurement is queried from within the guest
> during attestation, so don't attempt to return it as part of
> query-sev-launch-measure.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  target/i386/sev.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index b03d70a3d1..0c8e4bdb4c 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -803,7 +803,9 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
>  
>  static char *sev_get_launch_measurement(void)
>  {
> -    SevGuestState *sev_guest = SEV_GUEST(MACHINE(qdev_get_machine())->cgs);
> +    ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
> +    SevGuestState *sev_guest =
> +        (SevGuestState *)object_dynamic_cast(OBJECT(cgs), TYPE_SEV_GUEST);
>  
>      if (sev_guest &&
>          SEV_COMMON(sev_guest)->state >= SEV_STATE_LAUNCH_SECRET) {

The QAPI docs for query-sev-launch-measurement should be updated
to reflect that this command is only valid to call for SEV/SEV-ES,
not SNP.

The error reoprting in qmp_query_sev_launch_measure leaves a little
to be desired just giving a generic message

   "SEV launch measurement is not available"

I think that this sev_get_launch_measurement method should report
a more fine grained error, to distinguish

  * Unavailable because we're not a SEV/SEV-ES guest
  * Unavailable because the guest hasn't reached launch state

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


