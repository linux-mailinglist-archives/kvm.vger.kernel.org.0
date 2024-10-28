Return-Path: <kvm+bounces-29889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BEE29B3940
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 19:35:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 863AF1F2262A
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 18:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 613E31DFDB3;
	Mon, 28 Oct 2024 18:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dgBa6QFV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5711DE4DE
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 18:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730140533; cv=none; b=Hjg2cDKr/+icSQZcL8w6IUEEuX3llCOsfegA8yZCZw1+gZypuCVasJoame4ygYQZDVIL804jqmVwU8ruXw42HUVK0BqlLi2agdeY7ZZ10DSkEtJDdMSwK99D1ra1Qqe00e3xXIEMV9RbmG22a0gi2JTpQoAUj/mlb0HY9ZgWku0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730140533; c=relaxed/simple;
	bh=UgOoJ3QjZTeLOPTAZU0D287m9zzP7vmg40Sg1mVnH8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LNWBqnLdWt74aAI+2HaYehwPSEbSATf1QrvOGEkiggyQas/EXlceFYZRKviKdLCwK4lsN7/Wxp8K/fU0RJBkAF+fX9hgkwCh6zLuJtDP+LB4Vg+pU8uuUc9N+If6/okWpuvpW//dURcq7hrieXjNJmBSak0nNgdy9Dst4TEU9YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dgBa6QFV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730140529;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=duliCMobIQPPdrmESlReaObMQo9uh/IPtq8AoECcs94=;
	b=dgBa6QFVFWt5PgK6GhS2aW6yc56zgNtiGHMSO0xBSgk0bytq5wp/Js8sjKnF+UPNuWhawv
	TghcAc5mgaZWVbHZwL4/xKbw9dXOA8RnBhepP5Za6dZYwuCfxuz7v+QPcNqeqHS9H42es6
	2zvOYYmh8QhXVA5qIJHC7nMOxuqjyvo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-9hVdeB3SO26PzMPIkTR3Ng-1; Mon, 28 Oct 2024 14:35:27 -0400
X-MC-Unique: 9hVdeB3SO26PzMPIkTR3Ng-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-37d52ccc50eso2216580f8f.3
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 11:35:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730140526; x=1730745326;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=duliCMobIQPPdrmESlReaObMQo9uh/IPtq8AoECcs94=;
        b=SsgHETo+PihE40NZ22tEx56o/o5b2QBtlla3zHjk/+B9jOcHaxd46Hq0w009axtrPe
         2+YTiPGT7483g0om7f+F7W7SrSxcMehTghwOrAG5JlZpK4XabVX5GQEf6wsUArF71np+
         Q56ZLC411CSfl2CJg+eeYsDFMjxPJbJiwOh6Qi0iHFMGnk+wmFPIWAOk2qHRurJLhhv8
         E8qRHLorMOk53kHFtn8GYnF6SimR2sYQPAglIAQBUBN/Gf6IZz8CxhHNnXcr4jaykyNw
         aodGt4W6YdG07HR7MgfxAc5HduPPRqkZ9YMZj8EtBMtfy34bsbPw5NU2Nns2725sEF5g
         wJew==
X-Forwarded-Encrypted: i=1; AJvYcCUP3UaWhRc2ysjcOHVIoeTE0tORxxKasabXJIjnnnUGGOhHxKxHXCpo5NnDTXMKo2SDl2E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwM3Q7Uy+PnRMgssmWLiomMplCTTaQHytGgLKpHGolw1gucSAfL
	/uqqp4NTAIwjOiEtcT41acW1hPIBljZwdnyqDaBl3mE76iYzyg/5YOwzaipTg8ICIeJ+SpMEE9x
	Pgup0D8//5UpwaoOkQyy8WHbSvVcnjsPOZGOOkX8CNd36tkkpZg==
X-Received: by 2002:adf:a2d2:0:b0:37d:4647:154e with SMTP id ffacd0b85a97d-380610f264fmr6329601f8f.9.1730140526359;
        Mon, 28 Oct 2024 11:35:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFMxtbAa8cR0rtuS4XI82GiF4f4IuMzrPdcu/PLsrntWaxop3xf26iGpks8sxuM5M8MgbZr+g==
X-Received: by 2002:adf:a2d2:0:b0:37d:4647:154e with SMTP id ffacd0b85a97d-380610f264fmr6329571f8f.9.1730140525868;
        Mon, 28 Oct 2024 11:35:25 -0700 (PDT)
Received: from [192.168.10.3] ([151.49.226.83])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38058b92963sm10244841f8f.98.2024.10.28.11.35.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2024 11:35:24 -0700 (PDT)
Message-ID: <0b1f3c07-a1e9-4008-8de5-52b1fea7ad7b@redhat.com>
Date: Mon, 28 Oct 2024 19:35:22 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/10] TDX host: metadata reading tweaks, bug fix and
 info dump
To: Kai Huang <kai.huang@intel.com>, dave.hansen@intel.com,
 kirill.shutemov@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
 peterz@infradead.org, mingo@redhat.com, hpa@zytor.com,
 dan.j.williams@intel.com, seanjc@google.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, isaku.yamahata@intel.com,
 adrian.hunter@intel.com, nik.borisov@suse.com, Klaus Kiwi <kkiwi@redhat.com>
References: <cover.1730118186.git.kai.huang@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <cover.1730118186.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/24 13:41, Kai Huang wrote:
> This series does necessary tweaks to TDX host "global metadata" reading
> code to fix some immediate issues in the TDX module initialization code,
> with intention to also provide a flexible code base to support sharing
> global metadata to KVM (and other kernel components) for future needs.

Kai/Dave/Rick,

the v6 of this series messes up the TDX patches for KVM, which do not 
apply anymore. I can work on a rebase myself for the sake of putting 
this series in kvm-coco-queue; but please help me a little bit by 
including in the generated data all the fields that KVM needs.

Are you able to send quickly a v7 that includes these fields, and that 
also checks in the script that generates the files?

Emphasis on "quickly".  No internal review processes of any kind, please.

Thanks,

Paolo

> This series, and additional patches to initialize TDX when loading KVM
> module and read essential metadata fields for KVM TDX can be found at
> [1].
> 
> Hi Dave (and maintainers),
> 
> This series targets x86 tip.  Also add Dan, KVM maintainers and KVM list
> so people can also review and comment.
> 
> This is a pre-work of the "quite near future" KVM TDX support.  I
> appreciate if you can review, comment and take this series if the
> patches look good to you.
> 
> History:
> 
> v5 -> v6:
>   - Change to use a script [*] to auto-generate metadata reading code.
> 
>    - https://lore.kernel.org/kvm/f25673ea-08c5-474b-a841-095656820b67@intel.com/
>    - https://lore.kernel.org/kvm/CABgObfYXUxqQV_FoxKjC8U3t5DnyM45nz5DpTxYZv2x_uFK_Kw@mail.gmail.com/
> 
>     Per Dave, this patchset doesn't contain a patch to add the script
>     to the kernel tree but append it in this cover letter in order to
>     minimize the review effort.
> 
>   - Change to use auto-generated code to read TDX module version,
>     supported features and CMRs in one patch, and made that from and
>     signed by Paolo.
>   - Couple of new patches due to using the auto-generated code
>   - Remove the "reading metadata" part (due to they are auto-generated
>     in one patch now) from the consumer patches.
> 
> Pervious versions and more background please see:
> 
>   - https://lore.kernel.org/kvm/9a06e2cf469cbca2777ac2c4ef70579e6bb934d5.camel@intel.com/T/
> 
> [1]: https://github.com/intel/tdx/tree/kvm-tdxinit-host-metadata-v6
> 
> [*] The script used to generate the patch 3:
> 
> #! /usr/bin/env python3
> import json
> import sys
> 
> # Note: this script does not run as part of the build process.
> # It is used to generate structs from the TDX global_metadata.json
> # file, and functions to fill in said structs.  Rerun it if
> # you need more fields.
> 
> TDX_STRUCTS = {
>      "version": [
>          "BUILD_DATE",
>          "BUILD_NUM",
>          "MINOR_VERSION",
>          "MAJOR_VERSION",
>          "UPDATE_VERSION",
>          "INTERNAL_VERSION",
>      ],
>      "features": [
>          "TDX_FEATURES0"
>      ],
>      "tdmr": [
>          "MAX_TDMRS",
>          "MAX_RESERVED_PER_TDMR",
>          "PAMT_4K_ENTRY_SIZE",
>          "PAMT_2M_ENTRY_SIZE",
>          "PAMT_1G_ENTRY_SIZE",
>      ],
>      "cmr": [
>          "NUM_CMRS", "CMR_BASE", "CMR_SIZE"
>      ],
> #   "td_ctrl": [
> #        "TDR_BASE_SIZE",
> #        "TDCS_BASE_SIZE",
> #        "TDVPS_BASE_SIZE",
> #    ],
> #    "td_conf": [
> #        "ATTRIBUTES_FIXED0",
> #        "ATTRIBUTES_FIXED1",
> #        "XFAM_FIXED0",
> #        "XFAM_FIXED1",
> #        "NUM_CPUID_CONFIG",
> #        "MAX_VCPUS_PER_TD",
> #        "CPUID_CONFIG_LEAVES",
> #        "CPUID_CONFIG_VALUES",
> #    ],
> }
> 
> def print_class_struct_field(field_name, element_bytes, num_fields, num_elements, file):
>      element_type = "u%s" % (element_bytes * 8)
>      element_array = ""
>      if num_fields > 1:
>          element_array += "[%d]" % (num_fields)
>      if num_elements > 1:
>          element_array += "[%d]" % (num_elements)
>      print("\t%s %s%s;" % (element_type, field_name, element_array), file=file)
> 
> def print_class_struct(class_name, fields, file):
>      struct_name = "tdx_sys_info_%s" % (class_name)
>      print("struct %s {" % (struct_name), file=file)
>      for f in fields:
>          print_class_struct_field(
>              f["Field Name"].lower(),
>              int(f["Element Size (Bytes)"]),
>              int(f["Num Fields"]),
>              int(f["Num Elements"]),
>              file=file)
>      print("};", file=file)
> 
> def print_read_field(field_id, struct_var, struct_member, indent, file):
>      print(
>          "%sif (!ret && !(ret = read_sys_metadata_field(%s, &val)))\n%s\t%s->%s = val;"
>          % (indent, field_id, indent, struct_var, struct_member),
>          file=file,
>      )
> 
> def print_class_function(class_name, fields, file):
>      func_name = "get_tdx_sys_info_%s" % (class_name)
>      struct_name = "tdx_sys_info_%s" % (class_name)
>      struct_var = "sysinfo_%s" % (class_name)
> 
>      print("static int %s(struct %s *%s)" % (func_name, struct_name, struct_var), file=file)
>      print("{", file=file)
>      print("\tint ret = 0;", file=file)
>      print("\tu64 val;", file=file)
> 
>      has_i = 0
>      has_j = 0
>      for f in fields:
>          num_fields = int(f["Num Fields"])
>          num_elements = int(f["Num Elements"])
>          if num_fields > 1:
>              has_i = 1
>          if num_elements > 1:
>              has_j = 1
> 
>      if has_i == 1 and has_j == 1:
>          print("\tint i, j;", file=file)
>      elif has_i == 1:
>          print("\tint i;", file=file)
> 
>      print(file=file)
>      for f in fields:
>          fname = f["Field Name"]
>          field_id = f["Base FIELD_ID (Hex)"]
>          num_fields = int(f["Num Fields"])
>          num_elements = int(f["Num Elements"])
>          struct_member = fname.lower()
>          indent = "\t"
>          if num_fields > 1:
>              if fname == "CMR_BASE" or fname == "CMR_SIZE":
>                  limit = "sysinfo_cmr->num_cmrs"
>              elif fname == "CPUID_CONFIG_LEAVES" or fname == "CPUID_CONFIG_VALUES":
>                  limit = "sysinfo_td_conf->num_cpuid_config"
>              else:
>                  limit = "%d" %(num_fields)
>              print("%sfor (i = 0; i < %s; i++)" % (indent, limit), file=file)
>              indent += "\t"
>              field_id += " + i"
>              struct_member += "[i]"
>          if num_elements > 1:
>              print("%sfor (j = 0; j < %d; j++)" % (indent, num_elements), file=file)
>              indent += "\t"
>              field_id += " * 2 + j"
>              struct_member += "[j]"
> 
>          print_read_field(
>              field_id,
>              struct_var,
>              struct_member,
>              indent,
>              file=file,
>          )
> 
>      print(file=file)
>      print("\treturn ret;", file=file)
>      print("}", file=file)
> 
> def print_main_struct(file):
>      print("struct tdx_sys_info {", file=file)
>      for class_name, field_names in TDX_STRUCTS.items():
>          struct_name = "tdx_sys_info_%s" % (class_name)
>          struct_var = class_name
>          print("\tstruct %s %s;" % (struct_name, struct_var), file=file)
>      print("};", file=file)
> 
> def print_main_function(file):
>      print("static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)", file=file)
>      print("{", file=file)
>      print("\tint ret = 0;", file=file)
>      print(file=file)
>      for class_name, field_names in TDX_STRUCTS.items():
>          func_name = "get_tdx_sys_info_" + class_name
>          struct_var = class_name
>          print("\tret = ret ?: %s(&sysinfo->%s);" % (func_name, struct_var), file=file)
>      print(file=file)
>      print("\treturn ret;", file=file)
>      print("}", file=file)
> 
> jsonfile = sys.argv[1]
> hfile = sys.argv[2]
> cfile = sys.argv[3]
> hfileifdef = hfile.replace(".", "_")
> 
> with open(jsonfile, "r") as f:
>      json_in = json.load(f)
>      fields = {x["Field Name"]: x for x in json_in["Fields"]}
> 
> with open(hfile, "w") as f:
>      print("/* SPDX-License-Identifier: GPL-2.0 */", file=f)
>      print("/* Automatically generated TDX global metadata structures. */", file=f)
>      print("#ifndef _X86_VIRT_TDX_AUTO_GENERATED_" + hfileifdef.upper(), file=f)
>      print("#define _X86_VIRT_TDX_AUTO_GENERATED_" + hfileifdef.upper(), file=f)
>      print(file=f)
>      print("#include <linux/types.h>", file=f)
>      print(file=f)
>      for class_name, field_names in TDX_STRUCTS.items():
>          print_class_struct(class_name, [fields[x] for x in field_names], file=f)
>          print(file=f)
>      print_main_struct(file=f)
>      print(file=f)
>      print("#endif", file=f)
> 
> with open(cfile, "w") as f:
>      print("// SPDX-License-Identifier: GPL-2.0", file=f)
>      print("/*", file=f)
>      print(" * Automatically generated functions to read TDX global metadata.", file=f)
>      print(" *", file=f)
>      print(" * This file doesn't compile on its own as it lacks of inclusion", file=f)
>      print(" * of SEAMCALL wrapper primitive which reads global metadata.", file=f)
>      print(" * Include this file to other C file instead.", file=f)
>      print(" */", file=f)
>      for class_name, field_names in TDX_STRUCTS.items():
>          print(file=f)
>          print_class_function(class_name, [fields[x] for x in field_names], file=f)
>      print(file=f)
>      print_main_function(file=f)
> 
> 
> 
> 
> Kai Huang (9):
>    x86/virt/tdx: Rename 'struct tdx_tdmr_sysinfo' to reflect the spec
>      better
>    x86/virt/tdx: Start to track all global metadata in one structure
>    x86/virt/tdx: Use dedicated struct members for PAMT entry sizes
>    x86/virt/tdx: Add missing header file inclusion to local tdx.h
>    x86/virt/tdx: Switch to use auto-generated global metadata reading
>      code
>    x86/virt/tdx: Trim away tail null CMRs
>    x86/virt/tdx: Reduce TDMR's reserved areas by using CMRs to find
>      memory holes
>    x86/virt/tdx: Require the module to assert it has the NO_RBP_MOD
>      mitigation
>    x86/virt/tdx: Print TDX module version
> 
> Paolo Bonzini (1):
>    x86/virt/tdx: Use auto-generated code to read global metadata
> 
>   arch/x86/virt/vmx/tdx/tdx.c                 | 178 ++++++++++++--------
>   arch/x86/virt/vmx/tdx/tdx.h                 |  43 +----
>   arch/x86/virt/vmx/tdx/tdx_global_metadata.c |  89 ++++++++++
>   arch/x86/virt/vmx/tdx/tdx_global_metadata.h |  42 +++++
>   4 files changed, 247 insertions(+), 105 deletions(-)
>   create mode 100644 arch/x86/virt/vmx/tdx/tdx_global_metadata.c
>   create mode 100644 arch/x86/virt/vmx/tdx/tdx_global_metadata.h
> 
> 
> base-commit: 21f0d4005e7eb71b95cf6b55041fd525bdb11c1f


