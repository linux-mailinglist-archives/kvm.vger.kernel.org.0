Return-Path: <kvm+bounces-29837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 81A949B308A
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 13:41:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AA508B218AF
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 12:41:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6C801DA31D;
	Mon, 28 Oct 2024 12:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R/Ylizz6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2872A4C83;
	Mon, 28 Oct 2024 12:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730119291; cv=none; b=JArAW1wNVu7yrMdaGhr25EVR4xAQnSVEqpSDz7umOlZcb92iv1CymzNtznN2pZM+84/yrd/Esb6tuGlcHWIGAMzFbYDA9+z67ZZ3oOqwOYiEw4S1Kx1/uKSJ35pyld42ObrXrLFxBkqftaNvl+JnixeoWKIx0Lw/OXm6/jeczdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730119291; c=relaxed/simple;
	bh=tM9QQ9Ju6qLhN1QtOG3v89V/3xTyFf3DjgdwEciiNOw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Utz135pRjXNccRnBiF9POzEzvrLYMxE2Do52IeKlPL+fKEN5TS+baYbBU8tHbMpjYBUAfoQzDpy9qGPw0ne/WprbLLUbn7+7rsa8vi5B9pr9Z3m+UPzyLfT8gX/xPsAV5i/qOJwZEpwyyznrnzZQZ/FvZn22q/zv2hTCitiCMb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R/Ylizz6; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730119288; x=1761655288;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tM9QQ9Ju6qLhN1QtOG3v89V/3xTyFf3DjgdwEciiNOw=;
  b=R/Ylizz6rjVpzs2WdWtRxFfVKnIh+eGjW8IQDqhvuy5oMrZRIPXEiIeL
   xeTfFwnITuyGqT3QfH5Mx+rl1qfTAUBjKE11KjFBV+yDY4Gt6uW2ARMsg
   EsvF8KGqwo4TQbFJxLceaVfSegDPF+yELW49IdmRnvHX8lCSxl8hul+QM
   G8rOZ8FZbrxML+TYrGpjILJhvUeVcYPYkPD7AGIQ92QAWlRbJNnaAvbJF
   Sm2uOs8irhaUwhk0z9UGjs/uuCYre7cr6VJC080U2B4VNk2flxLtFpWzN
   3BlQOPqHdRgLis/0s2yeiHQgWCHNYQBXcWW0rCoS2IieXbe/CDsEA+hEw
   A==;
X-CSE-ConnectionGUID: B0fTRxxLRX+y1Q/myj4ZqA==
X-CSE-MsgGUID: TEPnUc1MSlOAgOlTLLiIVw==
X-IronPort-AV: E=McAfee;i="6700,10204,11238"; a="32575209"
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="32575209"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 05:41:26 -0700
X-CSE-ConnectionGUID: 3+1tP802SqiQEzU1YFHEWQ==
X-CSE-MsgGUID: qSB4grSnTtms+dtoRhVwdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="82420852"
Received: from gargmani-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.169])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 05:41:22 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	tglx@linutronix.de,
	bp@alien8.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	dan.j.williams@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	adrian.hunter@intel.com,
	nik.borisov@suse.com,
	kai.huang@intel.com
Subject: [PATCH v6 00/10] TDX host: metadata reading tweaks, bug fix and info dump
Date: Tue, 29 Oct 2024 01:41:02 +1300
Message-ID: <cover.1730118186.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series does necessary tweaks to TDX host "global metadata" reading
code to fix some immediate issues in the TDX module initialization code,
with intention to also provide a flexible code base to support sharing
global metadata to KVM (and other kernel components) for future needs.

This series, and additional patches to initialize TDX when loading KVM
module and read essential metadata fields for KVM TDX can be found at
[1].

Hi Dave (and maintainers),

This series targets x86 tip.  Also add Dan, KVM maintainers and KVM list
so people can also review and comment.

This is a pre-work of the "quite near future" KVM TDX support.  I
appreciate if you can review, comment and take this series if the
patches look good to you.

History:

v5 -> v6:
 - Change to use a script [*] to auto-generate metadata reading code.

  - https://lore.kernel.org/kvm/f25673ea-08c5-474b-a841-095656820b67@intel.com/
  - https://lore.kernel.org/kvm/CABgObfYXUxqQV_FoxKjC8U3t5DnyM45nz5DpTxYZv2x_uFK_Kw@mail.gmail.com/

   Per Dave, this patchset doesn't contain a patch to add the script
   to the kernel tree but append it in this cover letter in order to
   minimize the review effort.

 - Change to use auto-generated code to read TDX module version,
   supported features and CMRs in one patch, and made that from and
   signed by Paolo.
 - Couple of new patches due to using the auto-generated code
 - Remove the "reading metadata" part (due to they are auto-generated
   in one patch now) from the consumer patches.

Pervious versions and more background please see:

 - https://lore.kernel.org/kvm/9a06e2cf469cbca2777ac2c4ef70579e6bb934d5.camel@intel.com/T/

[1]: https://github.com/intel/tdx/tree/kvm-tdxinit-host-metadata-v6

[*] The script used to generate the patch 3:

#! /usr/bin/env python3
import json
import sys

# Note: this script does not run as part of the build process.
# It is used to generate structs from the TDX global_metadata.json
# file, and functions to fill in said structs.  Rerun it if
# you need more fields.

TDX_STRUCTS = {
    "version": [
        "BUILD_DATE",
        "BUILD_NUM",
        "MINOR_VERSION",
        "MAJOR_VERSION",
        "UPDATE_VERSION",
        "INTERNAL_VERSION",
    ],
    "features": [
        "TDX_FEATURES0"
    ],
    "tdmr": [
        "MAX_TDMRS",
        "MAX_RESERVED_PER_TDMR",
        "PAMT_4K_ENTRY_SIZE",
        "PAMT_2M_ENTRY_SIZE",
        "PAMT_1G_ENTRY_SIZE",
    ],
    "cmr": [
        "NUM_CMRS", "CMR_BASE", "CMR_SIZE"
    ],
#   "td_ctrl": [
#        "TDR_BASE_SIZE",
#        "TDCS_BASE_SIZE",
#        "TDVPS_BASE_SIZE",
#    ],
#    "td_conf": [
#        "ATTRIBUTES_FIXED0",
#        "ATTRIBUTES_FIXED1",
#        "XFAM_FIXED0",
#        "XFAM_FIXED1",
#        "NUM_CPUID_CONFIG",
#        "MAX_VCPUS_PER_TD",
#        "CPUID_CONFIG_LEAVES",
#        "CPUID_CONFIG_VALUES",
#    ],
}

def print_class_struct_field(field_name, element_bytes, num_fields, num_elements, file):
    element_type = "u%s" % (element_bytes * 8)
    element_array = ""
    if num_fields > 1:
        element_array += "[%d]" % (num_fields)
    if num_elements > 1:
        element_array += "[%d]" % (num_elements)
    print("\t%s %s%s;" % (element_type, field_name, element_array), file=file)

def print_class_struct(class_name, fields, file):
    struct_name = "tdx_sys_info_%s" % (class_name)
    print("struct %s {" % (struct_name), file=file)
    for f in fields:
        print_class_struct_field(
            f["Field Name"].lower(),
            int(f["Element Size (Bytes)"]),
            int(f["Num Fields"]),
            int(f["Num Elements"]),
            file=file)
    print("};", file=file)

def print_read_field(field_id, struct_var, struct_member, indent, file):
    print(
        "%sif (!ret && !(ret = read_sys_metadata_field(%s, &val)))\n%s\t%s->%s = val;"
        % (indent, field_id, indent, struct_var, struct_member),
        file=file,
    )

def print_class_function(class_name, fields, file):
    func_name = "get_tdx_sys_info_%s" % (class_name)
    struct_name = "tdx_sys_info_%s" % (class_name)
    struct_var = "sysinfo_%s" % (class_name)

    print("static int %s(struct %s *%s)" % (func_name, struct_name, struct_var), file=file)
    print("{", file=file)
    print("\tint ret = 0;", file=file)
    print("\tu64 val;", file=file)

    has_i = 0
    has_j = 0
    for f in fields:
        num_fields = int(f["Num Fields"])
        num_elements = int(f["Num Elements"])
        if num_fields > 1:
            has_i = 1
        if num_elements > 1:
            has_j = 1

    if has_i == 1 and has_j == 1:
        print("\tint i, j;", file=file)
    elif has_i == 1:
        print("\tint i;", file=file)

    print(file=file)
    for f in fields:
        fname = f["Field Name"]
        field_id = f["Base FIELD_ID (Hex)"]
        num_fields = int(f["Num Fields"])
        num_elements = int(f["Num Elements"])
        struct_member = fname.lower()
        indent = "\t"
        if num_fields > 1:
            if fname == "CMR_BASE" or fname == "CMR_SIZE":
                limit = "sysinfo_cmr->num_cmrs"
            elif fname == "CPUID_CONFIG_LEAVES" or fname == "CPUID_CONFIG_VALUES":
                limit = "sysinfo_td_conf->num_cpuid_config"
            else:
                limit = "%d" %(num_fields)
            print("%sfor (i = 0; i < %s; i++)" % (indent, limit), file=file)
            indent += "\t"
            field_id += " + i"
            struct_member += "[i]"
        if num_elements > 1:
            print("%sfor (j = 0; j < %d; j++)" % (indent, num_elements), file=file)
            indent += "\t"
            field_id += " * 2 + j"
            struct_member += "[j]"

        print_read_field(
            field_id,
            struct_var,
            struct_member,
            indent,
            file=file,
        )

    print(file=file)
    print("\treturn ret;", file=file)
    print("}", file=file)

def print_main_struct(file):
    print("struct tdx_sys_info {", file=file)
    for class_name, field_names in TDX_STRUCTS.items():
        struct_name = "tdx_sys_info_%s" % (class_name)
        struct_var = class_name
        print("\tstruct %s %s;" % (struct_name, struct_var), file=file)
    print("};", file=file)

def print_main_function(file):
    print("static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)", file=file)
    print("{", file=file)
    print("\tint ret = 0;", file=file)
    print(file=file)
    for class_name, field_names in TDX_STRUCTS.items():
        func_name = "get_tdx_sys_info_" + class_name
        struct_var = class_name
        print("\tret = ret ?: %s(&sysinfo->%s);" % (func_name, struct_var), file=file)
    print(file=file)
    print("\treturn ret;", file=file)
    print("}", file=file)

jsonfile = sys.argv[1]
hfile = sys.argv[2]
cfile = sys.argv[3]
hfileifdef = hfile.replace(".", "_")

with open(jsonfile, "r") as f:
    json_in = json.load(f)
    fields = {x["Field Name"]: x for x in json_in["Fields"]}

with open(hfile, "w") as f:
    print("/* SPDX-License-Identifier: GPL-2.0 */", file=f)
    print("/* Automatically generated TDX global metadata structures. */", file=f)
    print("#ifndef _X86_VIRT_TDX_AUTO_GENERATED_" + hfileifdef.upper(), file=f)
    print("#define _X86_VIRT_TDX_AUTO_GENERATED_" + hfileifdef.upper(), file=f)
    print(file=f)
    print("#include <linux/types.h>", file=f)
    print(file=f)
    for class_name, field_names in TDX_STRUCTS.items():
        print_class_struct(class_name, [fields[x] for x in field_names], file=f)
        print(file=f)
    print_main_struct(file=f)
    print(file=f)
    print("#endif", file=f)

with open(cfile, "w") as f:
    print("// SPDX-License-Identifier: GPL-2.0", file=f)
    print("/*", file=f)
    print(" * Automatically generated functions to read TDX global metadata.", file=f)
    print(" *", file=f)
    print(" * This file doesn't compile on its own as it lacks of inclusion", file=f)
    print(" * of SEAMCALL wrapper primitive which reads global metadata.", file=f)
    print(" * Include this file to other C file instead.", file=f)
    print(" */", file=f)
    for class_name, field_names in TDX_STRUCTS.items():
        print(file=f)
        print_class_function(class_name, [fields[x] for x in field_names], file=f)
    print(file=f)
    print_main_function(file=f)




Kai Huang (9):
  x86/virt/tdx: Rename 'struct tdx_tdmr_sysinfo' to reflect the spec
    better
  x86/virt/tdx: Start to track all global metadata in one structure
  x86/virt/tdx: Use dedicated struct members for PAMT entry sizes
  x86/virt/tdx: Add missing header file inclusion to local tdx.h
  x86/virt/tdx: Switch to use auto-generated global metadata reading
    code
  x86/virt/tdx: Trim away tail null CMRs
  x86/virt/tdx: Reduce TDMR's reserved areas by using CMRs to find
    memory holes
  x86/virt/tdx: Require the module to assert it has the NO_RBP_MOD
    mitigation
  x86/virt/tdx: Print TDX module version

Paolo Bonzini (1):
  x86/virt/tdx: Use auto-generated code to read global metadata

 arch/x86/virt/vmx/tdx/tdx.c                 | 178 ++++++++++++--------
 arch/x86/virt/vmx/tdx/tdx.h                 |  43 +----
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c |  89 ++++++++++
 arch/x86/virt/vmx/tdx/tdx_global_metadata.h |  42 +++++
 4 files changed, 247 insertions(+), 105 deletions(-)
 create mode 100644 arch/x86/virt/vmx/tdx/tdx_global_metadata.c
 create mode 100644 arch/x86/virt/vmx/tdx/tdx_global_metadata.h


base-commit: 21f0d4005e7eb71b95cf6b55041fd525bdb11c1f
-- 
2.46.2


