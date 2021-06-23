Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94FF33B22A9
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 23:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhFWVqd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 17:46:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34644 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhFWVq1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 17:46:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624484649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+sCbgnq2B/vVvI6ov/d1WRc/JmSSVpJ31dPnRnp1zZE=;
        b=INZH7uLMIPvrk3ksKaTw6A/qzP9TebZekYQXF/c7KaAvIMSILTTvwMY/visBs8VZeJMikm
        GosT3at4QbINUBAapVIM/d07/vad8Pl5QNgpa1uqxKIpejkcqxiMXCH30+G9ZQ1lo55Nng
        ucHg+Kv5UnmUWpr+bVIhdMtrIYa79oI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-ukHTh9j2Pd68XEGUampVjg-1; Wed, 23 Jun 2021 17:44:08 -0400
X-MC-Unique: ukHTh9j2Pd68XEGUampVjg-1
Received: by mail-wr1-f70.google.com with SMTP id v8-20020a5d43c80000b029011a94e052f2so1539504wrr.2
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 14:44:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+sCbgnq2B/vVvI6ov/d1WRc/JmSSVpJ31dPnRnp1zZE=;
        b=U6s/RU75sDDMESZYUIN1kJQjPzUjLV4C3iVhAg9NlXVOchZgTcenyxBexqW99LFzW6
         nKl75uOykJJNQy/0OTpdim0t3DM1ilfHLBdMAGcPNMbQW2Aq3KZsdDX6L0Ny6mj7qyOC
         dFIoWxNuVjNg/lQgqbyMPEAO52n/wIVBmPUJoH0Bz6b4O2Y8Ka4INLixqXImU+zPgAxa
         cDprOIF3qkG+tw/8mC5Eiy2BHl1bAk7dZ+Vf6Ee9M+5SARUsYZSjRBj3lx85FRaWkVQh
         bOndNm850rB9HE/Pdi+WUcBHgwE25svo2I+OvsB4bR1HbO3BWYpEkbne3u9v0WS7VIc2
         Ip2Q==
X-Gm-Message-State: AOAM5331KpJWhDC5rqtMNes4Tjj6xwFwve6+DCHpTs9G5PchjZUGNauL
        eagpZ1JbQ0XOFSRrankAki/4ciOSLN+TuXPU4zIpz9SCvJisuSOBfoUX515dcie73/xSa90jHPX
        RXEY6wwbd6ZiT32cjSYqoMVEh3Zta1XMHJYxKW7vE7Qy1Ex27QGQaK41noCjKGTjO
X-Received: by 2002:a7b:c2a2:: with SMTP id c2mr158643wmk.89.1624484647034;
        Wed, 23 Jun 2021 14:44:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwrjI4uPV1KcA/5/nyDF/m/nloK6zqZBZk3frvVGzqoXR4+cgJtmWFPnYQ0uVET3ovE0f+Biw==
X-Received: by 2002:a7b:c2a2:: with SMTP id c2mr158622wmk.89.1624484646843;
        Wed, 23 Jun 2021 14:44:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l20sm1107888wmq.3.2021.06.23.14.44.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 14:44:06 -0700 (PDT)
Subject: Re: [PATCH v6 0/2] fallback for emulation errors
To:     Aaron Lewis <aaronlewis@google.com>, david.edmondson@oracle.com,
        seanjc@google.com, jmattson@google.com
Cc:     kvm@vger.kernel.org
References: <20210510144834.658457-1-aaronlewis@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f2f28f97-1677-df75-e3ea-602e5f53e1b2@redhat.com>
Date:   Wed, 23 Jun 2021 23:44:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210510144834.658457-1-aaronlewis@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/05/21 16:48, Aaron Lewis wrote:
> This patchset allows userspace to be a fallback for handling emulation errors.
> 
> v1 -> v2:
> 
>   - Added additional documentation for KVM_CAP_EXIT_ON_EMULATION_FAILURE.
>   - In prepare_emulation_failure_exit():
>     - Created a local variable for vcpu->run.
>     - Cleared the flags, emulation_failure.flags.
>     - Or'd the instruction bytes flag on to emulation_failure.flags.
>   - Updated the comment for KVM_INTERNAL_ERROR_EMULATION flags on how they are
>     to be used.
>   - Updated the comment for struct emulation_failure.
> 
> v2 -> v3:
> 
>   - Update documentation for KVM_CAP_EXIT_ON_EMULATION_FAILURE.
>   - Fix spacing in prepare_emulation_failure_exit().
> 
> v3 -> v4:
> 
>   - In prepare_emulation_failure_exit():
>     - Clear instruction bytes to 0x90.
>     - Copy over insn_size bytes rather than sizeof(ctxt->fetch.data).
>   - set_page_table_entry() takes a pte rather than mask.
>   - In _vm_get_page_table_entry():
>     - Removed check for page aligned addresses only.
>     - Added canonical check.
>     - Added a check to make sure no reserved bits are set along the walk except
>       for the final pte (the pte cannot have the reserved bits checked otherwise
>       the test would fail).
>     - Added check to ensure superpage bits are clear.
>   - Added check in test for 'allow_smaller_maxphyaddr' module parameter.
>   - If the is_flds() check fails, only look at the first byte.
>   - Don't use labels to increment the RIP.  Decode the instruction well enough to
>     ensure it is only 2-bytes.
> 
> v4 -> v5:
> 
>   - Switch 'insn_size' to u32.
>   - Add documentation for how the flags are used.
>   - Remove 'max_insn_size' and use 'sizeof(run->emulation_failure.insn_bytes)' instead.
>   - Fix typos.
>   - Fix canonical check.
>   - Add reserved check for bit-7 of PML4E.
>   - Add reserved check for bit-63 of all page table levels if EFER.NXE = 0.
>   - Remove opcode check (it might be a prefix).
>   - Remove labels.
>   - Remove detritus (rogue cpuid entry in the test).
> 
> v5 -> v6
> 
>   - Fix documentation.
> 
> Aaron Lewis (2):
>    kvm: x86: Allow userspace to handle emulation errors
>    selftests: kvm: Allows userspace to handle emulation errors.
> 
>   Documentation/virt/kvm/api.rst                |  19 ++
>   arch/x86/include/asm/kvm_host.h               |   6 +
>   arch/x86/kvm/x86.c                            |  37 ++-
>   include/uapi/linux/kvm.h                      |  23 ++
>   tools/include/uapi/linux/kvm.h                |  23 ++
>   tools/testing/selftests/kvm/.gitignore        |   1 +
>   tools/testing/selftests/kvm/Makefile          |   1 +
>   .../selftests/kvm/include/x86_64/processor.h  |   4 +
>   .../selftests/kvm/lib/x86_64/processor.c      |  94 ++++++++
>   .../kvm/x86_64/emulator_error_test.c          | 219 ++++++++++++++++++
>   10 files changed, 423 insertions(+), 4 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/x86_64/emulator_error_test.c
> 

Queued, thanks (not yet tested, but still).

Paolo

