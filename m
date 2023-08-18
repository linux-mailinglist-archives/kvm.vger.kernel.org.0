Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2508780C96
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 15:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377176AbjHRNgG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 09:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377198AbjHRNfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 09:35:47 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758B33C1F;
        Fri, 18 Aug 2023 06:35:42 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37IDZPKa009356;
        Fri, 18 Aug 2023 13:35:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=4v2TWfa6oBkILRs3ARO+kKbi1OBX9uk4r23vOBdt0sQ=;
 b=N5EfXrFf0lfl/FChvrCSDatm+69jbUI0jt71yPIZ54Wzn4gCSrJwvRDOOfRPbru0KSoA
 n1q4Mohy68e+J/JY6+vB5RnlBAIkmtsaFtixNhlmspUaRh0NU/u7Al+tGg/mHVuKReRd
 9Ex8qqT5Ujze4ncXlqnH4/7Z4cmKpOJP8p/KhRIRnf0LeLN8cyN3Ab2D9HT4VWD/ds//
 KQ8ubm88mGOAsYdLptYSUPv2tW1hvCb9qu4n1EwtTskpSkRb50YkZIs+5filgSeygO21
 vOr9et1WAl6lSB7dffxsCisbJWCmvrROl5LI4zTA2Dh6WQ3l0+D7krNAW2nt05CoZraq fQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sj9e38f0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Aug 2023 13:35:39 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37IDMIOu026809;
        Fri, 18 Aug 2023 13:35:39 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sj9e38f0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Aug 2023 13:35:38 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37IBMs0Z007836;
        Fri, 18 Aug 2023 13:35:38 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3senwky64e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Aug 2023 13:35:38 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37IDZZWF16712286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Aug 2023 13:35:35 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 164CD20040;
        Fri, 18 Aug 2023 13:35:35 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B16D20043;
        Fri, 18 Aug 2023 13:35:34 +0000 (GMT)
Received: from osiris (unknown [9.171.32.106])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Fri, 18 Aug 2023 13:35:34 +0000 (GMT)
Date:   Fri, 18 Aug 2023 15:35:32 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: Re: [PATCH 00/12] s390/vfio_ap: crypto pass-through for SE guests
Message-ID: <20230818133532.16552-A-hca@linux.ibm.com>
References: <20230815184333.6554-1-akrowiak@linux.ibm.com>
 <b083c649-0032-4501-54eb-1d86af5fd4c8@linux.ibm.com>
 <b841f8b4-b065-db5c-9339-f199301b2f12@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b841f8b4-b065-db5c-9339-f199301b2f12@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: g7c8ntFPGg80CcNCOdJrpkQh_iPJFbQx
X-Proofpoint-ORIG-GUID: 3dFBHvpA6l8_w2pbU4sdLdFP0Do3W786
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-18_16,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 adultscore=0 clxscore=1011 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 impostorscore=0 mlxlogscore=916
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308180120
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 16, 2023 at 02:12:50PM +0200, Janosch Frank wrote:
> On 8/16/23 13:39, Janosch Frank wrote:
> > On 8/15/23 20:43, Tony Krowiak wrote:
> > > This patch series is for the changes required in the vfio_ap device
> > > driver to facilitate pass-through of crypto devices to a secure
> > > execution guest. In particular, it is critical that no data from the
> > > queues passed through to the SE guest is leaked when the guest is
> > > destroyed. There are also some new response codes returned from the
> > > PQAP(ZAPQ) and PQAP(TAPQ) commands that have been added to the
> > > architecture in support of pass-through of crypto devices to SE guests;
> > > these need to be accounted for when handling the reset of queues.
> > > 
> > 
> > @Heiko: Once this has soaked a day or two, could you please apply this
> > and create a feature branch that I can pull from?
> 
> Sorry for the noise, for some reason I still had Heiko's old address in the
> address book. I'll delete it in a second.
> 
> Here we go again.

Series is now available via the vfio-ap branch, based on rc2 like your
your branches within the kvms390 tree.

https://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git vfio-ap
