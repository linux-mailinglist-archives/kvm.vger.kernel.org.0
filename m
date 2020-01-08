Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86D35134C95
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 21:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgAHUGO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 15:06:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38875 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725835AbgAHUGN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 15:06:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578513971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=74hOkbtq8ouxtUc90++pV1soqHOiP2RiIHBC4eJpr5M=;
        b=H93zYXT+BA6icZPWQFd0PiVtfGEWF1OvhMP6TpuCBy2KTk4QkM4t+Ut5BnOX03NFdkp5zv
        iSxMPvduLYWTH4+AztirbVnAF8GvD+pWUyR6Z0EUD5qCNX93bPK7XAb1+Zv8gyYqcMn5Ee
        I1Avr0mOn2roJKmAfenm6oU1qUANkHc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-PipfQWKzNBm1rR1bkYmOow-1; Wed, 08 Jan 2020 15:06:10 -0500
X-MC-Unique: PipfQWKzNBm1rR1bkYmOow-1
Received: by mail-wm1-f70.google.com with SMTP id t16so63279wmt.4
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 12:06:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=74hOkbtq8ouxtUc90++pV1soqHOiP2RiIHBC4eJpr5M=;
        b=G4n7dnxUMLlNiey6H1x4ljz46weaHye5Ef6vcPJMu3Pb3pYAQaV5opjcARGR+VeyPs
         obUQeD2MUzCnpYIIpCEsUVIA0tLCAqE96j0RMoT3X3lcYgEwLX8n4gtjPwGk4xjJKmfB
         TMDh2P+LJgaK7YfLB97dKNerSubrnJunjhjCgscQiTixukHN4O76cST8QUG0phXrTJWt
         TnAWMdZjk6Ufe1OJ4Wf48z/Lqx6oaGec9IPbFDzhtDhMVQB+nAgd7XHClY7Inc9TvTri
         WksnVeh14PV/GeG4HLMe27vqhfWlU227xi2qpfK16mwoxrEmiwETJ9Dpcc0grHLojlum
         mreQ==
X-Gm-Message-State: APjAAAVB377PxLKsubshaDhAxu6XZDlwzoIv+jP5qN4h+x8R7yQ09G0L
        tH1KDKQJTKRf2oGkEQ8kIOIlugajm1Eh/FIWwlPrRKnuPZFO5i/8WNx/KIQg3BQNkaRJEj/LrUh
        vvXYFPjA96htK
X-Received: by 2002:a5d:66c3:: with SMTP id k3mr6222575wrw.370.1578513969405;
        Wed, 08 Jan 2020 12:06:09 -0800 (PST)
X-Google-Smtp-Source: APXvYqyl7RMYaGBDLZSP0rJ2jOO3l1LBIbKtQJORY1x4b2ENg/eMA59bDQeu/JPmKQdNZIqnfOvPUg==
X-Received: by 2002:a5d:66c3:: with SMTP id k3mr6222557wrw.370.1578513969170;
        Wed, 08 Jan 2020 12:06:09 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c6d:4079:b74c:e329? ([2001:b07:6468:f312:c6d:4079:b74c:e329])
        by smtp.gmail.com with ESMTPSA id z187sm235072wme.16.2020.01.08.12.06.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 12:06:08 -0800 (PST)
Subject: Re: [PATCH RESEND v2 08/17] KVM: X86: Implement ring-based dirty
 memory tracking
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
References: <20191221014938.58831-1-peterx@redhat.com>
 <20191221014938.58831-9-peterx@redhat.com> <20200108155210.GA7096@xz-x1>
 <9f7582b1-cfba-d096-2216-c5b06edc6ca9@redhat.com>
 <20200108190639.GE7096@xz-x1>
 <03e0cc7c-f47b-bdfa-8266-c77dc0627096@redhat.com>
 <20200108195953.GG7096@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <81d1c4da-a065-4cd8-ba30-0df30cd40b2d@redhat.com>
Date:   Wed, 8 Jan 2020 21:06:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200108195953.GG7096@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/01/20 20:59, Peter Xu wrote:
> On Wed, Jan 08, 2020 at 08:44:32PM +0100, Paolo Bonzini wrote:
>> On 08/01/20 20:06, Peter Xu wrote:
>>>> The kvmgt patches were posted, you could just include them in your next
>>>> series and clean everything up.  You can get them at
>>>> https://patchwork.kernel.org/cover/11316219/.
>>> Good to know!
>>>
>>> Maybe I'll simply drop all the redundants in the dirty ring series
>>> assuming it's there?  Since these patchsets should not overlap with
>>> each other (so looks more like an ordering constraints for merging).
>>
>> Just include the patches, we'll make sure to get an ACK from Alex.
> 
> Sure.  I can even wait for some more days until that consolidates
> (just in case we need to change back and forth for this series).

Don't worry, I'll keep track of that.

Paolo

