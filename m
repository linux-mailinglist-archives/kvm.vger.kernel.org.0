Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 039E4190C7D
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 12:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgCXLas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 07:30:48 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:43709 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727416AbgCXLap (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 07:30:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585049443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HUoI3izHtkIzFR5QtYPD1Igvkj0MnI7ELPqcHmKkEcc=;
        b=NKeb8To5AfLAkiY8nBB0TTEg0ft/chu/XFtpTfnX0o7e9GVIT/B9wrNbeFAkR9OROy3j99
        1ewAdjysfw6HkfO7k+kNSgu4dVo0FT6qaggHaS1PZ6ebnhoGIPbsypgeqliTOIZZo+135c
        kAmYSwJRdkrsWrI1zh6lrIInJFMDUAk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-TnIuv_ieMvOsLfEqKC9DTQ-1; Tue, 24 Mar 2020 07:30:42 -0400
X-MC-Unique: TnIuv_ieMvOsLfEqKC9DTQ-1
Received: by mail-wr1-f72.google.com with SMTP id d1so7937810wru.15
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 04:30:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HUoI3izHtkIzFR5QtYPD1Igvkj0MnI7ELPqcHmKkEcc=;
        b=cDevapiUZzsv+MVmN2bGvTpcz8Rxq0W+UKJ6KkPcA9K31mEU/rU1CocPEJ4qjRq45c
         jAlcHG6+wnQTtKo+FYmZlGZRF6OCuf6n4/Hxggb/MEawaGBP0DaUxT6tDjBDbY4/uRwx
         FsHHfvmgYX/YlGYb7vWAK4nCaPM9O1PAEGqfJtpqa/e6BkzsxKvGRcxuUBzPS71LkoSn
         Yq0ssks9yCm4FpQOr7Z7RxNdK8ipAPpbsVtdK6TYUgRwqXyWDxBGICBda6ivHORa8cl7
         /Y3Um9Vr1nxldrZqQb/De/QtPfpE1nkYy6+PQVZ6ASxVluVL8aSQ/3je7GB+Z8jOiDf+
         26Sw==
X-Gm-Message-State: ANhLgQ1aOt62pvWhN2Rk8ixQ/izmNu+8CWBpftGR3w0+fZtIGscuFSYN
        qqb3XnasjjEeExy/0eM5xwc5BsgVnRdmM70l0jfwu6BD/uNapnK0ISypmAGPTZMgGHcT2gzbL90
        XWb8M+R2IO04P
X-Received: by 2002:adf:ab12:: with SMTP id q18mr37220832wrc.148.1585049441332;
        Tue, 24 Mar 2020 04:30:41 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuUjSBUhhUbkbFZ5FgkCOpcr55gKEKWk7dXYHSUq5RRMQjE2NU1Uym3jModjIYPajJh5t5cXA==
X-Received: by 2002:adf:ab12:: with SMTP id q18mr37220804wrc.148.1585049440995;
        Tue, 24 Mar 2020 04:30:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7848:99b4:482a:e888? ([2001:b07:6468:f312:7848:99b4:482a:e888])
        by smtp.gmail.com with ESMTPSA id o67sm3965202wmo.5.2020.03.24.04.30.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2020 04:30:40 -0700 (PDT)
Subject: Re: [PATCH 0/7] KVM: Fix memslot use-after-free bug
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Peter Xu <peterx@redhat.com>
References: <20200320205546.2396-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <aa19166a-a4bd-28c2-88a0-ab5b18e8f473@redhat.com>
Date:   Tue, 24 Mar 2020 12:30:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200320205546.2396-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/03/20 21:55, Sean Christopherson wrote:
> Fix a bug introduced by dynamic memslot allocation where the LRU slot can
> become invalid and lead to a out-of-bounds/use-after-free scenario.
> 
> The patch is different that what Qian has already tested, but I was able
> to reproduce the bad behavior by enhancing the set memory region selftest,
> i.e. I'm relatively confident the bug is fixed.
> 
> Patches 2-6 are a variety of selftest cleanup, with the aforementioned
> set memory region enhancement coming in patch 7.
> 
> Note, I couldn't get the selftest to fail outright or with KASAN, but was
> able to hit a WARN_ON an invalid slot 100% of the time (without the fix,
> obviously).
> 
> Regarding s390, I played around a bit with merging gfn_to_memslot_approx()
> into search_memslots().  Code wise it's trivial since they're basically
> identical, but doing so increases the code footprint of search_memslots()
> on x86 by 30 bytes, so I ended up abandoning the effort.
> 
> Sean Christopherson (7):
>   KVM: Fix out of range accesses to memslots
>   KVM: selftests: Fix cosmetic copy-paste error in vm_mem_region_move()
>   KVM: selftests: Take vcpu pointer instead of id in vm_vcpu_rm()
>   KVM: selftests: Add helpers to consolidate open coded list operations
>   KVM: selftests: Add util to delete memory region
>   KVM: selftests: Expose the primary memslot number to tests
>   KVM: selftests: Add "delete" testcase to set_memory_region_test
> 
>  arch/s390/kvm/kvm-s390.c                      |   3 +
>  include/linux/kvm_host.h                      |   3 +
>  .../testing/selftests/kvm/include/kvm_util.h  |   3 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 139 ++++++++++--------
>  .../kvm/x86_64/set_memory_region_test.c       | 122 +++++++++++++--
>  virt/kvm/kvm_main.c                           |   3 +
>  6 files changed, 201 insertions(+), 72 deletions(-)
> 

Queued patches 1-3, thanks.

Paolo

