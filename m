Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16DF155B7BA
	for <lists+kvm@lfdr.de>; Mon, 27 Jun 2022 07:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbiF0FYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 01:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbiF0FYE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 01:24:04 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0BD5FA9;
        Sun, 26 Jun 2022 22:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656307443; x=1687843443;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=dao6bRTb6endJS3dwZqWfDAFVT3N8FW7QPmL++/+lEg=;
  b=J/1z6BVSr6MYn3/qYBP5vpd//K4YHwn4US9/AwKx/8ki6ygnpwvoMgAo
   MBl/jXIZZx8H/9QGdHoVtXH683BcrYOGWzLf/g7JsTvwLze/HBgwHSKS8
   hcGn3l4UkJ617Hvw8s/JolmAL6067G/NeuvZPojRtRPByzyxlqzjzK6eq
   b6vDHOYN/NFL4t+u1a/TAeVTELheUUK9DQAniPVDEGwiztUt1ZIfk7tW8
   Q5R41ZbtrIZyn7EIl24rJ9Kf0d1bnv/L1jH6tk94FWrSriw8EtfK1mo4R
   iFT+nH3PTgrDWbzgXaT1d26gEtunotiq4bqD0V6Swdfim6q5iOaMdKlCI
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10390"; a="306833472"
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="306833472"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2022 22:24:02 -0700
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="589783038"
Received: from fzaeni-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.88.6])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2022 22:23:59 -0700
Message-ID: <5ce7ebfe54160ea35e432bf50207ebed32db31fc.camel@intel.com>
Subject: Re: [PATCH v5 07/22] x86/virt/tdx: Implement SEAMCALL function
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Mon, 27 Jun 2022 17:23:57 +1200
In-Reply-To: <069a062e-a4a6-09af-7b74-7f4929f2ec0b@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <095e6bbc57b4470e1e9a9104059a5238c9775f00.1655894131.git.kai.huang@intel.com>
         <069a062e-a4a6-09af-7b74-7f4929f2ec0b@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-06-24 at 11:38 -0700, Dave Hansen wrote:
> On 6/22/22 04:16, Kai Huang wrote:
> > SEAMCALL instruction causes #GP when SEAMRR isn't enabled, and #UD when
> > CPU is not in VMX operation.  The TDX_MODULE_CALL macro doesn't handle
> > SEAMCALL exceptions.  Leave to the caller to guarantee those conditions
> > before calling __seamcall().
>=20
> I was trying to make the argument earlier that you don't need *ANY*
> detection for TDX, other than the ability to make a SEAMCALL.
> Basically, patch 01/22 could go away.
>=20
> You are right that:
>=20
> 	The TDX_MODULE_CALL macro doesn't handle SEAMCALL exceptions.
>=20
> But, it's also not hard to make it *able* to handle exceptions.
>=20
> So what does patch 01/22 buy us?  One EXTABLE entry?

There are below pros if we can detect whether TDX is enabled by BIOS during=
 boot
before initializing the TDX Module:

1) There are requirements from customers to report whether platform support=
s TDX
and the TDX keyID numbers before initializing the TDX module so the userspa=
ce
cloud software can use this information to do something.  Sorry I cannot fi=
nd
the lore link now.

Isaku, if you see, could you provide more info?

2) As you can see, it can be used to handle ACPI CPU/memory hotplug and dri=
ver
managed memory hotplug.  Kexec() support patch also can use it.

Particularly, in concept, ACPI CPU/memory hotplug is only related to whethe=
r TDX
is enabled by BIOS, but not whether TDX module is loaded, or the result of
initializing the TDX module.  So I think we should have some code to detect=
 TDX
during boot.


Also, it seems adding EXTABLE to TDX_MODULE_CALL doesn't have significantly=
 less
code comparing to detecting TDX during boot:

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 4b75c930fa1b..4a97ca8eb14c 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -8,6 +8,7 @@
 #include <asm/ptrace.h>
 #include <asm/shared/tdx.h>

+#ifdef CONFIG_INTEL_TDX_HOST
 /*
  * SW-defined error codes.
  *
@@ -18,6 +19,21 @@
 #define TDX_SW_ERROR                   (TDX_ERROR | GENMASK_ULL(47, 40))
 #define TDX_SEAMCALL_VMFAILINVALID     (TDX_SW_ERROR | _UL(0xFFFF0000))

+/*
+ * Special error codes to indicate SEAMCALL #GP and #UD.
+ *
+ * SEAMCALL causes #GP when SEAMRR is not properly enabled by BIOS, and
+ * causes #UD when CPU is not in VMX operation.  Define two separate
+ * error codes to distinguish the two cases so caller can be aware of
+ * what caused the SEAMCALL to fail.
+ *
+ * Bits 61:48 are reserved bits which will never be set by the TDX
+ * module.  Borrow 2 reserved bits to represent #GP and #UD.
+ */
+#define TDX_SEAMCALL_GP                (TDX_ERROR | GENMASK_ULL(48, 48))
+#define TDX_SEAMCALL_UD                (TDX_ERROR | GENMASK_ULL(49, 49))
+#endif
+
 #ifndef __ASSEMBLY__

 /*
diff --git a/arch/x86/virt/vmx/tdx/tdxcall.S b/arch/x86/virt/vmx/tdx/tdxcal=
l.S
index 49a54356ae99..7431c47258d9 100644
--- a/arch/x86/virt/vmx/tdx/tdxcall.S
+++ b/arch/x86/virt/vmx/tdx/tdxcall.S
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <asm/asm-offsets.h>
 #include <asm/tdx.h>
+#include <asm/asm.h>

 /*
  * TDCALL and SEAMCALL are supported in Binutils >=3D 2.36.
@@ -45,6 +46,7 @@
        /* Leave input param 2 in RDX */

        .if \host
+1:
        seamcall
        /*
         * SEAMCALL instruction is essentially a VMExit from VMX root
@@ -57,9 +59,25 @@
         * This value will never be used as actual SEAMCALL error code as
         * it is from the Reserved status code class.
         */
-       jnc .Lno_vmfailinvalid
+       jnc .Lseamcall_out
        mov $TDX_SEAMCALL_VMFAILINVALID, %rax
-.Lno_vmfailinvalid:
+       jmp .Lseamcall_out
+2:
+       /*
+        * SEAMCALL caused #GP or #UD.  By reaching here %eax contains
+        * the trap number.  Check the trap number and set up the return
+        * value to %rax.
+        */
+       cmp $X86_TRAP_GP, %eax
+       je .Lseamcall_gp
+       mov $TDX_SEAMCALL_UD, %rax
+       jmp .Lseamcall_out
+.Lseamcall_gp:
+       mov $TDX_SEAMCALL_GP, %rax
+       jmp .Lseamcall_out
+
+       _ASM_EXTABLE_FAULT(1b, 2b)
+.Lseamcall_out




