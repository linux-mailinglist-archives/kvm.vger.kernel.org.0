Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706CA12932D
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 09:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfLWIiT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 03:38:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28172 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725880AbfLWIiS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Dec 2019 03:38:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577090297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XnOi8KdkPNeH7kxyMasf9MX3PhEHIiVQI77jSjBPQtM=;
        b=NML8/2b0I6/0fb0zCEYXy6L/5FYd/ngtFGbjAU5YLWCVE70jh7sSIf6i0jrsLaNEhdgqkJ
        HsiZeb5mcwL07GINmryCqxkD3Qqxi9ig0uugvNWWTjOsGMI2r9nBfWHGW8oPDXXqBhntiI
        Ix3I10z4GTKP30xsvSdwzZhg3shYbuY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-xWX57NFKNbOWiQCBMboCnw-1; Mon, 23 Dec 2019 03:38:15 -0500
X-MC-Unique: xWX57NFKNbOWiQCBMboCnw-1
Received: by mail-wr1-f72.google.com with SMTP id f10so6777091wro.14
        for <kvm@vger.kernel.org>; Mon, 23 Dec 2019 00:38:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XnOi8KdkPNeH7kxyMasf9MX3PhEHIiVQI77jSjBPQtM=;
        b=QkCLdvrU1h8p7UcxRLQhsgIDIEpas9FrHbfbKIkaBxgM0iBmxVkXN/k41JLgUHIo39
         Q7DI7Y3aQiMg1LAUZgSaFv89kbPSeKrsXznbrcZ9Ej/rvJwFioUa6bxm+2s8rsvAZrx5
         DfFqdR0W62/dBwMJl/94MvIJDnJ3/f8TF0CjpiYbStnQkJ45jOqWQz6YAlUiWaUiiDxI
         v00+XT+GRvq3Wfqegb1bXFIhxtZN2D5bEqs61skJ7NXANB8KF/R4ZaeQnexuYeClSfl8
         uB7cNLRXM/o/PLnG5QTx2C+sjvTT5txgv98tly6r+8A6X0+Rx/WEl5+X4LVuBdJuLec4
         4q6g==
X-Gm-Message-State: APjAAAXPadbdXqawBZHOlZNt/AszLBLT5mMcRp0EjSV0p+gF0QBLYE4D
        +jeyR34rPC+RGAEjPTF9zLs8ppbtTWiCcusLpeQnIvo2VPkTH9xX2bf9I59QponjMM0Ut/hKGl2
        UMI8ejLbU5VOM
X-Received: by 2002:a7b:cfc9:: with SMTP id f9mr31219793wmm.1.1577090294328;
        Mon, 23 Dec 2019 00:38:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqx9nTUL9FbeLW2fHuSyBjmm0kJnIZOEmeByEWXSXIYjjjZ6G4Cs87Mxtk6ksMkmTIDSoAWPNQ==
X-Received: by 2002:a7b:cfc9:: with SMTP id f9mr31219765wmm.1.1577090294080;
        Mon, 23 Dec 2019 00:38:14 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:ac09:bce1:1c26:264c? ([2001:b07:6468:f312:ac09:bce1:1c26:264c])
        by smtp.gmail.com with ESMTPSA id z187sm19162109wme.16.2019.12.23.00.38.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Dec 2019 00:38:13 -0800 (PST)
Subject: Re: Async page fault delivered while irq are disabled?
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
References: <20191219152814.GA24080@lenoir>
 <20191219155745.GA6439@linux.intel.com> <20191219161524.GB24080@lenoir>
 <20191219190028.GB6439@linux.intel.com>
 <925b4dd2-7919-055e-0041-672dad8c082e@redhat.com>
 <20191223021745.GA21615@lenoir>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9bfb0925-a571-d51d-367d-3dc2cf74fc8c@redhat.com>
Date:   Mon, 23 Dec 2019 09:38:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191223021745.GA21615@lenoir>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/12/19 03:17, Frederic Weisbecker wrote:
> On Fri, Dec 20, 2019 at 10:34:20AM +0100, Paolo Bonzini wrote:
>> On 19/12/19 20:00, Sean Christopherson wrote:
>>>> And one last silly question, what about that line in
>>>> kvm_arch_can_inject_async_page_present:
>>>>
>>>> 	if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED))
>>>> 		return true;
>>>>
>>>> That looks weird, also it shortcuts the irqs_allowed() check.
>>>
>>> I wondered about that code as well :-).  Definitely odd, but it would
>>> require the guest to disable async #PF after an async #PF is queued.  Best
>>> guess is the idea is that it's the guest's problem if it disables async #PF
>>> on the fly.
>>>
>>
>> When the guest disables async #PF all outstanding page faults are
>> cancelled by kvm_clear_async_pf_completion_queue.  However, in case they
>> complete while in cancel_work_sync. you need to inject them even if
>> interrupts are disabled.
> 
> Hmm, shouldn't the guest wait for the whole pending waitqueue in kvm_async_pf_task_wait()
> to be serviced and woken up before actually allowing to disable async #PF ?
> Because you can't really afford to inject those #PF while IRQs are disabled,
> that's a big rq deadlock risk.

That's just how Linux works, and Linux doesn't ever disable async page
faults with disabled IRQ (reboot_notifier_list is a blocking notifier).

Paolo

