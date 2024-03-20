Return-Path: <kvm+bounces-12292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94DC8881190
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 13:19:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F21D6B21DA6
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 12:19:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DB9B3FB8A;
	Wed, 20 Mar 2024 12:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RJRC4rGV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4613EA98
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 12:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710937153; cv=none; b=m/FI3Vv9VuLC8wS4eu0Kfs/lUk9jMSznai/dOCqK/5AHVO4uL36TlKRgGDRdFFi05NitA8YXz38FBQg8rj2NRfHPK7HtxKfB2mOAEwMV67ImQ/EAQBRrKkC/s5V0gJfzaG98F4HuQEl9A06IPAHA6rBmII9JqEFLMMKYqO+16mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710937153; c=relaxed/simple;
	bh=7mmDKhJxFjWh01i8dGYyrf6Yba7gW8Jp1pWj3COQq9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XxIcSNpTFmBAGTK7WSc1nl180UDLRkh/AUdsCxpSHQCHUzITJqndevAySJ6mKIsdgdrVzKRZWvtWcqOQ4ZE9jzHzjQZ3uh8kg6I7EOdpYT+3R9rYEjn0jc6YEPtRWX3YCMKLBERaqjdZ+kpZXLw6nrFDGo0epEfiFrzuAVUXpXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RJRC4rGV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710937151;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=Z+ssQQQdNxOxj9xKDlEMieDSkHVA/7a1kXcY2syiQZI=;
	b=RJRC4rGV/sFcVsh4BS86+M9wMg1yA1T8kQUmQQI5jlTEDBNClWoDamfkduvC3KjYr/mlX1
	doyoj2UTBPsZDaOqaksXnGBI+ZKpege7kVXl0uSTbGwgO7AdcmSHDpDS4zHlTAFT0h8tvR
	5xn7H+i0AO9hMSgWLrS4rTdO8Jtfons=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530--8savm7cM3OuOBO5G4Qjsg-1; Wed, 20 Mar 2024 08:19:06 -0400
X-MC-Unique: -8savm7cM3OuOBO5G4Qjsg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26464800267;
	Wed, 20 Mar 2024 12:19:06 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.205])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0296140C6CB3;
	Wed, 20 Mar 2024 12:19:04 +0000 (UTC)
Date: Wed, 20 Mar 2024 12:18:43 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Isaku Yamahata <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v3 42/49] i386/sev: Add support for SNP CPUID validation
Message-ID: <ZfrUI3yqliykklMD@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-43-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240320083945.991426-43-michael.roth@amd.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

On Wed, Mar 20, 2024 at 03:39:38AM -0500, Michael Roth wrote:
> SEV-SNP firmware allows a special guest page to be populated with a
> table of guest CPUID values so that they can be validated through
> firmware before being loaded into encrypted guest memory where they can
> be used in place of hypervisor-provided values[1].
> 
> As part of SEV-SNP guest initialization, use this interface to validate
> the CPUID entries reported by KVM_GET_CPUID2 prior to initial guest
> start and populate the CPUID page reserved by OVMF with the resulting
> encrypted data.
> 
> [1] SEV SNP Firmware ABI Specification, Rev. 0.8, 8.13.2.6
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  target/i386/sev.c | 159 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 158 insertions(+), 1 deletion(-)
> 

> +static void
> +sev_snp_cpuid_report_mismatches(SnpCpuidInfo *old,
> +                                SnpCpuidInfo *new)
> +{
> +    size_t i;
> +
> +    if (old->count != new->count) {
> +        error_report("SEV-SNP: CPUID validation failed due to count mismatch, provided: %d, expected: %d",
> +                     old->count, new->count);
> +    }

Missing 'return' here, may result in array out of bounds on 'new->entries'
in the next loop

> +
> +    for (i = 0; i < old->count; i++) {
> +        SnpCpuidFunc *old_func, *new_func;
> +
> +        old_func = &old->entries[i];
> +        new_func = &new->entries[i];
> +
> +        if (memcmp(old_func, new_func, sizeof(SnpCpuidFunc))) {
> +            error_report("SEV-SNP: CPUID validation failed for function 0x%x, index: 0x%x.\n"
> +                         "provided: eax:0x%08x, ebx: 0x%08x, ecx: 0x%08x, edx: 0x%08x\n"
> +                         "expected: eax:0x%08x, ebx: 0x%08x, ecx: 0x%08x, edx: 0x%08x",
> +                         old_func->eax_in, old_func->ecx_in,
> +                         old_func->eax, old_func->ebx, old_func->ecx, old_func->edx,
> +                         new_func->eax, new_func->ebx, new_func->ecx, new_func->edx);
> +        }
> +    }
> +}
> +


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


