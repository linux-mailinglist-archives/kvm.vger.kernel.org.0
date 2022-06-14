Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0845F54A735
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 04:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241048AbiFNC7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 22:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355463AbiFNC6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 22:58:50 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7646A19FA3
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 19:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655175296; x=1686711296;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hz1HPVAXIgAiBUzdUIGtPlxdfZXFXYAK4rPQ0UOTuTw=;
  b=KIMyHXNlKHJDVDr4w5zd0WIPB4vtl9v65BRRPALnZL+9vqn6URh5jvic
   DJHCvXTGewr8gHHh8E1E38dRoOjjnNz3grhfdeBwAfWsXMHLvlix31Isc
   lc2agobttNihwh8QSpXYAE1hWn4gIScF/Y+/gAaIfsOZCpz5B6AuuBSPo
   SIC3TwycbCbEUzbwcrabqyztBmd3Qmp30Q6IXURqmzDMSmATCr0vPNyc3
   wTO+n2prJVawvS9dnG0PTwNTgwqYnNQTIo7khvW0VPwoUSKycg/MM3vDd
   uKyhQqDm23gNxBppb0L8PQ1/NnNdgrveCd20FYmokhSsFpB+fkdXbzUVh
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="277259378"
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="277259378"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 19:54:56 -0700
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="830132375"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 19:54:53 -0700
Date:   Tue, 14 Jun 2022 10:54:40 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     wangguangju <wangguangju@baidu.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, kvm@vger.kernel.org, dave.hansen@linux.intel.co,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.orga
Subject: Re: [PATCH] KVM: x86: add a bool variable to distinguish whether to
 use PVIPI
Message-ID: <20220614025434.GA15042@gao-cwp>
References: <1655124522-42030-1-git-send-email-wangguangju@baidu.com>
 <YqdxAFhkeLjvi7L5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqdxAFhkeLjvi7L5@google.com>
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

On Mon, Jun 13, 2022 at 05:16:48PM +0000, Sean Christopherson wrote:
>The shortlog is not at all helpful, it doesn't say anything about what actual
>functional change.
>
>  KVM: x86: Don't advertise PV IPI to userspace if IPIs are virtualized
>
>On Mon, Jun 13, 2022, wangguangju wrote:
>> Commit d588bb9be1da ("KVM: VMX: enable IPI virtualization")
>> enable IPI virtualization in Intel SPR platform.There is no point
>> in using PVIPI if IPIv is supported, it doesn't work less good
>> with PVIPI than without it.
>> 
>> So add a bool variable to distinguish whether to use PVIPI.
>
>Similar complaint with the changelog, it doesn't actually call out why PV IPIs
>are unwanted.
>
>  Don't advertise PV IPI support to userspace if IPI virtualization is
>  supported by the CPU.  Hardware virtualization of IPIs more performant
>  as senders do not need to exit.

PVIPI is mainly [*] for sending multi-cast IPIs. Intel IPI virtualization
can virtualize only uni-cast IPIs. Their use cases don't overlap. So, I
don't think it makes sense to disable PVIPI if intel IPI virtualization
is supported.

The question actually is how to deal with the exceptional case below.
Considering the migration case Sean said below, it is hard to let VM
always work in the ideal way unless KVM notifies VM of migration and VM
changes its behavior on receiving such notifications. But since x2apic
has better performance than xapic, if VM cares about performance, it can
simply switch to x2apic mode. All things considered, I think the
performance gain isn't worth the complexity added. So, I prefer to leave
it as is.

[*]: when linux guest is in *xapic* mode, it uses PVIPI to send uni-case IPI.

>
>That said, I'm not sure that KVM should actually hide PV_SEND_IPI.  KVM still
>supports the feature, and unlike sched_info_on(), IPI virtualization is platform
>dependent and not fully controlled by software.  E.g. hiding PV_SEND_IPI could
>cause problems when migrating from a platform without IPIv to a platform with IPIv,
>as a paranoid VMM might complain that an exposed feature isn't supported by KVM.
>
>There's also the question of what to do about AVIC.  AVIC has many more inhibits
>than APICv, e.g. an x2APIC guest running on hardware that doesn't accelerate x2APIC
>IPIs will probably be better off with PV IPIs.
>
>Given that userspace should have read access to the module param, I'm tempted to
>say KVM should let userspace make the decision of whether or not to advertise PV
>IPIs to the guest.
