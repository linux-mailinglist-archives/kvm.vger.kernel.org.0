Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980011C2260
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 04:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgEBCsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 22:48:21 -0400
Received: from ms11p00im-qufo17281801.me.com ([17.58.38.55]:49076 "EHLO
        ms11p00im-qufo17281801.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726463AbgEBCsU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 1 May 2020 22:48:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1588387127;
        bh=V0wXfOzGLr1+wLpSbb38sjTuFxy3NzHcnZy36e3SRhY=;
        h=From:Content-Type:Subject:Message-Id:Date:To;
        b=YlK1LNymHI4x5dHx23VFh/HokwaURY2CY2NFzYNqdsqRAj0x7iCgubNceKquJIlPy
         kl6FTSHCydzHrZmmR2Ipzye9uNBhX34J20DGR5/z9nXgQqb+Kf8fSHh8qiuXEfnwKW
         S/g2ZQJnZkmVuO7JgnITZ7MBFX7JERrJfjTcBu9F+HwfoSy3vasX1ikqD9fhuZn9zx
         GN0Dk6KQeuSLknKjUvC+lF4nM7ybiAFK80tiLb/rb6YstFiOg/7nU1CFnjXdTRZOu+
         bXrBGexQO6wNt3easI7Am0vtVS6UmeG1SVtv1WZn96v98DILrP2GEZFJxqjhZ5e1K4
         KiExVEmJuL3xg==
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net [71.184.117.43])
        by ms11p00im-qufo17281801.me.com (Postfix) with ESMTPSA id 28A301000C0;
        Sat,  2 May 2020 02:38:46 +0000 (UTC)
From:   Qian Cai <cailca@icloud.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: s390 KVM warning in handle_pqap()
Message-Id: <ED53E46F-EF53-46F6-B88E-2035965AB20C@icloud.com>
Date:   Fri, 1 May 2020 22:38:44 -0400
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_18:2020-05-01,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=280 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2002250000 definitions=main-2005020021
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This line,

if (WARN_ON_ONCE(fc !=3D 0x03))

qemu-kvm-2.12.0-99.module+el8.2.0+5827+8c39933c with this kernel config,

https://raw.githubusercontent.com/cailca/linux-mm/master/s390.config

# /usr/libexec/qemu-kvm -name ubuntu-18.04-server-cloudimg -cpu host =
-smp 2 -m 2G -hda ubuntu-18.04-server-cloudimg.qcow2 -cdrom =
ubuntu-18.04-server-cloudimg.iso -nic user,hostfwd=3Dtcp::2222-:22 =
-nographic

00: [  424.578896] WARNING: CPU: 0 PID: 1533 at arch/s390/kvm/priv.c:632 =
handle_
00: pqap+0x2b6/0x468 [kvm]                                               =
      =20
00: [  424.578934] Modules linked in: kvm ip_tables x_tables xfs =
dasd_fba_mod da
00: sd_eckd_mod dm_mirror dm_region_hash dm_log dm_mod                   =
      =20
00: [  424.579026] CPU: 0 PID: 1533 Comm: qemu-kvm Not tainted =
5.7.0-rc3-next-20
00: 200501 #2                                                            =
      =20
00: [  424.579064] Hardware name: IBM 2964 N96 400 (z/VM 6.4.0)          =
      =20
00: [  424.579101] Krnl PSW : 0704d00180000000 000003ff80440dc2 =
(handle_pqap+0x2
00: ba/0x468 [kvm])                                                      =
      =20
00: [  424.579239]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 =
CC:1 PM:0
00:  RI:0 EA:3                                                           =
      =20
00: [  424.579282] Krnl GPRS: 0000000000000000 0000030000000000 =
0000030000000000
00:  00000000e1ca6148                                                    =
      =20
00: [  424.579320]            0000030000000000 000003ff80440c14 =
0000000000000000
00:  00000000822e8520                                                    =
      =20
00: [  424.579359]            00000000e1ca6000 000000009c79a000 =
00000000822e8008
00:  0000007c00877e70                                                    =
      =20
00: [  424.579399]            000003ff803f5000 000003ff80467528 =
000003ff80440c14
00:  000003e0043bf2c8                                                    =
      =20
00: [  424.579461] Krnl Code: 000003ff80440db6: a774ff5a            brc  =
   7,00
00: 0003ff80440c6a                                                       =
      =20
00: [  424.579461]            000003ff80440dba: a7f4ff54            brc  =
   15,0
00: 00003ff80440c62                                                      =
      =20
00: [  424.579461]           #000003ff80440dbe: af000000            mc   =
   0,0=20
00: [  424.579461]           >000003ff80440dc2: a798ffa1            lhi  =
   %r9,
00: -95                                                                  =
      =20
00: [  424.579461]            000003ff80440dc6: a51d0300            =
llihl   %r1,
00: 768                                                                  =
      =20
00: [  424.579461]            000003ff80440dca: b90800b1            agr  =
   %r11
00: ,%r1                                                                 =
      =20
00: [  424.579461]            000003ff80440dce: d70bb000b000        xc   =
   0(12
00: ,%r11),0(%r11)                                                       =
      =20
00: [  424.579461]            000003ff80440dd4: b9140029            lgfr =
   %r2,
00: %r9                                                                  =
      =20
00: [  424.586765] Call Trace:                                           =
      =20
00: [  424.586894]  [<000003ff80440dc2>] handle_pqap+0x2ba/0x468 [kvm]   =
      =20
00: [  424.587026]  [<000003ff80446fa6>] kvm_s390_handle_b2+0x2f6/0x950 =
[kvm]  =20
00: [  424.587156]  [<000003ff8042d74c>] =
kvm_handle_sie_intercept+0x154/0x1db0 [
00: kvm]                                                                 =
      =20
00: [  424.587287]  [<000003ff80426950>] __vcpu_run+0x1040/0x2150 [kvm]  =
      =20
00: [  424.587414]  [<000003ff8042941a>] =
kvm_arch_vcpu_ioctl_run+0x5fa/0x1338 [k
00: vm]                                                                  =
      =20
00: [  424.587540]  [<000003ff8040195e>] kvm_vcpu_ioctl+0x346/0xa10 =
[kvm]      =20
00: [  424.587590]  [<00000001433fbd16>] ksys_ioctl+0x276/0xbb8          =
      =20
00: [  424.587630]  [<00000001433fc682>] __s390x_sys_ioctl+0x2a/0x38     =
      =20
00: [  424.587674]  [<000000014393c880>] system_call+0xd8/0x2b4          =
      =20
00: [  424.587715] 2 locks held by qemu-kvm/1533:                        =
      =20
00: [  424.587748]  #0: 00000000822e80d0 (&vcpu->mutex){+.+.}-{3:3}, at: =
kvm_vcp
00: u_ioctl+0x170/0xa10 [kvm]                                            =
      =20
00: [  424.587898]  #1: 0000000081fe3980 (&kvm->srcu){....}-{0:0}, at: =
__vcpu_ru
00: n+0x60a/0x2150 [kvm]                                                 =
      =20
00: [  424.588045] Last Breaking-Event-Address:                          =
      =20
00: [  424.588169]  [<000003ff80440c1e>] handle_pqap+0x116/0x468 [kvm]   =
      =20
00: [  424.588204] irq event stamp: 23141                                =
      =20
00: [  424.588246] hardirqs last  enabled at (23149): =
[<000000014308f3de>] conso
00: le_unlock+0x766/0xa20                                                =
      =20
00: [  424.588287] hardirqs last disabled at (23156): =
[<000000014308ee40>] conso
00: le_unlock+0x1c8/0xa20                                                =
      =20
00: [  424.588536] softirqs last  enabled at (22998): =
[<000000014393e162>] __do_
00: softirq+0x6e2/0xa48                                                  =
      =20
00: [  424.588583] softirqs last disabled at (22983): =
[<0000000142f652dc>] do_so
00: ftirq_own_stack+0xe4/0x100                                           =
      =20
00: [  424.588625] ---[ end trace e420441aa7c001ac ]---    =20=
