Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2FF1E1566
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 22:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390836AbgEYU4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 16:56:30 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4222 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390817AbgEYU43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 16:56:29 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ecc30ab0000>; Mon, 25 May 2020 13:55:07 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 25 May 2020 13:56:29 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 25 May 2020 13:56:29 -0700
Received: from [10.2.58.199] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 May
 2020 20:56:29 +0000
Subject: Re: [PATCH v3 3/3] vfio-pci: Invalidate mmaps and block MMIO access
 on disabled memory
To:     Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cohuck@redhat.com>, <cai@lca.pw>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <159017449210.18853.15037950701494323009.stgit@gimli.home>
 <159017506369.18853.17306023099999811263.stgit@gimli.home>
 <20200523193417.GI766834@xz-x1> <20200523170602.5eb09a66@x1.home>
 <20200523235257.GC939059@xz-x1> <20200525122607.GC744@ziepe.ca>
 <20200525142806.GC1058657@xz-x1> <20200525144651.GE744@ziepe.ca>
 <20200525151142.GE1058657@xz-x1> <20200525165637.GG744@ziepe.ca>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <3d9c1c8b-5278-1c4d-0e9c-e6f8fdb75853@nvidia.com>
Date:   Mon, 25 May 2020 13:56:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200525165637.GG744@ziepe.ca>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590440107; bh=mZysOd1QSiEigolQ8hgnjUdmLlF/gyT8pGtK6k3rS+I=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=SWe1pufSO5sOhzDhzw9FORr9IxV3d2pqwczuexNQ8i/rSIdTPJapPS+xjsVmjUx+j
         8AexDFSia74cHhz9UOfLvRGUhDEp2cf7jkplVC3Mt/Rfk0FNuEUT4jxtPV2hgkMUOb
         dc46G8WMaN9n2tvlh+JASE8owmtRpb8tJICS3M6z1ehjXHaZ+6MngGzLU4/+33s0O6
         Vsq5pXorjAoY5UmdS3qZo1jAad4+XzjE4Ozuz76I/7GfeZTDA4demB8WyaXQz1Kt7I
         ecRbj0Hvq4WglA9i7Po2nRX0unF41cf/93qAK5qhjyyEuaKbATmKUzrDCM2lxjQCGr
         sEgX43LJiWtKg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-05-25 09:56, Jason Gunthorpe wrote:
> On Mon, May 25, 2020 at 11:11:42AM -0400, Peter Xu wrote:
>> On Mon, May 25, 2020 at 11:46:51AM -0300, Jason Gunthorpe wrote:
>>> On Mon, May 25, 2020 at 10:28:06AM -0400, Peter Xu wrote:
>>>> On Mon, May 25, 2020 at 09:26:07AM -0300, Jason Gunthorpe wrote:
>>>>> On Sat, May 23, 2020 at 07:52:57PM -0400, Peter Xu wrote:
>>>>>
>>>>>> For what I understand now, IMHO we should still need all those handlings of
>>>>>> FAULT_FLAG_RETRY_NOWAIT like in the initial version.  E.g., IIUC KVM gup will
>>>>>> try with FOLL_NOWAIT when async is allowed, before the complete slow path.  I'm
>>>>>> not sure what would be the side effect of that if fault() blocked it.  E.g.,
>>>>>> the caller could be in an atomic context.
>>>>>
>>>>> AFAICT FAULT_FLAG_RETRY_NOWAIT only impacts what happens when
>>>>> VM_FAULT_RETRY is returned, which this doesn't do?
>>>>
>>>> Yes, that's why I think we should still properly return VM_FAULT_RETRY if
>>>> needed..  because IMHO it is still possible that the caller calls with
>>>> FAULT_FLAG_RETRY_NOWAIT.
>>>>
>>>> My understanding is that FAULT_FLAG_RETRY_NOWAIT majorly means:
>>>>
>>>>    - We cannot release the mmap_sem, and,
>>>>    - We cannot sleep
>>>
>>> Sleeping looks fine, look at any FS implementation of fault, say,
>>> xfs. The first thing it does is xfs_ilock() which does down_write().
>>
>> Yeah.  My wild guess is that maybe fs code will always be without
>> FAULT_FLAG_RETRY_NOWAIT so it's safe to sleep unconditionally (e.g., I think
>> the general #PF should be fine to sleep in fault(); gup should be special, but
>> I didn't observe any gup code called upon file systems)?
> 
> get_user_pages is called on filesystem backed pages.
> 
> I have no idea what FAULT_FLAG_RETRY_NOWAIT is supposed to do. Maybe
> John was able to guess when he reworked that stuff?
> 

Although I didn't end up touching that particular area, I'm sure it's going
to come up sometime soon, so I poked around just now, and found that
FAULT_FLAG_RETRY_NOWAIT was added almost exactly 9 years ago. This flag was
intended to make KVM and similar things behave better when doing GUP on
file-backed pages that might, or might not be in memory.

The idea is described in the changelog, but not in the code comments or
Documentation, sigh:

commit 318b275fbca1ab9ec0862de71420e0e92c3d1aa7
Author: Gleb Natapov <gleb@redhat.com>
Date:   Tue Mar 22 16:30:51 2011 -0700

     mm: allow GUP to fail instead of waiting on a page

     GUP user may want to try to acquire a reference to a page if it is already
     in memory, but not if IO, to bring it in, is needed.  For example KVM may
     tell vcpu to schedule another guest process if current one is trying to
     access swapped out page.  Meanwhile, the page will be swapped in and the
     guest process, that depends on it, will be able to run again.

     This patch adds FAULT_FLAG_RETRY_NOWAIT (suggested by Linus) and
     FOLL_NOWAIT follow_page flags.  FAULT_FLAG_RETRY_NOWAIT, when used in
     conjunction with VM_FAULT_ALLOW_RETRY, indicates to handle_mm_fault that
     it shouldn't drop mmap_sem and wait on a page, but return VM_FAULT_RETRY
     instead.

If that helps, maybe documentation approximately like this might be welcome
(against linux-next, so I'm using mmap_lock, instead of mmap_sem), below.
Or is this overkill? People like minimal documentation in the code, so maybe
this belongs in Documentation, if anywhere:

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8429d5aa31e44..e32e8e52a57ac 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -430,6 +430,15 @@ extern pgprot_t protection_map[16];
   * continuous faults with flags (b).  We should always try to detect pending
   * signals before a retry to make sure the continuous page faults can still be
   * interrupted if necessary.
+ *
+ * About @FAULT_FLAG_RETRY_NOWAIT: this is intended for callers who would like
+ * to acquire a page, but only if the page is already in memory. If, on the
+ * other hand, the page requires IO in order to bring it into memory, then fault
+ * handlers will immediately return VM_FAULT_RETRY ("don't wait"), while leaving
+ * mmap_lock held ("don't drop mmap_lock"). For example, this is useful for
+ * virtual machines that have multiple guests running: if guest A attempts
+ * get_user_pages() on a swapped out page, another guest can be scheduled while
+ * waiting for IO to swap in guest A's page.
   */
  #define FAULT_FLAG_WRITE                       0x01
  #define FAULT_FLAG_MKWRITE                     0x02


thanks,
-- 
John Hubbard
NVIDIA
