Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEED43A402E
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 12:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhFKKdW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 06:33:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46416 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229480AbhFKKdV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Jun 2021 06:33:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623407478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ABgescNKFLTBVcW3cvCAFrSrlDuItxLFj5+UfkoHSk=;
        b=YVpO+VjgTGKg0yhY+xXdLoSyiNNQ0vChxHNHcReBUshrcwZylwfrbRkgundGsy1axhbnee
        wIqN1vo2K+Sp+iJTpGUtSQjMwKW1nEMriZQ5Yxi7y/uuvayo8WKdlxgmBCwdMZGvXkv1CO
        yROUVr+mQNapUBgy86y0/znl97dMjFY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-X5uNZmKtM92dUAxI9ZHvXQ-1; Fri, 11 Jun 2021 06:31:17 -0400
X-MC-Unique: X5uNZmKtM92dUAxI9ZHvXQ-1
Received: by mail-wm1-f72.google.com with SMTP id y129-20020a1c32870000b029016920cc7087so1948250wmy.4
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 03:31:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2ABgescNKFLTBVcW3cvCAFrSrlDuItxLFj5+UfkoHSk=;
        b=T+2XySiF2ZER8JFiCZxTZBElJ+s5xvyusU5PnrBfjUFY2xPvZQNF41kUYmXD/G47MX
         UzWJ4BiTH8jSXSSJhXYlQ5bc4xL7kH5cord3WoQYYdjkV3YqBBqrCmfwQ+yNoPTW+KXm
         c1KPfJyJi5sI0gcw6jFXWozZ4nb1Mw3X+ea4NaL/7awXkFXD8jJuNlIteybQLwNJ1a/+
         pq172NZkIhPjukzHlMPBacwPddpxTBq+n78g06OI3eKRgaoZv0/ZekwOcOhy2aqtAD5j
         15SQhpUXseGXFzsCdI/l8w/6HNJa5+KFnvGUVmXec41OoINaN6uzhUEJfZB/FIZ/1T5Y
         bPXg==
X-Gm-Message-State: AOAM530OrYilh/ay2sjVkPK3UdrU4sKCuRF2fyWxNDuDD3i5cNlybH8E
        d7pt436d/kCtGqCw/U01U2RJx7QW+kF3b2sTgN2u2uoKJSM49xDHk1jvYVmJhd/9R2F0+b5VzYR
        iYvVqqePWQTmz
X-Received: by 2002:a5d:61d0:: with SMTP id q16mr3154832wrv.175.1623407475772;
        Fri, 11 Jun 2021 03:31:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyMgSDtnK9WI6jMA0Oetnq9UmN7D3xZyZ43D7ke1iDbEWyx9Sgep0ZkRuog2Qcn2ws3fWaLCA==
X-Received: by 2002:a5d:61d0:: with SMTP id q16mr3154801wrv.175.1623407475491;
        Fri, 11 Jun 2021 03:31:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m65sm5510434wmm.19.2021.06.11.03.31.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 03:31:14 -0700 (PDT)
To:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
Cc:     Jan Kiszka <jan.kiszka@siemens.com>
References: <CALMp9eRWBJQJBE2bxME6FzjhDOadNJW8wty7Gb=QJO8=ndaaEw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC] x86: Eliminate VM state changes during KVM_GET_MP_STATE
Message-ID: <50c5d8c2-4849-2517-79c8-bd4e03fd36ad@redhat.com>
Date:   Fri, 11 Jun 2021 12:31:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eRWBJQJBE2bxME6FzjhDOadNJW8wty7Gb=QJO8=ndaaEw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/06/21 22:39, Jim Mattson wrote:
> But, even worse, it can modify guest memory,
> even while all vCPU threads are stopped!

To some extent this is a userspace issue---they could declare vCPU 
threads stopped only after KVM_GET_MPSTATE is done, and only start the 
downtime phase of migration after that.  But it is nevertheless a pretty 
bad excuse.

> Was this simply to avoid serializing the two new bits in 
> apic->pending_events?

Yes, and more precisely to allow some interoperability between old and 
new kernels.

> Would anyone object to serializing KVM_APIC_SIPI in the 
> kvm_vcpu_events struct as well? Or would it be better to resurrect 
> KVM_MP_STATE_SIPI_RECEIVED?

Reusing KVM_VCPUEVENT_VALID_SIPI_VECTOR to mean KVM_APIC_SIPI is set 
would be nice, but it would break new->old migration (because old 
kernels only set KVM_APIC_SIPI if they see KVM_MP_STATE_SIPI_RECEIVED). 
  Can we decide this migration corner case is not something we care about?

Using KVM_MP_STATE_SIPI_RECEIVED solves interoperability issues because 
we never deleted the pre-2013 code, on the other hand 
KVM_MP_STATE_SIPI_RECEIVED assumes the existing mpstate is 
KVM_MP_STATE_INIT_RECEIVED; it does not account very well for the case 
of INIT+SIPI both being pending.  Unlike real hardware, KVM will queue a 
SIPI if it comes before the INIT has been processed, so that even in 
overcommit scenarios it is not possible to fail the INIT-SIPI; dropping 
kvm_apic_accept_events altogether would break this "tweak" across 
migration, which might cause failure to bring up APs.

If we start with just removing guest memory writes, there is an easy way 
out: the tweak does not work in guest mode, where INIT causes a vmexit 
and a pre-queued SIPI will never be delivered.  So, if in guest mode, we 
can ignore the case of pending INIT+SIPI, and only do a minimal version 
of kvm_apic_accept_events() that delays the larger side effects to the 
next KVM_RUN.

For a first improvement, the logic becomes the following:

* if in guest mode and both INIT and SIPI are set, clear KVM_APIC_SIPI 
and exit.  KVM_GET_VCPU_EVENTS will set latched_init.

* if in guest mode and SIPI is set, KVM_APIC_SIPI is transmitted to 
userspace via KVM_MP_STATE_SIPI_RECEIVED and 
KVM_VCPUEVENT_VALID_SIPI_VECTOR.

* if not in guest mode, run kvm_apic_accept_events.  Later this can be 
changed to drop KVM_APIC_SIPI if it's deemed preferrable.

I'll post a few RFC patches.  Selftests would be needed too.

Paolo

