Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B95BD48E540
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 09:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236812AbiANIMm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 03:12:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57251 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236787AbiANIMl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 03:12:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642147961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dwuxbIX1i5Dfm9gk8fkBbEk0Kx7vWseXfNpMD4fzRhg=;
        b=LerQaxZYEwsB+fJc2Yy26XiSYXvSVZuDChqnuvSBfbEMsL1JHGg2h35gt8GqST7lSxV79D
        GE4XAx9le4Zg8tbViM6FV9M2zi1agLn8cOy+mxXHU2oK1fesWIFb+nXDdQspFJCsce/R8n
        hknbuoQi0GBP0g8a2+2HG0n7epXRUIE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-332-l8lq6-vKOXGmksVknYFh2Q-1; Fri, 14 Jan 2022 03:12:40 -0500
X-MC-Unique: l8lq6-vKOXGmksVknYFh2Q-1
Received: by mail-wm1-f72.google.com with SMTP id r2-20020a05600c35c200b00345c3b82b22so7588485wmq.0
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 00:12:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dwuxbIX1i5Dfm9gk8fkBbEk0Kx7vWseXfNpMD4fzRhg=;
        b=M5hW6/noGXbXwsavQLnN91A2OaaiE5+jpdqelW+2DCyzQev0BxiRUNHYwOW/epddm4
         1YIoYBGxLKO6S3t6UIgem0razGw1upF8mgvBG4GHyJbZ5lxYxKcWMM7ooFPMfpUy8aRF
         ZZhjl2W7KeJLU4qarnpGWz05DfE0cGY7jUj/RIrFvWfs3s6VVePaEf5JYCUqIWURKWpe
         PHdpvzec6wWWl/5KgLPjQ4C5oJyMmwytjjMiv90bvMLQZT4hS7WY9+hZJq1dvlBSxWcL
         9/Q3/ZmpgJIO5TI89AEBRZAtC4YKp+XuIq6OVbfVE7G9M+3eH1Qs5eATzd/wG6wvk/em
         7rIw==
X-Gm-Message-State: AOAM531DE/GlGUPBDmyF0+BzFTdJNmLJ9ZDvQnjANP2DwamDg2R0pe2U
        DIKdAMjqbOeKDLSQAhEQF7pLV/lmiJD5VubEnKFfjQZRRECJa+fMxWxIWX17BCFteLScOIskvzA
        t/Hm9x7jmLE09
X-Received: by 2002:a5d:6586:: with SMTP id q6mr7426423wru.62.1642147958960;
        Fri, 14 Jan 2022 00:12:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyYS3u4Ps5fXTlLgsznvhnty33P7q3kjewzPzh1N7ViZUtbk0nln9x6reL1Wi8sEumeVB28mQ==
X-Received: by 2002:a5d:6586:: with SMTP id q6mr7426403wru.62.1642147958704;
        Fri, 14 Jan 2022 00:12:38 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id e4sm1807548wrq.51.2022.01.14.00.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 00:12:37 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] KVM: x86: Partially allow KVM_SET_CPUID{,2} after
 KVM_RUN for CPU hotplug
In-Reply-To: <YeCEyNz/xqcJBcU/@google.com>
References: <20220113133703.1976665-1-vkuznets@redhat.com>
 <YeCEyNz/xqcJBcU/@google.com>
Date:   Fri, 14 Jan 2022 09:12:37 +0100
Message-ID: <87o84en3be.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Jan 13, 2022, Vitaly Kuznetsov wrote:
>> Recently, KVM made it illegal to change CPUID after KVM_RUN but
>> unfortunately this change is not fully compatible with existing VMMs.
>> In particular, QEMU reuses vCPU fds for CPU hotplug after unplug and it
>> calls KVM_SET_CPUID2. Relax the requirement by implementing an allowlist
>> of entries which are allowed to change.
>
> Honestly, I'd prefer we give up and just revert feb627e8d6f6 ("KVM: x86: Forbid
> KVM_SET_CPUID{,2} after KVM_RUN").  Attempting to retroactively restrict the
> existing ioctls is becoming a mess, and I'm more than a bit concerned that this
> will be a maintenance nightmare in the future, without all that much benefit to
> anyone.

I cannot say I disagree)

>
> I also don't love that the set of volatile entries is nothing more than "this is
> what QEMU needs today".  There's no architectural justification, and the few cases
> that do architecturally allow CPUID bits to change are disallowed.  E.g. OSXSAVE,
> MONITOR/MWAIT, CPUID.0x12.EAX.SGX1 are all _architecturally_ defined scenarios
> where CPUID can change, yet none of those appear in this list.  Some of those are
> explicitly handled by KVM (runtime CPUID updates), but why should it be illegal
> for userspace to intercept writes to MISC_ENABLE and do its own CPUID emulation?

I see. Another approach would be to switch from the current allowlist
approach to a blocklist of things which we forbid to change
("MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, ...") after the
first KVM_RUN.

-- 
Vitaly

