Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B084FE7A9
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 20:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358635AbiDLSNu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 14:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358646AbiDLSNs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 14:13:48 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6DF4968E;
        Tue, 12 Apr 2022 11:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649787090; x=1681323090;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=e+v9atRUEsNxr7cIqFOK0n4ysOpxO9O67Ox4EDhcAKY=;
  b=K6x0jezJZy9FPx5cQ4ZLGr4gynE/sdwhh/Kkasfny9BBzvg+crNcgyKp
   llHRFDByU1k2dXiFDW1M10FSnBctn9t5vLTmJXjkT4VQ8HfcPTBKCXytP
   qMpqTLHBf30gXW3l3Tm2oSHjiDKnyfGrjV+QuuqI3SNEdssuh9O2wPSFA
   NVsANBSYW8nXagxq124jI9VS/MUf0VKxiIxOncHRpog9izl2iEbHVHysi
   2KBZmUsyWbA7XBJ2A9Gt0nTdU7vGD925SjggpnoacUtDcnVImIC2ewq2h
   YaBl0yASQnLbH69K6dPnkMrE+3knCqo8xLxwelY6z7gaknF8V8CoYtrT6
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="261907604"
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="261907604"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 11:04:55 -0700
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="559438893"
Received: from lpfafma-mobl.amr.corp.intel.com (HELO guptapa-desk) ([10.209.17.36])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 11:04:54 -0700
Date:   Tue, 12 Apr 2022 11:04:52 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Neelima Krishnan <neelima.krishnan@intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] x86/tsx: fix KVM guest live migration for tsx=on
Message-ID: <20220412180452.ityo3o3eoxh3iul7@guptapa-desk>
References: <20220411180131.5054-1-jon@nutanix.com>
 <41a3ca80-d3e2-47d2-8f1c-9235c55de8d1@intel.com>
 <AE4621FC-0947-4CEF-A1B3-87D4E00C786D@nutanix.com>
 <e800ba74-0ff6-8d98-8978-62c02cf1f8ea@intel.com>
 <1767A554-CC0A-412D-B70C-12DF0AF4C690@nutanix.com>
 <90457491-1ac3-b04a-856a-25c6e04d429a@intel.com>
 <28C45B75-7FE3-4C79-9A29-F929AF9BC5A8@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <28C45B75-7FE3-4C79-9A29-F929AF9BC5A8@nutanix.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 12, 2022 at 04:08:32PM +0000, Jon Kohler wrote:
>
>
>> On Apr 12, 2022, at 11:54 AM, Dave Hansen <dave.hansen@intel.com> wrote:
>>
>> On 4/12/22 06:36, Jon Kohler wrote:
>>> So my theory here is to extend the logical effort of the microcode driven
>>> automatic disablement as well as the tsx=auto automatic disablement and
>>> have tsx=on force abort all transactions on X86_BUG_TAA SKUs, but leave
>>> the CPU features enumerated to maintain live migration.
>>>
>>> This would still leave TSX totally good on Ice Lake / non-buggy systems.
>>>
>>> If it would help, I'm working up an RFC patch, and we could discuss there?
>>
>> Sure.  But, it sounds like you really want a new tdx=something rather
>> than to muck with tsx=on behavior.  Surely someone else will come along
>> and complain that we broke their TDX setup if we change its behavior.
>
>Good point, there will always be a squeaky wheel. I’ll work that into the RFC,
>I’ll do something like tsx=compat and see how it shapes up.

FYI, the original series had tsx=fake, that would have taken care of
this breakage.

   https://lore.kernel.org/lkml/de6b97a567e273adff1f5268998692bad548aa10.1623272033.git-series.pawan.kumar.gupta@linux.intel.com/

For the lack of real world use-cases at that time, this patch was dropped.

Thanks,
Pawan
