Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 259D7D95DF
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 17:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404538AbfJPPn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 11:43:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44494 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728018AbfJPPn4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 11:43:56 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4511F155E0
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 15:43:55 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id q9so1372495wmj.9
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 08:43:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nhY9YqzszUFd4RrH6E4lGS+ky+sUcMNkuo5x1ttpMi4=;
        b=KWyVazdzOpYPzY4UdWEW6ITiE9EJHXyNKQm4jyjCfcX3Fk5vvrfg9ShkMM4p02CQjU
         pnk1YWFjtiIURndIwFC4/aT4/iQwvemkPhGO2k6NiI5+227bAbHAPn7ZwaONv1F+ZdZ7
         vDsPtHvwYaUKdVObZSS+Zv8EGxqI4vMPZSJF/XNPpZ36x11144BMq9wJDTvjuWq9R1es
         3U4bm1TTBLZ7mUa3eke9Rp2xGIzYdm0GFsUWzPbKfEgeTIrugX0TmAf5J32SLIYiGyk5
         rtQ4S9gIzog8uCb42gu1M2+81Df8DVpeng3+noVG3dLfKjsN8RoMmHwjMz6IKuJPm9l/
         2PWg==
X-Gm-Message-State: APjAAAXMkMojfKeWorFAqDu0WTj/Ve7r4DC6iD+6/iCXM5dDdj5ti1Ov
        m3ksFWTsBcGXgZyIqVd6oQHwxSFTes50ODRuKD8jT33COkEglQf0dF/I9ydbm8hDW2djCo0vbB+
        KmoHVK6LV78UR
X-Received: by 2002:a05:6000:1c7:: with SMTP id t7mr3258864wrx.198.1571240633564;
        Wed, 16 Oct 2019 08:43:53 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx2W8txY71EldDBse2zN1F1PijCT+k7OzSblQA4BTfrwaQ8qF50czeeiiu6UijsFaW+yzCTXA==
X-Received: by 2002:a05:6000:1c7:: with SMTP id t7mr3258837wrx.198.1571240633280;
        Wed, 16 Oct 2019 08:43:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d001:591b:c73b:6c41? ([2001:b07:6468:f312:d001:591b:c73b:6c41])
        by smtp.gmail.com with ESMTPSA id h17sm2447959wmb.33.2019.10.16.08.43.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 08:43:52 -0700 (PDT)
Subject: Re: [PATCH v9 09/17] x86/split_lock: Handle #AC exception for split
 lock
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
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
References: <20190626203637.GC245468@romley-ivt3.sc.intel.com>
 <alpine.DEB.2.21.1906262338220.32342@nanos.tec.linutronix.de>
 <20190925180931.GG31852@linux.intel.com>
 <3ec328dc-2763-9da5-28d6-e28970262c58@redhat.com>
 <alpine.DEB.2.21.1910161142560.2046@nanos.tec.linutronix.de>
 <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com>
 <alpine.DEB.2.21.1910161244060.2046@nanos.tec.linutronix.de>
 <3a12810b-1196-b70a-aa2e-9fe17dc7341a@redhat.com>
 <b2c42a64-eb42-1f18-f609-42eec3faef18@intel.com>
 <d2fc3cbe-1506-94fc-73a4-8ed55dc9337d@redhat.com>
 <20191016154116.GA5866@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d235ed9a-314c-705c-691f-b31f2f8fa4e8@redhat.com>
Date:   Wed, 16 Oct 2019 17:43:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191016154116.GA5866@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/19 17:41, Sean Christopherson wrote:
> On Wed, Oct 16, 2019 at 04:08:14PM +0200, Paolo Bonzini wrote:
>> SIGBUS (actually a new KVM_EXIT_INTERNAL_ERROR result from KVM_RUN is
>> better, but that's the idea) is for when you're debugging guests.
>> Global disable (or alternatively, disable SMT) is for production use.
> 
> Alternatively, for guests without split-lock #AC enabled, what if KVM were
> to emulate the faulting instruction with split-lock detection temporarily
> disabled?

Yes we can get fancy, but remember that KVM is not yet supporting
emulation of locked instructions.  Adding it is possible but shouldn't
be in the critical path for the whole feature.

How would you disable split-lock detection temporarily?  Just tweak
MSR_TEST_CTRL for the time of running the one instruction, and cross
fingers that the sibling doesn't notice?

Thanks,

Paolo

> The emulator can presumably handle all such lock instructions, and an
> unhandled instruction would naturally exit to userspace.
> 
> The latency of VM-Enter+VM-Exit should be enough to guard against DoS from
> a malicious guest.  KVM could also artificially rate-limit a guest that is
> generating copious amounts of split-lock #ACs.
> 

