Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC2A6112969
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 11:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbfLDKi6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 05:38:58 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20110 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727446AbfLDKi6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Dec 2019 05:38:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575455937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qyYnPmXfgI61ReQeMn/+NTEgEMEEZXrZpt8TBXvPtWs=;
        b=PBV9A8K/tIfbfS9wJYChjoNSb9X+xXIEAHaNTucE75HhJ7gElP7WBMO+BMZ5ZJcM0UeGI4
        XaHG5X/VApWjw7K0qxyt1BdIrHaMcY5pzLlUdJsIuU+mdrndbOiZStICt5QPsrqbshaJJP
        oZtT1b8uBtnQrNbljCEsgOb7tyQs7II=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-GMxku97lOqKb5wfj8JYdEQ-1; Wed, 04 Dec 2019 05:38:56 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3388D107ACC4;
        Wed,  4 Dec 2019 10:38:55 +0000 (UTC)
Received: from [10.72.12.45] (ovpn-12-45.pek2.redhat.com [10.72.12.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0763E101E811;
        Wed,  4 Dec 2019 10:38:47 +0000 (UTC)
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1355422f-ab62-9dc3-2b48-71a6e221786b@redhat.com>
Date:   Wed, 4 Dec 2019 18:38:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191129213505.18472-5-peterx@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: GMxku97lOqKb5wfj8JYdEQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/11/30 =E4=B8=8A=E5=8D=885:34, Peter Xu wrote:
> +int kvm_dirty_ring_push(struct kvm_dirty_ring *ring,
> +=09=09=09struct kvm_dirty_ring_indexes *indexes,
> +=09=09=09u32 slot, u64 offset, bool lock)
> +{
> +=09int ret;
> +=09struct kvm_dirty_gfn *entry;
> +
> +=09if (lock)
> +=09=09spin_lock(&ring->lock);
> +
> +=09if (kvm_dirty_ring_full(ring)) {
> +=09=09ret =3D -EBUSY;
> +=09=09goto out;
> +=09}
> +
> +=09entry =3D &ring->dirty_gfns[ring->dirty_index & (ring->size - 1)];
> +=09entry->slot =3D slot;
> +=09entry->offset =3D offset;


Haven't gone through the whole series, sorry if it was a silly question=20
but I wonder things like this will suffer from similar issue on=20
virtually tagged archs as mentioned in [1].

Is this better to allocate the ring from userspace and set to KVM=20
instead? Then we can use copy_to/from_user() friends (a little bit slow=20
on recent CPUs).

[1] https://lkml.org/lkml/2019/4/9/5

Thanks


> +=09smp_wmb();
> +=09ring->dirty_index++;
> +=09WRITE_ONCE(indexes->avail_index, ring->dirty_index);
> +=09ret =3D kvm_dirty_ring_used(ring) >=3D ring->soft_limit;
> +=09pr_info("%s: slot %u offset %llu used %u\n",
> +=09=09__func__, slot, offset, kvm_dirty_ring_used(ring));
> +
> +out:

