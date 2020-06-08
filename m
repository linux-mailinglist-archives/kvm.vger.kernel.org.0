Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D391F15D6
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 11:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbgFHJrP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 05:47:15 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57328 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729166AbgFHJrP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 05:47:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591609634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oRvR0z9DPHYwpMI8dWRlJVdbfk+Jsh/v5E8QlIJ9FT8=;
        b=L1Kvk0TY0RfO/qr0xq+5E+dkkWTcl1Sn5WA576ZztzJqoBruOhcTcM3+mc7PohCZcQVN9x
        TwZlazfRCGg4BSkDTq+v80yGDwjsI5R3Ixnn6mWwmp/K7+8iZeaB4K86+Xx4D4FMEGNjLD
        tGMVDDYilPI7YbkB3QQAjVSL0Ts7Guw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-2HOf27seOnqEVafcIC1r1A-1; Mon, 08 Jun 2020 05:47:12 -0400
X-MC-Unique: 2HOf27seOnqEVafcIC1r1A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C3E68014D4;
        Mon,  8 Jun 2020 09:47:10 +0000 (UTC)
Received: from [10.72.13.71] (ovpn-13-71.pek2.redhat.com [10.72.13.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B5E755D9C9;
        Mon,  8 Jun 2020 09:46:56 +0000 (UTC)
Subject: Re: [PATCH 5/6] vdpa: introduce virtio pci driver
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.miller@broadcom.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, eli@mellanox.com
References: <20200529080303.15449-6-jasowang@redhat.com>
 <20200602010332-mutt-send-email-mst@kernel.org>
 <5dbb0386-beeb-5bf4-d12e-fb5427486bb8@redhat.com>
 <6b1d1ef3-d65e-08c2-5b65-32969bb5ecbc@redhat.com>
 <20200607095012-mutt-send-email-mst@kernel.org>
 <9b1abd2b-232c-aa0f-d8bb-03e65fd47de2@redhat.com>
 <20200608021438-mutt-send-email-mst@kernel.org>
 <a1b1b7fb-b097-17b7-2e3a-0da07d2e48ae@redhat.com>
 <20200608052041-mutt-send-email-mst@kernel.org>
 <9d2571b6-0b95-53b3-6989-b4d801eeb623@redhat.com>
 <20200608054453-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bc27064c-2309-acf3-ccd8-6182bfa2a4cd@redhat.com>
Date:   Mon, 8 Jun 2020 17:46:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200608054453-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/6/8 下午5:45, Michael S. Tsirkin wrote:
> On Mon, Jun 08, 2020 at 05:43:58PM +0800, Jason Wang wrote:
>>>> Looking at
>>>> pci_match_one_device() it checks both subvendor and subdevice there.
>>>>
>>>> Thanks
>>> But IIUC there is no guarantee that driver with a specific subvendor
>>> matches in presence of a generic one.
>>> So either IFC or virtio pci can win, whichever binds first.
>>
>> I'm not sure I get there. But I try manually bind IFCVF to qemu's
>> virtio-net-pci, and it fails.
>>
>> Thanks
> Right but the reverse can happen: virtio-net can bind to IFCVF first.


That's kind of expected. The PF is expected to be bound to virtio-pci to 
create VF via sysfs.

Thanks



>

