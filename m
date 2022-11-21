Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A81F6632F0D
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 22:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbiKUVl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 16:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbiKUVlX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 16:41:23 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251F9D53BB;
        Mon, 21 Nov 2022 13:41:08 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALLDBcn018614;
        Mon, 21 Nov 2022 21:41:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=hOeu/+Bt8HQlDI7PcpknrsHZP7B7Q/fucFNjwPt+3cc=;
 b=IQ4GlJTM3xM2BSVHeD8FKLNWRoxNxZ4KkLFzGpbk4lFNKA+cg6PlPA7Tcp55C7ziKVQm
 hJCXwNZwpAztYEbFzTeb5AYbVvvc639f81B5NUaensURRRMR+A1XZYSIxJ7dAFoWO/Ud
 kOii9uE7SdxRcbxdv/V7BfXbaBmrYNtUCW7S5BJpeqQNRkVBOYc0i/WZZjpag8DGybWd
 hzroXVV3UlTJJGQJVFJj2WqwyzDEqLYi4PrkwSJ9o8UYf/v9qa085aKRsV5HKkaojSl+
 KRWa/2RwmLMUO3ZSub6VUnV/DcunHtAXf6hcWaq1pghAHv21EVLCXGhoVq5lkDpvjfY1 zg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0h28gs8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:07 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ALLbSIv004521;
        Mon, 21 Nov 2022 21:41:05 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3kxps8u6v1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:04 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ALLf1GS61931952
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 21:41:01 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0FF2AE053;
        Mon, 21 Nov 2022 21:41:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9372AE045;
        Mon, 21 Nov 2022 21:41:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 21 Nov 2022 21:41:01 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 65C70E0174; Mon, 21 Nov 2022 22:41:01 +0100 (CET)
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
Subject: [PATCH v1 00/16] vfio/ccw: channel program cleanup
Date:   Mon, 21 Nov 2022 22:40:40 +0100
Message-Id: <20221121214056.1187700-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5aJR6-FriNT1NwyWjG7JD0obPEPAczMT
X-Proofpoint-ORIG-GUID: 5aJR6-FriNT1NwyWjG7JD0obPEPAczMT
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210162
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Matt, et al,

(Apologies for sending this out right before the holiday; but I have
this in a state where it's unlikely to change further.)

(@Heiko, @Vasily, @Alexander: As you might notice in the diffstat,
this is mostly within drivers/s390/cio/vfio_ccw* with the exception
of one change to idals.h (patch 12). I hope that's okay.)

Here is the first batch of the vfio-ccw channel program handler rework,
which I'm referring to as "the IDA code." Most of it is rearrangement to
make it more readable, and to remove restrictions in place since
commit 0a19e61e6d4c ("vfio: ccw: introduce channel program interfaces").
My hope is that with this off the plate, it will be easier to extend the
vfio-ccw channel program handler for newer, more modern, features.

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
Who would operate on 2K at a time?

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
use the full 64-bit addressing. This is a change from today,
where any direct-addressed CCW is converted to a 4K Format-2 IDA.
This needs to become a 2K Format-2 IDA to maintain compatibility
with potential IDAs in other CCWs in a chain.

The first few patches at the start of this series are improvements
that could stand alone, regardless of the rework that follows.
The remainder of the series is intended to do the code movement
that would enable these older IDA formats, but the restriction
itself isn't removed until the end.

While I developed this on top of the -parent code that you've
seen recently [2], it isn't explicitly dependent on it and should
be usable/reviewable without it. I -did- base this series on the
addressing fixes that were discussed more recently [3], since
there are intersections with this file in general.
Patch 2 addresses the suggestion you made in that series [4].

Thanks in advance, I look forward to the feedback...

Eric

[1] See most recent Principles of Operation, page 1-6
[2] https://lore.kernel.org/kvm/20221104142007.1314999-1-farman@linux.ibm.com/
[3] https://lore.kernel.org/linux-s390/20221121165836.283781-1-farman@linux.ibm.com/
[4] https://lore.kernel.org/linux-s390/c9e7229e-a88d-2185-bb6b-a94e9dac7b7a@linux.ibm.com/

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
  vfio/ccw: discard second fmt-1 IDAW
  vfio/ccw: calculate number of IDAWs regardless of format
  vfio/ccw: allocate/populate the guest idal
  vfio/ccw: handle a guest Format-1 IDAL
  vfio/ccw: don't group contiguous pages on 2K IDAWs
  vfio/ccw: remove old IDA format restrictions

 Documentation/s390/vfio-ccw.rst |   4 +-
 arch/s390/include/asm/idals.h   |  12 ++
 drivers/s390/cio/vfio_ccw_cp.c  | 346 +++++++++++++++++---------------
 drivers/s390/cio/vfio_ccw_cp.h  |   3 +-
 drivers/s390/cio/vfio_ccw_fsm.c |   2 +-
 5 files changed, 197 insertions(+), 170 deletions(-)

-- 
2.34.1

