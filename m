Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1647A47C0
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 13:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbjIRLCk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 07:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjIRLCK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 07:02:10 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4521194;
        Mon, 18 Sep 2023 04:02:03 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38IAcCco032249;
        Mon, 18 Sep 2023 11:01:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=b4Sdvna41FxYoNTJKFMCbyBKytypM4xsTtpbA7PEhO4=;
 b=LAmvNVBWd3UxUgz/0SaAkea3vCNyJgP3iZBdirXsnlNy1aNH/evHeLPxAnLj5w8ZD1Oq
 EKa/uAygA/+WM33smLcWbX3aWk62Fsi4zooohAgz6QfCzMiYXOr50iaTirOX6qwrpO+d
 WZLSTnLqyvMbaMunTX9eAnb1Tv4TSqJnQHcwH8XqK5lRpIpHFv1mkk+Lva0DnXudNHi3
 L8os1Fpu1pDyuzJe+G4Cwl7u4WFuTvLsVYSYyfkeFCsm+1nUQfRdAWHoHEJA96nmqAVT
 abDxLMOAtJ0sx134V6G3yhKhmQ+kO+4AvSkUUA1q+nAnCBTydVrf7s+tRIjlydn3VvW0 qw== 
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t6m0qt4b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Sep 2023 11:01:49 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38I97sdM016463;
        Mon, 18 Sep 2023 11:01:48 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3t5sd1hf5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Sep 2023 11:01:48 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38IB1jdV25428696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Sep 2023 11:01:45 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95A2720043;
        Mon, 18 Sep 2023 11:01:45 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5ADDE20040;
        Mon, 18 Sep 2023 11:01:45 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 18 Sep 2023 11:01:45 +0000 (GMT)
Date:   Mon, 18 Sep 2023 13:01:43 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/3] Use arch_make_folio_accessible() everywhere
Message-ID: <20230918130143.1c865f12@p-imbrenda>
In-Reply-To: <ZQSfz1Kx9/QhN64E@casper.infradead.org>
References: <20230915172829.2632994-1-willy@infradead.org>
        <20230915195450.1fd35f48@p-imbrenda>
        <ZQSfz1Kx9/QhN64E@casper.infradead.org>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MdVxyNtlXmxn96i-bW9xtSaOS3Vc683F
X-Proofpoint-ORIG-GUID: MdVxyNtlXmxn96i-bW9xtSaOS3Vc683F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-18_02,2023-09-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 adultscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2308100000 definitions=main-2309180092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Sep 2023 19:17:51 +0100
Matthew Wilcox <willy@infradead.org> wrote:

> On Fri, Sep 15, 2023 at 07:54:50PM +0200, Claudio Imbrenda wrote:
> > On Fri, 15 Sep 2023 18:28:25 +0100
> > "Matthew Wilcox (Oracle)" <willy@infradead.org> wrote:
> >   
> > > We introduced arch_make_folio_accessible() a couple of years
> > > ago, and it's in use in the page writeback path.  GUP still uses
> > > arch_make_page_accessible(), which means that we can succeed in making
> > > a single page of a folio accessible, then fail to make the rest of the
> > > folio accessible when it comes time to do writeback and it's too late
> > > to do anything about it.  I'm not sure how much of a real problem this is.
> > > 
> > > Switching everything around to arch_make_folio_accessible() also lets
> > > us switch the page flag to be per-folio instead of per-page, which is
> > > a good step towards dynamically allocated folios.  
> > 
> > if I understand correctly, this will as a matter of fact move the
> > security property from pages to folios.  
> 
> Correct.
> 
> > this means that trying to access a page will (try to) make the whole
> > folio accessible, even though that might be counterproductive.... 
> > 
> > and there is no way to simply split a folio
> > 
> > I don't like this  
> 
> As I said in the cover letter, we already make the entire folio
> accessible in the writeback path.  I suppose if you never write the
> folio back, this is new ...
> 
> Anyway, looking forward to a more substantial discussion on Monday.

this will be a wall of text, sorry

first some definitions:

* secure page
page belonging to a secure guest, accessible by the guest, not
accessible by the host

* shared page
page belonging to a secure guest, accessible by the guest and by the
host. the guest decides which pages to share

* pinned shared
the host can force a page to stay shared; when the guest wants to
unshare it, a vm-exit event happens. this allows the host to make sure
the page is allowed become secure again before allowing the page to be
unshared

* exported
page with guest content, encrypted and integrity protected, no longer
accessible by the guest, but accessible by the host

* made accessible
a page is pinned shared, or, if that fails, exported.


now let's see how we use the arch-bit in struct page:

the arch-bit that is used to track whether the page is secure or not.
the bit MUST be set whenever a page is secure, and MAY be set for
non-secure pages. in general it should not be set for non-secure pages,
for performance reasons. sometimes we have small windows where
non-secure pages can have the bit set.

sometimes the arch-bit is used to determine whether further processing
(e.g. export) is needed.

when a page transitions from non-secure to secure, we must make sure
that no I/O is possibly happening on it. we do this in 2 ways at the
same time:

* make sure the page is not in writeback, and if so wait until the
  writeback is over

* make sure the page does not have any extra references except for the
  mapping itself. this means no-one else is trying to use the page for
  any other purpose, e.g. direct I/O.

  >> If the page has extra references, we wait until they are dropped <<


each time a guest tries to touch an exported page, it gets imported.
it's important to track the security property of each page individually.


and this is the most important thing, and the root of all our issues:

	>> we MUST NOT do any kind of I/O on secure pages <<


now let's see what happens for writeback. if a folio is in writeback,
all of it is going to be written back. so all of it needs to be made
accessible. once the I/O is over, the pages can be accessed again.


let's see what happens for other types of I/O (e.g. direct I/O)

currently, when we try to do direct I/O on a specific page,
pin_user_pages() will cause the pages to be made accessible. the
other neighbouring pages will stay secure and keep the arch bit set.

if the security property tracking gets moved to a whole folio, then you
can have a situation where the guest asks for I/O on a shared page, and
then tries to access a neighbouring page... which will hang until the
I/O is done, since the rest of folio has now been exported.

even worse, virtio requires individual guest pages to be shared
with the host. the host needs to do pin_user_pages() on those pages to
make sure they stay there, since they will be accessed directly. the pin
stays as long as the corresponding virtio devices are configured (i.e.
until the guest shuts down or reboots). with your changes, the whole
folio will be made accessible, both the shared page (pin shared) and the
remaining pages in the folio (exported). when the guest tries to access
the remaining pages, it will fail, triggering an import in the host. the
host will then proceed to wait forever.....


if I understand correctly, we have no control over the size of the
folios, and no way to split folios, so there is no solution to this.

