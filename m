Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682097A8967
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 18:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbjITQ1y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 12:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbjITQ1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 12:27:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F509F
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 09:27:48 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38KGIuvn018978;
        Wed, 20 Sep 2023 16:27:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=nYjl1sbzEhK9CsJFcP4t1U/LXzN/OiB/JyBAhZuS9zw=;
 b=hdROw481DK3NzAUbKkvDiVDEGYxpXVnIQIRE4k8cd0MEPi1E1mRTzSGS4dwP8D52jKU/
 VAXsos3DGQsWH8uytTf821bCAVuS5IKwt/TnD1gzFpo1UoUhp2bwU//+4VquwJYu91Xh
 NEfpaFNlS2sYmOj50Lkp72SpM9eMw3MW/8VcfkYbeaErzHYarK1aiXTIINoUNO7EwsFJ
 wn6yE7Jtk1DaDtqQmuKqJaqbyhTMETfMan+I3BeBuSOdaKAJz2K9fbdMCPhPCxkxaOOU
 CmH5nQ7SVhsswv8bzspu5F4mD9j7TEcP20yXNEF1cwUTjHx3jHb5LExqqzbW3D+o65XW yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t84230ch2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Sep 2023 16:27:36 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38KGGDAK011067;
        Wed, 20 Sep 2023 16:27:35 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t84230cgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Sep 2023 16:27:35 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38KGO5eI011671;
        Wed, 20 Sep 2023 16:27:34 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3t5qpnqknv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Sep 2023 16:27:34 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
        by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38KGRX073867244
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Sep 2023 16:27:34 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E352B5805A;
        Wed, 20 Sep 2023 16:27:33 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A4B458056;
        Wed, 20 Sep 2023 16:27:33 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.182.187])
        by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 20 Sep 2023 16:27:33 +0000 (GMT)
Message-ID: <f7419e537b8cf3471688619b808c2f70d8ae5649.camel@linux.ibm.com>
Subject: Re: [PATCH] vfio/mdev: Fix a null-ptr-deref bug for
 mdev_unregister_parent()
From:   Eric Farman <farman@linux.ibm.com>
To:     Jinjie Ruan <ruanjinjie@huawei.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Date:   Wed, 20 Sep 2023 12:27:32 -0400
In-Reply-To: <20230918115551.1423193-1-ruanjinjie@huawei.com>
References: <20230918115551.1423193-1-ruanjinjie@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JaX13kIwYU3yfqO2pasyPRLPfyepKNpo
X-Proofpoint-ORIG-GUID: A1fKzdmmCgilX9Wussqhf2JUbsFGTLPV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-20_05,2023-09-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 spamscore=0 impostorscore=0 mlxlogscore=691 malwarescore=0 bulkscore=0
 clxscore=1011 phishscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309200132
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-09-18 at 19:55 +0800, Jinjie Ruan wrote:
> Inject fault while probing mdpy.ko, if kstrdup() of create_dir()
> fails in
> kobject_add_internal() in kobject_init_and_add() in mdev_type_add()
> in parent_create_sysfs_files(), it will return 0 and probe
> successfully.
> And when rmmod mdpy.ko, the mdpy_dev_exit() will call
> mdev_unregister_parent(), the mdev_type_remove() may traverse
> uninitialized
> parent->types[i] in parent_remove_sysfs_files(), and it will cause
> below null-ptr-deref.
>=20
> If mdev_type_add() fails, return the error code and kset_unregister()
> to fix the issue.
>=20
> =C2=A0general protection fault, probably for non-canonical address
> 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN
> =C2=A0KASAN: null-ptr-deref in range [0x0000000000000010-
> 0x0000000000000017]
> =C2=A0CPU: 2 PID: 10215 Comm: rmmod Tainted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 N 6.6.0-
> rc2+ #20
> =C2=A0Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-=
1
> 04/01/2014
> =C2=A0RIP: 0010:__kobject_del+0x62/0x1c0
> =C2=A0Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 51 01 00 00 48 b8 00 0=
0
> 00 00 00 fc ff df 48 8b 6b 28 48 8d 7d 10 48 89 fa 48 c1 ea 03 <80>
> 3c 02 00 0f 85 24 01 00 00 48 8b 75 10 48 89 df 48 8d 6b 3c e8
> =C2=A0RSP: 0018:ffff88810695fd30 EFLAGS: 00010202
> =C2=A0RAX: dffffc0000000000 RBX: ffffffffa0270268 RCX: 0000000000000000
> =C2=A0RDX: 0000000000000002 RSI: 0000000000000004 RDI: 0000000000000010
> =C2=A0RBP: 0000000000000000 R08: 0000000000000001 R09: ffffed10233a4ef1
> =C2=A0R10: ffff888119d2778b R11: 0000000063666572 R12: 0000000000000000
> =C2=A0R13: fffffbfff404e2d4 R14: dffffc0000000000 R15: ffffffffa0271660
> =C2=A0FS:=C2=A0 00007fbc81981540(0000) GS:ffff888119d00000(0000)
> knlGS:0000000000000000
> =C2=A0CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> =C2=A0CR2: 00007fc14a142dc0 CR3: 0000000110a62003 CR4: 0000000000770ee0
> =C2=A0DR0: ffffffff8fb0bce8 DR1: ffffffff8fb0bce9 DR2: ffffffff8fb0bcea
> =C2=A0DR3: ffffffff8fb0bceb DR6: 00000000fffe0ff0 DR7: 0000000000000600
> =C2=A0PKRU: 55555554
> =C2=A0Call Trace:
> =C2=A0 <TASK>
> =C2=A0 ? die_addr+0x3d/0xa0
> =C2=A0 ? exc_general_protection+0x144/0x220
> =C2=A0 ? asm_exc_general_protection+0x22/0x30
> =C2=A0 ? __kobject_del+0x62/0x1c0
> =C2=A0 kobject_del+0x32/0x50
> =C2=A0 parent_remove_sysfs_files+0xd6/0x170 [mdev]
> =C2=A0 mdev_unregister_parent+0xfb/0x190 [mdev]
> =C2=A0 ? mdev_register_parent+0x270/0x270 [mdev]
> =C2=A0 ? find_module_all+0x9d/0xe0
> =C2=A0 mdpy_dev_exit+0x17/0x63 [mdpy]
> =C2=A0 __do_sys_delete_module.constprop.0+0x2fa/0x4b0
> =C2=A0 ? module_flags+0x300/0x300
> =C2=A0 ? __fput+0x4e7/0xa00
> =C2=A0 do_syscall_64+0x35/0x80
> =C2=A0 entry_SYSCALL_64_after_hwframe+0x46/0xb0
> =C2=A0RIP: 0033:0x7fbc813221b7
> =C2=A0Code: 73 01 c3 48 8b 0d d1 8c 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 6=
6
> 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 b0 00 00 00 0f 05 <48>
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a1 8c 2c 00 f7 d8 64 89 01 48
> =C2=A0RSP: 002b:00007ffe780e0648 EFLAGS: 00000206 ORIG_RAX:
> 00000000000000b0
> =C2=A0RAX: ffffffffffffffda RBX: 00007ffe780e06a8 RCX: 00007fbc813221b7
> =C2=A0RDX: 000000000000000a RSI: 0000000000000800 RDI: 000055e214df9b58
> =C2=A0RBP: 000055e214df9af0 R08: 00007ffe780df5c1 R09: 0000000000000000
> =C2=A0R10: 00007fbc8139ecc0 R11: 0000000000000206 R12: 00007ffe780e0870
> =C2=A0R13: 00007ffe780e0ed0 R14: 000055e214df9260 R15: 000055e214df9af0
> =C2=A0 </TASK>
> =C2=A0Modules linked in: mdpy(-) mdev vfio_iommu_type1 vfio [last
> unloaded: mdpy]
> =C2=A0Dumping ftrace buffer:
> =C2=A0=C2=A0=C2=A0 (ftrace buffer empty)
> =C2=A0---[ end trace 0000000000000000 ]---
> =C2=A0RIP: 0010:__kobject_del+0x62/0x1c0
> =C2=A0Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 51 01 00 00 48 b8 00 0=
0
> 00 00 00 fc ff df 48 8b 6b 28 48 8d 7d 10 48 89 fa 48 c1 ea 03 <80>
> 3c 02 00 0f 85 24 01 00 00 48 8b 75 10 48 89 df 48 8d 6b 3c e8
> =C2=A0RSP: 0018:ffff88810695fd30 EFLAGS: 00010202
> =C2=A0RAX: dffffc0000000000 RBX: ffffffffa0270268 RCX: 0000000000000000
> =C2=A0RDX: 0000000000000002 RSI: 0000000000000004 RDI: 0000000000000010
> =C2=A0RBP: 0000000000000000 R08: 0000000000000001 R09: ffffed10233a4ef1
> =C2=A0R10: ffff888119d2778b R11: 0000000063666572 R12: 0000000000000000
> =C2=A0R13: fffffbfff404e2d4 R14: dffffc0000000000 R15: ffffffffa0271660
> =C2=A0FS:=C2=A0 00007fbc81981540(0000) GS:ffff888119d00000(0000)
> knlGS:0000000000000000
> =C2=A0CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> =C2=A0CR2: 00007fc14a142dc0 CR3: 0000000110a62003 CR4: 0000000000770ee0
> =C2=A0DR0: ffffffff8fb0bce8 DR1: ffffffff8fb0bce9 DR2: ffffffff8fb0bcea
> =C2=A0DR3: ffffffff8fb0bceb DR6: 00000000fffe0ff0 DR7: 0000000000000600
> =C2=A0PKRU: 55555554
> =C2=A0Kernel panic - not syncing: Fatal exception
> =C2=A0Dumping ftrace buffer:
> =C2=A0=C2=A0=C2=A0 (ftrace buffer empty)
> =C2=A0Kernel Offset: disabled
> =C2=A0Rebooting in 1 seconds..
>=20
> Fixes: da44c340c4fe ("vfio/mdev: simplify mdev_type handling")
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> ---
> =C2=A0drivers/vfio/mdev/mdev_sysfs.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Eric Farman <farman@linux.ibm.com>

