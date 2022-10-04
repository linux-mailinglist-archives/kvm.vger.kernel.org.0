Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE3D5F40EB
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 12:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiJDKhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 06:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiJDKhx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 06:37:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0CD4DB50
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 03:37:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00CBA61342
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 10:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A43FC433C1;
        Tue,  4 Oct 2022 10:37:50 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="I+yr63xM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1664879868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+uuXyz6ODMCn8eE/GSnCUiibQIaNdSdi0qY50roQ2TY=;
        b=I+yr63xM6MVGbU/ja/1NoHxtBP1PUMlIoOYTgwPsGHRtNZOlO03qK1aHf5Jwl0qVrixt05
        QynFlZexNrSPne85nzKqPpqEdqXVq9/YR9lOmXAfwdByPpPVB3gW+SFZpDHc9TbZCZkEKy
        kmmcUGT/wWd8TnMlAX6uV8kf8vHrzvM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 869645c6 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 4 Oct 2022 10:37:48 +0000 (UTC)
Date:   Tue, 4 Oct 2022 12:37:44 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Cc:     qemu-devel@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        kvm-devel <kvm@vger.kernel.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Subject: Re: [PATCH v2] mips/malta: pass RNG seed to to kernel via env var
Message-ID: <YzwM+KhUG0bg+P2e@zx2c4.com>
References: <YziPyCqwl5KIE2cf@zx2c4.com>
 <20221003103627.947985-1-Jason@zx2c4.com>
 <b529059a-7819-e49d-e4dc-7ae79ee21ec5@amsat.org>
 <CAHmME9pUuduiEcmi2xaY3cd87D_GNX1bkVeXNqVq6AL_e=Kt+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHmME9pUuduiEcmi2xaY3cd87D_GNX1bkVeXNqVq6AL_e=Kt+Q@mail.gmail.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

And just to give you some idea that this truly is possible from firmware
and I'm not just making it up, consider this patch to U-Boot:

u-boot:
diff --git a/arch/mips/lib/bootm.c b/arch/mips/lib/bootm.c
index cab8da4860..27f3ee68c0 100644
--- a/arch/mips/lib/bootm.c
+++ b/arch/mips/lib/bootm.c
@@ -211,6 +211,8 @@ static void linux_env_legacy(bootm_headers_t *images)
 		sprintf(env_buf, "%un8r", gd->baudrate);
 		linux_env_set("modetty0", env_buf);
 	}
+
+	linux_env_set("rngseed", "4142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f60");
 }

 static int boot_reloc_fdt(bootm_headers_t *images)

Now, obviously that seed should be generated from some real method (a
seed file in flash, a hardware RNG U-Boot knows about, etc), but for the
purposes of showing that this is how things are passed to Linux, the
above suffices. To show that this ingested by Linux, let's then add:

linux:
diff --git a/drivers/char/random.c b/drivers/char/random.c
index a007e3dad80f..05d5b8bcb7e9 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -890,6 +890,7 @@ EXPORT_SYMBOL_GPL(add_hwgenerator_randomness);
  */
 void __init add_bootloader_randomness(const void *buf, size_t len)
 {
+	print_hex_dump(KERN_ERR, "SARU seed: ", DUMP_PREFIX_OFFSET, 16, 1, buf, len, 1);
 	mix_pool_bytes(buf, len);
 	if (trust_bootloader)
 		credit_init_bits(len * 8);

And now let's boot it:

$ qemu-system-mips -nographic -bios ./u-boot.bin -m 1G -netdev user,tftp=arch/mips/boot,bootfile=/uImage,id=net -device pcnet,netdev=net

U-Boot 2022.10-dirty (Oct 04 2022 - 12:31:05 +0200)

Board: MIPS Malta CoreLV
DRAM:  256 MiB
Core:  3 devices, 3 uclasses, devicetree: separate
PCI: Failed autoconfig bar 10
PCI: Failed autoconfig bar 14
PCI: Failed autoconfig bar 18
PCI: Failed autoconfig bar 1c
PCI: Failed autoconfig bar 20
PCI: Failed autoconfig bar 24
Flash: 4 MiB
Loading Environment from Flash... *** Warning - bad CRC, using default environment

In:    serial@3f8
Out:   serial@3f8
Err:   serial@3f8
Net:   eth0: pcnet#0
IDE:   Bus 0: not available
malta # bootp
BOOTP broadcast 1
DHCP client bound to address 10.0.2.15 (1 ms)
Using pcnet#0 device
TFTP from server 10.0.2.2; our IP address is 10.0.2.15
Filename '/uImage'.
Load address: 0x81000000
Loading: #################################################################
         #################################################################
         #################################################################
         #################################################################
         ####################################################
         169.6 MiB/s
done
Bytes transferred = 4446702 (43d9ee hex)
malta # bootm
## Booting kernel from Legacy Image at 81000000 ...
   Image Name:   Linux-6.0.0-rc6+
   Created:      2022-10-04  10:23:27 UTC
   Image Type:   MIPS Linux Kernel Image (gzip compressed)
   Data Size:    4446638 Bytes = 4.2 MiB
   Load Address: 80100000
   Entry Point:  8054939c
   Verifying Checksum ... OK
   Uncompressing Kernel Image
[    0.000000] Linux version 6.0.0-rc6+ (zx2c4@thinkpad) (mips-linux-musl-gcc (GCC) 11.2.1 20211120, GNU ld (GNU Binutils) 2.37) #5 SMP PREEMPT Fri Jun 5 15:58:00 CEST 2015
[    0.000000] earlycon: uart8250 at I/O port 0x3f8 (options '38400n8')
[    0.000000] printk: bootconsole [uart8250] enabled
[    0.000000] Config serial console: console=ttyS0,38400n8r
[    0.000000] MIPS CPS SMP unable to proceed without a CM
[    0.000000] CPU0 revision is: 00019300 (MIPS 24Kc)
[    0.000000] FPU revision is: 00739300
[    0.000000] OF: fdt: No chosen node found, continuing without
[    0.000000] OF: fdt: Ignoring memory range 0x100000000 - 0x17ffff000
[    0.000000] MIPS: machine is mti,malta
[    0.000000] Software DMA cache coherency enabled
[    0.000000] Initrd not found or empty - disabling initrd
[    0.000000] Primary instruction cache 2kB, VIPT, 2-way, linesize 16 bytes.
[    0.000000] Primary data cache 2kB, 2-way, VIPT, no aliases, linesize 16 bytes
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000000000-0x0000000000ffffff]
[    0.000000]   Normal   [mem 0x0000000001000000-0x000000001fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000000000-0x000000000fffffff]
[    0.000000]   node   0: [mem 0x0000000090000000-0x00000000ffffefff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x00000000ffffefff]
[    0.000000] SARU seed: 00000000: 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f 50  ABCDEFGHIJKLMNOP
[    0.000000] SARU seed: 00000010: 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60  QRSTUVWXYZ[\]^_`
[    0.000000] random: crng init done
...

So, as you can see, it works perfectly. Thus, setting this in QEMU
follows *exactly* *the* *same* *pattern* as every other architecture
that allows for this kind of mechanism. There's nothing weird or unusual
or out of place happening here.

Hope this helps clarify.

Regards,
Jason
