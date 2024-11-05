Return-Path: <kvm+bounces-30717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15F199BCA9D
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 11:38:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9E632865A0
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 10:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D21161D2B17;
	Tue,  5 Nov 2024 10:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CImgJkj5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250822EB1F
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 10:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730803131; cv=none; b=B6Wp0q1imoxBWfnvwtaavsKokYvALqDBxeCQBQ/n4be9RjkWOQ2BNzxbwgpHGHPFOgQV0QcNKJyvWFcepjgXuX0jkJ1eaKTSXE8fgL1zb9QZ38qCziCBics0L5s17bVhOj8YlJgz8Mo/4+T4FeoGphEXhpOZWtjJCLHa59+SEf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730803131; c=relaxed/simple;
	bh=29FhFDkFux7c/h96556NBBqwKD8Cve/k3oHkN77e/FM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iBLQbfYKliQ9wWp+PAp1FrLRA6HEKNbUoC65/qOp3ZBakC+dxOjH6M6IIoz6r7ZiUK9ta6elEpFoSDEoqscTXjrZaFaPcFD/ZV5LlraAEvJhounQbjdExktEz60kQKZwj3zGlVdFe9WjWoJ4QMU+K1bbhlThr4qfXUGi5byDNZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CImgJkj5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730803128;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=sK/6DimcM6s/4CQKE4lNadkNqe4oszzONtph8blZGq0=;
	b=CImgJkj5BZLuV4onl4hh1FPo6GdomPswPCrL2+3Ag2h/24cOXh5OBwV0AfucxYru3ba44l
	ZU1TtVcdfgsKskeUReVUy+L2tcsQ7jY2UyK+3H+0SxLYtcIixPbGbLJDZhIkwcWFIq0vNr
	3ZtKcrNI/1YZeR/Gwvv1vuRFoB4MseY=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-527-2919mB85NKGfOIKEA8-5HA-1; Tue,
 05 Nov 2024 05:38:45 -0500
X-MC-Unique: 2919mB85NKGfOIKEA8-5HA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 730E019560A5;
	Tue,  5 Nov 2024 10:38:43 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.52])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E60B519560A3;
	Tue,  5 Nov 2024 10:38:36 +0000 (UTC)
Date: Tue, 5 Nov 2024 10:38:33 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v6 14/60] i386/tdx: Support user configurable
 mrconfigid/mrowner/mrownerconfig
Message-ID: <Zyn1qW36aJeIGqbC@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-15-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241105062408.3533704-15-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Nov 05, 2024 at 01:23:22AM -0500, Xiaoyao Li wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Three sha384 hash values, mrconfigid, mrowner and mrownerconfig, of a TD
> can be provided for TDX attestation. Detailed meaning of them can be
> found: https://lore.kernel.org/qemu-devel/31d6dbc1-f453-4cef-ab08-4813f4e0ff92@intel.com/
> 
> Allow user to specify those values via property mrconfigid, mrowner and
> mrownerconfig. They are all in base64 format.
> 
> example
> -object tdx-guest, \
>   mrconfigid=ASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq83v,\
>   mrowner=ASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq83v,\
>   mrownerconfig=ASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq83v
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> Changes in v6:
>  - refine the doc comment of QAPI properties;
> 
> Changes in v5:
>  - refine the description of QAPI properties and add description of
>    default value when not specified;
> 
> Changes in v4:
>  - describe more of there fields in qom.json
>  - free the old value before set new value to avoid memory leak in
>    _setter(); (Daniel)
> 
> Changes in v3:
>  - use base64 encoding instread of hex-string;
> ---
>  qapi/qom.json         | 16 +++++++-
>  target/i386/kvm/tdx.c | 86 +++++++++++++++++++++++++++++++++++++++++++
>  target/i386/kvm/tdx.h |  3 ++
>  3 files changed, 104 insertions(+), 1 deletion(-)

> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 5a9ce2ada89d..887a5324b439 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -13,6 +13,7 @@
>  
>  #include "qemu/osdep.h"
>  #include "qemu/error-report.h"
> +#include "qemu/base64.h"
>  #include "qapi/error.h"
>  #include "qom/object_interfaces.h"
>  
> @@ -222,6 +223,7 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>      X86CPU *x86cpu = X86_CPU(cpu);
>      CPUX86State *env = &x86cpu->env;
>      g_autofree struct kvm_tdx_init_vm *init_vm = NULL;
> +    size_t data_len;
>      int r = 0;
>  
>      QEMU_LOCK_GUARD(&tdx_guest->lock);
> @@ -232,6 +234,37 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>      init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
>                          sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
>  
> +#define SHA384_DIGEST_SIZE  48

Don't define this - as of fairly recently, we now have
QCRYPTO_HASH_DIGEST_LEN_SHA384 in QEMU's "crypto/hash.h"
header.

> +    if (tdx_guest->mrconfigid) {
> +        g_autofree uint8_t *data = qbase64_decode(tdx_guest->mrconfigid,
> +                              strlen(tdx_guest->mrconfigid), &data_len, errp);
> +        if (!data || data_len != SHA384_DIGEST_SIZE) {
> +            error_setg(errp, "TDX: failed to decode mrconfigid");
> +            return -1;
> +        }
> +        memcpy(init_vm->mrconfigid, data, data_len);
> +    }
> +
> +    if (tdx_guest->mrowner) {
> +        g_autofree uint8_t *data = qbase64_decode(tdx_guest->mrowner,
> +                              strlen(tdx_guest->mrowner), &data_len, errp);
> +        if (!data || data_len != SHA384_DIGEST_SIZE) {
> +            error_setg(errp, "TDX: failed to decode mrowner");
> +            return -1;
> +        }
> +        memcpy(init_vm->mrowner, data, data_len);
> +    }
> +
> +    if (tdx_guest->mrownerconfig) {
> +        g_autofree uint8_t *data = qbase64_decode(tdx_guest->mrownerconfig,
> +                            strlen(tdx_guest->mrownerconfig), &data_len, errp);
> +        if (!data || data_len != SHA384_DIGEST_SIZE) {
> +            error_setg(errp, "TDX: failed to decode mrownerconfig");
> +            return -1;
> +        }
> +        memcpy(init_vm->mrownerconfig, data, data_len);
> +    }
> +
>      r = setup_td_guest_attributes(x86cpu, errp);
>      if (r) {
>          return r;

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


