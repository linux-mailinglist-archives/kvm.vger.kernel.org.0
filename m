Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D611DBA10
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 18:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgETQqq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 12:46:46 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23633 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726821AbgETQqq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 12:46:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589993204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7vjx9ftJhMQ0P4vMekqxWsrl2y5tpT+NNgg8eoV8o3U=;
        b=VovyrsBq8JfQoXGS+LnrVkcIU6uCx6ryH+7UiKW/4kp7c9YdclloNBBk7OatJqVumENeEd
        f3hdP7iQnovl0asNkIIrPXX2RaCgYlZgwxly7NcRv8cf/lH8OvT/5vR/OVi0GxJniWOkzu
        5ykSjTNHDkJUMeTQXWdey/Ey3ZUw+74=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-SrR44d4uOamW-7TG2ZJlow-1; Wed, 20 May 2020 12:46:38 -0400
X-MC-Unique: SrR44d4uOamW-7TG2ZJlow-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D34D481CBE3;
        Wed, 20 May 2020 16:46:35 +0000 (UTC)
Received: from w520.home (ovpn-112-50.phx2.redhat.com [10.3.112.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D99BB79C2B;
        Wed, 20 May 2020 16:46:12 +0000 (UTC)
Date:   Wed, 20 May 2020 10:46:12 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, <cjia@nvidia.com>,
        <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH Kernel v22 0/8] Add UAPIs to support migration for VFIO
 devices
Message-ID: <20200520104612.03a32977@w520.home>
In-Reply-To: <97977ede-3c5b-c5a5-7858-7eecd7dd531c@nvidia.com>
References: <1589781397-28368-1-git-send-email-kwankhede@nvidia.com>
        <20200519105804.02f3cae8@x1.home>
        <20200520025500.GA10369@joy-OptiPlex-7040>
        <97977ede-3c5b-c5a5-7858-7eecd7dd531c@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 May 2020 19:10:07 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 5/20/2020 8:25 AM, Yan Zhao wrote:
> > On Tue, May 19, 2020 at 10:58:04AM -0600, Alex Williamson wrote:  
> >> Hi folks,
> >>
> >> My impression is that we're getting pretty close to a workable
> >> implementation here with v22 plus respins of patches 5, 6, and 8.  We
> >> also have a matching QEMU series and a proposal for a new i40e
> >> consumer, as well as I assume GVT-g updates happening internally at
> >> Intel.  I expect all of the latter needs further review and discussion,
> >> but we should be at the point where we can validate these proposed
> >> kernel interfaces.  Therefore I'd like to make a call for reviews so
> >> that we can get this wrapped up for the v5.8 merge window.  I know
> >> Connie has some outstanding documentation comments and I'd like to make
> >> sure everyone has an opportunity to check that their comments have been
> >> addressed and we don't discover any new blocking issues.  Please send
> >> your Acked-by/Reviewed-by/Tested-by tags if you're satisfied with this
> >> interface and implementation.  Thanks!
> >>  
> > hi Alex and Kirti,
> > after porting to qemu v22 and kernel v22, it is found out that
> > it can not even pass basic live migration test with error like
> > 
> > "Failed to get dirty bitmap for iova: 0xca000 size: 0x3000 err: 22"
> >   
> 
> Thanks for testing Yan.
> I think last moment change in below cause this failure
> 
> https://lore.kernel.org/kvm/1589871178-8282-1-git-send-email-kwankhede@nvidia.com/
> 
>  > 	if (dma->iova > iova + size)
>  > 		break;  
> 
> Surprisingly with my basic testing with 2G sys mem QEMU didn't raise 
> abort on g_free, but I do hit this with large sys mem.
> With above change, that function iterated through next vfio_dma as well. 
> Check should be as below:
> 
> -               if (dma->iova > iova + size)
> +               if (dma->iova > iova + size -1)


Or just:

	if (dma->iova >= iova + size)

Thanks,
Alex


>                          break;
> 
> Another fix is in QEMU.
> https://lists.gnu.org/archive/html/qemu-devel/2020-05/msg04751.html
> 
>  > > +        range->bitmap.size = ROUND_UP(pages, 64) / 8;  
>  >
>  > ROUND_UP(npages/8, sizeof(u64))?
>  >  
> 
> If npages < 8, npages/8 is 0 and ROUND_UP(0, 8) returns 0.
> 
> Changing it as below
> 
> -        range->bitmap.size = ROUND_UP(pages / 8, sizeof(uint64_t));
> +        range->bitmap.size = ROUND_UP(pages, sizeof(__u64) * 
> BITS_PER_BYTE) /
> +                             BITS_PER_BYTE;
> 
> I'm updating patches with these fixes and Cornelia's suggestion soon.
> 
> Due to short of time I may not be able to address all the concerns 
> raised on previous versions of QEMU, I'm trying make QEMU side code 
> available for testing for others with latest kernel changes. Don't 
> worry, I will revisit comments on QEMU patches. Right now first priority 
> is to test kernel UAPI and prepare kernel patches for 5.8
> 
> Thanks,
> Kirti
> 

