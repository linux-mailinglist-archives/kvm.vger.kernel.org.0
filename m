Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1E56F0598
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 14:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243863AbjD0MRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 08:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243386AbjD0MR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 08:17:27 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0115B4C37;
        Thu, 27 Apr 2023 05:17:24 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33RBvAHQ017905;
        Thu, 27 Apr 2023 12:17:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ClN6svg5Zbke6G0BMK6b7HlcsiI44LgCgTwEaaJW9M8=;
 b=kmSFr1CXti/kglDD+dZes7LK7kKGp0PyHYZLwbiT0O8M9xPvLsSm/5ri/XmtVaGod4go
 iVTZ16zLXQ+KZklahXs/L12B/bId+43ZrnZ8w0yk3AMh/2XrXCVxdzX9KBS9bzdEl00b
 HvOhd7jUUN8g66nfOWV5qmUrsQWSTPL2K2zA0K5rRZp8+yCc6LLBTBKF1eyzyPcoHH5e
 1dVWH9fydVTFrJVNjFhX3qe/N0zEg6CR1lTZxzXfwk55qsOv1dRnSIEI7nSnXTgUw2zV
 1niAXiEjrNmMKHljbGfESfBBZ4mT5lIoMGlvTZQhfJ/g3tQomUwUIyvKlEywS5FZHvH5 AQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q7nru5nkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 12:17:22 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33QLrcxP007999;
        Thu, 27 Apr 2023 12:17:19 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3q47772xnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 12:17:19 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33RCHECT21299536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Apr 2023 12:17:14 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 320C52004D;
        Thu, 27 Apr 2023 12:17:14 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C70FB20040;
        Thu, 27 Apr 2023 12:17:13 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 27 Apr 2023 12:17:13 +0000 (GMT)
Date:   Thu, 27 Apr 2023 14:17:11 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seiden@linux.ibm.com, jgg@nvidia.com
Subject: Re: [PATCH v2 1/1] KVM: s390: fix race in gmap_make_secure
Message-ID: <20230427141711.6b071148@p-imbrenda>
In-Reply-To: <ZEpkFzFFEpqa9zMv@osiris>
References: <20230426134834.35199-1-imbrenda@linux.ibm.com>
        <20230426134834.35199-2-imbrenda@linux.ibm.com>
        <ZEpUEF7H86E9vVfS@osiris>
        <20230427134649.1e482d91@p-imbrenda>
        <ZEpkFzFFEpqa9zMv@osiris>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PDs8fp8EefkxdtV-yjHqzbCTSpNMHlzc
X-Proofpoint-ORIG-GUID: PDs8fp8EefkxdtV-yjHqzbCTSpNMHlzc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-27_07,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 bulkscore=0 mlxlogscore=732 impostorscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304270106
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 Apr 2023 14:01:27 +0200
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Thu, Apr 27, 2023 at 01:46:49PM +0200, Claudio Imbrenda wrote:
> > On Thu, 27 Apr 2023 12:53:04 +0200
> > Heiko Carstens <hca@linux.ibm.com> wrote:
> >   
> > > On Wed, Apr 26, 2023 at 03:48:34PM +0200, Claudio Imbrenda wrote:  
> > > > This patch fixes a potential race in gmap_make_secure and removes the
> > > > last user of follow_page without FOLL_GET.
> > > > 
> > > > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > > > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > Fixes: 214d9bbcd3a6 ("s390/mm: provide memory management functions for protected KVM guests")
> > > > ---
> > > >  arch/s390/kernel/uv.c | 32 +++++++++++---------------------
> > > >  1 file changed, 11 insertions(+), 21 deletions(-)    
> > > 
> > > It would be helpful if this would be a bit more descriptive. "Fix
> > > race" is not very helpful :)
> > > 
> > > What race does this fix?
> > > When can this happen?
> > > What are the consequences if the race window is being hit?  
> > 
> > We are locking something we don't have a reference to, and as explained
> > by Jason and David in this thread <Y9J4P/RNvY1Ztn0Q@nvidia.com> it can
> > lead to all kind of bad things, including the page getting
> > unmapped (MADV_DONTNEED), freed, reallocated as a larger folio and the
> > unlock_page() would target the wrong bit.
> > 
> > Also there is another race with the FOLL_WRITE, which could race
> > between the follow_page and the get_locked_pte.
> > 
> > The main point of the patch is to remove the last follow_page without
> > FOLL_GET or FOLL_PIN, removing the races can be considered a nice bonus.  
> 
> I've seen that discussion. What I'm actually asking for is that all of
> this information should be added to the commit description. Nobody
> will remember any of the details in one year.

I will put it in the patch description.

do you think the text above is enough?
