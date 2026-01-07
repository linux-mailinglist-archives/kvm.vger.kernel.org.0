Return-Path: <kvm+bounces-67213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A9A4ECFD343
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 11:36:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AF0D0306963E
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 10:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40D05322A0A;
	Wed,  7 Jan 2026 10:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vpo/KhPT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB9D31812C
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 10:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767781654; cv=none; b=Bbx5XGbzV7q1uFUmE8TNQbOylJdLwPNos86OOOi7fUNBgnYojXTONxjExvNP/8Ouij++7Y5IT336sp41wxvbFMqM4QJDgQ34Y2PMGqBKhH4pXsqWsT8NiZmIQ4IzykxEcLrSeXGHSsgrw5oEES9/7zTb8x3Ol/r8k7yk+IKnKco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767781654; c=relaxed/simple;
	bh=FjQzwXFo5MlrvgxgsMJltyme9Wc+pWNh/mWm6hfDH+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W/3pYlO8KFcuJkFZo5W5H6UaJhXFgL7hp/ryTnIRfHXpQG+TumIoy8HSQuKcr9Of4zvN1DbaYkhXclwP2iH487QMcebJWYRtBtXyojFNqSE0NHGi5UtzQZkeXpqrlmTqkITJDb+fjyi9FWPdGoDFWpoMdXDdbxcoBCdpTS+b+XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vpo/KhPT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767781651;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LkLBY3b4HKc7Dnp8QpnTuvCHtXY90DZNUs/UBD3mHQQ=;
	b=Vpo/KhPTP1SllWdxC4bVHRVpc5pDaNwCjSuFFm6Ex/H9kw22dne/tX3t3A/adyCnyD0B4I
	PLscOdsOPvyAc7H4OGXqTBYDsJ2CnTp9uu9HMjTzG63Ya10894RoRnF2EEjxtARyFpdajF
	ePaOywxGD6XWjT+HJsWC+gI8sx83y7s=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-6r35nsC_MvODcA2Kzr8G8g-1; Wed,
 07 Jan 2026 05:27:28 -0500
X-MC-Unique: 6r35nsC_MvODcA2Kzr8G8g-1
X-Mimecast-MFC-AGG-ID: 6r35nsC_MvODcA2Kzr8G8g_1767781647
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2E19B18002C5;
	Wed,  7 Jan 2026 10:27:27 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.169])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3633218007D2;
	Wed,  7 Jan 2026 10:27:24 +0000 (UTC)
Date: Wed, 7 Jan 2026 10:27:21 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: marcandre.lureau@redhat.com
Cc: qemu-devel@nongnu.org, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"open list:X86 KVM CPUs" <kvm@vger.kernel.org>
Subject: Re: [PATCH] Add query-tdx-capabilities
Message-ID: <aV41CQP0JODTdRqy@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20260106183620.2144309-1-marcandre.lureau@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260106183620.2144309-1-marcandre.lureau@redhat.com>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Tue, Jan 06, 2026 at 10:36:20PM +0400, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> Return an empty TdxCapability struct, for extensibility and matching
> query-sev-capabilities return type.
> 
> Fixes: https://issues.redhat.com/browse/RHEL-129674
> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> ---
>  qapi/misc-i386.json        | 30 ++++++++++++++++++++++++++++++
>  target/i386/kvm/kvm_i386.h |  1 +
>  target/i386/kvm/kvm.c      |  5 +++++
>  target/i386/kvm/tdx-stub.c |  8 ++++++++
>  target/i386/kvm/tdx.c      | 21 +++++++++++++++++++++
>  5 files changed, 65 insertions(+)
> 
> diff --git a/qapi/misc-i386.json b/qapi/misc-i386.json
> index 05a94d6c416..f10e4338b48 100644
> --- a/qapi/misc-i386.json
> +++ b/qapi/misc-i386.json
> @@ -225,6 +225,36 @@
>  ##
>  { 'command': 'query-sev-capabilities', 'returns': 'SevCapability' }
>  
> +##
> +# @TdxCapability:
> +#
> +# The struct describes capability for Intel Trust Domain Extensions
> +# (TDX) feature.
> +#
> +# Since: 11.0
> +##
> +{ 'struct': 'TdxCapability',
> +  'data': { } }
> +
> +##
> +# @query-tdx-capabilities:
> +#
> +# Get TDX capabilities.
> +#
> +# This is only supported on Intel X86 platforms with KVM enabled.
> +#
> +# Errors:
> +#     - If TDX is not available on the platform, GenericError
> +#
> +# Since: 11.0
> +#
> +# .. qmp-example::
> +#
> +#     -> { "execute": "query-tdx-capabilities" }
> +#     <- { "return": {} }
> +##
> +{ 'command': 'query-tdx-capabilities', 'returns': 'TdxCapability' }

This matches the conceptual design used with query-sev-capabilities,
where the lack of SEV support has to be inferred from the command
returning "GenericError". On the one hand this allows the caller to
distinguish different scenarios - unsupported due to lack of HW
support, vs unsupported due to lack of KVM support. On the other
hand 'GenericError' might reflect other things that should be
considered fatal errors, rather than indicitive of lack of support
in the host.

With the other 'query-sev' command, we have "enabled: bool" field,
and when enabled == false, the other fields are documented to have
undefined values.

I tend towards suggesting that 'query-sev-capabilities' (and thus
also this new query-tdx-capabilities) should have been more like
query-sev,  and had a a "supported: bool" field to denote the lack
of support in the host.

This would not have allowed callers to disinguish the reason why
SEV/TDX is not supported (hardware vs KVM), but I'm not sure that
reason matters for callers - lack of KVM support is more of an
OS integration problem.




> +
>  ##
>  # @sev-inject-launch-secret:
>  #
> diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
> index 2b653442f4d..71dd45be47a 100644
> --- a/target/i386/kvm/kvm_i386.h
> +++ b/target/i386/kvm/kvm_i386.h
> @@ -61,6 +61,7 @@ void kvm_put_apicbase(X86CPU *cpu, uint64_t value);
>  
>  bool kvm_has_x2apic_api(void);
>  bool kvm_has_waitpkg(void);
> +bool kvm_has_tdx(void);
>  
>  uint64_t kvm_swizzle_msi_ext_dest_id(uint64_t address);
>  void kvm_update_msi_routes_all(void *private, bool global,
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 7b9b740a8e5..8ce25d7e785 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -6582,6 +6582,11 @@ bool kvm_has_waitpkg(void)
>      return has_msr_umwait;
>  }
>  
> +bool kvm_has_tdx(void)
> +{
> +    return kvm_is_vm_type_supported(KVM_X86_TDX_VM);
> +}
> +
>  #define ARCH_REQ_XCOMP_GUEST_PERM       0x1025
>  
>  void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask)
> diff --git a/target/i386/kvm/tdx-stub.c b/target/i386/kvm/tdx-stub.c
> index 1f0e108a69e..c4e7f2c58c8 100644
> --- a/target/i386/kvm/tdx-stub.c
> +++ b/target/i386/kvm/tdx-stub.c
> @@ -1,6 +1,8 @@
>  /* SPDX-License-Identifier: GPL-2.0-or-later */
>  
>  #include "qemu/osdep.h"
> +#include "qapi/error.h"
> +#include "qapi/qapi-commands-misc-i386.h"
>  
>  #include "tdx.h"
>  
> @@ -30,3 +32,9 @@ void tdx_handle_get_tdvmcall_info(X86CPU *cpu, struct kvm_run *run)
>  void tdx_handle_setup_event_notify_interrupt(X86CPU *cpu, struct kvm_run *run)
>  {
>  }
> +
> +TdxCapability *qmp_query_tdx_capabilities(Error **errp)
> +{
> +    error_setg(errp, "TDX is not available in this QEMU");
> +    return NULL;
> +}
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 01619857685..b5ee3b1ab92 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -14,6 +14,7 @@
>  #include "qemu/base64.h"
>  #include "qemu/mmap-alloc.h"
>  #include "qapi/error.h"
> +#include "qapi/qapi-commands-misc-i386.h"
>  #include "qapi/qapi-visit-sockets.h"
>  #include "qom/object_interfaces.h"
>  #include "crypto/hash.h"
> @@ -1537,6 +1538,26 @@ static void tdx_guest_finalize(Object *obj)
>  {
>  }
>  
> +static TdxCapability *tdx_get_capabilities(Error **errp)
> +{
> +    if (!kvm_enabled()) {
> +        error_setg(errp, "TDX is not available without KVM");
> +        return NULL;
> +    }
> +
> +    if (!kvm_has_tdx()) {
> +        error_setg(errp, "TDX is not supported by this host");
> +        return NULL;
> +    }
> +
> +    return g_new0(TdxCapability, 1);
> +}
> +
> +TdxCapability *qmp_query_tdx_capabilities(Error **errp)
> +{
> +    return tdx_get_capabilities(errp);
> +}
> +
>  static void tdx_guest_class_init(ObjectClass *oc, const void *data)
>  {
>      ConfidentialGuestSupportClass *klass = CONFIDENTIAL_GUEST_SUPPORT_CLASS(oc);
> -- 
> 2.52.0
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


