Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE28E12327E
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 17:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbfLQQat (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 11:30:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44055 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728214AbfLQQas (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 11:30:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576600247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ap670LPy12Q7/8a16LjycNst+xdpGA3dsChug73d5nU=;
        b=RAwPlPFVOFnCvlvS29sQNfIV3r1O+u4sauDHlvec7aMbtr4io6zClXnE3YBrOg30s48T4U
        FpmIpE3TvCAi/xB+WGtuRxxw9Dec9oMdbH4W7MwfLekfIgBv7R39ITh21IZxDXRbi/jQY5
        MIZMabOCLrkBCGgc0frL+XljcdwlFRw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-O6F7qxCkPraTdKOBOxFBdA-1; Tue, 17 Dec 2019 11:30:46 -0500
X-MC-Unique: O6F7qxCkPraTdKOBOxFBdA-1
Received: by mail-wm1-f70.google.com with SMTP id y125so944049wmg.1
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2019 08:30:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ap670LPy12Q7/8a16LjycNst+xdpGA3dsChug73d5nU=;
        b=XLWpXuKilIU2fGwSe539nm6cu4Gc6srDaf1733xBx78p6d3YqzxTt/xT5h27olootZ
         o2AOMpB6HIVC3wvFgz9EslqTx4f5On6glpI87Bx0oilPXZLttztzwYZPA4bCKV72yz9h
         XfTiTwGl4qQlwaWwsC/vI0VbpTGHY48qLvzm1P7jgl8H46JMGPC+IYXQVt4ii5fsvZoi
         JKgmVk98NIQvddex7Apklf6O369a81jio8pXVn5wqrQgd2wbRiTJ0bmPGKMh/jKB5ln6
         uWnvkGPfwFpqUtVkVw9GSlRNd2mAYTGgImtU53MYZX/kcW+e6N12FvBJdtvcZZpBlGeq
         Ii1w==
X-Gm-Message-State: APjAAAUs4bV9fFHvTLta1tEeMM3oBljZs7nvHMnOOMC1LNq0hYDbpJwx
        81yCuHgSma0C32ktA92WCsNv9F9xTAzMyF2MU2BCcZr1HfoynF8jo2Xz/xqNhkZdTtg/UM4cvcE
        0SyOireETcfsv
X-Received: by 2002:a1c:18e:: with SMTP id 136mr6629644wmb.53.1576600245051;
        Tue, 17 Dec 2019 08:30:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqympyH0YgvfHQF/+r2TKl3XLNPcDWYbY9gSaina8WVxwgLNBW8wAR3QILILNbDyVG9ju439Kg==
X-Received: by 2002:a1c:18e:: with SMTP id 136mr6629615wmb.53.1576600244834;
        Tue, 17 Dec 2019 08:30:44 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:503f:4ffc:fc4a:f29a? ([2001:b07:6468:f312:503f:4ffc:fc4a:f29a])
        by smtp.gmail.com with ESMTPSA id s128sm3518280wme.39.2019.12.17.08.30.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 08:30:44 -0800 (PST)
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Peter Xu <peterx@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
References: <20191202201036.GJ4063@linux.intel.com>
 <20191202211640.GF31681@xz-x1> <20191202215049.GB8120@linux.intel.com>
 <fd882b9f-e510-ff0d-db43-eced75427fc6@redhat.com>
 <20191203184600.GB19877@linux.intel.com>
 <374f18f1-0592-9b70-adbb-0a72cc77d426@redhat.com>
 <20191209215400.GA3352@xz-x1>
 <affd9d84-1b84-0c25-c431-a075c58c33dc@redhat.com>
 <20191210155259.GD3352@xz-x1>
 <3e6cb5ec-66c0-00ab-b75e-ad2beb1d216d@redhat.com>
 <20191215172124.GA83861@xz-x1>
 <f117d46a-7528-ce32-8e46-4f3f35937079@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D645E55@SHSMSX104.ccr.corp.intel.com>
 <20191217091837.744982d3@x1.home>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <10cc6fc6-c837-1a1a-a344-df97793b5ff5@redhat.com>
Date:   Tue, 17 Dec 2019 17:30:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191217091837.744982d3@x1.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/12/19 17:18, Alex Williamson wrote:
>>
>> Alex, if you are OK we'll work on such interface and move kvmgt to use it.
>> After it's accepted, we can also mark pages dirty through this new interface
>> in Kirti's dirty page tracking series.
> I'm not sure what you're asking for, is it an interface for the host
> CPU to read/write the memory backing of a mapped IOVA range without
> pinning pages?  That seems like something like that would make sense for
> an emulation model where a page does not need to be pinned for physical
> DMA.  If you're asking more for an interface that understands the
> userspace driver is a VM (ie. implied using a _guest postfix on the
> function name) and knows about GPA mappings beyond the windows directly
> mapped for device access, I'd not look fondly on such a request.

No, it would definitely be the former, using IOVAs to access guest
memory---kvmgt is currently doing the latter by calling into KVM, and
I'm not really fond of that either.

Paolo

