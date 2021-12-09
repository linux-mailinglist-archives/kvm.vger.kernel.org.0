Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DCE46E84F
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 13:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237246AbhLIMX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 07:23:58 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:45508 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233686AbhLIMX5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 07:23:57 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B7A291F37D;
        Thu,  9 Dec 2021 12:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1639052423;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=qi8ZoK8f8gPDnzmEmrKOIb52wbwmYXcQJdNvNkryX1Q=;
        b=ll0amWt1Q+ikTxxelRKVDZcLKFC9yGD4S8zTE2LrieQwfEGK9Uj0e0RJ9x3Hcnle2TzFde
        fSCR0ObkzlK9wJMJ7vFgtRYVYnuT3fIRynCp2McbJr/gIqkr4PczQ1vMaU4h/S0f+J7DAO
        KKvVHIhB2KQ6GPMAoecAgptGiJ7MyX0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1639052423;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=qi8ZoK8f8gPDnzmEmrKOIb52wbwmYXcQJdNvNkryX1Q=;
        b=l5HJQnTJidxiMurMgt9/auTdtfLp07wMGhxNKRYKroXx+oug64fuDQdsmlgrkid+2xpy9K
        qw+wi1GI0LQmv2AA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7F57813B2D;
        Thu,  9 Dec 2021 12:20:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qkZJHYf0sWEHYQAAMHmgww
        (envelope-from <pvorel@suse.cz>); Thu, 09 Dec 2021 12:20:23 +0000
Date:   Thu, 9 Dec 2021 13:20:21 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     linux-perf-users@vger.kernel.org
Cc:     ltp@lists.linux.it, Cyril Hrubis <chrubis@suse.cz>,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org
Subject: LTP test perf_event_open02.c: possible rounding issue on aarch64 KVM
Message-ID: <YbH0hQbQw3KNSLOQ@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I have problem with LTP test perf_event_open02.c [1] on QEMU using KVM on
openSUSE aarch64 kernel 5.15.5-1-default (not much different from stable ke=
rnel
=66rom kernel.org):

# /opt/ltp/testcases/bin/perf_event_open02
=2E..
perf_event_open02.c:104: TINFO: bench_work estimated loops =3D 8083 in 500 =
ms
perf_event_open02.c:149: TINFO: [0] value:2425293761 time_enabled:749092800=
 time_running:749092800
perf_event_open02.c:149: TINFO: [1] value:2425287027 time_enabled:749141475=
 time_running:749141475
perf_event_open02.c:149: TINFO: [2] value:2433046583 time_enabled:757346300=
 time_running:757346300
perf_event_open02.c:149: TINFO: [3] value:2432771537 time_enabled:753369300=
 time_running:753369300
perf_event_open02.c:149: TINFO: [4] value:2432551620 time_enabled:753784075=
 time_running:753784075
perf_event_open02.c:149: TINFO: [5] value:2432386104 time_enabled:753481750=
 time_running:753481750
perf_event_open02.c:149: TINFO: [6] value:2095086137 time_enabled:768866050=
 time_running:660021525
perf_event_open02.c:308: TINFO: nhw: 6, overall task clock: 4098138525
perf_event_open02.c:309: TINFO: hw sum: 116450294745, task clock sum: 24589=
636350
perf_event_open02.c:321: TINFO: ratio: 6.000196
perf_event_open02.c:323: TFAIL: test failed (ratio was greater than 6)
=2E..

The test tries to assert the precision of hardware counters (using struct
perf_event_attr hw_event.type =3D PERF_TYPE_HARDWARE), but sometimes it fai=
ls with
slight overrun. We suppose that this is a rounding error, but it'd be nice =
to
get this confirmed from kernel developers.

Related kernel setup (or you need to know something else)
grep PERF_EVENTS config-5.15.5-1-default # aarch64
CONFIG_HAVE_PERF_EVENTS=3Dy
CONFIG_PERF_EVENTS=3Dy
CONFIG_HW_PERF_EVENTS=3Dy

Test is running inside testing framework with this setup:
qemu-system-aarch64 -device virtio-gpu-pci -only-migratable -chardev ringbu=
f,id=3Dserial0,logfile=3Dserial0,logappend=3Don -serial chardev:serial0 -au=
diodev none,id=3Dsnd0 -device intel-hda -device hda-output,audiodev=3Dsnd0 =
-m 2048 -machine virt,gic-version=3Dhost -cpu host -mem-prealloc -mem-path =
/dev/hugepages/ -netdev user,id=3Dqanet0 -device virtio-net,netdev=3Dqanet0=
,mac=3D52:54:00:12:34:56 -object rng-random,filename=3D/dev/urandom,id=3Drn=
g0 -device virtio-rng-pci,rng=3Drng0 -boot menu=3Don,splash-time=3D5000 -de=
vice nec-usb-xhci -device usb-tablet -device usb-kbd -smp 2 -enable-kvm -no=
-shutdown -vnc :97,share=3Dforce-shared -device virtio-serial -chardev pipe=
,id=3Dvirtio_console,path=3Dvirtio_console,logfile=3Dvirtio_console.log,log=
append=3Don -device virtconsole,chardev=3Dvirtio_console,name=3Dorg.openqa.=
console.virtio_console -chardev pipe,id=3Dvirtio_console1,path=3Dvirtio_con=
sole1,logfile=3Dvirtio_console1.log,logappend=3Don -device virtconsole,char=
dev=3Dvirtio_console1,name=3Dorg.openqa.console.virtio_console1 -chardev so=
cket,path=3Dqmp_socket,server=3Don,wait=3Doff,id=3Dqmp_socket,logfile=3Dqmp=
_socket.log,logappend=3Don -qmp chardev:qmp_socket -S -device virtio-scsi-p=
ci,id=3Dscsi0 -blockdev driver=3Dfile,node-name=3Dhd0-overlay0-file,filenam=
e=3D/var/lib/openqa/pool/7/raid/hd0-overlay0,cache.no-flush=3Don -blockdev =
driver=3Dqcow2,node-name=3Dhd0-overlay0,file=3Dhd0-overlay0-file,cache.no-f=
lush=3Don -device virtio-blk-device,id=3Dhd0-device,drive=3Dhd0-overlay0,bo=
otindex=3D0,serial=3Dhd0 -blockdev driver=3Dfile,node-name=3Dcd0-overlay0-f=
ile,filename=3D/var/lib/openqa/pool/7/raid/cd0-overlay0,cache.no-flush=3Don=
 -blockdev driver=3Dqcow2,node-name=3Dcd0-overlay0,file=3Dcd0-overlay0-file=
,cache.no-flush=3Don -device scsi-cd,id=3Dcd0-device,drive=3Dcd0-overlay0,s=
erial=3Dcd0 -drive id=3Dpflash-code-overlay0,if=3Dpflash,file=3D/var/lib/op=
enqa/pool/7/raid/pflash-code-overlay0,unit=3D0,readonly=3Don -drive id=3Dpf=
lash-vars-overlay0,if=3Dpflash,file=3D/var/lib/openqa/pool/7/raid/pflash-va=
rs-overlay0,unit=3D1

Running the same OS and kernel (aarch64 JeOS Tumbleweed 20211202) on RPI it=
's working:
perf_event_open02.c:104: TINFO: bench_work estimated loops =3D 3601 in 500 =
ms
perf_event_open02.c:149: TINFO: [0] value:1080601748 time_enabled:480527015=
 time_running:480527015
perf_event_open02.c:149: TINFO: [1] value:1080599535 time_enabled:480540573=
 time_running:480540573
perf_event_open02.c:149: TINFO: [2] value:1080592770 time_enabled:480533868=
 time_running:480533868
perf_event_open02.c:149: TINFO: [3] value:1080607121 time_enabled:480571573=
 time_running:480571573
perf_event_open02.c:149: TINFO: [4] value:1080598264 time_enabled:480568330=
 time_running:480568330
perf_event_open02.c:149: TINFO: [5] value:1080608798 time_enabled:480600001=
 time_running:480600001
perf_event_open02.c:149: TINFO: [6] value:923390393 time_enabled:480919479 =
time_running:410947611
perf_event_open02.c:308: TINFO: nhw: 6, overall task clock: 4990107074
perf_event_open02.c:309: TINFO: hw sum: 51868804135, task clock sum: 299406=
16417
perf_event_open02.c:321: TINFO: ratio: 5.999995
perf_event_open02.c:325: TPASS: test passed

Test is not supported ENOENT when running with similar setup on x86_64 and
s390x quests:
perf_event_open.h:31: TCONF: perf_event_open type/config not supported: ENO=
ENT (2)

grep PERF_EVENTS config-5.15.5-1-default # x86_64
CONFIG_HAVE_PERF_EVENTS=3Dy
CONFIG_PERF_EVENTS=3Dy
CONFIG_PERF_EVENTS_INTEL_UNCORE=3Dy
CONFIG_PERF_EVENTS_INTEL_RAPL=3Dy
CONFIG_PERF_EVENTS_INTEL_CSTATE=3Dy
CONFIG_PERF_EVENTS_AMD_POWER=3Dm
CONFIG_PERF_EVENTS_AMD_UNCORE=3Dm
CONFIG_HAVE_PERF_EVENTS_NMI=3Dy

But it passes on ppc64le

perf_event_open02.c:104: TINFO: bench_work estimated loops =3D 4075 in 500 =
ms
perf_event_open02.c:151: TINFO: [0] value:815279669 time_enabled:316461566 =
time_running:316461566
perf_event_open02.c:151: TINFO: [1] value:815281799 time_enabled:316462740 =
time_running:316462740
perf_event_open02.c:151: TINFO: [2] value:815280588 time_enabled:316534086 =
time_running:316534086
perf_event_open02.c:151: TINFO: [3] value:815283285 time_enabled:316465672 =
time_running:316465672
perf_event_open02.c:151: TINFO: [4] value:815305390 time_enabled:316492698 =
time_running:316492698
perf_event_open02.c:151: TINFO: [5] value:686550649 time_enabled:316631866 =
time_running:266632316
perf_event_open02.c:308: TINFO: nhw: 5, overall task clock: 2534004200
perf_event_open02.c:309: TINFO: hw sum: 32612814180, task clock sum: 126699=
66232
perf_event_open02.c:321: TINFO: ratio: 4.999978
perf_event_open02.c:325: TPASS: test passed

grep PERF_EVENTS config # ppc64le
CONFIG_HAVE_PERF_EVENTS=3Dy
CONFIG_PERF_EVENTS=3Dy
CONFIG_HAVE_PERF_EVENTS_NMI=3Dy

When I tried running aarch64 quest with stable kernel 5.10.76 from kernel.o=
rg on
my intel laptop, using simplified setup, the event was not supported (not s=
ure
whether that was caused unavailable -enable-kvm or something else; I also
haven't checked kernel config):

qemu-system-aarch64 -M virt -cpu cortex-a53 -nographic -smp $SMP -kernel Im=
age -append "rootwait root=3D/dev/vda console=3DttyAMA0" -netdev user,id=3D=
eth0 -device virtio-net-device,netdev=3Deth0 -drive file=3Drootfs.ext4,if=
=3Dnone,format=3Draw,id=3Dhd0 -device virtio-blk-device,drive=3Dhd0
=2E..
perf_event_open.h:26: TINFO: perf_event_open event.type: 0, event.config: 1
perf_event_open.h:30: TCONF: perf_event_open type/config not supported: ENO=
ENT (2)

I also tested that stable kernel 5.10.76 on RPI but that passed (the same a=
s openSUSE 5.15.5-1-default)
perf_event_open02.c:104: TINFO: bench_work estimated loops =3D 1496 in 500 =
ms
perf_event_open02.c:149: TINFO: [0] value:449725668 time_enabled:500191054 =
time_running:500191054
perf_event_open02.c:149: TINFO: [1] value:449728803 time_enabled:500204795 =
time_running:500204795
perf_event_open02.c:149: TINFO: [2] value:449732944 time_enabled:500210665 =
time_running:500210665
perf_event_open02.c:149: TINFO: [3] value:449738099 time_enabled:500210443 =
time_running:500210443
perf_event_open02.c:149: TINFO: [4] value:449745104 time_enabled:500234961 =
time_running:500234961
perf_event_open02.c:149: TINFO: [5] value:449756676 time_enabled:500247647 =
time_running:500247647
perf_event_open02.c:149: TINFO: [6] value:385474224 time_enabled:502975813 =
time_running:430976612
perf_event_open02.c:308: TINFO: nhw: 6, overall task clock: 4031349522
perf_event_open02.c:309: TINFO: hw sum: 21590362808, task clock sum: 241871=
13827
perf_event_open02.c:321: TINFO: ratio: 5.999756
perf_event_open02.c:325: TPASS: test passed

So is it a rounding issue on aarch64 QEMU/KVM?
Thanks for any hint what to check / try.

Kind regards,
Petr

[1] https://github.com/linux-test-project/ltp/tree/c2d4836c057fb9f78e7f625d=
71638d4f40f98659/testcases/kernel/syscalls/perf_event_open/perf_event_open0=
2.c
