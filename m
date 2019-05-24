Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 637D22A010
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 22:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391738AbfEXUsF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 16:48:05 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45751 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389927AbfEXUsE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 16:48:04 -0400
Received: by mail-wr1-f65.google.com with SMTP id b18so11185821wrq.12
        for <kvm@vger.kernel.org>; Fri, 24 May 2019 13:48:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K432UpVxeuDeNqKM2H/vr+JGou/LVzqkzfEUav2ZxbY=;
        b=PWfr3dXKNtsjRt0DlYqxgc72s/IoGxuIzb/9FIYnXhEbks+RyJ+W5m21OugBQRfrOl
         cpqurQHzXFPMKFtrIFeh4ZSaMugMEXGklWaajZu2JcOcz7bhx68uWVNpbBcEfa3Gn1Ct
         P046+8X8Ao8VWrvhxYXblqMwvmWckGp6dPMb4MVcJzBIZd8ePuYPqHIigKGRiUlu8GtF
         pofDS1SCDWikz0WQN3SjhE0aOJMGkOUSgmLkjnTk0a/9oN2WMZPeIelpjBJO6NvNLmey
         aAM0hPqfMrYo2xdsGITnRO8w/9H23ingn7hmYnzKvg7Yl25/KKc233OEYxzzW5Q1G96S
         +Bjg==
X-Gm-Message-State: APjAAAUE9gLmkd8c3mTH5zqvFGaZM8LYY5myO5uJ7PVd5nnhDrOKwA4h
        gXTxo0dA72qYbD30MXhcK95D5A==
X-Google-Smtp-Source: APXvYqySkTKpV4KW9TPC/PzqwiV/fNny9zQZwPsWSoV2uTz4skXdd3+f3NWHuy9KO2kRpMaqwdIXGw==
X-Received: by 2002:a5d:4e46:: with SMTP id r6mr65757839wrt.290.1558730883442;
        Fri, 24 May 2019 13:48:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4d53:18d:3ffd:370? ([2001:b07:6468:f312:4d53:18d:3ffd:370])
        by smtp.gmail.com with ESMTPSA id f2sm4545596wme.12.2019.05.24.13.48.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 13:48:02 -0700 (PDT)
Subject: Re: [PATCH] KVM: lapic: Reuse auto-adjusted timer advance of first
 stable vCPU
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Wanpeng Li <kernellwp@gmail.com>
References: <20190508214702.25317-1-sean.j.christopherson@intel.com>
 <3ea5ae51-89b2-ee0c-d156-88198af90b95@redhat.com>
 <20190524202333.GG365@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <54b65859-44bc-05f6-ef1c-4f6903aa2659@redhat.com>
Date:   Fri, 24 May 2019 22:48:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190524202333.GG365@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/05/19 22:23, Sean Christopherson wrote:
> On Mon, May 20, 2019 at 03:03:10PM +0200, Paolo Bonzini wrote:
>> On 08/05/19 23:47, Sean Christopherson wrote:
>>> +
>>> +		/*
>>> +		 * The first vCPU to get a stable advancement time "wins" and
>>> +		 * sets the advancement time that is used for *new* vCPUS that
>>> +		 * are created with auto-adjusting enabled.
>>> +		 */
>>> +		if (apic->lapic_timer.timer_advance_adjust_done)
>>> +			(void)cmpxchg(&adjusted_timer_advance_ns, -1,
>>> +				      timer_advance_ns);
>>
>> This is relatively expensive, so it should only be done after setting
>> timer_advance_adjust_done to true.
> 
> That's already the case, or am I missing something?
> 
> This code is inside "if (!apic->lapic_timer.timer_advance_adjust_done)",

Right, I missed the outer if from the context.  Sorry for the noise.

Paolo
