Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5894C54BFD3
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 04:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242487AbiFOCvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 22:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233181AbiFOCvf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 22:51:35 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6EE2AC70;
        Tue, 14 Jun 2022 19:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655261495; x=1686797495;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xlvoYMRrFROAq8lxJcU7JJSApZCF7NO92GYSAv0vikg=;
  b=Iw1ftnb0ZB1MjQrk88XcMqoT+PFY9ZvYfp1iKvpTw6DhvXD77dkMKh2w
   fw0AUfbYRysYbceetqbAnjHywXf/nh9DYc/GTeD1KAmIekAQUFPNzkClt
   2CtrP2OvVUnqZogAFplKPb26v3x0v4X0kaeG31HedzuHbJm2Eh4LC0Hhc
   BVu+JxCbyVFi0jr2FAE3cV+/e7dOqpP4TG7gegeb7/dYl1tdc5oI522t5
   31oQOETv7aTR2/LKsRRTxt26XoEea+MIehcigQdLrRwISMT7iJWcRmcpe
   /Z1VoShHdDs0OFsfzBzkmFflT03o9gSqtsyicjdYkUWE1CBdq1A2zotkF
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="340474710"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="340474710"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 19:51:34 -0700
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="640734272"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 19:51:32 -0700
Date:   Wed, 15 Jun 2022 10:51:19 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Kechen Lu <kechenl@nvidia.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, somduttar@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 4/7] KVM: x86: Let userspace re-enable previously
 disabled exits
Message-ID: <20220615025114.GB7808@gao-cwp>
References: <20220615011622.136646-1-kechenl@nvidia.com>
 <20220615011622.136646-5-kechenl@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615011622.136646-5-kechenl@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022 at 06:16:19PM -0700, Kechen Lu wrote:
>From: Sean Christopherson <seanjc@google.com>
>
>Add an OVERRIDE flag to KVM_CAP_X86_DISABLE_EXITS allow userspace to
>re-enable exits and/or override previous settings.  There's no real use
>case for the the per-VM ioctl, but a future per-vCPU variant wants to let
>userspace toggle interception while the vCPU is running; add the OVERRIDE
>functionality now to provide consistent between between the per-VM and
>per-vCPU variants.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>
>---
> Documentation/virt/kvm/api.rst |  5 +++++
> arch/x86/kvm/x86.c             | 39 +++++++++++++++++++++++-----------
> include/uapi/linux/kvm.h       |  4 +++-
> 3 files changed, 35 insertions(+), 13 deletions(-)
>
>diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>index d0d8749591a8..89e13b6783b5 100644
>--- a/Documentation/virt/kvm/api.rst
>+++ b/Documentation/virt/kvm/api.rst
>@@ -6941,6 +6941,7 @@ Valid bits in args[0] are::
>   #define KVM_X86_DISABLE_EXITS_HLT              (1 << 1)
>   #define KVM_X86_DISABLE_EXITS_PAUSE            (1 << 2)
>   #define KVM_X86_DISABLE_EXITS_CSTATE           (1 << 3)
>+  #define KVM_X86_DISABLE_EXITS_OVERRIDE         (1ull << 63)
> 
> Enabling this capability on a VM provides userspace with a way to no
> longer intercept some instructions for improved latency in some
>@@ -6949,6 +6950,10 @@ physical CPUs.  More bits can be added in the future; userspace can
> just pass the KVM_CHECK_EXTENSION result to KVM_ENABLE_CAP to disable
> all such vmexits.
> 
>+By default, this capability only disables exits.  To re-enable an exit, or to
>+override previous settings, userspace can set KVM_X86_DISABLE_EXITS_OVERRIDE,
>+in which case KVM will enable/disable according to the mask (a '1' == disable).
>+
> Do not enable KVM_FEATURE_PV_UNHALT if you disable HLT exits.
> 
> 7.14 KVM_CAP_S390_HPAGE_1M
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index f31ebbb1b94f..7cc8ac550bc7 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -4201,11 +4201,10 @@ static inline bool kvm_can_mwait_in_guest(void)
> 
> static u64 kvm_get_allowed_disable_exits(void)
> {
>-	u64 r = KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_PAUSE |
>-		KVM_X86_DISABLE_EXITS_CSTATE;
>+	u64 r = KVM_X86_DISABLE_VALID_EXITS;
> 
>-	if(kvm_can_mwait_in_guest())
>-		r |= KVM_X86_DISABLE_EXITS_MWAIT;
>+	if (!kvm_can_mwait_in_guest())
>+		r &= ~KVM_X86_DISABLE_EXITS_MWAIT;

This hunk looks like a fix to patch 3; it can be squashed into that patch.
