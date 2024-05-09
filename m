Return-Path: <kvm+bounces-17118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5369F8C1102
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 16:11:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09312282F9C
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 14:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0F3B15E205;
	Thu,  9 May 2024 14:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fk7oUK3O"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0BC15250D
	for <kvm@vger.kernel.org>; Thu,  9 May 2024 14:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715263890; cv=none; b=a2rgjjAuNtU8fIafP6g3k5JUVq9LGAw2uNYTNT1qdwkoL0Y+woFZoDdLfsK9YVTLMqlXxHKvqswN6v9cH/ObwZRGXYh7CY9pdS9MwW3ZboUDfpQ6WKMKwfjPcVvjCOiNtDtNA8/pkNwWh7OdeYbAQOvN8jI31irbAQerpjLz78s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715263890; c=relaxed/simple;
	bh=NAZvbUXF81kt2MGIbgWDuIyEJ67SN5bcG1VeAi/hXPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SLDry+BMbWBRNGiLxqqCRgiOT2TpFkU/okGxpGdMBPwXIyZhf1qo4sqzlG1fASptmgbyXQpmcdL518GeZA0IhEgKMClYOmKb1BFavvC02wxWBj90dKYytGZdvrd/rqLy+Ra656GJHX7e771CaLpsjjZZuOu4roN4FuuBBGqygkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fk7oUK3O; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715263888;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=MwDf4z2qPk9gIInCEQqfGV/TxXqVFqrdl4H4xc+6TvM=;
	b=Fk7oUK3OM9DBaM30wBGf39++PnCvDZ8SfAYMZWNAXw3d8H6r+C8WKNTtZHSgi6YYo7uKX8
	QAOEkLBur6uFJ0UxYN2sb5S+nK8VSGeLFS0Z+2kFWCf8/c/XWgrU/oAZayGNuqpkRhB29T
	WPe/an5b6T/g1m1s3z5mmZv2ugFPsW4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-yXt33DdxN3G2tAfz5FD_og-1; Thu, 09 May 2024 10:11:22 -0400
X-MC-Unique: yXt33DdxN3G2tAfz5FD_og-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F806800656;
	Thu,  9 May 2024 14:11:21 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.79])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 62ADC403BF6F;
	Thu,  9 May 2024 14:11:17 +0000 (UTC)
Date: Thu, 9 May 2024 15:11:14 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Babu Moger <babu.moger@amd.com>, pbonzini@redhat.com,
	richard.henderson@linaro.org, weijiang.yang@intel.com,
	philmd@linaro.org, dwmw@amazon.co.uk, paul@xen.org,
	joao.m.martins@oracle.com, qemu-devel@nongnu.org,
	mtosatti@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
	marcel.apfelbaum@gmail.com, yang.zhong@intel.com,
	jing2.liu@intel.com, vkuznets@redhat.com, michael.roth@amd.com,
	wei.huang2@amd.com, bdas@redhat.com, eduardo@habkost.net,
	qemu-stable <qemu-stable@nongnu.org>
Subject: Re: [PATCH v3] target/i386: Fix CPUID encoding of Fn8000001E_ECX
Message-ID: <ZjzZgmt-UMFsGjvZ@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240102231738.46553-1-babu.moger@amd.com>
 <0ee4b0a8293188a53970a2b0e4f4ef713425055e.1714757834.git.babu.moger@amd.com>
 <89911cf2-7048-4571-a39a-8fa44d7efcda@tls.msk.ru>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <89911cf2-7048-4571-a39a-8fa44d7efcda@tls.msk.ru>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

On Thu, May 09, 2024 at 04:54:16PM +0300, Michael Tokarev wrote:
> 03.05.2024 20:46, Babu Moger wrote:
> > Observed the following failure while booting the SEV-SNP guest and the
> > guest fails to boot with the smp parameters:
> > "-smp 192,sockets=1,dies=12,cores=8,threads=2".
> > 
> > qemu-system-x86_64: sev_snp_launch_update: SNP_LAUNCH_UPDATE ret=-5 fw_error=22 'Invalid parameter'
> > qemu-system-x86_64: SEV-SNP: CPUID validation failed for function 0x8000001e, index: 0x0.
> > provided: eax:0x00000000, ebx: 0x00000100, ecx: 0x00000b00, edx: 0x00000000
> > expected: eax:0x00000000, ebx: 0x00000100, ecx: 0x00000300, edx: 0x00000000
> > qemu-system-x86_64: SEV-SNP: failed update CPUID page
> ...
> > Cc: qemu-stable@nongnu.org
> > Fixes: 31ada106d891 ("Simplify CPUID_8000_001E for AMD")
> > Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
> > Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> > Signed-off-by: Babu Moger <babu.moger@amd.com>
> > ---
> > v3:
> >    Rebased to the latest tree.
> >    Updated the pc_compat_9_0 for the new flag.
> 
> > diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> > index 08c7de416f..46235466d7 100644
> > --- a/hw/i386/pc.c
> > +++ b/hw/i386/pc.c
> > @@ -81,6 +81,7 @@
> >   GlobalProperty pc_compat_9_0[] = {
> >       { TYPE_X86_CPU, "guest-phys-bits", "0" },
> >       { "sev-guest", "legacy-vm-type", "true" },
> > +    { TYPE_X86_CPU, "legacy-multi-node", "on" },
> >   };
> 
> Should this legacy-multi-node property be added to previous
> machine types when applying to stable?  How about stable-8.2
> and stable-7.2?

machine types are considered to express a fixed guest ABI
once part of a QEMU release. Given that we should not be
changing existing machine types in stable branches.

In theory we could create new "bug fix" machine types in stable
branches. To support live migration, we would then need to also
add those same stable branch "bug fix" machine type versions in
all future QEMU versions. This is generally not worth the hassle
of exploding the number of machine types.

If you backport the patch, minus the machine type, then users
can still get the fix but they'll need to manually set the
property to enable it.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


