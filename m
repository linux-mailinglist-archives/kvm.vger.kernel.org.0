Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C486D508081
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 07:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356912AbiDTFYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 01:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235111AbiDTFYO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 01:24:14 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E6F3587B;
        Tue, 19 Apr 2022 22:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650432089; x=1681968089;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=SfesI4khtBjUJgxDq/Dosd4z9f8CYx2PpAzYtY+D6RE=;
  b=TIIYG+nDC/rWBPX0b5YerQduJmUL8NTK+cVTgfQrJdgeDtQS7RB+zOxy
   AkAY4k7Yvq6zKalYVbcbP5XONW01x+/w2qkYFH61X6cXRgeT/gAkorBNZ
   xVYOirFz500VlkCT97HXDGGRbo8KIqwEUg6F8KPh2tl5lNA1ijSdIZk2c
   LdzmGBItPRf0DykOmgW3qwqO/pMO4MhqNt+OSEwm46ONpy1aD1JuOOWRr
   tC64CuC7tsWuPnjT4EwgaUhsCr0ha99N3fRFV2FejWP0e87eatHA8Wb3c
   DZE4Xrf4FUJPXEZlNih2K3HZ8oYlX0JOW/rJonUOlPeIimL8MJtghd1C0
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="244525655"
X-IronPort-AV: E=Sophos;i="5.90,274,1643702400"; 
   d="scan'208";a="244525655"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 22:21:29 -0700
X-IronPort-AV: E=Sophos;i="5.90,274,1643702400"; 
   d="scan'208";a="510412173"
Received: from sazizi-mobl2.amr.corp.intel.com (HELO [10.212.98.167]) ([10.212.98.167])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 22:21:28 -0700
Message-ID: <f0094630-1d8b-7d3e-a376-1701ce2148eb@intel.com>
Date:   Tue, 19 Apr 2022 22:21:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com, isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <32dcf4c7acc95244a391458d79cd6907125c5c29.1649219184.git.kai.huang@intel.com>
 <bc078c41-89fd-0a24-7d8e-efcd5a697686@linux.intel.com>
 <fd954918981d5c823a8c2b8d1b346d4eb13f334f.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v3 04/21] x86/virt/tdx: Add skeleton for detecting and
 initializing TDX on demand
In-Reply-To: <fd954918981d5c823a8c2b8d1b346d4eb13f334f.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/19/22 21:37, Kai Huang wrote:
> On Tue, 2022-04-19 at 07:53 -0700, Sathyanarayanan Kuppuswamy wrote:
>> On 4/5/22 9:49 PM, Kai Huang wrote:
>>> The TDX module is essentially a CPU-attested software module running
>>> in the new Secure Arbitration Mode (SEAM) to protect VMs from malicious
>>> host and certain physical attacks.  The TDX module implements the
>> /s/host/hosts
> I don't quite get.  Could you explain why there are multiple hosts?

This one is an arbitrary language tweak.  This:

	to protect VMs from malicious host and certain physical attacks.

could also be written:

	to protect VMs from malicious host attacks and certain physical
	attacks.

But, it's somewhat more compact to do what was writen.  I agree that the
language is a bit clumsy and could be cleaned up, but just doing
s/host/hosts/ doesn't really improve anything.
