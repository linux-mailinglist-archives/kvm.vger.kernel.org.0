Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0F56A472D
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 17:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbjB0QjI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 11:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjB0QjH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 11:39:07 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12839CA23;
        Mon, 27 Feb 2023 08:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677515945; x=1709051945;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CSaNHnZtUfWYDe+SuUmvhwZ1RDTvcv4le5hQAwv5cdU=;
  b=gbU+oPb3MT0aYe87YEzsd1sorHjdaaUQ/xEeihwUv8VhJ+411Wrm3DXu
   P7LfHDFuWLFU5nIrcWRSFG7k2rzRwADLWxD/vVpUuLnKiT5yhEoKdlvcJ
   SEWOWhxMh/5cyPJKUcBbZ9R38+rKUnQy78ShFwu8JoeOOR/CYA/Cc1y1E
   xrgy4MuhP+pKoKGOw03p2k3+xd1WgpJo3ohOXp5YrUjxP3tdE6Ju1c5aR
   znpdnNkP2xbl/Hjn4FDtYiLHphHkFyP3oK2mUI8QGazilekHsC/oVQx9Z
   LCGpOI7gdA3eDXgxd6cr/MkLWgKomUTEIHwJbK6CwSlRbkJA8Cu08mZXV
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="335386194"
X-IronPort-AV: E=Sophos;i="5.98,219,1673942400"; 
   d="scan'208";a="335386194"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 08:39:04 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="1002841327"
X-IronPort-AV: E=Sophos;i="5.98,219,1673942400"; 
   d="scan'208";a="1002841327"
Received: from mkrathi-mobl.gar.corp.intel.com (HELO [10.251.27.133]) ([10.251.27.133])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 08:39:03 -0800
Message-ID: <3f80e71f-a995-8ad6-b7f2-2b80fefdbd46@intel.com>
Date:   Mon, 27 Feb 2023 08:39:02 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] x86/CPU/AMD: Make sure EFER[AIBRSE] is set
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230124163319.2277355-8-kim.phillips@amd.com>
 <20230224185257.o3mcmloei5zqu7wa@treble> <Y/knUC0s+rg6ef2r@zn.tnic>
 <Y/k/ZXUXOFiBhOiI@zn.tnic> <20230225000931.wrednfun4jifkqau@treble>
 <Y/lUSC5x2ZkTIGu4@zn.tnic> <20230225005221.425yahqvxb57c43x@desk>
 <20230225013202.g7tibykvylprsxs5@treble> <Y/n9XcbnCzWv2Vul@zn.tnic>
 <445daef5-8417-ddbb-abbf-3c5ab38e1c9c@intel.com> <Y/zO7MtvjiVLCiLg@zn.tnic>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <Y/zO7MtvjiVLCiLg@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/27/23 07:40, Borislav Petkov wrote:
> On Mon, Feb 27, 2023 at 07:25:00AM -0800, Dave Hansen wrote:
>> It will freak some users out, but it does seem like the kind of thing we
>> _want_ a bug report for.
> You mean, something like:
> 
> 	if (spectre_v2_in_ibrs_mode(spectre_v2_enabled) &&
> 	    cpu_has(c, X86_FEATURE_AUTOIBRS))
> 		WARN_ON_ONCE(msr_set_bit(MSR_EFER, _EFER_AUTOIBRS));
> 
> ?

Yep, that looks sane.
