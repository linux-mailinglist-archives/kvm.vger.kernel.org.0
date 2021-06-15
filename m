Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9DFC3A74FD
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 05:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhFODXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 23:23:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44432 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbhFODXY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 23:23:24 -0400
Received: from mail-pf1-f198.google.com ([209.85.210.198])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1lszde-0006MA-QH
        for kvm@vger.kernel.org; Tue, 15 Jun 2021 03:21:18 +0000
Received: by mail-pf1-f198.google.com with SMTP id 9-20020a6217090000b02902ed4caf9377so9429930pfx.19
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 20:21:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y27UbtFOQ8c39eVLx06R3uWLnW6dhZQzs0wPAm5K83o=;
        b=PkqOCS6qH2Qo0P3Kqw2kdpKVan1oef78YTgF0WRWsDi8Y829v9n/m7fYr7i2RRczCt
         AomZIUkiqoGXMyiPTsosxdxMM6VT6eZJkyx8H9iocptkIPO5G3Mc4sJXkgzvQJh0oDN9
         e1oyKCy9ADNJvUwmDAuFH3ZU6MSxDyYlOd1GlYz5U0owsSHRjFzjFwuiKAHpVCg6XVxQ
         Vj9uBrwhJJDiYjmwsmxcMEMfT+Xjy691muPnCJWunQ/qssMbAlUptAMtslPH0TQpKkxJ
         5La67yTMeVLZib8OLeI11Wi+B3i+29ScyYA68IorwBBsncyOg0E7i+goHST2Hnjgzrm/
         N18A==
X-Gm-Message-State: AOAM530a91L87fJSbzrpPPzh5XU0gdXqAKwBlsXOXCuPLZgzZn8CpigR
        P/kgHdKHhTsdskJsPuGRaTa8Vl2/hqXvSd3ji4n0r+QF06/l8KEwfPw0zRWlPSC9npD9fYXjxFi
        nEp0U34zk337OLRJNcONLed8arqJfDP5f379xxKX7j3oS
X-Received: by 2002:a62:3344:0:b029:25e:a0a8:1c51 with SMTP id z65-20020a6233440000b029025ea0a81c51mr2260511pfz.58.1623727277195;
        Mon, 14 Jun 2021 20:21:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzexSvriwW6xx6lNJddJMvfRC0bGnFI1v9u8YQnjAImetW0yirOAeb6eRv6xa0GzZf8Zx3jXavguowXoco3M7U=
X-Received: by 2002:a62:3344:0:b029:25e:a0a8:1c51 with SMTP id
 z65-20020a6233440000b029025ea0a81c51mr2260481pfz.58.1623727276783; Mon, 14
 Jun 2021 20:21:16 -0700 (PDT)
MIME-Version: 1.0
References: <d18ab1d5-4eff-43e1-4a5b-5373b67e4286@arm.com> <20201120123414.bolwl6pym4iy3m6x@kamzik.brq.redhat.com>
In-Reply-To: <20201120123414.bolwl6pym4iy3m6x@kamzik.brq.redhat.com>
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Tue, 15 Jun 2021 11:21:05 +0800
Message-ID: <CAMy_GT9Y1JNyh5GkZm31RQ6nX8Jv9qHFRN2KeOe01GOyk2ifQg@mail.gmail.com>
Subject: Re: [kvm-unit-tests] its-migration segmentation fault
To:     Andrew Jones <drjones@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Auger Eric <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 20, 2020 at 8:35 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Fri, Nov 20, 2020 at 12:02:10PM +0000, Alexandru Elisei wrote:
> > When running all the tests with taskset -c 0-3 ./run_tests.sh on a rockpro64 (on
> > the Cortex-a53 cores) the its-migration test hangs. In the log file I see:
> >
> > run_migration timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
> > -nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
> > virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd
> > -device pci-testdev -display none -serial stdio -kernel arm/gic.flat -smp 6
> > -machine gic-version=3 -append its-migration # -initrd /tmp/tmp.OrlQiorBpY
> > ITS: MAPD devid=2 size = 0x8 itt=0x40420000 valid=1
> > ITS: MAPD devid=7 size = 0x8 itt=0x40430000 valid=1
> > MAPC col_id=3 target_addr = 0x30000 valid=1
> > MAPC col_id=2 target_addr = 0x20000 valid=1
> > INVALL col_id=2
> > INVALL col_id=3
> > MAPTI dev_id=2 event_id=20 -> phys_id=8195, col_id=3
> > MAPTI dev_id=7 event_id=255 -> phys_id=8196, col_id=2
> > Now migrate the VM, then press a key to continue...
> > scripts/arch-run.bash: line 103: 48549 Done                    echo '{ "execute":
> > "qmp_capabilities" }{ "execute":' "$2" '}'
> >      48550 Segmentation fault      (core dumped) | ncat -U $1
> > scripts/arch-run.bash: line 103: 48568 Done                    echo '{ "execute":
> > "qmp_capabilities" }{ "execute":' "$2" '}'
> >      48569 Segmentation fault      (core dumped) | ncat -U $1
> > scripts/arch-run.bash: line 103: 48583 Done                    echo '{ "execute":
> > "qmp_capabilities" }{ "execute":' "$2" '}'
> >      48584 Segmentation fault      (core dumped) | ncat -U $1
> > [..]
> > scripts/arch-run.bash: line 103: 49414 Done                    echo '{ "execute":
> > "qmp_capabilities" }{ "execute":' "$2" '}'
> >      49415 Segmentation fault      (core dumped) | ncat -U $1
> > qemu-system-aarch64: terminating on signal 15 from pid 48496 (timeout)
> > qemu-system-aarch64: terminating on signal 15 from pid 48504 (timeout)
> > scripts/arch-run.bash: line 103: 49430 Done                    echo '{ "execute":
> > "qmp_capabilities" }{ "execute":' "$2" '}'
> >      49431 Segmentation fault      (core dumped) | ncat -U $1
> > scripts/arch-run.bash: line 103: 49445 Done                    echo '{ "execute":
> > "qmp_capabilities" }{ "execute":' "$2" '}'
> > [..]
>
> Is your ncat segfaulting? It looks like it from this output. Have you
> tried running your ncat with a UNIX socket independently of this test?
>
> Is this the first time you've tried this test in this environment, or
> is this a regression for you?
>
> >
> > If I run the test manually:
> >
> > $ taskset -c 0-3 ./arm-run arm/gic.flat -smp 4 -machine gic-version=3 -append
> > 'its-migration'
>
> This won't work because we need run_tests.sh to setup the run_migration()
> call. The only ways to run migration tests separately are
>
>  $ ./run_tests.sh its-migration
>
> and
>
>  $ tests/its-migration
>
> For the second one you need to do 'make standalone' first.
>
>
> >
> > /usr/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host,accel=kvm
> > -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev
> > testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
> > arm/gic.flat -smp 4 -machine gic-version=3 -append its-migration # -initrd
> > /tmp/tmp.OtsTj3QD4J
> > ITS: MAPD devid=2 size = 0x8 itt=0x403a0000 valid=1
> > ITS: MAPD devid=7 size = 0x8 itt=0x403b0000 valid=1
> > MAPC col_id=3 target_addr = 0x30000 valid=1
> > MAPC col_id=2 target_addr = 0x20000 valid=1
> > INVALL col_id=2
> > INVALL col_id=3
> > MAPTI dev_id=2 event_id=20 -> phys_id=8195, col_id=3
> > MAPTI dev_id=7 event_id=255 -> phys_id=8196, col_id=2
> > Now migrate the VM, then press a key to continue...
> >
> > And the test hangs here after I press a key.
>
> The test doesn't get your input because of the '</dev/null' in run_qemu(),
> which ./arm-run calls. So it's not hanging it's just waiting forever on
> the key press.
Hello Andrew,
We have found this waiting for key press issue on our side as well
[1], the test will fail with TIMEOUT, it looks like it's not getting
my input like you mentioned here.
I would like to ask what is the expected behaviour of these migration
related tests (its-pending-migration / its-migration /
its-migrate-unmapped-collection)? Should they pass right after the
tester hit a key?
Also, if these test would require user interaction, should they be
moved to some special group like 'nodefault' to prevent it from
failing with timeout in automated tests?

I tried to remove '</dev/null' in 'errors=$("${@}" $INITRD </dev/null
2> >(tee /dev/stderr) > /dev/fd/$stdout)' from script/arch-run.bash
and run it again, and found out that if you wait to see that 'Now
migrate the VM, then press a key to continue...' prompt, it's too late
for the test to catch your key press. You will have to press any key
right after the test started. However although the test will pass, it
won't be terminated properly but keep complaining about "Ncat:
Connection refused." until I hit ctrl + c. Not sure if this is
expected?

$ uname -a
Linux kuzzle 5.11.0-18-generic #19-Ubuntu SMP Fri May 7 14:21:20 UTC
2021 aarch64 aarch64 aarch64 GNU/Linux
$ sudo ./its-migration
BUILD_HEAD=90a7d30e
k (my key press)
run_migration timeout -k 1s --foreground 90s
/usr/bin/qemu-system-aarch64 -nodefaults -machine
virt,gic-version=host,accel=kvm -cpu host -device virtio-serial-device
-device virtconsole,chardev=ctd -chardev testdev,id=ctd -device
pci-testdev -display none -serial stdio -kernel /tmp/tmp.HhCjbIcns7
-smp 32 -machine gic-version=3 -append its-migration # -initrd
/tmp/tmp.AyirrSboiF
ITS: MAPD devid=2 size = 0x8 itt=0x408d0000 valid=1
ITS: MAPD devid=7 size = 0x8 itt=0x408e0000 valid=1
MAPC col_id=3 target_addr = 0x30000 valid=1
MAPC col_id=2 target_addr = 0x20000 valid=1
INVALL col_id=2
INVALL col_id=3
MAPTI dev_id=2 event_id=20 -> phys_id=8195, col_id=3
MAPTI dev_id=7 event_id=255 -> phys_id=8196, col_id=2
Now migrate the VM, then press a key to continue...
INFO: gicv3: its-migration: Migration complete
INT dev_id=2 event_id=20
PASS: gicv3: its-migration: dev2/eventid=20 triggers LPI 8195 on PE #3
after migration
INT dev_id=7 event_id=255
PASS: gicv3: its-migration: dev7/eventid=255 triggers LPI 8196 on PE
#2 after migration
SUMMARY: 2 tests
Ncat: Connection refused.
Ncat: Connection refused.
Ncat: Connection refused.

Ncat: Version 7.80

Thanks!
PHLin

[1] https://bugs.launchpad.net/ubuntu-kernel-tests/+bug/1931680

>
> Thanks,
> drew
>
> >
> > Package versions:
> >
> > $ ncat --version
> > Ncat: Version 7.91 ( https://nmap.org/ncat )
> >
> > $ /usr/bin/qemu-system-aarch64 --version
> > QEMU emulator version 5.1.0
> > Copyright (c) 2003-2020 Fabrice Bellard and the QEMU Project developers
> >
> > $ uname -a
> > Linux rockpro 5.10.0-rc4 #33 SMP PREEMPT Thu Nov 19 15:58:57 GMT 2020 aarch64
> > GNU/Linux
> >
> > Thanks,
> >
> > Alex
> >
>
