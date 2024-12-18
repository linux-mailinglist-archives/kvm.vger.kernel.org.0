Return-Path: <kvm+bounces-34066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 237119F6ADF
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 17:18:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB3F3189765A
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 16:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9E9A1F5437;
	Wed, 18 Dec 2024 16:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Aqo7Ypfg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EE11C2304
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 16:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734538678; cv=none; b=Az71xOmtYjZBgWIKs60ByCrWGaFIb++LcA8JZfW6YG56hFIdJGOacTQqK8sMpFwlW/9hk0eV2qsX+OrFuRHvTPRVJN1R1xXz6NgR+/gbo3RvpETNJoJp/SsuONDlHsjxMWKYafmkHHaNY54S3hJrG8doQdzzAkf248AUc5hQ+RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734538678; c=relaxed/simple;
	bh=yGUeewr+JbeZGae9OO4MZP2/F1u62YbamO5mcG80/po=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iKatJFqueSLXtIbceiidswvDFRpJosjA44R9UKH9cMEiL21cUyu+fe6NkY+UYtfxZWelRrV98IE3VWGhH8lxZEFgnGmuiDUmuV1x5smrb4dw4jmfSmChgXf9PY19x+cigJJD9T9rh/f725QAVMyXWd6vFJ0K+kJ21LJl7foWyt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Aqo7Ypfg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734538675;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gYKjrkJRWjzHKmM/pQpwasuiCDmRdGn9UbHhpJk1ymM=;
	b=Aqo7YpfgwL3Lh6lVPX4l8gTRYET93sShT9OuhqHtvukxF9pSAdy/+rE2P6HUdMT3J/KOf7
	2IcoPK3X5l/+2OJ8ph/fij4Ee6vr4Ym30GJAh8+UeHOOnN5e8GI2XUb96TEfa+2aypZGmT
	YYjkm1j4IdV9f7u7/VQGG7g0V/xXm9k=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-584-lrRuWrC_OG2bWpCNTzju7g-1; Wed,
 18 Dec 2024 11:17:52 -0500
X-MC-Unique: lrRuWrC_OG2bWpCNTzju7g-1
X-Mimecast-MFC-AGG-ID: lrRuWrC_OG2bWpCNTzju7g
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 312AF1956065;
	Wed, 18 Dec 2024 16:17:50 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.61])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3940B300F9B5;
	Wed, 18 Dec 2024 16:17:41 +0000 (UTC)
Date: Wed, 18 Dec 2024 16:17:39 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Eric Farman <farman@linux.ibm.com>,
	kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	qemu-ppc@nongnu.org, Zhao Liu <zhao1.liu@intel.com>,
	qemu-s390x@nongnu.org, Yanan Wang <wangyanan55@huawei.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 2/2] target/i386/sev: Reduce system specific declarations
Message-ID: <Z2L1o7xesp5EcRuW@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241218155913.72288-1-philmd@linaro.org>
 <20241218155913.72288-3-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241218155913.72288-3-philmd@linaro.org>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Wed, Dec 18, 2024 at 04:59:13PM +0100, Philippe Mathieu-Daudé wrote:
> "system/confidential-guest-support.h" is not needed,
> remove it. Reorder #ifdef'ry to reduce declarations
> exposed on user emulation.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  target/i386/sev.h  | 29 ++++++++++++++++-------------
>  hw/i386/pc_sysfw.c |  2 +-
>  2 files changed, 17 insertions(+), 14 deletions(-)
> 
> diff --git a/target/i386/sev.h b/target/i386/sev.h
> index 2664c0b1b6c..373669eaace 100644
> --- a/target/i386/sev.h
> +++ b/target/i386/sev.h
> @@ -18,7 +18,17 @@
>  #include CONFIG_DEVICES /* CONFIG_SEV */
>  #endif
>  
> -#include "system/confidential-guest-support.h"
> +#if !defined(CONFIG_SEV) || defined(CONFIG_USER_ONLY)
> +#define sev_enabled() 0
> +#define sev_es_enabled() 0
> +#define sev_snp_enabled() 0
> +#else
> +bool sev_enabled(void);
> +bool sev_es_enabled(void);
> +bool sev_snp_enabled(void);
> +#endif
> +
> +#if !defined(CONFIG_USER_ONLY)

I'm surprised any of this header file is relevant to
user mode. If something is mistakely calling sev_ functions
from user mode compiled code, I'd be inclined to fix the
caller such that its #include ".../sev.h" can be wrapped
by !CONFIG_USER_ONLY

>  
>  #define TYPE_SEV_COMMON "sev-common"
>  #define TYPE_SEV_GUEST "sev-guest"
> @@ -45,18 +55,6 @@ typedef struct SevKernelLoaderContext {
>      size_t cmdline_size;
>  } SevKernelLoaderContext;
>  
> -#ifdef CONFIG_SEV
> -bool sev_enabled(void);
> -bool sev_es_enabled(void);
> -bool sev_snp_enabled(void);
> -#else
> -#define sev_enabled() 0
> -#define sev_es_enabled() 0
> -#define sev_snp_enabled() 0
> -#endif
> -
> -uint32_t sev_get_cbit_position(void);
> -uint32_t sev_get_reduced_phys_bits(void);
>  bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp);
>  
>  int sev_encrypt_flash(hwaddr gpa, uint8_t *ptr, uint64_t len, Error **errp);
> @@ -68,4 +66,9 @@ void sev_es_set_reset_vector(CPUState *cpu);
>  
>  void pc_system_parse_sev_metadata(uint8_t *flash_ptr, size_t flash_size);
>  
> +#endif /* !CONFIG_USER_ONLY */
> +
> +uint32_t sev_get_cbit_position(void);
> +uint32_t sev_get_reduced_phys_bits(void);
> +
>  #endif
> diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
> index da7ed121292..1eeb58ab37f 100644
> --- a/hw/i386/pc_sysfw.c
> +++ b/hw/i386/pc_sysfw.c
> @@ -36,7 +36,7 @@
>  #include "hw/qdev-properties.h"
>  #include "hw/block/flash.h"
>  #include "system/kvm.h"
> -#include "sev.h"
> +#include "target/i386/sev.h"
>  
>  #define FLASH_SECTOR_SIZE 4096
>  
> -- 
> 2.45.2
> 
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


