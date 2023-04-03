Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF566D4E69
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 18:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbjDCQxS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 12:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDCQxR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 12:53:17 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F419B2121;
        Mon,  3 Apr 2023 09:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680540796; x=1712076796;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=ki7HvbTTIzSPCh+p8ENNZZvs3EEXOxF+XqGP2DaWK5Y=;
  b=cBB3dej1+fSvz0QI8KMDHMbvQR6HSrIybpO+86Y2kGP5zo95fGTgoGGr
   +h7KqPfTT2n+5or9QoYU2BfKyMKTmT5VqdR1b040xWWh+GT2Q7jl4mbq/
   OM6R0csvd7EWMJOrffY1dIVNdgvZaOZ4a3IITPZM53tIELxY76sqG3Fwn
   CBz12PulD0LlZPxernh3crw3mxB135SwTL2Qo5myFjdeJBdHVP6k7tvVJ
   K29KW4+39s3j0RZm0CQLOd9rQWsVSSjgtyJo30W6LBxQdkPQpVGhEdums
   JLwL50zTuhp4mXBy+gUj3hgKRbFWRtML+iaEZznKPkmmezIyQ4rDYy0KT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="407008575"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="407008575"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 09:53:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="860280525"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="860280525"
Received: from ssidhu-mobl.amr.corp.intel.com (HELO [10.212.178.109]) ([10.212.178.109])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 09:53:13 -0700
Message-ID: <19035c40-e756-6efd-1c02-b09109fb44c1@intel.com>
Date:   Mon, 3 Apr 2023 09:53:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC PATCH 0/7] x86/entry: Atomic statck switching for IST
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Cfir Cohen <cfir@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Kaplan <David.Kaplan@amd.com>,
        David Rientjes <rientjes@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Jiri Slaby <jslaby@suse.cz>, Joerg Roedel <joro@8bytes.org>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Stunes <mstunes@vmware.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Raj Ashok <ashok.raj@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, x86@kernel.org
References: <20230403140605.540512-1-jiangshanlai@gmail.com>
Content-Language: en-US
In-Reply-To: <20230403140605.540512-1-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/3/23 07:05, Lai Jiangshan wrote:
>  Documentation/x86/kernel-stacks.rst   |   2 +
>  arch/x86/entry/Makefile               |   3 +
>  arch/x86/entry/entry_64.S             | 615 +++++++-------------------
>  arch/x86/entry/ist_entry.c            | 299 +++++++++++++
>  arch/x86/include/asm/cpu_entry_area.h |   8 +-
>  arch/x86/include/asm/idtentry.h       |  15 +-
>  arch/x86/include/asm/sev.h            |  14 -
>  arch/x86/include/asm/traps.h          |   1 -
>  arch/x86/kernel/asm-offsets_64.c      |   7 +
>  arch/x86/kernel/callthunks.c          |   2 +
>  arch/x86/kernel/dumpstack_64.c        |   6 +-
>  arch/x86/kernel/nmi.c                 |   8 -
>  arch/x86/kernel/sev.c                 | 108 -----
>  arch/x86/kernel/traps.c               |  43 --
>  arch/x86/kvm/vmx/vmx.c                | 441 +++++++++++++++++-
>  arch/x86/kvm/x86.c                    |  10 +-
>  arch/x86/mm/cpu_entry_area.c          |   2 +-
>  tools/objtool/check.c                 |   7 +-
>  18 files changed, 937 insertions(+), 654 deletions(-)
>  create mode 100644 arch/x86/entry/ist_entry.c

Some high-level comments...

The diffstat looks a lot nastier because of the testing patch.  If you
that patch and trim the diffstat a bit, it starts to look a _lot_ more
appealing:

>  arch/x86/entry/entry_64.S             |  615 ++++++++----------------------------
>  arch/x86/entry/ist_entry.c            |  299 +++++++++++++++++
>  arch/x86/kernel/sev.c                 |  108 ------
>  arch/x86/kernel/traps.c               |   43 --
...
>  16 files changed, 490 insertions(+), 650 deletions(-)

It removes more code than it adds and also removes a bunch of assembly.
If it were me posting this, I'd have shouted that from the rooftops
instead of obscuring it with a testing patch and leaving it as an
exercise to the reader to figure out.

It also comes with testing code and a great cover letter, which are rare
and _spectacular_.

That said, I'm torn.  This series makes a valiant attempt to improve one
of the creakiest corners of arch/x86/.  But, there are precious few
reviewers that can _really_ dig into this stuff.  This is also a lot
less valuable now than it would have been when FRED was not on the horizon.

It's also not incremental at all.  It's going to be a big pain when
someone bisects their random system hang to patch 4/7.  It'll mean
there's a bug buried somewhere in the 500 lines of patch 3/7.

Grumbling aside, there's too much potential upside here to ignore.  As
this moves out of RFC territory, it would be great if you could:

 * Look at the FRED series and determine how much this collides
 * Dig up some reviewers
 * Flesh out the testing story.  What kind of hardware was this tested
   on?  How much was bare metal vs. VMs, etc...?
 * Reinforce what the benefits to end users are here.  Are folks
   _actually_ running into the #VC fragility, for instance?

Also, let's say we queue this, it starts getting linux-next testing, and
we start getting bug reports of hangs.  It'll have to get reverted if we
can't find the bug fast.

How much of a pain would it be to make atomic-IST-entry _temporarily_
selectable at boot time?  It would obviously need to keep the old code
around and would not have the nice diffstat.  But that way, folks would
at least have a workaround while we're bug hunting.

1. https://lore.kernel.org/all/20230327075838.5403-1-xin3.li@intel.com/
