Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4DDDD8DA9
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 12:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392311AbfJPKQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 06:16:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34862 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731227AbfJPKQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 06:16:47 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AD92AC057E9A
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 10:16:46 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id s16so780336wme.6
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 03:16:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FqU17P1qR94N/PHEmxrZJeNNd2E82hqushMeG+PRQqM=;
        b=PGxCTwZt6h+5NftbW2uR1DGT83H6mFCrNcKEKWJ9+RKpNkM1lYn6OWcf8owZE++7d7
         jc769nKi4d7b6B1CwlPpy+1fARLD0Hyozf5MXY2NynSinQBbix64wSQszhjokSUluJMR
         pLkeNIsdFiq8mAW/aWUET5beeOAHop6LP7Y3y402tOufJgxoHZ96Q5cNMWR5r107hJR+
         L0GESqrKcj3y+0yeoeB4mhfaFEZl7V46FllG+4fYuOxPlMJu+LrXXVG/jXbNlzrAwzHK
         eo94EkFo8qcIAqS8wyDYe1mdMhR9onMKK1+J5AB0xgB5cKyJTfYvzfBoqnsJVtyl5QB2
         iVTQ==
X-Gm-Message-State: APjAAAUJZv4ali7FtXJQc+w74TPQTOBF46UgLbEmMh7TShMJ8mY9rurA
        RtEKloTsy6vTQtIF5da73Z9vCZslDza1SxKipC0soMuQo7YJO7ZHMTwnQMRWaZBC4dxB7kB7FvC
        az0lPMnqEWmQn
X-Received: by 2002:a7b:ca54:: with SMTP id m20mr2832437wml.142.1571221005075;
        Wed, 16 Oct 2019 03:16:45 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzsIkx/eCnPYwYgdrORxF+fi7dWkpIzcQ1zHw9HznCWXeTkyvriGZUYtXynSytJfjZaCk3lLg==
X-Received: by 2002:a7b:ca54:: with SMTP id m20mr2832398wml.142.1571221004729;
        Wed, 16 Oct 2019 03:16:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d001:591b:c73b:6c41? ([2001:b07:6468:f312:d001:591b:c73b:6c41])
        by smtp.gmail.com with ESMTPSA id u11sm1878652wmd.32.2019.10.16.03.16.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 03:16:44 -0700 (PDT)
Subject: Re: [PATCH v9 09/17] x86/split_lock: Handle #AC exception for split
 lock
To:     Thomas Gleixner <tglx@linutronix.de>
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
        Xiaoyao Li <xiaoyao.li@intel.com>,
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com>
Date:   Wed, 16 Oct 2019 12:16:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1910161142560.2046@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/19 11:47, Thomas Gleixner wrote:
> On Wed, 16 Oct 2019, Paolo Bonzini wrote:
>> Just never advertise split-lock
>> detection to guests.  If the host has enabled split-lock detection,
>> trap #AC and forward it to the host handler---which would disable
>> split lock detection globally and reenter the guest.
> 
> Which completely defeats the purpose.

Yes it does.  But Sean's proposal, as I understand it, leads to the
guest receiving #AC when it wasn't expecting one.  So for an old guest,
as soon as the guest kernel happens to do a split lock, it gets an
unexpected #AC and crashes and burns.  And then, after much googling and
gnashing of teeth, people proceed to disable split lock detection.

(Old guests are the common case: you're a cloud provider and your
customers run old stuff; it's a workstation and you want to play that
game that requires an old version of Windows; etc.).

To save them the googling and gnashing of teeth, I guess we can do a
pr_warn_ratelimited on the first split lock encountered by a guest.  (It
has to be ratelimited because userspace could create an arbitrary amount
of guests to spam the kernel logs).  But the end result is the same,
split lock detection is disabled by the user.

The first alternative I thought of was:

- Remove KVM loading of MSR_TEST_CTRL, i.e. KVM *never* writes the CPU's
  actual MSR_TEST_CTRL.  KVM still emulates MSR_TEST_CTRL so that the
  guest can do WRMSR and handle its own #AC faults, but KVM doesn't
  change the value in hardware.

- trap #AC if the guest encounters a split lock while detection is
  disabled, and then disable split-lock detection in the host.

But I discarded it because it still doesn't do anything for malicious
guests, which can trigger #AC as they prefer.  And it makes things
_worse_ for sane guests, because they think split-lock detection is
enabled but they become vulnerable as soon as there is only one
malicious guest on the same machine.

In all of these cases, the common final result is that split-lock
detection is disabled on the host.  So might as well go with the
simplest one and not pretend to virtualize something that (without core
scheduling) is obviously not virtualizable.

Thanks,

Paolo

> 1) Sane guest
> 
> Guest kernel has #AC handler and you basically prevent it from
> detecting malicious user space and killing it. You also prevent #AC
> detection in the guest kernel which limits debugability.
> 
> 2) Malicious guest
> 
> Trigger #AC to disable the host detection and then carry out the DoS 
> attack.


