Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E531DCD43
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 14:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbgEUMvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 08:51:06 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27350 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729054AbgEUMvF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 May 2020 08:51:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590065464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I8r9b3WKmFH8x00N7WEjSsV4mj5QT0SricNOgzeLgeo=;
        b=e8/fgY66vaz+DkaPoKJXi5L5cskbw1K0JVRmOIVZJv8ISLqZIUavn/BMQWnZnsXha4grqf
        xzrG2AKqISWDJrOOLC4TZjAn+dAP9/MTvHXj0kSDcWYLd5FaibZJSvqBPDt47MPt9FtDCi
        votedtwRHNDINzbmtB+MHPvOIwb1UEU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-tS6g-31COVqHvhYFgiKviw-1; Thu, 21 May 2020 08:51:00 -0400
X-MC-Unique: tS6g-31COVqHvhYFgiKviw-1
Received: by mail-ej1-f71.google.com with SMTP id c25so2848935eja.4
        for <kvm@vger.kernel.org>; Thu, 21 May 2020 05:51:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=I8r9b3WKmFH8x00N7WEjSsV4mj5QT0SricNOgzeLgeo=;
        b=OdEHAWhrtFp2M4mFZu/FMSB2Lhmu+rAVIWdmhoezLgRJfIwYhuWYpMtJ2yP/mCAUxZ
         6SL9m4PUn5BOIMEXvCK77JUGcF4GPfVfjnVGDRBiTuyor/Rg4k8/myyFaTyek/ziEYtu
         Pa+xguP5uolVNYPERE7ehem9Ib6RRCz1y92nQ+TzBiB/8ThqgDt/1a5lz1vmN5CndmNN
         CR/p/at/djwSxw1lGIgInXSjFtzw5Ob0ClbF7w1qA98spRAvd5wEe3rGR2RElnnawqo7
         CFcBvFRC/mW5EZyaug4cNin/Y3bJ9Iu5Cim1DWEp6+8Tv5dScXmgxZlz0O/AK6aEz9I7
         P1pA==
X-Gm-Message-State: AOAM532JFhEYld0Dzm729545wUzMYx284VoRrg03h+xkyoOf1+QGswB/
        GB5TcuNtORHD0VM8GC+I5eis8tS+gLshlxPQpB2pb2eRxOqdL0yvpbmui5/rJ9pHFWYAK8oTFQy
        k73JJ0JLAz7QU
X-Received: by 2002:a50:9a86:: with SMTP id p6mr7633387edb.153.1590065459325;
        Thu, 21 May 2020 05:50:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXrIhCP1DTKfr0JnNOc4ivRO8cZw1JfFcEy/90FjXovtXUz6eXY3PV1UDasKGJ7973lC0o3g==
X-Received: by 2002:a50:9a86:: with SMTP id p6mr7633376edb.153.1590065459007;
        Thu, 21 May 2020 05:50:59 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id c15sm4736175ejx.62.2020.05.21.05.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 05:50:58 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     wei.huang2@amd.com, cavery@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 03/22] KVM: SVM: immediately inject INTR vmexit
In-Reply-To: <20200424172416.243870-4-pbonzini@redhat.com>
References: <20200424172416.243870-1-pbonzini@redhat.com> <20200424172416.243870-4-pbonzini@redhat.com>
Date:   Thu, 21 May 2020 14:50:57 +0200
Message-ID: <87blmhsb7y.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> We can immediately leave SVM guest mode in svm_check_nested_events
> now that we have the nested_run_pending mechanism.  This makes
> things easier because we can run the rest of inject_pending_event
> with GIF=0, and KVM will naturally end up requesting the next
> interrupt window.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index e69e60ac1370..266fde240493 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -778,13 +778,13 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
>  
>  static void nested_svm_intr(struct vcpu_svm *svm)
>  {
> +	trace_kvm_nested_intr_vmexit(svm->vmcb->save.rip);
> +
>  	svm->vmcb->control.exit_code   = SVM_EXIT_INTR;
>  	svm->vmcb->control.exit_info_1 = 0;
>  	svm->vmcb->control.exit_info_2 = 0;
>  
> -	/* nested_svm_vmexit this gets called afterwards from handle_exit */
> -	svm->nested.exit_required = true;
> -	trace_kvm_nested_intr_vmexit(svm->vmcb->save.rip);
> +	nested_svm_vmexit(svm);
>  }
>  
>  static bool nested_exit_on_intr(struct vcpu_svm *svm)

Sorry for reporting this late but I just found out that this commit
breaks Hyper-V 2016 on KVM on SVM completely (always hangs on boot). I
haven't investigated it yet (well, this is Windows, you know...) but
what's usually different about Hyper-V is that unlike KVM/Linux it has
handlers for some hardware interrupts in the guest and not in the
hypervisor.

-- 
Vitaly

