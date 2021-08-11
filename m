Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C263E9230
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 15:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhHKNF7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 09:05:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55749 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229766AbhHKNF6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 09:05:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628687134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ejky1L45fjpIqglpN+AycHkOBEyLVHC4mSrGMJh6Vhk=;
        b=R6jKYdjEjs3FUXNbrLa7BVwvfC0aKyH5ntWKOYxgjEy2XtHfngeIrGXk00jEWOkQgoA2XM
        sp53/RbdLPmcEWK2HHejBKDqZrPZGPjPbsxkrUIsCM0HLDZ/Zx1Lt23OUzHyosdO17VnyO
        y1wGTslXwTcbU77i5oTQDEL26kFRgjY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-T3F45O6rPa-GSlGyFV3krA-1; Wed, 11 Aug 2021 09:05:33 -0400
X-MC-Unique: T3F45O6rPa-GSlGyFV3krA-1
Received: by mail-ej1-f70.google.com with SMTP id e1-20020a170906c001b02905b53c2f6542so663256ejz.7
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 06:05:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ejky1L45fjpIqglpN+AycHkOBEyLVHC4mSrGMJh6Vhk=;
        b=fcbsc3OP5Q7fN/bnFtFQjTQNBhxwoKMzZbH78ZdJ7BCNJytWzU4z36bhElHN5orcJf
         A/vcuMEUHIjXl8qp53G9dXyo9nkhPD4ExUxUdUwqhIE7FSamE0875uWHB5rpzDb7e0Us
         7jQ2XerUrHCvDl40ECJ+IHI6TX2P7jGib83qmZw6MuTjXNdbjwyt9IRmrPVkP9M+O5kd
         n1a3zRh62XoTSUBYapCZByUwf2f5HLSdKxho3aOEQPRFAl5hNG+GG2HIwCulkezX6P5W
         14BOCVRGUf9qmIpNQrKAhp3bOYOs9+dT4XCxH7h5r+lgEgTXF61Kf4zY3bb60FPBwXJ6
         amNA==
X-Gm-Message-State: AOAM530L2TAI01jwSPnR2ZGUqkYbkPkAJQKlFGl+WzOAEf8z2mYfJFts
        lVDvFHEb4zmj8qsPxYL5p87O7HFVxeET4pI76XG6yrI69SKRx1kdzSImvWZsSCZm1GvN7rNN9o6
        yyFqmtqJoa+fr
X-Received: by 2002:a17:907:3d93:: with SMTP id he19mr3569807ejc.179.1628687132019;
        Wed, 11 Aug 2021 06:05:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwv0o2qcd2qyszkVd6eUDUWXqakuUjyDYC+wCYZeaGx1y3ijN1A/umGBfrGXBRNz7hWK5walg==
X-Received: by 2002:a17:907:3d93:: with SMTP id he19mr3569774ejc.179.1628687131737;
        Wed, 11 Aug 2021 06:05:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id y1sm2657015ejf.2.2021.08.11.06.05.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 06:05:31 -0700 (PDT)
Subject: Re: [PATCH v6 00/21] KVM: Add idempotent controls for migrating
 system counter state
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20210804085819.846610-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <927240ff-a4f4-fcc6-ae1b-92cefeda9e59@redhat.com>
Date:   Wed, 11 Aug 2021 15:05:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/08/21 10:57, Oliver Upton wrote:
> KVM's current means of saving/restoring system counters is plagued with
> temporal issues. At least on ARM64 and x86, we migrate the guest's
> system counter by-value through the respective guest system register
> values (cntvct_el0, ia32_tsc). Restoring system counters by-value is
> brittle as the state is not idempotent: the host system counter is still
> oscillating between the attempted save and restore. Furthermore, VMMs
> may wish to transparently live migrate guest VMs, meaning that they
> include the elapsed time due to live migration blackout in the guest
> system counter view. The VMM thread could be preempted for any number of
> reasons (scheduler, L0 hypervisor under nested) between the time that
> it calculates the desired guest counter value and when KVM actually sets
> this counter state.
> 
> Despite the value-based interface that we present to userspace, KVM
> actually has idempotent guest controls by way of system counter offsets.
> We can avoid all of the issues associated with a value-based interface
> by abstracting these offset controls in new ioctls. This series
> introduces new vCPU device attributes to provide userspace access to the
> vCPU's system counter offset.
> 
> Patch 1 addresses a possible race in KVM_GET_CLOCK where
> use_master_clock is read outside of the pvclock_gtod_sync_lock.
> 
> Patch 2 adopts Paolo's suggestion, augmenting the KVM_{GET,SET}_CLOCK
> ioctls to provide userspace with a (host_tsc, realtime) instant. This is
> essential for a VMM to perform precise migration of the guest's system
> counters.
> 
> Patches 3-4 are some preparatory changes for exposing the TSC offset to
> userspace. Patch 5 provides a vCPU attribute to provide userspace access
> to the TSC offset.
> 
> Patches 6-7 implement a test for the new additions to
> KVM_{GET,SET}_CLOCK.
> 
> Patch 8 fixes some assertions in the kvm device attribute helpers.
> 
> Patches 9-10 implement at test for the tsc offset attribute introduced in
> patch 5.

The x86 parts look good, except that patch 3 is a bit redundant with my 
idea of altogether getting rid of the pvclock_gtod_sync_lock.  That said 
I agree that patches 1 and 2 (and extracting kvm_vm_ioctl_get_clock and 
kvm_vm_ioctl_set_clock) should be done before whatever locking changes 
have to be done.

Time is ticking for 5.15 due to my vacation, I'll see if I have some 
time to look at it further next week.

I agree that arm64 can be done separately from x86.

Paolo

