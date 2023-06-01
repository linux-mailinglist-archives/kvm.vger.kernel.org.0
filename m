Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D29E719B79
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 14:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbjFAMEX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 08:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbjFAMEW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 08:04:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B868CE4
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 05:04:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D4AA641A9
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 12:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99CC9C433EF
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 12:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685621059;
        bh=lcqOPdIxGwWCNvkZF/FOWgzj9csPQtyF8YtGYTB2Mcw=;
        h=From:To:Subject:Date:From;
        b=s4ySVFzKDxpftpTdtT3xpnI5yTrtgcOUOCix3D6O1JUEwtWdzuBJNGFQdCWRqzC/7
         glSbRuzQmPQEwiRjeM0e6AO0WHSVATAH8DEqZIkVzosI0NlnLwa28mDxL4H4fk1p/3
         Yu5PD55mLHRGnkH0yZFLiTgyBVlRVy6rfDD6MyLb+rMbzF+HE8QhMHk9vQtDTlMQGC
         22Mhj2qDsGUvHO6q2Qlpqjk2wLiGRmEQgS2qaAPL85iHDJEVdWFrww98AqKi4ijppf
         HN/uvyq/yxqsuAEloEsvDCW+dUZ1sISXseocYzVCsYU12DWTZZlasAViQ2hnhtr9Wn
         P37z7QuDi7lxA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 82A2EC43144; Thu,  1 Jun 2023 12:04:19 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217516] New: FAIL: TSC reference precision test when do
 hyperv_clock test of kvm unit test
Date:   Thu, 01 Jun 2023 12:04:19 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: zjuysxie@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-217516-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217516

            Bug ID: 217516
           Summary: FAIL: TSC reference precision test when do
                    hyperv_clock test of kvm unit test
           Product: Virtualization
           Version: unspecified
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: high
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: zjuysxie@hotmail.com
        Regression: No

when i do kvm unit test with -cpu host,hv_time it failed sometime(e.g. not
everytime) with error info "FAIL: TSC reference precision"

detail test failed log:
# timeout -k 1s --foreground 90s /usr/libexec/qemu-kvm --no-reboot -nodefau=
lts
-device pc-testdev -device isa-debug-exit,iobase=3D0xf4,iosize=3D0x4 -vnc n=
one
-serial stdio -device pci-testdev -machine accel=3Dkvm -kernel
x86/hyperv_clock.flat -cpu host,hv_time # -initrd /tmp/tmp.kFgWZZHuFw
enabling apic
smp: waiting for 0 APs
paging enabled
cr0 =3D 80010011
cr3 =3D 1007000
cr4 =3D 20
PASS: MSR value after enabling
scale: 10624e40e147ae1 offset: -96899
refcnt 1523884, TSC 1826d03c, TSC reference 1523889
refcnt 21523885 (delta 20000001), TSC 1422cb9da, TSC reference 21523888 (de=
lta
19999999)
delta on CPU 0 was 3...86
PASS: TSC reference precision test
iterations/sec:  47979415
PASS: MSR value after disabling
[root@iZbp1dwjy9g3o14k8rot75Z kvm-unit-tests]# timeout -k 1s --foreground 9=
0s
/usr/libexec/qemu-kvm --no-reboot -nodefaults -device pc-testdev -device
isa-debug-exit,iobase=3D0xf4,iosize=3D0x4 -vnc none -serial stdio -device
pci-testdev -machine accel=3Dkvm -kernel x86/hyperv_clock.flat -cpu host,hv=
_time
# -initrd /tmp/tmp.kFgWZZHuFw
enabling apic
smp: waiting for 0 APs
paging enabled
cr0 =3D 80010011
cr3 =3D 1007000
cr4 =3D 20
PASS: MSR value after enabling
scale: 10624e40e147ae1 offset: -94820
refcnt 1523422, TSC 181d1f72, TSC reference 1523427
refcnt 21523428 (delta 20000006), TSC 142230e40, TSC reference 21523432 (de=
lta
20000005)
suspecting drift on CPU 0? delta =3D 75, acceptable [0, 45)
FAIL: TSC reference precision test
iterations/sec:  47972169
PASS: MSR value after disabling


os info:
# cat /etc/os-release
NAME=3D"CentOS Linux"
VERSION=3D"8"
ID=3D"centos"
ID_LIKE=3D"rhel fedora"
VERSION_ID=3D"8"
PLATFORM_ID=3D"platform:el8"
PRETTY_NAME=3D"CentOS Linux 8"
ANSI_COLOR=3D"0;31"
CPE_NAME=3D"cpe:/o:centos:centos:8"
HOME_URL=3D"https://centos.org/"
BUG_REPORT_URL=3D"https://bugs.centos.org/"
CENTOS_MANTISBT_PROJECT=3D"CentOS-8"
CENTOS_MANTISBT_PROJECT_VERSION=3D"8"

# cat /etc/redhat-release
CentOS Linux release 8.5.2111

# uname -r
4.18.0-348.7.1.el8_5.x86_64

I use kvm unit test code with branch master at commit:
commit 02d8befe99f8205d4caea402d8b0800354255681 (HEAD -> master, origin/mas=
ter,
origin/HEAD)
Author: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Date:   Tue Apr 4 20:50:47 2023 +0200

    pretty_print_stacks: modify relative path calculation


cpu info:
# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 85
model name      : Intel(R) Xeon(R) Platinum 8269CY CPU @ 2.50GHz
stepping        : 7
microcode       : 0x5003102
cpu MHz         : 3800.000
cache size      : 36608 KB
physical id     : 0
siblings        : 52
core id         : 0
cpu cores       : 26
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 22
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca =
cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb
rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est
tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic movbe popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch
cpuid_fault epb cat_l3 cdp_l3 invpcid_single intel_ppin ssbd mba ibrs ibpb
stibp ibrs_enhanced tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase
tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid cqm mpx rdt_a avx512f avx51=
2dq
rdseed adx smap clflushopt clwb intel_pt avx512cd avx512bw avx512vl xsaveopt
xsavec xgetbv1 xsaves cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_local dth=
erm
ida arat pln pts pku ospke avx512_vnni md_clear flush_l1d arch_capabilities
bugs            : spectre_v1 spectre_v2 spec_store_bypass swapgs taa
itlb_multihit
bogomips        : 5000.00
clflush size    : 64
cache_alignment : 64
address sizes   : 46 bits physical, 48 bits virtual
power management:

[...]

processor       : 103
vendor_id       : GenuineIntel
cpu family      : 6
model           : 85
model name      : Intel(R) Xeon(R) Platinum 8269CY CPU @ 2.50GHz
stepping        : 7
microcode       : 0x5003102
cpu MHz         : 3800.000
cache size      : 36608 KB
physical id     : 1
siblings        : 52
core id         : 29
cpu cores       : 26
apicid          : 123
initial apicid  : 123
fpu             : yes
fpu_exception   : yes
cpuid level     : 22
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca =
cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb
rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est
tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic movbe popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch
cpuid_fault epb cat_l3 cdp_l3 invpcid_single intel_ppin ssbd mba ibrs ibpb
stibp ibrs_enhanced tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase
tsc_adjust bmi1 avx2 smep bmi2 erms invpcid cqm mpx rdt_a avx512f avx512dq
rdseed adx smap clflushopt clwb intel_pt avx512cd avx512bw avx512vl xsaveopt
xsavec xgetbv1 xsaves cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_local dth=
erm
ida arat pln pts pku ospke avx512_vnni md_clear flush_l1d arch_capabilities
bugs            : spectre_v1 spectre_v2 spec_store_bypass swapgs taa
itlb_multihit
bogomips        : 5006.84
clflush size    : 64
cache_alignment : 64
address sizes   : 46 bits physical, 48 bits virtual
power management:

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
