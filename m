Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C41A693942
	for <lists+kvm@lfdr.de>; Sun, 12 Feb 2023 19:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjBLSJr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 13:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjBLSJp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 13:09:45 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30AE72B9;
        Sun, 12 Feb 2023 10:09:44 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31CHBIQI030003;
        Sun, 12 Feb 2023 18:09:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=pp1;
 bh=QxUQfBxRs7+eRaVd5A2a/fOjiztC+ILi8foFXLLYTfA=;
 b=CbTIZlqop91Etr9jWEJK03h3U7LLK8ci9NqEAst6jPUKkkEXcfhNlpyimNsfUztquFl4
 xPJ+KTI//c8/ei7vrsxWkMEFA1cDL8wmjoAQTRNkjmn2QcvN3QsrUiCWR9te9cLYIMGp
 Z9ljnWNskkgHkn+WNGjff96CaLXzTNnsDk/j/5KURFmUEErJJwCysjyXJ/tdBu35XXLJ
 2IF/IlHn5KAKv/w256Bu1fF84D52CFCGXp6aVMIGP/sMkKhP+YUCGaVuwGCHrmrLvmYQ
 HAsiWQN21dzJcJHbasZpG17cpu58kof2IMM9CZtNrVCabcpKXskWa/nRmvDHG7wfBAYz NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nq046ku24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Feb 2023 18:09:43 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31CHvQMD009508;
        Sun, 12 Feb 2023 18:09:43 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nq046ku1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Feb 2023 18:09:43 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31C5e6bE008148;
        Sun, 12 Feb 2023 18:09:41 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3np2n69aqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Feb 2023 18:09:41 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31CI9bJ151052804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 12 Feb 2023 18:09:37 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 989D020043;
        Sun, 12 Feb 2023 18:09:37 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0265120040;
        Sun, 12 Feb 2023 18:09:37 +0000 (GMT)
Received: from osiris (unknown [9.179.11.167])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Sun, 12 Feb 2023 18:09:36 +0000 (GMT)
Date:   Sun, 12 Feb 2023 19:09:35 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/ccw: Remove WARN_ON during shutdown
Message-ID: <Y+krX5SJjqrZHzvl@osiris>
References: <20230210174227.2256424-1-farman@linux.ibm.com>
 <20230210143004.347b17bc.alex.williamson@redhat.com>
 <67809f492928a8d7e60aad7884a3409746793ea6.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <67809f492928a8d7e60aad7884a3409746793ea6.camel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZCEjWaYvLcryzONzbn9O2SCh9pndXkGI
X-Proofpoint-GUID: UYCv5aNrgUEqPqTkJG5ReAi9SbiqJ07N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-12_08,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 adultscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=969 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302120164
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 10, 2023 at 08:24:05PM -0500, Eric Farman wrote:
> On Fri, 2023-02-10 at 14:30 -0700, Alex Williamson wrote:
> > On Fri, 10 Feb 2023 18:42:27 +0100
> > Eric Farman <farman@linux.ibm.com> wrote:
> > 
> > > The logic in vfio_ccw_sch_shutdown() always assumed that the input
> > > subchannel would point to a vfio_ccw_private struct, without
> > > checking
> > > that one exists. The blamed commit put in a check for this
> > > scenario,
> > > to prevent the possibility of a missing private.
> > > 
> > > The trouble is that check was put alongside a WARN_ON(), presuming
> > > that such a scenario would be a cause for concern. But this can be
> > > triggered by binding a subchannel to vfio-ccw, and rebooting the
> > > system before starting the mdev (via "mdevctl start" or similar)
> > > or after stopping it. In those cases, shutdown doesn't need to
> > > worry because either the private was never allocated, or it was
> > > cleaned up by vfio_ccw_mdev_remove().
> > > 
> > > Remove the WARN_ON() piece of this check, since there are plausible
> > > scenarios where private would be NULL in this path.
> > > 
> > > Fixes: 9e6f07cd1eaa ("vfio/ccw: create a parent struct")
> > > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > > ---
> > >  drivers/s390/cio/vfio_ccw_drv.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
...
> > I see I'm on the To: line here, is this intended to go through the
> > vfio
> > tree rather than s390? 
> 
> Either way. I put you as "to" as the blamed commit went via vfio, but I
> could ask Heiko or Vasili to take it if that's easier.

I picked it up, so it will go via s390. Thanks!
