Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E57819F387
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 12:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgDFKbP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 06:31:15 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39880 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726675AbgDFKbO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Apr 2020 06:31:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586169073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Frr3U9FewSH3rwJWC1POGOuw/i/P/MIPEW7fR+tNJOo=;
        b=JZOJ5C+K2Vtfscy4FB/znZTOktwU/ZUk0ffxXCm//Qyo6sNG7Sl+MGXFKUEHsPqcmUMJVp
        JTnR3iZMP2czs3eGGsx2ICg3peec3aIttOmxp8k84URzDwh7Ii4V1FnhmnKLMKsdr62dtg
        KoYRfmsb7jfozNU9hJXl4j/SWQtgZPI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-p-t34X7RPyeNPqCCGcDabQ-1; Mon, 06 Apr 2020 06:30:47 -0400
X-MC-Unique: p-t34X7RPyeNPqCCGcDabQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE647113784E;
        Mon,  6 Apr 2020 10:30:45 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B5D8A60BF1;
        Mon,  6 Apr 2020 10:30:41 +0000 (UTC)
Subject: Re: [PATCH v2 04/22] hw/iommu: introduce HostIOMMUContext
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-5-git-send-email-yi.l.liu@intel.com>
 <aa1bfbd5-e6de-6475-809e-a6ca46089aaa@redhat.com>
 <A2975661238FB949B60364EF0F2C25743A2230B3@SHSMSX104.ccr.corp.intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <338937be-9b1e-163f-90ef-2cf0c437c3e8@redhat.com>
Date:   Mon, 6 Apr 2020 12:30:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A2230B3@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 4/6/20 10:04 AM, Liu, Yi L wrote:
> Hi Eric,
> 
>> From: Auger Eric < eric.auger@redhat.com>
>> Sent: Tuesday, March 31, 2020 1:23 AM
>> To: Liu, Yi L <yi.l.liu@intel.com>; qemu-devel@nongnu.org;
>> Subject: Re: [PATCH v2 04/22] hw/iommu: introduce HostIOMMUContext
>>
>> Yi,
>>
>> On 3/30/20 6:24 AM, Liu Yi L wrote:
>>> Currently, many platform vendors provide the capability of dual stage
>>> DMA address translation in hardware. For example, nested translation
>>> on Intel VT-d scalable mode, nested stage translation on ARM SMMUv3,
>>> and etc. In dual stage DMA address translation, there are two stages
>>> address translation, stage-1 (a.k.a first-level) and stage-2 (a.k.a
>>> second-level) translation structures. Stage-1 translation results are
>>> also subjected to stage-2 translation structures. Take vSVA (Virtual
>>> Shared Virtual Addressing) as an example, guest IOMMU driver owns
>>> stage-1 translation structures (covers GVA->GPA translation), and host
>>> IOMMU driver owns stage-2 translation structures (covers GPA->HPA
>>> translation). VMM is responsible to bind stage-1 translation structures
>>> to host, thus hardware could achieve GVA->GPA and then GPA->HPA
>>> translation. For more background on SVA, refer the below links.
>>>  - https://www.youtube.com/watch?v=Kq_nfGK5MwQ
>>>  - https://events19.lfasiallc.com/wp-content/uploads/2017/11/\
>>> Shared-Virtual-Memory-in-KVM_Yi-Liu.pdf
>>>
> [...]
>>> +void host_iommu_ctx_init(void *_iommu_ctx, size_t instance_size,
>>> +                         const char *mrtypename,
>>> +                         uint64_t flags)
>>> +{
>>> +    HostIOMMUContext *iommu_ctx;
>>> +
>>> +    object_initialize(_iommu_ctx, instance_size, mrtypename);
>>> +    iommu_ctx = HOST_IOMMU_CONTEXT(_iommu_ctx);
>>> +    iommu_ctx->flags = flags;
>>> +    iommu_ctx->initialized = true;
>>> +}
>>> +
>>> +static const TypeInfo host_iommu_context_info = {
>>> +    .parent             = TYPE_OBJECT,
>>> +    .name               = TYPE_HOST_IOMMU_CONTEXT,
>>> +    .class_size         = sizeof(HostIOMMUContextClass),
>>> +    .instance_size      = sizeof(HostIOMMUContext),
>>> +    .abstract           = true,
>> Can't we use the usual .instance_init and .instance_finalize?
> sorry, I somehow missed this comment. In prior patch, .instace_init
> was used, but the current major init method is via host_iommu_ctx_init(),
> so .instance_init is not really necessary.
> https://www.spinics.net/lists/kvm/msg210878.html

OK globally what disturbs me is you introduced a QOM object but globally
the inheritance schema is not totally clear to me (only a VFIO derived
is created and I do not understand what other backend would be able to
use it) and this does not really have the look & feel of standard QOM
objects. I tried to compare its usage/implementation version
MemoryRegion for instance.

Thanks

Eric
> Regards,
> Yi Liu
> 

