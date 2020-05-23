Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4A41DF840
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 18:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgEWQeZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 12:34:25 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24776 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727884AbgEWQeZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 23 May 2020 12:34:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590251663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HuZzbZkGqE+3pTQ3powlX9CzpAalpjRkp2uqWJb6cGs=;
        b=P5J6vwu7hkzDiO79zFbczylt3oVfaKc842wA9Z/YJDndEPgXDw+gaCf/Wd07JHEiVuF80d
        aIKx7kePtPZJfp+Pe3e8lTuTZOO2f8e5mfpLvhRrN8B+jj2Jq9dVQxfv/np7Dtv3hdHUhv
        x5lkpPT8i1xLjFnVLEQX45G4gyPtcf8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108--qLWJ9ikO32D7LcqZqQAgw-1; Sat, 23 May 2020 12:34:21 -0400
X-MC-Unique: -qLWJ9ikO32D7LcqZqQAgw-1
Received: by mail-ej1-f71.google.com with SMTP id t4so3441746ejj.12
        for <kvm@vger.kernel.org>; Sat, 23 May 2020 09:34:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=HuZzbZkGqE+3pTQ3powlX9CzpAalpjRkp2uqWJb6cGs=;
        b=YM2awB0uiCLndU1c6J51jH+dn5fEze7W/lCKAk45Bfb6QlCtIKQtPfVlRwqpomY+69
         o9vxOlWYPt+9L32i2Hw+G0adhzronTNR0LVtq57o8p0bh+vT19V/uNOvaavC12o3N7PZ
         EdGM3SYbH6dRbzPxGLvpNve3UMG0l8TfMGFipbm2lwhDaRsImhtVYULFecHPWWA7LKDU
         v8UJxCwED2zLiI9CqK5HXRyfiEA83Go0qyX03HMvU44JfvL24TS8mN62c0bBFnQUdU/8
         +5wFa7R6b0tNb5WBRyXVXZm0hnhj2plqAw5wscfgMPN6sAJ0J8Hxb0BJrOb/FvE4df/P
         IPPg==
X-Gm-Message-State: AOAM533a3qCdXsP6gYFDszIpLGuh2HES3AXkNmviAPXc1d7sXcDh4PhU
        Vkjou0xTt+Ipj0Swb0IXZfSQbxHK2tcw8dkub3kVDExcX7NBJSKcpDf7j1NLOsY1hJTcIqDCtHY
        OYcfpiX8I8ihH
X-Received: by 2002:a17:906:63c9:: with SMTP id u9mr13178570ejk.487.1590251660270;
        Sat, 23 May 2020 09:34:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7dhtvhIMSi54iwS+CUxrxgAY6k5WRmLc4pl9vgr9H/PwlkHIpt/cYv0rq9eje8EQckB2j8Q==
X-Received: by 2002:a17:906:63c9:: with SMTP id u9mr13178556ejk.487.1590251659992;
        Sat, 23 May 2020 09:34:19 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f5sm11154367edj.1.2020.05.23.09.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 09:34:18 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] KVM: x86: extend struct kvm_vcpu_pv_apf_data with token info
In-Reply-To: <20200521183832.GB46035@redhat.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com> <20200511164752.2158645-3-vkuznets@redhat.com> <20200521183832.GB46035@redhat.com>
Date:   Sat, 23 May 2020 18:34:17 +0200
Message-ID: <87sgfq8vau.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Mon, May 11, 2020 at 06:47:46PM +0200, Vitaly Kuznetsov wrote:
>> Currently, APF mechanism relies on the #PF abuse where the token is being
>> passed through CR2. If we switch to using interrupts to deliver page-ready
>> notifications we need a different way to pass the data. Extent the existing
>> 'struct kvm_vcpu_pv_apf_data' with token information for page-ready
>> notifications.
>> 
>> The newly introduced apf_put_user_ready() temporary puts both reason
>> and token information, this will be changed to put token only when we
>> switch to interrupt based notifications.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/include/uapi/asm/kvm_para.h |  3 ++-
>>  arch/x86/kvm/x86.c                   | 17 +++++++++++++----
>>  2 files changed, 15 insertions(+), 5 deletions(-)
>> 
>> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
>> index 2a8e0b6b9805..e3602a1de136 100644
>> --- a/arch/x86/include/uapi/asm/kvm_para.h
>> +++ b/arch/x86/include/uapi/asm/kvm_para.h
>> @@ -113,7 +113,8 @@ struct kvm_mmu_op_release_pt {
>>  
>>  struct kvm_vcpu_pv_apf_data {
>>  	__u32 reason;
>
> Hi Vitaly,
>
> Given we are redoing it, can we convert "reason" into a flag instead
> and use bit 0 for signalling "page not present" Then rest of the 31
> bits can be used for other purposes. I potentially want to use one bit to
> signal error (if it is known at the time of injecting #PF).

Yes, I think we can do that. The existing KVM_PV_REASON_PAGE_READY and
KVM_PV_REASON_PAGE_NOT_PRESENT are mutually exclusive and can be
converted to flags (we'll only have KVM_PV_REASON_PAGE_NOT_PRESENT in
use when this series is merged).

>
>> -	__u8 pad[60];
>> +	__u32 pageready_token;
>> +	__u8 pad[56];
>
> Given token is 32 bit, for returning error in "page ready" type messages,
> I will probably use padding bytes and create pagready_flag and use one
> of the bits to signal error.

In case we're intended to pass more data in synchronous notifications,
shall we leave some blank space after 'flags' ('reason' previously) and
before 'token'?

-- 
Vitaly

