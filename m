Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A933F8720
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 14:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242512AbhHZMSg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 08:18:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24064 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242404AbhHZMSf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 08:18:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629980268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H9SPrSZkzKsa6FIEWU7jpm6w2xfSbI6PkE7tQuZ3c50=;
        b=BEyhdgbjBDnJnv0wuZPutmRISETbAGbhGSKJfztkBf7Onu2YG0vAi2m7NOoQIt7w/A2mpW
        BChjN0ucGY4skWgQGc4Z/6eLoDeFN5tN7MLp8aINEje329RQnvW36HqWyv6ONgYDlsTKEb
        gNNtzRRvPJebSfVtdIntOzfjHiBq41o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-XRJYofoZNOi8ffPwTdxX2w-1; Thu, 26 Aug 2021 08:17:44 -0400
X-MC-Unique: XRJYofoZNOi8ffPwTdxX2w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F316E87D541;
        Thu, 26 Aug 2021 12:17:42 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B503760877;
        Thu, 26 Aug 2021 12:17:42 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 2E0EB18003AA; Thu, 26 Aug 2021 14:17:41 +0200 (CEST)
Date:   Thu, 26 Aug 2021 14:17:41 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     isaku.yamahata@gmail.com
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v2 24/44] i386/tdx: Add MMIO HOB entries
Message-ID: <20210826121741.cp4lsldhyha2r4pa@sirius.home.kraxel.org>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <3cf3b4e1ccbddd08bb4695930b6ebee9678f9454.1625704981.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cf3b4e1ccbddd08bb4695930b6ebee9678f9454.1625704981.git.isaku.yamahata@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

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

I doubt this works.  These are initialized by the firmware not qemu.

take care,
  Gerd

