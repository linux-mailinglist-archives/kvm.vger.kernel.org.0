Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7784F4DDFB8
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 18:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239554AbiCRRUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 13:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235952AbiCRRUq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 13:20:46 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB9D14B85A
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 10:19:27 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id s8so9963059pfk.12
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 10:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lzsvd7vgCFzNYVBiGWplExgWAHNobHxZzTboIKXc/JM=;
        b=irvMD+AAm6EZE0bGA8/vkh/YM9K5q5/mhTYeLKN0BzU1c0guDLLvLfhfRMgN+FNxwa
         djyf/3EEGIemzb7FdQfd4kLDwKSyuCS0sFNI9k8syhhfHhBk4iuo5VFsQPM7z/Fd+zf5
         aJtlQz63LsWcP9is20MviJ1htSNsRWS5dSxplKyoOYF2SA735Bej0uQVZSp4AcqRDm9P
         hVvqHix+xiBguD4a2zSdNeBb/O54z2h73wo6NP/M66Ycc4WFHY5835GlQuWLyJQ2zksq
         GS3p9C1v7sqrXjEM4dwH2GjDWi8mQ1F2YejFcetDWvWCGRIlLhwoLbQHSQ6O7PzlztCT
         uDtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lzsvd7vgCFzNYVBiGWplExgWAHNobHxZzTboIKXc/JM=;
        b=qLlqaq19pt1N6biW1Xmca4pA2lfLgE/ehrYoFncW7svguXtVcQeWsKcbGVuNT4CNVL
         w33yJxyD24KSLQd1A+JzVs8+EMu4ueEKRkBaBZK6aws4qMhwQ0DuG0soRcS6yHg8I4S6
         l46itGUdhSCzhEb7cxbAct0019QsCa1AZs3gA3qvGbqIwwpGgb4NifYCLTW75ZJbWlOz
         TuUJgJqiY0/lZZkccxJJsYX8D3DWjLL2OcLJXTG8+9zBtVwK3nmHi9HKBVWyvs4RJpFA
         FqF3T0LcZfOqftOpK2gcV5yhogaYjVn8IA2KTIGQx97H8lP/H+5Y/ZTMaGMUWSwpL1Gc
         HzbA==
X-Gm-Message-State: AOAM533537jjRWpI3qbEfwp6UEyzajKlrypZbohQmC4j5Nr0x+CFgK4Z
        htzzT8oqINDmhPKH7EBiVec=
X-Google-Smtp-Source: ABdhPJzNcF3n+0tDpc7uLaqC2sLoM/SqX1zpNhuDj2W2m4pPPlWWp2K98llsclEWCQkOFShBKxEPBg==
X-Received: by 2002:a65:6b95:0:b0:380:85c1:98e3 with SMTP id d21-20020a656b95000000b0038085c198e3mr8711399pgw.511.1647623966432;
        Fri, 18 Mar 2022 10:19:26 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id j67-20020a636e46000000b003740d689ca9sm7929796pgc.62.2022.03.18.10.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 10:19:25 -0700 (PDT)
Date:   Fri, 18 Mar 2022 10:19:24 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Philippe Mathieu-Daud??? <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Daniel P. Berrang???" <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eric Blake <eblake@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, Connor Kuehl <ckuehl@redhat.com>,
        seanjc@google.com, qemu-devel@nongnu.org, erdemaktas@google.com,
        isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH v3 18/36] i386/tdvf: Introduce function to parse TDVF
 metadata
Message-ID: <20220318171924.GA4050087@ls.amr.corp.intel.com>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-19-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317135913.2166202-19-xiaoyao.li@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 17, 2022 at 09:58:55PM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> diff --git a/hw/i386/tdvf.c b/hw/i386/tdvf.c
> new file mode 100644
> index 000000000000..02da1d2c12dd
> --- /dev/null
> +++ b/hw/i386/tdvf.c
> @@ -0,0 +1,196 @@
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
> +
> +#include "qemu/osdep.h"
> +#include "hw/i386/pc.h"
> +#include "hw/i386/tdvf.h"
> +#include "sysemu/kvm.h"
> +
> +#define TDX_METADATA_GUID "e47a6535-984a-4798-865e-4685a7bf8ec2"
> +#define TDX_METADATA_VERSION    1
> +#define TDVF_SIGNATURE_LE32     0x46564454 /* TDVF as little endian */

_LE32 doesn't make sense.  qemu doesn't provide macro version for byteswap.
Let's convert at the usage point.


> +
> +typedef struct {
> +    uint32_t DataOffset;
> +    uint32_t RawDataSize;
> +    uint64_t MemoryAddress;
> +    uint64_t MemoryDataSize;
> +    uint32_t Type;
> +    uint32_t Attributes;
> +} TdvfSectionEntry;
> +
> +typedef struct {
> +    uint32_t Signature;
> +    uint32_t Length;
> +    uint32_t Version;
> +    uint32_t NumberOfSectionEntries;
> +    TdvfSectionEntry SectionEntries[];
> +} TdvfMetadata;
> +
> +struct tdx_metadata_offset {
> +    uint32_t offset;
> +};
> +
> +static TdvfMetadata *tdvf_get_metadata(void *flash_ptr, int size)
> +{
> +    TdvfMetadata *metadata;
> +    uint32_t offset = 0;
> +    uint8_t *data;
> +
> +    if ((uint32_t) size != size) {
> +        return NULL;
> +    }
> +
> +    if (pc_system_ovmf_table_find(TDX_METADATA_GUID, &data, NULL)) {
> +        offset = size - le32_to_cpu(((struct tdx_metadata_offset *)data)->offset);
> +
> +        if (offset + sizeof(*metadata) > size) {
> +            return NULL;
> +        }
> +    } else {
> +        error_report("Cannot find TDX_METADATA_GUID\n");
> +        return NULL;
> +    }
> +
> +    metadata = flash_ptr + offset;
> +
> +    /* Finally, verify the signature to determine if this is a TDVF image. */
> +   if (metadata->Signature != TDVF_SIGNATURE_LE32) {


metadata->Signature = le32_to_cpu(metadata->Signature);
metadata->Signature != TDVF_SIGNATURE for consistency.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
