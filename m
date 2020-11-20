Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C507B2BAA3F
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 13:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgKTMe3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 07:34:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727883AbgKTMe2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 07:34:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605875666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OOLIin4v2N9YnANejor4CHwzXzXg8lZQrdWXMbglVRM=;
        b=hwuvbxFlRB3UUXK5KLCTZKrrUvES4PAq+zDGAEeu94w/ioMenxBE+y5sCMbbIt5kHKWf7l
        zhgPHPfW+tbiji0l+6F1Syop3zg7lOlCDh9VQqmkl4T9PEzRHYRwvGRYI43kq/xdH7mU52
        9hV9qVhfEYua7j5u6HqWV8TywZsKn+U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-RdYy3KTyNcajujCIwg3S-w-1; Fri, 20 Nov 2020 07:34:23 -0500
X-MC-Unique: RdYy3KTyNcajujCIwg3S-w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E54D801B17;
        Fri, 20 Nov 2020 12:34:22 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.104])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D091110016F4;
        Fri, 20 Nov 2020 12:34:17 +0000 (UTC)
Date:   Fri, 20 Nov 2020 13:34:14 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Auger Eric <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests] its-migration segmentation fault
Message-ID: <20201120123414.bolwl6pym4iy3m6x@kamzik.brq.redhat.com>
References: <d18ab1d5-4eff-43e1-4a5b-5373b67e4286@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d18ab1d5-4eff-43e1-4a5b-5373b67e4286@arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 20, 2020 at 12:02:10PM +0000, Alexandru Elisei wrote:
> When running all the tests with taskset -c 0-3 ./run_tests.sh on a rockpro64 (on
> the Cortex-a53 cores) the its-migration test hangs. In the log file I see:
> 
> run_migration timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
> -nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
> virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd
> -device pci-testdev -display none -serial stdio -kernel arm/gic.flat -smp 6
> -machine gic-version=3 -append its-migration # -initrd /tmp/tmp.OrlQiorBpY
> ITS: MAPD devid=2 size = 0x8 itt=0x40420000 valid=1
> ITS: MAPD devid=7 size = 0x8 itt=0x40430000 valid=1
> MAPC col_id=3 target_addr = 0x30000 valid=1
> MAPC col_id=2 target_addr = 0x20000 valid=1
> INVALL col_id=2
> INVALL col_id=3
> MAPTI dev_id=2 event_id=20 -> phys_id=8195, col_id=3
> MAPTI dev_id=7 event_id=255 -> phys_id=8196, col_id=2
> Now migrate the VM, then press a key to continue...
> scripts/arch-run.bash: line 103: 48549 Done                    echo '{ "execute":
> "qmp_capabilities" }{ "execute":' "$2" '}'
>      48550 Segmentation fault      (core dumped) | ncat -U $1
> scripts/arch-run.bash: line 103: 48568 Done                    echo '{ "execute":
> "qmp_capabilities" }{ "execute":' "$2" '}'
>      48569 Segmentation fault      (core dumped) | ncat -U $1
> scripts/arch-run.bash: line 103: 48583 Done                    echo '{ "execute":
> "qmp_capabilities" }{ "execute":' "$2" '}'
>      48584 Segmentation fault      (core dumped) | ncat -U $1
> [..]
> scripts/arch-run.bash: line 103: 49414 Done                    echo '{ "execute":
> "qmp_capabilities" }{ "execute":' "$2" '}'
>      49415 Segmentation fault      (core dumped) | ncat -U $1
> qemu-system-aarch64: terminating on signal 15 from pid 48496 (timeout)
> qemu-system-aarch64: terminating on signal 15 from pid 48504 (timeout)
> scripts/arch-run.bash: line 103: 49430 Done                    echo '{ "execute":
> "qmp_capabilities" }{ "execute":' "$2" '}'
>      49431 Segmentation fault      (core dumped) | ncat -U $1
> scripts/arch-run.bash: line 103: 49445 Done                    echo '{ "execute":
> "qmp_capabilities" }{ "execute":' "$2" '}'
> [..]

Is your ncat segfaulting? It looks like it from this output. Have you
tried running your ncat with a UNIX socket independently of this test?

Is this the first time you've tried this test in this environment, or
is this a regression for you?

> 
> If I run the test manually:
> 
> $ taskset -c 0-3 ./arm-run arm/gic.flat -smp 4 -machine gic-version=3 -append
> 'its-migration'

This won't work because we need run_tests.sh to setup the run_migration()
call. The only ways to run migration tests separately are

 $ ./run_tests.sh its-migration

and

 $ tests/its-migration

For the second one you need to do 'make standalone' first.


> 
> /usr/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host,accel=kvm
> -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev
> testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
> arm/gic.flat -smp 4 -machine gic-version=3 -append its-migration # -initrd
> /tmp/tmp.OtsTj3QD4J
> ITS: MAPD devid=2 size = 0x8 itt=0x403a0000 valid=1
> ITS: MAPD devid=7 size = 0x8 itt=0x403b0000 valid=1
> MAPC col_id=3 target_addr = 0x30000 valid=1
> MAPC col_id=2 target_addr = 0x20000 valid=1
> INVALL col_id=2
> INVALL col_id=3
> MAPTI dev_id=2 event_id=20 -> phys_id=8195, col_id=3
> MAPTI dev_id=7 event_id=255 -> phys_id=8196, col_id=2
> Now migrate the VM, then press a key to continue...
> 
> And the test hangs here after I press a key.

The test doesn't get your input because of the '</dev/null' in run_qemu(),
which ./arm-run calls. So it's not hanging it's just waiting forever on
the key press.

Thanks,
drew

> 
> Package versions:
> 
> $ ncat --version
> Ncat: Version 7.91 ( https://nmap.org/ncat )
> 
> $ /usr/bin/qemu-system-aarch64 --version
> QEMU emulator version 5.1.0
> Copyright (c) 2003-2020 Fabrice Bellard and the QEMU Project developers
> 
> $ uname -a
> Linux rockpro 5.10.0-rc4 #33 SMP PREEMPT Thu Nov 19 15:58:57 GMT 2020 aarch64
> GNU/Linux
> 
> Thanks,
> 
> Alex
> 

