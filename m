Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC4D3B2C91
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 12:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhFXKkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 06:40:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60022 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232125AbhFXKkf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 06:40:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624531095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+8zOkEqDmKxv2wc98jEmrwn1/qGX8Rt7M/G4D1QmCCQ=;
        b=Li1ctAfTKPjmx28/2Au4q7t43mI/lOhwDX+pOY3pNG/mQZdQgc6OVcJuGvCUYR1han4VxK
        wu24rs2HqEykUxa/AoHV6ZLd+mAPmB0vdlDz96GUzKOeltUbnYlDRlTrg2bKaLG0sF8cQx
        93w21diNAGcQFD4OHArCVqnXyCrWGys=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-xnNjForQOWayEk7zUXCXXg-1; Thu, 24 Jun 2021 06:38:14 -0400
X-MC-Unique: xnNjForQOWayEk7zUXCXXg-1
Received: by mail-ed1-f72.google.com with SMTP id t11-20020a056402524bb029038ffacf1cafso3111676edd.5
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 03:38:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+8zOkEqDmKxv2wc98jEmrwn1/qGX8Rt7M/G4D1QmCCQ=;
        b=bC5EyRJ/OWa931VZ/XrunfIXKlxDxxfMzjxQivjZKKglAGaXCXdQqP4XAjAa7tQog2
         qgWu8DV4V/R2cFl60b3H7q4x/Y2rk1puL/LPT3xpPCUehBwOBstNCbQm1axFVde9cqkr
         85Kh2/iVX8iewyee3aBQMo8z3jn/2ZfZQdJDbgGgv6n75INZEKMqcf2jIDBCiYdAudMm
         sIYqewYxwN7LP4Jso7Yz3i1jURVKAQA11ZPyq6l26am+Z/DnTmieKj50PxdOBuuFVeRE
         YM4d1SuPayQGn1hWR6g25KmyYA9tyZ6lTRoavxjDf+w2fkMmKvYhcjURbD8W5XCwDTiA
         z53w==
X-Gm-Message-State: AOAM533YzyncJxlyxWSm2/+gXz5olyNr6mFbtblgbhrs2LsD2u9fULs+
        V6vC1242+BVuXUjt+F3Gx/4nHEIvhszCU5OXnBvgdxW34TbaVdXLBXlw0X7oioZH0npf3VnVAA7
        xi8IfYZ3JlWX4
X-Received: by 2002:a05:6402:1d08:: with SMTP id dg8mr6303341edb.299.1624531093045;
        Thu, 24 Jun 2021 03:38:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwI+JaqzEU3/RzVF63EQukSLbrjwL8GzIunmYBe8RjRpEpadfN+nfLVG7sxB/MR0xBEwblQQg==
X-Received: by 2002:a05:6402:1d08:: with SMTP id dg8mr6303320edb.299.1624531092822;
        Thu, 24 Jun 2021 03:38:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l22sm1595366edr.15.2021.06.24.03.38.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 03:38:12 -0700 (PDT)
Subject: Re: [PATCH RFC] KVM: nSVM: Fix L1 state corruption upon return from
 SMM
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Cathy Avery <cavery@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
References: <20210623074427.152266-1-vkuznets@redhat.com>
 <a3918bfa-7b4f-c31a-448a-aa22a44d4dfd@redhat.com>
 <53a9f893cb895f4b52e16c374cbe988607925cdf.camel@redhat.com>
 <ac98150acd77f4c09167bc1bb1c552db68925cf2.camel@redhat.com>
 <87pmwc4sh4.fsf@vitty.brq.redhat.com>
 <5fc502b70a89e18034716166abc65caec192c19b.camel@redhat.com>
 <YNNc9lKIzM6wlDNf@google.com> <YNNfnLsc+3qMsdlN@google.com>
 <82327cd1-92ca-9f6b-3af0-8215e9d21eae@redhat.com>
 <83affeedb9a3d091bece8f5fdd5373342298dcd3.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a8945898-9fcb-19f1-1ba1-c9be55e04580@redhat.com>
Date:   Thu, 24 Jun 2021 12:38:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <83affeedb9a3d091bece8f5fdd5373342298dcd3.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/21 10:20, Maxim Levitsky wrote:
> Something else to note, just for our information is that KVM
> these days does vmsave/vmload to VM_HSAVE_PA to store/restore
> the additional host state, something that is frowned upon in the spec,
> but there is some justification of doing this in the commit message,
> citing an old spec which allowed this.

True that.  And there is no mention in the specification for VMRUN that 
the host state-save area is a subset of the VMCB format (i.e., that it 
uses VMCB offsets for whatever subset of the state it saves in the 
VMCB), so the spec reference in the commit message is incorrect.  It 
would be nice if the spec guaranteed that.  Michael, Tom?

In fact, Vitaly's patch *will* overwrite the vmsave/vmload parts of 
VM_HSAVE_PA, and it will store the L2 values rather than the L1 values, 
because KVM always does its vmload/vmrun/vmsave sequence using 
vmload(vmcs01) and vmsave(vmcs01)!  So that has to be changed to use 
code similar to svm_set_nested_state (which can be moved to a separate 
function and reused):

         dest->es = src->es;
         dest->cs = src->cs;
         dest->ss = src->ss;
         dest->ds = src->ds;
         dest->gdtr = src->gdtr;
         dest->idtr = src->idtr;
         dest->rflags = src->rflags | X86_EFLAGS_FIXED;
         dest->efer = src->efer;
         dest->cr0 = src->cr0;
         dest->cr3 = src->cr3;
         dest->cr4 = src->cr4;
         dest->rax = src->rax;
         dest->rsp = src->rsp;
         dest->rip = src->rip;
         dest->cpl = 0;


Paolo

