Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029466B7C3E
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 16:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjCMPmR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 11:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbjCMPmP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 11:42:15 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557FE763F1;
        Mon, 13 Mar 2023 08:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678722133; x=1710258133;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DJywSOj3kOONae0FQh7yAxGN7pIUwFnKg9M+3IECMAY=;
  b=Vpf5rvLmwl4EbZmEVyWjMrsdalwehhChkzZQXcWDthvJb8HBMPL+8Z9U
   O32LtUc2vH4RQg/uwqRnmy7uVDF02cMhEMEdzeWk115lF7QvBSA0KPulT
   JEyTfHd45pNhAKwZlWpFsPJWNEzvhOTEJSOMOuQ5HcBcI0Tge45tbt8N+
   yZoj3IrbsjSQXKlS/KYONPCHDUHP+FTsIzW4u0ylNHhK8eHfbmRt0gUQZ
   a/xqWgYG6+U6gA6uQlTrNPt1g/DZh1NixxBKCu+HUk/7r72F1CCKENYOW
   Kkrr0q08Yu9r/vNGZkku/DnPbrrwyI2kr2zY39ULrnrhoaVzdouSSkpi4
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="337202885"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="337202885"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 08:42:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="767749715"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="767749715"
Received: from rahulmur-mobl3.amr.corp.intel.com (HELO [10.212.195.84]) ([10.212.195.84])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 08:42:11 -0700
Message-ID: <9461b569-2f76-0ec7-af8d-53ee0778b7cd@intel.com>
Date:   Mon, 13 Mar 2023 08:42:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH -v2] x86/CPU/AMD: Make sure EFER[AIBRSE] is set
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
References: <Y/knUC0s+rg6ef2r@zn.tnic> <Y/k/ZXUXOFiBhOiI@zn.tnic>
 <20230225000931.wrednfun4jifkqau@treble> <Y/lUSC5x2ZkTIGu4@zn.tnic>
 <20230225005221.425yahqvxb57c43x@desk>
 <20230225013202.g7tibykvylprsxs5@treble> <Y/n9XcbnCzWv2Vul@zn.tnic>
 <445daef5-8417-ddbb-abbf-3c5ab38e1c9c@intel.com> <Y/zO7MtvjiVLCiLg@zn.tnic>
 <3f80e71f-a995-8ad6-b7f2-2b80fefdbd46@intel.com>
 <20230310162253.GCZAtZXcpK2JK0cFkZ@fat_crate.local>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230310162253.GCZAtZXcpK2JK0cFkZ@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/10/23 08:22, Borislav Petkov wrote:
> The AutoIBRS bit gets set only on the BSP as part of determining which
> mitigation to enable on AMD. Setting on the APs relies on the
> circumstance that the APs get booted through the trampoline and EFER
> - the MSR which contains that bit - gets replicated on every AP from the
> BSP.
> 
> However, this can change in the future and considering the security
> implications of this bit not being set on every CPU, make sure it is set
> by verifying EFER later in the boot process and on every AP.
> 
> Reported-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Link: https://lore.kernel.org/r/20230224185257.o3mcmloei5zqu7wa@treble

Looks sane, thanks for adding the warning:

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>

