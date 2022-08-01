Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFDF1586E90
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 18:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbiHAQbT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 12:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbiHAQbR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 12:31:17 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE1033A04;
        Mon,  1 Aug 2022 09:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659371476; x=1690907476;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AaEA2TO46c+mpYxj0CEeD2Dypcs7suvTtQjaxxfR7kY=;
  b=BInlCthmB3uTvUdXXFZ3kQlR37LFUehDkRAYrgKZ2kxp9RqoosMhlwFn
   dOvgculNKJgAZuxStJcoQLoXWCWsTRxp05luDZTEwScCbPs5jYZ/rNG2z
   Ec98zWftXGzCGvHqVDu4hHcJPhdxskpPCUQdgpoCXVD6hSA9bkOCyeSyB
   4w/4EhDZzlw6oJtOoQRd6+k0IawRzqtS2mEzWNRyoImhF9S1u3Ba0AJ7Z
   yVCdlBIuuTAebDTzbADE1NyfOYnkJLlxqYDICe/vpa7+kHLVZLVEbFM/0
   oWD4xEh5RVuvQ4RvOX7+yFlCBPJ1dyR/NUbSzNbohxVzs7GILrXf4bm/f
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="287944811"
X-IronPort-AV: E=Sophos;i="5.93,208,1654585200"; 
   d="scan'208";a="287944811"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 09:31:16 -0700
X-IronPort-AV: E=Sophos;i="5.93,208,1654585200"; 
   d="scan'208";a="630309202"
Received: from cdthomas-mobl2.amr.corp.intel.com (HELO [10.209.57.155]) ([10.209.57.155])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 09:31:15 -0700
Message-ID: <85aa20bb-09ca-d1a6-8671-947370765a02@intel.com>
Date:   Mon, 1 Aug 2022 09:31:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 0/5] x86: cpuid: improve support for broken CPUID
 configurations
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "David S. Miller" <davem@davemloft.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Jane Malalane <jane.malalane@citrix.com>,
        Kees Cook <keescook@chromium.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-perf-users@vger.kernel.org,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>
References: <20220718141123.136106-1-mlevitsk@redhat.com>
 <fad05f161cc6425d8c36fb6322de2bbaa683dcb3.camel@redhat.com>
 <4a327f06f6e5da6f3badb5ccf80d22a5c9e18b97.camel@redhat.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <4a327f06f6e5da6f3badb5ccf80d22a5c9e18b97.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/1/22 09:05, Maxim Levitsky wrote:
>> A very kind ping on these patches.
> Another kind ping on these patches.

Maxim,

This series is not forgotten.  Its latest version was simply posted too
close to the merge window.  It'll get looked at in a week or two when
things calm down.

Please be patient.
