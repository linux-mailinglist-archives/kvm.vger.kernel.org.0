Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7B511129D1
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 12:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfLDLE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 06:04:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31318 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727268AbfLDLE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 06:04:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575457498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T19X4nvS8o6/QCGqV5cYH9dB5ySF6S5McpcQOxAuM1Y=;
        b=WaKq0K9uEeAV32YBa3Vuc0SroHENyed+erglxIQonqjKpfDUtp0ReeinMOCgJ8Kbgy58e9
        0R4EGw6m+nPduNRqK4xUiTx+eRg+HOFBPTSdwjLgDJkgOy4OetEXAYrktfACZd/tmsoDCp
        XzcAgclldbFrdZkBsxvSpH6WJ5uX0a8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-rR7vLXFiNBa2ck36I8dhIQ-1; Wed, 04 Dec 2019 06:04:56 -0500
Received: by mail-wm1-f70.google.com with SMTP id s12so2022784wmc.6
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 03:04:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/mPzTUYV/4/AeMFkskqxn26gUIegqrDV8tBrRpiOjJE=;
        b=eQazAzjJ6oPdm1+mrC7D1ab6Y4DHsVBVvjTwEkmWkmjqeUQoEJnBdYAh/7F2BJPgix
         1nS4RD9yx9rTI303n/QIkPG+Xay6P79dpnRSivkB85RggmQ3JcWUazib10p82UaPpG5o
         1fMFRMYSZhtfTQUMSkeS6T0EQleVhapTOrY+pSBQPqVb2R6tl8vmfwHTS73S65ydoSVV
         ppttfNc6eOAx0TIlL+m+htX731bR4yiHeKghcgtESQ2ACi8ZVSbBFfKq8F+Py+UNLQbI
         GpREMPTfTb2GPXHl9YMzHoUjtTeNcLo4vN8whiINTNzL9PUSY1nrf9YhRm7bt2ezZaCK
         8adQ==
X-Gm-Message-State: APjAAAVHt/xijV32LXAo+y1mrwS4f2HV0P1j9dmKc6nspVR5N/wPs7/R
        BpNE8RJRmk7Qtit1WLLNrIQ3CgRC2FEnpRSUoAWwHNMy9s5eq9zoZCvr1dfSjnI6NPrU+tZeThr
        a/I6UIYvHyGDv
X-Received: by 2002:adf:cf0a:: with SMTP id o10mr3157135wrj.325.1575457495740;
        Wed, 04 Dec 2019 03:04:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqxZej/ubogLxmoGHCyzT2M4jWD3RKQn+Hr3K0Odb3wHdjAp8chAUWwQGUSBl7gRSN6mqYV+jA==
X-Received: by 2002:adf:cf0a:: with SMTP id o10mr3157105wrj.325.1575457495413;
        Wed, 04 Dec 2019 03:04:55 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a? ([2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a])
        by smtp.gmail.com with ESMTPSA id k19sm6238150wmi.42.2019.12.04.03.04.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 03:04:54 -0800 (PST)
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
To:     Jason Wang <jasowang@redhat.com>, Peter Xu <peterx@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <1355422f-ab62-9dc3-2b48-71a6e221786b@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a3e83e6b-4bfa-3a6b-4b43-5dd451e03254@redhat.com>
Date:   Wed, 4 Dec 2019 12:04:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1355422f-ab62-9dc3-2b48-71a6e221786b@redhat.com>
Content-Language: en-US
X-MC-Unique: rR7vLXFiNBa2ck36I8dhIQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/12/19 11:38, Jason Wang wrote:
>>
>> +=C2=A0=C2=A0=C2=A0 entry =3D &ring->dirty_gfns[ring->dirty_index & (rin=
g->size - 1)];
>> +=C2=A0=C2=A0=C2=A0 entry->slot =3D slot;
>> +=C2=A0=C2=A0=C2=A0 entry->offset =3D offset;
>=20
>=20
> Haven't gone through the whole series, sorry if it was a silly question
> but I wonder things like this will suffer from similar issue on
> virtually tagged archs as mentioned in [1].

There is no new infrastructure to track the dirty pages---it's just a
different way to pass them to userspace.

> Is this better to allocate the ring from userspace and set to KVM
> instead? Then we can use copy_to/from_user() friends (a little bit slow
> on recent CPUs).

Yeah, I don't think that would be better than mmap.

Paolo


> [1] https://lkml.org/lkml/2019/4/9/5

