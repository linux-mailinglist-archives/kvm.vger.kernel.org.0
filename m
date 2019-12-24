Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E45C8129E17
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2019 07:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfLXGfB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 01:35:01 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43121 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbfLXGfB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 01:35:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577169300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AX9wAqQweKNe2DojWeRurmYeWv9FWstsri4vT88f7Vw=;
        b=aJIGYnMtmkxSrqz+BYGyeK0alx8Wqa73z8CJ8x1Lo9ebOVx5pt6i4m98qrfMey6x4gKccI
        7iKp+p7tL0MxykoFAnoVmJbgbRbvIea2vaLIBQCuGA1pfX/FFOGhj6PwXxcsSZOYJc7rM5
        b5RCqFcjkWBnyssUAO/aZm4hP/KmbMU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-P9nYY79oPJClDXW0IGOkqQ-1; Tue, 24 Dec 2019 01:34:58 -0500
X-MC-Unique: P9nYY79oPJClDXW0IGOkqQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE056DB21;
        Tue, 24 Dec 2019 06:34:57 +0000 (UTC)
Received: from [10.72.12.236] (ovpn-12-236.pek2.redhat.com [10.72.12.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CA065C1B5;
        Tue, 24 Dec 2019 06:34:47 +0000 (UTC)
Subject: Re: [PATCH RESEND v2 00/17] KVM: Dirty ring interface
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191221014938.58831-1-peterx@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5e859f76-96a2-634e-c26e-17421af7022a@redhat.com>
Date:   Tue, 24 Dec 2019 14:34:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191221014938.58831-1-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/12/21 =E4=B8=8A=E5=8D=889:49, Peter Xu wrote:
> * Why not virtio?
>
> There's already some discussion during v1 patchset on whether it's
> good to use virtio for the data path of delivering dirty pages [1].
> I'd confess the only thing that we might consider to use is the vring
> layout (because virtqueue is tightly bound to devices, while we don't
> have a device contet here), however it's a pity that even we only use
> the most low-level vring api it'll be at least iov based which is
> already an overkill for dirty ring (which is literally an array of
> addresses).  So I just kept things easy.


If iov is the only reason, we can simple extend vringh helper to access=20
the descriptor directly.

For split ring, it has some redundant stuffs.

- dirty ring has simple assumption used_idx =3D last_avail_idx (which is=20
fetch_index), so no need for having two rings
- descriptor is self contained (dirty_gfns), no need to another=20
indirection (but we can reuse vring descriptors for sure)

For packed ring, it looks not, but I'm not sure it's worthwhile to try.

Thanks

