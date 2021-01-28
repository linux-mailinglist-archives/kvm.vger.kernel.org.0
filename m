Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E39AA3079B8
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 16:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhA1P2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 10:28:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22116 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231724AbhA1P2R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 10:28:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611847608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nXaMC39tKd/urwVqL22Zi0tZ8ddl8Mjq4+J5FN/+Y1c=;
        b=G/ISZsm6dCzih/xVsw4u+EQ/WT97By2zw8h0i6tW+QEBIPzSmzSkDWDr8PuFBHyhLrbk5B
        pRXH+nsv1+QJEgjHIH2j7lC47BP9AELYjGsvs/PPPZ/HuF6LLXpZMRStYjuQGFO6+YZuKP
        wnQ0HkepQVSA+9/C6gWUm3fkUsuKnoU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-5a2NZPTRMACXRaq6RBVLgg-1; Thu, 28 Jan 2021 10:26:47 -0500
X-MC-Unique: 5a2NZPTRMACXRaq6RBVLgg-1
Received: by mail-ej1-f71.google.com with SMTP id k3so2324424ejr.16
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 07:26:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=nXaMC39tKd/urwVqL22Zi0tZ8ddl8Mjq4+J5FN/+Y1c=;
        b=Y2MHRWvfwlJAzaIovEl+WV+c/Z1qrT9YSn5SWH4Bt9YO3TGjAMuc5PK7NfN+V0Iy9p
         g3aHH1lFwGE+9UOD+FATA3iC34gMzoKmNmGJXb6olrwdzGZHpvFRH7ys4sQ5pMegGIZV
         4n/Flnh0zMxvsmp/1CUbbxNDu5mheprx6z4GUpKkk3/bKlMfxqH8t29xzbPc0wf1mWIy
         W7POHGY/4wf0vjM45wyB37g+HCWuguYJ0teoRDgL30yjbJayzTRJ4PzLhDlobIpK7HW0
         CvyxMFcqDBt6VB7qEG52IXmkP4Qu0LadURpKUkuRkVTi7fxX9K2TXAjKt5ME74b+ifbE
         1k/Q==
X-Gm-Message-State: AOAM532OnHx+YVvh7z3D4lTg1TmHY3+VfPgLfjESb8Ef66ItHZtqx5on
        GYUJpmwcQmGJJrGeuINfXfv57YLeN96ZzYfqPoiyu6dfh2yOLAM0oSxjdNr+iDj7gTrwAGg0ct5
        lx8R+n/ZIVRzn
X-Received: by 2002:aa7:d40f:: with SMTP id z15mr35258edq.276.1611847605670;
        Thu, 28 Jan 2021 07:26:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzqtL9wY+u5eGyYkm/8areIm13hXdWFN9t1U3YVLRKBXghhqZks2b65iR4S7H4XI/SuwerMjw==
X-Received: by 2002:aa7:d40f:: with SMTP id z15mr35238edq.276.1611847605539;
        Thu, 28 Jan 2021 07:26:45 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id k21sm3177754edq.60.2021.01.28.07.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 07:26:44 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH 1/5] KVM: Make the maximum number of user memslots a
 per-VM thing
In-Reply-To: <34f76035-8749-e06b-2fb0-f30e295f6425@redhat.com>
References: <20210127175731.2020089-1-vkuznets@redhat.com>
 <20210127175731.2020089-2-vkuznets@redhat.com>
 <09f96415-b32d-1073-0b4f-9c6e30d23b3a@oracle.com>
 <877dnx30vv.fsf@vitty.brq.redhat.com>
 <5b6ac6b4-3cc8-2dc3-cd8c-a4e322379409@oracle.com>
 <34f76035-8749-e06b-2fb0-f30e295f6425@redhat.com>
Date:   Thu, 28 Jan 2021 16:26:44 +0100
Message-ID: <87v9bh13rf.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 28/01/21 11:48, Maciej S. Szmigiero wrote:
>>>
>>> VMMs (especially big ones like QEMU) are complex and e.g. each driver
>>> can cause memory regions (-> memslots in KVM) to change. With this
>>> feature it becomes possible to set a limit upfront (based on VM
>>> configuration) so it'll be more obvious when it's hit.
>>>
>> 
>> I see: it's a kind of a "big switch", so every VMM doesn't have to be
>> modified or audited.
>> Thanks for the explanation.
>
> Not really, it's the opposite: the VMM needs to opt into a smaller 
> number of memslots.
>
> I don't know... I understand it would be defense in depth, however 
> between dynamic allocation of memslots arrays and GFP_KERNEL_ACCOUNT, it 
> seems to be a bit of a solution in search of a problem.  For now I 
> applied patches 1-2-5.

An alternative with a new module parameter was also suggested, that
would make it possible to protect against buggy/malicious VMMs but
again, the attack is not any different from just creating many
VMs. Module parameter will most like end up being unused 99,9% of the
time (if not 100). I don't seem to have a strong opinion.

-- 
Vitaly

