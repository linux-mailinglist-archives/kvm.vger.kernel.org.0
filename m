Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A83326BA43
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 04:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgIPCe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 22:34:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21064 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726260AbgIPCeZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Sep 2020 22:34:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600223663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qnumBkA+KwFilA4RJOFxl4BV5Ql5BJOBeoDcSO1RlRY=;
        b=aCNcGLavzxPNlcyuE3SEyq5DE+T5u8CeYURjtVoZWT1FDjdU2Zzdd92f0k7F+pCBvcythU
        T9Bc0Zax4rt2Np//Nl+Io6+dWhQxQAprWx/oXk9iuONjAWt5kOhnvJi9wBEugtlP5lKOcD
        j8nigaD18zxUz9wAEoFs0qG7eAP1aJk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-p9uQ44heN9OKqanwlBSB6w-1; Tue, 15 Sep 2020 22:34:20 -0400
X-MC-Unique: p9uQ44heN9OKqanwlBSB6w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA4241084C80;
        Wed, 16 Sep 2020 02:34:17 +0000 (UTC)
Received: from [10.72.13.186] (ovpn-13-186.pek2.redhat.com [10.72.13.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A2821C4;
        Wed, 16 Sep 2020 02:33:56 +0000 (UTC)
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
To:     "Raj, Ashok" <ashok.raj@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Liu Yi L <yi.l.liu@intel.com>, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org, kevin.tian@intel.com,
        jacob.jun.pan@linux.intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, peterx@redhat.com, hao.wu@intel.com,
        stefanha@gmail.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jacon Jun Pan <jacob.jun.pan@intel.com>
References: <20200914162247.GA63399@otc-nc-03>
 <20200914163354.GG904879@nvidia.com> <20200914105857.3f88a271@x1.home>
 <20200914174121.GI904879@nvidia.com> <20200914122328.0a262a7b@x1.home>
 <20200914190057.GM904879@nvidia.com> <20200914224438.GA65940@otc-nc-03>
 <20200915113341.GW904879@nvidia.com> <20200915181154.GA70770@otc-nc-03>
 <20200915184510.GB1573713@nvidia.com> <20200915192632.GA71024@otc-nc-03>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9e865ab2-9ff9-8af4-7051-96a42f270f06@redhat.com>
Date:   Wed, 16 Sep 2020 10:33:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200915192632.GA71024@otc-nc-03>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/9/16 上午3:26, Raj, Ashok wrote:
>>> IIUC, you are asking that part of the interface to move to a API interface
>>> that potentially the new /dev/sva and VFIO could share? I think the API's
>>> for PASID management themselves are generic (Jean's patchset + Jacob's
>>> ioasid set management).
>> Yes, the in kernel APIs are pretty generic now, and can be used by
>> many types of drivers.
> Good, so there is no new requirements here I suppose.


The requirement is not for in-kernel APIs but a generic uAPIs.


>> As JasonW kicked this off, VDPA will need all this identical stuff
>> too. We already know this, and I think Intel VDPA HW will need it, so
>> it should concern you too:)
> This is one of those things that I would disagree and commit :-)..
>
>> A PASID vIOMMU solution sharable with VDPA and VFIO, based on a PASID
>> control char dev (eg /dev/sva, or maybe /dev/iommu) seems like a
>> reasonable starting point for discussion.
> Looks like now we are getting closer to what we need.:-)
>
> Given that PASID api's are general purpose today and any driver can use it
> to take advantage. VFIO fortunately or unfortunately has the IOMMU things
> abstracted. I suppose that support is also mostly built on top of the
> generic iommu* api abstractions in a vendor neutral way?
>
> I'm still lost on what is missing that vDPA can't build on top of what is
> available?


For sure it can, but we may end up duplicated (or similar) uAPIs which 
is bad.

Thanks


>
> Cheers,
> Ashok
>

