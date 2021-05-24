Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9310438F1B7
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 18:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbhEXQrq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 12:47:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52350 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232442AbhEXQrq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 12:47:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621874777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rPXQnZqFXzr656PBelcXfqldn7RBuvw0W5adzX4HMdo=;
        b=Hbv+saMyp9bO8LrubjUXZGgZ9GY8XH1lDozdcIWNGQ5qf8vqKyOiD1Dc0ku37xO2eNFSJ1
        Ciz31w5fFyX7xklKRZIozU+SG6XBdrR8wZelnPg+WJlj4qy8jxXe8nkqVMkfPJ8Kz0+Lzz
        twIat5hGsifQ84zhTnR1uLGJui0XhmQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-NrdYP2gNNImCPL_Fz6M0VA-1; Mon, 24 May 2021 12:46:15 -0400
X-MC-Unique: NrdYP2gNNImCPL_Fz6M0VA-1
Received: by mail-ed1-f72.google.com with SMTP id u14-20020a05640207ceb029038d4bfbf3a6so12316662edy.9
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 09:46:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rPXQnZqFXzr656PBelcXfqldn7RBuvw0W5adzX4HMdo=;
        b=ksnhbFsqUNtaxkqm0pNEdOz8hmilnABTZEsQidXCXsQHcneOGRmj65o4JyyrRzg+2n
         Q6e2KLT6GT0tMpw1dDnA6TAIEAk0jlMhywlnmOAQN4/UwqZ73weGmQqIE+W3MS2eoUhd
         ytcp5sNiR5H92TJRDgqCuLrXJC1JuyvqK2esPRlUUhxjQnuZcuJTQVw74qFilXzwwZKo
         34sK9U4AHX3pMP7NknHU3cTqSvAjsfbWNIytErNm4R0pWr2i5jlAku0/5HcYGJLr0QlU
         zmpf6OCUbWwW2q3G/26RGR7sQqZPvNjmZiJPH0VTU4f6qWaWArWj6zRz6g6mViDOgHF6
         XERA==
X-Gm-Message-State: AOAM531Tu8YU+84LhVOtBUjpHSNDQyge777USQ9SSdwsCcs2vGuek6Is
        E5GUoey4iz2UKIQ8CVOTmNT1Fc9kB/FMRG+0VsDy++3NCgeeVxGXBJ5RQu2U7e/0A+OACTaXAHl
        Jd4BiU/HNuZ7yJ846IaebZi5xPMm0cT22CiIGzmvDGiCzIh86KewAvpcSLWd/QH8A
X-Received: by 2002:aa7:d9d0:: with SMTP id v16mr27008472eds.293.1621874773790;
        Mon, 24 May 2021 09:46:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwsfktlLreanoyXo8N7DiOcsuDNhGZMiJyh/uiGkyCpS5Lzwy7WsZdCK7bmoKYL5loJDSg5Fw==
X-Received: by 2002:aa7:d9d0:: with SMTP id v16mr27008456eds.293.1621874773577;
        Mon, 24 May 2021 09:46:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l28sm9464826edc.29.2021.05.24.09.46.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 09:46:13 -0700 (PDT)
Subject: Re: [PATCH 00/12] KVM: nVMX: Fix vmcs02 PID use-after-free issue
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
References: <20210520230339.267445-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b97b4285-eed6-65c9-5d78-250b10bc4a43@redhat.com>
Date:   Mon, 24 May 2021 18:46:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210520230339.267445-1-jmattson@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/05/21 01:03, Jim Mattson wrote:
> When the VMCS12 posted interrupt descriptor isn't backed by an L1
> memslot, kvm will launch vmcs02 with a stale posted interrupt
> descriptor. Before commit 6beb7bd52e48 ("kvm: nVMX: Refactor
> nested_get_vmcs12_pages()"), kvm would have silently disabled the
> VMCS02 "process posted interrupts" VM-execution control. Both
> behaviors are wrong, though the use-after-free is more egregious.
> 
> Empirical tests on actual hardware reveal that a posted interrupt
> descriptor without any backing memory/device has PCI bus error
> semantics (reads return all 1's and writes are discarded). However,
> kvm can't tell an unbacked address from an MMIO address. Normally, kvm
> would ask userspace for an MMIO completion, but that's complicated for
> a posted interrupt descriptor access. There are already a number of
> cases where kvm bails out to userspace with KVM_INTERNAL_ERROR via
> kvm_handle_memory_failure, so that seems like the best route to take.
> 
> It would be relatively easy to invoke kvm_handle_memory_failure at
> emulated VM-entry, but that approach would break existing
> kvm-unit-tests. Moreover, the issue doesn't really come up until the
> vCPU--in virtualized VMX non-root operation--received the posted
> interrupt notification vector indicated in its VMCS12.
> 
> Sadly, it's really hard to arrange for an exit to userspace from
> vmx_complete_nested_posted_interrupt, which is where kvm actually
> needs to access the unbacked PID. Initially, I added a new kvm request
> for a userspace exit on the next guest entry, but Sean hated that
> approach. Based on his suggestion, I added the plumbing to get back
> out to userspace in the event of an error in
> vmx_complete_nested_posted_interrupt. This works in the case of an
> unbacked PID, but it doesn't work quite as well in the case of an
> unbacked virtual APIC page (another case where kvm was happy to just
> silently ignore the problem and attempt to muddle its way through.) In
> that case, this series is an incremental improvement, but it's not a
> complete fix.
> 
> Jim Mattson (12):
>    KVM: x86: Remove guest mode check from kvm_check_nested_events
>    KVM: x86: Wake up a vCPU when kvm_check_nested_events fails
>    KVM: nVMX: Add a return code to vmx_complete_nested_posted_interrupt
>    KVM: x86: Add a return code to inject_pending_event
>    KVM: x86: Add a return code to kvm_apic_accept_events
>    KVM: nVMX: Fail on MMIO completion for nested posted interrupts
>    KVM: nVMX: Disable vmcs02 posted interrupts if vmcs12 PID isn't
>      mappable
>    KVM: selftests: Move APIC definitions into a separate file
>    KVM: selftests: Hoist APIC functions out of individual tests
>    KVM: selftests: Introduce x2APIC register manipulation functions
>    KVM: selftests: Introduce prepare_tpr_shadow
>    KVM: selftests: Add a test of an unbacked nested PI descriptor
> 
>   arch/x86/kvm/lapic.c                          |  11 +-
>   arch/x86/kvm/lapic.h                          |   2 +-
>   arch/x86/kvm/vmx/nested.c                     |  31 ++-
>   arch/x86/kvm/x86.c                            |  56 ++--
>   tools/testing/selftests/kvm/.gitignore        |   1 +
>   tools/testing/selftests/kvm/Makefile          |   3 +-
>   .../selftests/kvm/include/x86_64/apic.h       |  91 +++++++
>   .../selftests/kvm/include/x86_64/processor.h  |  49 +---
>   .../selftests/kvm/include/x86_64/vmx.h        |   6 +
>   tools/testing/selftests/kvm/lib/x86_64/apic.c |  45 ++++
>   tools/testing/selftests/kvm/lib/x86_64/vmx.c  |   8 +
>   .../testing/selftests/kvm/x86_64/evmcs_test.c |  11 +-
>   .../selftests/kvm/x86_64/set_boot_cpu_id.c    |   6 +-
>   tools/testing/selftests/kvm/x86_64/smm_test.c |   4 +-
>   .../selftests/kvm/x86_64/vmx_pi_mmio_test.c   | 252 ++++++++++++++++++
>   .../selftests/kvm/x86_64/xapic_ipi_test.c     |  59 +---
>   16 files changed, 488 insertions(+), 147 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/include/x86_64/apic.h
>   create mode 100644 tools/testing/selftests/kvm/lib/x86_64/apic.c
>   create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_pi_mmio_test.c
> 

Pending further debugging of the selftest I've queued 
1-3-4-5-6-7-8-9-10.  Thanks,

Paolo

