Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8855B2D4181
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 12:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731134AbgLIL4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 06:56:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33128 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730695AbgLIL4b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 06:56:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607514904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AAGWrTXE2wtUiOQk5bJL+e+smh03p2zf7YVDeW5MSN8=;
        b=SA6HbTJYp5jkOY4z10daWjaL9pu/W0FVRMzeW2ekn6H1/3v6KcXrusY+bJ+1Pupg5oWVQR
        /k4BW5Y6CHwABop68ZtLzPQEBa39mAh6SBgO3hlihcg4m2cd1X30ladktaDMkdUKsNs3JN
        mU3OKFv+RKjVMHtObbOzEixjIELZSK8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-mONXM4exMaKNZ9X_88D0Sw-1; Wed, 09 Dec 2020 06:55:00 -0500
X-MC-Unique: mONXM4exMaKNZ9X_88D0Sw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB4C96D529;
        Wed,  9 Dec 2020 11:54:58 +0000 (UTC)
Received: from gondolin (ovpn-113-135.ams2.redhat.com [10.36.113.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BCDFF7092B;
        Wed,  9 Dec 2020 11:54:52 +0000 (UTC)
Date:   Wed, 9 Dec 2020 12:54:50 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     "xuxiaoyang (C)" <xuxiaoyang2@huawei.com>,
        Eric Farman <farman@linux.ibm.com>
Cc:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        <kwankhede@nvidia.com>, <wu.wubin@huawei.com>,
        <maoming.maoming@huawei.com>, <xieyingtai@huawei.com>,
        <lizhengui@huawei.com>, <wubinfeng@huawei.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: Re: [PATCH v2] vfio iommu type1: Improve vfio_iommu_type1_pin_pages
 performance
Message-ID: <20201209125450.3f5834ab.cohuck@redhat.com>
In-Reply-To: <4d58b74d-72bb-6473-9523-aeaa392a470e@huawei.com>
References: <60d22fc6-88d6-c7c2-90bd-1e8eccb1fdcc@huawei.com>
        <4d58b74d-72bb-6473-9523-aeaa392a470e@huawei.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 8 Dec 2020 21:55:53 +0800
"xuxiaoyang (C)" <xuxiaoyang2@huawei.com> wrote:

> On 2020/11/21 15:58, xuxiaoyang (C) wrote:
> > vfio_pin_pages() accepts an array of unrelated iova pfns and processes
> > each to return the physical pfn.  When dealing with large arrays of
> > contiguous iovas, vfio_iommu_type1_pin_pages is very inefficient because
> > it is processed page by page.In this case, we can divide the iova pfn
> > array into multiple continuous ranges and optimize them.  For example,
> > when the iova pfn array is {1,5,6,7,9}, it will be divided into three
> > groups {1}, {5,6,7}, {9} for processing.  When processing {5,6,7}, the
> > number of calls to pin_user_pages_remote is reduced from 3 times to onc=
e.
> > For single page or large array of discontinuous iovas, we still use
> > vfio_pin_page_external to deal with it to reduce the performance loss
> > caused by refactoring.
> >=20
> > Signed-off-by: Xiaoyang Xu <xuxiaoyang2@huawei.com>

(...)

>=20
> hi Cornelia Huck, Eric Farman, Zhenyu Wang, Zhi Wang
>=20
> vfio_pin_pages() accepts an array of unrelated iova pfns and processes
> each to return the physical pfn.  When dealing with large arrays of
> contiguous iovas, vfio_iommu_type1_pin_pages is very inefficient because
> it is processed page by page.  In this case, we can divide the iova pfn
> array into multiple continuous ranges and optimize them.  I have a set
> of performance test data for reference.
>=20
> The patch was not applied
>                     1 page           512 pages
> no huge pages=EF=BC=9A     1638ns           223651ns
> THP=EF=BC=9A               1668ns           222330ns
> HugeTLB=EF=BC=9A           1526ns           208151ns
>=20
> The patch was applied
>                     1 page           512 pages
> no huge pages       1735ns           167286ns
> THP=EF=BC=9A               1934ns           126900ns
> HugeTLB=EF=BC=9A           1713ns           102188ns
>=20
> As Alex Williamson said, this patch lacks proof that it works in the
> real world. I think you will have some valuable opinions.

Looking at this from the vfio-ccw angle, I'm not sure how much this
would buy us, as we deal with IDAWs, which are designed so that they
can be non-contiguous. I guess this depends a lot on what the guest
does.

Eric, any opinion? Do you maybe also happen to have a test setup that
mimics workloads actually seen in the real world?

