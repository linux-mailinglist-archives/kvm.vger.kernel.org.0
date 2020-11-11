Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49262AF58D
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 16:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbgKKP4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 10:56:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21805 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726817AbgKKP4r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Nov 2020 10:56:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605110206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=suRdJwLnXLetr79Suk7ebRlOZN0VSf/hg9yKDNSdV0U=;
        b=OCIqJe6atSb3Ongj9hh2nKIuvIDNXXlqOcyY0SnUu+nvLcUjf1ToIxSXlFsmMntR27qO9c
        EmTLwi19fclM9hUHd/njdl/o4LcbvBnnYx9VflDLhILyOUdyxAyY4AwYPE6oHS8g6MFu3X
        859DsBnIFx9Udks5679579u+UaGObMg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-SRrrHpkwOMCtGy7yEhbCdg-1; Wed, 11 Nov 2020 10:56:42 -0500
X-MC-Unique: SRrrHpkwOMCtGy7yEhbCdg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DD8D803F41;
        Wed, 11 Nov 2020 15:56:40 +0000 (UTC)
Received: from w520.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0D2760CD0;
        Wed, 11 Nov 2020 15:56:39 +0000 (UTC)
Date:   Wed, 11 Nov 2020 08:56:39 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "xuxiaoyang (C)" <xuxiaoyang2@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <kwankhede@nvidia.com>, <wu.wubin@huawei.com>,
        <maoming.maoming@huawei.com>, <xieyingtai@huawei.com>,
        <lizhengui@huawei.com>, <wubinfeng@huawei.com>
Subject: Re: [PATCH] vfio iommu type1: Improve vfio_iommu_type1_pin_pages
 performance
Message-ID: <20201111085639.7235fb42@w520.home>
In-Reply-To: <2553f102-de17-b23b-4cd8-fefaf2a04f24@huawei.com>
References: <2553f102-de17-b23b-4cd8-fefaf2a04f24@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 10 Nov 2020 21:42:33 +0800
"xuxiaoyang (C)" <xuxiaoyang2@huawei.com> wrote:

> vfio_iommu_type1_pin_pages is very inefficient because
> it is processed page by page when calling vfio_pin_page_external.
> Added contiguous_vaddr_get_pfn to process continuous pages
> to reduce the number of loops, thereby improving performance.

vfio_pin_pages() accepts an array of unrelated iova pfns and processes
each to return the physical pfn.  AFAICT this proposal makes an
unfounded and unverified assumption that the caller is asking for a
range of contiguous iova pfns.  That's not the semantics of the call.
This is wrong.  Thanks,

Alex

