Return-Path: <kvm+bounces-30721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DEDB9BCAC9
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 11:47:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 313FC1C2242B
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 10:47:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6EFB1D2B10;
	Tue,  5 Nov 2024 10:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bh7gQ7At"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB85C18DF89
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 10:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730803613; cv=none; b=JYSVn/6Od/dzJ0gBELnKMxqsGXcl82tqzXVoh1FlcOJjeD4Ix0y0ocDKXlAXsl6YXc/F0TJk91fyH2fhhsbobUw0aDVz6gvIHBa3TVj8mkn7UJmuGbiVqnjnbL1Lgxp+2yyvF1qmukz62HAfvVQtCaQAur0M3bVyhrHWRr2wdwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730803613; c=relaxed/simple;
	bh=yLTXfIHizRD39hNPZtozNGZYxJLTeEUcFKgHXap2gMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ovnowQXeuR350o1HuuYokYflOaFuV1i1QYFLXYiQFK4x3GB4KJukQ+bt9Sy6svdQX9umW2SiHRmZCLvSE+H6caBlUzmyucfYLvmRvpYJJfoxD+fXsJWIsuU2AL84fdWlPipmdFLDSy4KWxmaKZtCW+wySV5IhQ4vnmQMdeZ2Ea4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bh7gQ7At; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730803609;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=/WEwL9TkWSySnRfQq6doKrURf9dgdkbqXzEf7AEuYg4=;
	b=bh7gQ7AtfrvsVe7BHEuKglw2q9vYmiEuLro3fHUQzSg4UfdozWF5s+wQg2KY3lf5lm5uyT
	dibpPtxikb9scuZw7ebcLXbzepprCkKzLCH2Ej9N08PABWEKFwnw/yBQQUIUdcERkF5/pX
	vnZE6gNXo4jBl8nDU0FPjZLAzHyYLx8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-367-54uIS3cwMyOIjc-eRyHuIQ-1; Tue,
 05 Nov 2024 05:46:46 -0500
X-MC-Unique: 54uIS3cwMyOIjc-eRyHuIQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D0861956048;
	Tue,  5 Nov 2024 10:46:44 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.52])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7633E19560A2;
	Tue,  5 Nov 2024 10:46:38 +0000 (UTC)
Date: Tue, 5 Nov 2024 10:46:34 +0000
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
Subject: Re: [PATCH v6 24/60] i386/tdx: Setup the TD HOB list
Message-ID: <Zyn3irziLxvAzNCU@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-25-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241105062408.3533704-25-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, Nov 05, 2024 at 01:23:32AM -0500, Xiaoyao Li wrote:
> The TD HOB list is used to pass the information from VMM to TDVF. The TD
> HOB must include PHIT HOB and Resource Descriptor HOB. More details can
> be found in TDVF specification and PI specification.
> 
> Build the TD HOB in TDX's machine_init_done callback.
> 
> Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> 
> ---
> Changes in v1:
>   - drop the code of adding mmio resources since OVMF prepares all the
>     MMIO hob itself.
> ---
>  hw/i386/meson.build   |   2 +-
>  hw/i386/tdvf-hob.c    | 147 ++++++++++++++++++++++++++++++++++++++++++
>  hw/i386/tdvf-hob.h    |  24 +++++++
>  target/i386/kvm/tdx.c |  16 +++++
>  4 files changed, 188 insertions(+), 1 deletion(-)
>  create mode 100644 hw/i386/tdvf-hob.c
>  create mode 100644 hw/i386/tdvf-hob.h
> 
> diff --git a/hw/i386/meson.build b/hw/i386/meson.build
> index 3bc1da2b6eb4..7896f348cff8 100644
> --- a/hw/i386/meson.build
> +++ b/hw/i386/meson.build
> @@ -32,7 +32,7 @@ i386_ss.add(when: 'CONFIG_PC', if_true: files(
>    'port92.c'))
>  i386_ss.add(when: 'CONFIG_X86_FW_OVMF', if_true: files('pc_sysfw_ovmf.c'),
>                                          if_false: files('pc_sysfw_ovmf-stubs.c'))
> -i386_ss.add(when: 'CONFIG_TDX', if_true: files('tdvf.c'))
> +i386_ss.add(when: 'CONFIG_TDX', if_true: files('tdvf.c', 'tdvf-hob.c'))
>  
>  subdir('kvm')
>  subdir('xen')
> diff --git a/hw/i386/tdvf-hob.c b/hw/i386/tdvf-hob.c
> new file mode 100644
> index 000000000000..e00de256ea8c
> --- /dev/null
> +++ b/hw/i386/tdvf-hob.c
> @@ -0,0 +1,147 @@
> +/*
> + * SPDX-License-Identifier: GPL-2.0-or-later
> +
> + * Copyright (c) 2020 Intel Corporation
> + * Author: Isaku Yamahata <isaku.yamahata at gmail.com>
> + *                        <isaku.yamahata at intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> +
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> +
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + */

Remove the boilerplate in favour of the SPDX tag.


> diff --git a/hw/i386/tdvf-hob.h b/hw/i386/tdvf-hob.h
> new file mode 100644
> index 000000000000..1b737e946a8d
> --- /dev/null
> +++ b/hw/i386/tdvf-hob.h
> @@ -0,0 +1,24 @@
> +#ifndef HW_I386_TD_HOB_H
> +#define HW_I386_TD_HOB_H

Add the SPDX tag to this file


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


