Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5769C6F0543
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 14:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243583AbjD0MC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 08:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243215AbjD0MC6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 08:02:58 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310125249;
        Thu, 27 Apr 2023 05:02:57 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33RC1uME008953;
        Thu, 27 Apr 2023 12:02:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=WQqbqw8Dk24fd7dt43IolbjnFRtm9rDGQ/pIbOJ9xT4=;
 b=TEs4HeTftYqBgKjq/TFafCimE55xIn6oYFx/LzoHi9V2Ic5+SvnhhBDKin++tg44YTLA
 5fIeDPx00gH02TBsa7j1dUpwlJsBoQaftQQ+S8F63uADRLovPcMnArZM0+SAy1I1kXEF
 8S3VmaEKxYqDHdkft3LHB4iiVMXU4jauQHlzryhcrb1A/ZsNE0BG01MRnzpisznn+GJz
 8B1cg9GsaEJFbE+4ShZw0zrtji/Knh+2q9tUtAaqUS7cxblxR9uE83ThbqI5c4NBaJJn
 iRlhBHLKK/Gl5FDwT1VZD+TYkAcoAB8CnwUVzIH3yCSH9yJ1nrvcFc2oQbUptJYbtT/0 TA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q7junj34e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 12:02:52 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33R2u6hC026844;
        Thu, 27 Apr 2023 12:01:33 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3q47772xy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 12:01:33 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33RC1SYV53871096
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Apr 2023 12:01:28 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F7FC20043;
        Thu, 27 Apr 2023 12:01:28 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD76B20040;
        Thu, 27 Apr 2023 12:01:27 +0000 (GMT)
Received: from osiris (unknown [9.152.212.90])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu, 27 Apr 2023 12:01:27 +0000 (GMT)
Date:   Thu, 27 Apr 2023 14:01:27 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seiden@linux.ibm.com, jgg@nvidia.com
Subject: Re: [PATCH v2 1/1] KVM: s390: fix race in gmap_make_secure
Message-ID: <ZEpkFzFFEpqa9zMv@osiris>
References: <20230426134834.35199-1-imbrenda@linux.ibm.com>
 <20230426134834.35199-2-imbrenda@linux.ibm.com>
 <ZEpUEF7H86E9vVfS@osiris>
 <20230427134649.1e482d91@p-imbrenda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427134649.1e482d91@p-imbrenda>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LLcr1T1ItDCWmazol86xFND65gqBeZLa
X-Proofpoint-ORIG-GUID: LLcr1T1ItDCWmazol86xFND65gqBeZLa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-27_07,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=563
 malwarescore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304270102
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 27, 2023 at 01:46:49PM +0200, Claudio Imbrenda wrote:
> On Thu, 27 Apr 2023 12:53:04 +0200
> Heiko Carstens <hca@linux.ibm.com> wrote:
> 
> > On Wed, Apr 26, 2023 at 03:48:34PM +0200, Claudio Imbrenda wrote:
> > > This patch fixes a potential race in gmap_make_secure and removes the
> > > last user of follow_page without FOLL_GET.
> > > 
> > > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > > Fixes: 214d9bbcd3a6 ("s390/mm: provide memory management functions for protected KVM guests")
> > > ---
> > >  arch/s390/kernel/uv.c | 32 +++++++++++---------------------
> > >  1 file changed, 11 insertions(+), 21 deletions(-)  
> > 
> > It would be helpful if this would be a bit more descriptive. "Fix
> > race" is not very helpful :)
> > 
> > What race does this fix?
> > When can this happen?
> > What are the consequences if the race window is being hit?
> 
> We are locking something we don't have a reference to, and as explained
> by Jason and David in this thread <Y9J4P/RNvY1Ztn0Q@nvidia.com> it can
> lead to all kind of bad things, including the page getting
> unmapped (MADV_DONTNEED), freed, reallocated as a larger folio and the
> unlock_page() would target the wrong bit.
> 
> Also there is another race with the FOLL_WRITE, which could race
> between the follow_page and the get_locked_pte.
> 
> The main point of the patch is to remove the last follow_page without
> FOLL_GET or FOLL_PIN, removing the races can be considered a nice bonus.

I've seen that discussion. What I'm actually asking for is that all of
this information should be added to the commit description. Nobody
will remember any of the details in one year.
