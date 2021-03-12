Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E37F33942B
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 18:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbhCLRBd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 12:01:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35346 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232828AbhCLRBH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 12:01:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615568467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ibEFyDcNRQcFn8mb4AJj959j835v5WAGXwvC24n6Zqc=;
        b=bdWRqFM1UQr5tE0FPGlBzv/ucpIb7G4k/byScu2FaB8urnHjrGNR2etO2SRVJXFLqa0Uzw
        VNqo1hl4XFnh8YCznPdi7wlToGcHVVIhpj0ZRXp6+tWjCb1dm0VkNBiDbHkisVHepJEGtE
        dDdW3ZSvgZ2ArBxpCBd0byY4qX3myBc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-xL7kyQHsNJStuOZYK9buVQ-1; Fri, 12 Mar 2021 12:00:58 -0500
X-MC-Unique: xL7kyQHsNJStuOZYK9buVQ-1
Received: by mail-wr1-f72.google.com with SMTP id e13so11416004wrg.4
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 09:00:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ibEFyDcNRQcFn8mb4AJj959j835v5WAGXwvC24n6Zqc=;
        b=Gq+/DCCZ9bbxAqhnW1u02deOCXrnzJ5Qe+CSBLIL+A6vMsKVjFHXnak2VcAPKdA2li
         vu/28m01YVAkTAxt4o1/FgC/BvmEQE6Z0DyQqC/9iUuVPfPprXlN8ddbzOADYeRBzdYN
         Dv4TX4v7WR0JqazuXy58D+KRzSLQgcCJLmrz4YwwasyHSrTa6mKE9AJOwdfkrGbbFiWE
         /Mdj3FB4rMnk+szmN4lxLwBeG9bsahuxc7XSIL+7IcxWBB2hUmu5SebyS7rpUvC0XzIW
         x6EClgjIqstptRt+kASw8+9Qb88i/92sUFoIA9UWmFZU67of7iTJ0NtuwQ6GyWqcn+q7
         U2mw==
X-Gm-Message-State: AOAM530Mbc5hQoZmQmaK1cd3xZbKDphAcfZlUVeTXD4l/Om4Sm0mGcL9
        qG7yfA240YZUMEGvp1B3g/F2qPSAEE30uTM7vfd3u+ewpOSwffxPD3ajzCk8l5PZEwHwLHNBQy/
        opYjSH2adAaz2
X-Received: by 2002:adf:ab52:: with SMTP id r18mr14896225wrc.65.1615568451693;
        Fri, 12 Mar 2021 09:00:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxfQkaiAQ/ku5Iskzu4+3i1V5GziZi87TzTf1flgCqphkmpmEAqCUhOTWTVnB2ZyCnQdx7k/Q==
X-Received: by 2002:adf:ab52:: with SMTP id r18mr14895600wrc.65.1615568446554;
        Fri, 12 Mar 2021 09:00:46 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s11sm2957818wme.22.2021.03.12.09.00.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 09:00:45 -0800 (PST)
Subject: Re: [PATCH 4/4] KVM: x86/mmu: Factor out tdp_iter_return_to_root
To:     Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
References: <20210311231658.1243953-1-bgardon@google.com>
 <20210311231658.1243953-5-bgardon@google.com> <YEuYTF3mzzMCkz5c@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f3bf9ad8-8179-b2bf-7511-403ed4d1d165@redhat.com>
Date:   Fri, 12 Mar 2021 18:00:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YEuYTF3mzzMCkz5c@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/03/21 17:35, Sean Christopherson wrote:
> What about calling it tdp_iter_restart()?  Or tdp_iter_resume()?  Or something
> like tdp_iter_restart_at_next() if we want it to give a hint that the next_last
> thing is where it restarts.
> 
> I think I like tdp_iter_restart() the best.  It'd be easy enough to add a
> function comment clarifying from where it restarts, and IMO the resulting code
> in tdp_mmu_iter_cond_resched() is the most intutive, e.g. it makes it very clear
> that the walk is being restarted in some capacity after yielding.

I agree with tdp_iter_restart(), or tdp_iter_restart_from_root() too.

Paolo

