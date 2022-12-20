Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE6EC652531
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 18:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbiLTRKZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 12:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbiLTRKV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 12:10:21 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BD463D1;
        Tue, 20 Dec 2022 09:10:20 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKH8UAW020187;
        Tue, 20 Dec 2022 17:10:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=7vu1oYuOCK2brgIcuVNCjFaC2Fv9+nxVUKRiCzIlMp4=;
 b=N5Xt0fQ/ycu3HojKLW5/aXPi3gJXv8GnV5pLTDad5Xvdih5uWYRUeQ+yksBUBs85E9Wc
 SlfYga3rVb8BWNgThh3xOzLecQhvyrDk+UGdW+MhY2WNi3aVfymBCaot0ko8hw1Y1J+K
 paMLht7AgGrTpVm2R4QBMKe2r8f2EtFj1TJMBWSST6rnLcCAgXFB6Tx7HzBNnReW2gDZ
 5NEYzGz62Wl6Ava4WTM0oDOUrIwjks7FFbyctPNKEZ3CXOXYODH7XaL4/UFi+Y6TQauf
 ydzbhRgD5QMo2l23ypXXFHgFFxrYIu80tu/bsKhZl1xyL7yv3zyLo/L/fgCqQr2weTOT fg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkgbw9x1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:18 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BK6igdt020586;
        Tue, 20 Dec 2022 17:10:13 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3mh6yy4amt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:13 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKHAAgG23724384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 17:10:10 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E235020043;
        Tue, 20 Dec 2022 17:10:09 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8AEF20040;
        Tue, 20 Dec 2022 17:10:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 20 Dec 2022 17:10:09 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 7AF79E0614; Tue, 20 Dec 2022 18:10:09 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 00/16] vfio/ccw: channel program cleanup
Date:   Tue, 20 Dec 2022 18:09:52 +0100
Message-Id: <20221220171008.1362680-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Z-sEJV4LEL-o5A2UCY7jpqtK06FEozIp
X-Proofpoint-ORIG-GUID: Z-sEJV4LEL-o5A2UCY7jpqtK06FEozIp
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_06,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 impostorscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212200141
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Matt, et al,

(Apologies for sending this out right before the holiday, again;
but I have this in a state where it's unlikely to change further.)

Here is a new version of the first batch of the vfio-ccw channel
program handler rework, which I'm referring to as "the IDA code."
Most of it is rearrangement to make it more readable, and to remove
restrictions in place since commit 0a19e61e6d4c ("vfio: ccw: introduce
channel program interfaces"). My hope is that with this off the plate,
it will be easier to extend this logic for newer, more modern, features.

Some background:

A Format-1 Channel Command Word (CCW) contains a 31-bit data address,
meaning any I/O transfer is limited to the first 2GB of memory.
The concept of an Indirect Data Address (IDA) was introduced long ago
to allow for non-contiguous memory to be used for data transfers,
while still using 31-bit data addresses.

The initial z/Architecture extended the definition of ESA/390's IDA
concept to include a new IDA format that allows for 64-bit data
addresses [1]. The result is three distinct IDA flavors:

 - Format-1 IDA (31-bit addresses), each IDAW moves up to 2K of data
 - Format-2 IDA (64-bit addresses), each IDAW moves up to 2K of data
 - Format-2 IDA (64-bit addresses), each IDAW moves up to 4K of data

The selection of these three possibilities is done by bits within the
Operation-Request Block (ORB), though it should not be a surprise
that the last one is far-and-away the most common these days.

While newer features can be masked off (by a CPU model or equivalent),
and guarded by a defensive check in a driver (such as our check for
a Transport Mode ORB in fsm_io_request()), all three of these
possibilities are available by the base z/Architecture, and cannot
be "hidden." So while it might be unlikely for a guest to issue
such an I/O, it's not impossible.

vfio-ccw was written to only support the third of these options,
while the first two are rejected by a check buried in
ccwchain_calc_length(). While a Transport Mode ORB gets a
distinct message logged, no such announcement as to the cause
of the problem is done here, except for a generic -EOPNOTSUPP
return code in the prefetch codepath.

The goal of this series is to rework the channel program handler
such that any of the above IDA formats can be processed and sent
to the hardware. Any Format-1 IDA issued by a guest will be
converted to the 2K Format-2 variety, such that it is able to
use the full 64-bit addressing. One change from today is that any
direct-addressed CCW can only converted to a 4K Format-2 IDA if
the ORB settings permit this. Otherwise, those CCWs would need to
be converted to a 2K Format-2 IDA to maintain compatibility with
potential IDA CCWs elsewhere in the chain.

The first few patches at the start of this series are improvements
that could stand alone, regardless of the rework that follows.
The remainder of the series is intended to do the code movement
that would enable these older IDA formats, but the restriction
itself isn't removed until the end.

Thanks in advance, I look forward to the feedback...

Eric

[1] See most recent Principles of Operation, page 1-6

v1->v2:
 - [EF] Rebased to current upstream master (with s390/vfio patches merged)
 - [MR, JG] Collected r-b's (Thank you!)
 - Patch 1:
   [MR] Drop Fixes tag
 - Patch 6:
   [MR] Fix typo in commit message
 - Patch 7:
   [MR] Convert forgotten "ch_pa + i" to "&ch_pa[i]" notation for consistency
 - Patch 8:
   [MR] Change "!len" to "len == 0" since it's not a pointer
 - Patch 11:
   [MR] Only read 4 bytes for a Format-1 IDA, instead of 8 bytes
 - Patch 12:
   [MR] Remove unnecessary else in ccw_count_idals
   [EF (checkpatch.pl --strict)] Whitespace changes
 - Patch 13:
   [MR] Return ERR_PTR for errors in get_guest_idal(), instead of NULL, and check
   appropriately in caller
 - Patch 14:
   [EF (checkpatch.pl --strict)] Wrap "_cp" in parentheses in definition of idal_is_2k
 - Patch 15:
   [MR] Add comments for "unaligned" parameter on page_array_{alloc|unpin}
 - Patch 16:
   [MR] Drop unnecessary comma from Documentation/s390/vfio-ccw.rst
v1: https://lore.kernel.org/kvm/20221121214056.1187700-1-farman@linux.ibm.com/

Eric Farman (16):
  vfio/ccw: cleanup some of the mdev commentary
  vfio/ccw: simplify the cp_get_orb interface
  vfio/ccw: allow non-zero storage keys
  vfio/ccw: move where IDA flag is set in ORB
  vfio/ccw: replace copy_from_iova with vfio_dma_rw
  vfio/ccw: simplify CCW chain fetch routines
  vfio/ccw: remove unnecessary malloc alignment
  vfio/ccw: pass page count to page_array struct
  vfio/ccw: populate page_array struct inline
  vfio/ccw: refactor the idaw counter
  vfio/ccw: read only one Format-1 IDAW
  vfio/ccw: calculate number of IDAWs regardless of format
  vfio/ccw: allocate/populate the guest idal
  vfio/ccw: handle a guest Format-1 IDAL
  vfio/ccw: don't group contiguous pages on 2K IDAWs
  vfio/ccw: remove old IDA format restrictions

 Documentation/s390/vfio-ccw.rst |   4 +-
 arch/s390/include/asm/idals.h   |  12 ++
 drivers/s390/cio/vfio_ccw_cp.c  | 362 +++++++++++++++++---------------
 drivers/s390/cio/vfio_ccw_cp.h  |   3 +-
 drivers/s390/cio/vfio_ccw_fsm.c |   2 +-
 5 files changed, 210 insertions(+), 173 deletions(-)

-- 
2.34.1

