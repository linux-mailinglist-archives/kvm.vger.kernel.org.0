Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4729DA918
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 11:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408685AbfJQJsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 05:48:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51910 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404643AbfJQJsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 05:48:52 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3FE6A5946B
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2019 09:48:51 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id 190so872727wme.4
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2019 02:48:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=fulMV+toG6g3eSzWv6dizQDXtOUtM0UaAnY8lyzO4+w=;
        b=sMZsWPckGozGFyMhKPLDh9d5sSgbnbolg8qDbFDj8sPlLrW/Lfc1JO2rs3h5y/Qq5o
         wNa/GRXH7/1TIKZiJ/yEx4+NSSt2gm/MVHRUJoLENhZZUsU6ZqleTqRGyebwBA+0MzeF
         IFpY8bdpG+jWA+D7FDY/uX+U+XsLfiBJ/1BQ4OcJp03AOCTdnAjfYzJtgzhtauN6i36Z
         6BEIkurTPgTo4rY4WxSO1Kh0XGbMNwTRflw0kPvJEQTgye9Zv8HUUYb9e47zqJ6i1nsC
         U7gou+58TMpdEIYpd+Ijt8gzVl/rRtbfFkGiIPs2ZdbOAuBeOFTniodKyfa5TNwoJtmF
         Jaaw==
X-Gm-Message-State: APjAAAUZBs/yeRVPD82CEW6vtx5j4BOyiFQ4EWjG/40UrgUQmRDHDs87
        0ksZbSTeJNx5BBWrthJ+eVxCVMUlPDRQaqJtBbjRUhVsYHePqQDfh4+OUxC/mUxf2+MxAZv90Aj
        TlRbPh/dl5YSx
X-Received: by 2002:a1c:a784:: with SMTP id q126mr1990785wme.59.1571305729874;
        Thu, 17 Oct 2019 02:48:49 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz6+utTLAGkxHY41AD+u4w7d0GVfoTtd9+W82zHGNyobcnEv8oi1KJDn6bNKlNyci+bK9572g==
X-Received: by 2002:a1c:a784:: with SMTP id q126mr1990764wme.59.1571305729627;
        Thu, 17 Oct 2019 02:48:49 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id b62sm2305917wmc.13.2019.10.17.02.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 02:48:49 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     "x86\@kernel.org" <x86@kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mingfangsen <mingfangsen@huawei.com>,
        "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar\@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson\@intel.com" <sean.j.christopherson@intel.com>,
        "wanpengli\@tencent.com" <wanpengli@tencent.com>,
        "jmattson\@google.com" <jmattson@google.com>,
        "joro\@8bytes.org" <joro@8bytes.org>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "mingo\@redhat.com" <mingo@redhat.com>,
        "bp\@alien8.de" <bp@alien8.de>, "hpa\@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: SVM: Fix potential wrong physical id in avic_handle_ldr_update
In-Reply-To: <7db9f15500ab486b897bf1a7fa7e7161@huawei.com>
References: <7db9f15500ab486b897bf1a7fa7e7161@huawei.com>
Date:   Thu, 17 Oct 2019 11:48:48 +0200
Message-ID: <87tv873dof.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
>
>>> Guest physical APIC ID may not equal to vcpu->vcpu_id in some case.
>>> We may set the wrong physical id in avic_handle_ldr_update as we 
>>> always use vcpu->vcpu_id.
>
> Hi, Vitaly, thanks for your reply.
> Do you think there may be a wrong physical id in
> avic_handle_ldr_update too ?

Honestly I'm not sure, however, as we need to put physical id to LDR
we'd rather get it from LAPIC then assume that it's == vcpu_id so I
think your patch makes sense even if it fixes a theoretical issue.

But I may be missing something important about AVIC.

>
>>>
>>> @@ -4591,6 +4591,8 @@ static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
>>>  	int ret = 0;
>>>  	struct vcpu_svm *svm = to_svm(vcpu);
>>>  	u32 ldr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LDR);
>>> +	u32 apic_id_reg = kvm_lapic_get_reg(vcpu->arch.apic, APIC_ID);
>>> +	u32 id = (apic_id_reg >> 24) & 0xff;
>>
>>If we reach here than we're guaranteed to be in xAPIC mode, right? Could you maybe export and use kvm_xapic_id() here then (and in
>>avic_handle_apic_id_update() too)?
>>
>
> I think we're guaranteed to be in xAPIC mode when we reach here. I would have a try to export
> and use use kvm_xapic_id here and in avic_handle_apic_id_update too.
> Thanks for your suggestion.
>
> Have a nice day.
> Best wishes.

-- 
Vitaly
