Return-Path: <kvm+bounces-12294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 614F8881199
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 13:23:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 917ED1C21218
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 12:23:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAC553FB9E;
	Wed, 20 Mar 2024 12:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DyVHvhBZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857683FB82
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 12:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710937384; cv=none; b=WG13r6GViHqV2bcOD+C8faSzFbk6hL0Z1XpeLW2KFYV9DTKAoHSLC6gQhXVhIzFOi2c8bd+njq0x4F0dhRvmFXXxfPLnsp+aM3PpgPsd2VpPuu1fjCUpvumbISRPKggfBzjkwTxZLNWH+ou8N8HXAXzBT/rZdKbd+HlT3aWVsIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710937384; c=relaxed/simple;
	bh=28a8ttPhmJbCd2NGitmTcpJhP7LLburpBU4syXw7EHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aVFHtzmG/KVShxcGWqq9VIfmhUj6JjzEjbT9wAwZA24vH2qmxN90uRlYJQv/42sjp2Mp6duvPckEqCG7munLakIJ/geaP8pkSgX1xoJOTmIiHQwaFXlIWnPBazEFkU16UHe37W7XV75s29SzTWyAqJnzfdfqATmtDWzxnFP4FL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DyVHvhBZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710937381;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=SQceJ9/YZkt6XxI9iTpqGKCag4EEivpdtrk1B+eGx3U=;
	b=DyVHvhBZgwkdAqm0uPFer7XVqziZpNnnl8I2i+ec42N3W1agQYEXzDEdzgiiHoED4Fy11P
	bkJe+JUfJqnPkcS2Yv75u8jrZKKimSi7V+hZsG11xh8gCxUapm5le+8095gRZSK5jBmtjQ
	20/E4CQwVIPgflxejl43+TeI5g6t/hM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-192-ouw4RKJdMuSa2E8buguA7w-1; Wed, 20 Mar 2024 08:22:57 -0400
X-MC-Unique: ouw4RKJdMuSa2E8buguA7w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81B5680330A;
	Wed, 20 Mar 2024 12:22:57 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.205])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 612BB3C20;
	Wed, 20 Mar 2024 12:22:56 +0000 (UTC)
Date: Wed, 20 Mar 2024 12:22:34 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Isaku Yamahata <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v3 47/49] hw/i386/sev: Add support to encrypt BIOS when
 SEV-SNP is enabled
Message-ID: <ZfrVClQEH_yUuXVs@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-48-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240320083945.991426-48-michael.roth@amd.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

On Wed, Mar 20, 2024 at 03:39:43AM -0500, Michael Roth wrote:
> TODO: Brijesh as author, me as co-author (vice-versa depending)
>       drop flash handling? we only support BIOS now

A reminder that this commit message needs fixing.

> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  hw/i386/pc_sysfw.c            | 12 +++++++-----
>  hw/i386/x86.c                 |  2 +-
>  include/hw/i386/x86.h         |  2 +-
>  target/i386/sev-sysemu-stub.c |  2 +-
>  target/i386/sev.c             | 15 +++++++++++----
>  target/i386/sev.h             |  2 +-
>  6 files changed, 22 insertions(+), 13 deletions(-)

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


