Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2F1870C0F4
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 16:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbjEVOYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 10:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233893AbjEVOXw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 10:23:52 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F746C1;
        Mon, 22 May 2023 07:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684765431; x=1716301431;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3XoNg7LuzDozHxXwwhSOHtm37An12NorEyX5vtfGYGs=;
  b=GWdBIjpGYcHr2PCw6X4ytZefGgSd+vRTS2wB2uJdbnb+eA0L0MSi3Cma
   gtz69vbtA3kB5s8P3sSeEcNVHEOZi7eBcpQHJZBpHDpzbxufglovD6Xx8
   Apnl+Lnqs8n7W1cJTT51lbNujDYhqMhOqM+v2q3ga3z6fnteUs3nYjfLU
   x40Da4RmnE3yTVLpwsxwQOFknBTOPSJlWvF3sBxaqBo7hEK0QNnyyoMqD
   FpLAGajBJ7A/04SI2+khepXpwFRuWA0fkqYgyCOV/x6SrgpmbEwQFTxk5
   iZ48IG2BlRpbGB69hmnaEWPJtZ6n9iM/gp20a1qzn8Zp3ZFXpyHGXsUiO
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="356163233"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="356163233"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 07:23:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="773373063"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="773373063"
Received: from ericasu-mobl.amr.corp.intel.com (HELO [10.209.49.107]) ([10.209.49.107])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 07:23:50 -0700
Message-ID: <4ffbb2c3-8ed1-d419-16ca-b311867537be@intel.com>
Date:   Mon, 22 May 2023 07:23:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] KVM: x86: Track supported ARCH_CAPABILITIES in kvm_caps
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
References: <20230506030435.80262-1-chao.gao@intel.com>
 <b472b58d-0469-8a55-985c-1d966ce66419@intel.com>
 <ZGZhW/x5OWPmx1qD@google.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <ZGZhW/x5OWPmx1qD@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/18/23 10:33, Sean Christopherson wrote:
> 
>   2. I'm pretty sure conditioning mmio_stale_data_clear on kvm_arch_has_assigned_device()
>      is a bug.  AIUI, the vulnerability applies to _any_ MMIO accesses.  Assigning
>      a device is necessary to let the device DMA into the guest, but it's not
>      necessary to let the guest access MMIO addresses, that's done purely via
>      memslots.

Just to make sure we're all on the same page: KVM needs mitigations when
real, hardware MMIO is exposed to the guest.  None of this has anything
to do with virtio or what guests _normally_ see as devices or MMIO.  Right?

But direct device assignment does that "real hardware MMIO" for sure
because it's mapping parts of the PCI address space (which is all MMIO)
into the guest.  That's what the kvm_arch_has_assigned_device() check
was going for.

But I think you're also saying that, in the end, memory gets exposed to
the guest by KVM userspace setting up a memslot.  KVM userspace _could_
have mapped a piece of MMIO and could just pass that down to a guest
without kvm_arch_has_assigned_device() being involved.  That makes the
kvm_arch_has_assigned_device() useless.

In other words, all guests with kvm_arch_has_assigned_device() need
mitigation.  But there are potentially situations where the guest can
see real hardware MMIO and yet also be !kvm_arch_has_assigned_device().
