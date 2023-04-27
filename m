Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7246F051D
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 13:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243729AbjD0LrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 07:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243201AbjD0LrE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 07:47:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03454C01;
        Thu, 27 Apr 2023 04:47:02 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33RBawxf005329;
        Thu, 27 Apr 2023 11:47:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=T7d+5jR3X4qIbS2arwV6AFNn0EjK2Y3UhN3yBUMaB8c=;
 b=bp0zi0zSQijFTWBDR+je+AjvfE1/bT0BPQqt1plQ9S60oSxk8EFcVLFzPjnL/g/3vfAD
 qacGz2x5ZuXXeaIFmpoOcwEcYrpEjzJfQJiA3ByHQkhaadr12/q15jqeiaQdWwe8GUPF
 hFePi0RPF1161W0d467QxcB04JDFVxcfdqFkjWPprwteaRbUagSjFNKrhjiHJdosSAS3
 rTPi6MndRbS0SCCTMomSNJHkq/Rw/LiUOAQbqM8+gLEOKaCt3Nqj7ngqvjY53fQEWfhg
 srXa2ArM9y0/PT43IkTJbQOSaHAn79fOxNT6CMGeXwejqvVRLS1Lt4xJxzpcwS6gAo81 lA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q7mp5fhas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 11:47:01 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33R1efkW014311;
        Thu, 27 Apr 2023 11:46:58 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3q47772e1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 11:46:58 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33RBkpqM42533216
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Apr 2023 11:46:51 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F06A20063;
        Thu, 27 Apr 2023 11:46:51 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4380E2004F;
        Thu, 27 Apr 2023 11:46:51 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 27 Apr 2023 11:46:51 +0000 (GMT)
Date:   Thu, 27 Apr 2023 13:46:49 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seiden@linux.ibm.com, jgg@nvidia.com
Subject: Re: [PATCH v2 1/1] KVM: s390: fix race in gmap_make_secure
Message-ID: <20230427134649.1e482d91@p-imbrenda>
In-Reply-To: <ZEpUEF7H86E9vVfS@osiris>
References: <20230426134834.35199-1-imbrenda@linux.ibm.com>
        <20230426134834.35199-2-imbrenda@linux.ibm.com>
        <ZEpUEF7H86E9vVfS@osiris>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2dfRSZKvCdx--75g5gZXU2l6elzZK5lg
X-Proofpoint-ORIG-GUID: 2dfRSZKvCdx--75g5gZXU2l6elzZK5lg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-27_07,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 mlxlogscore=613 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 spamscore=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304270102
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 Apr 2023 12:53:04 +0200
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Wed, Apr 26, 2023 at 03:48:34PM +0200, Claudio Imbrenda wrote:
> > This patch fixes a potential race in gmap_make_secure and removes the
> > last user of follow_page without FOLL_GET.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Fixes: 214d9bbcd3a6 ("s390/mm: provide memory management functions for protected KVM guests")
> > ---
> >  arch/s390/kernel/uv.c | 32 +++++++++++---------------------
> >  1 file changed, 11 insertions(+), 21 deletions(-)  
> 
> It would be helpful if this would be a bit more descriptive. "Fix
> race" is not very helpful :)
> 
> What race does this fix?
> When can this happen?
> What are the consequences if the race window is being hit?

We are locking something we don't have a reference to, and as explained
by Jason and David in this thread <Y9J4P/RNvY1Ztn0Q@nvidia.com> it can
lead to all kind of bad things, including the page getting
unmapped (MADV_DONTNEED), freed, reallocated as a larger folio and the
unlock_page() would target the wrong bit.

Also there is another race with the FOLL_WRITE, which could race
between the follow_page and the get_locked_pte.

The main point of the patch is to remove the last follow_page without
FOLL_GET or FOLL_PIN, removing the races can be considered a nice bonus.
