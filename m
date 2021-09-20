Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97543411562
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 15:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239253AbhITNUL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 09:20:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51031 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236028AbhITNUL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 09:20:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632143924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XZbiHti4vCOqgWKM54l6a3juvV92A2baM8UIqCN0ZRQ=;
        b=RI7g7GuCburUcVWCcAq22wbtDkgIg205YCB1Ss6jQZWSVt7L4keYz4zPlYSQtUnDG4XPi7
        vUeRIeJLhM5xWKoybvWiMCTAze7iOgzPcCKDw5YCKf3HdvgA3zyql+V0j1T9md+K9vOyhp
        D2lftFjn86IHp0cEXqaOCUAJjTBDyC8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-J6n7XLTFNjS_j_PlKJatgA-1; Mon, 20 Sep 2021 09:18:34 -0400
X-MC-Unique: J6n7XLTFNjS_j_PlKJatgA-1
Received: by mail-wr1-f71.google.com with SMTP id c2-20020adfa302000000b0015e4260febdso4726609wrb.20
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 06:18:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XZbiHti4vCOqgWKM54l6a3juvV92A2baM8UIqCN0ZRQ=;
        b=6aQSb5vvKDqsH1SU++8g+HlKfINh+GUvsQKSMuH53kCC2+hYsvjH2gCp1jCzB6+vlO
         e70o/D3O5LAtz9+qJRNT2IjalHvllHPDYhx0adR0xNDD5YFeb7cVvm+ToccOOPVtNxB9
         5NF/EEhWN8dpeogUkkJP7gV9txwfxNDVd/irBmwajHJZEzZa8R02bpKjceHE03DI4fCy
         HazYVlh4bvm32veW3Z+qUIQ2/YeFB3yxhB6sVQ2QT9a2ndrb4N2+OOrUxzQkiaWj3z4B
         r+CEflXD6sz6Pyl3Q2C08hXEpzdv4/ONXEeAPAr4bMF1j+kFy9lJUu1ibxZMvKnx1aCa
         89HQ==
X-Gm-Message-State: AOAM533vDMfu/7iyLKFMk4001blZCmxLIzNFtGM8y658jZCz4iu6axQL
        Yp0lBvC2CzgWzqcwm5/5ANKuEVib6kx+gPolx4dpeJPg6/GKTASmAkoNvmLFb9op0o1AETJ+zK3
        fvmTNBZgQUZr9
X-Received: by 2002:a5d:6c6d:: with SMTP id r13mr13376877wrz.439.1632143913674;
        Mon, 20 Sep 2021 06:18:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7N3hxz36qRlOw1/rL/DwL4aDROJ8XxG8xzFR2ylC3WRZ+AXi5MycER2AoBKQtMUNziJuirw==
X-Received: by 2002:a5d:6c6d:: with SMTP id r13mr13376850wrz.439.1632143913429;
        Mon, 20 Sep 2021 06:18:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o12sm13359543wms.15.2021.09.20.06.18.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 06:18:32 -0700 (PDT)
Subject: Re: [PATCH v2 00/13] perf: KVM: Fix, optimize, and clean up callbacks
To:     Marc Zyngier <maz@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Guo Ren <guoren@kernel.org>, Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
References: <20210828003558.713983-1-seanjc@google.com>
 <20210828201336.GD4353@worktop.programming.kicks-ass.net>
 <YUO5J/jTMa2KGbsq@google.com>
 <YURDqVZ1UXKCiKPV@hirez.programming.kicks-ass.net>
 <662e93f9-e858-689d-d203-742731ecad2c@redhat.com>
 <87tuifv3mb.wl-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7a5825d1-d6e9-8ac8-5df2-cce693525da7@redhat.com>
Date:   Mon, 20 Sep 2021 15:18:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87tuifv3mb.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/09/21 14:22, Marc Zyngier wrote:
>> I think that's only ARM, and even then it is only because of
>> limitations of the hardware which mostly apply only if VHE is not in
>> use.
>>
>> If anything, it's ARM that should support module build in VHE mode
>> (Linux would still need to know whether it will be running at EL1 or
>> EL2, but KVM's functionality is as self-contained as on x86 in the VHE
>> case).
> I don't see this happening anytime soon. At least not before we
> declare the arm64 single kernel image policy to be obsolete.

--verbose please. :)  I am sure you're right, but I don't understand the 
link between the two.

Paolo

