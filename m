Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48A448D718
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 13:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234016AbiAMMG1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 07:06:27 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58236 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231705AbiAMMG0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 07:06:26 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20DBSDD4016832;
        Thu, 13 Jan 2022 12:06:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=EFtsyeAfsTzzfYSWbF3pit3u+MKCLgwDllpn85f81R0=;
 b=n7IgqPGP0TDq85lNNynqQgB1P+UM5ZacwO+YBvjELUfilwhasNo/1r73sOphU3kB/lfw
 kmzSf79nn5bamLVUcrl0sGXANrFEluEhKHu7kQyafNdeMmUs8AxB75XcsCahUmSJTxU6
 1APNGGddCDuv3o8LE/wxu+SWz3kfUtq+wj+/rN0QHZT5M/jvm7xKPOtmvZUWJnQcl7ol
 HmKgPESY56tGLHYOp+pmooLqmSkQodQqR3jcG++iIaGteAeN9thKqq92sgSnXSCFYnqE
 g24e55RX0epJV9XDlMvouiRSwmp182RfsMO6E0btWOyhV1TtSdd9Okus+i0QeCtZqUcE mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3djk81gnrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 12:06:16 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20DBU02X019625;
        Thu, 13 Jan 2022 12:06:16 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3djk81gnrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 12:06:16 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20DC2HL1007193;
        Thu, 13 Jan 2022 12:06:14 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3df28a42xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 12:06:14 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20DC6BQY41746874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 12:06:11 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D867A406B;
        Thu, 13 Jan 2022 12:06:11 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21AB6A405B;
        Thu, 13 Jan 2022 12:06:11 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 13 Jan 2022 12:06:11 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 857EFE03A3; Thu, 13 Jan 2022 13:06:10 +0100 (CET)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     dwmw2@infradead.org
Cc:     butterflyhuangxx@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: KVM: Warn if mark_page_dirty() is called without an active vCPU
Date:   Thu, 13 Jan 2022 13:06:09 +0100
Message-Id: <20220113120609.736701-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <e8f40b8765f2feefb653d8a67e487818f66581aa.camel@infradead.org>
References: <e8f40b8765f2feefb653d8a67e487818f66581aa.camel@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nd-OLcRjum13P0XnqeaPh7PLB8yz2KSK
X-Proofpoint-ORIG-GUID: 8Tr4RSrypsmJQ4MKNPYLJTUBF4w-RnY1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_04,2022-01-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 impostorscore=0 malwarescore=0 mlxlogscore=637 bulkscore=0
 spamscore=0 lowpriorityscore=0 mlxscore=0 clxscore=1011 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201130073
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

Quick heads-up.
The new warnon triggers on s390. Here we write to the guest from an
irqfd worker. Since we do not use dirty_ring yet this might be an over-indication.
Still have to look into that.

[ 1801.980777] WARNING: CPU: 12 PID: 117600 at arch/s390/kvm/../../../virt/kvm/kvm_main.c:3166 mark_page_dirty_in_slot+0xa0/0xb0 [kvm]
[ 1801.980839] Modules linked in: xt_CHECKSUM(E) xt_MASQUERADE(E) xt_conntrack(E) ipt_REJECT(E) xt_tcpudp(E) nft_compat(E) nf_nat_tftp(E) nft_objref(E) vhost_vsock(E) vmw_vsock_virtio_transport_common(E) vsock(E) vhost(E) vhost_iotlb(E) nf_conntrack_tftp(E) crc32_generic(E) algif_hash(E) af_alg(E) paes_s390(E) dm_crypt(E) encrypted_keys(E) loop(E) lcs(E) ctcm(E) fsm(E) kvm(E) nft_fib_inet(E) nft_fib_ipv4(E) nft_fib_ipv6(E) nft_fib(E) nft_reject_inet(E) nf_reject_ipv4(E) nf_reject_ipv6(E) nft_reject(E) nft_ct(E) nft_chain_nat(E) nf_nat(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) ip_set(E) nf_tables(E) nfnetlink(E) sunrpc(E) dm_service_time(E) dm_multipath(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) zfcp(E) scsi_transport_fc(E) ism(E) smc(E) ib_core(E) eadm_sch(E) vfio_ccw(E) mdev(E) vfio_iommu_type1(E) vfio(E) sch_fq_codel(E) configfs(E) ip_tables(E) x_tables(E) ghash_s39 [...truncated...]
[ 1801.980915]  sha1_s390(E) sha_common(E) pkey(E) zcrypt(E) rng_core(E) autofs4(E) [last unloaded: vfio_ap]
[ 1801.980931] CPU: 12 PID: 117600 Comm: kworker/12:0 Tainted: G            E     5.17.0-20220113.rc0.git0.32ce2abb03cf.300.fc35.s390x+next #1
[ 1801.980935] Hardware name: IBM 2964 NC9 712 (LPAR)
[ 1801.980938] Workqueue: events irqfd_inject [kvm]
[ 1801.980959] Krnl PSW : 0704e00180000000 000003ff805f0f5c (mark_page_dirty_in_slot+0xa4/0xb0 [kvm])
[ 1801.980981]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
[ 1801.980985] Krnl GPRS: 000003ff298e9040 000000017754a660 0000000000000000 0000000000000000
[ 1801.980988]            000000003fefcc36 ffffffffffffff68 0000000000000000 0000000177871500
[ 1801.980990]            00000001d1918000 000000003fefcc36 00000001d1918000 0000000000000000
[ 1801.980993]            00000001375b0000 00000001d191a838 000003ff805f0ee6 0000038000babb48
[ 1801.981003] Krnl Code: 000003ff805f0f4c: eb9ff0a00004	lmg	%r9,%r15,160(%r15)
                          000003ff805f0f52: c0f400018c61	brcl	15,000003ff80622814
                         #000003ff805f0f58: af000000		mc	0,0
                         >000003ff805f0f5c: eb9ff0a00004	lmg	%r9,%r15,160(%r15)
                          000003ff805f0f62: c0f400018c59	brcl	15,000003ff80622814
                          000003ff805f0f68: c004ffe37b10	brcl	0,000003ff80260588
                          000003ff805f0f6e: ec360033007c	cgij	%r3,0,6,000003ff805f0fd4
                          000003ff805f0f74: e31020100012	lt	%r1,16(%r2)
[ 1801.981057] Call Trace:
[ 1801.981060]  [<000003ff805f0f5c>] mark_page_dirty_in_slot+0xa4/0xb0 [kvm]
[ 1801.981083]  [<000003ff8060e9fe>] adapter_indicators_set+0xde/0x268 [kvm]
[ 1801.981104]  [<000003ff80613c24>] set_adapter_int+0x64/0xd8 [kvm]
[ 1801.981124]  [<000003ff805fb9aa>] kvm_set_irq+0xc2/0x130 [kvm]
[ 1801.981144]  [<000003ff805f8d86>] irqfd_inject+0x76/0xa0 [kvm]
[ 1801.981164]  [<0000000175e56906>] process_one_work+0x1fe/0x470
[ 1801.981173]  [<0000000175e570a4>] worker_thread+0x64/0x498
[ 1801.981176]  [<0000000175e5ef2c>] kthread+0x10c/0x110
[ 1801.981180]  [<0000000175de73c8>] __ret_from_fork+0x40/0x58
[ 1801.981185]  [<000000017698440a>] ret_from_fork+0xa/0x40
