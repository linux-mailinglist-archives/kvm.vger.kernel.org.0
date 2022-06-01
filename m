Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFF153A2E1
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 12:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352168AbiFAKmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 06:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352160AbiFAKmv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 06:42:51 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2786B6D39F;
        Wed,  1 Jun 2022 03:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654080171; x=1685616171;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lsLWoFUywADLZhzpKKkETDsQTXdgFausLpKlbw44yQ0=;
  b=hZxniufXNs06JWy0NPmX8De8htF7qLo43Av+VTLHOfXsS1ATWGQKb33t
   CsAV5WnrsITGxti6aUli549x++gP76dZBKSa+MxCfy3psUjjYVWP8qHHo
   z5PnnGQHHVNiadd5u/0PZo5WJiplkwd91bwP4433nfHhJUmt/rTlOBy4o
   fSRKeiLgBOle7oH+hd5ewZtxgioObgMCcumRO5iYWJr/plcON5Mk/lYo6
   Tt3z1VLZWTnnWacEhIqZaapIjcJXiDnUor8RbNf7GOWZTaZAI8uL3+FuA
   RqYuVYPiQre0rfTeCPcJcel7hJ2Xa+aPgMNhtsxp32u8CS73f2KpLyG1R
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10364"; a="338590678"
X-IronPort-AV: E=Sophos;i="5.91,268,1647327600"; 
   d="scan'208";a="338590678"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 03:42:50 -0700
X-IronPort-AV: E=Sophos;i="5.91,268,1647327600"; 
   d="scan'208";a="606196995"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.255.29.254]) ([10.255.29.254])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 03:42:48 -0700
Message-ID: <d763aede-8ca3-58b0-ef58-fb169cfc53c0@intel.com>
Date:   Wed, 1 Jun 2022 18:42:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 1/2] KVM: vmx, pmu: accept 0 for absent MSRs when
 host-initiated
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "likexu@tencent.com" <likexu@tencent.com>
References: <20220531175450.295552-1-pbonzini@redhat.com>
 <20220531175450.295552-2-pbonzini@redhat.com> <YpZgU+vfjkRuHZZR@google.com>
 <4b59b1c0-112b-5e07-e613-607220c3b597@redhat.com>
 <2b3be388-400e-7871-7d73-aba50d49a9b7@intel.com>
 <afa804c8-abed-3353-1f0d-fdf6cd5eab00@redhat.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <afa804c8-abed-3353-1f0d-fdf6cd5eab00@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/1/2022 6:15 PM, Paolo Bonzini wrote:
> On 6/1/22 11:12, Yang, Weijiang wrote:
>>> Yes, I agree.  I have started making some changes and pushed the
>>> result to kvm/arch-lbr-for-weijiang.
>>>
>>> Most of the MSR handling is rewritten (and untested).
>>>
>>> The nested VMX handling was also completely broken so I just removed
>>> it.  Instead, KVM should be adjusted so that it does not whine.
>> Noted, I'll run tests based on it, thanks a lot!
>>
>> Has the branch been pushed? I cannot see it.
> It's just lbr-for-weijiang, sorry for mistyping.
Found it, thank you!
>
> Paolo
>
