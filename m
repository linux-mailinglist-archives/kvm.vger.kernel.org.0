Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B9B46B7CF
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 10:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234259AbhLGJsU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 04:48:20 -0500
Received: from mga05.intel.com ([192.55.52.43]:52337 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229881AbhLGJsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 04:48:17 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="323796366"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="323796366"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 01:44:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="515207353"
Received: from sunyi-u2010.sh.intel.com ([10.239.48.3])
  by orsmga008.jf.intel.com with ESMTP; 07 Dec 2021 01:44:38 -0800
From:   Yi Sun <yi.sun@intel.com>
To:     yi.sun@linux.intel.com, yi.sun@intel.com, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH RESEND v3 2/2] x86: Create ISO images according to unittests.cfg
Date:   Tue,  7 Dec 2021 17:44:32 +0800
Message-Id: <20211207094432.189576-3-yi.sun@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207094432.189576-1-yi.sun@intel.com>
References: <20211207094432.189576-1-yi.sun@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create ISO image according to the configure file unittests.cfg,
where describes the parameters of each test case.

The grub.cfg in ios/boot/grub/ looks as following, taking case
'vmx_apicv_test' as an example:

set timeout=0
set default=0

menuentry "vmx.elf" {
    multiboot /boot/vmx.elf apic_reg_virt_test virt_x2apic_mode_test
    module   /boot/module
    boot
}

[1] All parameters are from '-append xxx' in the unittests.cfg.
[2] The file 'module' is a fixed file that can be passed by paramters
of script ./create_iso.sh.

Signed-off-by: Yi Sun <yi.sun@intel.com>

diff --git a/x86/create_iso.sh b/x86/create_iso.sh
new file mode 100755
index 0000000..4fe8e5b
--- /dev/null
+++ b/x86/create_iso.sh
@@ -0,0 +1,112 @@
+#!/bin/bash
+config_file=$1
+module_file=$2
+
+opts=
+extra_params=" "
+kernel=
+smp=
+testname=
+
+dir_x86=`dirname $0`
+[[ ${dir_x86:0:1} != "/" ]] && dir_x86=`pwd`/$dir_x86
+
+usage() {
+	cat << EOF
+Usage: create_iso.sh <configure> [module_file]
+    configure:
+        Usually just pass unittests.cfg to the create_iso.sh.
+
+    module_file:
+        This is optional. You can pass some environment to the kernels
+        The module.file looks as following:
+            NR_CPUS=56
+	    MEMSIZE=4096
+	    TEST_DEVICE=0
+	    BOOTLOADER=1
+EOF
+}
+
+grub_cfg() {
+	local kernel_elf=$1
+	local kernel_para=$2
+	local module_file=$3
+
+	if [[ "${module_file}" != "" ]]; then
+		module_cmd="module   /boot/${module_file}"
+	fi
+
+	cat << EOF
+set timeout=0
+set default=0
+
+menuentry "${kernel_elf}" {
+    multiboot /boot/${kernel_elf} ${kernel_para}
+    ${module_cmd}
+    boot
+}
+EOF
+}
+
+create_iso() {
+	local case_name=$1
+	local kernel_elf=$2
+	local kernel_params=$3
+	local module_file=$4
+
+	if [ -f $kernel_elf ]; then
+		rm -rf build/isofiles
+		mkdir -p build/isofiles/boot/grub
+
+		cp $kernel_elf build/isofiles/boot/
+		[[ -f $module_file ]] && cp $module_file build/isofiles/boot/
+
+		grub_cfg ${kernel_elf##*/} "${kernel_params}" ${module_file##*/} > build/isofiles/boot/grub/grub.cfg
+
+		rm -rf ${testname}.iso
+		grub-mkrescue -o ${dir_x86}/${case_name}.iso build/isofiles >& /dev/null
+		if [ $? == 0 ]; then
+			echo "Creating ISO for case: ${case_name}"
+		else
+			echo "[FAIL] grub-mkrescue: Please install grub-mkrescue and xorriso correctly."
+			exit 1
+		fi
+	fi
+}
+
+if [[ "$config_file" == "" || ! -f $config_file ]]; then
+	echo "[FAIL] A configure file is required, usually pass unittests.cfg as the first parameter"
+	usage
+	exit 1
+fi
+
+nline=`wc $config_file | cut -d' ' -f 2`
+
+while read -r line; do
+	if [[ "$line" =~ ^\[(.*)\]$ || $nline == 1 ]]; then
+		rematch=${BASH_REMATCH[1]}
+		if [[ "${testname}" != "" ]]; then
+			create_iso $testname ${dir_x86}/${kernel}.elf "${extra_params}" $module_file
+		fi
+		testname=$rematch
+		extra_params=" "
+		smp=1
+		kernel=""
+		opts=""
+		groups=""
+	elif [[ $line =~ ^file\ *=\ *(.*)\.flat$ ]]; then
+		kernel=${BASH_REMATCH[1]}
+	elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
+		smp=${BASH_REMATCH[1]}
+	elif [[ $line =~ ^extra_params\ *=\ *(.*)$ ]]; then
+		opts=${BASH_REMATCH[1]}
+		if [[ "$opts" =~ .*append\ (.*)$ ]]; then
+			extra_params=${BASH_REMATCH[1]}
+			extra_params=`echo $extra_params | sed 's/\"//g'`
+		fi
+	elif [[ $line =~ ^groups\ *=\ *(.*)$ ]]; then
+		groups=${BASH_REMATCH[1]}
+	fi
+	(( nline -= 1))
+
+done < $config_file
-- 
2.27.0

