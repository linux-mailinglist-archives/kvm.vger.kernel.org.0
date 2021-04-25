Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D7C36A3F1
	for <lists+kvm@lfdr.de>; Sun, 25 Apr 2021 03:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhDYBoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Apr 2021 21:44:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47062 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229770AbhDYBoR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 24 Apr 2021 21:44:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619315018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X9SNeh6gyW1M84fzI5vwpJh2K2IpIi8tzyiDHoQ9A5k=;
        b=jFMiAhH5luN/6MCDjQFrxHEybPqZUVzvwvm73EPI5MgKCKtvdiWzRRwjYi152XR0JMGuyV
        +DkLJTXfjNJShRU8W8fPKIQcebHnE180BkaeH7gMSmaJueEKYtygVjxgVJA/kT+m9vcVvh
        4w2YjwuAEg5ABGm57+wKk1XfsM1iyIQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-IO1z8ijeMsOJOjWuTu6gLw-1; Sat, 24 Apr 2021 21:43:34 -0400
X-MC-Unique: IO1z8ijeMsOJOjWuTu6gLw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 452968030B5;
        Sun, 25 Apr 2021 01:43:32 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-44.pek2.redhat.com [10.72.13.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71BBB19C46;
        Sun, 25 Apr 2021 01:43:19 +0000 (UTC)
Subject: Re: [RFC PATCH 0/7] Untrusted device support for virtio
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        martin.radev@aisec.fraunhofer.de, konrad.wilk@oracle.com,
        kvm@vger.kernel.org
References: <20210421032117.5177-1-jasowang@redhat.com>
 <20210422063128.GB4176641@infradead.org>
 <0c61dcbb-ac5b-9815-a4a1-5f93ae640011@redhat.com>
 <20210423161114-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <708f1a31-b4dd-d0b9-cb1e-e94b75a5a752@redhat.com>
Date:   Sun, 25 Apr 2021 09:43:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210423161114-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/4/24 上午4:14, Michael S. Tsirkin 写道:
> On Thu, Apr 22, 2021 at 04:19:16PM +0800, Jason Wang wrote:
>> 在 2021/4/22 下午2:31, Christoph Hellwig 写道:
>>> On Wed, Apr 21, 2021 at 11:21:10AM +0800, Jason Wang wrote:
>>>> The behaivor for non DMA API is kept for minimizing the performance
>>>> impact.
>>> NAK.  Everyone should be using the DMA API in a modern world.  So
>>> treating the DMA API path worse than the broken legacy path does not
>>> make any sense whatsoever.
>>
>> I think the goal is not treat DMA API path worse than legacy. The issue is
>> that the management layer should guarantee that ACCESS_PLATFORM is set so
>> DMA API is guaranteed to be used by the driver. So I'm not sure how much
>> value we can gain from trying to 'fix' the legacy path. But I can change the
>> behavior of legacy path to match DMA API path.
>>
>> Thanks
> I think before we maintain different paths with/without ACCESS_PLATFORM
> it's worth checking whether it's even a net gain. Avoiding sharing
> by storing data in private memory can actually turn out to be
> a net gain even without DMA API.


I agree.


>
> It is worth checking what is the performance effect of this patch.


So I've posted v2, where private memory is used in no DMA API path (as 
what has been done in packed).

Pktgen and netperf doens't see obvious difference.

Thanks


>
>

