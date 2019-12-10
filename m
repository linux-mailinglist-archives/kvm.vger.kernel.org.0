Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFC5118515
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 11:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbfLJK3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 05:29:05 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32749 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727116AbfLJK3F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Dec 2019 05:29:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575973744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iYRdhx94lZEfdmmjolViEp26vremOEQhwyKs35+L2rM=;
        b=c77gJqOYUsQL1d9KSg+A03qtUipZ8AXGNTqjDnUbwLIINBTvVSahW8ANhm41V8tVWDl7pg
        I/1K4yohJvhMRhSCytYEJroREsLotrp4OYCE5rQvfu9Esltz1SbO+XFM/UqNAU/7FLBpg0
        0CAJ1TLIcjF4ZlzHpP2/rG0+mJUJGFQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-56ZsMUwiPvCumw3t-H6MIw-1; Tue, 10 Dec 2019 05:29:02 -0500
Received: by mail-wm1-f69.google.com with SMTP id q21so832816wmc.7
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 02:29:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iYRdhx94lZEfdmmjolViEp26vremOEQhwyKs35+L2rM=;
        b=QrHO+g21JIKHnlMdf3h1oB8VM3aU2aHC4K8Xoo+Ch3I6Q8Tqx8Hm7GqhcIDseuC238
         xnhuyJ4thKDFQ2kbH8dmZ/02K8CEfrS6ggUg1Cdk0BEXlD+Iqxtv1PPVwjOG/QCPvLwj
         yEyyrOTse+DNU+PDUggzv+rc9RFirDxLMp098GDoJbAvkZkxAM5NIpEHRRDEgE6dH1LV
         44D9IaGcexkmR73XVrCgD3WfkDCQV72lJJq4gBgjX1/dLp6fI/Q92qgTGF9B3nANa/f4
         eh34psDmGpKuRK5pKPHD4hZDnZwCxG+WECztSBScWWvxgan0XhDske1hbp6U64pjxqnO
         v8Kw==
X-Gm-Message-State: APjAAAWBG0cJsL13na8IMWXr8NYLsOhobjGNpTE4mQD1gXcZY3A8y/rJ
        d02pCwB1VIaAyq0VGHky89DENtkqesBo0+dZ3efVybCN5dbTYbooUKmLK8zqo/sKl43OKWCz2rM
        mU6+ipcwwOBUR
X-Received: by 2002:a5d:6284:: with SMTP id k4mr2304026wru.398.1575973740917;
        Tue, 10 Dec 2019 02:29:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqzuMgkVYc+esWPIvGo0F5L891J0fK0Q3nskPFxv2CWHs5OO4BgCv23sK914Q45HzzW2+5D5HQ==
X-Received: by 2002:a5d:6284:: with SMTP id k4mr2303997wru.398.1575973740718;
        Tue, 10 Dec 2019 02:29:00 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id f1sm2551482wml.11.2019.12.10.02.29.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 02:29:00 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: Add a WARN on TIF_NEED_FPU_LOAD in
 kvm_load_guest_fpu()
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191209200517.13382-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bf494125-1de6-dc41-1438-0ee5f802c229@redhat.com>
Date:   Tue, 10 Dec 2019 11:29:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191209200517.13382-1-sean.j.christopherson@intel.com>
Content-Language: en-US
X-MC-Unique: 56ZsMUwiPvCumw3t-H6MIw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/12/19 21:05, Sean Christopherson wrote:
> +	/*
> +	 * Reloading userspace's FPU is handled by kvm_arch_vcpu_load(), both
> +	 * for direct calls from userspace (via vcpu_load()) and if this task
> +	 * is preempted (via kvm_arch_sched_in()) between vcpu_load() and now.

via kvm_sched_in (not the arch_ function).  Applied with that change.

Paolo

> +	 */
> +	WARN_ON_ONCE(test_thread_flag(TIF_NEED_FPU_LOAD));
> +

