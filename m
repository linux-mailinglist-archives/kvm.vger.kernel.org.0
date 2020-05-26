Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA7D1E188A
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 02:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387888AbgEZAqk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 20:46:40 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:19572 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgEZAqj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 20:46:39 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ecc66930001>; Mon, 25 May 2020 17:45:11 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 25 May 2020 17:46:39 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 25 May 2020 17:46:39 -0700
Received: from [10.2.58.199] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 May
 2020 00:46:35 +0000
Subject: Re: [PATCH v3 3/3] vfio-pci: Invalidate mmaps and block MMIO access
 on disabled memory
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Peter Xu <peterx@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cohuck@redhat.com>, <cai@lca.pw>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <159017506369.18853.17306023099999811263.stgit@gimli.home>
 <20200523193417.GI766834@xz-x1> <20200523170602.5eb09a66@x1.home>
 <20200523235257.GC939059@xz-x1> <20200525122607.GC744@ziepe.ca>
 <20200525142806.GC1058657@xz-x1> <20200525144651.GE744@ziepe.ca>
 <20200525151142.GE1058657@xz-x1> <20200525165637.GG744@ziepe.ca>
 <3d9c1c8b-5278-1c4d-0e9c-e6f8fdb75853@nvidia.com>
 <20200526003705.GK744@ziepe.ca>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <b30fdc87-31e7-cb45-dab3-c37322ce05b1@nvidia.com>
Date:   Mon, 25 May 2020 17:46:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200526003705.GK744@ziepe.ca>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590453911; bh=4+5X1bqe7iUQBAG8+uP1hdKTijQrIwV/IvAYXW5YUYA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Yf5b2cOe6nNsHghXhQGAUs5IZv0j9/Jpj66m2TAneQzjW6V6SsrTZgb89zPd5ijoy
         chROg5GT4uAWMUqqD+BKEwGroiFUZeCynFsST9B5qCLDixOV1PMJDBXLg3n2ZP7grg
         Blcl9PBvzlRusobX4J5iA4qCOzvdzLHMTqn1hTZWNwE1EKlWlXnjmCTQE0MqVBv96l
         hAaNNJZGv4Q1RtGKLfSr8z9+6qmmDCs3OhOrrwuzu7hpOep4uMUwPxwnuTc0XS3tuZ
         ZJOdIcLtt6IszgyMxT5LPAGJeUFuoU6/bXv/zGLIMvCwlvyyvUftHkk/2A8vtdQ3/3
         9PCtZXvVUaFxA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-05-25 17:37, Jason Gunthorpe wrote:
...
>> commit 318b275fbca1ab9ec0862de71420e0e92c3d1aa7
>> Author: Gleb Natapov <gleb@redhat.com>
>> Date:   Tue Mar 22 16:30:51 2011 -0700
>>
>>      mm: allow GUP to fail instead of waiting on a page
>>
>>      GUP user may want to try to acquire a reference to a page if it is already
>>      in memory, but not if IO, to bring it in, is needed.  For example KVM may
>>      tell vcpu to schedule another guest process if current one is trying to
>>      access swapped out page.  Meanwhile, the page will be swapped in and the
>>      guest process, that depends on it, will be able to run again.
>>
>>      This patch adds FAULT_FLAG_RETRY_NOWAIT (suggested by Linus) and
>>      FOLL_NOWAIT follow_page flags.  FAULT_FLAG_RETRY_NOWAIT, when used in
>>      conjunction with VM_FAULT_ALLOW_RETRY, indicates to handle_mm_fault that
>>      it shouldn't drop mmap_sem and wait on a page, but return VM_FAULT_RETRY
>>      instead.
> 
> So, from kvm's perspective it was to avoid excessively long blocking in
> common paths when it could rejoin the completed IO by somehow waiting
> on a page itself?


Or perhaps some variation on that, such as just retrying with an intervening
schedule() call. It's not clear just from that commit.

> 
> It all seems like it should not be used unless the page is going to go
> to IO?


That's my conclusion so far, yes.


> 
> Certainly there is no reason to optimize the fringe case of vfio
> sleeping if there is and incorrect concurrnent attempt to disable the
> a BAR.


Definitely agree with that position.

> 
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 8429d5aa31e44..e32e8e52a57ac 100644
>> +++ b/include/linux/mm.h
>> @@ -430,6 +430,15 @@ extern pgprot_t protection_map[16];
>>    * continuous faults with flags (b).  We should always try to detect pending
>>    * signals before a retry to make sure the continuous page faults can still be
>>    * interrupted if necessary.
>> + *
>> + * About @FAULT_FLAG_RETRY_NOWAIT: this is intended for callers who would like
>> + * to acquire a page, but only if the page is already in memory. If, on the
>> + * other hand, the page requires IO in order to bring it into memory, then fault
>> + * handlers will immediately return VM_FAULT_RETRY ("don't wait"), while leaving
>> + * mmap_lock held ("don't drop mmap_lock"). For example, this is useful for
>> + * virtual machines that have multiple guests running: if guest A attempts
>> + * get_user_pages() on a swapped out page, another guest can be scheduled while
>> + * waiting for IO to swap in guest A's page.
>>    */
>>   #define FAULT_FLAG_WRITE                       0x01
>>   #define FAULT_FLAG_MKWRITE                     0x02
> 
> It seems reasonable but people might complain about the kvm
> specifics of the explanation.
> 
> It might be better to explain how the caller is supposed to know when
> it is OK to try GUP again and expect success, as it seems to me this
> is really about externalizing the sleep for page wait?
> 

OK, good point. The example was helpful in the commit log, but not quite
appropriate in mm.h, yes.

thanks,
-- 
John Hubbard
NVIDIA
