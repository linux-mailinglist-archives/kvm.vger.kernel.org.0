Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D25F44A73F
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 08:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243470AbhKIHFD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 02:05:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54342 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238018AbhKIHFD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Nov 2021 02:05:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636441336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pF7ryoCzsjXQ1Nwqjy1I7OneVRrOUC6wNI+lDbYFFik=;
        b=OI24j++pAjltxn/aJeF6H0nHE8HemRrKAgPrum7Y0euN+gJ4F5XidwZjs6fVa2jZpRN955
        mhjNrSMUnia5Su2u9d/ff3R6PRZORrhzWc0UFDtvAtsMi1Vxy4uHPgTape2ACfDP6qDFCr
        tuT8WtVsV8K0zIKRixMYql1N14Uf9bY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-cFp8daR9NTmV_jsDkZKq_g-1; Tue, 09 Nov 2021 02:02:15 -0500
X-MC-Unique: cFp8daR9NTmV_jsDkZKq_g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7AA20804141;
        Tue,  9 Nov 2021 07:02:14 +0000 (UTC)
Received: from [10.33.192.183] (dhcp-192-183.str.redhat.com [10.33.192.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E16C60936;
        Tue,  9 Nov 2021 07:01:58 +0000 (UTC)
Message-ID: <92a0b4a1-0888-3b99-a089-d2096272eee7@redhat.com>
Date:   Tue, 9 Nov 2021 08:01:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH 3/7] s390x: virtio: CCW transport
 implementation
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, drjones@redhat.com
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
 <1630059440-15586-4-git-send-email-pmorel@linux.ibm.com>
 <74901bd1-e69f-99d3-b11e-e0b541226d20@redhat.com>
 <509a8f4f-89cc-fe80-4200-6776c503adbf@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <509a8f4f-89cc-fe80-4200-6776c503adbf@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/11/2021 13.34, Pierre Morel wrote:
> 
> 
> On 11/3/21 08:49, Thomas Huth wrote:
>> On 27/08/2021 12.17, Pierre Morel wrote:
>>> This is the implementation of the virtio-ccw transport level.
>>>
>>> We only support VIRTIO revision 0.
>>
>> That means only legacy virtio? Wouldn't it be better to shoot for modern 
>> virtio instead?
> 
> Yes but can we do it in a second series?

Sure.

>>> +int virtio_ccw_read_features(struct virtio_ccw_device *vcdev, uint64_t 
>>> *features)
>>> +{
>>> +    struct virtio_feature_desc *f_desc = &vcdev->f_desc;
>>> +
>>> +    f_desc->index = 0;
>>> +    if (ccw_send(vcdev, CCW_CMD_READ_FEAT, f_desc, sizeof(*f_desc), 0))
>>> +        return -1;
>>> +    *features = swap32(f_desc->features);
>>> +
>>> +    f_desc->index = 1;
>>> +    if (ccw_send(vcdev, CCW_CMD_READ_FEAT, f_desc, sizeof(*f_desc), 0))
>>> +        return -1;
>>> +    *features |= (uint64_t)swap32(f_desc->features) << 32;
>>
>> Weren't the upper feature bits only available for modern virtio anyway?
> 
> Yes.
> I have the intention to upgrade to Rev. 1 when I get enough time for it.
> Should I remove this? It does not induce problem does it?

No problem - maybe simply add a comment that the upper bits are for virtio 
1.0 and later.

  Thomas

