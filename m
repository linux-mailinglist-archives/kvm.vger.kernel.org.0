Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D994A17405A
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 20:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgB1Tgw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 14:36:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37108 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725769AbgB1Tgv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 14:36:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582918610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y4+Rq4edgfQ2d5X2Wftt+NGWjHUEu6BgwavFrRxlIE8=;
        b=YNxt58cNtZhzwWM9I2gF4crBvKo5LnlyqxaRZ7gCLgZec794GysYowGn0ra14BZJG2W5Zg
        l3wZrPK6ORjr5EsqlT1oYFqXZrbJ8pT3u4k3y+ETmCPNkV6KJhR0ikRHf+KpgM7WhH8OBz
        Ek9i7Hq+kdH/wU6S4OonfViumxCQOG0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-Z8mc1oj2PHeoj1GW0-isdQ-1; Fri, 28 Feb 2020 14:36:48 -0500
X-MC-Unique: Z8mc1oj2PHeoj1GW0-isdQ-1
Received: by mail-wr1-f72.google.com with SMTP id d9so1754919wrv.21
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 11:36:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y4+Rq4edgfQ2d5X2Wftt+NGWjHUEu6BgwavFrRxlIE8=;
        b=cl4nq1zTF03+yNPWHnS4Ut4arKHAEWvNfXUo4LwS3tSinLXg3S8yVLRk68tZXHdq6+
         IwFJwNGwKCW4kowfJ6hYlyvccSJbryft9t7jsk11Mft4Wh43i1tuuL7YZwjTllrkOgM1
         vjVqiLqcIuepqvRh3znWv3RWKftp3goTKvTM/Y2szwyIFeG6KZ6gFG+91ivcvZsS6QpM
         zqugWz0u9YxY+8CmJ71ym7QCXcCYfUyZ2lm0/X91UPL1qN4FQi9sXTx6OBxVrRWrI3SB
         kaeWXiZFVCi4Plhe5toPLRD0mY9xdqZ5DfuxL/DTAk8MaQpWyh6X0yYYpmCppB6eV7ja
         S0SA==
X-Gm-Message-State: APjAAAUxetksNCgqu+0sNJcFonDlQnVIg/lFCMNCG63slIa4ACL8O4p2
        T3OPtFtwZ56YA4KLeNlnviSrBf43JCoKsW4lHnqpfExy56Wq6dg1sd5VIXk4rbCKi5Gpsu9g+3C
        jqBLDctCs7o8W
X-Received: by 2002:adf:8382:: with SMTP id 2mr5831169wre.243.1582918607479;
        Fri, 28 Feb 2020 11:36:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqzrWJVgmWIf4acpom3X1WSOc9ysjhsJ/VBWhpdRxPgKzsFioxUjDl9DbqKKlS51ZSwQhKlPQw==
X-Received: by 2002:adf:8382:: with SMTP id 2mr5831152wre.243.1582918607243;
        Fri, 28 Feb 2020 11:36:47 -0800 (PST)
Received: from [192.168.178.40] ([151.20.130.54])
        by smtp.gmail.com with ESMTPSA id d17sm3309385wmb.36.2020.02.28.11.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 11:36:46 -0800 (PST)
Subject: Re: [PATCH] x86/kvm: Handle async page faults directly through
 do_page_fault()
To:     Andy Lutomirski <luto@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Radim Krcmar <rkrcmar@redhat.com>
References: <6bf68d0facc36553324c38ec798b0feebf6742b7.1582915284.git.luto@kernel.org>
 <c80e3380-d484-1b01-a638-0ee130dea11a@redhat.com>
 <CALCETrUG0B2QLYYp8h+5KiZ4LpVDZ00XEPsgh4DbbDX9Mx5-EQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <162c3f40-e413-767b-0b4d-a32208debc87@redhat.com>
Date:   Fri, 28 Feb 2020 20:36:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CALCETrUG0B2QLYYp8h+5KiZ4LpVDZ00XEPsgh4DbbDX9Mx5-EQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/02/20 20:04, Andy Lutomirski wrote:
>>> +      * We are relying on the interrupted context being sane (valid
>>> +      * RSP, relevant locks not held, etc.), which is fine as long as
>>> +      * the the interrupted context had IF=1.
>> This is not about IF=0/IF=1; the KVM code is careful about taking
>> spinlocks only with IRQs disabled, and async PF is not delivered if the
>> interrupted context had IF=0.  The problem is that the memory location
>> is not reentrant if an NMI is delivered in the wrong window, as you hint
>> below.
>
> If an async PF is delivered with IF=0, then, unless something else
> clever happens to make it safe, we are toast. 

Right, it just cannot happen.  kvm_can_do_async_pf is where KVM decides
whether a page fault must be handled synchronously, and it does this:

bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
{
	...
        /*
         * If interrupts are off we cannot even use an artificial
         * halt state.
         */
        return kvm_x86_ops->interrupt_allowed(vcpu);
}

The same function is called by kvm_arch_can_inject_async_page_present.

Paolo

