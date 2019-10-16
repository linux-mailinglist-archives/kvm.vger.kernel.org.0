Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07775D9796
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 18:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406283AbfJPQiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 12:38:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34626 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390211AbfJPQit (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 12:38:49 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 28E1785360
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 16:38:49 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id n18so11964566wro.11
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 09:38:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vjbKDvVFPL0th2krdx8wMvub7uxuN9FX2tXsWBpSZGA=;
        b=PxtaBDuzuBlg91sZzAwSl1kjUgAtN0jqoIjMT3nVV4SIZC/IzYwZgAIELExtOHaV0f
         xegSOfl6npJIft7xnTqiiksa5pNyQilpccTVCUL+djO/T3DF0X9YFZOdoz+e9cljMKCE
         9TgEmKA5KvdDgRMLK+kA9dvW1UwgS9lN8IjksSTFcy8ppOSuAFZHd+mO2NQOmvwYBNCw
         m7XvtdXTIbjJ/bT6rYbfbOs9eCeYcHZnqFm4wuFp781BwPYno/dwDNnelaMraO69c56P
         aT7yFR0vwIdUGH9Q83HyGn5eV/CkGx1x+owRL11S5pcVkGdkW2lBnVB4QfJNXptX8WKQ
         5j8g==
X-Gm-Message-State: APjAAAWgwX0RArRUqhTRtp3ZVkhY71C/yZdR89U58GcrxbeJRe+DVmbQ
        3FQN2qEhpILckdtzLICKx9Jw/4B72MigD7NFvWvnDpyKb5pyjgnYoOarJ/XC+QVokCO/HJzwQ7R
        pWSX953xnYZtT
X-Received: by 2002:a1c:1bc5:: with SMTP id b188mr4397242wmb.88.1571243927611;
        Wed, 16 Oct 2019 09:38:47 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyTRKkY7xojuOdJ8XLJRUq8YBcEngwDEOfnwMsHIoBx2ccVCj7UoQkvx5J80rejnnTYAPIXcw==
X-Received: by 2002:a1c:1bc5:: with SMTP id b188mr4397221wmb.88.1571243927350;
        Wed, 16 Oct 2019 09:38:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d001:591b:c73b:6c41? ([2001:b07:6468:f312:d001:591b:c73b:6c41])
        by smtp.gmail.com with ESMTPSA id b62sm4008159wmc.13.2019.10.16.09.38.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 09:38:46 -0700 (PDT)
Subject: Re: [PATCH v9 09/17] x86/split_lock: Handle #AC exception for split
 lock
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
 <1560897679-228028-10-git-send-email-fenghua.yu@intel.com>
 <alpine.DEB.2.21.1906262209590.32342@nanos.tec.linutronix.de>
 <20190626203637.GC245468@romley-ivt3.sc.intel.com>
 <alpine.DEB.2.21.1906262338220.32342@nanos.tec.linutronix.de>
 <20190925180931.GG31852@linux.intel.com>
 <3ec328dc-2763-9da5-28d6-e28970262c58@redhat.com>
 <alpine.DEB.2.21.1910161142560.2046@nanos.tec.linutronix.de>
 <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com>
 <c3ff2fb3-4380-fb07-1fa3-15896a09e748@intel.com>
 <d30652bb-89fa-671a-5691-e2c76af231d0@redhat.com>
 <8808c9ac-0906-5eec-a31f-27cbec778f9c@intel.com>
 <alpine.DEB.2.21.1910161519260.2046@nanos.tec.linutronix.de>
 <ba2c0aab-1d7c-5cfd-0054-ac2c266c1df3@redhat.com>
 <bea889c5-1599-1eb8-ff3a-3bde1e58afa3@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f9735fb8-650e-c263-36a7-61390ccbb662@redhat.com>
Date:   Wed, 16 Oct 2019 18:38:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <bea889c5-1599-1eb8-ff3a-3bde1e58afa3@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/19 18:25, Xiaoyao Li wrote:
>>
>>    3 | Y         |     Y       |  N  |   Y     |   x   | Switch
>> MSR_TEST_CTRL on
>>      |           |             |     |         |       | enter/exit,
>> plus:
>>      |           |             |     |         |       | A) #AC
>> forwarded to guest.
>>      |           |             |     |         |       | B) SIGBUS or
>> KVM exit code
>>
> 
> I just want to get confirmed that in (3), we should split into 2 case:
> 
> a) if host has it enabled, still apply the constraint that guest is
> forcibly enabled? so we don't switch MSR_TEST_CTL.
> 
> b) if host has it disabled, we can switch MSR_TEST_CTL on enter/exit.

That's doable, yes.

Paolo
