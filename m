Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589EE37A6CC
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 14:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbhEKMf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 08:35:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40542 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230475AbhEKMfx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 08:35:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620736485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2QPkbbSWG9Bctna+DKSZ7C9IAc+76gV5dRWVuVO49Zw=;
        b=bSxXhSwd0IwJ8cLn5jFduOeN4+4V8b/WRJIldKxNewiT58etnN5ZPGtoPbaM7NPMkdxODW
        21EZnqGelAIdWiPhLuPWCATMQgL/ybOUeJCm+HBAK0bxUgjuswLy0C+fGfh2DI2wqj0KaF
        aW+CF5zkzO8ygXYpLOr6QDB+2zfQqSM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-K4tGLFgBMwSuO3t-yg36EA-1; Tue, 11 May 2021 08:34:43 -0400
X-MC-Unique: K4tGLFgBMwSuO3t-yg36EA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A299B803620;
        Tue, 11 May 2021 12:34:42 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B122D5D6D1;
        Tue, 11 May 2021 12:34:39 +0000 (UTC)
Message-ID: <fe160df2233486073031ea0ffbde20a7d16f9601.camel@redhat.com>
Subject: Re: [PATCH 14/15] KVM: x86: Tie Intel and AMD behavior for
 MSR_TSC_AUX to guest CPU model
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Date:   Tue, 11 May 2021 15:34:38 +0300
In-Reply-To: <CALMp9eSzy6gEvZe2s-MGe3cM047iKNoGidHDkm63=01sfgSyjg@mail.gmail.com>
References: <20210504171734.1434054-1-seanjc@google.com>
         <20210504171734.1434054-15-seanjc@google.com>
         <7e75b44c0477a7fb87f83962e4ea2ed7337c37e5.camel@redhat.com>
         <YJlkT0kJ241gYgVw@google.com>
         <CALMp9eSzy6gEvZe2s-MGe3cM047iKNoGidHDkm63=01sfgSyjg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-05-10 at 10:11 -0700, Jim Mattson wrote:
> On Mon, May 10, 2021 at 9:50 AM Sean Christopherson <seanjc@google.com> wrote:
> > On Mon, May 10, 2021, Maxim Levitsky wrote:
> > > On Tue, 2021-05-04 at 10:17 -0700, Sean Christopherson wrote:
> > > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > > index de921935e8de..6c7c6a303cc5 100644
> > > > --- a/arch/x86/kvm/svm/svm.c
> > > > +++ b/arch/x86/kvm/svm/svm.c
> > > > @@ -2663,12 +2663,6 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> > > >                     msr_info->data |= (u64)svm->sysenter_esp_hi << 32;
> > > >             break;
> > > >     case MSR_TSC_AUX:
> > > > -           if (tsc_aux_uret_slot < 0)
> > > > -                   return 1;
> > > > -           if (!msr_info->host_initiated &&
> > > Not related to this patch, but I do wonder why do we need
> > > to always allow writing this msr if done by the host,
> > > since if neither RDTSPC nor RDPID are supported, the guest
> > > won't be able to read this msr at all.
> > 
> > It's an ordering thing and not specific to MSR_TSC_AUX.  Exempting host userspace
> > from guest CPUID checks allows userspace to set MSR state, e.g. during migration,
> > before setting the guest CPUID model.
> 
> I thought the rule was that if an MSR was enumerated by
> KVM_GET_MSR_INDEX_LIST, then KVM had to accept legal writes from the
> host. The only "ordering thing" is that KVM_GET_MSR_INDEX_LIST is a
> device ioctl, so it can't take guest CPUID information into account.

This makes sense.

Thanks!
Best regards,
	Maxim Levitsky
> 
> > > > -               !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
> > > > -               !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
> > > > -                   return 1;
> > > >             msr_info->data = svm->tsc_aux;
> > > >             break;
> > > >     /*


