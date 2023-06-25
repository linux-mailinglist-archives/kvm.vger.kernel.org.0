Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E4873CED8
	for <lists+kvm@lfdr.de>; Sun, 25 Jun 2023 09:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbjFYHOp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 03:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbjFYHOn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 03:14:43 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1511DE75;
        Sun, 25 Jun 2023 00:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687677283; x=1719213283;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OUIC591VVcLn4DPWqvzRPzY9Na+W05nEu4Lz3WGnOzM=;
  b=SCfdyn4Cop9vPYfA+2D6/YIdQIYid9pQGzEWuyW2A0r7+2uzJx9x3nh8
   6aJNJWWohBTNk5kw8isuVTyXzcmXnOntNwPt//M0bYwKo5aMrThwjaaH3
   Txw8OXfckyBAVQ0TYyKpb9yzT0CNTRJOxbIRQInWypV4u8MqqWbVij7+E
   UFT7GeXR6MrX17G0p8z3UiG6tKySfibj919LeTrWd30ASRJfmQGJ8fsmd
   qIiSTqyYoKKIBuLwdPOl2IDhLQca5na33Wd40cZuqravB2EleVimL/J1P
   ByZIVhUV0uOJ+hEGPwXhOZra3L2/qkijhmhIGr1PQJdRJPpIQcB0+S2FG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10751"; a="363586776"
X-IronPort-AV: E=Sophos;i="6.01,156,1684825200"; 
   d="scan'208";a="363586776"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2023 00:14:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10751"; a="860328562"
X-IronPort-AV: E=Sophos;i="6.01,156,1684825200"; 
   d="scan'208";a="860328562"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.254.211.169]) ([10.254.211.169])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2023 00:14:40 -0700
Message-ID: <45be3429-f352-920a-d1af-7f3a07930f5d@intel.com>
Date:   Sun, 25 Jun 2023 15:14:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.12.0
Subject: Re: [PATCH v3 07/11] KVM: VMX: drop IPAT in memtype when CD=1 for
 KVM_X86_QUIRK_CD_NW_CLEARED
Content-Language: en-US
To:     Yan Zhao <yan.y.zhao@intel.com>, Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, kai.huang@intel.com,
        robert.hoo.linux@gmail.com
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
 <20230616023815.7439-1-yan.y.zhao@intel.com> <ZJESMaG5Thb5LWtt@chao-email>
 <ZJEQNTvfwOSsSzrf@yzhao56-desk.sh.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZJEQNTvfwOSsSzrf@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/20/2023 10:34 AM, Yan Zhao wrote:
> On Tue, Jun 20, 2023 at 10:42:57AM +0800, Chao Gao wrote:
>> On Fri, Jun 16, 2023 at 10:38:15AM +0800, Yan Zhao wrote:
>>> For KVM_X86_QUIRK_CD_NW_CLEARED, remove the ignore PAT bit in EPT memory
>>> types when cache is disabled and non-coherent DMA are present.
>>>
>>> With the quirk KVM_X86_QUIRK_CD_NW_CLEARED, WB + IPAT are returned as the
>>> EPT memory type when guest cache is disabled before this patch.
>>> Removing the IPAT bit in this patch will allow effective memory type to
>>> honor PAT values as well, which will make the effective memory type
>> Given guest sets CR0.CD, what's the point of honoring (guest) PAT? e.g.,
>> which guests can benefit from this change?
> This patch is actually a preparation for later patch 10 to implement
> fine-grained zap.
> If when CR0.CD=1 the EPT type is WB + IPAT, and
> when CR0.CD=0 + mtrr enabled, EPT type is WB or UC or ..., which are
> without IPAT, then we have to always zap all EPT entries.
> 
> Given removing the IPAT bit when CR0.CD=1 only makes the quirk
> KVM_X86_QUIRK_CD_NW_CLEARED more strict (meaning it could be WC/UC... if
> the guest PAT overwrites it), it's still acceptable.

Per my understanding, the reason why KVM had KVM_X86_QUIRK_CD_NW_CLEARED 
is to ensure the memory type is WB to achieve better boot performance 
for old OVMF.

you need to justify the original purpose is not broken by this patch.
