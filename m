Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9167E127841
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 10:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfLTJeX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 04:34:23 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52605 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727191AbfLTJeW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 04:34:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576834461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MiM/rnqsccdb7wsah7IMUjz0D2mRuAu1TPcc9JoAwGw=;
        b=dqpDhkHOIiReLo0RDWdeujxysiz70FsYMBGhXZww/OVA4f9uuRIJ+BAJw1ltzhX6BPJ1/Q
        J8hdSM43A6WohONOIpfyUE6+KRP0sjBbM18W0A76+JmeMh0j9o3OY4jXPsjAwE5tBOFy3n
        sY/8AnpPQlYGuszEkpmcZFUx05cSnwk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-uLMM0fuqOY2m0Tlggp7olA-1; Fri, 20 Dec 2019 04:34:20 -0500
X-MC-Unique: uLMM0fuqOY2m0Tlggp7olA-1
Received: by mail-wm1-f70.google.com with SMTP id f25so2319062wmb.1
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 01:34:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MiM/rnqsccdb7wsah7IMUjz0D2mRuAu1TPcc9JoAwGw=;
        b=mISAfEKxjld+Y4TUD7JpCz1t8DGVOiATQtymFk6LI3RxD40FrVrjRcOcI+3MP2JNwh
         EeoiV6+Ae1CAH6ztT4/u5m9rPwSFGsYqev8S+VMbIf02fKXQUswLKSJU7IonI7P/e9h4
         IOclCMIZNZAJyhjc65qcby4SThOsJ8cVvrORqfZrm/gY9zw3CcpfMyFoVvniK3aZXn/0
         ZcvT5t7P4D6C+UfdUDcg7LsNMX5rsVpbnxqCDWNb1Dy0Zx5w3N6t3eE9z7e05DVbpJ7C
         2caHa5atkBBzOsXBcRUZdXxfJGU62axnTIl7MfaxXNG1i2eqSGBgHFe2Uxa3/63JKpyz
         q9/g==
X-Gm-Message-State: APjAAAVq5J4CMYQpRDzZmCrdOpQB/mRpLmfeCjdny2Q8fAE6EXf2LJOh
        QtKnojhkL3npQrvpgYzleEqBFE3nzfhL+9fyEkbjrKa+fyT629q9R6w2GZ3QvXD4yZSiYJHdifM
        kHtzKTwIuEFUC
X-Received: by 2002:a1c:9896:: with SMTP id a144mr15196702wme.116.1576834459184;
        Fri, 20 Dec 2019 01:34:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqx3eFo3A16eF3x4YCipYvCobqKZnvjuiCDcPBiVR5qNYxirO8MQqEOsWVBENns40gK4rh1zKg==
X-Received: by 2002:a1c:9896:: with SMTP id a144mr15196678wme.116.1576834458985;
        Fri, 20 Dec 2019 01:34:18 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id o1sm9464559wrn.84.2019.12.20.01.34.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 01:34:18 -0800 (PST)
Subject: Re: Async page fault delivered while irq are disabled?
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
References: <20191219152814.GA24080@lenoir>
 <20191219155745.GA6439@linux.intel.com> <20191219161524.GB24080@lenoir>
 <20191219190028.GB6439@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <925b4dd2-7919-055e-0041-672dad8c082e@redhat.com>
Date:   Fri, 20 Dec 2019 10:34:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191219190028.GB6439@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/12/19 20:00, Sean Christopherson wrote:
>> And one last silly question, what about that line in
>> kvm_arch_can_inject_async_page_present:
>>
>> 	if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED))
>> 		return true;
>>
>> That looks weird, also it shortcuts the irqs_allowed() check.
> 
> I wondered about that code as well :-).  Definitely odd, but it would
> require the guest to disable async #PF after an async #PF is queued.  Best
> guess is the idea is that it's the guest's problem if it disables async #PF
> on the fly.
> 

When the guest disables async #PF all outstanding page faults are
cancelled by kvm_clear_async_pf_completion_queue.  However, in case they
complete while in cancel_work_sync. you need to inject them even if
interrupts are disabled.

Paolo

