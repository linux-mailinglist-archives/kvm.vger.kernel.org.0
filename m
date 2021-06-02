Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE24139849A
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 10:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhFBIyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 04:54:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37394 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229904AbhFBIyP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Jun 2021 04:54:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622623952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9ArZvpLSAQuv5CBVhrYmEmSDRDRVYj1zP8TVHlpX3nA=;
        b=N55LO5U0fXUOlaO9UnIcoWZRiSWPlkXx8Cw+gqb5N9nrDIPH7EgVFXzwvtGiTUKPMNGejA
        XZtBzIRGuEHWbz19ff45X2nnFCWgA/fhWwOIGZEdUCRucmCd3LhzeqC8KRqaUj62dWjUzd
        2gKKEZ+5g3yCM7qMiJSnm8GuFPDtL9s=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-3YL2Ek8lP3yfndiGdJJXXA-1; Wed, 02 Jun 2021 04:52:30 -0400
X-MC-Unique: 3YL2Ek8lP3yfndiGdJJXXA-1
Received: by mail-pg1-f199.google.com with SMTP id t10-20020a6564ca0000b02902205085fa58so1257710pgv.16
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 01:52:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=9ArZvpLSAQuv5CBVhrYmEmSDRDRVYj1zP8TVHlpX3nA=;
        b=oJedfmqnlGBHit281zYz/jAutU503HQB+LVL6f7YKE0XdbjrlVmQA0thnNPZrDo4PL
         K2oDZb8+5GIFOvqK5jy1BeNk5X1r/CRp6e97d52JO93XUZrzQnW7L//2brcjzI8mSLK3
         Ilx6mmdmljzM171IWrfXY0p8rOauZFRmk7EA+4XT0iodNKA5RsCpTm6p2fH1krDv5eKJ
         aSyWFcjmu2po4Sg5ZtHVRSbkQ9lT7NUrTqMLiagiLGVvo1h8CT1V95oIktAi2KWcyDmo
         d1LVBSvwezUVpDLlCbG88h1UqWLM77Em1P9eXeRbxKE9hPkab3yJ+fmvLhIIbsvKV0zO
         1OCA==
X-Gm-Message-State: AOAM530mXAm5J6p7Jk31pHmuwm99JYJJ8xfpueyE/PYfiY7iay+smlf8
        ffW3pgyKciko1nvDj6NMte805JJ0jNqLE2YbXIVvRHEC/uIunDMj2xqHNTNNm4PsHL4mVZZ47wX
        gxCEnU2gZPQSN
X-Received: by 2002:a05:6a00:856:b029:28e:e5d2:9a62 with SMTP id q22-20020a056a000856b029028ee5d29a62mr25918429pfk.17.1622623949418;
        Wed, 02 Jun 2021 01:52:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6352chW2w8JBVfW8qE6tyLLdIANPog+tIL9JC4Kxa2bdk25eLDpPcxihKlfwVlgGmyGjSHg==
X-Received: by 2002:a05:6a00:856:b029:28e:e5d2:9a62 with SMTP id q22-20020a056a000856b029028ee5d29a62mr25918402pfk.17.1622623949178;
        Wed, 02 Jun 2021 01:52:29 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a20sm6829660pfk.145.2021.06.02.01.52.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 01:52:28 -0700 (PDT)
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528200311.GP1002214@nvidia.com>
 <MWHPR11MB188685D57653827B566BF9B38C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210601202834.GR1002214@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1a3b4cf2-f511-640b-6c8c-a85f94a9536d@redhat.com>
Date:   Wed, 2 Jun 2021 16:52:02 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210601202834.GR1002214@nvidia.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/6/2 ÉÏÎç4:28, Jason Gunthorpe Ð´µÀ:
>> I summarized five opens here, about:
>>
>> 1)  Finalizing the name to replace /dev/ioasid;
>> 2)  Whether one device is allowed to bind to multiple IOASID fd's;
>> 3)  Carry device information in invalidation/fault reporting uAPI;
>> 4)  What should/could be specified when allocating an IOASID;
>> 5)  The protocol between vfio group and kvm;
>>
>> For 1), two alternative names are mentioned: /dev/iommu and
>> /dev/ioas. I don't have a strong preference and would like to hear
>> votes from all stakeholders. /dev/iommu is slightly better imho for
>> two reasons. First, per AMD's presentation in last KVM forum they
>> implement vIOMMU in hardware thus need to support user-managed
>> domains. An iommu uAPI notation might make more sense moving
>> forward. Second, it makes later uAPI naming easier as 'IOASID' can
>> be always put as an object, e.g. IOMMU_ALLOC_IOASID instead of
>> IOASID_ALLOC_IOASID.:)
> I think two years ago I suggested /dev/iommu and it didn't go very far
> at the time.


It looks to me using "/dev/iommu" excludes the possibility of 
implementing IOASID in a device specific way (e.g through the 
co-operation with device MMU + platform IOMMU)?

What's more, ATS spec doesn't forbid the device #PF to be reported via a 
device specific way.

Thanks


> We've also talked about this as /dev/sva for a while and
> now /dev/ioasid
>
> I think /dev/iommu is fine, and call the things inside them IOAS
> objects.
>
> Then we don't have naming aliasing with kernel constructs.
>   

