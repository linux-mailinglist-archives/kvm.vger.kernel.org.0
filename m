Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CBB254BBF
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 19:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgH0RMk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 13:12:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31714 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727895AbgH0RM0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 13:12:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598548345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KuENNcu03ZYZzJy2Hk5IZPtHrf6j8qPH04KuM2zt3fQ=;
        b=dU3Eimudo5jCy1ZZ0o6Cu8aTXdEDandobFNW6YEkto2/LPgcW3QxhzML75UQ8NbFDRGbJh
        8u0dgUjpM8wG17J8MVZylnv1Ut1c6WZVvsy/Xu/Ufa/pPOMuN0OH7S/z3DcvkVuTX7XEzI
        +24N9Rp6CmhTiIntK1kg6r1AIUFihZU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-6nOjKZdDOG2TUs42Yrymxg-1; Thu, 27 Aug 2020 13:12:21 -0400
X-MC-Unique: 6nOjKZdDOG2TUs42Yrymxg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 057B01029D23;
        Thu, 27 Aug 2020 17:12:20 +0000 (UTC)
Received: from starship (unknown [10.35.206.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 713F35C1DA;
        Thu, 27 Aug 2020 17:12:15 +0000 (UTC)
Message-ID: <a9708f1038dbf921451e9ff00dafecc324c8b736.camel@redhat.com>
Subject: Re: [PATCH 0/8] KVM: nSVM: ondemand nested state allocation + smm
 fixes
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Thu, 27 Aug 2020 20:12:14 +0300
In-Reply-To: <20200827170434.284680-1-mlevitsk@redhat.com>
References: <20200827170434.284680-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-08-27 at 20:04 +0300, Maxim Levitsky wrote:
> This patch series does some refactoring and implements on demand nested state area
> This way at least guests that don't use nesting won't waste memory
> on nested state.
> 
> This patch series is based on patch series '[PATCH 0/3] Few nSVM bugfixes'
> (patch #7 here should have beeing moved there as well to be honest)
> 
> The series was tested with various nested guests, and it seems to work
> as long as I disable the TSC deadline timer (this is unrelated to this
> patch series)
> 
> I addressed the review feedback from V2, and added few refactoring
> patches to this series as suggested.
> 
> Best regards,
>         Maxim Levitsky
> 
> Maxim Levitsky (8):
>   KVM: SVM: rename a variable in the svm_create_vcpu
>   KVM: nSVM: rename nested vmcb to vmcb12
>   KVM: SVM: refactor msr permission bitmap allocation
>   KVM: SVM: use __GFP_ZERO instead of clear_page
>   KVM: SVM: refactor exit labels in svm_create_vcpu
>   KVM: x86: allow kvm_x86_ops.set_efer to return a value
>   KVM: emulator: more strict rsm checks.
>   KVM: nSVM: implement ondemand allocation of the nested state
> 
>  arch/x86/include/asm/kvm_host.h |   2 +-
>  arch/x86/kvm/emulate.c          |  22 ++-
>  arch/x86/kvm/svm/nested.c       | 267 ++++++++++++++++++--------------
>  arch/x86/kvm/svm/svm.c          | 106 +++++++------
>  arch/x86/kvm/svm/svm.h          |  10 +-
>  arch/x86/kvm/vmx/vmx.c          |   9 +-
>  arch/x86/kvm/x86.c              |   3 +-
>  7 files changed, 243 insertions(+), 176 deletions(-)
> 
> -- 
> 2.26.2
> 
Ignore this one, I send this with wrong version.

