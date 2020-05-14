Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472E51D3D4B
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 21:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgENTSZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 15:18:25 -0400
Received: from mga17.intel.com ([192.55.52.151]:45643 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727987AbgENTSZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 15:18:25 -0400
IronPort-SDR: deqYmsASqCuZvMMfkelDH4OQHH7fVRarDIV3hFkhS/CuaDIt1Mn5lA39jkp91FKZSUIKoEC4KR
 RiMVNCdeMafQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 12:18:24 -0700
IronPort-SDR: otlr/Bc1J/OkMNQtp5Gh+hPnaeW8KpTJir4maVnHF3TwNk7grY8hXpwv1+vUYyEsRuNFaDzQE/
 j61nhipb+mIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,392,1583222400"; 
   d="scan'208";a="341719749"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga001.jf.intel.com with ESMTP; 14 May 2020 12:18:24 -0700
Date:   Thu, 14 May 2020 12:18:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org
Subject: Re: [PATCH RFC 2/5] KVM: x86: introduce KVM_MEM_ALLONES memory
Message-ID: <20200514191823.GA15847@linux.intel.com>
References: <20200514180540.52407-1-vkuznets@redhat.com>
 <20200514180540.52407-3-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514180540.52407-3-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 14, 2020 at 08:05:37PM +0200, Vitaly Kuznetsov wrote:
> PCIe config space can (depending on the configuration) be quite big but
> usually is sparsely populated. Guest may scan it by accessing individual
> device's page which, when device is missing, is supposed to have 'pci
> holes' semantics: reads return '0xff' and writes get discarded. Currently,
> userspace has to allocate real memory for these holes and fill them with
> '0xff'. Moreover, different VMs usually require different memory.
> 
> The idea behind the feature introduced by this patch is: let's have a
> single read-only page filled with '0xff' in KVM and map it to all such
> PCI holes in all VMs. This will free userspace of obligation to allocate
> real memory. Later, this will also allow us to speed up access to these
> holes as we can aggressively map the whole slot upon first fault.
> 
> Suggested-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  Documentation/virt/kvm/api.rst  | 22 ++++++---
>  arch/x86/include/uapi/asm/kvm.h |  1 +
>  arch/x86/kvm/x86.c              |  9 ++--
>  include/linux/kvm_host.h        | 15 ++++++-
>  include/uapi/linux/kvm.h        |  2 +
>  virt/kvm/kvm_main.c             | 79 +++++++++++++++++++++++++++++++--
>  6 files changed, 113 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index d871dacb984e..2b87d588a7e0 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1236,7 +1236,8 @@ yet and must be cleared on entry.
>  
>    /* for kvm_memory_region::flags */
>    #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
> -  #define KVM_MEM_READONLY	(1UL << 1)
> +  #define KVM_MEM_READONLY		(1UL << 1)
> +  #define KVM_MEM_ALLONES		(1UL << 2)

Why not call this KVM_MEM_PCI_HOLE or something else that better conveys
that this is memslot is intended to emulate PCI master abort semantics?
