Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367F23A2AD7
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 13:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhFJL5D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 07:57:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39081 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229935AbhFJL5C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 07:57:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623326105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dnjigdHt7m2fp4eaFXb/Zd3EnABp8cmZxGHc30RzvVM=;
        b=G2/UIgNeF68wLf6xXezUXoRChDjTsrtTnghSVXywxAQl8WAB5t+7YNo/abyLvWMkkkoRjY
        j05LIGzxL1GlqoetFA+u8Q3A8AGUJqqy2tSJCkkYUybSg59RHzqdJhWzH7m4ifE/FWMtTg
        Ql9Ci4U11SvQvhmtZK3yIp/80NnDplc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-aJe8Njf7NIiOeBDQD0JBmg-1; Thu, 10 Jun 2021 07:55:04 -0400
X-MC-Unique: aJe8Njf7NIiOeBDQD0JBmg-1
Received: by mail-wm1-f69.google.com with SMTP id v2-20020a7bcb420000b0290146b609814dso2952446wmj.0
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 04:55:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dnjigdHt7m2fp4eaFXb/Zd3EnABp8cmZxGHc30RzvVM=;
        b=OGdgi3plQEJfxBocmbZ1OjRxpKjd8ZnCw7nMkg5fepzApJxt+MXKU5KEQ/gwz+wbTS
         iOU1JRZh+K/digwDO0edplJ7tL4iBcPmUdOdi2+aKIzWxnIYgon+Wn+P9We0s0helQ9n
         s0HHIFvX7KllxdVT1K/8cZ47hBJQ9QgHJWjDYDNCe6zZpdSoeg1KAsgSkLFFS50k5fAg
         /7QKVXDKkDE4OhsZRCTHW0wBob0qkoLMAUJuZpB2hWmtMO/weeeYFl0y4abdxga7jSjI
         4pyCy1NiZBYr0d9l3VIwoyX1P/4xRLixPBEr94qxn4WL/ySnv0YiNh+Fb7I17ydU6Tr9
         Y3Hw==
X-Gm-Message-State: AOAM531rpnUwofpDxuQNDjcKjxrm/z9sueywra4XQ/ojYccb4/22c02v
        4tzo+shVfchrxXVwiMwcvggRqOB5mgx0J+inhLdnvEca3kB7idJwlOp84NxHj0fkaZWu006ouR7
        6fgw9x0vaVYNv93HJlbyeV80BaBphmkkfKhVyUrHA4/blUNPnNIvAcBWI0KJunns/
X-Received: by 2002:a5d:6111:: with SMTP id v17mr4981951wrt.20.1623326103268;
        Thu, 10 Jun 2021 04:55:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJza44AxbKeDSuy9lMDRY5EAe1mGQUyX3SgWemjTlAXN8G+eyGToH039jn8SfauCM1eBDpAIFA==
X-Received: by 2002:a5d:6111:: with SMTP id v17mr4981927wrt.20.1623326102999;
        Thu, 10 Jun 2021 04:55:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id h46sm3758197wrh.44.2021.06.10.04.55.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 04:55:02 -0700 (PDT)
Subject: Re: [PATCH v2 00/12] KVM: nVMX: Fix vmcs02 PID use-after-free issue
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
References: <20210604172611.281819-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3a11ea57-81c0-ef72-ed49-05fabd28f05b@redhat.com>
Date:   Thu, 10 Jun 2021 13:55:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210604172611.281819-1-jmattson@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/06/21 19:25, Jim Mattson wrote:
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
> v1 -> v2:
>    05/12: Modified kvm_arch_vcpu_ioctl_get_mpstate() so that it
>           returns the error code from kvm_apic_accept_events() if
> 	 said error code is less than 0.
>    07/12: Changed a comment based on Sean's feedback.
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
>   arch/x86/kvm/x86.c                            |  59 ++--
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
>   16 files changed, 490 insertions(+), 148 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/include/x86_64/apic.h
>   create mode 100644 tools/testing/selftests/kvm/lib/x86_64/apic.c
>   create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_pi_mmio_test.c
> 

Queued, thanks.  I'll leave out temporarily 2/10/12 until I figure out 
what's going on.

Paolo

