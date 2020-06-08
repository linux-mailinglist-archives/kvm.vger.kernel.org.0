Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D2A1F19B3
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 15:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbgFHNNT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 09:13:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24681 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729130AbgFHNNS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 09:13:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591621996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aE4uxEFzisXgU373/MFQA+2UMs2/qJwN6z64o4N5Dt4=;
        b=R5fc6p79UyIJ/dAsbTm4TvTSlIZkM2nPuY35BhvdlqvQzobCEpJ/v2JhFrSGdWNO40XGCM
        bmVP5hOMF77XVccgh+iDi3wh51ZWe8JI2uAbTaf2x7XJrnee+eaji+6Lc4Pg0HlKanOpiT
        5FcYEJTRIEfgS/L2c7ZWCJ/lYXXyUI0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-UnznCOAOM_asWOEscL7p8g-1; Mon, 08 Jun 2020 09:13:13 -0400
X-MC-Unique: UnznCOAOM_asWOEscL7p8g-1
Received: by mail-wr1-f71.google.com with SMTP id l18so7187766wrm.0
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 06:13:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aE4uxEFzisXgU373/MFQA+2UMs2/qJwN6z64o4N5Dt4=;
        b=hjV4sSY4qFA9FjaVUx75cWxDIBsTz8HikYKwH9B80IMWdJMRir87VZsYc48GUyJsOb
         x3lxBz7rhqSU6IxedPjFMmNixuvmnFY7KQiBYLaXrr7A7Y39sb6O1QtkqGzbyklqEM6M
         AdnN3uSVomrM0sjIwjk2MlJcBT4WobcG7OhDn5IYY7szKsJjfcYNk7L8Nfro/RBhF83Y
         jvUxekPuoyDbKSAwjwHnSAdJIajEaAJRa+37EvTmBsieUP645veCbtXVWeVB2+/RgytA
         PfDujAKq+kZOY5l+Z5iO9UeOGGXJPbrReLjUzRAZcdaCXN2FyIryHplzq6/LivlPqXSV
         Ip7w==
X-Gm-Message-State: AOAM530pM84pNjizoX3U10Iyq6CZzhurx+Zv3dy3pSANZiCg9OJyj+6H
        /OHbwLSUDjOx8rw7n5MlLLJ2i6kwZtaOFm1tiD0NioKCPMSEidbkPWTRErRnwhNY+gbNxspnRpN
        xdH7t2+TLQx+e
X-Received: by 2002:adf:9163:: with SMTP id j90mr23117173wrj.65.1591621992172;
        Mon, 08 Jun 2020 06:13:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFKKUfkK+tx2dyjLJychJAOnf6ou8lGUS/UM9N0R8J5nM/pSwyG9zl28UmZ6GGRGsYFCgLVg==
X-Received: by 2002:adf:9163:: with SMTP id j90mr23117143wrj.65.1591621991883;
        Mon, 08 Jun 2020 06:13:11 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.87.23])
        by smtp.gmail.com with ESMTPSA id u4sm23511562wmb.48.2020.06.08.06.13.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2020 06:13:11 -0700 (PDT)
Subject: Re: [RFC PATCH] KVM: x86: Fix APIC page invalidation race
To:     Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     felipe.franciosi@nutanix.com, rkrcmar@redhat.com,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200606042627.61070-1-eiichi.tsukata@nutanix.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0d9b3313-5d4c-9ef3-63e4-ba08ddbbe7a1@redhat.com>
Date:   Mon, 8 Jun 2020 15:13:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200606042627.61070-1-eiichi.tsukata@nutanix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/06/20 06:26, Eiichi Tsukata wrote:
> Commit b1394e745b94 ("KVM: x86: fix APIC page invalidation") tried to
> fix inappropriate APIC page invalidation by re-introducing arch specific
> kvm_arch_mmu_notifier_invalidate_range() and calling it from
> kvm_mmu_notifier_invalidate_range_start. But threre could be the
> following race because VMCS APIC address cache can be updated
> *before* it is unmapped.
> 
> Race:
>   (Invalidator) kvm_mmu_notifier_invalidate_range_start()
>   (Invalidator) kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD)
>   (KVM VCPU) vcpu_enter_guest()
>   (KVM VCPU) kvm_vcpu_reload_apic_access_page()
>   (Invalidator) actually unmap page
> 
> Symptom:
>   The above race can make Guest OS see already freed page and Guest OS
> will see broken APIC register values.

This is not exactly the issue.  The values in the APIC-access page do
not really matter, the problem is that the host physical address values
won't match between the page tables and the APIC-access page address.
Then the processor will not trap APIC accesses, and will instead show
the raw contents of the APIC-access page (zeroes), and cause the crash
as you mention below.

Still, the race explains the symptoms and the patch matches this text in
include/linux/mmu_notifier.h:

	 * If the subsystem
         * can't guarantee that no additional references are taken to
         * the pages in the range, it has to implement the
         * invalidate_range() notifier to remove any references taken
         * after invalidate_range_start().

where the "additional reference" is in the VMCS: because we have to
account for kvm_vcpu_reload_apic_access_page running between
invalidate_range_start() and invalidate_range_end(), we need to
implement invalidate_range().

The patch seems good, but I'd like Andrea Arcangeli to take a look as
well so I've CCed him.

Thank you very much!

Paolo

> Especially, Windows OS checks
> LAPIC modification so it can cause BSOD crash with BugCheck
> CRITICAL_STRUCTURE_CORRUPTION (109). These symptoms are the same as we
> previously saw in https://bugzilla.kernel.org/show_bug.cgi?id=197951 and
> we are currently seeing in
> https://bugzilla.redhat.com/show_bug.cgi?id=1751017.
> 
> To prevent Guest OS from accessing already freed page, this patch calls
> kvm_arch_mmu_notifier_invalidate_range() from
> kvm_mmu_notifier_invalidate_range() instead of ..._range_start().

