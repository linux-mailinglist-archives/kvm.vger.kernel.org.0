Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFEEE24D11C
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 11:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgHUJFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 05:05:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54456 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725855AbgHUJFa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 05:05:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598000729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a2gI9Nvwoet4V714YdL5zCr/MsTRTl+MoaZaV7VgHD8=;
        b=JOi1CDS9CY8VAci2TMLmtUyWLaaPZIkpz9cT1yT78BdjoynH+WhfTmZQGPac3RgJbmVnGS
        z0jLY0upRatcUtUWDD24IQeWM1nK/19+MxuCiLdQxIRopKxXYYpUQz2Rawnrl3Ub1JdGoJ
        7DzZ+oCOS5wxnTZOqBHaGT83cVYkfhI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-jl2mGst2N6aQZol7K-rsPQ-1; Fri, 21 Aug 2020 05:05:27 -0400
X-MC-Unique: jl2mGst2N6aQZol7K-rsPQ-1
Received: by mail-wr1-f72.google.com with SMTP id g3so218160wrx.1
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 02:05:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a2gI9Nvwoet4V714YdL5zCr/MsTRTl+MoaZaV7VgHD8=;
        b=V8tz4T8PvgSXAIuyR1OX5eTHHpy6EIzYoMq2LSpUI9OaqF7k5/uE7GkYBpTWv06aLY
         uemi/gD37DO5uOb3eZnDvh10MT31OpItMOsw6Hk5LwqIQqFOzcTS0FnkeoUQbmq1TMcB
         G1f8ktWLjNNWpJvC42R/+OICqbwvbFzLbMJ/6MhLDzF3mpGkxQ3ewACPP/UTYsEdOmmS
         oLHrOHJmZMKxwxjJrUAX5j5pLhijSEq3PYRwYDh1jHvLmLx7cJlDs06iMBD1sORjf7jA
         7YAUv4hst9iQ1v8ni3MvTXHSJv7cP5ypeYmoTo3BUeSWwLflF52AOzXp82vuZWFcus+G
         kPpA==
X-Gm-Message-State: AOAM530z5wNomeEOGC5aykbZLLIB6nUpIZsKcEnyKB2lNvYfgOHFQKen
        aLQarbOW5ViiXmEgZSS9sASOFQhfrIaTWiG807jKcPDl2gfEnyGZb7CWevuijIUTtmOOkQns73t
        MaQ3jI6S7w487
X-Received: by 2002:adf:e550:: with SMTP id z16mr1804416wrm.329.1598000726213;
        Fri, 21 Aug 2020 02:05:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtSmPRNO2v5XZHoE+3AgJHTVtEt5bRlbkV6IO+RvvNhGsNxv9/jNAWd+Cs2dM5XrePLC4Q+A==
X-Received: by 2002:adf:e550:: with SMTP id z16mr1804395wrm.329.1598000725944;
        Fri, 21 Aug 2020 02:05:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1cc0:4e4e:f1a9:1745? ([2001:b07:6468:f312:1cc0:4e4e:f1a9:1745])
        by smtp.gmail.com with ESMTPSA id d7sm3123948wra.29.2020.08.21.02.05.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2020 02:05:25 -0700 (PDT)
Subject: Re: [PATCH] x86/entry/64: Disallow RDPID in paranoid entry if KVM is
 enabled
To:     Borislav Petkov <bp@alien8.de>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@intel.com>,
        Chang Seok Bae <chang.seok.bae@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20200821025050.32573-1-sean.j.christopherson@intel.com>
 <20200821074743.GB12181@zn.tnic>
 <3eb94913-662d-5423-21b1-eaf75635142a@redhat.com>
 <20200821081633.GD12181@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3b4ba9e9-dbf6-a094-0684-e68248050758@redhat.com>
Date:   Fri, 21 Aug 2020 11:05:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200821081633.GD12181@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/08/20 10:16, Borislav Petkov wrote:
> On Fri, Aug 21, 2020 at 10:09:01AM +0200, Paolo Bonzini wrote:
>> One more MSR *is* a big deal: KVM's vmentry+vmexit cost is around 1000
>> cycles, adding 100 clock cycles for 2 WRMSRs is a 10% increase.
> 
> The kernel uses TSC_AUX so we can't reserve it to KVM either.

KVM only uses TSC_AUX while in kernel space, because the kernel hadn't
used it until now.  That's for a good reason:

* if possible, __this_cpu_read(cpu_number) is always faster.

* The kernel can just block preemption at its will and has no need for
the atomic rdtsc+vgetcpu provided by RDTSCP.

So far, the kernel had always used LSL instead of RDPID when
__this_cpu_read was not available.  In one place, RDTSCP is used as an
ordered rdtsc but it discards the TSC_AUX value.  RDPID is also used in
the vDSO but it isn't kernel space.

Hence the assumption that KVM makes (and has made ever since TSC_AUX was
introduced.  What is the difference in speed between LSL and RDPID?  I
don't have a machine that has RDPID to test it, unfortunately.

Paolo

