Return-Path: <kvm+bounces-30719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13DFC9BCAB4
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 11:43:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37DBD1C22260
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 10:43:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1362E1D2B34;
	Tue,  5 Nov 2024 10:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QO+cY4/Z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8101CEEB9
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 10:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730803388; cv=none; b=K9ZuCLtNmwafggNOzpw5b0REj05UwIgXYGPVUD4i6ijPwvimXelQ7RYJpv4h+ZQegeLRLy/b6sGGXpkDyJ5pvd4kWXuEMwjqsKTLtUtqIwbmi7N2gDQnX7FqVXiq6FUjncXxMwVSSeKgKmAO+iTaOQlmtUiDfyONRac+zgH8Lek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730803388; c=relaxed/simple;
	bh=Uiy9iGfFPZYrwi/ggTElaur50pp0jm064DlFfnneVtg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tYNPbE+GgDWmBLEUxEmWuLwdOZ2dopYrANz1sCp9zs1y7HN65ph9OynWqx7+2BwWhr1+GhkHmYpMuJnued53xByBJu5PxwUKnfY98Qyu5MUfPMivkEhHXSMRKYjsB1EWfYA6Dnnqbtk0RJ2XtSC9Qk5h3sB9uGcA7prvpnTEugE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QO+cY4/Z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730803385;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=fjQMb444NpSo3Nqa82o/omKxuraxwlFuyfDE/0Lkv3c=;
	b=QO+cY4/ZOvcT3WAvlt6wnzRf+DQxG5+8T2SC+G3Hl/aAY4k7kQJ5dyxIHQj5xZw41VwXxw
	okS/nUD0Hb5GWluIgUpAJCnVUaV+Ro3chJcV2TWNn0K/NxUHchwwiBEmGY8jX1R1+O4/lx
	q6BGqME0tgY1ubGKj1XchgEHWBFdedQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-624-RY5z4U_cNgG8cD171WNHxg-1; Tue,
 05 Nov 2024 05:43:00 -0500
X-MC-Unique: RY5z4U_cNgG8cD171WNHxg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F08251956089;
	Tue,  5 Nov 2024 10:42:58 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.52])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D7BE6300018D;
	Tue,  5 Nov 2024 10:42:51 +0000 (UTC)
Date: Tue, 5 Nov 2024 10:42:47 +0000
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
Subject: Re: [PATCH v6 18/60] i386/tdvf: Introduce function to parse TDVF
 metadata
Message-ID: <Zyn2p9wD2SnisXhT@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-19-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241105062408.3533704-19-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Nov 05, 2024 at 01:23:26AM -0500, Xiaoyao Li wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX VM needs to boot with its specialized firmware, Trusted Domain
> Virtual Firmware (TDVF). QEMU needs to parse TDVF and map it in TD
> guest memory prior to running the TDX VM.
> 
> A TDVF Metadata in TDVF image describes the structure of firmware.
> QEMU refers to it to setup memory for TDVF. Introduce function
> tdvf_parse_metadata() to parse the metadata from TDVF image and store
> the info of each TDVF section.
> 
> TDX metadata is located by a TDX metadata offset block, which is a
> GUID-ed structure. The data portion of the GUID structure contains
> only an 4-byte field that is the offset of TDX metadata to the end
> of firmware file.
> 
> Select X86_FW_OVMF when TDX is enable to leverage existing functions
> to parse and search OVMF's GUID-ed structures.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
> Changes in v6:
>  - Drop the the data endianness change for metadata->Length;
> 
> Changes in v1:
>  - rename tdvf_parse_section_entry() to
>    tdvf_parse_and_check_section_entry()
> 
> Changes in RFC v4:
>  - rename TDX_METADATA_GUID to TDX_METADATA_OFFSET_GUID
> ---
>  hw/i386/Kconfig        |   1 +
>  hw/i386/meson.build    |   1 +
>  hw/i386/tdvf.c         | 200 +++++++++++++++++++++++++++++++++++++++++
>  include/hw/i386/tdvf.h |  51 +++++++++++
>  4 files changed, 253 insertions(+)
>  create mode 100644 hw/i386/tdvf.c
>  create mode 100644 include/hw/i386/tdvf.h
> 
> diff --git a/hw/i386/Kconfig b/hw/i386/Kconfig
> index 86bc10377c4f..555a000037bc 100644
> --- a/hw/i386/Kconfig
> +++ b/hw/i386/Kconfig
> @@ -12,6 +12,7 @@ config SGX
>  
>  config TDX
>      bool
> +    select X86_FW_OVMF
>      depends on KVM
>  
>  config PC
> diff --git a/hw/i386/meson.build b/hw/i386/meson.build
> index 10bdfde27c69..3bc1da2b6eb4 100644
> --- a/hw/i386/meson.build
> +++ b/hw/i386/meson.build
> @@ -32,6 +32,7 @@ i386_ss.add(when: 'CONFIG_PC', if_true: files(
>    'port92.c'))
>  i386_ss.add(when: 'CONFIG_X86_FW_OVMF', if_true: files('pc_sysfw_ovmf.c'),
>                                          if_false: files('pc_sysfw_ovmf-stubs.c'))
> +i386_ss.add(when: 'CONFIG_TDX', if_true: files('tdvf.c'))
>  
>  subdir('kvm')
>  subdir('xen')
> diff --git a/hw/i386/tdvf.c b/hw/i386/tdvf.c
> new file mode 100644
> index 000000000000..4afa636bfa0e
> --- /dev/null
> +++ b/hw/i386/tdvf.c
> @@ -0,0 +1,200 @@
> +/*
> + * SPDX-License-Identifier: GPL-2.0-or-later

Since you have this SPDX tag....

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

...you should omit the GPL boilerplate text here, as the new
QEMU standard is to use only SPDX for new files.


> +
> +int tdvf_parse_metadata(TdxFirmware *fw, void *flash_ptr, int size)
> +{
> +    TdvfSectionEntry *sections;

g_autofree TdvfSectionEntry *sections = NULL;

will avoid the duplicated 'g_free' calls later

> +    TdvfMetadata *metadata;
> +    ssize_t entries_size;
> +    int i;
> +
> +    metadata = tdvf_get_metadata(flash_ptr, size);
> +    if (!metadata) {
> +        return -EINVAL;
> +    }
> +
> +    /* load and parse metadata entries */
> +    fw->nr_entries = le32_to_cpu(metadata->NumberOfSectionEntries);
> +    if (fw->nr_entries < 2) {
> +        error_report("Invalid number of fw entries (%u) in TDVF Metadata",
> +                     fw->nr_entries);
> +        return -EINVAL;
> +    }
> +
> +    entries_size = fw->nr_entries * sizeof(TdvfSectionEntry);
> +    if (metadata->Length != sizeof(*metadata) + entries_size) {
> +        error_report("TDVF metadata len (0x%x) mismatch, expected (0x%x)",
> +                     metadata->Length,
> +                     (uint32_t)(sizeof(*metadata) + entries_size));
> +        return -EINVAL;
> +    }
> +
> +    fw->entries = g_new(TdxFirmwareEntry, fw->nr_entries);
> +    sections = g_new(TdvfSectionEntry, fw->nr_entries);
> +
> +    if (!memcpy(sections, (void *)metadata + sizeof(*metadata), entries_size)) {
> +        error_report("Failed to read TDVF section entries");
> +        goto err;
> +    }
> +
> +    for (i = 0; i < fw->nr_entries; i++) {
> +        if (tdvf_parse_and_check_section_entry(&sections[i], &fw->entries[i])) {
> +            goto err;
> +        }
> +    }
> +    g_free(sections);
> +
> +    return 0;
> +
> +err:
> +    g_free(sections);
> +    fw->entries = 0;
> +    g_free(fw->entries);
> +    return -EINVAL;
> +}
> diff --git a/include/hw/i386/tdvf.h b/include/hw/i386/tdvf.h
> new file mode 100644
> index 000000000000..593341eb2e93
> --- /dev/null
> +++ b/include/hw/i386/tdvf.h
> @@ -0,0 +1,51 @@
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

Same note about only using SPDX.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


