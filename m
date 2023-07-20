Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E321E75BA91
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 00:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjGTWYv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 18:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbjGTWYs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 18:24:48 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329D0E44;
        Thu, 20 Jul 2023 15:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689891887; x=1721427887;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rdKwApR3nE0JioSbploXwNi+nKycgqcT+OaCWqAn1So=;
  b=HJJkOmz0DSMX2l9ayx+quSZxgst6t6XP/S6iw2o9stPOFKq3WmHsYW08
   Jd7wO51xF+XFavAui5u9YiswKMpuaOBhPbh+yrk3MV57/LgL5+/Qo47TM
   Bqjn77O+exqglCaliDo6xuSdYl7luQKeN0VqGJyV462wdgptOXi0uT7kT
   zH0iRYGk3p1sDKMLA2X1acVY9okQRbLWnQV4WDIrlqxad31GY0l8TQKOU
   4YVoPAxTWrRL1kdKyxw3PfiD5TOwsRkdfuZtcsqMCfPBBgxf2rs+2V1b9
   zK/2q9VJEjMOEJ4BXWyg3UH+C76ZeNsg34Rg0q46qb+2Jz5y7QW1Md+gD
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="453256097"
X-IronPort-AV: E=Sophos;i="6.01,219,1684825200"; 
   d="scan'208";a="453256097"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 15:24:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="814713346"
X-IronPort-AV: E=Sophos;i="6.01,219,1684825200"; 
   d="scan'208";a="814713346"
Received: from tholtx-mobl.amr.corp.intel.com (HELO [10.209.39.44]) ([10.209.39.44])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 15:24:34 -0700
Message-ID: <ac578d2f-7567-708d-f131-9899f1b8dec1@intel.com>
Date:   Thu, 20 Jul 2023 15:24:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH RFC v9 08/51] x86/speculation: Do not enable Automatic
 IBRS if SEV SNP is enabled
Content-Language: en-US
To:     Kim Phillips <kim.phillips@amd.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-9-michael.roth@amd.com>
 <696ea7fe-3294-f21b-3bc0-3f8cc0a718e9@intel.com>
 <b8eeb557-0a6b-3aff-0f31-1c5e3e965a50@amd.com>
 <396d0e29-defc-e207-2cbd-fe7137e798ad@intel.com>
 <a11ba4c9-8f6f-c231-c480-e2f25b8132b8@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <a11ba4c9-8f6f-c231-c480-e2f25b8132b8@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/20/23 12:11, Kim Phillips wrote:
> Hopefully the commit text in this version will help answer all your
> questions?:

To be honest, it didn't really.  I kinda feel like I was having the APM
contents tossed casually in my direction rather than being provided a
fully considered explanation.

Here's what I came up with instead:

Host-side Automatic IBRS has different behavior based on whether SEV-SNP
is enabled.

Without SEV-SNP, Automatic IBRS protects only the kernel.  But when
SEV-SNP is enabled, the Automatic IBRS protection umbrella widens to all
host-side code, including userspace.  This protection comes at a cost:
reduced userspace indirect branch performance.

To avoid this performance loss, nix using Automatic IBRS on SEV-SNP
hosts.  Fall back to retpolines instead.

=====

Is that about right?

I don't think any chit-chat about the guest side is even relevant.

This also absolutely needs a comment.  Perhaps just pull the code up to
the top level of the function and do this:

	/*
	 * Automatic IBRS imposes unacceptable overhead on host
	 * userspace for SEV-SNP systems.  Zap it instead.
	 */
	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP))
		setup_clear_cpu_cap(X86_FEATURE_AUTOIBRS);

BTW, I assume you've grumbled to folks about this.  It's an awful shame
the hardware (or ucode) was built this was.  It's just throwing
Automatic IBRS out the window because it's not architected in a nice way.

Is there any plan to improve this?
