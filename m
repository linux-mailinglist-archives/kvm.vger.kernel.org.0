Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4BDF5A8DF5
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 08:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbiIAGHV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 02:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232946AbiIAGHU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 02:07:20 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E14111AF9
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 23:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662012438; x=1693548438;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=G6jVS9CeJVnfYB/Itqo+fr2ajX7MAVat38uzOdqvS9o=;
  b=CvektLSjF0qU++noPvzX1RvpkZ5MYyYXnT09zN3es49G+0RKoM5fgi2k
   I9x84zUjOeAR2+japeGyY6pgXE7PnMew8DYFoqpaFCta6iRngM2IEFfQd
   ZxKkl2lRou0fKPAFxi5pWHhQInWurk3R/8cuVKi/iqViwThJ4vf6EfYin
   AJGUIy4IB5hcbXBecLppxHZNJPMMiZIY/lPdZg/K9tTynzo0jAuRu2b+D
   Rf/fqSMjMWiIaddth6O46u/bIzmj2hG+Ib/l5T2/TOXMWYyBMkomxkddy
   BrMbQXA0zuHyA57JLE9zi0jXndAC3zOnYYo6bRpaZQpPrIbRlabTQ54aj
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="294366255"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="294366255"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 23:07:18 -0700
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="754687731"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.28.114]) ([10.255.28.114])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 23:07:15 -0700
Message-ID: <957f0cc5-6887-3861-2b80-69a8c7cdd098@intel.com>
Date:   Thu, 1 Sep 2022 14:07:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.0
Subject: Re: [PATCH 0/2] expose host-phys-bits to guest
Content-Language: en-US
To:     Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sergio Lopez <slp@redhat.com>
References: <20220831125059.170032-1-kraxel@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220831125059.170032-1-kraxel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/31/2022 8:50 PM, Gerd Hoffmann wrote:
> When the guest (firmware specifically) knows how big
> the address space actually is it can be used better.
> 
> Some more background:
>    https://bugzilla.redhat.com/show_bug.cgi?id=2084533

QEMU enables host-phys-bits for "-cpu host/max" in 
host_cpu_max_instance_init();

I think the problem is for all the named CPU model, that they don't have 
phys_bits defined. Thus they all have "cpu->phys-bits == 0", which leads 
to cpu->phys_bits = TCG_PHYS_ADDR_BITS (36 for 32-bits build and 40 for 
64-bits build)

Anyway, IMO, guest including guest firmware, should always consult from 
CPUID leaf 0x80000008 for physical address length. Tt is the duty of 
userspace VMM, here QEMU, to ensure VM's host physical address length 
not exceeding host's. If userspace VMM cannot ensure this, guest is 
likely hitting problem.

> This is a RfC series exposes the information via cpuid.
> 
> take care,
>    Gerd
> 
> Gerd Hoffmann (2):
>    [hack] reserve bit KVM_HINTS_HOST_PHYS_BITS
>    [RfC] expose host-phys-bits to guest
> 
>   include/standard-headers/asm-x86/kvm_para.h | 3 ++-
>   target/i386/cpu.h                           | 3 ---
>   hw/i386/microvm.c                           | 6 +++++-
>   target/i386/cpu.c                           | 3 +--
>   target/i386/host-cpu.c                      | 4 +++-
>   target/i386/kvm/kvm.c                       | 1 +
>   6 files changed, 12 insertions(+), 8 deletions(-)
> 

