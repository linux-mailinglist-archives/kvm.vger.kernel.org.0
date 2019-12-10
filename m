Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 894E81189DE
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 14:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbfLJNcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 08:32:00 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24758 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727007AbfLJNb7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Dec 2019 08:31:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575984718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+zG80mYfBd3fViyzCn3KpotJdNxDgZHe7SOcelUNx0g=;
        b=QLyQlMLOQ9mhnS3zQ6DEwvRoxNPlYGGOpN/a2Yps2ffB/PFshe0ce2GJLrlq5u3aET6d/Q
        L90limQULW64MD4+6BXbZ9QVHIhtR7M1/o42tTC3E7REv2IpgJj/BgZM/qepZ+V38xZTHj
        ST9VpGHnTwnd4TNzvJGBVW6SHkFkoNY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-G0iwsgwoMg6u2pgk046JJg-1; Tue, 10 Dec 2019 08:31:57 -0500
Received: by mail-wm1-f71.google.com with SMTP id p5so611313wmc.4
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 05:31:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+zG80mYfBd3fViyzCn3KpotJdNxDgZHe7SOcelUNx0g=;
        b=NWr+ZxE2tWDDXJop7W7rVMQMXD0dcjRZoyO9mJYaOxcgLppXA0J4N9/JNpJ+nOVGq/
         WCK5JuXy4KKcoYxcUFajs0s19jASjlmUogwnJMbZluR2lIvqcFl2VRM5mPlXIWk7maXh
         zhcnVtuuH7IVg4fppO7zz7+2kyghL4NAM0SgEXFLYFq0t0pUaEVGvdbacJ6X3SXlIKPN
         Jnt7rzRgp3xjypHtDXwHV8DMUt7CA+EbIES0kPm/1Dld53YibhPJISbDA7TTdrZqXdhI
         patW69uxoHKW5h6q9F496x5uZPuHVDh9OusflXUhhURDqhoNKhvDsdF2OgAP1i3lzkeH
         Lm8Q==
X-Gm-Message-State: APjAAAWVg++HtIKPrpxTmm67WidqpuJYaKHTMheaasu7TorLDAVFIQU+
        UdhF4wDRDXgJINWDD66ZbuJ7/BG/9P00GFRGOOiKwLVFSsSFHcC50AE0WoslZ5BKGFR6CMcJ29U
        GtPzbRB7mvij4
X-Received: by 2002:a5d:53c1:: with SMTP id a1mr3153941wrw.373.1575984716151;
        Tue, 10 Dec 2019 05:31:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqwfhzGVbFt8ye1oZ0Fqx1K1/PNOqob3EdPQ1TOnXC1rqknFM0Gg4Ty4IHcOaPiNjQiXQIi79Q==
X-Received: by 2002:a5d:53c1:: with SMTP id a1mr3153914wrw.373.1575984715928;
        Tue, 10 Dec 2019 05:31:55 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id z6sm3476706wrw.36.2019.12.10.05.31.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 05:31:55 -0800 (PST)
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, Peter Xu <peterx@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <1355422f-ab62-9dc3-2b48-71a6e221786b@redhat.com>
 <a3e83e6b-4bfa-3a6b-4b43-5dd451e03254@redhat.com>
 <20191210081958-mutt-send-email-mst@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8843d1c8-1c87-e789-9930-77e052bf72f9@redhat.com>
Date:   Tue, 10 Dec 2019 14:31:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191210081958-mutt-send-email-mst@kernel.org>
Content-Language: en-US
X-MC-Unique: G0iwsgwoMg6u2pgk046JJg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/19 14:25, Michael S. Tsirkin wrote:
>> There is no new infrastructure to track the dirty pages---it's just a
>> different way to pass them to userspace.
> Did you guys consider using one of the virtio ring formats?
> Maybe reusing vhost code?

There are no used/available entries here, it's unidirectional
(kernel->user).

> If you did and it's not a good fit, this is something good to mention
> in the commit log.
> 
> I also wonder about performance numbers - any data here?

Yes some numbers would be useful.  Note however that the improvement is
asymptotical, O(#dirtied pages) vs O(#total pages) so it may differ
depending on the workload.

Paolo

