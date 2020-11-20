Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BB62BA9BB
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 13:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbgKTMA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 07:00:56 -0500
Received: from foss.arm.com ([217.140.110.172]:48420 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727858AbgKTMA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Nov 2020 07:00:56 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9DF6811D4;
        Fri, 20 Nov 2020 04:00:55 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 107DC3F718;
        Fri, 20 Nov 2020 04:00:54 -0800 (PST)
To:     kvm@vger.kernel.org,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Andrew Jones <drjones@redhat.com>,
        Auger Eric <eric.auger@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvm-unit-tests] its-migration segmentation fault
Message-ID: <d18ab1d5-4eff-43e1-4a5b-5373b67e4286@arm.com>
Date:   Fri, 20 Nov 2020 12:02:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running all the tests with taskset -c 0-3 ./run_tests.sh on a rockpro64 (on
the Cortex-a53 cores) the its-migration test hangs. In the log file I see:

run_migration timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd
-device pci-testdev -display none -serial stdio -kernel arm/gic.flat -smp 6
-machine gic-version=3 -append its-migration # -initrd /tmp/tmp.OrlQiorBpY
ITS: MAPD devid=2 size = 0x8 itt=0x40420000 valid=1
ITS: MAPD devid=7 size = 0x8 itt=0x40430000 valid=1
MAPC col_id=3 target_addr = 0x30000 valid=1
MAPC col_id=2 target_addr = 0x20000 valid=1
INVALL col_id=2
INVALL col_id=3
MAPTI dev_id=2 event_id=20 -> phys_id=8195, col_id=3
MAPTI dev_id=7 event_id=255 -> phys_id=8196, col_id=2
Now migrate the VM, then press a key to continue...
scripts/arch-run.bash: line 103: 48549 Done                    echo '{ "execute":
"qmp_capabilities" }{ "execute":' "$2" '}'
     48550 Segmentation fault      (core dumped) | ncat -U $1
scripts/arch-run.bash: line 103: 48568 Done                    echo '{ "execute":
"qmp_capabilities" }{ "execute":' "$2" '}'
     48569 Segmentation fault      (core dumped) | ncat -U $1
scripts/arch-run.bash: line 103: 48583 Done                    echo '{ "execute":
"qmp_capabilities" }{ "execute":' "$2" '}'
     48584 Segmentation fault      (core dumped) | ncat -U $1
[..]
scripts/arch-run.bash: line 103: 49414 Done                    echo '{ "execute":
"qmp_capabilities" }{ "execute":' "$2" '}'
     49415 Segmentation fault      (core dumped) | ncat -U $1
qemu-system-aarch64: terminating on signal 15 from pid 48496 (timeout)
qemu-system-aarch64: terminating on signal 15 from pid 48504 (timeout)
scripts/arch-run.bash: line 103: 49430 Done                    echo '{ "execute":
"qmp_capabilities" }{ "execute":' "$2" '}'
     49431 Segmentation fault      (core dumped) | ncat -U $1
scripts/arch-run.bash: line 103: 49445 Done                    echo '{ "execute":
"qmp_capabilities" }{ "execute":' "$2" '}'
[..]

If I run the test manually:

$ taskset -c 0-3 ./arm-run arm/gic.flat -smp 4 -machine gic-version=3 -append
'its-migration'

/usr/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host,accel=kvm
-cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/gic.flat -smp 4 -machine gic-version=3 -append its-migration # -initrd
/tmp/tmp.OtsTj3QD4J
ITS: MAPD devid=2 size = 0x8 itt=0x403a0000 valid=1
ITS: MAPD devid=7 size = 0x8 itt=0x403b0000 valid=1
MAPC col_id=3 target_addr = 0x30000 valid=1
MAPC col_id=2 target_addr = 0x20000 valid=1
INVALL col_id=2
INVALL col_id=3
MAPTI dev_id=2 event_id=20 -> phys_id=8195, col_id=3
MAPTI dev_id=7 event_id=255 -> phys_id=8196, col_id=2
Now migrate the VM, then press a key to continue...

And the test hangs here after I press a key.

Package versions:

$ ncat --version
Ncat: Version 7.91 ( https://nmap.org/ncat )

$ /usr/bin/qemu-system-aarch64 --version
QEMU emulator version 5.1.0
Copyright (c) 2003-2020 Fabrice Bellard and the QEMU Project developers

$ uname -a
Linux rockpro 5.10.0-rc4 #33 SMP PREEMPT Thu Nov 19 15:58:57 GMT 2020 aarch64
GNU/Linux

Thanks,

Alex

