Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3047A740AAE
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbjF1IJ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:09:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:44408 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233122AbjF1IFt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 04:05:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687939549; x=1719475549;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nPgXph7jE9MY5L1ghfiQHOSu+yYZgBulZjzQgnxPKMQ=;
  b=JSEuk7V04sLPGc7ejjogysXnTHBVxkMrHx1LWYS5XQ4TZs1mux9gKLU0
   TnNqNA5O3xZuUdd2L1M63DrG8jzv4F0BIj0ZhrCUIIq2l5oa8ExYiOL6P
   gw6MjDGlVTSzMHQFF5M9mNKvenLiy4sdHYBaqZoQ/BaD5Xc3dLof5jFR0
   nV31xVOtwQivvhTz5mBRXNQMmLM6o9vFrpvfSgKGQ4IYFaI6gP9bGCZBU
   9XJUaOTgitSwWx3aghTxcpFFZmyRXn8QnYtd8TfC7ei0wOEVWzXNHYaX/
   M4ersbDC5hJUSTnQcciM69MtLfacMLjL4R+fzWAVGnbrytqztzMMnPUzm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="364323158"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="364323158"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 00:28:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="829976081"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="829976081"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.238.2.33]) ([10.238.2.33])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 00:28:34 -0700
Message-ID: <1313445e-1bd2-f559-edd5-e07e0d9ccda9@intel.com>
Date:   Wed, 28 Jun 2023 15:27:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v1 1/6] KVM: x86: Consolidate flags for __linearize()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Binbin Wu <binbin.wu@linux.intel.com>
References: <20230601142309.6307-1-guang.zeng@intel.com>
 <20230601142309.6307-2-guang.zeng@intel.com> <ZJsfIQqPQgRILn7o@google.com>
Content-Language: en-US
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <ZJsfIQqPQgRILn7o@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/28/2023 1:40 AM, Sean Christopherson wrote:
> On Thu, Jun 01, 2023, Zeng Guang wrote:
>> From: Binbin Wu <binbin.wu@linux.intel.com>
>>
>> Define a 32-bit parameter and consolidate the two bools into it.
> Please write changelogs so that they make sense without the context of the shortlog.
> In isolation, the above provides zero context.  And there's no need to provide a
> play-by-play description of the change, e.g. this can be:
>
>    Consolidate __linearize()'s @write and @fetch into a set of flags so that
>    additional flags can be added without needing more/new boolean parameters,
>    e.g. to precisely identify the access type for LASS.
>
>> __linearize() has two bool parameters write and fetch. And new flag
>> will be needed to support new feature (e.g. LAM needs a flag to skip
> s/LAM/LASS
>
>> address untag under some conditions).
> Looks like this was copy+pasted LAM.  AIUI, there is no untagging in LASS.  Please,
> please take the time to proofread what you're posting.  To you it's a minor typo,
> to others, incorrect statements like this can create a lot of confusion.

LASS and LAM attempts to apply same emulator framework. This patch as
prerequisite directly uses the one of LAM patches. But no excuse, we
will modify it to non-feature and hardware specific as you suggested.
Thanks.



