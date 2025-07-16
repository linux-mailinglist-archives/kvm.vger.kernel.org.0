Return-Path: <kvm+bounces-52631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04D49B07542
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 14:04:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A3FB3BC073
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 12:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01C71291C09;
	Wed, 16 Jul 2025 12:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="q9/jU5K/"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D92B1FECB0
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 12:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752667452; cv=none; b=bmGD7uia2ypYURwHcymdUSYYmcj1dnAYlSRH7QivygqZ2XwCV7/uZcx8FMoFJu8HYKksIk7LTRZG773/fwLmg8wKP8nc7Gds9GlwNgkivHZp5WsN6E9Jtno8X+jL0aXZoKLb4qh0/1WESUw3ksjukBZ9lCYwxXuG8rjsD6meLNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752667452; c=relaxed/simple;
	bh=Pk41JK6LzfRd2cw/qc/Fq4Tdhf822PAQYuv1/ufSLwU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pl+Jf58rL7ZEd8FWXYFj6aktsR5jBBmjEEi6IZ24BXYOJp3xQZLNWFP0e2558XBIv3TxEEk7ArhOwcZ4lXNjablpGxyKsi6DL5vwrSafI9zc6o4rxdII0zUD2+o6qu04y00oBkyBfE/vPozMDvJwZVf5Qd20az9EsCzSMgrWgbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=q9/jU5K/ reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from [157.82.206.39] ([157.82.206.39])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 56GC480g035139
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 16 Jul 2025 21:04:08 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=vMV67TVLAh3aCny89PBJAPim2yFAca+LdlfBZ2bhUvI=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250326; t=1752667448; v=1;
        b=q9/jU5K/AJKxDpShYA+GUsf7UIpPq8vsDrIu1VnB8/AuFbuvvdWkSple68lsErGZ
         PRMH3kxNZM+bMNXqcuTsx+OzvKpkdQUtB+TCJbeYwEBgIJKMukF7oCBXzYj6YG43
         /EnflSpubosv/A5ZXtVVdfxwrEbXo6cdu7ZEczE/TzPkYhL+qBL6cTLGHgHGjkJQ
         OhV09zIzyBxXSkQ9oCj7K7FTeNhOfUn/E1lK6A56e/LdvyUBN/aMdVHH/kkZgtlt
         NoEEtJbjbC8CRuM7hFPxYtYssj/HuU1lFvaXBOCU4taO+aK++q06upsR6jc/FzeZ
         puwKZchHaO1JlF0Jp2mXEw==
Message-ID: <dc6a7170-3a36-4b9b-b5fe-f05564100049@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 16 Jul 2025 21:04:07 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 13/13] net: implement UDP tunnel features
 offloading
To: Paolo Abeni <pabeni@redhat.com>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Jason Wang
 <jasowang@redhat.com>,
        Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, Luigi Rizzo <lrizzo@google.com>,
        Giuseppe Lettieri
 <g.lettieri@iet.unipi.it>,
        Vincenzo Maffione <v.maffione@gmail.com>,
        Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
        kvm@vger.kernel.org
References: <cover.1752229731.git.pabeni@redhat.com>
 <509e49207e4dc4a10ef36492a2ee1f90f3c2c237.1752229731.git.pabeni@redhat.com>
 <f266ffe9-f601-46cc-85be-515475cbfe12@rsg.ci.i.u-tokyo.ac.jp>
 <1d582df4-2995-423c-8b6c-351beaf94139@redhat.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <1d582df4-2995-423c-8b6c-351beaf94139@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/07/16 19:13, Paolo Abeni wrote:
> On 7/15/25 10:07 AM, Akihiko Odaki wrote:
>> On 2025/07/11 22:02, Paolo Abeni wrote:
>>> When any host or guest GSO over UDP tunnel offload is enabled the
>>> virtio net header includes the additional tunnel-related fields,
>>> update the size accordingly.
>>>
>>> Push the GSO over UDP tunnel offloads all the way down to the tap
>>> device extending the newly introduced NetFeatures struct, and
>>> eventually enable the associated features.
>>>
>>> As per virtio specification, to convert features bit to offload bit,
>>> map the extended features into the reserved range.
>>>
>>> Finally, make the vhost backend aware of the exact header layout, to
>>> copy it correctly. The tunnel-related field are present if either
>>> the guest or the host negotiated any UDP tunnel related feature:
>>> add them to host kernel supported features list, to allow qemu
>>> transfer to such backend the needed information.
>>
>> Please also update: hw/virtio/virtio-qmp.c
> 
> Do you mean by adding FEATURE_ENTRY() for
> {GUEST,HOST}_UDP_TUNNEL_GSO{,_CSUM} ?

Yes.

> 
> Such entries are added in patch 8/13 "qmp: update virtio features map to
> support extended features". Even if the features are not supported yet
> in such patch, I think the code could already parse their name.
> 
> Do you prefer I move the features entry definition here?

No, I missed what patch 8/13 did. There is no change needed here.

Regards,
Akihiko Odaki

