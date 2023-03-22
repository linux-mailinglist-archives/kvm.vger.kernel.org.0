Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D853D6C5106
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 17:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbjCVQnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 12:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjCVQnS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 12:43:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC59161A85
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 09:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679503347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cC9A56nYy1+m5j88UXEHoA+LJcmsoLgXsOwYg6hVvpA=;
        b=UZTamQ6H+oo64itGXXh+zPDb9g17Q7ipLkr1QE92BeTr7qEtszd+GXZ6KTAdj0KgsxJn2q
        /KXhX8hS2vTLEgoXcDC4SY/iugsufaO6sL8uZPAavSwWksog33QDxDm8sjpRCmxx+jOR2s
        6ukrueWY8gKyLpBiIeyVoDypo4D3JkE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-5HfkHJV8NauG4Jivpvuunw-1; Wed, 22 Mar 2023 12:42:22 -0400
X-MC-Unique: 5HfkHJV8NauG4Jivpvuunw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56DB02823822;
        Wed, 22 Mar 2023 16:42:21 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CD47492C13;
        Wed, 22 Mar 2023 16:42:20 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Viktor Prutyanov <viktor@daynix.com>
Cc:     jasowang@redhat.com, pasic@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, yan@daynix.com
Subject: Re: [PATCH v4] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
In-Reply-To: <20230322123121-mutt-send-email-mst@kernel.org>
Organization: Red Hat GmbH
References: <20230322141031.2211141-1-viktor@daynix.com>
 <20230322123121-mutt-send-email-mst@kernel.org>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Wed, 22 Mar 2023 17:42:20 +0100
Message-ID: <87mt44hh5f.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 22 2023, "Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Wed, Mar 22, 2023 at 05:10:31PM +0300, Viktor Prutyanov wrote:
>> According to VirtIO spec v1.2, VIRTIO_F_NOTIFICATION_DATA feature
>> indicates that the driver passes extra data along with the queue
>> notifications.
>> 
>> In a split queue case, the extra data is 16-bit available index. In a
>> packed queue case, the extra data is 1-bit wrap counter and 15-bit
>> available index.
>> 
>> Add support for this feature for MMIO, channel I/O and modern PCI
>> transports.
>> 
>> Signed-off-by: Viktor Prutyanov <viktor@daynix.com>
>> ---
>>  v4: remove VP_NOTIFY macro and legacy PCI support, add
>>     virtio_ccw_kvm_notify_with_data to virtio_ccw
>>  v3: support feature in virtio_ccw, remove VM_NOTIFY, use avail_idx_shadow,
>>     remove byte swap, rename to vring_notification_data
>>  v2: reject the feature in virtio_ccw, replace __le32 with u32
>> 
>>  Tested with disabled VIRTIO_F_NOTIFICATION_DATA on qemu-system-s390x
>>  (virtio-blk-ccw), qemu-system-riscv64 (virtio-blk-device,
>>  virtio-rng-device), qemu-system-x86_64 (virtio-blk-pci, virtio-net-pci)
>>  to make sure nothing is broken.
>>  Tested with enabled VIRTIO_F_NOTIFICATION_DATA on 64-bit RISC-V Linux
>>  and my hardware implementation of virtio-rng.
>
> what did you test? virtio pci? mmio? guessing not ccw...
>
> Cornelia could you hack up something to quickly test ccw?

Hm, I'm not entirely sure how notification data is supposed to be used
in real life -- Viktor, what is your virtio-rng implementation doing;
can this be hacked into all transports?

(Also, if the other ccw folks have something handy, please speak up :)

