Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5F34FE56D
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 17:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357530AbiDLP5P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 11:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357473AbiDLP4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 11:56:40 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC6F55A0;
        Tue, 12 Apr 2022 08:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649778845; x=1681314845;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=S/RdM4HIQ/M3AD9TZlGFbxa+CRrzvVu2swh7M3JNMGY=;
  b=ILEUX+8v4VG4882BVbEHem1vJlpOtnECxBHviyepVgbX+A2N7bVYGFk5
   mCT+CROYcA7Gez61drCqLPYJaRJR1uBeJt2D0S9+2Et8HXajo22ggSXQq
   MT1o7SegYZVAFCy1m6jtofhCFa/Dn7yHyxAQrR+6ee3+J4zmF2U8L71n1
   qSAP6L3zzAejsF+S/OGQAEGCK5JY8zUWu/c7JuWwQPUxrgpfAH1lbtY8Z
   zvO7wX4gPuqZI8EUIeWjaMhQRcNEj2bk3NXYZhgHg5d6fmJ/beswhIi/9
   tJNtc/1hE37JkgowpQZYat+hDZVLntguYlutqKKFNV+9bp812j2jtThA7
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="249690306"
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="249690306"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 08:54:05 -0700
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="551764539"
Received: from vtelkarx-mobl.amr.corp.intel.com (HELO [10.209.191.73]) ([10.209.191.73])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 08:54:04 -0700
Message-ID: <90457491-1ac3-b04a-856a-25c6e04d429a@intel.com>
Date:   Tue, 12 Apr 2022 08:54:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Jon Kohler <jon@nutanix.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Neelima Krishnan <neelima.krishnan@intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>
References: <20220411180131.5054-1-jon@nutanix.com>
 <41a3ca80-d3e2-47d2-8f1c-9235c55de8d1@intel.com>
 <AE4621FC-0947-4CEF-A1B3-87D4E00C786D@nutanix.com>
 <e800ba74-0ff6-8d98-8978-62c02cf1f8ea@intel.com>
 <1767A554-CC0A-412D-B70C-12DF0AF4C690@nutanix.com>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH] x86/tsx: fix KVM guest live migration for tsx=on
In-Reply-To: <1767A554-CC0A-412D-B70C-12DF0AF4C690@nutanix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/12/22 06:36, Jon Kohler wrote:
> So my theory here is to extend the logical effort of the microcode driven
> automatic disablement as well as the tsx=auto automatic disablement and
> have tsx=on force abort all transactions on X86_BUG_TAA SKUs, but leave
> the CPU features enumerated to maintain live migration.
> 
> This would still leave TSX totally good on Ice Lake / non-buggy systems.
> 
> If it would help, I'm working up an RFC patch, and we could discuss there?

Sure.  But, it sounds like you really want a new tdx=something rather
than to muck with tsx=on behavior.  Surely someone else will come along
and complain that we broke their TDX setup if we change its behavior.

Maybe you should just pay the one-time cost and move your whole fleet
over to tsx=off if you truly believe nobody is using it.

