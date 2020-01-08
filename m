Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0640A134990
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 18:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbgAHRlP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 12:41:15 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43358 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728253AbgAHRlO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jan 2020 12:41:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578505272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0sTGKEIISyGluaZPtnr2/ulkq7UdSDvBR5TeoAxjPMQ=;
        b=BQebebDVBR/v1BThfwz7eNBJEU+3p19eqUb2fRuA/jFae/YY7O1P8QB8lEGxGOX6jKHAni
        osk1mZRp4Kxap59x3xTieGFnhOJE+eeFqQxEC9nraonSgek/SzlY+AFa+BufXc5nIrIg5s
        1QVnRO9gp43ZssQ9GM27PcbDrTj+Hk4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-6FrT9x_MPJ6bdm_ni6o8Kw-1; Wed, 08 Jan 2020 12:41:10 -0500
X-MC-Unique: 6FrT9x_MPJ6bdm_ni6o8Kw-1
Received: by mail-wm1-f70.google.com with SMTP id b131so1099266wmd.9
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 09:41:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0sTGKEIISyGluaZPtnr2/ulkq7UdSDvBR5TeoAxjPMQ=;
        b=NLn7t0kfYZblenDuPT/87xugp7Tj8XNuM17MbXW9NUBY7ZlgVI5Z6RCPgHuk6WQIHK
         x9O+ENIfSRJpot9efQmA7cakZvsAVyVE8kygY86nO51350XMF5xlcvcnGS301ZjJGLiz
         hkJLTGaa5cpGGkdlaIpKdeOjQmKEGZYI8yBKKwf8zFhMkNdhvccQhoz7SyrhOFiwi1oI
         Wqt4ELz2NFPA/ZLCgbdiUnnXCQM2TNE20XaIP91WEKicCD/EkTB0N1PLL5fLcuRaJ8yl
         uk8A6n3+LxGtrC+iHqGhYUVl/GUwZGs5MTtxI0yui13c865ogXH6HqOvyGPltrw0i9My
         2v2A==
X-Gm-Message-State: APjAAAXUYJUR4ewzi5+8KrQXk+jOYOAxwdT0aMbb2Y2Ufh5Ut7aHi5CV
        ldYKj6ZSnuraKHAVMvoPy8r2fRg70vmumhF1bSEUaQHNdjiIycQMFI858P+Us0RmmB6Xea4kY0X
        nQPdE9V0dOAms
X-Received: by 2002:adf:e290:: with SMTP id v16mr6250475wri.16.1578505269427;
        Wed, 08 Jan 2020 09:41:09 -0800 (PST)
X-Google-Smtp-Source: APXvYqzPQtvQ+CfdZxLPT34g2/xZ1MRZci6Z0IM3bcacXC6lg/3LGlEHM0jH40To5MeilhL7Rjg5Fg==
X-Received: by 2002:adf:e290:: with SMTP id v16mr6250452wri.16.1578505269112;
        Wed, 08 Jan 2020 09:41:09 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c6d:4079:b74c:e329? ([2001:b07:6468:f312:c6d:4079:b74c:e329])
        by smtp.gmail.com with ESMTPSA id k13sm4808771wrx.59.2020.01.08.09.41.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 09:41:08 -0800 (PST)
Subject: Re: [PATCH RESEND v2 08/17] KVM: X86: Implement ring-based dirty
 memory tracking
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
References: <20191221014938.58831-1-peterx@redhat.com>
 <20191221014938.58831-9-peterx@redhat.com> <20200108155210.GA7096@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9f7582b1-cfba-d096-2216-c5b06edc6ca9@redhat.com>
Date:   Wed, 8 Jan 2020 18:41:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200108155210.GA7096@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/01/20 16:52, Peter Xu wrote:
> here, which is still a bit tricky to makeup the kvmgt issue.
> 
> Now we still have the waitqueue but it'll only be used for
> no-vcpu-context dirtyings, so:
> 
> - For no-vcpu-context: thread could wait in the waitqueue if it makes
>   vcpu0's ring soft-full (note, previously it was hard-full, so here
>   we make it easier to wait so we make sure )
> 
> - For with-vcpu-context: we should never wait, guaranteed by the fact
>   that KVM_RUN will return now if soft-full for that vcpu ring, and
>   above waitqueue will make sure even vcpu0's waitqueue won't be
>   filled up by kvmgt
> 
> Again this is still a workaround for kvmgt and I think it should not
> be needed after the refactoring.  It's just a way to not depend on
> that work so this should work even with current kvmgt.

The kvmgt patches were posted, you could just include them in your next
series and clean everything up.  You can get them at
https://patchwork.kernel.org/cover/11316219/.

Paolo

