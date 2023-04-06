Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC236D96C6
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 14:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbjDFMIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 08:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjDFMIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 08:08:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5739FE42
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 05:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680782884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D6+G/+qMHHfZWTlu7nahMnOXMFXydYG4UFMFj92Vprg=;
        b=iVQ4lF37+QzNEOURYHHee5DPtd+j7knGGg/6dSkXAvpIQcdJu96kVz3z0DO2I4F7xxBd4y
        05Y3Sj8pQepGMgphCSvD3yvp4eQUKp4F+/xk+9EojubDYK/lMFqI3p3Xtr7xSw/wff/gQc
        vRcOXWtvMWx8IdXiOEDFzD7LdeSjI1w=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-33-GIMsYSPFPjafovy6-knaLA-1; Thu, 06 Apr 2023 08:08:03 -0400
X-MC-Unique: GIMsYSPFPjafovy6-knaLA-1
Received: by mail-wr1-f70.google.com with SMTP id i19-20020adfa513000000b002dc1cdac53fso4821035wrb.5
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 05:08:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680782881; x=1683374881;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D6+G/+qMHHfZWTlu7nahMnOXMFXydYG4UFMFj92Vprg=;
        b=DYUbjxo3dsqlNaMR/kab68c3whRiEkRrbJhx4POGswdo//gHwWqB16KoCZ4rJKKfnT
         XZ8SBhQUt/GsFwpUMEbWfUnejrJTErkFmMa7NzQYTwGyoZGuWyYSph7Cu5CRV5kzCo22
         8ZN6qL/wG+XU5xtOFsWV/jtuo5LzCKEXLE8Pm8Glj61LH2skmtOr40ng4r9uHL0Vg0P7
         1GOcqj47qLRG+cdsK5jCMEnZ/Tbjgsx3W2ed1COxTDSdp9WwIIxLI8c5QSlnhFU7oUSz
         TONM9c/M2tahRJJSXmFnYa4ojA2NMdpG2yUVBgGUivu0JsL3LzmfxcqWcIx7HRt83tjV
         tCEQ==
X-Gm-Message-State: AAQBX9cK2JVJ1+lvfYElNpa9+g6jelYycF8OdRa4NElUB0ksY6fYDK60
        6CN6MELdbdalFY4In7pgZq5HJdJEZmH1dbauZd6ghIQVFOFpvrBX0sieoWGAfNWyIReAt+sGZW5
        PfsMoDm36jBuq
X-Received: by 2002:a7b:cbc7:0:b0:3eb:2b88:a69a with SMTP id n7-20020a7bcbc7000000b003eb2b88a69amr7095612wmi.14.1680782881078;
        Thu, 06 Apr 2023 05:08:01 -0700 (PDT)
X-Google-Smtp-Source: AKy350b1TCHLBujhOUkgXMFuNaQqaNd6h+rVM3zqYVUUAk79f8ntvaT7XE35w9wr4mvS8DgydZCjZg==
X-Received: by 2002:a7b:cbc7:0:b0:3eb:2b88:a69a with SMTP id n7-20020a7bcbc7000000b003eb2b88a69amr7095597wmi.14.1680782880762;
        Thu, 06 Apr 2023 05:08:00 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id fj12-20020a05600c0c8c00b003ef67848a21sm5130037wmb.13.2023.04.06.05.07.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 05:07:59 -0700 (PDT)
Message-ID: <46f68930-fdfc-db3d-5f28-521ff76e170a@redhat.com>
Date:   Thu, 6 Apr 2023 14:07:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v3 0/6] Expose GPU memory as coherently CPU accessible
Content-Language: en-US
To:     ankita@nvidia.com, jgg@nvidia.com, alex.williamson@redhat.com,
        naoya.horiguchi@nec.com, maz@kernel.org, oliver.upton@linux.dev
Cc:     aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
        targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
        apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
References: <20230405180134.16932-1-ankita@nvidia.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230405180134.16932-1-ankita@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[...]

> This goes along with a qemu series to provides the necessary
> implementation of the Grace Hopper Superchip firmware specification so
> that the guest operating system can see the correct ACPI modeling for
> the coherent GPU device.
> https://github.com/qemu/qemu/compare/master...ankita-nv:qemu:dev-ankit/cohmem-0330
> 
> Applied and tested over v6.3-rc4.
> 

I briefly skimmed over the series, the patch subject prefixes are a bit 
misleading IMHO and could be improved:

> Ankit Agrawal (6):
>    kvm: determine memory type from VMA

this is arch64 specific kvm (kvm/aarch64: ?)

>    vfio/nvgpu: expose GPU device memory as BAR1
>    mm: handle poisoning of pfn without struct pages

mm/memory-failure:

>    mm: Add poison error check in fixup_user_fault() for mapped PFN

That's both MM and core-KVM, maybe worth splitting up.

>    mm: Change ghes code to allow poison of non-struct PFN

That's  drivers/acpi/apei code, not core-mm code.

>    vfio/nvgpu: register device memory for poison handling

-- 
Thanks,

David / dhildenb

