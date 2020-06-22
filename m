Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A632032E7
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 11:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgFVJHq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 05:07:46 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51650 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725952AbgFVJHp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 05:07:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592816864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uYoQXSzwclqSNX+q/yIlo00opb3YPsUI2zyXrlleGws=;
        b=a+2gipN97RSZA8vu7wpp0FwPoezaSoHIiI31gimWp4zYOUvrXIXS5RvEVNHyoKkvaeHR/T
        6t//Hyq2MzjMYkoOJkBNJP7dN+6IADbWosFHFcrOzKGbIT+mahs3GfF3BJZF6QDwn+wgQZ
        wopFP/FHmg03cXlNdTULcW6y2564tZc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-SQJRxOhlMqa4Bpmmejm1fA-1; Mon, 22 Jun 2020 05:07:41 -0400
X-MC-Unique: SQJRxOhlMqa4Bpmmejm1fA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 294EE801503;
        Mon, 22 Jun 2020 09:07:40 +0000 (UTC)
Received: from [10.72.13.194] (ovpn-13-194.pek2.redhat.com [10.72.13.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E1D2071664;
        Mon, 22 Jun 2020 09:07:34 +0000 (UTC)
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
To:     Eugenio Perez Martin <eperezma@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20200611113404.17810-1-mst@redhat.com>
 <20200611113404.17810-3-mst@redhat.com>
 <20200611152257.GA1798@char.us.oracle.com>
 <CAJaqyWdwXMX0JGhmz6soH2ZLNdaH6HEdpBM8ozZzX9WUu8jGoQ@mail.gmail.com>
 <CAJaqyWdwgy0fmReOgLfL4dAv-E+5k_7z3d9M+vHqt0aO2SmOFg@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b6347dad-89e8-61f6-6394-65c301f91dd7@redhat.com>
Date:   Mon, 22 Jun 2020 17:07:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAJaqyWdwgy0fmReOgLfL4dAv-E+5k_7z3d9M+vHqt0aO2SmOFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/6/20 上午2:07, Eugenio Perez Martin wrote:
> On Mon, Jun 15, 2020 at 2:28 PM Eugenio Perez Martin
> <eperezma@redhat.com> wrote:
>> On Thu, Jun 11, 2020 at 5:22 PM Konrad Rzeszutek Wilk
>> <konrad.wilk@oracle.com> wrote:
>>> On Thu, Jun 11, 2020 at 07:34:19AM -0400, Michael S. Tsirkin wrote:
>>>> As testing shows no performance change, switch to that now.
>>> What kind of testing? 100GiB? Low latency?
>>>
>> Hi Konrad.
>>
>> I tested this version of the patch:
>> https://lkml.org/lkml/2019/10/13/42
>>
>> It was tested for throughput with DPDK's testpmd (as described in
>> http://doc.dpdk.org/guides/howto/virtio_user_as_exceptional_path.html)
>> and kernel pktgen. No latency tests were performed by me. Maybe it is
>> interesting to perform a latency test or just a different set of tests
>> over a recent version.
>>
>> Thanks!
> I have repeated the tests with v9, and results are a little bit different:
> * If I test opening it with testpmd, I see no change between versions
> * If I forward packets between two vhost-net interfaces in the guest
> using a linux bridge in the host:
>    - netperf UDP_STREAM shows a performance increase of 1.8, almost
> doubling performance. This gets lower as frame size increase.
>    - rests of the test goes noticeably worse: UDP_RR goes from ~6347
> transactions/sec to 5830
>    - TCP_STREAM goes from ~10.7 gbps to ~7Gbps


Which direction did you mean here? Guest TX or RX?


>    - TCP_RR from 6223.64 transactions/sec to 5739.44


Perf diff might help. I think we can start from the RR result which 
should be easier. Maybe you can test it for each patch then you may see 
which patch is the source of the regression.

Thanks

