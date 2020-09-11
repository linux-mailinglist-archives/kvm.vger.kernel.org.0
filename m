Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95AA26628A
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 17:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgIKPw2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 11:52:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54933 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726531AbgIKPwL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 11:52:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599839507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fCBNxhg4v+PlU/AgCt/3/vpQJvyfun2d3FdEVJq/cDc=;
        b=ML91t1Lnw6979RerElZkiu9Fj4AwsOyfMaSsXmMSzcAGDd05MMgN4+vFzgefhq3Eku3Prr
        acvNeofRzyurK7V1QSAUakvjAMVfBbR0I7jcT20dfE8rla/jjAhFtTep3DEcfFCOVHIu0v
        AsaODXsviu7prqNQklePnjQCkjbm/PQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-evcznX8cOPSFaXlz2vF3tw-1; Fri, 11 Sep 2020 11:51:45 -0400
X-MC-Unique: evcznX8cOPSFaXlz2vF3tw-1
Received: by mail-wm1-f71.google.com with SMTP id m20so770363wmg.6
        for <kvm@vger.kernel.org>; Fri, 11 Sep 2020 08:51:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fCBNxhg4v+PlU/AgCt/3/vpQJvyfun2d3FdEVJq/cDc=;
        b=ahMENzEQKi8dKampUFvfmjFEV/XfAShPqRnWDf+Nti/qRAY+DPMLRloeDo26qZ2hGT
         omzIBXwgApLHsAVoxf6CIN1bihkyPsNE+FJN79IomyWuOtoX8cehMlQmzxQymsyzew/C
         LqzOeq1mvXDllpyheY8omM3l0renxhc3Q1OC4GPbcWTl9n5NQAGehWb7XCDwYnIusQqM
         +NzzESi7HurSz5WexS3W6NmLj7q5LsksjXFGKCXpNPzFpStJPjvc2BkITPHn1Qx/dEyp
         9CxNkjmLXgBxioRH34Udq/bSBXRUSXW5UfKlseTR4u6jNXDX75h6zB6B61ycUU7WELR/
         2koA==
X-Gm-Message-State: AOAM530wJRwnBKVaIFy78ruIl0r82a4LfuqenWnZjg/EutaZta2Au0nr
        43Pw9ro0gpyrh5pXsBBwsiltJskvk6195LavHCi1BTGrs7g9RJTh+I6vBa8krtA9ZnWOAxPc1dF
        DBZcPGNuN7xks
X-Received: by 2002:a1c:5906:: with SMTP id n6mr2979461wmb.160.1599839504397;
        Fri, 11 Sep 2020 08:51:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQCqvimZAE4vluHyVy943ZzCol91kQ2jsAOfVdq1lcxwqpS1hnNIAz54XhxFeFAyaaHXW/AA==
X-Received: by 2002:a1c:5906:: with SMTP id n6mr2979442wmb.160.1599839504147;
        Fri, 11 Sep 2020 08:51:44 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id l126sm5052866wmf.39.2020.09.11.08.51.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 08:51:43 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: nVMX: Update VMCS02 when L2 PAE PDPTE updates
 detected
To:     Peter Shier <pshier@google.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>
References: <20200820230545.2411347-1-pshier@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7c1be323-f7a6-e7da-67e7-942443e57488@redhat.com>
Date:   Fri, 11 Sep 2020 17:51:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200820230545.2411347-1-pshier@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/08/20 01:05, Peter Shier wrote:
> After L1 exits, vmx_vcpu_run calls vmx_register_cache_reset which
> clears VCPU_EXREG_PDPTR in vcpu->arch.regs_dirty.  When L2 next
> resumes, ept_load_pdptrs finds VCPU_EXREG_PDPTR clear in
> vcpu->arch.regs_dirty and does not load VMCS02.GUEST_PDPTRn from
> vcpu->arch.walk_mmu->pdptrs[]. prepare_vmcs02 will then load
> VMCS02.GUEST_PDPTRn from vmcs12->pdptr0/1/2/3 which contain the stale
> values stored at last L2 exit. A repro of this bug showed L2 entering
> triple fault immediately due to the bad VMCS02.GUEST_PDPTRn values.
> 
> When L2 is in PAE paging mode add a call to ept_load_pdptrs before
> leaving L2. This will update VMCS02.GUEST_PDPTRn if they are dirty in
> vcpu->arch.walk_mmu->pdptrs[].

Queued with an improved comment:

 	/*
-	 * Ensure that the VMCS02 PDPTR fields are up-to-date before switching
-	 * to L1.
+	 * VCPU_EXREG_PDPTR will be clobbered in arch/x86/kvm/vmx/vmx.h between
+	 * now and the new vmentry.  Ensure that the VMCS02 PDPTR fields are
+	 * up-to-date before switching to L1.
 	 */

I am currently on leave so I am going through the patches and queuing 
them, but I will only push kvm/next and kvm/queue next week.  kvm/master
patches will be sent to Linus for the next -rc though.

Paolo

