Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED6B7860A4
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 21:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237943AbjHWTaT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 15:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238098AbjHWTaA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 15:30:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E9E10C8;
        Wed, 23 Aug 2023 12:29:58 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37NJCZGq030998;
        Wed, 23 Aug 2023 19:29:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=8V1esxwklFErSUFnPK6XOA6s5/KCSCyZQLNUOEjUwVQ=;
 b=DYQLCFsvQm7ip5ocKtXS1uWIqlbbB2h59SlXyf2Fj18SRGwf6SBl7OdI3PoKnArd5CPE
 uFxkg1Ka6Rmg23WDAm6dxV4xBUwIawPNnBn7pthvJxEQ5RKr1y/FT/lzUkDBEEzOOW8H
 xqO1L4SbIgURfEWG2RmjwsQgcOTAIYp45o0zOHj9/NIEV/fEd06VcJ6HodPNRJN1ctyM
 8zJ8KIBqOsi65CHT9Kpeuj/jqmFPfp9mTR8nJHzbOpdY812yl6FGn3d2rU+j8iBwyHEW
 in455Bi661CNMAXhS7ZZTMfou6y8JtWlUF3pqTSZkWeXNfyexUYWaHGPg5UuOuU7ztVO ew== 
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3snr2kgg3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Aug 2023 19:29:58 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37NIjrrr016403;
        Wed, 23 Aug 2023 19:29:57 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sn227rxvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Aug 2023 19:29:57 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37NJTsww25690648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Aug 2023 19:29:54 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E839D2004B;
        Wed, 23 Aug 2023 19:29:53 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5514020040;
        Wed, 23 Aug 2023 19:29:53 +0000 (GMT)
Received: from osiris (unknown [9.171.42.232])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 23 Aug 2023 19:29:53 +0000 (GMT)
Date:   Wed, 23 Aug 2023 21:29:51 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Michael Mueller <mimu@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: fix gisa destroy operation might lead to cpu
 stalls
Message-ID: <20230823192951.28372-A-hca@linux.ibm.com>
References: <20230823124140.3839373-1-mimu@linux.ibm.com>
 <ZOYIWuq3iqLjDd+q@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <e144381d-4ff3-d7b6-5624-813ea22f196a@linux.ibm.com>
 <ZOYtd7m2TqMDIb++@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZOYtd7m2TqMDIb++@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mJu6Q59Hxe4ba6l_geAJbSrW0jFH3oY2
X-Proofpoint-ORIG-GUID: mJu6Q59Hxe4ba6l_geAJbSrW0jFH3oY2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-23_13,2023-08-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=270 mlxscore=0 phishscore=0 clxscore=1015 malwarescore=0
 spamscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308230173
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 23, 2023 at 06:01:59PM +0200, Alexander Gordeev wrote:
> On Wed, Aug 23, 2023 at 04:09:26PM +0200, Michael Mueller wrote:
> > Does that make sense for you?
> 
> Not really. If process_gib_alert_list() does guarantee the removal,
> then it should be a condition, not the loop.
> 
> But I am actually not into this code. Just wanted to point out that
> cpu_relax() is removed from this loop and the two other loops within
> process_gib_alert_list() do not have it either.

Not sure if you are mainly referring to the missing cpu_relax(), however:
any chance you missed that cpu_relax() translates only to barrier() on
s390? So it really doesn't "relax" anything. cpu_relax() used to be a
diagnose 0x44 (aka voluntary yield), but that caused many problems,
therefore we removed that logic, and the only thing remaining is a no-op
with compiler barrier semantics.
