Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10E7B620D88
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 11:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbiKHKl6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 05:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233618AbiKHKl5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 05:41:57 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D38BC99;
        Tue,  8 Nov 2022 02:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667904115; x=1699440115;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ygzPxUg72VhUSOIbY1MyPNpSeL0qLoDe3788f0cgiV8=;
  b=lwMugXzlY3/qPJeGXt59y2CFerPbh9V7PR0DBdiWEdArznn9VUIA7q/8
   ArufR6DZltC2M/xH50pVKagb52huIq8S8t3sBd83mUDnCcBZxAObpn2sQ
   BqATTNlAsQi1Ppsnsi6dCHr3oK1k/2lsCYycslhLF+g435Fa2BCWrgSoY
   E6IZNYFRAcXbTTv5DMR9VZFpoPAFeL7IiZsNErARRgYR9MGc0mdo7Zo+d
   V6eXuTuomZ4ukhrA2CFTRVXf1fa+zNkT6r+jpJzhj8zxoKd/zHVm5GOTI
   jc56fLnPHvJAs42AeepQIDYh7dho4garwzc/tLJWZygKUO72/GgInTLGA
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="294034004"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="294034004"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 02:41:55 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="705250995"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="705250995"
Received: from wanglin4-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.173.199])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 02:41:52 -0800
Date:   Tue, 8 Nov 2022 18:41:52 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     seanjc@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: VMX: Do not trap VMFUNC instructions for L1 guests.
Message-ID: <20221108104152.mij7vchxhfpbcfpb@linux.intel.com>
References: <20221107082727.1355797-1-yu.c.zhang@linux.intel.com>
 <c8f036f4-6ab1-efbe-dd60-b934c21cb21d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c8f036f4-6ab1-efbe-dd60-b934c21cb21d@redhat.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 07, 2022 at 06:20:23PM +0100, Paolo Bonzini wrote:
> On 11/7/22 09:27, Yu Zhang wrote:
> > VMFUNC is not supported for L1 guests, and executing VMFUNC in
> > L1 shall generate a #UD directly. Just disable it in secondary
> > proc-based execution control for L1, instead of intercepting it
> > and inject the #UD again.
> > 
> > Signed-off-by: Yu Zhang<yu.c.zhang@linux.intel.com>
> 
> Is this for TDX or similar?  The reason for a patch should be mentioned in
> the commit message.

Thanks for your quick reply, Paolo. 

It is not a new feature. Just a clean up for VMFUNC, which is not
supported by KVM for L1 guest.

According to Intel SDM 25.5.6.2 - "General Operation of the VMFUNC
Instruction", The VMFUNC instruction causes an invalid-opcode exception
(#UD) if the “enable VM functions” VM-execution controls is 0 or the
value of EAX is greater than 63 (only VM functions 0–63 can be enable).
Otherwise, the instruction causes a VM exit if the bit at position
EAX is 0 in the VM-function controls (the selected VM function is not
enabled)

And since KVM only provides emulation of VMFUNC for nested guests,
it is uncessary for KVM to intercept it and reinject a #UD. So just
disable VMFUNC in VM-execution control for L1 guests.

But please feel free to educate me if I missed some backgrounds about
why this is enabled in the first place. Thanks!

B.R.
Yu
