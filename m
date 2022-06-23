Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F210C5572BB
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 07:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiFWF5Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 01:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiFWF5X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 01:57:23 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A69343ED1;
        Wed, 22 Jun 2022 22:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655963842; x=1687499842;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8pd8Oamgron657/1QMJs6kHNOEmzKM8mE2Gr1jHf/Cw=;
  b=gCX9loaARlZxJbDfH/ng2wN84EO33TIDS5qMBrmQn5Po2jPiNkCb5wu5
   K0JMDITIROGmnesgFuITKn+e4koDfEGWjOw4f4j0TkX2n11n1bXYX4XZT
   9PehWH8GHxmLAfeX8H+3R9P1O14GGv9ebJ2sq2fze6darz0E2+t1zsbNf
   jHqhGqPHkKNuv7S65ilYw1uHZpMJFJHdlJwH1lJ9/VZ3n5hZfFcNLwX/a
   ngGGP6587YRy9aZf6HCcgi2IT777cq+eVJJSxZ6Mu0oZ9QYxsh0hUyWoL
   DTSZgYoW43czp6RBFVqESykr+X39RGBk+YVZirRjV9LjETTxoCdhA+ZYj
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10386"; a="306092389"
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="306092389"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 22:57:22 -0700
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="644570302"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 22:57:18 -0700
Date:   Thu, 23 Jun 2022 13:57:03 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Subject: Re: [PATCH v5 01/22] x86/virt/tdx: Detect TDX during kernel boot
Message-ID: <20220623055658.GA2934@gao-cwp>
References: <cover.1655894131.git.kai.huang@intel.com>
 <062075b36150b119bf2d0a1262de973b0a2b11a7.1655894131.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <062075b36150b119bf2d0a1262de973b0a2b11a7.1655894131.git.kai.huang@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 22, 2022 at 11:15:30PM +1200, Kai Huang wrote:
>Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
>host and certain physical attacks.  TDX introduces a new CPU mode called
>Secure Arbitration Mode (SEAM) and a new isolated range pointed by the
						    ^ perhaps, range of memory

>SEAM Ranger Register (SEAMRR).  A CPU-attested software module called
>'the TDX module' runs inside the new isolated range to implement the
>functionalities to manage and run protected VMs.
>
>Pre-TDX Intel hardware has support for a memory encryption architecture
>called MKTME.  The memory encryption hardware underpinning MKTME is also
>used for Intel TDX.  TDX ends up "stealing" some of the physical address
>space from the MKTME architecture for crypto-protection to VMs.  BIOS is
>responsible for partitioning the "KeyID" space between legacy MKTME and
>TDX.  The KeyIDs reserved for TDX are called 'TDX private KeyIDs' or
>'TDX KeyIDs' for short.
>
>To enable TDX, BIOS needs to configure SEAMRR (core-scope) and TDX
>private KeyIDs (package-scope) consistently for all packages.  TDX
>doesn't trust BIOS.  TDX ensures all BIOS configurations are correct,
>and if not, refuses to enable SEAMRR on any core.  This means detecting
>SEAMRR alone on BSP is enough to check whether TDX has been enabled by
>BIOS.
>
>To start to support TDX, create a new arch/x86/virt/vmx/tdx/tdx.c for
>TDX host kernel support.  Add a new Kconfig option CONFIG_INTEL_TDX_HOST
>to opt-in TDX host kernel support (to distinguish with TDX guest kernel
>support).  So far only KVM is the only user of TDX.  Make the new config
>option depend on KVM_INTEL.
>
>Use early_initcall() to detect whether TDX is enabled by BIOS during
>kernel boot, and add a function to report that.  Use a function instead
>of a new CPU feature bit.  This is because the TDX module needs to be
>initialized before it can be used to run any TDX guests, and the TDX
>module is initialized at runtime by the caller who wants to use TDX.
>
>Explicitly detect SEAMRR but not just only detect TDX private KeyIDs.
>Theoretically, a misconfiguration of TDX private KeyIDs can result in
>SEAMRR being disabled, but the BSP can still report the correct TDX
>KeyIDs.  Such BIOS bug can be caught when initializing the TDX module,
>but it's better to do more detection during boot to provide a more
>accurate result.
>
>Also detect the TDX KeyIDs.  This allows userspace to know how many TDX
>guests the platform can run w/o needing to wait until TDX is fully
>functional.
>
>Signed-off-by: Kai Huang <kai.huang@intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

But some cosmetic comments below ...

>---
>+
>+static u32 tdx_keyid_start __ro_after_init;
>+static u32 tdx_keyid_num __ro_after_init;
>+
...

>+static int detect_tdx_keyids(void)
>+{
>+	u64 keyid_part;
>+
>+	rdmsrl(MSR_IA32_MKTME_KEYID_PARTITIONING, keyid_part);

how about:
	rdmsr(MSR_IA32_MKTME_KEYID_PARTITIONING, tdx_keyid_start, tdx_keyid_num);
	tdx_keyid_start++;

Then TDX_KEYID_NUM/START can be dropped.

>+
>+	tdx_keyid_num = TDX_KEYID_NUM(keyid_part);
>+	tdx_keyid_start = TDX_KEYID_START(keyid_part);
>+
>+	pr_info("TDX private KeyID range: [%u, %u).\n",
>+			tdx_keyid_start, tdx_keyid_start + tdx_keyid_num);
>+
>+	/*
>+	 * TDX guarantees at least two TDX KeyIDs are configured by
>+	 * BIOS, otherwise SEAMRR is disabled.  Invalid TDX private
>+	 * range means kernel bug (TDX is broken).

Maybe it is better to have a comment for why TDX/kernel guarantees
there should be at least 2 TDX keyIDs.

>+
>+/*
>+ * This file contains both macros and data structures defined by the TDX
>+ * architecture and Linux defined software data structures and functions.
>+ * The two should not be mixed together for better readability.  The
>+ * architectural definitions come first.
>+ */
>+
>+/*
>+ * Intel Trusted Domain CPU Architecture Extension spec:
>+ *
>+ * IA32_MTRRCAP:
>+ *   Bit 15:	The support of SEAMRR
>+ *
>+ * IA32_SEAMRR_PHYS_MASK (core-scope):
>+ *   Bit 10:	Lock bit
>+ *   Bit 11:	Enable bit
>+ */
>+#define MTRR_CAP_SEAMRR			BIT_ULL(15)

Can you move this bit definition to arch/x86/include/asm/msr-index.h
right after MSR_MTRRcap definition there?
