Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A01252B916
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 13:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbiERLvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 07:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235891AbiERLvR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 07:51:17 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9431055D;
        Wed, 18 May 2022 04:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652874676; x=1684410676;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LsDlrEy/O3rSVlfRNcSoeekumU3aG2sLzMfu7YpuCuQ=;
  b=YUgs7Xqf6fb6xwDrJmnHm50SEUM3uU8uSiUzrQLnCL0HYyf/gfXijtWU
   GniBSFN2prL6b9HDfly5WOPiogHAv+o4NP5RtQiX51DNqb5wv8Dd/rbuQ
   PJ8arD5QIuivBGjXf8Mm7Pf5+YbpQqQ9RPMBMe8dyrr30S5sfn9BHYeLo
   fF+xIF46bH5GFrydOZDRCXauI7UWLs7fKW22IeT2GPmdrjnoJE4RWpr5R
   eCDjDHmcke/tL6phWzS+nPuL0fvFXsADCxpbaWuEZ/kvc3Jz+GaG+loeQ
   y+9Ycg1b3OwuZRb6l6Pq3fyLyHFCvxgU6NMnNYx2f4Kmci/bBfcwpYh+D
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="334679697"
X-IronPort-AV: E=Sophos;i="5.91,234,1647327600"; 
   d="scan'208";a="334679697"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 04:51:16 -0700
X-IronPort-AV: E=Sophos;i="5.91,234,1647327600"; 
   d="scan'208";a="597747941"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 04:51:10 -0700
Date:   Wed, 18 May 2022 19:51:01 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        intel-gfx@lists.freedesktop.org,
        Sean Christopherson <seanjc@google.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v3 02/19] KVM: x86: inhibit APICv/AVIC when the guest
 and/or host changes apic id/base from the defaults.
Message-ID: <20220518115056.GA18087@gao-cwp>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
 <20220427200314.276673-3-mlevitsk@redhat.com>
 <20220518082811.GA8765@gao-cwp>
 <8c78939bf01a98554696add10e17b07631d97a28.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c78939bf01a98554696add10e17b07631d97a28.camel@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 18, 2022 at 12:50:27PM +0300, Maxim Levitsky wrote:
>> > struct kvm_arch {
>> > @@ -1258,6 +1260,7 @@ struct kvm_arch {
>> > 	hpa_t	hv_root_tdp;
>> > 	spinlock_t hv_root_tdp_lock;
>> > #endif
>> > +	bool apic_id_changed;
>> 
>> What's the value of this boolean? No one reads it.
>
>I use it in later patches to kill the guest during nested VM entry 
>if it attempts to use nested AVIC after any vCPU changed APIC ID.
>
>I mentioned this boolean in the commit description.
>
>This boolean avoids the need to go over all vCPUs and checking
>if they still have the initial apic id.

Do you want to kill the guest if APIC base got changed? If yes,
you can check if APICV_INHIBIT_REASON_RO_SETTINGS is set and save
the boolean.

>
>In the future maybe we can introduce a more generic 'taint'
>bitmap with various flags like that, indicating that the guest
>did something unexpected.
>
>BTW, the other option in regard to the nested AVIC is just to ignore this issue completely.
>The code itself always uses vcpu_id's, thus regardless of when/how often the guest changes
>its apic ids, my code would just use the initial APIC ID values consistently.
>
>In this case I won't need this boolean.
>
>> 
>> > };
>> > 
>> > struct kvm_vm_stat {
>> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> > index 66b0eb0bda94e..8996675b3ef4c 100644
>> > --- a/arch/x86/kvm/lapic.c
>> > +++ b/arch/x86/kvm/lapic.c
>> > @@ -2038,6 +2038,19 @@ static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
>> > 	}
>> > }
>> > 
>> > +static void kvm_lapic_check_initial_apic_id(struct kvm_lapic *apic)
>> > +{
>> > +	if (kvm_apic_has_initial_apic_id(apic))
>> > +		return;
>> > +
>> > +	pr_warn_once("APIC ID change is unsupported by KVM");
>> 
>> It is misleading because changing xAPIC ID is supported by KVM; it just
>> isn't compatible with APICv. Probably this pr_warn_once() should be
>> removed.
>
>Honestly since nobody uses this feature, I am not sure if to call this supported,
>I am sure that KVM has more bugs in regard of using non standard APIC ID.
>This warning might hopefuly make someone complain about it if this
>feature is actually used somewhere.

Now I got you. It is fine to me.
