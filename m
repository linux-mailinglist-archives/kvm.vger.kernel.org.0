Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A4F6A9352
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 10:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjCCJDK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 04:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCCJDJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 04:03:09 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D1119F34
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 01:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677834147; x=1709370147;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xXsudIOVQkzh6vofqQTXtsh+EFg2DKujbaUAUJiUCWM=;
  b=meoMLOAs71el7jE1JNEC4K4iO8AqtOUiFxzmLhawQfzA44wH83QuxGXs
   HjXe9N98KTJ135b6cMVoxMPG7JhBm00Rj0COwd6Hv2Y1LRWIYAfk1N2Ec
   C4P6XeIShsTuXUxr5SztOFWEqnhZ5b9FOy1q0xSLV09ojltzK8F9eDErn
   q9+dhAw9CYyhOO2kydbgnlLb58733bOWFK6VEd66k+YVHaq5k7Lg4OkYj
   pVuNlsjDkYNdRnQBvqmV6GZKs+GgTRG9/8j9suA2cng4rs3SwQAYenQUs
   FIxtpyVh+Tw2uVIXWWs8ZypQNmMQiNqTUbiPYxKPV8CTWjrJkJE6fipe5
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="332478890"
X-IronPort-AV: E=Sophos;i="5.98,230,1673942400"; 
   d="scan'208";a="332478890"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 01:00:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="668593696"
X-IronPort-AV: E=Sophos;i="5.98,230,1673942400"; 
   d="scan'208";a="668593696"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga007.jf.intel.com with ESMTP; 03 Mar 2023 01:00:44 -0800
Message-ID: <e87a40cd49200d7cd7178cc7839ce1ffdf587ff4.camel@linux.intel.com>
Subject: Re: [PATCH v5 4/5] KVM: x86: emulation: Apply LAM mask when
 emulating data access in 64-bit mode
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>, seanjc@google.com,
        pbonzini@redhat.com, chao.gao@intel.com
Cc:     kvm@vger.kernel.org
Date:   Fri, 03 Mar 2023 17:00:43 +0800
In-Reply-To: <1687b7c1-1c31-2684-7bcf-ca7109038153@linux.intel.com>
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
         <20230227084547.404871-5-robert.hu@linux.intel.com>
         <79b1563b-71e3-3a3d-0812-76cca32fc7b3@linux.intel.com>
         <871716083508732b474ae22b381a58be66889707.camel@linux.intel.com>
         <52e5514d-89f3-f060-71fb-01da3fe81a7a@linux.intel.com>
         <f1714f362630c29e7aeab24dcf75244d7fc41802.camel@linux.intel.com>
         <1687b7c1-1c31-2684-7bcf-ca7109038153@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-03-03 at 11:35 +0800, Binbin Wu wrote:
> > > > > Also the instruction INVLPG, INVPCID should have some special
> > > > > handling
> > > > > since LAM is not applied to the memory operand of the two
> > > > > instruction
> > > > > according to the LAM spec.
> > > > 
> > > > The spec's meaning on these 2 is: LAM masking doesn't apply to
> > > > their
> > > > operands (the address), so the behavior is like before LAM
> > > > feature
> > > > introduced. No change.
> > > 
> > > Yes, LAM are not applied to the 2 instrustions, but the
> > > __linearize
> > > is
> > > changed.
> > > For example, the emulation of invlpg (em_invpg) will also call
> > > it.

Can you elaborate more on this? what emulation case of INVLPG? do you
mean vm-exit handling due to Guest execute INVLPG when
VMCS_control.INVLPG_exiting set? or other case?

> > > So
> > > need to handle the case specificlly.
> > > Can add a flag as the input of linearize to indicate the LAM
> > > check
> > > and
> > > untag is needed or not.
> > > 
> > 
> > No need.
> > 
> > "The INVLPG instruction ...
> > LAM does not apply to the specified memory address. Thus, in 64-bit
> > mode, ** if the memory address specified is in non-canonical form
> > then
> > the INVLPG is the same as a NOP. **
> 
> Based on current patch, if the address of invlpg is non-canonical,
> it 
> will be first checked and converted by the new LAM handling.
> After that, I will be canonical and do the invalidition, but not NOP.
> Maybe we can say do an additional TLB invalidation may be no big 
> different as NOP, but it need to be documented/comment somewhere
> 
> 
> > 
> > The INVPCID instruction ...
> > LAM does not apply to the specified memory address, and in 64-bit
> > mode ** if this memory address is in non-canonical form then the
> > processor generates a #GP(0) exception. **"
> > 
> > You can double confirm in SDM: Before-and-After LAM introduced, the
> > behavior hasn't changed. Thus you don't need to worry about these 2
> > INS's emulations.
> 
> This is because currently, VMX vmexit handling is not considered yet.
> The linear address of guest is retrived from get_vmx_mem_address,
> which 
> is also will be called by INVPCID.

Again, nested LAM isn't in this patch set's scope.
In terms of handle_invpcid() --> get_vmx_mem_address(), per Spec, no
behavior changes, no changes needed.
> 
> What arguable is that we need to cover all supervisor mode pointer
> cases 
> in this phase.
> But IMO if thesel cases are not covered, CR4.LAM_SUP should be not
> allow 
> to be set by guest.
> 

