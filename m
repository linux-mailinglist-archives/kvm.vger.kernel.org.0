Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44AC85F4986
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 20:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiJDS4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 14:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiJDS4N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 14:56:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B214A58513;
        Tue,  4 Oct 2022 11:56:12 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 294IZlDc027012;
        Tue, 4 Oct 2022 18:56:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=YUtDJ3FlmPz/Xj/lMsoELhtafuOGjgSK5JjLhXOpoV4=;
 b=ev6rp/PacPx3EqiD/g+0eFQEKEtCyf7cZcEOSVQkYoLM/rWp688Tuc4PwfIjybsmvIV4
 oeQpDisNhWRZp4ohQBIouFJ2BlDkIXWlXwsPrLoBiEKqDl5ivVPmPwG8RhAjI+Kdn0Ok
 cYycUVviq4AvMLWcj5S+yHSAamJyQ8JS59VryflzoGduzVasVq4zHKV9A8v5hSZtzQ4m
 a12h8lhZ7I8JGu9UywN/d9KcjkFu9Xg69A+YwuUMANn4sJg3HGiOreLqJMIMfRhgT5cr
 ejDQltI0YEnawpmTX0tK0FmoAx34xvg6AsyINuIzYrRK9GQJhdCKiU1NdrJRMh4tGm6P Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0gw1jtf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 18:56:06 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 294Iqcpf013240;
        Tue, 4 Oct 2022 18:56:05 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0gw1jtek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 18:56:05 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 294Ip1Vt030829;
        Tue, 4 Oct 2022 18:56:04 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02wdc.us.ibm.com with ESMTP id 3jxd69pqm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 18:56:04 +0000
Received: from smtpav02.wdc07v.mail.ibm.com ([9.208.128.114])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 294Iu2m861866482
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Oct 2022 18:56:03 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B081758060;
        Tue,  4 Oct 2022 18:56:02 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B42B58059;
        Tue,  4 Oct 2022 18:56:01 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.160.98.127])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Oct 2022 18:56:00 +0000 (GMT)
Message-ID: <a50f4b7ca18d593df7727b70d6ea524180e40a57.camel@linux.ibm.com>
Subject: Re: [PATCH v2] vfio: Follow a strict lifetime for struct iommu_group
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        "Jason J . Herne" <jjherne@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Date:   Tue, 04 Oct 2022 14:56:00 -0400
In-Reply-To: <33bc5258-5c95-99ee-a952-5b0b2826da3a@linux.ibm.com>
References: <0-v2-a3c5f4429e2a+55-iommu_group_lifetime_jgg@nvidia.com>
         <4cb6e49e-554e-57b3-e2d3-bc911d99083f@linux.ibm.com>
         <20220927140541.6f727b01.alex.williamson@redhat.com>
         <52545d8b-956b-8934-8a7e-212729ea2855@linux.ibm.com>
         <YzxT6Suu+272gDvP@nvidia.com>
         <1aebfa84-8310-5dff-1862-3d143878d9dd@linux.ibm.com>
         <YzxfK/e14Bx9yNyo@nvidia.com>
         <0a0d7937-316a-a0e2-9d7d-df8f3f8a38e3@linux.ibm.com>
         <33bc5258-5c95-99ee-a952-5b0b2826da3a@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: n9y-AqN2geHaINpWgrqOQ6_4-ttrtCXE
X-Proofpoint-GUID: _ltum3Y8_9VTyp16VUTEmn1JJLXReLTi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_08,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 adultscore=0 mlxlogscore=681 spamscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1011 mlxscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210040120
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-10-04 at 14:22 -0400, Matthew Rosato wrote:
> On 10/4/22 1:36 PM, Christian Borntraeger wrote:
> >=20
> >=20
> > Am 04.10.22 um 18:28 schrieb Jason Gunthorpe:
> > > On Tue, Oct 04, 2022 at 05:44:53PM +0200, Christian Borntraeger
> > > wrote:
> > >=20
> > > > > Does some userspace have the group FD open when it stucks
> > > > > like this,
> > > > > eg what does fuser say?
> > > >=20
> > > > /proc/<virtnodedevd>/fd
> > > > 51480 0 dr-x------. 2 root root=C2=A0 0=C2=A0 4. Okt 17:16 .
> > > > 43593 0 dr-xr-xr-x. 9 root root=C2=A0 0=C2=A0 4. Okt 17:16 ..
> > > > 65252 0 lr-x------. 1 root root 64=C2=A0 4. Okt 17:42 0 -> /dev/nul=
l
> > > > 65253 0 lrwx------. 1 root root 64=C2=A0 4. Okt 17:42 1 ->
> > > > 'socket:[51479]'
> > > > 65261 0 lrwx------. 1 root root 64=C2=A0 4. Okt 17:42 10 ->
> > > > 'anon_inode:[eventfd]'
> > > > 65262 0 lrwx------. 1 root root 64=C2=A0 4. Okt 17:42 11 ->
> > > > 'socket:[51485]'
> > > > 65263 0 lrwx------. 1 root root 64=C2=A0 4. Okt 17:42 12 ->
> > > > 'socket:[51487]'
> > > > 65264 0 lrwx------. 1 root root 64=C2=A0 4. Okt 17:42 13 ->
> > > > 'socket:[51486]'
> > > > 65265 0 lrwx------. 1 root root 64=C2=A0 4. Okt 17:42 14 ->
> > > > 'anon_inode:[eventfd]'
> > > > 65266 0 lrwx------. 1 root root 64=C2=A0 4. Okt 17:42 15 ->
> > > > 'socket:[60421]'
> > > > 65267 0 lrwx------. 1 root root 64=C2=A0 4. Okt 17:42 16 ->
> > > > 'anon_inode:[eventfd]'
> > > > 65268 0 lrwx------. 1 root root 64=C2=A0 4. Okt 17:42 17 ->
> > > > 'socket:[28008]'
> > > > 65269 0 l-wx------. 1 root root 64=C2=A0 4. Okt 17:42 18 ->
> > > > /run/libvirt/nodedev/driver.pid
> > > > 65270 0 lrwx------. 1 root root 64=C2=A0 4. Okt 17:42 19 ->
> > > > 'socket:[28818]'
> > > > 65254 0 lrwx------. 1 root root 64=C2=A0 4. Okt 17:42 2 ->
> > > > 'socket:[51479]'
> > > > 65271 0 lr-x------. 1 root root 64=C2=A0 4. Okt 17:42 20 ->
> > > > '/dev/vfio/3 (deleted)'
> > >=20
> > > Seems like a userspace bug to keep the group FD open after the
> > > /dev/
> > > file has been deleted :|
> > >=20
> > > What do you think about this?
> > >=20
> > > commit a54a852b1484b1605917a8f4d80691db333b25ed
> > > Author: Jason Gunthorpe <jgg@ziepe.ca>
> > > Date:=C2=A0=C2=A0 Tue Oct 4 13:14:37 2022 -0300
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0 vfio: Make the group FD disassociate from th=
e iommu_group
> > > =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0 Allow the vfio_grou=
p struct to exist with a NULL
> > > iommu_group pointer. When
> > > =C2=A0=C2=A0=C2=A0=C2=A0 the pointer is NULL the vfio_group users pro=
mise not to
> > > touch the
> > > =C2=A0=C2=A0=C2=A0=C2=A0 iommu_group. This allows a driver to be hot =
unplugged while
> > > userspace is
> > > =C2=A0=C2=A0=C2=A0=C2=A0 keeping the group FD open.
> > > =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0 SPAPR mode is exclu=
ded from this behavior because of
> > > how it wrongly hacks
> > > =C2=A0=C2=A0=C2=A0=C2=A0 part of its iommu interface through KVM. Due=
 to this we
> > > loose control over
> > > =C2=A0=C2=A0=C2=A0=C2=A0 what it is doing and cannot revoke the iommu=
_group usage in
> > > the IOMMU
> > > =C2=A0=C2=A0=C2=A0=C2=A0 layer via vfio_group_detach_container().
> > > =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0 Thus, for SPAPR the=
 group FDs must still be closed
> > > before a device can be
> > > =C2=A0=C2=A0=C2=A0=C2=A0 hot unplugged.
> > > =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0 This fixes a usersp=
ace regression where we learned that
> > > virtnodedevd
> > > =C2=A0=C2=A0=C2=A0=C2=A0 leaves a group FD open even though the /dev/=
 node for it has
> > > been deleted
> > > =C2=A0=C2=A0=C2=A0=C2=A0 and all the drivers for it unplugged.
> > > =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0 Fixes: ca5f21b25749=
 ("vfio: Follow a strict lifetime
> > > for struct iommu_group")
> > > =C2=A0=C2=A0=C2=A0=C2=A0 Reported-by: Christian Borntraeger
> > > <borntraeger@linux.ibm.com>
> > > =C2=A0=C2=A0=C2=A0=C2=A0 Signed-off-by: Jason Gunthorpe <jgg@nvidia.c=
om>
> >=20
> > Almost :-)
> >=20
> > drivers/vfio/vfio_main.c: In function 'vfio_file_is_group':
> > drivers/vfio/vfio_main.c:1606:47: error: expected ')' before ';'
> > token
> > =C2=A01606 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return (fi=
le->f_op =3D=3D &vfio_group_fops;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ~=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 ^
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 )
> > drivers/vfio/vfio_main.c:1606:48: error: expected ';' before '}'
> > token
> > =C2=A01606 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return (fi=
le->f_op =3D=3D &vfio_group_fops;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 ^
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 ;
> > =C2=A01607 | }
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | ~
> >=20
> >=20
> > With that fixed I get:
> >=20
> > ERROR: modpost: "vfio_file_is_group" [drivers/vfio/pci/vfio-pci-
> > core.ko] undefined!
> >=20
> > With that worked around (m -> y)
>=20
>=20
> Looks like this can be solved with
> EXPORT_SYMBOL_GPL(vfio_file_is_group);
>=20
> Also:
>=20
> arch/s390/kvm/../../../virt/kvm/vfio.c:64:28: warning:
> =E2=80=98kvm_vfio_file_iommu_group=E2=80=99 defined but not used [-Wunuse=
d-function]
> =C2=A0=C2=A0 64 | static struct iommu_group *kvm_vfio_file_iommu_group(st=
ruct
> file *file)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^~~~~~~~~~~~~~~~~~~~~~~~~
>=20
> kvm_vfio_file_iommu_group looks like it is now SPAPR-only
>=20
> >=20
> >=20
> > Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> >=20
> > At least the vfio-ap part
>=20

I can reproduce the problem with vfio-ccw, also blamed to this patch.
With the changes described above, things work as they did before.

Tested-by: Eric Farman <farman@linux.ibm.com> # vfio-ccw, vfio-ap

I can try a v2 when the below gets addressed.

> Nope, with this s390 vfio-pci at least breaks:
>=20
> [=C2=A0 132.943389] kernel BUG at lib/list_debug.c:53!
> [=C2=A0 132.943406] monitor event: 0040 ilc:2 [#1] SMP=20
> [=C2=A0 132.943410] Modules linked in: vfio_pci kvm vfio_pci_core
> irqbypass vfio_virqfd vhost_vsock vmw_vsock_virtio_transport_common
> vsock vhost vhost_iotlb nft_fib_inet nft_fib_ipv4 nft_fib_ipv6
> nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject
> nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defr
> ag_ipv4 ip_set nf_tables nfnetlink sunrpc mlx5_ib ism smc ib_uverbs
> ib_core uvdevice s390_trng tape_3590 tape tape_class eadm_sch
> vfio_ccw mdev vfio_iommu_type1 vfio zcrypt_cex4 sch_fq_codel configfs
> ghash_s390 prng chacha_s390 libchacha mlx5_core aes_s390 des_s390
> libdes sha3_512_s390 nvme sha3_256_s390 sha512_s390 sh
> a256_s390 nvme_core sha1_s390 sha_common zfcp scsi_transport_fc pkey
> zcrypt rng_core autofs4 [last unloaded: vfio_pci]
> [=C2=A0 132.943457] CPU: 12 PID: 4991 Comm: nose2 Tainted: G=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 6.0.0-rc4 #40
> [=C2=A0 132.943460] Hardware name: IBM 3931 A01 782 (LPAR)
> [=C2=A0 132.943462] Krnl PSW : 0704c00180000000 00000000cbc90568
> (__list_del_entry_valid+0xd8/0xf0)
> [=C2=A0 132.943469]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3
> CC:0 PM:0 RI:0 EA:3
> [=C2=A0 132.943474] Krnl GPRS: 8000000000000001 0000000900000027
> 000000000000004e 00000000ccc1ffe0
> [=C2=A0 132.943477]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 00000000fffeffff 00000009fc290000
> 0000000000000000 0000000000000080
> [=C2=A0 132.943480]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 00000000acc86438 0000000000000000
> 00000000acc86420 00000000a1492800
> [=C2=A0 132.943483]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 00000000922a0000 000003ffb9dce260
> 00000000cbc90564 0000038004a6b9f8
> [=C2=A0 132.943489] Krnl Code: 00000000cbc90558: c0200045eff3=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> larl=C2=A0=C2=A0=C2=A0 %r2,00000000cc54e53e
> [=C2=A0 132.943489]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 00000000cbc9055e: c0e50022c7d9=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0
> brasl=C2=A0=C2=A0 %r14,00000000cc0e9510
> [=C2=A0 132.943489]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 #00000000cbc90564: af000000=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0
> mc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0,0
> [=C2=A0 132.943489]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 >00000000cbc90568: b9040032=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0
> lgr=C2=A0=C2=A0=C2=A0=C2=A0 %r3,%r2
> [=C2=A0 132.943489]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 00000000cbc9056c: c0200045efd4=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0
> larl=C2=A0=C2=A0=C2=A0 %r2,00000000cc54e514
> [=C2=A0 132.943489]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 00000000cbc90572: c0e50022c7cf=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0
> brasl=C2=A0=C2=A0 %r14,00000000cc0e9510
> [=C2=A0 132.943489]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 00000000cbc90578: af000000=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> mc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0,0
> [=C2=A0 132.943489]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 00000000cbc9057c: 0707=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> bcr=C2=A0=C2=A0=C2=A0=C2=A0 0,%r7
> [=C2=A0 132.943510] Call Trace:
> [=C2=A0 132.943512]=C2=A0 [<00000000cbc90568>] __list_del_entry_valid+0xd=
8/0xf0
> [=C2=A0 132.943515] ([<00000000cbc90564>]
> __list_del_entry_valid+0xd4/0xf0)
> [=C2=A0 132.943518]=C2=A0 [<000003ff8011a1b8>]
> vfio_group_detach_container+0x88/0x170 [vfio]=20
> [=C2=A0 132.943524]=C2=A0 [<000003ff801176c0>]
> vfio_device_remove_group.isra.0+0xb0/0x1e0 [vfio]=20
> [=C2=A0 132.943529]=C2=A0 [<000003ff804f9e54>]
> vfio_pci_core_unregister_device+0x34/0x80 [vfio_pci_core]=20
> [=C2=A0 132.943535]=C2=A0 [<000003ff804ae1c4>] vfio_pci_remove+0x2c/0x40
> [vfio_pci]=20
> [=C2=A0 132.943539]=C2=A0 [<00000000cbd58c3c>] pci_device_remove+0x3c/0x9=
8=20
> [=C2=A0 132.943542]=C2=A0 [<00000000cbdbdbce>]
> device_release_driver_internal+0x1c6/0x288=20
> [=C2=A0 132.943545]=C2=A0 [<00000000cbd4e284>] pci_stop_bus_device+0x94/0=
xc0=20
> [=C2=A0 132.943549]=C2=A0 [<00000000cbd4e570>]
> pci_stop_and_remove_bus_device_locked+0x30/0x48=20
> [=C2=A0 132.943552]=C2=A0 [<00000000cb55d980>] zpci_bus_remove_device+0x6=
8/0xa8
> [=C2=A0 132.943555]=C2=A0 [<00000000cb556e82>]
> zpci_deconfigure_device+0x3a/0xe0=20
> [=C2=A0 132.943558]=C2=A0 [<00000000cbd65d04>] power_write_file+0x7c/0x13=
0=20
> [=C2=A0 132.943561]=C2=A0 [<00000000cb8fbc90>]
> kernfs_fop_write_iter+0x138/0x210=20
> [=C2=A0 132.943565]=C2=A0 [<00000000cb837344>] vfs_write+0x194/0x2e0 "
> [=C2=A0 132.943568]=C2=A0 [<00000000cb8376fa>] ksys_write+0x6a/0xf8=20
> [=C2=A0 132.943571]=C2=A0 [<00000000cc0f918c>] __do_syscall+0x1d4/0x200=
=20
> [=C2=A0 132.943575]=C2=A0 [<00000000cc107e42>] system_call+0x82/0xb0=20
> [=C2=A0 132.943577] Last Breaking-Event-Address:
> [=C2=A0 132.943579]=C2=A0 [<00000000cc0e955c>] _printk+0x4c/0x58
> [=C2=A0 132.943585] Kernel panic - not syncing: Fatal exception:
> panic_on_oops

