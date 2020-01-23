Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A867214643A
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 10:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgAWJPq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 04:15:46 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59652 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726205AbgAWJPq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Jan 2020 04:15:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579770945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=12B39Xg1ujbGmC2fcxyE3VvGdS8Z63MnFzgGD9DRUo4=;
        b=erQqhVwjCLb2swKBiZkT8YZCeKfsT1Ti+0aJevA+yQjvH/57dgD46jWS+sRntcLJHC1Orr
        bSLKtH+YoNmxZsgWhI80pad+SeJhi7FxsP5c1YdZOlaRl0LGYli3QkdV7TueR8HJNTEYmq
        CRKOykeDhitLttGXCwvTPtun91YF7xk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-xrojZcrHPQWkWvgVBE9OEQ-1; Thu, 23 Jan 2020 04:15:44 -0500
X-MC-Unique: xrojZcrHPQWkWvgVBE9OEQ-1
Received: by mail-wm1-f69.google.com with SMTP id t17so341822wmi.7
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2020 01:15:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=12B39Xg1ujbGmC2fcxyE3VvGdS8Z63MnFzgGD9DRUo4=;
        b=eWDYIH4L4ybrSrXiJR5HOIQ8qtFG6/e6MESX30wsocFNooYc1cAVDjlvwFQKjW/U1Y
         ymTB2t3KnHERhUUJC30QyWRYZTtBAxJ/PwmGY1fUwTRnydFezkuk2aq0MG9sOMNTqwAB
         qdTHRdcjud4TCTRWaCQyUL55Kw37ehY1XIs+zmkRFh9MCSJMh2v7zY6mlqGPqhvvHhpL
         h3sETvk+GPqfwtp9IsSgHQIoX5GFTHuQOxe5gu7EtgbF5msMhOMvSGulFSsJ/CAU8pli
         OBjJfTt85wwJQxFbZmApWUwSnkuX1qjXIPMmT8UrEZJkXfPwTZU/ZOS40TOAS/5OfjHR
         07Ww==
X-Gm-Message-State: APjAAAUjRB+GnQdtRYD88VXpT30awqB8UNAmCiacNcHxvGX1ngRyrqlr
        53IFDc3RWDa6Y1GAxXfzp8l4IN/VRGcBDat0PMXR3nWZwMNAsl5V9LKv2v3N1HcNmm7FZXL5PG9
        kWnAkdsHkV5MF
X-Received: by 2002:a05:600c:290b:: with SMTP id i11mr3036722wmd.27.1579770943286;
        Thu, 23 Jan 2020 01:15:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqwexsQSodRXMekzwFz0uAi8G31zz2yRchJWLCfe5ZB2s6Sa5TKDasgwMQb5tuntXRoVZkEIHA==
X-Received: by 2002:a05:600c:290b:: with SMTP id i11mr3036695wmd.27.1579770943050;
        Thu, 23 Jan 2020 01:15:43 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b68sm1919858wme.6.2020.01.23.01.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 01:15:42 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: Re: [PATCH RFC 2/3] x86/kvm/hyper-v: move VMX controls sanitization out of nested_enable_evmcs()
In-Reply-To: <f15d9e98-25e9-2031-2db5-6aaa6c78c0eb@redhat.com>
References: <20200115171014.56405-1-vkuznets@redhat.com> <20200115171014.56405-3-vkuznets@redhat.com> <6c4bdb57-08fb-2c2d-9234-b7efffeb72ed@redhat.com> <20200122054724.GD18513@linux.intel.com> <9c126d75-225b-3b1b-d97a-bcec1f189e02@redhat.com> <87eevrsf3s.fsf@vitty.brq.redhat.com> <20200122155108.GA7201@linux.intel.com> <87blqvsbcy.fsf@vitty.brq.redhat.com> <f15d9e98-25e9-2031-2db5-6aaa6c78c0eb@redhat.com>
Date:   Thu, 23 Jan 2020 10:15:41 +0100
Message-ID: <87zheer0si.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 22/01/20 17:29, Vitaly Kuznetsov wrote:
>> Yes, in case we're back to the idea to filter things out in QEMU we can
>> do this. What I don't like is that every other userspace which decides
>> to enable eVMCS will have to perform the exact same surgery as in case
>> it sets allow_unsupported_controls=0 it'll have to know (hardcode) the
>> filtering (or KVM_SET_MSRS will fail) and in case it opts for
>> allow_unsupported_controls=1 Windows guests just won't boot without the
>> filtering.
>> 
>> It seems to be 1:1, eVMCSv1 requires the filter.
>
> Yes, that's the point.  It *is* a hack in KVM, but it is generally
> preferrable to have an easier API for userspace, if there's only one way
> to do it.
>
> Though we could be a bit more "surgical" and only remove
> SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES---thus minimizing the impact on
> non-eVMCS guests.  Vitaly, can you prepare a v2 that does that and adds
> a huge "hack alert" comment that explains the discussion?

Yes, sure. I'd like to do more testing to make sure filtering out
SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES is enough for other Hyper-V
versions too (who knows how many bugs are there :-)

-- 
Vitaly

