Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEC2270E4
	for <lists+kvm@lfdr.de>; Wed, 22 May 2019 22:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730028AbfEVUik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 16:38:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57318 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728761AbfEVUij (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 May 2019 16:38:39 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4MKbIwR079461
        for <kvm@vger.kernel.org>; Wed, 22 May 2019 16:38:38 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sncbravxn-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 22 May 2019 16:38:38 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <rppt@linux.ibm.com>;
        Wed, 22 May 2019 21:38:36 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 22 May 2019 21:38:33 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4MKcW4Y50397334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 May 2019 20:38:32 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E2C5AE045;
        Wed, 22 May 2019 20:38:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87F48AE04D;
        Wed, 22 May 2019 20:38:31 +0000 (GMT)
Received: from rapoport-lnx (unknown [9.148.205.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 22 May 2019 20:38:31 +0000 (GMT)
Date:   Wed, 22 May 2019 23:38:29 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] mm/gup: continue VM_FAULT_RETRY processing event for
 pre-faults
References: <1557844195-18882-1-git-send-email-rppt@linux.ibm.com>
 <20190522122113.a2edc8aba32f0fad189bae21@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522122113.a2edc8aba32f0fad189bae21@linux-foundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-TM-AS-GCONF: 00
x-cbid: 19052220-0020-0000-0000-0000033F6D06
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052220-0021-0000-0000-0000219253D1
Message-Id: <20190522203828.GC18865@rapoport-lnx>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905220144
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(added kvm)

On Wed, May 22, 2019 at 12:21:13PM -0700, Andrew Morton wrote:
> On Tue, 14 May 2019 17:29:55 +0300 Mike Rapoport <rppt@linux.ibm.com> wrote:
> 
> > When get_user_pages*() is called with pages = NULL, the processing of
> > VM_FAULT_RETRY terminates early without actually retrying to fault-in all
> > the pages.
> > 
> > If the pages in the requested range belong to a VMA that has userfaultfd
> > registered, handle_userfault() returns VM_FAULT_RETRY *after* user space
> > has populated the page, but for the gup pre-fault case there's no actual
> > retry and the caller will get no pages although they are present.
> > 
> > This issue was uncovered when running post-copy memory restore in CRIU
> > after commit d9c9ce34ed5c ("x86/fpu: Fault-in user stack if
> > copy_fpstate_to_sigframe() fails").
> > 
> > After this change, the copying of FPU state to the sigframe switched from
> > copy_to_user() variants which caused a real page fault to get_user_pages()
> > with pages parameter set to NULL.
> 
> You're saying that argument buf_fx in copy_fpstate_to_sigframe() is NULL?

Apparently I haven't explained well. The 'pages' parameter in the call to
get_user_pages_unlocked() is NULL.
 
> If so was that expected by the (now cc'ed) developers of
> d9c9ce34ed5c8923 ("x86/fpu: Fault-in user stack if
> copy_fpstate_to_sigframe() fails")?
> 
> It seems rather odd.  copy_fpregs_to_sigframe() doesn't look like it's
> expecting a NULL argument.
> 
> Also, I wonder if copy_fpstate_to_sigframe() would be better using
> fault_in_pages_writeable() rather than get_user_pages_unlocked().  That
> seems like it operates at a more suitable level and I guess it will fix
> this issue also.

If I understand correctly, one of the points of d9c9ce34ed5c8923 ("x86/fpu:
Fault-in user stack if copy_fpstate_to_sigframe() fails") was to to avoid
page faults, hence the use of get_user_pages().

With fault_in_pages_writeable() there might be a page fault, unless I've
completely mistaken.

Unrelated to copy_fpstate_to_sigframe(), the issue could happen if any call
to get_user_pages() with pages parameter set to NULL tries to access
userfaultfd-managed memory. Currently, there are 4 in tree users:

arch/x86/kernel/fpu/signal.c:198:8-31:  -> gup with !pages
arch/x86/mm/mpx.c:423:11-25:  -> gup with !pages
virt/kvm/async_pf.c:90:1-22:  -> gup with !pages
virt/kvm/kvm_main.c:1437:6-20:  -> gup with !pages

I don't know if anybody is using mpx with uffd and anyway mpx seems to go
away.

As for KVM, I think that post-copy live migration of L2 guest might trigger
that as well. Not sure though, I'm not really familiar with KVM code.
 
> > In post-copy mode of CRIU, the destination memory is managed with
> > userfaultfd and lack of the retry for pre-fault case in get_user_pages()
> > causes a crash of the restored process.
> > 
> > Making the pre-fault behavior of get_user_pages() the same as the "normal"
> > one fixes the issue.
> 
> Should this be backported into -stable trees?

I think that it depends on whether KVM affected by this or not.

> > Fixes: d9c9ce34ed5c ("x86/fpu: Fault-in user stack if copy_fpstate_to_sigframe() fails")
> > Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> 
> 

-- 
Sincerely yours,
Mike.

