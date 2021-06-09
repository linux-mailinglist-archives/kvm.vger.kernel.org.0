Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA80D3A10EC
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 12:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236657AbhFIKQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 06:16:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39206 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232972AbhFIKQs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 06:16:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623233694;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UGhpFhVlOYIC5kowMMVAYHo7k0EKPg3F6ebOQuwUO2Q=;
        b=Hr7h2vMJP5MFiqu8dsvSwpBzdSIUviOr/30iuUvRzBPNfToCP+OgqBE9lEbuY1NbvqtVCp
        lTRfDIf+CJxl0c0CbgEXmREhxnlp93ptDgVnaisTczuQGA2H3dKsZkBvgrP4axb/yhHJui
        xWLNo5EvRhsYKgTC8JyfCaQ3gcZkOK0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-0LSBqE8RPPiw94B434Zybw-1; Wed, 09 Jun 2021 06:14:52 -0400
X-MC-Unique: 0LSBqE8RPPiw94B434Zybw-1
Received: by mail-wr1-f69.google.com with SMTP id e11-20020a056000178bb0290119c11bd29eso5693558wrg.2
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 03:14:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=UGhpFhVlOYIC5kowMMVAYHo7k0EKPg3F6ebOQuwUO2Q=;
        b=tyaC3JAK8RSHI3yqoTmOmuPxrB6SdW5VlGW1mH1iVEtDo3yG5RmXR2v9wjTsiYDAHG
         ypNLPcx8Lytg53O50cwFatBB+tcHYCQH/tVhAxP3V54UMjgJT15PYLHWua8f5hh4Nksm
         /jOcqz/anGkINlP8d9Mp57T+XTOHsy/nY5QOU6Z6nuURAQBwdzHNREPxwGjQO9KFhyJc
         ni+dVujaHvb1P2/vboFs5xHzWbi1OIxahEsSQDj4qMzpkTf1VRh1LVcvnpuh1/4uaLPg
         iBWogdAhJslw/feuiYOLqgQwzgRKIbkKjCZy1pr02nZhDFl1cjHHUhqmfH7xv3E+NJHn
         LzVA==
X-Gm-Message-State: AOAM530tF6ZwFQw+pIsGg5jHMc2ZMJ5j+x/YrAJO65odyEnJSb09zo3u
        pP5GjrS0h5aQuL/YMIU7KfKAyv5cQE0bW6ztX9eTWvgPva2QmWPWFdx3+R7X+RBvr3Or49ffuqG
        qVNGsXdZMRtFp
X-Received: by 2002:a05:600c:1d1b:: with SMTP id l27mr15988808wms.62.1623233691356;
        Wed, 09 Jun 2021 03:14:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPzb12xOqzJBjs300yp5Am4sprlPGLIaJs+P2xzrS5KjO/tgbq9Rys/XuEfnxApGxtTlyRzQ==
X-Received: by 2002:a05:600c:1d1b:: with SMTP id l27mr15988778wms.62.1623233691155;
        Wed, 09 Jun 2021 03:14:51 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id r3sm4058615wmq.8.2021.06.09.03.14.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 03:14:50 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: Plan for /dev/ioasid RFC v2
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
 <b1bb72b5-cb98-7739-8788-01e36ec415a8@redhat.com>
 <MWHPR11MB1886FEFB5C8358EB65DBEA1A8C369@MWHPR11MB1886.namprd11.prod.outlook.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <8a3f2bc6-79b7-5dfb-492a-21c0af7b9c2c@redhat.com>
Date:   Wed, 9 Jun 2021 12:14:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <MWHPR11MB1886FEFB5C8358EB65DBEA1A8C369@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

On 6/9/21 11:37 AM, Tian, Kevin wrote:
>> From: Eric Auger <eric.auger@redhat.com>
>> Sent: Wednesday, June 9, 2021 4:15 PM
>>
>> Hi Kevin,
>>
>> On 6/7/21 4:58 AM, Tian, Kevin wrote:
>>> Hi, all,
>>>
>>> We plan to work on v2 now, given many good comments already received
>>> and substantial changes envisioned. This is a very complex topic with
>>> many sub-threads being discussed. To ensure that I didn't miss valuable
>>> suggestions (and also keep everyone on the same page), here I'd like to
>>> provide a list of planned changes in my mind. Please let me know if
>>> anything important is lost.  :)
>>>
>>> --
>>>
>>> (Remaining opens in v1)
>>>
>>> -   Protocol between kvm/vfio/ioasid for wbinvd/no-snoop. I'll see how
>>>     much can be refined based on discussion progress when v2 is out;
>>>
>>> -   Device-centric (Jason) vs. group-centric (David) uAPI. David is not fully
>>>     convinced yet. Based on discussion v2 will continue to have ioasid uAPI
>>>     being device-centric (but it's fine for vfio to be group-centric). A new
>>>     section will be added to elaborate this part;
>>>
>>> -   PASID virtualization (section 4) has not been thoroughly discussed yet.
>>>     Jason gave some suggestion on how to categorize intended usages.
>>>     I will rephrase this section and hope more discussions can be held for
>>>     it in v2;
>>>
>>> (Adopted suggestions)
>>>
>>> -   (Jason) Rename /dev/ioasid to /dev/iommu (so does uAPI e.g. IOASID
>>>     _XXX to IOMMU_XXX). One suggestion (Jason) was to also rename
>>>     RID+PASID to SID+SSID. But given the familiarity of the former, I will
>>>     still use RID+PASID in v2 to ease the discussoin;
>>>
>>> -   (Jason) v1 prevents one device from binding to multiple ioasid_fd's. This
>>>     will be fixed in v2;
>>>
>>> -   (Jean/Jason) No need to track guest I/O page tables on ARM/AMD.
>> When
>>>     a pasid table is bound, it becomes a container for all guest I/O page
>> tables;
>> while I am totally in line with that change, I guess we need to revisit
>> the invalidate ioctl
>> to support PASID table invalidation.
> Yes, this is planned when doing this change.
OK
>
>>> -   (Jean/Jason) Accordingly a device label is required so iotlb invalidation
>>>     and fault handling can both support per-device operation. Per Jean's
>>>     suggestion, this label will come from userspace (when VFIO_BIND_
>>>     IOASID_FD);
>> what is not totally clear to me is the correspondance between this label
>> and the SID/SSID tuple.
>> My understanding is it rather maps to the SID because you can attach
>> several ioasids to the device.
>> So it is not clear to me how you reconstruct the SSID info
>>
> Yes, device handle maps to SID. The fault data reported to userspace
> will include {device_label, ioasid, vendor_fault_data}. In your case
> I believe SSID will be included in vendor_fault_data thus no reconstruct
> required. For Intel the user could figure out vPASID according to device_
> label and ioasid, i.e. no need to include PASID info in vendor_fault_data.
OK that works.

Thanks

Eric
>
> Thanks
> Kevin

