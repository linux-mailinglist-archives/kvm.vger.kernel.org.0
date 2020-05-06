Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F38A1C759B
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 18:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729979AbgEFQAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 12:00:13 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37425 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727984AbgEFQAK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 12:00:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588780809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EQ0EEtrPfpJzumspnJEz+3MkFW8Zic8Ww3qHCEsKpM4=;
        b=d1EIzcFNlxXKYhrb8Sxbbr9Ay/o4n1N6fQMQhZUrDvuVGtQ7pp8+v8ruIBIIkbO5ndDn7K
        Q9LYzQgCuth1JyzkW0eNuqrh/LyUjYJ2OXLlqOCsPqLE3IXGDDpCv6D1s0/ZXBsXLpOxJQ
        RC5mr0f//M2ThhhRrL1QnaSbixE0WiI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-luTiCZJrNr2pR2aYSYfSFQ-1; Wed, 06 May 2020 12:00:07 -0400
X-MC-Unique: luTiCZJrNr2pR2aYSYfSFQ-1
Received: by mail-wr1-f71.google.com with SMTP id x8so1546218wrl.16
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 09:00:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EQ0EEtrPfpJzumspnJEz+3MkFW8Zic8Ww3qHCEsKpM4=;
        b=hwC6xbIiTO7mgykiQXDQUYo/IFpkYyMU6Xu6OZOUrd+lYUBJ3sDGnB1ui3pcY6SCcZ
         c4W6JXAaWbX6wvBKMqkkaIDqSvVA03wWm4kNOsPpsdoIAeyk4hVFs061ezIBhYELYIjr
         Zym3/2DsqhgQoaWTUprWfiixfqqbx94CgrvVa++/bjILNRXZoUQPLDia96canzpKwYuf
         IikjQvpl/uYe2j5vAAZw0T3byV40cBwJchzFC0Or3ffxe1QQRVGWjwYc4MwjaF4HZsic
         TdVRPR2RT83cs5MXImku0gGAYzopM5RJHvu+GOiu+S1sh/8SpunEf2juytYMV1kx5v9t
         sugQ==
X-Gm-Message-State: AGi0PuZ4az7cvWfeA2cl6G7ErIcl/MKkRyX/n3f51HBoBlBARiZlgcDn
        TsCf8w6QBS7XSW+JuqF9XmTlioR8DbrNJOgPK3/MtgQ5k7Xi3Vx9zMHRMzixIqV4DPLp9IJUuXg
        MdA0PB9IzP9K4
X-Received: by 2002:a1c:e444:: with SMTP id b65mr5465480wmh.6.1588780806282;
        Wed, 06 May 2020 09:00:06 -0700 (PDT)
X-Google-Smtp-Source: APiQypKJYjv8BLS1aRa9vCE7/QqSfNIT9rRG0R1XpwIO/ycwue+PAI9H1CUc2J7/1fl/us+KYQZmVA==
X-Received: by 2002:a1c:e444:: with SMTP id b65mr5465453wmh.6.1588780805996;
        Wed, 06 May 2020 09:00:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:11d7:2f21:f38b:17e? ([2001:b07:6468:f312:11d7:2f21:f38b:17e])
        by smtp.gmail.com with ESMTPSA id m15sm3541401wmc.35.2020.05.06.09.00.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 09:00:05 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: get vmcs12 pages before checking pending
 interrupts
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
References: <20200505232201.923-1-oupton@google.com>
 <262881d0-cc24-99c2-2895-c5cbdc3487d0@redhat.com>
 <20200506152555.GA3329@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1f91d445-c3f3-fe35-3d65-0b7e0a6ff699@redhat.com>
Date:   Wed, 6 May 2020 18:00:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200506152555.GA3329@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/05/20 17:25, Sean Christopherson wrote:
>>
>> The patch is a bit ad hoc, I'd rather move the whole "if
>> (kvm_request_pending(vcpu))" from vcpu_enter_guest to vcpu_run (via a
>> new function).
> It might make sense to go with an ad hoc patch to get the thing fixed, then
> worry about cleaning up the pending request crud.  It'd be nice to get rid
> of the extra nested_ops->check_events() call in kvm_vcpu_running(), as well
> as all of the various request checks in (or triggered by) vcpu_block().

Yes, I agree that there are unnecessary tests in kvm_vcpu_running() if
requests are handled before vcpu_block and that would be a nice cleanup,
but I'm asking about something less ambitious.

Can you think of something that can go wrong if we just move all
requests, except for KVM_REQ_EVENT, up from vcpu_enter_guest() to
vcpu_run()?  That might be more or less as ad hoc as Oliver's patch, but
without the code duplication at least.

Paolo

> I was very tempted to dive into that mess when working on the nested events
> stuff, but was afraid that I would be opening up pandora's box.

