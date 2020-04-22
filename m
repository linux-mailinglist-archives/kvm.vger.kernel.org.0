Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A661B3A44
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 10:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgDVIiq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 04:38:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47098 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725836AbgDVIip (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 04:38:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587544724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sNTOJ4DOMqRb7+wXEID+nQDjGuphmZGJ3HThxBu7IL0=;
        b=Tb5qYIWXL715Ut5stx/b+SgjOVApXYvF1VLK48sZOIryWZ7jxEo1R/2b/nT3CgmXkN3TL8
        Ow7wq6aKRJ8lfTG7EBlI4hDbSCa/SZ3OhLUKEPCyb04YDJ1PlBs7XB32tVGMfh7hqJVct+
        Sv3MH9sTGVnw5AWEhn1PV45D9jLmeAE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-ajvfl0kDPRevTqdmtVJK1w-1; Wed, 22 Apr 2020 04:38:42 -0400
X-MC-Unique: ajvfl0kDPRevTqdmtVJK1w-1
Received: by mail-wm1-f70.google.com with SMTP id 14so495350wmo.9
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 01:38:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sNTOJ4DOMqRb7+wXEID+nQDjGuphmZGJ3HThxBu7IL0=;
        b=Ns0ToR2mSMXcHx+5WUeEwYUbS9UyNXtOpTlB81L8Pm/+3rgHKZ3o5Quursal6dxodx
         KGJ4S7XzKl/tsbHu2pG91Bry0PUJ/KBW1jWk9yscoyq1Ybh2s9dCtbRF4rRu7W4BMRpE
         Ls47P5WXDT2hVyBpEhzx5eImXm7w6VjtJzhxVPTbDFWLiiFsDqLgUyuS5vVSlNGM93Vh
         rU49Ca3YNJRypKf5RhBx29glWpskwWNiReleMRhgvvn55dgFTUrkI5kfmFngxjgHoBvX
         KmgMDqEhlzGIY+WXboA0v4M5iz0y93kGuAiQbA8rrb8k/C1wLfkoyWsPCEpX3TrlWaIT
         r3GQ==
X-Gm-Message-State: AGi0PuYbcjA+QG8ck7P8LbkY0MPQJ9RLS8AkiJP1VpXBrhHCS5kBrwM/
        MUcCdnN+2mR0LVPctLORT4UNmcOwdXjV6M9OBLE7D/H/9bf7diEjXdC6wNjOHVMzVaU15YgIhmk
        vLVFobdUC+L7f
X-Received: by 2002:a7b:cbc6:: with SMTP id n6mr9898917wmi.155.1587544721450;
        Wed, 22 Apr 2020 01:38:41 -0700 (PDT)
X-Google-Smtp-Source: APiQypKIAK7PHX7yxQV9nvW/3uOnuY71DYi++4LYtknbUhl3x9F6y+H9cop2sa4girLIMLzLO6u82A==
X-Received: by 2002:a7b:cbc6:: with SMTP id n6mr9898897wmi.155.1587544721232;
        Wed, 22 Apr 2020 01:38:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id a24sm6542275wmb.24.2020.04.22.01.38.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 01:38:40 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: X86: TSCDEADLINE MSR emulation fastpath
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
References: <1587468026-15753-1-git-send-email-wanpengli@tencent.com>
 <1587468026-15753-2-git-send-email-wanpengli@tencent.com>
 <ed968729-5d2a-a318-1d8f-db39e6ee72cb@redhat.com>
 <CANRm+CxzROx=eawemmzh==2Mz-DxKSyYFSxHqLxUiGFFnWkAYw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d87e0a4b-608a-451b-e3f0-968d46b6cc26@redhat.com>
Date:   Wed, 22 Apr 2020 10:38:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CANRm+CxzROx=eawemmzh==2Mz-DxKSyYFSxHqLxUiGFFnWkAYw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/20 02:48, Wanpeng Li wrote:
> On Tue, 21 Apr 2020 at 19:37, Paolo Bonzini <pbonzini@redhat.com> wrote:
>> On 21/04/20 13:20, Wanpeng Li wrote:
>>> +     case MSR_IA32_TSCDEADLINE:
>>> +             if (!kvm_x86_ops.event_needs_reinjection(vcpu)) {
>>> +                     data = kvm_read_edx_eax(vcpu);
>>> +                     if (!handle_fastpath_set_tscdeadline(vcpu, data))
>>> +                             ret = EXIT_FASTPATH_CONT_RUN;
>>> +             }
>>>               break;
>> Can you explain the event_needs_reinjection case?  Also, does this break
> This is used to catch the case vmexit occurred while another event was
> being delivered to guest software, I move the
> vmx_exit_handlers_fastpath() call after vmx_complete_interrupts()
> which will decode such event and make kvm_event_needs_reinjection
> return true.

This doesn't need a callback, kvm_event_needs_reinjection should be enough.

You should also check other conditions such as

	vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu)
            || need_resched() || signal_pending(current)

before doing CONT_RUN.

>> AMD which does not implement the callback?
> Now I add the tscdeadline msr emulation and vmx-preemption timer
> fastpath pair for Intel platform.

But this would cause a crash if you run on AMD.

Paolo

