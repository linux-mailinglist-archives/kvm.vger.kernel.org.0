Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89CDB4FC8F4
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 01:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbiDKXtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 19:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239284AbiDKXsy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 19:48:54 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0FEB2D1C5;
        Mon, 11 Apr 2022 16:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649720718; x=1681256718;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=M4z4Q955a3/4N9f2aOTjbxPXvTzaZ4umBszVHw38CKg=;
  b=CmancUPI/I8iM0L0AXkcpheFS+U/ocFsKPF9vE+qRSg+nc5pz7VsJsYf
   p3peL+7BWX5WJRzGDAmuzgZjXR6Pyb92QSdhNiLszc2yQ4JVJd9KHbMMZ
   Gx+Ln1VtCyzCjRGdAVWc/wa6W2NpBGJZW/tQQ1O12nvFoRehOOjqm475x
   hE7RGuUFZiM9EPRnbTlQhVflthwbvmsTFM1YBxwqR9ULbmjR3LZuli3r2
   lb2eLP/0dq1LhaKNuFMpzaqKmiwGtVeTu1quU+qgRqIqmXdX0pDmIxWGV
   B5wS5raeckW4CknlDsJI2i3W7q3/veSuanK7BPn4amt1bNmb5SAAGUGN7
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10314"; a="322684314"
X-IronPort-AV: E=Sophos;i="5.90,252,1643702400"; 
   d="scan'208";a="322684314"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 16:45:18 -0700
X-IronPort-AV: E=Sophos;i="5.90,252,1643702400"; 
   d="scan'208";a="572472056"
Received: from minhjohn-mobl.amr.corp.intel.com (HELO [10.212.44.201]) ([10.212.44.201])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 16:45:17 -0700
Message-ID: <e800ba74-0ff6-8d98-8978-62c02cf1f8ea@intel.com>
Date:   Mon, 11 Apr 2022 16:45:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] x86/tsx: fix KVM guest live migration for tsx=on
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
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <AE4621FC-0947-4CEF-A1B3-87D4E00C786D@nutanix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/11/22 12:35, Jon Kohler wrote:
> Also, while I’ve got you, I’d also like to send out a patch to simply
> force abort all transactions even when tsx=on, and just be done with
> TSX. Now that we’ve had the patch that introduced this functionality
> I’m patching for roughly a year, combined with the microcode going
> out, it seems like TSX’s numbered days have come to an end. 

Could you elaborate a little more here?  Why would we ever want to force
abort transactions that don't need to be aborted for some reason?
