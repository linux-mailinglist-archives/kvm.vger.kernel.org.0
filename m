Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB39712326F
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 17:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbfLQQ3C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 11:29:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22674 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727906AbfLQQ3B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 11:29:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576600140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4QjX231V5laeRafQx7w7GoeX0Nh1hHz4npFVAtL7D8g=;
        b=B0/OJE6Ji3KFyuPexE+rKJrl0ztEhW4zodBSj3/Mx7IqenANGXT1h1tR5LPFHu1/Nb9NHi
        WPsZxwa9RLqhP8HgH2NrkQV8Zkh3/2SwdWVoDsVyxbc/67XFGnF/2I2Oal+wLJzMbtKrmL
        qo8UsmCNmsnG/GMz4NaFpOa8n9Okxrg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-afcSmJKdPYmEDahhMobCyQ-1; Tue, 17 Dec 2019 11:28:57 -0500
X-MC-Unique: afcSmJKdPYmEDahhMobCyQ-1
Received: by mail-wr1-f70.google.com with SMTP id u18so5543101wrn.11
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2019 08:28:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4QjX231V5laeRafQx7w7GoeX0Nh1hHz4npFVAtL7D8g=;
        b=VaWZ4pkRSZeYtu4uFKrznsCbFiO0N9kHWLNawkiTb2NkxpsUhDcO00KmP6vqH//kvX
         cGxJMunQPx0Dr8oHivr116zBqj4BGRIoQ3gawSGQu6c0s7PZbEXCWjZLMtXglTrwuzbQ
         6MGvO/l+bXeJwsai03CZZeRnJX5Pb0JvT/Ye8fhdYar6pHDUdTIOU+6/ERuQFrsLipGE
         +F9QsoM5lvdDZZHaMmClyqsZ2rVTaTVPhE3IyQXx/2vRQc4v1XG2ts+/AzAxh/Sjm94E
         8eu9VU+Fg7ngKlJQijA1YhmPmk8MXFG3NNVL+RTaZUCd1LKDF1B6cjfZrZuA2soe2478
         Rb5A==
X-Gm-Message-State: APjAAAXoCXdkBtMLWwDwDwNRYKMdp46lAa7F9ZtZibI+fdMHGxwHriA6
        fThoCh92jw8lQowAjiQXDWouc6+hW5cZZWpQTeiqKnosjCQfr86NbgJYbCuZzvnJ9v+HsWQgG1g
        4MbhSsCMnuAy9
X-Received: by 2002:adf:93c5:: with SMTP id 63mr38034364wrp.236.1576600135976;
        Tue, 17 Dec 2019 08:28:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqxRJaRQi6xIACk4g1bfPvll2CC76RIL71MS1JCPM6b+N9bpbm+K8CT7GIX0TKm/lKeMlLnoNQ==
X-Received: by 2002:adf:93c5:: with SMTP id 63mr38034345wrp.236.1576600135728;
        Tue, 17 Dec 2019 08:28:55 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:503f:4ffc:fc4a:f29a? ([2001:b07:6468:f312:503f:4ffc:fc4a:f29a])
        by smtp.gmail.com with ESMTPSA id e18sm25885046wrr.95.2019.12.17.08.28.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 08:28:55 -0800 (PST)
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
To:     Peter Xu <peterx@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
References: <20191203184600.GB19877@linux.intel.com>
 <374f18f1-0592-9b70-adbb-0a72cc77d426@redhat.com>
 <20191209215400.GA3352@xz-x1>
 <affd9d84-1b84-0c25-c431-a075c58c33dc@redhat.com>
 <20191210155259.GD3352@xz-x1>
 <3e6cb5ec-66c0-00ab-b75e-ad2beb1d216d@redhat.com>
 <20191215172124.GA83861@xz-x1>
 <f117d46a-7528-ce32-8e46-4f3f35937079@redhat.com>
 <20191216185454.GG83861@xz-x1>
 <815923d9-2d48-2915-4acb-97eb90996403@redhat.com>
 <20191217162405.GD7258@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c01d0732-2172-2573-8251-842e94da4cfc@redhat.com>
Date:   Tue, 17 Dec 2019 17:28:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191217162405.GD7258@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/12/19 17:24, Peter Xu wrote:
>> No, please pass it all the way down to the [&] functions but not to
>> kvm_write_guest_page.  Those should keep using vcpu->kvm.
> Actually I even wanted to refactor these helpers.  I mean, we have two
> sets of helpers now, kvm_[vcpu]_{read|write}*(), so one set is per-vm,
> the other set is per-vcpu.  IIUC the only difference of these two are
> whether we should consider ((vcpu)->arch.hflags & HF_SMM_MASK) or we
> just write to address space zero always.

Right.

> Could we unify them into a
> single set of helper (I'll just drop the *_vcpu_* helpers because it's
> longer when write) but we always pass in vcpu* as the first parameter?
> Then we add another parameter "vcpu_smm" to show whether we want to
> consider the HF_SMM_MASK flag.

You'd have to check through all KVM implementations whether you always
have the vCPU.  Also non-x86 doesn't have address spaces, and by the
time you add ", true" or ", false" it's longer than the "_vcpu_" you
have removed.  So, not a good idea in my opinion. :D

Paolo

