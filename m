Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFA6E143AE8
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 11:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729351AbgAUKZC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 05:25:02 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31770 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728931AbgAUKZC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 05:25:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579602301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aCi48PVWkDA8UrXfSnL/5YO1GyZMOjomyxZveXaEvec=;
        b=WwHvZOpnY0H3PNYv0oKS3hnvVT2syxRnfRtbnTMCjbxOn//7iO7JtFz1cJe5vplJ0kRzAJ
        E6GMYn9TMp6lsn02a4XOf9C2s8OOeJQkttTmPsFiFhPBkjoGGHF1KWWTp3/UJ8ufJJmvHw
        JX6V4mWC8jbM3FAtc9yPLT1eeC8afMw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-f0fi1GpoPL6mfoEAE8bIwA-1; Tue, 21 Jan 2020 05:24:59 -0500
X-MC-Unique: f0fi1GpoPL6mfoEAE8bIwA-1
Received: by mail-wr1-f70.google.com with SMTP id r2so1108665wrp.7
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 02:24:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aCi48PVWkDA8UrXfSnL/5YO1GyZMOjomyxZveXaEvec=;
        b=AYwJ/oLX6hHihRohQdCMw4dSLhjF/rh9bWCu5OCvU7FtHIeYJFT9W2xl1MzENn63ux
         Ck4rRDY9LnQGl00ujHIsLq2PEHXZWWhO9QiNfI+s3iEiLl6FgzQHb5BbBGXk1DH6wZIZ
         uZrSbMwFEw5ZBqmOfNU+PJY1kBKuxLkB7oTRmaqnX0rjcLUjgJ1g0Yr1vyydXyOIokGB
         d4qtD2NjZDkZ8rUtoBIeCUlAilns5Nb7Fm0RIzkkZGad15L/gb/e8UUFZ0SPTuH/Qgfh
         lSW2go194VmY884ZLei8YLX++BkJjz17nixwVkfm1q+7woojQavYgUIBQT8sr0EOlGVX
         htQg==
X-Gm-Message-State: APjAAAXRQJe+uLKRAxw/YnCCl4k1IFt9V/8kZyE3Q79+W1SAXQqy9lKz
        oeT2EktQN95NnOsVebQJGKCo7AiYA5GBwK/aziStzvHA/sgtNGQ0JRHnwhvqfLvvRrVa5JP5jOx
        HKCz3uYX6k5Rc
X-Received: by 2002:a05:600c:2c7:: with SMTP id 7mr3522406wmn.87.1579602298806;
        Tue, 21 Jan 2020 02:24:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqwwbUM3KKi/8PzBPn0yJAulXWiBEnPnllYFTZSqZ130XUc0JnR6nrnpLeUYhWl6VLYPSf8ejA==
X-Received: by 2002:a05:600c:2c7:: with SMTP id 7mr3522380wmn.87.1579602298497;
        Tue, 21 Jan 2020 02:24:58 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id c17sm51703396wrr.87.2020.01.21.02.24.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 02:24:57 -0800 (PST)
Subject: Re: [PATCH v3 12/21] KVM: X86: Implement ring-based dirty memory
 tracking
To:     Peter Xu <peterx@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-13-peterx@redhat.com>
 <20200109110110-mutt-send-email-mst@kernel.org>
 <20200109191514.GD36997@xz-x1>
 <22bcd5fc-338c-6b72-2bda-47ba38d7e8ef@redhat.com>
 <20200119051145-mutt-send-email-mst@kernel.org>
 <20200120072915.GD380565@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4e75a275-6687-2efc-0595-9b993ec300be@redhat.com>
Date:   Tue, 21 Jan 2020 11:24:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200120072915.GD380565@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/20 08:29, Peter Xu wrote:
>>>
>>>    00b (invalid GFN) ->
>>>      01b (valid gfn published by kernel, which is dirty) ->
>>>        1*b (gfn dirty page collected by userspace) ->
>>>          00b (gfn reset by kernel, so goes back to invalid gfn)
>>> That is 10b and 11b are equivalent.  The kernel doesn't read that bit if
>>> userspace has collected the page.
> Yes "1*b" is good too (IMHO as long as we can define three states for
> an entry).  However do you want me to change to that?  Note that I
> still think we need to read the rest of the field (in this case,
> "slot" and "gfn") besides the two bits to do re-protect.  Should we
> trust that unconditionally if writable?

I think that userspace would only hurt itself if they do so.  As long as
the kernel has a trusted copy of the indices, it's okay.

We have plenty of bits--x86 limits GFNs to 40 bits (52 bits maximum
physical address).  However, even on other architectures GFNs are
limited to address space size - page shift (64-12).

Paolo

