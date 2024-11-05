Return-Path: <kvm+bounces-30720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A47A9BCAC1
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 11:46:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E5E45B226FC
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 10:45:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9D381CB9F6;
	Tue,  5 Nov 2024 10:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NN3q0GqZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FFB1D174E
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 10:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730803553; cv=none; b=p6PFYKJDoTkShNZTkVTMlESnwDITrzJYOZfP7KYe4FRl2vBPLzjAGtu8v15GQeAYZPkbF//hkI4hiZnOlK2JFvZcEqEd2nvSwM0f99M7nyAE09phG+0qgKZDAxgVAeV9vVX8DG4Rjpc0AvEd35Z5WRvAoB9t/xMkWCgxzRNnnG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730803553; c=relaxed/simple;
	bh=oYVTDhrXx4ROXIzFc3BsfFU1QfGcuaeSETewCVEnDVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dNZIaCfQB5K28427n3koomKYl4j33Bh3oHidABhddgbnu6ufT9MW5NN3cmhnSeGwbKIZVpUmBuGHiQ1aboUn4m0Tx+sdAmhdZ4VikVzjVbBCGvo2/yDoqiASynMhMycA7BN5Q9dtNe2Q56Mmn6xljmj5+EAQS4i8KeyrS4NbSpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NN3q0GqZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730803550;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=a4sSjMu6dy5LcbB+3OMviQ9WUC614rkcnLLhl6yR5pw=;
	b=NN3q0GqZA700sUYfXxlqcnmYsy/2g9UtWho0Sw6ufaLqAFzV6qpKdPJ0PUHeg648pCoAvr
	gBR1GNokjXtW0Axj5cMuISAJZy40OFh2/kLP+22V664Exda8TCQwiS2T1DsiqmyC1EJrLg
	kdnd4KObtcQjOFNuIH/5RoQKv5IUOU8=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-537-4i_KOLDhOV-B2tk-F2jYrQ-1; Tue,
 05 Nov 2024 05:45:46 -0500
X-MC-Unique: 4i_KOLDhOV-B2tk-F2jYrQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E8F61955EE8;
	Tue,  5 Nov 2024 10:45:44 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.52])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E1C53000198;
	Tue,  5 Nov 2024 10:45:38 +0000 (UTC)
Date: Tue, 5 Nov 2024 10:45:34 +0000
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
Subject: Re: [PATCH v6 23/60] headers: Add definitions from UEFI spec for
 volumes, resources, etc...
Message-ID: <Zyn3TsMTINMpg5zF@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-24-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241105062408.3533704-24-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Nov 05, 2024 at 01:23:31AM -0500, Xiaoyao Li wrote:
> Add UEFI definitions for literals, enums, structs, GUIDs, etc... that
> will be used by TDX to build the UEFI Hand-Off Block (HOB) that is passed
> to the Trusted Domain Virtual Firmware (TDVF).
> 
> All values come from the UEFI specification [1], PI spec [2] and TDVF
> design guide[3].
> 
> [1] UEFI Specification v2.1.0 https://uefi.org/sites/default/files/resources/UEFI_Spec_2_10_Aug29.pdf
> [2] UEFI PI spec v1.8 https://uefi.org/sites/default/files/resources/UEFI_PI_Spec_1_8_March3.pdf
> [3] https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-virtual-firmware-design-guide-rev-1.pdf
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  include/standard-headers/uefi/uefi.h | 198 +++++++++++++++++++++++++++
>  1 file changed, 198 insertions(+)
>  create mode 100644 include/standard-headers/uefi/uefi.h
> 
> diff --git a/include/standard-headers/uefi/uefi.h b/include/standard-headers/uefi/uefi.h
> new file mode 100644
> index 000000000000..b15aba796156
> --- /dev/null
> +++ b/include/standard-headers/uefi/uefi.h
> @@ -0,0 +1,198 @@
> +/*
> + * Copyright (C) 2020 Intel Corporation
> + *
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
> + *
> + */

Remove the boilerplate text in favour of adding a SPDX tag.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


