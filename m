Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC94F7CC04D
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 12:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343512AbjJQKPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 06:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234852AbjJQKPG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 06:15:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B956EFD;
        Tue, 17 Oct 2023 03:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697537704; x=1729073704;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GKDGW/BPCucqar9pMbGebGRJy44RYD2Z9cdu6z44l6E=;
  b=Zm0RGs80aaEEZTaMMrkDouIdVyjEUJMENrjMBodMeRiEyrGmF5rGR8jX
   I/w/tyKDwfHynl7CJJNjDoNSbtfhEENQD8FLaIsDUWzPdCOhUMANJDtjE
   0eXY4iiL8kMKMwY6UceC9s+xIcFa+wC9l3L77sEeMEJW4KsZ7hc5RfKVd
   vs2jTv1YA7f2Bb6ERHkbC7ombqROZc6EAp4rxGchRt0YgksjuN65XSz7L
   QoYe+yx8DCJCF3VuKDFy4a8HJwbQGZC/CX117cG69ikOldSdg68dPm23X
   qdc+sgGX8lw62I4IYyyJErLlsoIodBG4v9qDIA7afxoZMWDaNp4Ek6ag0
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="452226630"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="452226630"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 03:15:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="872503202"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="872503202"
Received: from chowe-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.229.64])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 03:14:57 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, rafael@kernel.org, david@redhat.com,
        dan.j.williams@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v14 00/23] TDX host kernel support
Date:   Tue, 17 Oct 2023 23:14:24 +1300
Message-ID: <cover.1697532085.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

For people who concern this patchset, sorry for sending out late.  And to
save people's time, I didn't include the full coverletter here this time.
For detailed information please refer to previous v13's coverletter[1].


This version mainly adds a new patch to handle TDX vs S3/hibernation
interaction.  In short, TDX cannot survive when platform goes to S3 and
deeper states.  TDX gets completely reset upon this, and both TDX guests
and TDX module are destroyed.  Please refer to the new patch (21).

Other changes from v13 -> v14:
 - Addressed comments received in v13 (Rick/Nikolay/Dave).
   - SEAMCALL patches, skeleton patch, kexec patch
 - Some minor updates based on internal discussion.
 - Added received Reviewed-by tags (thanks!).
 - Updated the documentation patch to reflect new changes.

Please see each individual patch for specific change history.

Hi Dave,

In this version all patches (except the documentation one) now have at
least Kirill's Reviewed-by tag.  Could you help to take a look?

And again, thanks everyone for reviewing and helping on this series.

[1]: v13 https://lore.kernel.org/lkml/cover.1692962263.git.kai.huang@intel.com/T/


Kai Huang (23):
  x86/virt/tdx: Detect TDX during kernel boot
  x86/tdx: Define TDX supported page sizes as macros
  x86/virt/tdx: Make INTEL_TDX_HOST depend on X86_X2APIC
  x86/cpu: Detect TDX partial write machine check erratum
  x86/virt/tdx: Handle SEAMCALL no entropy error in common code
  x86/virt/tdx: Add SEAMCALL error printing for module initialization
  x86/virt/tdx: Add skeleton to enable TDX on demand
  x86/virt/tdx: Get information about TDX module and TDX-capable memory
  x86/virt/tdx: Use all system memory when initializing TDX module as
    TDX memory
  x86/virt/tdx: Add placeholder to construct TDMRs to cover all TDX
    memory regions
  x86/virt/tdx: Fill out TDMRs to cover all TDX memory regions
  x86/virt/tdx: Allocate and set up PAMTs for TDMRs
  x86/virt/tdx: Designate reserved areas for all TDMRs
  x86/virt/tdx: Configure TDX module with the TDMRs and global KeyID
  x86/virt/tdx: Configure global KeyID on all packages
  x86/virt/tdx: Initialize all TDMRs
  x86/kexec: Flush cache of TDX private memory
  x86/virt/tdx: Keep TDMRs when module initialization is successful
  x86/virt/tdx: Improve readability of module initialization error
    handling
  x86/kexec(): Reset TDX private memory on platforms with TDX erratum
  x86/virt/tdx: Handle TDX interaction with ACPI S3 and deeper states
  x86/mce: Improve error log of kernel space TDX #MC due to erratum
  Documentation/x86: Add documentation for TDX host support

 Documentation/arch/x86/tdx.rst     |  217 +++-
 arch/x86/Kconfig                   |    3 +
 arch/x86/coco/tdx/tdx-shared.c     |    6 +-
 arch/x86/include/asm/cpufeatures.h |    1 +
 arch/x86/include/asm/msr-index.h   |    3 +
 arch/x86/include/asm/shared/tdx.h  |    6 +
 arch/x86/include/asm/tdx.h         |   39 +
 arch/x86/kernel/cpu/intel.c        |   17 +
 arch/x86/kernel/cpu/mce/core.c     |   33 +
 arch/x86/kernel/machine_kexec_64.c |   16 +
 arch/x86/kernel/process.c          |    8 +-
 arch/x86/kernel/reboot.c           |   15 +
 arch/x86/kernel/setup.c            |    2 +
 arch/x86/virt/vmx/tdx/Makefile     |    2 +-
 arch/x86/virt/vmx/tdx/tdx.c        | 1587 ++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h        |  145 +++
 16 files changed, 2084 insertions(+), 16 deletions(-)
 create mode 100644 arch/x86/virt/vmx/tdx/tdx.c
 create mode 100644 arch/x86/virt/vmx/tdx/tdx.h


base-commit: 9ee4318c157b9802589b746cc340bae3142d984c
-- 
2.41.0

