Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC994B60D4
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 03:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbiBOCLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 21:11:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232846AbiBOCLk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 21:11:40 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B0D19C3A;
        Mon, 14 Feb 2022 18:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644891091; x=1676427091;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+HeZRAeKFxW/cwuCZBqN2uQwwndDLWRt5wIFdHPT7oM=;
  b=AuaIm1/q2OT+wy9PW+hgjnMIe7bEwjz7GYjQ21mcIsPrGAkCK5iylBVS
   KpsmX9MNuK/ZWgogrIn+VAWfGzQOo0p1uR6dAyJpNKRLAAomLtVB9xQ6L
   7nOgKIE4oTNy6Zv//HGT19Mm0ItMxUaMqwyNaJFzCIMqlYQybNdLEFAs6
   epNKKhaE3ToKkSi65rh7XDtRDpICr9dbxyrHwph3AWKhgTTltN731u2ns
   uWRB1jx3TWhLPoanDEaHwTv58xLc1FRdS0mk62y2z2nR161wyxI72nazz
   Dym4s/EJztdhyOJDsaslFZYuclyFJXvRX+3j6dEqFwmcCeWa0fgoLtPSP
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="230867125"
X-IronPort-AV: E=Sophos;i="5.88,369,1635231600"; 
   d="scan'208";a="230867125"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 18:11:31 -0800
X-IronPort-AV: E=Sophos;i="5.88,369,1635231600"; 
   d="scan'208";a="703381197"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.105])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 18:11:27 -0800
Date:   Tue, 15 Feb 2022 10:22:23 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 02/11] KVM: VMX: Handle APIC-write offset wrangling in
 VMX code
Message-ID: <20220215022221.GA28478@gao-cwp>
References: <20220204214205.3306634-1-seanjc@google.com>
 <20220204214205.3306634-3-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204214205.3306634-3-seanjc@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -5302,9 +5302,16 @@ static int handle_apic_eoi_induced(struct kvm_vcpu *vcpu)
> static int handle_apic_write(struct kvm_vcpu *vcpu)
> {
> 	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
>-	u32 offset = exit_qualification & 0xfff;
> 
>-	/* APIC-write VM exit is trap-like and thus no need to adjust IP */
>+	/*
>+	 * APIC-write VM-Exit is trap-like, KVM doesn't need to advance RIP and
>+	 * hardware has done any necessary aliasing, offset adjustments, etc...
>+	 * for the access.  I.e. the correct value has already been  written to
>+	 * the vAPIC page for the correct 16-byte chunk.  KVM needs only to
>+	 * retrieve the register value and emulate the access.
>+	 */
>+	u32 offset = exit_qualification & 0xff0;

Can we take this opportunity to remove offset/exit_qualification?
They are used just once.

>+
> 	kvm_apic_write_nodecode(vcpu, offset);
> 	return 1;
> }
>-- 
>2.35.0.263.gb82422642f-goog
>
