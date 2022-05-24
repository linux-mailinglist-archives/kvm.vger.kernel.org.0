Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66DF3532493
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 09:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbiEXH6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 03:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235689AbiEXH4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 03:56:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F43B24F22
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 00:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653378994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o/4B6aNftnpN9z+S7/8G8n2JRdUMsTbUHlH2bCDBd1Y=;
        b=JKpqoYIfLjdVSGdf5VTTiwwA//DWheZ75pG37Zdekpp9yFTy3O2BBoqe+EzYUkMlP5FbDd
        nkBuopCdNpCfiW9LLXKbky1Dy5B2cy9HZYu2dtJaIalwP5RrkEsjzo4qFW6+CMi6Q8OL0U
        WCUoPMsjqJrUcIIEgmQ+90SIrZScfdg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-f9P5wkjKOFuLZFttQdjeDg-1; Tue, 24 May 2022 03:56:29 -0400
X-MC-Unique: f9P5wkjKOFuLZFttQdjeDg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5D61380673C;
        Tue, 24 May 2022 07:56:28 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C5577AD8;
        Tue, 24 May 2022 07:56:28 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id EAE8D1800393; Tue, 24 May 2022 09:56:26 +0200 (CEST)
Date:   Tue, 24 May 2022 09:56:26 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com,
        Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com
Subject: Re: [RFC PATCH v4 23/36] i386/tdx: Setup the TD HOB list
Message-ID: <20220524075626.l7rgyjz3jhojhds2@sirius.home.kraxel.org>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-24-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512031803.3315890-24-xiaoyao.li@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> +static void tdvf_hob_add_mmio_resources(TdvfHob *hob)
> +{
> +    MachineState *ms = MACHINE(qdev_get_machine());
> +    X86MachineState *x86ms = X86_MACHINE(ms);
> +    PCIHostState *pci_host;
> +    uint64_t start, end;
> +    uint64_t mcfg_base, mcfg_size;
> +    Object *host;
> +
> +    /* Effectively PCI hole + other MMIO devices. */
> +    tdvf_hob_add_mmio_resource(hob, x86ms->below_4g_mem_size,
> +                               APIC_DEFAULT_ADDRESS);
> +
> +    /* Stolen from acpi_get_i386_pci_host(), there's gotta be an easier way. */
> +    pci_host = OBJECT_CHECK(PCIHostState,
> +                            object_resolve_path("/machine/i440fx", NULL),
> +                            TYPE_PCI_HOST_BRIDGE);
> +    if (!pci_host) {
> +        pci_host = OBJECT_CHECK(PCIHostState,
> +                                object_resolve_path("/machine/q35", NULL),
> +                                TYPE_PCI_HOST_BRIDGE);
> +    }
> +    g_assert(pci_host);
> +
> +    host = OBJECT(pci_host);
> +
> +    /* PCI hole above 4gb. */
> +    start = object_property_get_uint(host, PCI_HOST_PROP_PCI_HOLE64_START,
> +                                     NULL);
> +    end = object_property_get_uint(host, PCI_HOST_PROP_PCI_HOLE64_END, NULL);
> +    tdvf_hob_add_mmio_resource(hob, start, end);
> +
> +    /* MMCFG region */
> +    mcfg_base = object_property_get_uint(host, PCIE_HOST_MCFG_BASE, NULL);
> +    mcfg_size = object_property_get_uint(host, PCIE_HOST_MCFG_SIZE, NULL);
> +    if (mcfg_base && mcfg_base != PCIE_BASE_ADDR_UNMAPPED && mcfg_size) {
> +        tdvf_hob_add_mmio_resource(hob, mcfg_base, mcfg_base + mcfg_size);
> +    }
> +}

That looks suspicious.  I think you need none of this, except for the
first tdvf_hob_add_mmio_resource() call which adds the below-4G hole.

It is the firmware which places the mmio resources into the address
space by programming the pci config space of the devices.  qemu doesn't
dictate any of this, and I doubt you get any useful values here.  The
core runs before the firmware had the chance to do any setup here ...

> new file mode 100644
> index 000000000000..b15aba796156
> --- /dev/null
> +++ b/hw/i386/uefi.h

Separate patch please.

Also this should probably go somewhere below
include/standard-headers/

take care,
  Gerd

