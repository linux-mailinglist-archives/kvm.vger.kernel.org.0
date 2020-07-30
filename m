Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87042339FC
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 22:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgG3Us5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 16:48:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50208 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbgG3Us4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 16:48:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06UKgHEh101584;
        Thu, 30 Jul 2020 20:48:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Cqjec/JmJLo7a5VR/JGr2Y+AIOuHwIGHZrb6qGXqEIw=;
 b=ciwC00u6FHi2+R0x/txxaIzTO2qoFcexcEIhCYoUaE/+dwmKZdvBI8hyBxuqGxFLWpxp
 9ntMbAL6HK55vNU5fyrXeSiPBc5Z5XRVRZ4J3PvdQ9GDsDTOp69bs/Msh9MD/wnS/0+K
 SGyNfYKtS5dI62EOL8+iI8aPeQJ44dkmIALCgWQoAhHqoqUe6Iog/iVYS+Fu02Tb8VJZ
 MG9m3TE/uK32EfoqICucDUORK10MfudmTHDmfp/oiSrtdUcjHp7SWXfh+ew0rzh8ugGA
 tMB5OmKwfsmJqfK9w4APUIXHw26fmr3CK2835ENRlFNPAwJJhJMVLY21BUqOdgE+IeGI CQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32hu1jwwf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 30 Jul 2020 20:48:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06UKhSH7161581;
        Thu, 30 Jul 2020 20:48:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32hu5xcnst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jul 2020 20:48:26 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06UKmGi1032069;
        Thu, 30 Jul 2020 20:48:21 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Jul 2020 13:48:15 -0700
Date:   Thu, 30 Jul 2020 16:57:05 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Hugh Dickins <hughd@google.com>
Cc:     Pengfei Li <fly@kernel.page>, akpm@linux-foundation.org,
        bmt@zurich.ibm.com, dledford@redhat.com, willy@infradead.org,
        vbabka@suse.cz, kirill.shutemov@linux.intel.com, jgg@ziepe.ca,
        alex.williamson@redhat.com, cohuck@redhat.com,
        daniel.m.jordan@oracle.com, dbueso@suse.de, jglisse@redhat.com,
        jhubbard@nvidia.com, ldufour@linux.ibm.com,
        Liam.Howlett@oracle.com, peterz@infradead.org, cl@linux.com,
        jack@suse.cz, rientjes@google.com, walken@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/2] mm, util: account_locked_vm() does not hold mmap_lock
Message-ID: <20200730205705.ityqlyeswzo5dkow@ca-dmjordan1.us.oracle.com>
References: <20200726080224.205470-1-fly@kernel.page>
 <20200726080224.205470-2-fly@kernel.page>
 <alpine.LSU.2.11.2007291121280.4649@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.2007291121280.4649@eggly.anvils>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9698 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007300145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9698 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 mlxlogscore=999
 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007300145
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 29, 2020 at 12:21:11PM -0700, Hugh Dickins wrote:
> On Sun, 26 Jul 2020, Pengfei Li wrote:
> 
> > Since mm->locked_vm is already an atomic counter, account_locked_vm()
> > does not need to hold mmap_lock.
> 
> I am worried that this patch, already added to mmotm, along with its
> 1/2 making locked_vm an atomic64, might be rushed into v5.9 with just
> that two-line commit description, and no discussion at all.
> 
> locked_vm belongs fundamentally to mm/mlock.c, and the lock to guard
> it is mmap_lock; and mlock() has some complicated stuff to do under
> that lock while it decides how to adjust locked_vm.
>
> It is very easy to convert an unsigned long to an atomic64_t, but
> "atomic read, check limit and do stuff, atomic add" does not give
> the same guarantee as holding the right lock around it all.

Yes, this is why I withdrew my attempt to do something similar last year, I
didn't want to make the accounting racy.  Stack and heap growing and mremap
would be affected in addition to mlock.

It'd help to hear more about the motivation for this.

Daniel
