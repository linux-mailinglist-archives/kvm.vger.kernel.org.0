Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330F9431721
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 13:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhJRLZV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 07:25:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38291 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231271AbhJRLZU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 07:25:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634556189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DH9MmuWPIFv8Xp2QWT2sodcLkmf50VTNvopcpg7U4YM=;
        b=cQJcyW+c4/Nmuc3RFniOWr4SOarAOWfJV59DpuT3Oe8E60s1PkWMEgwAUVaKJk3QCoY/Al
        e0MvdCGPZeGV+rsBCyaaDSQte/VVp8/J8PZP6FbsidNuaO8PyR2DN6CfRBwDPaonZHcfps
        37THpLABk6zoTPkB4yVQU25tgaaz8tE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-uBDyPJdcNk2xVw8uqTEu5w-1; Mon, 18 Oct 2021 07:23:07 -0400
X-MC-Unique: uBDyPJdcNk2xVw8uqTEu5w-1
Received: by mail-wm1-f71.google.com with SMTP id s10-20020a1cf20a000000b0030d66991388so3070580wmc.7
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 04:23:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=DH9MmuWPIFv8Xp2QWT2sodcLkmf50VTNvopcpg7U4YM=;
        b=Paq50zTtB6VYZZl0/oruoNUgABZB/jAG0HQ6uFfhLjgHJ/yXwjzJm7BuPhrqiJdYcu
         oiX7mW6gVyLOSf5KDqDK/rj29x2EB5bZM1dlMf6UgU4ekJLakVaFQoJb98O1cy8/n3gp
         68xtC+GRfpobMT7RXaiJzmJpaqmapzOIneISiBNb2DDN5jchtWVfV0jmHTiQFUKqbQje
         E4Bd7BSxIxKdVB5iMWmCYy7vZGg4msIJnrrGpllUucWdOi3ESU65tPSeDwWcHylVAJVL
         4hdurWACGvHYB9IptOm2137AKi6ng71g0k/trlTKBiQ/gyaHcCKwRiPPQtGigeOsv2/9
         hoSQ==
X-Gm-Message-State: AOAM532EIGMB5ms9/IQnpEfPJoHPWTzdpFIoF0ixU11n8Oh4dW+SwDcY
        Wo5ItUrOxAMnvbacnrW0ASRwUxMOmpztlJPsT8nl0uyeY9nWMq7PBo37A55QyzCrtDmbSlTBdiJ
        FGO3X0WXnl7OP
X-Received: by 2002:adf:d1e3:: with SMTP id g3mr35329029wrd.63.1634556186814;
        Mon, 18 Oct 2021 04:23:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzE/NxmnDikAIWz7KVPC9n9ISxaSf9rTpK5oYp0RHeXe6M+UoOV2w6tzahEFy7lHBOVHl0z7w==
X-Received: by 2002:adf:d1e3:: with SMTP id g3mr35329003wrd.63.1634556186611;
        Mon, 18 Oct 2021 04:23:06 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t1sm2185823wre.32.2021.10.18.04.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 04:23:06 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Matlack <dmatlack@google.com>,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH RFC] KVM: SVM: reduce guest MAXPHYADDR by one in case
 C-bit is a physical bit
In-Reply-To: <87ee8iye6b.fsf@vitty.brq.redhat.com>
References: <20211015150524.2030966-1-vkuznets@redhat.com>
 <YWmdLPsa6qccxtEa@google.com> <87ee8iye6b.fsf@vitty.brq.redhat.com>
Date:   Mon, 18 Oct 2021 13:23:04 +0200
Message-ID: <874k9ey3tz.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Sean Christopherson <seanjc@google.com> writes:
>
>> On Fri, Oct 15, 2021, Vitaly Kuznetsov wrote:
>>> Several selftests (memslot_modification_stress_test, kvm_page_table_test,
>>> dirty_log_perf_test,.. ) which rely on vm_get_max_gfn() started to fail
>>> since commit ef4c9f4f65462 ("KVM: selftests: Fix 32-bit truncation of
>>> vm_get_max_gfn()") on AMD EPYC 7401P:
>>> 
>>>  ./tools/testing/selftests/kvm/demand_paging_test
>>>  Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
>>>  guest physical test memory offset: 0xffffbffff000
>>
>> This look a lot like the signature I remember from the original bug[1].  I assume
>> you're hitting the magic HyperTransport region[2].  I thought that was fixed, but
>> the hack-a-fix for selftests never got applied[3].
>>
>> [1] https://lore.kernel.org/lkml/20210623230552.4027702-4-seanjc@google.com/
>
> Hey,
>
> it seems I'm only three months late to the party!
>
>> [2] https://lkml.kernel.org/r/7e3a90c0-75a1-b8fe-dbcf-bda16502ace9@amd.com
>> [3] https://lkml.kernel.org/r/20210805105423.412878-1-pbonzini@redhat.com
>>
>
> This patch helps indeed

FWIW, 'access_tracking_perf_test' remains broken even after the patch is
applied:

# ./access_tracking_perf_test 
Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
guest physical test memory offset: 0xfffcbffff000

Populating memory             : 3.858448918s
Writing to populated memory   : 0.937319626s
Reading from populated memory : 0.003073207s
==== Test Assertion Failure ====
  lib/kvm_util.c:1382: false
  pid=6422 tid=6425 errno=4 - Interrupted system call
     1	0x000000000040667d: addr_gpa2hva at kvm_util.c:1382
     2	 (inlined by) addr_gpa2hva at kvm_util.c:1376
     3	 (inlined by) addr_gva2hva at kvm_util.c:2245
     4	0x0000000000402909: lookup_pfn at access_tracking_perf_test.c:98
     5	 (inlined by) mark_vcpu_memory_idle at access_tracking_perf_test.c:152
     6	 (inlined by) vcpu_thread_main at access_tracking_perf_test.c:232
     7	0x00007fd02d1cb431: ?? ??:0
     8	0x00007fd02d0f9912: ?? ??:0
  No vm physical memory at 0xfcbffff000

(and my cpuid hack reducing guest physical address space by half doesn't
seem to help either)

-- 
Vitaly

