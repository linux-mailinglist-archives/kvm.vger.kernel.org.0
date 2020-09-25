Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80EC278604
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 13:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgIYLgv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 07:36:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60361 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727248AbgIYLgv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 07:36:51 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601033809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/In/MyFjECzpjg2964FDjcYSNLEaaOd6O2cQZuUIz4w=;
        b=idTEWa/faGP/nwtogZXDmCLn31Sspv0d4UesJpaV8heGEv62B31rbaY2jd69Jivc7TqTzK
        ICGmM+s6AADytup6KDmMI5MQB35UWGfFOZu6201bbH71BiUo9gS6hcQYh1yiiclB9fkD1p
        jC8qJjvoi65BU5yVST8DeRiJbXlMJgo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-dIZtoN74OPeva-7u3bbOug-1; Fri, 25 Sep 2020 07:36:47 -0400
X-MC-Unique: dIZtoN74OPeva-7u3bbOug-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0016C18BA283;
        Fri, 25 Sep 2020 11:36:46 +0000 (UTC)
Received: from [10.72.12.44] (ovpn-12-44.pek2.redhat.com [10.72.12.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A95078828;
        Fri, 25 Sep 2020 11:36:31 +0000 (UTC)
Subject: Re: [RFC PATCH 00/24] Control VQ support in vDPA
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     mst@redhat.com, lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, sgarzare@redhat.com
References: <20200924032125.18619-1-jasowang@redhat.com>
 <20200924101720.GR62770@stefanha-x1.localdomain>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6825ecc1-ffc5-e980-c44e-c18c0a2eaa41@redhat.com>
Date:   Fri, 25 Sep 2020 19:36:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200924101720.GR62770@stefanha-x1.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/9/24 下午6:17, Stefan Hajnoczi wrote:
> On Thu, Sep 24, 2020 at 11:21:01AM +0800, Jason Wang wrote:
>> This series tries to add the support for control virtqueue in vDPA.
> Please include documentation for both driver authors and vhost-vdpa
> ioctl users. vhost-vdpa ioctls are only documented with a single
> sentence. Please add full information on arguments, return values, and a
> high-level explanation of the feature (like this cover letter) to
> introduce the API.


Right, this is in the TODO list. (And we probably need to start with 
documenting vDPA bus operations first).


>
> What is the policy for using virtqueue groups? My guess is:
> 1. virtio_vdpa simply enables all virtqueue groups.
> 2. vhost_vdpa relies on userspace policy on how to use virtqueue groups.
>     Are the semantics of virtqueue groups documented somewhere so
>     userspace knows what to do? If a vDPA driver author decides to create
>     N virtqueue groups, N/2 virtqueue groups, or just 1 virtqueue group,
>     how will userspace know what to do?


So the mapping from virtqueue to virtqueue group is mandated by the vDPA 
device(driver). vDPA bus driver (like vhost-vDPA), can only change the 
association between virtqueue groups and ASID.

By default, it is required all virtqueue groups to be associated to 
address space 0. This make sure virtio_vdpa can work without any special 
groups/asid configuration.

I admit we need document all those semantics/polices.


>
> Maybe a document is needed to describe the recommended device-specific
> virtqueue groups that vDPA drivers should implement (e.g. "put the net
> control vq into its own virtqueue group")?


Yes, note that this depends on the hardware capability actually. It can 
only put control vq in other virtqueue group if:

1) hardware support to isolate control vq DMA from the rest virtqueues 
(PASID or simply using PA (translated address) for control vq)
or
2) the control vq is emulated by vDPA device driver (like vdpa_sim did).


>
> This could become messy with guidelines. For example, drivers might be
> shipped that aren't usable for certain use cases just because the author
> didn't know that a certain virtqueue grouping is advantageous.


Right.


>
> BTW I like how general this feature is. It seems to allow vDPA devices
> to be split into sub-devices for further passthrough. Who will write the
> first vDPA-on-vDPA driver? :)


Yes, that's an interesting question. For now, I can imagine we can 
emulated a SRIOV based virtio-net VFs via this.

If we want to expose the ASID setting to guest as well, it probably 
needs more thought.

Thanks


>
> Stefan

