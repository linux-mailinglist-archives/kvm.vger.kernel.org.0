Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48D053B60B
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 11:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbiFBJ1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 05:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbiFBJ1Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 05:27:16 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7A62AB225
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 02:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654162033; x=1685698033;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=N6PpjBk4nvg7Ou/iJNU4Gw3B97lPMNDnS0Fdgi2ltQk=;
  b=g7SObWM+KYOmWTvyp54fn5jYNyftFW61gS/HaeER7rQEqO3re/XeCWsT
   qW9dY8h2jac1zlskynbbyEVdQ4tdripIIGQ7fNBzoIoe0rR3RIQeLV2KV
   SoEE2GsZ1yRhiS3zUqX2RqPuCM0i5ZpdBetOHzcbwSHNyAbWqjp7b14gl
   5FjW66tyRpLehfH4/fCcdVn5DItnJ7P9+g81dH8/Ub18oee4K+UgrHFoK
   Dxkb6eQUqM63I2kNCR93vvk/B2c4RN75NDZMpZ4hez4XnqIwxlYxwvZT7
   doUMRxy+zUrfXGJa/GKyQ54qYE7yTuOD2Do2ss3Z5hYs061np9e7MK4e5
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10365"; a="336549227"
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="336549227"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2022 02:27:13 -0700
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="606752208"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.171.226]) ([10.249.171.226])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2022 02:27:08 -0700
Message-ID: <115674c7-8316-0d13-5dc0-ab680590c59b@intel.com>
Date:   Thu, 2 Jun 2022 17:27:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [RFC PATCH v4 23/36] i386/tdx: Setup the TD HOB list
Content-Language: en-US
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com,
        "Xu, Min M" <min.m.xu@intel.com>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-24-xiaoyao.li@intel.com>
 <20220524075626.l7rgyjz3jhojhds2@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220524075626.l7rgyjz3jhojhds2@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/24/2022 3:56 PM, Gerd Hoffmann wrote:
>    Hi,
> 
>> +static void tdvf_hob_add_mmio_resources(TdvfHob *hob)
>> +{
>> +    MachineState *ms = MACHINE(qdev_get_machine());
>> +    X86MachineState *x86ms = X86_MACHINE(ms);
>> +    PCIHostState *pci_host;
>> +    uint64_t start, end;
>> +    uint64_t mcfg_base, mcfg_size;
>> +    Object *host;
>> +
>> +    /* Effectively PCI hole + other MMIO devices. */
>> +    tdvf_hob_add_mmio_resource(hob, x86ms->below_4g_mem_size,
>> +                               APIC_DEFAULT_ADDRESS);
>> +
>> +    /* Stolen from acpi_get_i386_pci_host(), there's gotta be an easier way. */
>> +    pci_host = OBJECT_CHECK(PCIHostState,
>> +                            object_resolve_path("/machine/i440fx", NULL),
>> +                            TYPE_PCI_HOST_BRIDGE);
>> +    if (!pci_host) {
>> +        pci_host = OBJECT_CHECK(PCIHostState,
>> +                                object_resolve_path("/machine/q35", NULL),
>> +                                TYPE_PCI_HOST_BRIDGE);
>> +    }
>> +    g_assert(pci_host);
>> +
>> +    host = OBJECT(pci_host);
>> +
>> +    /* PCI hole above 4gb. */
>> +    start = object_property_get_uint(host, PCI_HOST_PROP_PCI_HOLE64_START,
>> +                                     NULL);
>> +    end = object_property_get_uint(host, PCI_HOST_PROP_PCI_HOLE64_END, NULL);
>> +    tdvf_hob_add_mmio_resource(hob, start, end);
>> +
>> +    /* MMCFG region */
>> +    mcfg_base = object_property_get_uint(host, PCIE_HOST_MCFG_BASE, NULL);
>> +    mcfg_size = object_property_get_uint(host, PCIE_HOST_MCFG_SIZE, NULL);
>> +    if (mcfg_base && mcfg_base != PCIE_BASE_ADDR_UNMAPPED && mcfg_size) {
>> +        tdvf_hob_add_mmio_resource(hob, mcfg_base, mcfg_base + mcfg_size);
>> +    }
>> +}
> 
> That looks suspicious.  I think you need none of this, except for the
> first tdvf_hob_add_mmio_resource() call which adds the below-4G hole.

for below-4G hole, it seems can be removed as well since I notice that 
OVMF will prepare that mmio hob for TD, in OVMF. Is it correct?

> It is the firmware which places the mmio resources into the address
> space by programming the pci config space of the devices.  qemu doesn't
> dictate any of this, and I doubt you get any useful values here.  The
> core runs before the firmware had the chance to do any setup here ...
> 
>> new file mode 100644
>> index 000000000000..b15aba796156
>> --- /dev/null
>> +++ b/hw/i386/uefi.h
> 
> Separate patch please.
> 
> Also this should probably go somewhere below
> include/standard-headers/

I will do it in next post.

> take care,
>    Gerd
> 

