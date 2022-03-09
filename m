Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF51F4D2812
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 06:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiCIFJ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 00:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiCIFJ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 00:09:26 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7F26424;
        Tue,  8 Mar 2022 21:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646802508; x=1678338508;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0+sd2pP56VQ690VP+LpLZGMChhV5dm2QjqdC8vtAGUs=;
  b=aSPixVMtDh8JipF+Mp0LTOVMfde8Zejl59B6DeCA2kbdd1L2AfiNLEyD
   KiYpOvoqSWZLHfIbgoyieoo/Rh4DTe2B869dXVwnXX7Fcepaz8q83D0mG
   GnaAvboyjM8MbkuJHGt2LmxFXagPiJ+7oyRyHvaIYmztcnmc+ux0/gbjo
   mioXHY3O3mIW94Lz9iQO63HtdM4sVHw9lluz2QlySQ+mnOnkdvQMAr3eZ
   IP1k8oqe3JGpeEnJC845IrFdb9nlPY4t3yva7yC6q91Oc2xo+HMhO6XBQ
   OEcJSNhDynbrib8kxC1lOFCR19j6zht9M40J3vQvRWDQZEyjQePccdw2j
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="253718724"
X-IronPort-AV: E=Sophos;i="5.90,166,1643702400"; 
   d="scan'208";a="253718724"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 21:08:27 -0800
X-IronPort-AV: E=Sophos;i="5.90,166,1643702400"; 
   d="scan'208";a="537858342"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 21:08:21 -0800
Date:   Wed, 9 Mar 2022 13:21:52 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v6 6/9] KVM: x86: lapic: don't allow to change APIC ID
 unconditionally
Message-ID: <20220309052013.GA2915@gao-cwp>
References: <20220225082223.18288-1-guang.zeng@intel.com>
 <20220225082223.18288-7-guang.zeng@intel.com>
 <Yifg4bea6zYEz1BK@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yifg4bea6zYEz1BK@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 08, 2022 at 11:04:01PM +0000, Sean Christopherson wrote:
>On Fri, Feb 25, 2022, Zeng Guang wrote:
>> From: Maxim Levitsky <mlevitsk@redhat.com>
>> 
>> No normal guest has any reason to change physical APIC IDs,
>
>I don't think we can reasonably assume this, my analysis in the link (that I just
>realized I deleted from context here) shows it's at least plausible that an existing
>guest could rely on the APIC ID being writable.  And that's just one kernel, who
>know what else is out there, especially given that people use KVM to emulate really
>old stuff, often on really old hardware.

Making xAPIC ID readonly is not only based on your analysis, but also Intel SDM
clearly saying writable xAPIC ID is processor model specific and ***software should
avoid writing to xAPIC ID***.

If writable xAPIC ID support should be retained and is tied to a module param,
live migration would depend on KVM's module params: e.g., migrate a VM with
modified xAPIC ID (apic_id_readonly off on this system) to one with
xapic_id_readonly on would fail, right? Is this failure desired? if not, we need to
have a VM-scope control. e.g., add an inhibitor of APICv (XAPIC_ID_MODIFIED) and
disable APICv forever for this VM if its vCPUs or QEMU modifies xAPIC ID.

>
>Practically speaking, anyone that wants to deploy IPIv is going to have to make
>the switch at some point, but that doesn't help people running legacy crud that
>don't care about IPIv.
>
>I was thinking a module param would be trivial, and it is (see below) if the
>param is off by default.  A module param will also provide a convenient opportunity
>to resolve the loophole reported by Maxim[1][2], though it's a bit funky.

Could you share the links?

>
>Anyways, with an off-by-default module param, we can just do:
>
>	if (!enable_apicv || !cpu_has_vmx_ipiv() || !xapic_id_readonly)
>		enable_ipiv = false;
>
>Forcing userspace to take advantage of IPIv is rather annoying, but it's not the
>end of world.
>
>Having the param on by default is a mess.  Either we break userspace (above), or
>we only kinda break userspace by having it on iff IPIv is on, but then we end up
>with cyclical dependency hell.  E.g. userspace makes xAPIC ID writable and forces
>on IPIv, which one "wins"? And if it's on by default, we can't fix the loophole
>in KVM_SET_LAPIC.

We are fine with having this param off by default.
