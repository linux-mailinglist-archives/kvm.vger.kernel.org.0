Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5875847E8E8
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 22:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350315AbhLWVHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 16:07:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46052 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245175AbhLWVHg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Dec 2021 16:07:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640293655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ejQpLUiC2+kMvw4pckDBYYMl1MqzJ9ugY4L5uNnu4+8=;
        b=fTA8eOjZS92N2qGX5FnDsd7HVbSmunGWFOX1UzkecuzFuAsPZYF2k2p41wklFV7S9ErKi3
        kdx3ZtFaUx6FeaPCO3ZfYy0YrmSX2y/iiGfcZd1n1NpfHa7HrYGjUaRxkNEBv/LD3nql1l
        Y/5LAQw+WGJNjpyraujzChqTXaG9omc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-466-fPEmDaHQOd2UJnCH7XYsuA-1; Thu, 23 Dec 2021 16:07:34 -0500
X-MC-Unique: fPEmDaHQOd2UJnCH7XYsuA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AEA0218460E8
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 21:07:33 +0000 (UTC)
Received: from starship (unknown [10.40.193.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7AFB9FD37;
        Thu, 23 Dec 2021 21:07:32 +0000 (UTC)
Message-ID: <9035a0f2ad6084f8e7820f8efe8152163ea4049a.camel@redhat.com>
Subject: Re: [PATCH kvm-unit-tests] vmx: separate VPID tests
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Date:   Thu, 23 Dec 2021 23:07:31 +0200
In-Reply-To: <20211223175658.708793-1-pbonzini@redhat.com>
References: <20211223175658.708793-1-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-12-23 at 12:56 -0500, Paolo Bonzini wrote:
> The VPID tests take quite a long time (about 12 minutes overall), so
> separate them from vmx_pf_exception_test and do not run vmx_pf_invvpid_test
> twice.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  x86/unittests.cfg | 25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index f0727f1..5367013 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -293,7 +293,7 @@ arch = i386
>  
>  [vmx]
>  file = vmx.flat
> -extra_params = -cpu max,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test -apic_reg_virt_test -virt_x2apic_mode_test -vmx_pf_exception_test -vmx_pf_no_vpid_test -vmx_pf_vpid_test"
> +extra_params = -cpu max,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test -apic_reg_virt_test -virt_x2apic_mode_test -vmx_pf_exception_test -vmx_pf_no_vpid_test -vmx_pf_invvpid_test -vmx_pf_vpid_test"
>  arch = x86_64
>  groups = vmx
>  
> @@ -362,10 +362,31 @@ groups = vmx
>  
>  [vmx_pf_exception_test]
>  file = vmx.flat
> -extra_params = -cpu max,+vmx -append "vmx_pf_exception_test vmx_pf_no_vpid_test vmx_pf_vpid_test vmx_pf_invvpid_test"
> +extra_params = -cpu max,+vmx -append "vmx_pf_exception_test"
>  arch = x86_64
>  groups = vmx nested_exception
>  
> +[vmx_pf_vpid_test]
> +file = vmx.flat
> +extra_params = -cpu max,+vmx -append "vmx_pf_vpid_test"
> +arch = x86_64
> +groups = vmx nested_exception
> +timeout = 240
> +
> +[vmx_pf_invvpid_test]
> +file = vmx.flat
> +extra_params = -cpu max,+vmx -append "vmx_pf_invvpid_test"
> +arch = x86_64
> +groups = vmx nested_exception
> +timeout = 240
> +
> +[vmx_pf_no_vpid_test]
> +file = vmx.flat
> +extra_params = -cpu max,+vmx -append "vmx_pf_no_vpid_test"
> +arch = x86_64
> +groups = vmx nested_exception
> +timeout = 240
> +
>  [vmx_pf_exception_test_reduced_maxphyaddr]
>  file = vmx.flat
>  extra_params = -cpu IvyBridge,phys-bits=36,host-phys-bits=off,+vmx -append "vmx_pf_exception_test vmx_pf_no_vpid_test vmx_pf_vpid_test vmx_pf_invvpid_test"
I suffered from this exact problem today, so thanks a lot!

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

