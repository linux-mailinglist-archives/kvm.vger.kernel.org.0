Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738984FEA8D
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 01:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiDLXXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 19:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiDLXXg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 19:23:36 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28075E33B9;
        Tue, 12 Apr 2022 15:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649803786; x=1681339786;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=QPbkzbAsX4wIyhvTey1hhzk+jNaorQwHf1oY4lEYit4=;
  b=KfSQosMST5GET6Su382sVSsOUN9ywGX4CN1I5DNA+Rix4CKJaqvZ+9Db
   HKF56W+BVdlZkWuzCXwWJJAC+KOFsHf9WRVaml0xDMwpMjIJZ7LQ5zcO7
   R2Jj5DSdhBJ3CkA2yc3mH9bVHk2Qcnd1qvpXb1XPrgP8fRt1HIWLOta1J
   eh+knmMP8cGmoEqSQLaI4mlKZG3qClFb3yBjvxSKtYAT7sqmGSecUpDVq
   uTXOxMWvwV1GQpKugOzovNjIsGmnzS0grWxb/Emd6VLMb11/oDFnG/koG
   gTfJiWp1oo53Rn1/VPBrnJQOkE8VAsNNm9a8w0mi1lUrXmoGVlvg3aoEa
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="249786474"
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="249786474"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 13:40:27 -0700
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="590491036"
Received: from lpfafma-mobl.amr.corp.intel.com (HELO guptapa-desk) ([10.209.17.36])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 13:40:26 -0700
Date:   Tue, 12 Apr 2022 13:40:25 -0700
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
Message-ID: <20220412204025.evmoxjr5beqindro@guptapa-desk>
References: <20220411180131.5054-1-jon@nutanix.com>
 <41a3ca80-d3e2-47d2-8f1c-9235c55de8d1@intel.com>
 <AE4621FC-0947-4CEF-A1B3-87D4E00C786D@nutanix.com>
 <e800ba74-0ff6-8d98-8978-62c02cf1f8ea@intel.com>
 <1767A554-CC0A-412D-B70C-12DF0AF4C690@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1767A554-CC0A-412D-B70C-12DF0AF4C690@nutanix.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 12, 2022 at 01:36:20PM +0000, Jon Kohler wrote:
>
>
>> On Apr 11, 2022, at 7:45 PM, Dave Hansen <dave.hansen@intel.com> wrote:
>>
>> On 4/11/22 12:35, Jon Kohler wrote:
>>> Also, while I’ve got you, I’d also like to send out a patch to simply
>>> force abort all transactions even when tsx=on, and just be done with
>>> TSX. Now that we’ve had the patch that introduced this functionality
>>> I’m patching for roughly a year, combined with the microcode going
>>> out, it seems like TSX’s numbered days have come to an end.
>>
>> Could you elaborate a little more here?  Why would we ever want to force
>> abort transactions that don't need to be aborted for some reason?
>
>Sure, I'm talking specifically about when users of tsx=on (or
>CONFIG_X86_INTEL_TSX_MODE_ON) on X86_BUG_TAA CPU SKUs. In this situation,
>TSX features are enabled, as are TAA mitigations. Using our own use case
>as an example, we only do this because of legacy live migration reasons.
>
>This is fine on Skylake (because we're signed up for MDS mitigation anyhow)
>and fine on Ice Lake because TAA_NO=1; however this is wicked painful on
>Cascade Lake, because MDS_NO=1 and TAA_NO=0, so we're still signed up for
>TAA mitigation by default. On CLX, this hits us on host syscalls as well as
>vmexits with the mds clear on every one :(
>
>So tsx=on is this oddball for us, because if we switch to auto, we'll break
>live migration for some of our customers (but TAA overhead is gone), but
>if we leave tsx=on, we keep the feature enabled (but no one likely uses it)
>and still have to pay the TAA tax even if a customer doesn't use it.
>
>So my theory here is to extend the logical effort of the microcode driven
>automatic disablement as well as the tsx=auto automatic disablement and
>have tsx=on force abort all transactions on X86_BUG_TAA SKUs, but leave
>the CPU features enumerated to maintain live migration.

This won't help on CLX as server parts did not get the microcode driven
automatic disablement. On CLX CPUID.RTM_ALWAYS_ABORT will not be set.

What could work on CLX is TSX_CTRL_RTM_DISABLE=1 and
TSX_CTRL_CPUID_CLEAR=0. This can be done for tsx=auto or with a new mode
tsx=fake|compat. IMO, adding a new mode would be better, otherwise
tsx=auto behavior will differ depending on the kernel version.

Provided that software using TSX is following below guidance [*]:

   When Intel TSX is disabled at runtime using TSX_CTRL, but the CPUID
   enumeration of Intel TSX is not cleared, existing software using RTM may
   see aborts for every transaction. The abort will always return a 0
   status code in EAX after XBEGIN. When the software does a number of
   transaction retries, it should never retry for a 0 status value, but go
   to the nontransactional fall back path immediately.

Thanks,
Pawan

[*] TAA document: section -> Implications on Intel TSX software
     https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/intel-tsx-asynchronous-abort.html
