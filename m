Return-Path: <kvm+bounces-31439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B85B09C3C34
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 11:42:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4433C1F221D7
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 10:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7360018A6C5;
	Mon, 11 Nov 2024 10:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M1hhh6Cq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA88616A930;
	Mon, 11 Nov 2024 10:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731321614; cv=none; b=Fj9Qb1Z0GVNlyGt0jDf9XtHWiIIMZ4P0HqjUzT8KkP2q5MQWQjZ1uaWPcd9J+RpT9NEW17VKNrp6L//EPGeVlXr5hIlHkk0SQ0jXc53RuI4DFOV8WRzUCCtKi13ZhHsbd6FkFYKTCNqpmnu1KmbvdLk+upfLI1wgVnJ8HbDaDKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731321614; c=relaxed/simple;
	bh=MXMCzIaNOSRkH3nz2MJpmuNfBaqvBWenPM22q1GVMTs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jbnn/ZX/qfk+cieQxzMBUM6ZxFg56sXqbCS32uNPq23rBcGEuLoFCIsLahR21HZ1U34pNHdYiaTHWzJal09ZPlm3WFoacKG/jHe9cgnMuwEg86DtiRpz0S5/b4vosJUbFw7esyUzPgFuFwJZyZjv6MfiSe5V0M5uzRo5ndfCMpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M1hhh6Cq; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731321613; x=1762857613;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MXMCzIaNOSRkH3nz2MJpmuNfBaqvBWenPM22q1GVMTs=;
  b=M1hhh6CqOqjRMMqD7FWvvWE+3Qr7TOMRLsPxurZsDaWVmDLf9VgPrz+Y
   sV/oB8cI5k4w6E4a9dShiEK9VtW9vQFxmhqvLXi/19C46pfLVXUnIWEVV
   qyHSATu0NuPtryVUUlIm5lcgHur5KjSfFiVnN2Vhr9Pq5Yi1Oo2qoLo05
   tPq8LtWIkZgzbI0DSCswHyuDtod8MgXcCuJQ97YaDd7uu33en80jKO/j0
   MgKDuuTZUAomG4948v8o35EOyyOk9FJqFDPjtuFtr3wUPT0+pseoyTO/x
   dUgR0gjvknjJaQfuC/1D5OCalDlREqC4q/wQGdp+71MTdEpX1yUt4P/tL
   w==;
X-CSE-ConnectionGUID: dDOhZ41cQjS1n27UVzBckw==
X-CSE-MsgGUID: 0D8e6AcJT2ed5TPXqXLJ+w==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41682574"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41682574"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 02:40:13 -0800
X-CSE-ConnectionGUID: x8Wy55MJQDK32T/Cutv6fA==
X-CSE-MsgGUID: t2aAMlP+T0ylsSpgXBQIGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,144,1728975600"; 
   d="scan'208";a="117667086"
Received: from uaeoff-desk2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.207])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 02:40:09 -0800
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
Subject: [PATCH v7 00/10] TDX host: metadata reading tweaks, bug fix and info dump
Date: Mon, 11 Nov 2024 23:39:36 +1300
Message-ID: <cover.1731318868.git.kai.huang@intel.com>
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

v6 -> v7:
 - Collect tags from Dan and Nikolay (Thanks!)
 - Address nit comments from Dan in patch 3 changelog.
 - Rebase to tip/x86/tdx

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

[1]: https://github.com/intel/tdx/tree/kvm-tdxinit-host-metadata-v7

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
}

STRUCT_PREFIX = "tdx_sys_info"
FUNC_PREFIX = "get_tdx_sys_info"
STRVAR_PREFIX = "sysinfo"

def print_class_struct_field(field_name, element_bytes, num_fields, num_elements, file):
    element_type = "u%s" % (element_bytes * 8)
    element_array = ""
    if num_fields > 1:
        element_array += "[%d]" % (num_fields)
    if num_elements > 1:
        element_array += "[%d]" % (num_elements)
    print("\t%s %s%s;" % (element_type, field_name, element_array), file=file)

def print_class_struct(class_name, fields, file):
    struct_name = "%s_%s" % (STRUCT_PREFIX, class_name)
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
    func_name = "%s_%s" % (FUNC_PREFIX, class_name)
    struct_name = "%s_%s" % (STRUCT_PREFIX, class_name)
    struct_var = "%s_%s" % (STRVAR_PREFIX, class_name)

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
                limit = "%s_%s->num_cmrs" %(STRVAR_PREFIX, "cmr")
            elif fname == "CPUID_CONFIG_LEAVES" or fname == "CPUID_CONFIG_VALUES":
                limit = "%s_%s->num_cpuid_config" %(STRVAR_PREFIX, "td_conf")
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
        struct_name = "%s_%s" % (STRUCT_PREFIX, class_name)
        struct_var = class_name
        print("\tstruct %s %s;" % (struct_name, struct_var), file=file)
    print("};", file=file)

def print_main_function(file):
    print("static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)", file=file)
    print("{", file=file)
    print("\tint ret = 0;", file=file)
    print(file=file)
    for class_name, field_names in TDX_STRUCTS.items():
        func_name = "%s_%s" % (FUNC_PREFIX, class_name)
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


base-commit: 7ae15e2f69bad06527668b478dff7c099ad2e6ae
-- 
2.46.2


