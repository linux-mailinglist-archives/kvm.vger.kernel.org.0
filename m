Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3427989BF
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 17:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244456AbjIHPUD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 11:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234324AbjIHPUB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 11:20:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4501BFF;
        Fri,  8 Sep 2023 08:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694186398; x=1725722398;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Om6CjFzh5dLipu2fLEo63swa2QFjMY5gRRlLIokstrk=;
  b=cMVNLhU5uvB7Wcv2BPC6rEWT5u2QaweWq/nfNchJyQ/fs3b1PiE5iuF1
   wugjwVvR7gZdSuteoZNudkrn4SbcucBGXK4ewkViTyihZSPXIx163e5iL
   i3PqO4d/LeiOp/wHwDREb/f16f4cRfn+XcmdJMi8edc6UMjQUxgSEFXtj
   0SZmn+CCW4TTUFsyudTJyL4tmVub3YuBDuVdAfUphbnVmG4TCZfB53if9
   9NaEDnlNu3OstUPqDPiVI2wc/DrIj+Waqw0u2A08NMI716w05e1Ib4WHP
   6HTYdmkIpNTomBwAC2DWL8nX4RO6G2Azid4Xkc7gjoZgKrhkKAmuRE+ly
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10827"; a="464043949"
X-IronPort-AV: E=Sophos;i="6.02,237,1688454000"; 
   d="scan'208";a="464043949"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2023 08:19:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10827"; a="989293235"
X-IronPort-AV: E=Sophos;i="6.02,237,1688454000"; 
   d="scan'208";a="989293235"
Received: from fgilganx-mobl1.amr.corp.intel.com (HELO [10.209.17.195]) ([10.209.17.195])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2023 08:19:56 -0700
Message-ID: <95e9f2f8-d714-2f9e-6bbe-56c51b9125b6@intel.com>
Date:   Fri, 8 Sep 2023 08:19:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH v13 01/22] x86/virt/tdx: Detect TDX during kernel boot
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, kirill.shutemov@linux.intel.com,
        tony.luck@intel.com, peterz@infradead.org, tglx@linutronix.de,
        bp@alien8.de, mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1692962263.git.kai.huang@intel.com>
 <7329a23e94e10e222fce6ef4685c429b9377cad6.1692962263.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <7329a23e94e10e222fce6ef4685c429b9377cad6.1692962263.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/23 05:14, Kai Huang wrote:
> Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
> host and certain physical attacks.  A CPU-attested software module
> called 'the TDX module' runs inside a new isolated memory range as a
> trusted hypervisor to manage and run protected VMs.
...

Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>

