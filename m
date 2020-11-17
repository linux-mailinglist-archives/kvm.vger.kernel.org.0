Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74A82B57CD
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 04:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgKQDVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 22:21:49 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14924 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726712AbgKQDVs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 22:21:48 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AH327AE168361;
        Mon, 16 Nov 2020 22:21:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=p1RvvAXxBmsENxKx6ZImxxAMZWPDabBr+EUHHUl/SDY=;
 b=J7MDtMoLjqA2KYw4czmxA0ywVbxWljTrDqYLqRoUKTaz/hbFHlfOwFFTtOP/5vgcvmqR
 CuSYxpRVqvyyuopmpbtoY9OC6kAhPhTHacszC9UNhm2F2nz06LcTvgk0dZrp89qmbaZU
 FJqqOQF0fY4KranGD844TDOSSxmR7AlELb3grk3uM3eh41+6/+LaIpvHaRM/esOCKoGL
 RitpkzdsoFB9CPoIGLKMH4/GiN3FWhORWWXFknSblg0hp2ofGI4YQTi4JOLWsQi3vzTP
 hyGDVyjHXmJLddP1yqvAZooH4DSxS9nXeOSPTl7yd2QA9COt1zTFJny0Ywx20b3ciL7p bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34v3yeu83a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 22:21:46 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AH3Ljg8028684;
        Mon, 16 Nov 2020 22:21:45 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34v3yeu82x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 22:21:45 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AH38nfX003240;
        Tue, 17 Nov 2020 03:21:43 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 34t6gh2ppu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 03:21:43 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AH3LeeQ53674242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 03:21:41 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0356AE053;
        Tue, 17 Nov 2020 03:21:40 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE4E5AE045;
        Tue, 17 Nov 2020 03:21:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 17 Nov 2020 03:21:40 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 6334BE036B; Tue, 17 Nov 2020 04:21:40 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH 0/2] Connect request callback to mdev and vfio-ccw
Date:   Tue, 17 Nov 2020 04:21:37 +0100
Message-Id: <20201117032139.50988-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_13:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 spamscore=0 mlxlogscore=893
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxscore=0 clxscore=1011
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170020
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is a situation where removing all the paths from a device
connected via mdev and vfio-ccw can cause some difficulty.
Using the "chchp -c 0 xx" command to all paths will cause the
device to be removed from the configuration, and any guest
filesystem that is relying on that device will encounter errors.
Interestingly, the last chchp command will actually fail to
return to a shell prompt, and subsequent commands (another
chchp to bring the paths back online, chzdev, etc.) will also
hang because of the outstanding chchp.

The last chchp command drives to vfio_ccw_sch_remove() for every
affected mediated device, and ultimately enters an infinite loop
in vfio_del_group_dev(). This loop is broken when the guest goes
away, which in this case doesn't occur until the guest is shutdown.
This drives vfio_ccw_mdev_release() and thus vfio_device_release()
to wake up the vfio_del_group_dev() thread.

There is also a callback mechanism called "request" to ask a
driver (and perhaps user) to release the device, but this is not
implemented for mdev. So this adds one to that point, and then
wire it to vfio-ccw to pass it along to userspace. This will
gracefully drive the unplug code, and everything behaves nicely.

Despite the testing that was occurring, this doesn't appear related
to the vfio-ccw channel path handling code. I can reproduce this with
an older kernel/QEMU, which makes sense because the above behavior is
driven from the subchannel event codepaths and not the chpid events.
Because of that, I didn't flag anything with a Fixes tag, since it's
seemingly been this way forever.

Eric Farman (2):
  vfio-mdev: Wire in a request handler for mdev parent
  vfio-ccw: Wire in the request callback

 drivers/s390/cio/vfio_ccw_ops.c     | 26 ++++++++++++++++++++++++++
 drivers/s390/cio/vfio_ccw_private.h |  4 ++++
 drivers/vfio/mdev/vfio_mdev.c       | 11 +++++++++++
 include/linux/mdev.h                |  4 ++++
 include/uapi/linux/vfio.h           |  1 +
 5 files changed, 46 insertions(+)

-- 
2.17.1

