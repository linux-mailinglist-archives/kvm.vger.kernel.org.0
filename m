Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955D16C50BA
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 17:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbjCVQaL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 12:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbjCVQaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 12:30:08 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638F31985;
        Wed, 22 Mar 2023 09:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679502580; x=1711038580;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=p3dnl7fFSNgtYBXeztjh7NbkyVy0Vzk4yZ7yaerGz6A=;
  b=RDE9d6UZqIzi6srmbsEmc1Ca3GlLnJjQcVjDDIH21d/1F49fee481Mg8
   YHL1pnybsD6xdVYkJHDgSGm+CcX/FiDZl0AEqfb8DGM5wtXvCzs81AxNe
   AClSWb9xzNfYc0jwVwri7bhdqmbBuuF1xFwf/vKgoXk1A3Q73MNyTF5Cg
   VEw520Fh4ulT92PbLUAgNjdTQ3soE71nDAqzKPiMUK7jwsG9cmEgUJSBD
   liSHs038F+JJxtkhQBVu3hpAEZVvjScHsZmYWl1ekDlH9qbMCOpbQvKre
   T/wTcXB4p0VLbEmcY2zf4PNppO9aDbWzEvqEd5+/uGsUwXoaf7jL+uOQT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="425551535"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="425551535"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 09:29:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="927887793"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="927887793"
Received: from mtfreder-mobl1.amr.corp.intel.com (HELO [10.209.35.23]) ([10.209.35.23])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 09:29:28 -0700
Message-ID: <445ca5e5-e793-3b0a-b9b0-0dcefc6725c2@intel.com>
Date:   Wed, 22 Mar 2023 09:29:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v5 22/34] x86/fred: FRED initialization code
Content-Language: en-US
To:     "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Li, Xin3" <xin3.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-23-xin3.li@intel.com>
 <CAJhGHyADXz-3PCFS3M_7TJ8qLGJ=4NcV9aBWrpjemuXB_SnMGg@mail.gmail.com>
 <5D679723-D84F-42F0-AD8A-8BD1A38FB6CD@zytor.com>
 <CAJhGHyC0_1xJD2R03-NoRVpMXFTHR4v8CdzyJOZe_k0rdv=NfQ@mail.gmail.com>
 <20230320164950.GR2194297@hirez.programming.kicks-ass.net>
 <SA1PR11MB67345D935A2368261E584085A8819@SA1PR11MB6734.namprd11.prod.outlook.com>
 <5f81c066-d82f-b66f-9c6d-a9e6a0d5aa4f@citrix.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <5f81c066-d82f-b66f-9c6d-a9e6a0d5aa4f@citrix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/20/23 18:02, andrew.cooper3@citrix.com wrote:
> There are fewer cases where a non-IST #VE ends up in a re-entrant fault
> (IIRC, you can still manage it by unmapping the entry stack), but you're
> still trusting the outer hypervisor to not e.g. unmap the SYSCALL entry
> point.

This is a general weakness of #VE.  But, the current Linux TDX guest
implementation is not vulnerable to it.  If the host unmaps something
unexpectedly, the guest will just die because of ATTR_SEPT_VE_DISABLE.
No #VE:

> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/coco/tdx/tdx.c#n216


