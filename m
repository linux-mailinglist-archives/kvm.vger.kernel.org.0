Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0097C27ED47
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 17:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730196AbgI3Pgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 11:36:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31813 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731043AbgI3Pgr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 11:36:47 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601480206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ke6qz/JBwiVN30Q5Ga33Om7udsmaHkiF+HvXUrXkShc=;
        b=Yjm+GPw18DiOpeeHSzkfjd/kX7+WmoMmYWTww/MLLWIsMjN+Sj476KocDMtPnZwHGgc+4a
        KbnNbjam3mlw7igXZuern0bA4KCoMgiNM/fe3s40Blu9Li2gQnsF2IvuwQuZL9CkTs+QDo
        ffFvzslaFkNXpXScnWLF0fx4AHIGB+g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-EWx8ciBvMki92aXVKIBPkw-1; Wed, 30 Sep 2020 11:36:44 -0400
X-MC-Unique: EWx8ciBvMki92aXVKIBPkw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3ED0D1074657;
        Wed, 30 Sep 2020 15:36:43 +0000 (UTC)
Received: from starship (unknown [10.35.206.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D2AD973678;
        Wed, 30 Sep 2020 15:36:39 +0000 (UTC)
Message-ID: <521dd8fe55650eac720891e90084a7f7620c7f0f.camel@redhat.com>
Subject: Re: [PATCH v6 0/4] KVM: nSVM: ondemand nested state allocation
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Date:   Wed, 30 Sep 2020 18:36:38 +0300
In-Reply-To: <20200922211025.175547-1-mlevitsk@redhat.com>
References: <20200922211025.175547-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2020-09-23 at 00:10 +0300, Maxim Levitsky wrote:
> This is the next version of this patch series.
> 
> In V5 I adopted Sean Christopherson's suggestion to make .set_efer return
> a negative error (-ENOMEM in this case) which in most cases in kvm
> propagates to the userspace.
> 
> I noticed though that wrmsr emulation code doesn't do this and instead
> it injects #GP to the guest on _any_ error.
> 
> So I fixed the wrmsr code to behave in a similar way to the rest
> of the kvm code.
> (#GP only on a positive error value, and forward the negative error to
> the userspace)
> 
> I had to adjust one wrmsr handler (xen_hvm_config) to stop it from returning
> negative values	so that new WRMSR emulation behavior doesn't break it.
> This patch was only compile tested.
> 
> The memory allocation failure was tested by always returning -ENOMEM
> from svm_allocate_nested.
> 
> The nested allocation itself was tested by countless attempts to run
> nested guests, do nested migration on both my AMD and Intel machines.
> I wasn't able to break it.
> 
> Changes from V5: addressed Sean Christopherson's review feedback.
> 
> Best regards,
> 	Maxim Levitsky
> 
> Maxim Levitsky (4):
>   KVM: x86: xen_hvm_config: cleanup return values
>   KVM: x86: report negative values from wrmsr emulation to userspace
>   KVM: x86: allow kvm_x86_ops.set_efer to return an error value
>   KVM: nSVM: implement on demand allocation of the nested state
> 
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/emulate.c          |  7 ++--
>  arch/x86/kvm/svm/nested.c       | 42 ++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c          | 58 +++++++++++++++++++--------------
>  arch/x86/kvm/svm/svm.h          |  8 ++++-
>  arch/x86/kvm/vmx/vmx.c          |  6 ++--
>  arch/x86/kvm/x86.c              | 37 ++++++++++++---------
>  7 files changed, 113 insertions(+), 47 deletions(-)
> 
> -- 
> 2.26.2
> 
Very polite ping on this patch series.

Best regards,
	Maxim Levitsky

