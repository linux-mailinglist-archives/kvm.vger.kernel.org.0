Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B917758FE9
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 10:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjGSIK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 04:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjGSIKy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 04:10:54 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC880E0;
        Wed, 19 Jul 2023 01:10:53 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36J87nUn013534;
        Wed, 19 Jul 2023 08:10:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=bmtdoH4x78WOzEgO0hJr3Q4YAok9U57wjwgQujC0nAA=;
 b=b6ITED5+a63nh8h/9Mi20RaNVia658Hk1kPH0a3vu+15UlGdMvRoF/cMcbTv0p3xkP3d
 jMenfcl2ZZyhx/hs4A5PCxmTcMQmGgniVu952R2R1H61QeH4EGCZhBeBNPz4BkMfxE0L
 u44TmGAQqXjEB2Kq8WaY7bVnUlacKsYCJS/AHfOEtH5DKHFe2pQ8FdSMc690PlmWbmEM
 6kV1adx4PHwxEccCva1BiTXY9ZDBIE1QgYAZL194hdLv+4PyMhNxL5Xh9CoTArRZZ00R
 xEDrqqHY8TIQ348X+8Ip4i8LYekuZqQ6PbOLwgQF5g60SQ/wqWBUsBf2l4sLhbRqOYls Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rxbuqgc8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 08:10:26 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36J87x9i014971;
        Wed, 19 Jul 2023 08:10:25 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rxbuqgc86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 08:10:25 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36J4EjMD029129;
        Wed, 19 Jul 2023 08:10:24 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3rv6smgq3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 08:10:24 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36J8ALVY46072444
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jul 2023 08:10:21 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21CD720043;
        Wed, 19 Jul 2023 08:10:21 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 537682006A;
        Wed, 19 Jul 2023 08:10:20 +0000 (GMT)
Received: from osiris (unknown [9.152.212.233])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 19 Jul 2023 08:10:20 +0000 (GMT)
Date:   Wed, 19 Jul 2023 10:10:19 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Costa Shulyupin <costa.shul@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Yantengsi <siyanteng@loongson.cn>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vineet Gupta <vgupta@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Mikhail Zaslonko <zaslonko@linux.ibm.com>,
        Eric DeVolder <eric.devolder@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:S390 ARCHITECTURE" <linux-s390@vger.kernel.org>,
        "open list:S390 VFIO-CCW DRIVER" <kvm@vger.kernel.org>
Subject: Re: [PATCH] docs: move s390 under arch
Message-ID: <ZLeaa6N2Dug3DpBs@osiris>
References: <20230718045550.495428-1-costa.shul@redhat.com>
 <ZLYxVo5/YjjOd3i7@osiris>
 <874jm1uzz4.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874jm1uzz4.fsf@meer.lwn.net>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: R7AfpQ8NRP86mYnCjoffY47XQ7k9vNVu
X-Proofpoint-ORIG-GUID: aYJmZMez_Q6H0kPd3jIlPFVhvX9jMX89
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-19_04,2023-07-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 mlxlogscore=747 mlxscore=0 suspectscore=0 impostorscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307190073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 18, 2023 at 07:10:55AM -0600, Jonathan Corbet wrote:
> Heiko Carstens <hca@linux.ibm.com> writes:
> 
> > I guess this should go via Jonathan, like most (or all) other similar
> > patches? Jonathan, let me know if you pick this up, or if this should
> > go via the s390 tree.
> 
> I'm happy either way...I'd sort of thought these would go through the
> arch trees to minimize the conflict potential, but it hasn't happened
> that way yet.  Let me know your preference and I'll go with it...should
> you take it:
> 
> Acked-by: Jonathan Corbet <corbet@lwn.net>

I'll take it. There will be a trivial merge conflict with the kexec Kconfig
rework that is sitting in Andrew's tree. In case there is more Kconfig
rework happining in the s390 tree this will avoid additional conflicts.
