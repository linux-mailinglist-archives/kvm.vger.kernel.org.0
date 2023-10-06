Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6877BB437
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 11:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbjJFJaI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 05:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbjJFJaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 05:30:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8A69E
        for <kvm@vger.kernel.org>; Fri,  6 Oct 2023 02:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696584563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vvA1lHKzQGxfWAWbwTOmAmPDMRdiZLc1hXad/9hlzkk=;
        b=V0JTpa279BDJYt+o54y9xpgZQ+5hkB0c6jPRFxvq94QJ7LiKE+mXeBkzzyik1O1q4q+2j3
        xm3YUxcixSfMggD1FiDFI4EfPeKInt4ZcpAltSze3i4BtNMuSe9rjoMWi9wLZDs8lzkfUJ
        6nIhLfFy6tA6NTrJZZN3qEZVMkd3SRU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-NVOzkToMNKWzoElww2VqTQ-1; Fri, 06 Oct 2023 05:29:22 -0400
X-MC-Unique: NVOzkToMNKWzoElww2VqTQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4065d52a83aso12640015e9.1
        for <kvm@vger.kernel.org>; Fri, 06 Oct 2023 02:29:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696584561; x=1697189361;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vvA1lHKzQGxfWAWbwTOmAmPDMRdiZLc1hXad/9hlzkk=;
        b=Aa0U6Rd04fNPn52h4SgZ7DMIFaoaCh5GdMfBuJJqVJEI5Wf4SRtyVA02ffKzTJf1N0
         htHpGEktFTrl+K5cGuQzLA/Xvx0WtV/5LdbVdooUwPPg1aDlq/I1rttkO8FYR8THH8m2
         +Z58irIjDO8YzSPritzmivanV+We8LfaIGQsw4yorduy/WPXCsH6+by/LPWJ5rcJij2a
         yM3BtRWHTIHL6o1haE61eAjMNQ9Ym2O/Vejw5DuGPYqn0FS8BWFEea9l2rCTGZsJVi6y
         wTvwYB6hNUqEd3M/vSUBUDRrFlQ6RF8WcjCJaxGHQhJxPiO4ATrstc5ccK9NWaT0U53H
         jqog==
X-Gm-Message-State: AOJu0Yz+pbtcNUUT8FFcYPwhHnGxVYOb1iyMhqI71aQaOd4Zo381lNAu
        ho8ssQpRfrjbf05wr0x+1n49jpRGMKBrEMckamlsWNNGKmKrRbph01ubxcAtEfjF6tZN7qhBMnJ
        m7YlZ2XOFbGnG
X-Received: by 2002:a05:600c:2219:b0:405:1c19:b747 with SMTP id z25-20020a05600c221900b004051c19b747mr6694346wml.15.1696584560736;
        Fri, 06 Oct 2023 02:29:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHupXihKRAP5qBZjCaoRVmVkV+yniUqhncS+SA6+IhjXmDvvug/kRNA1LTItXRR2oraHZDzDg==
X-Received: by 2002:a05:600c:2219:b0:405:1c19:b747 with SMTP id z25-20020a05600c221900b004051c19b747mr6694318wml.15.1696584560060;
        Fri, 06 Oct 2023 02:29:20 -0700 (PDT)
Received: from ?IPV6:2003:cb:c715:ee00:4e24:cf8e:3de0:8819? (p200300cbc715ee004e24cf8e3de08819.dip0.t-ipconnect.de. [2003:cb:c715:ee00:4e24:cf8e:3de0:8819])
        by smtp.gmail.com with ESMTPSA id 4-20020a05600c248400b004060f0a0fd5sm3316313wms.13.2023.10.06.02.29.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Oct 2023 02:29:19 -0700 (PDT)
Message-ID: <edf56572-1e7a-be30-d331-635493785d8c@redhat.com>
Date:   Fri, 6 Oct 2023 11:29:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Michal Privoznik <mprivozn@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        kvm@vger.kernel.org
References: <20230926185738.277351-1-david@redhat.com>
 <20231003093802-mutt-send-email-mst@kernel.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v4 00/18] virtio-mem: Expose device memory through
 multiple memslots
In-Reply-To: <20231003093802-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03.10.23 15:39, Michael S. Tsirkin wrote:
> On Tue, Sep 26, 2023 at 08:57:20PM +0200, David Hildenbrand wrote:
>> Quoting from patch #16:
>>
>>      Having large virtio-mem devices that only expose little memory to a VM
>>      is currently a problem: we map the whole sparse memory region into the
>>      guest using a single memslot, resulting in one gigantic memslot in KVM.
>>      KVM allocates metadata for the whole memslot, which can result in quite
>>      some memory waste.
>>
>>      Assuming we have a 1 TiB virtio-mem device and only expose little (e.g.,
>>      1 GiB) memory, we would create a single 1 TiB memslot and KVM has to
>>      allocate metadata for that 1 TiB memslot: on x86, this implies allocating
>>      a significant amount of memory for metadata:
>>
>>      (1) RMAP: 8 bytes per 4 KiB, 8 bytes per 2 MiB, 8 bytes per 1 GiB
>>          -> For 1 TiB: 2147483648 + 4194304 + 8192 = ~ 2 GiB (0.2 %)
>>
>>          With the TDP MMU (cat /sys/module/kvm/parameters/tdp_mmu) this gets
>>          allocated lazily when required for nested VMs
>>      (2) gfn_track: 2 bytes per 4 KiB
>>          -> For 1 TiB: 536870912 = ~512 MiB (0.05 %)
>>      (3) lpage_info: 4 bytes per 2 MiB, 4 bytes per 1 GiB
>>          -> For 1 TiB: 2097152 + 4096 = ~2 MiB (0.0002 %)
>>      (4) 2x dirty bitmaps for tracking: 2x 1 bit per 4 KiB page
>>          -> For 1 TiB: 536870912 = 64 MiB (0.006 %)
>>
>>      So we primarily care about (1) and (2). The bad thing is, that the
>>      memory consumption doubles once SMM is enabled, because we create the
>>      memslot once for !SMM and once for SMM.
>>
>>      Having a 1 TiB memslot without the TDP MMU consumes around:
>>      * With SMM: 5 GiB
>>      * Without SMM: 2.5 GiB
>>      Having a 1 TiB memslot with the TDP MMU consumes around:
>>      * With SMM: 1 GiB
>>      * Without SMM: 512 MiB
>>
>>      ... and that's really something we want to optimize, to be able to just
>>      start a VM with small boot memory (e.g., 4 GiB) and a virtio-mem device
>>      that can grow very large (e.g., 1 TiB).
>>
>>      Consequently, using multiple memslots and only mapping the memslots we
>>      really need can significantly reduce memory waste and speed up
>>      memslot-related operations. Let's expose the sparse RAM memory region using
>>      multiple memslots, mapping only the memslots we currently need into our
>>      device memory region container.
>>
>> The hyper-v balloon driver has similar demands [1].
>>
>> For virtio-mem, this has to be turned manually on ("dynamic-memslots=on"),
>> due to the interaction with vhost (below).
>>
>> If we have less than 509 memslots available, we always default to a single
>> memslot. Otherwise, we automatically decide how many memslots to use
>> based on a simple heuristic (see patch #12), and try not to use more than
>> 256 memslots across all memory devices: our historical DIMM limit.
>>
>> As soon as any memory devices automatically decided on using more than
>> one memslot, vhost devices that support less than 509 memslots (e.g.,
>> currently most vhost-user devices like with virtiofsd) can no longer be
>> plugged as a precaution.
>>
>> Quoting from patch #12:
>>
>>      Plugging vhost devices with less than 509 memslots available while we
>>      have memory devices plugged that consume multiple memslots due to
>>      automatic decisions can be problematic. Most configurations might just fail
>>      due to "limit < used + reserved", however, it can also happen that these
>>      memory devices would suddenly consume memslots that would actually be
>>      required by other memslot consumers (boot, PCI BARs) later. Note that this
>>      has always been sketchy with vhost devices that support only a small number
>>      of memslots; but we don't want to make it any worse.So let's keep it simple
>>      and simply reject plugging such vhost devices in such a configuration.
>>
>>      Eventually, all vhost devices that want to be fully compatible with such
>>      memory devices should support a decent number of memslots (>= 509).
>>
>>
>> The recommendation is to plug such vhost devices before the virtio-mem
>> decides, or to not set "dynamic-memslots=on". As soon as these devices
>> support a reasonable number of memslots (>= 509), this will start working
>> automatically.
>>
>> I run some tests on x86_64, now also including vfio and migration tests.
>> Seems to work as expected, even when multiple memslots are used.
>>
>>
>> Patch #1 -- #3 are from [2] that were not picked up yet.
>>
>> Patch #4 -- #12 add handling of multiple memslots to memory devices
>>
>> Patch #13 -- #16 add "dynamic-memslots=on" support to virtio-mem
>>
>> Patch #15 -- #16 make sure that virtio-mem memslots can be enabled/disable
>>               atomically
> 
> 
> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
> 
> pls feel free to merge.

Thanks!

Queued to

https://github.com/davidhildenbrand/qemu.git mem-next

-- 
Cheers,

David / dhildenb

