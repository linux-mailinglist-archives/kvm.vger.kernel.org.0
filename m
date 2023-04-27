Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F546F061A
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 14:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243958AbjD0Mpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 08:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243650AbjD0Mpp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 08:45:45 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E740C49F4;
        Thu, 27 Apr 2023 05:45:38 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33RCifR2029419;
        Thu, 27 Apr 2023 12:45:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=INH7Q3RtKqCz6BKeYwy2Vu3M2doflBXcblbCSd0JFQc=;
 b=KmFIIGxTnJ5Jd6XlI3GRtjvdcqgFwh6zRTDfO3ssM7uicWR/W+H9OjBxUeXvToGhF3jI
 r1dUDLEhoDkoitAZVeXu9uKBmqTjDesNtequwqc65capR3lOK1w58HsP54hl2Et+i01k
 eqwkdr7D4G9r0hOHafFx0f5o+46X5xA82ANZM/bNXZhZUIcamuuifBXibpTm9HGrFg44
 yo41pcVRWwhVm1pT+Yl1Yl9uBWFZrr+ISZy8bY8sxWXXAOLeBBMUPVbvInNZmWEiN0y6
 Vh9lFT1jaie0thzOnMzdDn4Bp4sTme6IOoDvUbfSbN7y+ob0Q5lJShj2rvtKYjl38Y0O Zg== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q7junk1p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 12:45:36 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33RCTt3l000494;
        Thu, 27 Apr 2023 12:45:33 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3q47772esd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 12:45:31 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33RCjPhX17957474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Apr 2023 12:45:25 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54ACD20091;
        Thu, 27 Apr 2023 12:45:25 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BAB120094;
        Thu, 27 Apr 2023 12:45:25 +0000 (GMT)
Received: from osiris (unknown [9.152.212.90])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu, 27 Apr 2023 12:45:24 +0000 (GMT)
Date:   Thu, 27 Apr 2023 14:45:24 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seiden@linux.ibm.com, jgg@nvidia.com
Subject: Re: [PATCH v2 1/1] KVM: s390: fix race in gmap_make_secure
Message-ID: <ZEpuZGMY3AQq/H4D@osiris>
References: <20230426134834.35199-1-imbrenda@linux.ibm.com>
 <20230426134834.35199-2-imbrenda@linux.ibm.com>
 <ZEpUEF7H86E9vVfS@osiris>
 <20230427134649.1e482d91@p-imbrenda>
 <ZEpkFzFFEpqa9zMv@osiris>
 <20230427141711.6b071148@p-imbrenda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427141711.6b071148@p-imbrenda>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: g2NLfA_aMkrGBrDjmsdZdbq2N0W1K8jT
X-Proofpoint-ORIG-GUID: g2NLfA_aMkrGBrDjmsdZdbq2N0W1K8jT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-27_07,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=603
 malwarescore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304270111
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 27, 2023 at 02:17:11PM +0200, Claudio Imbrenda wrote:
> > > > On Wed, Apr 26, 2023 at 03:48:34PM +0200, Claudio Imbrenda wrote:  
> > > > > This patch fixes a potential race in gmap_make_secure and removes the
> > > > > last user of follow_page without FOLL_GET.
> > > > > 
> > > > > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > > > > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > > Fixes: 214d9bbcd3a6 ("s390/mm: provide memory management functions for protected KVM guests")
> > > > > ---
> > > > >  arch/s390/kernel/uv.c | 32 +++++++++++---------------------
> > > > >  1 file changed, 11 insertions(+), 21 deletions(-)    
> > > > 
> > > > It would be helpful if this would be a bit more descriptive. "Fix
> > > > race" is not very helpful :)
> > > > 
> > > > What race does this fix?
> > > > When can this happen?
> > > > What are the consequences if the race window is being hit?  
> > > 
> > > We are locking something we don't have a reference to, and as explained
> > > by Jason and David in this thread <Y9J4P/RNvY1Ztn0Q@nvidia.com> it can
> > > lead to all kind of bad things, including the page getting
> > > unmapped (MADV_DONTNEED), freed, reallocated as a larger folio and the
> > > unlock_page() would target the wrong bit.
> > > 
> > > Also there is another race with the FOLL_WRITE, which could race
> > > between the follow_page and the get_locked_pte.
> > > 
> > > The main point of the patch is to remove the last follow_page without
> > > FOLL_GET or FOLL_PIN, removing the races can be considered a nice bonus.  
> > 
> > I've seen that discussion. What I'm actually asking for is that all of
> > this information should be added to the commit description. Nobody
> > will remember any of the details in one year.
> 
> I will put it in the patch description.
> 
> do you think the text above is enough?

Fine with me. With a proper Link: tag this is much better than before.
Thanks!
