Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0846939CDF5
	for <lists+kvm@lfdr.de>; Sun,  6 Jun 2021 10:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhFFICC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Jun 2021 04:02:02 -0400
Received: from mga18.intel.com ([134.134.136.126]:50914 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229962AbhFFICB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Jun 2021 04:02:01 -0400
IronPort-SDR: KiJHihMhBMkCykH4riKEVLgMEppE9Y1dSj1MDnXZx7x3X6CUDtUBj3wDKyEqn+ZbCk9a+nZJJx
 KNb27+k1P9cA==
X-IronPort-AV: E=McAfee;i="6200,9189,10006"; a="191820148"
X-IronPort-AV: E=Sophos;i="5.83,252,1616482800"; 
   d="scan'208";a="191820148"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2021 01:00:10 -0700
IronPort-SDR: UzZvoi5xoug672QrL0bBOoKmlBLiVjg2pf7rT90V8+DPr/OAxK/ZpAo2AzaHcMwjPrtF9vZ7wh
 0CNruWiANyaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,252,1616482800"; 
   d="scan'208";a="447154641"
Received: from sunyi-u2010.sh.intel.com ([10.239.48.3])
  by orsmga008.jf.intel.com with ESMTP; 06 Jun 2021 01:00:09 -0700
From:   Yi Sun <yi.sun@intel.com>
To:     nadav.amit@gmail.com, yi.sun@intel.com, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 2/2 v2] x86: Create ISO images according to unittests.cfg
Date:   Sun,  6 Jun 2021 16:00:04 +0800
Message-Id: <20210606080004.1112859-2-yi.sun@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210606080004.1112859-1-yi.sun@intel.com>
References: <20210606080004.1112859-1-yi.sun@intel.com>
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
index 0000000..e55ee9e
--- /dev/null
+++ b/x86/create_iso.sh
@@ -0,0 +1,83 @@
+#!/bin/bash
+set -e
+config_file=$1
+module_file=$2
+
+opts=
+extra_params=" "
+kernel=
+smp=
+testname=
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
+		grub-mkrescue -o ${case_name}.iso build/isofiles 2> /dev/null
+		[ $? == 0 ] && echo "Creating ISO for case: ${case_name}"
+	fi
+}
+
+nline=`wc $config_file | cut -d' ' -f 2`
+
+while read -r line; do
+	if [[ "$line" =~ ^\[(.*)\]$ || $nline == 1 ]]; then
+		rematch=${BASH_REMATCH[1]}
+		if [[ "${testname}" != "" ]]; then
+			create_iso $testname ${kernel}.elf "${extra_params}" $module_file
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

