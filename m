Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2024E511719
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 14:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbiD0Mm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 08:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234489AbiD0Mmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 08:42:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D3E31514;
        Wed, 27 Apr 2022 05:39:41 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23RB3B2G012983;
        Wed, 27 Apr 2022 12:39:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=u0nadIK7z0bvpO1bTNMb/ymcluSbpnagZ6CWDk9UtSE=;
 b=sIadZoA/anY4/hFkalao9hQoO7DEBj/Jw2G0A1HVMAPl9SkXNQU9ARkk7trCynosipkz
 TZIpb0Wq9546JwJD52/rqN7mZCa3C8tNMIx4W/UTI4zcWCJ51lSZAkGj6+Tr3EiCi0YJ
 Xhu7U6pq4k0WeJ2/7qfgJrHCyiXG5kJRqiOcztXC3n+VHEYIOndZ2mSqIFx5N1Wqp1x/
 q05Jardgx3hqs3fhEKgpe0aPTimqscdpD/85fsReqSj65sURPcjRfuyOI0qk79/hWw1R
 70MFfNqL0oXcVQm5/g3MwwbF5yejS9/MGNqBiqUSaZ1iTOi7kIyNka0tjXRTv6AWc37J Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpssq50rc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 12:39:41 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23RCWEYU002605;
        Wed, 27 Apr 2022 12:39:40 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpssq50qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 12:39:40 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23RCWsLP006510;
        Wed, 27 Apr 2022 12:39:38 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3fm938wxwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 12:39:38 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23RCdZ8H49676694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 12:39:35 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54E1B11C054;
        Wed, 27 Apr 2022 12:39:35 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD67211C04A;
        Wed, 27 Apr 2022 12:39:34 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.176])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 27 Apr 2022 12:39:34 +0000 (GMT)
Date:   Wed, 27 Apr 2022 14:39:33 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v6 1/3] s390x: Give name to return value
 of tprot()
Message-ID: <20220427143933.0593212d@p-imbrenda>
In-Reply-To: <9869b838-0070-ae67-737f-2bd3d0e21d60@linux.ibm.com>
References: <20220427100611.2119860-1-scgl@linux.ibm.com>
        <20220427100611.2119860-2-scgl@linux.ibm.com>
        <20220427131449.61cce697@p-imbrenda>
        <9869b838-0070-ae67-737f-2bd3d0e21d60@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JF7C5GvI5xkmmQnnGmRU57Xgqup7RynR
X-Proofpoint-ORIG-GUID: fK6gJdmeZJrxiDYTvtD7iXMr6SNjkXgU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_04,2022-04-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=989
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204270082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 Apr 2022 14:04:52 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> On 4/27/22 13:14, Claudio Imbrenda wrote:
> > On Wed, 27 Apr 2022 12:06:09 +0200
> > Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> >   
> >> Improve readability by making the return value of tprot() an enum.
> >>
> >> No functional change intended.  
> > 
> > Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > 
> > but see nit below
> >   
> >>
> >> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> >> ---
> >>  lib/s390x/asm/arch_def.h | 11 +++++++++--
> >>  lib/s390x/sclp.c         |  6 +++---
> >>  s390x/tprot.c            | 24 ++++++++++++------------
> >>  3 files changed, 24 insertions(+), 17 deletions(-)  
> 
> [...]
> 
> >> diff --git a/s390x/tprot.c b/s390x/tprot.c
> >> index 460a0db7..8eb91c18 100644
> >> --- a/s390x/tprot.c
> >> +++ b/s390x/tprot.c
> >> @@ -20,26 +20,26 @@ static uint8_t pagebuf[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
> >>  
> >>  static void test_tprot_rw(void)
> >>  {
> >> -	int cc;
> >> +	enum tprot_permission permission;
> >>  
> >>  	report_prefix_push("Page read/writeable");
> >>  
> >> -	cc = tprot((unsigned long)pagebuf, 0);
> >> -	report(cc == 0, "CC = 0");
> >> +	permission = tprot((unsigned long)pagebuf, 0);
> >> +	report(permission == TPROT_READ_WRITE, "CC = 0");  
> > 
> > here and in all similar cases below: does it still make sense to have
> > "CC = 0" as message at this point? Maybe a more descriptive one would
> > be better  
> 
> I thought about it, but decided against it. Firstly, because I preferred
> not to do any functional changes and secondly, I could not think of anything
> better. The prefix already tells you the meaning of the cc, so I don't know
> what to print that would not be redundant.
> 
> [...]

fair enough
