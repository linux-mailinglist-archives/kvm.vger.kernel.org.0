Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66AEE1A47FD
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 17:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgDJPum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 11:50:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41344 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726676AbgDJPul (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 11:50:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586533840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fbv9dpmY197904b6GS2826/Wmyt1SaRkI6kEH+Y6rqI=;
        b=jAx3Y9f1Gz4v7FpAx1NlkMd/BzdwVk0oeWvmm8PV7kCYLYauCXXdWi5++msSUZoR3T2gsg
        aG4ql8LdI3fobyNfc1zsGocdYVxwoZAwn9oM/DSmctU0aL+tc7ypnoLOLsN3lQjupz7GY8
        unRSGh7yi/dkHdI4L3WaHxYVUgB1YqI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-UJlSGkOGMf62UILNkVuCiQ-1; Fri, 10 Apr 2020 11:50:38 -0400
X-MC-Unique: UJlSGkOGMf62UILNkVuCiQ-1
Received: by mail-wm1-f72.google.com with SMTP id f9so786603wme.7
        for <kvm@vger.kernel.org>; Fri, 10 Apr 2020 08:50:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fbv9dpmY197904b6GS2826/Wmyt1SaRkI6kEH+Y6rqI=;
        b=shSHaFx1jRtc1oRTJwsm+0WSW3g/e97nEOw04uKx4Mf0V7pA/w8bDMEPtdKQT7NAek
         f0zFcxn2Lti0yKCgzRZE5ddDIa2vivTD4GQ0g5KRAYnMCKw/lrN+yGyCpbX3/6Ly+wgK
         CNqpniKtmTj94P2osNEOtnPrK9tB5aynOdVZNsab8k2CEw6siDJVOGlnxz6XyIkuIzzo
         sqLfs9MmDx+TEVIVQLNC2b2O/uoqwoVaPTpu+UWxez4RhI7KzkvBzu3F/6SiWRP0CjHn
         zZ9gk5w4USxbN5JG285qhngzCu8WJ19/SzIh7B5qFxxEyXAfwECTi05/3T11+FMjYPd1
         fLrw==
X-Gm-Message-State: AGi0Pua3I07xr3rUd4HS6Ca6D37fucOUijp/+hoNOqzxhe91bFWn53dY
        IyxrLI3Sxb2cutOyjt7ZPsRkEhyESEQpuA+hevEKtBRN32dIUEJ1nREx5JrCEClUEYd/dhFi5rA
        q3XzYwPVzV/Gc
X-Received: by 2002:a7b:c417:: with SMTP id k23mr5859670wmi.147.1586533837599;
        Fri, 10 Apr 2020 08:50:37 -0700 (PDT)
X-Google-Smtp-Source: APiQypJpRTANLwLNZGK/YcNONJDjAo50QC72EEpTSJ/RKdGUXrt8aC4++t3sHoHsg4ERsBQwwj3OwA==
X-Received: by 2002:a7b:c417:: with SMTP id k23mr5859648wmi.147.1586533837336;
        Fri, 10 Apr 2020 08:50:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f4b7:b34c:3ace:efb6? ([2001:b07:6468:f312:f4b7:b34c:3ace:efb6])
        by smtp.gmail.com with ESMTPSA id v186sm3273773wme.24.2020.04.10.08.50.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Apr 2020 08:50:36 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: X86: Ultra fast single target IPI fastpath
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
References: <1586480607-5408-1-git-send-email-wanpengli@tencent.com>
 <20200410153539.GD22482@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f51251cc-885e-2f7a-b18d-faa76db15b87@redhat.com>
Date:   Fri, 10 Apr 2020 17:50:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200410153539.GD22482@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/04/20 17:35, Sean Christopherson wrote:
> IMO, this should come at the very end of vmx_vcpu_run().  At a minimum, it
> needs to be moved below the #MC handling and below
> 
> 	if (vmx->fail || (vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
> 		return;

Why?  It cannot run in any of those cases, since the vmx->exit_reason
won't match.

> KVM more or less assumes vmx->idt_vectoring_info is always valid, and it's
> not obvious that a generic fastpath call can safely run before
> vmx_complete_interrupts(), e.g. the kvm_clear_interrupt_queue() call.

Not KVM, rather vmx.c.  You're right about a generic fastpath, but in
this case kvm_irq_delivery_to_apic_fast is not touching VMX state; even
if you have a self-IPI, the modification of vCPU state is only scheduled
here and will happen later via either kvm_x86_ops.sync_pir_to_irr or
KVM_REQ_EVENT.

Paolo

