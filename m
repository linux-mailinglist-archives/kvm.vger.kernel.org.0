Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59ED818C1F2
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 21:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgCSUyc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 16:54:32 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:52289 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725787AbgCSUyb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Mar 2020 16:54:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584651270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hjYV+wyQpR7B3d18pGkcaBgDOBTqUbQeqCdfhG5P9bo=;
        b=bxRQax2KOIvVQ8vCVGS2SgaQuwAMYHMkknuSolDAvevK95u+NMjCd71TmUS1CZ0VhdSu35
        pV0APy0kNcEmVqVdCGErKwq8qGi6Xfr+LIUiGaHeOwCbDTgB+COeVzGB6Y4y+A3hjk36C0
        O1MwnUiS9czP95Sgz7CCNe8sGTY1NJE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-p0LYqKLYNvCQK8jTVjAaFQ-1; Thu, 19 Mar 2020 16:54:26 -0400
X-MC-Unique: p0LYqKLYNvCQK8jTVjAaFQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCD30800D4E;
        Thu, 19 Mar 2020 20:54:23 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 09B57BBBFD;
        Thu, 19 Mar 2020 20:54:21 +0000 (UTC)
Date:   Thu, 19 Mar 2020 14:54:21 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     <cjia@nvidia.com>, <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v14 Kernel 4/7] vfio iommu: Implementation of ioctl for
 dirty pages tracking.
Message-ID: <20200319145421.4b8bd4eb@w520.home>
In-Reply-To: <8e537411-b60e-cc45-498c-5e516382206e@nvidia.com>
References: <1584560474-19946-1-git-send-email-kwankhede@nvidia.com>
        <1584560474-19946-5-git-send-email-kwankhede@nvidia.com>
        <20200318214500.1a0cb985@w520.home>
        <e0070cf4-af58-2906-b427-0888ecb89538@nvidia.com>
        <20200319102238.77686a08@w520.home>
        <8e537411-b60e-cc45-498c-5e516382206e@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Mar 2020 01:55:10 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 3/19/2020 9:52 PM, Alex Williamson wrote:
> > On Thu, 19 Mar 2020 20:22:41 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >   
> >> On 3/19/2020 9:15 AM, Alex Williamson wrote:  
> >>> On Thu, 19 Mar 2020 01:11:11 +0530
> >>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >>>      
> 
> <snip>
> 
> >>>> +
> >>>> +static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
> >>>> +{
> >>>> +	uint64_t bsize;
> >>>> +
> >>>> +	if (!npages || !bitmap_size || bitmap_size > UINT_MAX)  
> >>>
> >>> As commented previously, how do we derive this UINT_MAX limitation?
> >>>      
> >>
> >> Sorry, I missed that earlier
> >>  
> >>   > UINT_MAX seems arbitrary, is this specified in our API?  The size of a
> >>   > vfio_dma is limited to what the user is able to pin, and therefore
> >>   > their locked memory limit, but do we have an explicit limit elsewhere
> >>   > that results in this limit here.  I think a 4GB bitmap would track
> >>   > something like 2^47 bytes of memory, that's pretty excessive, but still
> >>   > an arbitrary limit.  
> >>
> >> There has to be some upper limit check. In core KVM, in
> >> virt/kvm/kvm_main.c there is max number of pages check:
> >>
> >> if (new.npages > KVM_MEM_MAX_NR_PAGES)
> >>
> >> Where
> >> /*
> >>    * Some of the bitops functions do not support too long bitmaps.
> >>    * This number must be determined not to exceed such limits.
> >>    */
> >> #define KVM_MEM_MAX_NR_PAGES ((1UL << 31) - 1)
> >>
> >> Though I don't know which bitops functions do not support long bitmaps.
> >>
> >> Something similar as above can be done or same as you also mentioned of
> >> 4GB bitmap limit? that is U32_MAX instead of UINT_MAX?  
> > 
> > Let's see, we use bitmap_set():
> > 
> > void bitmap_set(unsigned long *map, unsigned int start, unsigned int nbits)
> > 
> > So we're limited to an unsigned int number of bits, but for an
> > unaligned, multi-bit operation this will call __bitmap_set():
> > 
> > void __bitmap_set(unsigned long *map, unsigned int start, int len)
> > 
> > So we're down to a signed int number of bits (seems like an API bug in
> > bitops there), so it makes sense that KVM is testing against MAX_INT
> > number of pages, ie. number of bits.  But that still suggests a bitmap
> > size of MAX_UINT is off by a factor of 16.  So we can have 2^31 bits
> > divided by 2^3 bits/byte yields a maximum bitmap size of 2^28 (ie.
> > 256MB), which maps 2^31 * 2^12 = 2^43 (8TB) on a 4K system.
> > 
> > Let's fix the limit check and put a nice comment explaining it.  Thanks,
> >   
> 
> Agreed. Adding DIRTY_BITMAP_SIZE_MAX macro and comment as below.
> 
> /*
>   * Input argument of number of bits to bitmap_set() is unsigned 
> integer, which
>   * further casts to signed integer for unaligned multi-bit operation,
>   * __bitmap_set().
>   * Then maximum bitmap size supported is 2^31 bits divided by 2^3 
> bits/byte,
>   * that is 2^28 (256 MB) which maps to 2^31 * 2^12 = 2^43 (8TB) on 4K page
>   * system.
>   */
> #define DIRTY_BITMAP_PAGES_MAX  ((1UL << 31) - 1)

nit, can we just use INT_MAX here?

> #define DIRTY_BITMAP_SIZE_MAX 	\
> 			DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
> 
> 
> Thanks,
> Kirti
> 

