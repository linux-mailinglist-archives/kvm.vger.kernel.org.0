Return-Path: <kvm+bounces-12293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F7DC881196
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 13:20:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C9971C213AF
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 12:20:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C30043FB95;
	Wed, 20 Mar 2024 12:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OCqkateL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DA33EA62
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 12:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710937240; cv=none; b=n00TxwahKHGNm8MXAc7PVVBYrxWkPPIELLx7mvkGE4we1JYY2YoDGrPGbprAFuqmk0e1qfzrX7l6i9QfqE+G2Vaihp4l8ljpH39HbXlfO8HumHU9DRImphE+rifD6oBdQqXAuDZN9f8xtfNVvFWLD9itT/VTTcheXssMSq2KwJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710937240; c=relaxed/simple;
	bh=bI4yEXpC+Ozpvc2Hv1HRzOnfQNnImZCpbXmwrNi0c4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rOgDjnDZifgVqFy9LAjX2vhYN4ior256502ZkU9XCrdnFogbmJLjsJDjkG7UMOb3zH+pvaXIM2okXMC7iT3aHKtga5o/5Cl00nKxMOPSlWeiLBIxLNW5mkNoB5FkLXzVrq3drz5t3+HIyt8cSzFQ0ZeAPRYQk8otmrfK5Vak9QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OCqkateL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710937237;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=HNYvmFAa567wA6FN844Ryj3Mrt2bsGnF2CaPI2nteIM=;
	b=OCqkateL1zdaYrfTmeVH505KHGrfU2C7gPxokPjvoJz0aNL9NN7my341k2N0EJSitAHtnz
	QCEqKbNyJI+kAjPtkyuqLxjwE8PyOQG3OCNG1XvmyaaPEXL+ghurtOjIYTc/arE12x64h5
	8yzFBhNextrCykeeJLR0dW1vAoUS8GI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-557-CVQCHhebPIiF09UaziIiPw-1; Wed, 20 Mar 2024 08:20:34 -0400
X-MC-Unique: CVQCHhebPIiF09UaziIiPw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29512185A781;
	Wed, 20 Mar 2024 12:20:34 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.205])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E096BC5FDBB;
	Wed, 20 Mar 2024 12:20:31 +0000 (UTC)
Date: Wed, 20 Mar 2024 12:20:24 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Isaku Yamahata <isaku.yamahata@linux.intel.com>,
	Dov Murik <dovmurik@linux.ibm.com>
Subject: Re: [PATCH v3 43/49] qapi, i386: Move kernel-hashes to
 SevCommonProperties
Message-ID: <ZfrUiBlbEVHkMYl0@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-44-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240320083945.991426-44-michael.roth@amd.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

On Wed, Mar 20, 2024 at 03:39:39AM -0500, Michael Roth wrote:
> From: Dov Murik <dovmurik@linux.ibm.com>
> 
> In order to enable kernel-hashes for SNP, pull it from
> SevGuestProperties to its parent SevCommonProperties so
> it will be available for both SEV and SNP.
> 
> Signed-off-by: Dov Murik <dovmurik@linux.ibm.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  qapi/qom.json     | 14 +++++++-------
>  target/i386/sev.c | 44 ++++++++++++++++++--------------------------
>  2 files changed, 25 insertions(+), 33 deletions(-)

This change ought to be squashed into the earlier patch
that introduce sev-guest-common.

> 
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 7ba778af91..ea8832a8c3 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -886,12 +886,17 @@
>  # @reduced-phys-bits: number of bits in physical addresses that become
>  #     unavailable when SEV is enabled
>  #
> +# @kernel-hashes: if true, add hashes of kernel/initrd/cmdline to a
> +#     designated guest firmware page for measured boot with -kernel
> +#     (default: false) (since 6.2)
> +#
>  # Since: 2.12
>  ##
>  { 'struct': 'SevCommonProperties',
>    'data': { '*sev-device': 'str',
>              '*cbitpos': 'uint32',
> -            'reduced-phys-bits': 'uint32' } }
> +            'reduced-phys-bits': 'uint32',
> +            '*kernel-hashes': 'bool' } }
>  
>  ##
>  # @SevGuestProperties:
> @@ -906,10 +911,6 @@
>  #
>  # @handle: SEV firmware handle (default: 0)
>  #
> -# @kernel-hashes: if true, add hashes of kernel/initrd/cmdline to a
> -#     designated guest firmware page for measured boot with -kernel
> -#     (default: false) (since 6.2)
> -#
>  # Since: 2.12
>  ##
>  { 'struct': 'SevGuestProperties',
> @@ -917,8 +918,7 @@
>    'data': { '*dh-cert-file': 'str',
>              '*session-file': 'str',
>              '*policy': 'uint32',
> -            '*handle': 'uint32',
> -            '*kernel-hashes': 'bool' } }
> +            '*handle': 'uint32' } }
>  
>  ##
>  # @SevSnpGuestProperties:
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index db888afb53..3187b3dee8 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -54,6 +54,7 @@ struct SevCommonState {
>      char *sev_device;
>      uint32_t cbitpos;
>      uint32_t reduced_phys_bits;
> +    bool kernel_hashes;
>  
>      /* runtime state */
>      uint8_t api_major;
> @@ -86,7 +87,6 @@ struct SevGuestState {
>      uint32_t policy;
>      char *dh_cert_file;
>      char *session_file;
> -    bool kernel_hashes;
>  };
>  
>  struct SevSnpGuestState {
> @@ -1696,16 +1696,12 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
>      MemTxAttrs attrs = { 0 };
>      bool ret = true;
>      SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
> -    SevGuestState *sev_guest =
> -        (SevGuestState *)object_dynamic_cast(OBJECT(sev_common),
> -                                             TYPE_SEV_GUEST);
>  
>      /*
>       * Only add the kernel hashes if the sev-guest configuration explicitly
> -     * stated kernel-hashes=on. Currently only enabled for SEV/SEV-ES guests,
> -     * so check for TYPE_SEV_GUEST as well.
> +     * stated kernel-hashes=on.
>       */
> -    if (sev_guest && !sev_guest->kernel_hashes) {
> +    if (!sev_common->kernel_hashes) {
>          return false;
>      }
>  
> @@ -2037,6 +2033,16 @@ sev_common_set_sev_device(Object *obj, const char *value, Error **errp)
>      SEV_COMMON(obj)->sev_device = g_strdup(value);
>  }
>  
> +static bool sev_common_get_kernel_hashes(Object *obj, Error **errp)
> +{
> +    return SEV_COMMON(obj)->kernel_hashes;
> +}
> +
> +static void sev_common_set_kernel_hashes(Object *obj, bool value, Error **errp)
> +{
> +    SEV_COMMON(obj)->kernel_hashes = value;
> +}
> +
>  static void
>  sev_common_class_init(ObjectClass *oc, void *data)
>  {
> @@ -2051,6 +2057,11 @@ sev_common_class_init(ObjectClass *oc, void *data)
>                                    sev_common_set_sev_device);
>      object_class_property_set_description(oc, "sev-device",
>              "SEV device to use");
> +    object_class_property_add_bool(oc, "kernel-hashes",
> +                                   sev_common_get_kernel_hashes,
> +                                   sev_common_set_kernel_hashes);
> +    object_class_property_set_description(oc, "kernel-hashes",
> +            "add kernel hashes to guest firmware for measured Linux boot");
>  }
>  
>  static void
> @@ -2109,20 +2120,6 @@ sev_guest_set_session_file(Object *obj, const char *value, Error **errp)
>      SEV_GUEST(obj)->session_file = g_strdup(value);
>  }
>  
> -static bool sev_guest_get_kernel_hashes(Object *obj, Error **errp)
> -{
> -    SevGuestState *sev_guest = SEV_GUEST(obj);
> -
> -    return sev_guest->kernel_hashes;
> -}
> -
> -static void sev_guest_set_kernel_hashes(Object *obj, bool value, Error **errp)
> -{
> -    SevGuestState *sev = SEV_GUEST(obj);
> -
> -    sev->kernel_hashes = value;
> -}
> -
>  static void
>  sev_guest_class_init(ObjectClass *oc, void *data)
>  {
> @@ -2136,11 +2133,6 @@ sev_guest_class_init(ObjectClass *oc, void *data)
>                                    sev_guest_set_session_file);
>      object_class_property_set_description(oc, "session-file",
>              "guest owners session parameters (encoded with base64)");
> -    object_class_property_add_bool(oc, "kernel-hashes",
> -                                   sev_guest_get_kernel_hashes,
> -                                   sev_guest_set_kernel_hashes);
> -    object_class_property_set_description(oc, "kernel-hashes",
> -            "add kernel hashes to guest firmware for measured Linux boot");
>  }
>  
>  static void
> -- 
> 2.25.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


