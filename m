Return-Path: <kvm+bounces-65758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 985B2CB59F1
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 12:16:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1CF353011EF1
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 11:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE1823081AF;
	Thu, 11 Dec 2025 11:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ejIAMV2x"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F021A23AC
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 11:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765451771; cv=none; b=r4QLKB4UKg/ObbYAEcfnn96Ie30IX1NkmAVzTi0V7w5QXdwCoaqwlBm+V4gjeJMXzuu/hfmSsRgnig4J0pG5fgpmbi4/1XfplHjw+BO43XqzQis3t2ssxabye374B2fK3VrtVMv9dxFPtHG8s9fD/1CkHHLHAZZG/epf5SFwZXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765451771; c=relaxed/simple;
	bh=JDBjZhXx+GXedv5pqLc4BUMGTJ+cbAvfOj45sEse3EE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OYAhUGo74J6L/pJYWklc8v9h12ExVmVhDYeUYnGiC8Rdn7Hb3DwzjvEZkn8P8H2XcX3PZH+i2vJLF7As2sQUuXxrof5i9gjPzwqXwfObfthDQX+YRGBTv36qJZaniV94144MtpoqtboYBEZPnprXduWRVKxXB5T6oBDnmb0w6Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ejIAMV2x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765451768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PGjKevl2KNgfC8tVMV5G7TSSLfkSd+O3wEhDxq6nPVM=;
	b=ejIAMV2xGKx9qasi1gfyFnRo/wDrnqz0NRgahswVdfmFYJBthEKgV2jAso0sWRuSoD1dVh
	cy+5T98slLAc3rNO2gZ3zISffdJnCjWUlJZhYIu3oG88DQbBXDBqaCEFhPEfeKCoHxoinI
	Sm0vvg+e6Ldbbe3sJKVlQ6VeLdJc7mY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-252-QTT-Q78QM-mQL3ppn45-qQ-1; Thu,
 11 Dec 2025 06:16:05 -0500
X-MC-Unique: QTT-Q78QM-mQL3ppn45-qQ-1
X-Mimecast-MFC-AGG-ID: QTT-Q78QM-mQL3ppn45-qQ_1765451763
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1778C1956058;
	Thu, 11 Dec 2025 11:16:03 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.44.32.156])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 003FD1953984;
	Thu, 11 Dec 2025 11:16:01 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id A65161800608; Thu, 11 Dec 2025 12:15:59 +0100 (CET)
Date: Thu, 11 Dec 2025 12:15:59 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
To: Oliver Steffen <osteffen@redhat.com>
Cc: qemu-devel@nongnu.org, 
	Richard Henderson <richard.henderson@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Igor Mammedov <imammedo@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org, Zhao Liu <zhao1.liu@intel.com>, 
	Eduardo Habkost <eduardo@habkost.net>, Marcelo Tosatti <mtosatti@redhat.com>, 
	Luigi Leonardi <leonardi@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	Ani Sinha <anisinha@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH v2 3/3] igvm: Fill MADT IGVM parameter field
Message-ID: <h4256m67shwdq4aouxpqadb2zozhq2f5dfeo74c5jnet5f26kz@a3av5xjfyfow>
References: <20251211103136.1578463-1-osteffen@redhat.com>
 <20251211103136.1578463-4-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211103136.1578463-4-osteffen@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

  Hi,

> +static int qigvm_initialization_madt(QIgvm *ctx,
> +                                     const uint8_t *header_data, Error **errp)
> +{
> +    const IGVM_VHS_PARAMETER *param = (const IGVM_VHS_PARAMETER *)header_data;
> +    QIgvmParameterData *param_entry;
> +
> +    if (ctx->madt == NULL) {
> +        return 0;
> +    }
> +
> +    /* Find the parameter area that should hold the device tree */

cut+paste error in the comment.

> +    QTAILQ_FOREACH(param_entry, &ctx->parameter_data, next)
> +    {
> +        if (param_entry->index == param->parameter_area_index) {

Hmm, that is a pattern repeated a number of times already in the igvm
code.  Should we factor that out into a helper function?

>  static int qigvm_supported_platform_compat_mask(QIgvm *ctx, Error **errp)
>  {
>      int32_t header_count;
> @@ -892,7 +925,7 @@ IgvmHandle qigvm_file_init(char *filename, Error **errp)
>  }
>  
>  int qigvm_process_file(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
> -                       bool onlyVpContext, Error **errp)
> +                       bool onlyVpContext, GArray *madt, Error **errp)

I'd like to see less parameters for this function, not more.

I think sensible options here are:

  (a) store the madt pointer in IgvmCfg, or
  (b) pass MachineState instead of ConfidentialGuestSupport, so
      we can use the MachineState here to generate the madt.

Luigi, any opinion?  I think device tree support will need access to
MachineState too, and I think both madt and dt should take the same
approach here.

Long-term I'd like to also get rid of the onlyVpContext parameter.
That cleanup is something for another patch series though.

take care,
  Gerd


