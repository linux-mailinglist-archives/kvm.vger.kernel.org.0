Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4C1304C7B
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 23:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730204AbhAZWr3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:47:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30691 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394300AbhAZUt0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 15:49:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611694075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/HCxN2RDFJhyhwGoOhLA9wekT4P5GPKPHVcg2cvskDY=;
        b=ClnTffKFmCzyD42arQuxAxi6hji9XBa6H9C86mqfjgySkuuk47EJaCjF/C1h2idYZZLesR
        j61yj9ZljNEyIzpsYWX36qM0RKySYWqLhl1h8oGWCl5fXT1fDDfruAvNCsNWppiT4Aui9e
        8X/nsDRl3HDL7PztMyS9/3YusvJr3OI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-XCB86fu8OcK0rDemRAMkHQ-1; Tue, 26 Jan 2021 15:47:54 -0500
X-MC-Unique: XCB86fu8OcK0rDemRAMkHQ-1
Received: by mail-ed1-f70.google.com with SMTP id o8so4679100edh.12
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 12:47:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/HCxN2RDFJhyhwGoOhLA9wekT4P5GPKPHVcg2cvskDY=;
        b=Lg/P8d+erJ+sp1abTko0mdsxpb3sZHWWpT8tleXl0iMavYkVoBoTedhRtJn300JNRw
         QIQr3QWWvn8i1aKBnqWiIK5tT8xjCfB9+QHy72gmb+3Scgo6iLJaL6+hn22Q6XDpGZAk
         RIaYpZjB8PEkbtHSGADt+OnoS/wXpEYysrh9r9Xu2eQocu9CA5FjCBxoW1AexITxm3U6
         qRbqkHHcVY1e7A9Sy4vJt9zif7wG2g+7nbEEKjgGiIQ/eNPzjE2oTkwS4j5Zc9hliVgQ
         9AETZLigRr3UhY8hdoRmjQwTM7XZwjjhpGXbYVaY1cWjEaeknNQabzvnB1PQ5DmEkbC+
         8Kjg==
X-Gm-Message-State: AOAM531wl4wexD4IO+DeWieMpEdBRKR2Vj0q9mikeMYTDubTGPu6Cg8y
        fDS5q6S5CRthH0C/rkmBeeGIblqdOV/lTFCR6JVXrlgaQiQ0pMQAlS1M3BrEzqYgpxRS90OCTWw
        TzZYC9d/dz4xw
X-Received: by 2002:a05:6402:b30:: with SMTP id bo16mr6189939edb.84.1611694073166;
        Tue, 26 Jan 2021 12:47:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzmZ5HCWexDCC3GBD7cA6Oeb9RSprTKU/jHiBICZcXEbfaoLoWKIRxt5Atedh7pEV7ZLumFIQ==
X-Received: by 2002:a05:6402:b30:: with SMTP id bo16mr6189928edb.84.1611694073017;
        Tue, 26 Jan 2021 12:47:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x21sm1202290eje.118.2021.01.26.12.47.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 12:47:51 -0800 (PST)
Subject: Re: [PATCH 15/24] kvm: mmu: Wrap mmu_lock cond_resched and needbreak
To:     Ben Gardon <bgardon@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210112181041.356734-1-bgardon@google.com>
 <20210112181041.356734-16-bgardon@google.com> <YAjIddUuw/SZ+7ut@google.com>
 <460d38b9-d920-9339-1293-5900d242db37@redhat.com>
 <CANgfPd_WvXP=mOnxFR8BY=WnbR5Gn8RpK7aR_mOrdDiCh4VEeQ@mail.gmail.com>
 <fae0e326-cfd4-bf5d-97b5-ae632fb2de34@redhat.com>
 <CANgfPd_TOpc_cinPwAyH-0WajRM1nZvn9q6s70jno5LFf2vsdQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f1ef3118-2a8e-4bf2-b3b0-60ac4947e106@redhat.com>
Date:   Tue, 26 Jan 2021 21:47:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd_TOpc_cinPwAyH-0WajRM1nZvn9q6s70jno5LFf2vsdQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/01/21 19:11, Ben Gardon wrote:
> When I did a strict replacement I found ~10% worse memory population
> performance.
> Running dirty_log_perf_test -v 96 -b 3g -i 5 with the TDP MMU
> disabled, I got 119 sec to populate memory as the baseline and 134 sec
> with an earlier version of this series which just replaced the
> spinlock with an rwlock. I believe this difference is statistically
> significant, but didn't run multiple trials.
> I didn't take notes when profiling, but I'm pretty sure the rwlock
> slowpath showed up a lot. This was a very high contention scenario, so
> it's probably not indicative of real-world performance.
> In the slow path, the rwlock is certainly slower than a spin lock.
> 
> If the real impact doesn't seem too large, I'd be very happy to just
> replace the spinlock.

Ok, so let's use the union idea and add a "#define KVM_HAVE_MMU_RWLOCK" 
to x86.  The virt/kvm/kvm_main.c MMU notifiers functions can use the 
#define to pick between write_lock and spin_lock.

For x86 I want to switch to tdp_mmu=1 by default as soon as parallel 
page faults are in, so we can use the rwlock unconditionally and drop 
the wrappers, except possibly for some kind of kvm_mmu_lock/unlock_root 
that choose between read_lock for TDP MMU and write_lock for shadow MMU.

Thanks!

Paolo

