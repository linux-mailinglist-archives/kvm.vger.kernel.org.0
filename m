Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9EFD27958A
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 02:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbgIZAW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 20:22:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31294 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726210AbgIZAW6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 20:22:58 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601079777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rBlE3tvrZRcR07h4TdGkfa39W1mZMtw8tbkErf6purU=;
        b=WHgze79JyEJkk856HDx3OoJAoTZsX4fUZRP2hiyU1Y4UQBpP6fWpYmoKi1iZRS1I3/V98X
        +AFKLSCU5rA7A6nu22uk5XJyI3hg5Ugiw/Xa1/RbRVUKyXo6pbrtqRuQnG+JJxVbNwiRlh
        DQf3yib5XqAGT4AZo4oOYN3XM+jV5Kc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-4xLLx2IePm27ZIMC-MKFTw-1; Fri, 25 Sep 2020 20:22:53 -0400
X-MC-Unique: 4xLLx2IePm27ZIMC-MKFTw-1
Received: by mail-wm1-f72.google.com with SMTP id t10so280465wmi.9
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 17:22:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rBlE3tvrZRcR07h4TdGkfa39W1mZMtw8tbkErf6purU=;
        b=ZpTlE8k8EvJnoNM0G+cER6LdlNgaM50XQKC+HKdvkAM11TFEwZ5L5lSMKPguOO5Q+J
         9NMpBFm25gY6UhQT5AcCP9gkGdFjZDMUMyYo2ZfV28vyN0iTH7L9+aWbQdMeEu6Vp0R3
         my+/8uq32HdnKCcpzjFmlc33947OL/hpydWX3Qir96PD1ZMxufyxGGB92WZfdStjiWSh
         oDeN0jJsrfd9Rk+zsw/K0IO2WkbItiEKQHizLkrm4VsnTbd6hAVMDZTylqNRCZ2MmwzZ
         1SHtDAvS1B6y7FIlIlM7Rmvc7g7grlJ2CPEmGsa6BmfL4ptQ+pC6HZ+gAlz9mdy65u8b
         QN6A==
X-Gm-Message-State: AOAM532VEP39713ZAi7TvlqQOAfqMZvqulyARSXWFSTeq7ajNeVUSJ6F
        gYezWxsi5iZfgRrAmgxHEpwnlEJ0aq0o4PuBthHYvSwOcZ71itqVvK0YF5gSS/jbXR679Nmwa/8
        LqP80eLTHBq1q
X-Received: by 2002:a7b:ca56:: with SMTP id m22mr136186wml.12.1601079772162;
        Fri, 25 Sep 2020 17:22:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxiiKCVuLI2gYBswLm6UU+Fi8dc+cQm+ThtHpsWa+fhYRqFwMLwToTh+QC3bXJ5wYA2sYDyfQ==
X-Received: by 2002:a7b:ca56:: with SMTP id m22mr136161wml.12.1601079771862;
        Fri, 25 Sep 2020 17:22:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id c14sm4503667wrm.64.2020.09.25.17.22.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 17:22:51 -0700 (PDT)
Subject: Re: [PATCH 11/22] kvm: mmu: Factor out allocating a new tdp_mmu_page
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-12-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <66db4185-d794-4b3e-89c2-c07f4f2b5f2a@redhat.com>
Date:   Sat, 26 Sep 2020 02:22:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200925212302.3979661-12-bgardon@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/20 23:22, Ben Gardon wrote:
> Move the code to allocate a struct kvm_mmu_page for the TDP MMU out of the
> root allocation code to support allocating a struct kvm_mmu_page for every
> page of page table memory used by the TDP MMU, in the next commit.
> 
> Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
> machine. This series introduced no new failures.
> 
> This series can be viewed in Gerrit at:
> 	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Maybe worth squashing into the earlier patch.

Paolo

