Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09CFB37A6C3
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 14:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhEKMfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 08:35:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45136 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230436AbhEKMfO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 08:35:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620736447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KAZa5nsMm2MKbyX2g6hfUlqMSl1TOoy9/BgiaTHbg7U=;
        b=E6F9sozczLdiPQkLkAlVIOb74nRXEQyKqp3O7QIcoLP+ccs4w1CN66hcTXaJn8F/tbWu02
        GawZAq11rRakS1RZeNpPBX+vGy9nmeMRnZR0PqD9oUApUIN71fJ4PJ5lcSbK3HEfzA4Vr9
        H0uYh0gtVZirvFzodR2PId+4JtqPDrg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-r22KY4uyNwW44ttCNyCbiQ-1; Tue, 11 May 2021 08:34:06 -0400
X-MC-Unique: r22KY4uyNwW44ttCNyCbiQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2F4BCC626;
        Tue, 11 May 2021 12:34:04 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7F5319C44;
        Tue, 11 May 2021 12:34:01 +0000 (UTC)
Message-ID: <93105f38e3668d2da633599b14922a02dabe1b33.camel@redhat.com>
Subject: Re: [PATCH 03/15] KVM: SVM: Inject #UD on RDTSCP when it should be
 disabled in the guest
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Date:   Tue, 11 May 2021 15:34:00 +0300
In-Reply-To: <YJlluzMze2IfUM6S@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
         <20210504171734.1434054-4-seanjc@google.com>
         <CALMp9eSvXRJm-KxCGKOkgPO=4wJPBi5wDFLbCCX91UtvGJ1qBg@mail.gmail.com>
         <YJHCadSIQ/cK/RAw@google.com>
         <1b50b090-2d6d-e13d-9532-e7195ebffe14@redhat.com>
         <CALMp9eSSiPVWDf43Zed3+ukUc+NwMP8z7feoxX0eMmimvrznzA@mail.gmail.com>
         <4a4b9fea4937da7b0b42e6f3179566d73bf022e2.camel@redhat.com>
         <YJlluzMze2IfUM6S@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-05-10 at 16:56 +0000, Sean Christopherson wrote:
> On Mon, May 10, 2021, Maxim Levitsky wrote:
> > On Tue, 2021-05-04 at 14:58 -0700, Jim Mattson wrote:
> > > On Tue, May 4, 2021 at 2:57 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > > > On 04/05/21 23:53, Sean Christopherson wrote:
> > > > > > Does the right thing happen here if the vCPU is in guest mode when
> > > > > > userspace decides to toggle the CPUID.80000001H:EDX.RDTSCP bit on or
> > > > > > off?
> > > > > I hate our terminology.  By "guest mode", do you mean running the vCPU, or do
> > > > > you specifically mean running in L2?
> > > > > 
> > > > 
> > > > Guest mode should mean L2.
> > > > 
> > > > (I wonder if we should have a capability that says "KVM_SET_CPUID2 can
> > > > only be called prior to KVM_RUN").
> > > 
> > > It would certainly make it easier to reason about potential security issues.
> > > 
> > I vote too for this.
> 
> Alternatively, what about adding KVM_VCPU_RESET to let userspace explicitly
> pull RESET#, and defining that ioctl() to freeze the vCPU model?  I.e. after
> userspace resets the vCPU, KVM_SET_CPUID (and any other relevant ioctls() is
> disallowed.

I vote even stronger for this!

I recently created what Paulo called an 'evil' test to stress KVM related
bugs in nested migration by simulating a nested migration with a vCPU reset,
followed by reload of all of its state including nested state.

It is ugly since as you say I have to  manually load the reset state, and thus 
using 'KVM_VCPU_RESET' ioctl instead would make this test much more 
cleaner and even more 'evil'.

Best regards,
	Maxim Levitsky


> 
> Lack of proper RESET emulation is annoying, e.g. userspace has to manually stuff
> EDX after vCPU creation to get the right value at RESET.  A dedicated ioctl()
> would kill two birds with one stone, without having to add yet another "2"
> ioctl().
> 


