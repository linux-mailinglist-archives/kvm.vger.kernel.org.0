Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892752795E4
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 03:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729942AbgIZBPB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 21:15:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21326 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729911AbgIZBPA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 21:15:00 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601082899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9t91khu5vk6R18LNGpi1kxYeJVbZeFj+fLbOp41La0I=;
        b=clFTypVyxcTZtc3dC3To4ywgK/dl2yWS05kvL9wufsvjN/uthI4eXsdo+/of8FMb6YLGhR
        iE83x4+qyzkHM9boGBZWL6KnweLY2Hcyfsp5UcS6lzppWJeTPAWWzPar32BN/v6Wx8k4+t
        7/DKmzSeEA73fd0ot48yyG76EiQK2lI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-ghXccAr4N42WpuC0-GHFoA-1; Fri, 25 Sep 2020 21:14:58 -0400
X-MC-Unique: ghXccAr4N42WpuC0-GHFoA-1
Received: by mail-wr1-f71.google.com with SMTP id r16so1751678wrm.18
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 18:14:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9t91khu5vk6R18LNGpi1kxYeJVbZeFj+fLbOp41La0I=;
        b=oSN0jEyGbvRCEhr2v5pgU0aogkkAXxo9w1Qns8dIiqNCCOyVsWTAkVt58IoR2yiVfG
         a63RBnZoeEeBPYj6dYj/gNHdt546MCYy9YEz6tH46tnnii8My0XT+6Cq3C5cUJA6K3rz
         lpPCjvDXbaKnr4MvHvcY9IyZTIh/lhdIdbVtL1MK99Uu2E59Mwo6HrZAoje/AFKYiWn2
         4K7zvvI5X+SOTxxG26EUSBJV9egspsRZkHmTISBKFHMADo9m56kjPPu24iIG7Vz5X+xn
         bar13gTK3ELJa3vYfkWFtZwUlJS9fkxnIjZRO/BHp4sXMDERb0VPTv1woeq0LxRDdk5P
         q3hA==
X-Gm-Message-State: AOAM532fIHtiSUnwC77jL0/vuosHsrTPI5dYZSuhdQgZbImJjy7/XafC
        CbNG5GESA2QvZnUeMWZKDPh4dVRxEs6XvBBHknrN4ptEt+lre+yyFqc9RoyKtkhHuTBpPXhhGSD
        RxMWItHnhX2/K
X-Received: by 2002:a5d:568d:: with SMTP id f13mr6997070wrv.303.1601082896782;
        Fri, 25 Sep 2020 18:14:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDWq9bI57HwJozrRwYYvXyr2jmAFd4opRR6yOqDR5DFbCSCdevp1w/4eWjfo8bIhIjq2HJ9w==
X-Received: by 2002:a5d:568d:: with SMTP id f13mr6997045wrv.303.1601082896563;
        Fri, 25 Sep 2020 18:14:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id v204sm789831wmg.20.2020.09.25.18.14.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 18:14:55 -0700 (PDT)
Subject: Re: [PATCH 20/22] kvm: mmu: NX largepage recovery for TDP MMU
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
 <20200925212302.3979661-21-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <aa7752b0-d2d2-f387-602f-fbf3f0edf450@redhat.com>
Date:   Sat, 26 Sep 2020 03:14:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200925212302.3979661-21-bgardon@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/20 23:23, Ben Gardon wrote:
> +
> +	if (!kvm->arch.tdp_mmu_enabled)
> +		return err;
> +
> +	err = kvm_vm_create_worker_thread(kvm, kvm_nx_lpage_recovery_worker, 1,
> +			"kvm-nx-lpage-tdp-mmu-recovery",
> +			&kvm->arch.nx_lpage_tdp_mmu_recovery_thread);

Any reason to have two threads?

Paolo

