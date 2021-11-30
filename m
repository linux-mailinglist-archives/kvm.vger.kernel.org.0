Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBD4463B80
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 17:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238558AbhK3QVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 11:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238704AbhK3QUL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 11:20:11 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86496C061574;
        Tue, 30 Nov 2021 08:16:43 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id g14so89072912edb.8;
        Tue, 30 Nov 2021 08:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mzJ6JGKckSdI9QVOm/WqgiUaO2eWSx9RlGb8CUcCl4w=;
        b=BGtDTNJa6yl+3sQvIYCTCRiKOhxJrICeiKUd60ghIrHc2JQUA+Eqx2tTD5dNTf3ZkG
         XWZUJ3n2XZoQGZ/95AZ8JD2PJM4Fxnr3T23YyBkCkacY9C1VdaMM/UVQx7kyizhGWIng
         6um8VK7YEm4EcrQbDz/mH71PuCrfbNbLl4LRDoKILRik+pciV4t9X/JG9kU5vr/45n+Y
         JPywVfgr1/KmeuRNF+9Gcu3ECbqpdLhtH4T3lhTVNa5ruU4PPAGual4qZuYTPRXe2DRJ
         Anwb16sT8Yz+bYLJouW98HYyI8WWk4qFDE7zi9SRSvGASwtKDTQzoQOD75liaDJbMulJ
         nFMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mzJ6JGKckSdI9QVOm/WqgiUaO2eWSx9RlGb8CUcCl4w=;
        b=tPYtuJzR5vqafd66Yk2WlpWNonnyCmATlzZRnzHxEWCPePdaQdKFimFTkXJdCbbo+I
         cdZSH5XOqnIoFxFuZmYcRHzubjhffORnTy9b8avNNlSDjeXX/oDap8dbTZ0niV4SCcPE
         nBNC27H8LbAToFWkux2JAOFzJY/O/ptDmHJL+mfs1DrYHioUia5LrnzTUCRF+3+/uP+J
         wQb4hhAXpwuLXA7dhufShfBPCAl4ksLIEeGMk3X1I8+Bvser1PbV+ehX+ntafwRHFJuj
         UcvpyDZFFIE41Ucl3hxa5tD0BZhNKbO1UWgm0mTsXu5beR3O7jbqcRtDaN5y+K+vZlqg
         wM6g==
X-Gm-Message-State: AOAM533s42An43zgH6e3VLJ/UD9eZr7NQqWUQY/anWun5jQ/UocTRSED
        cJZ//Va8c+gs276h3wwVk1E=
X-Google-Smtp-Source: ABdhPJw2yRCId66xKjvWGOtJo37/MAUXUgEWlbSJBwdXpQc8hXYzqfCbuoni1K2nh9m8fWU22U0H2w==
X-Received: by 2002:a05:6402:5188:: with SMTP id q8mr86125381edd.181.1638289002148;
        Tue, 30 Nov 2021 08:16:42 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id hr17sm9270702ejc.57.2021.11.30.08.16.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 08:16:41 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <1469b131-cd76-e8bb-304b-73c59e81cb3b@redhat.com>
Date:   Tue, 30 Nov 2021 17:16:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 27/28] KVM: x86/mmu: Do remote TLB flush before dropping
 RCU in TDP MMU resched
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
References: <20211120045046.3940942-1-seanjc@google.com>
 <20211120045046.3940942-28-seanjc@google.com>
 <df9d430c-2065-804b-2343-d4bcdb7b2464@redhat.com>
 <YaZG/NopJ7YaVUjD@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YaZG/NopJ7YaVUjD@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/21 16:45, Sean Christopherson wrote:
>> Couldn't this sleep in kvm_make_all_cpus_request, whilst in an RCU read-side
>> critical section?
> No.  And if kvm_make_all_cpus_request() can sleep, the TDP MMU is completely hosed
> as tdp_mmu_zap_spte_atomic() and handle_removed_tdp_mmu_page() currently call
> kvm_flush_remote_tlbs_with_range() while under RCU protection.
> 
> kvm_make_all_cpus_request_except() disables preemption via get_cpu(), and
> smp_call_function() doubles down on disabling preemption as the inner helpers
> require preemption to be disabled, so anything below them should complain if
> there's a might_sleep().  hv_remote_flush_tlb_with_range() takes a spinlock, so
> nothing in there should be sleeping either.

Yeah, of course you're right.

Paolo
