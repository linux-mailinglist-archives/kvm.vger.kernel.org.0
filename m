Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F637369084
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 12:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242029AbhDWKq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 06:46:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31630 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241954AbhDWKq2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 06:46:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619174751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6QtPk8mqfGCCjiJxQkyFECGv6tkF4PR5uLMRyrjcM1s=;
        b=Z0uFprsYwywNS68m/eM3cYLkL6iap4CqZ9kiI9A5tXu9dAudrw0PXqECBfTyDlaxPpE2BG
        kbxvLyTLr1Tafxl4YV4bx9g1gSZF85VllCS3844/pGJ4qdCzVh+O0FagDCatlFJITengJi
        NAGomWygU3ES2krSPcRPsVlKoTORN00=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-b1DdjJjJMMOANPzZwqTfNQ-1; Fri, 23 Apr 2021 06:45:50 -0400
X-MC-Unique: b1DdjJjJMMOANPzZwqTfNQ-1
Received: by mail-wm1-f71.google.com with SMTP id n11-20020a1c400b0000b02901339d16b8d7so3796854wma.7
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 03:45:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6QtPk8mqfGCCjiJxQkyFECGv6tkF4PR5uLMRyrjcM1s=;
        b=Bp+5mB+3fTGZIInlfG4QodE39lg8v0CJpXBxKgCXSF9J1VQ0xtofhrOPKF69uADeA4
         sfnudAP0z+zKaaeaEMW969f+GuakBP4Da9sdViPM3xJ70wL94NS5KIIFVoXAs3gt2SOp
         JOFYfPE/mAS0TBZ+Tmx83VGn1/4bzBHHyAJ4EjCQEZwjfoUZuXJ8U3WWlpD60p48LpGI
         ucJwKjgqrzsOeod8t6oRRHReYDdQmFl/vFxHpA+Oa0Ie2qJTvVtaPv9ILCR0zETwvfnI
         TSZc83cv8WvYN5WMKCGMnBqGtqfcXSwJ7pKvCd306FXaSrMujp07I3Yf854oHQS0wM2a
         /wug==
X-Gm-Message-State: AOAM5314MXbzMR5uEg2eO6lhvJMVPGz6m2QUStQK4Py+bTZPcadp4H1I
        RDDZiI3NTVZLYZljGAsrROgFrDdTGc3bF0JnISzVW+dyMlh2sTnA4YnRWz/FqkO7Zzr+5OjQHjC
        fkl93mXao7KFI
X-Received: by 2002:adf:d1cd:: with SMTP id b13mr3909859wrd.126.1619174749031;
        Fri, 23 Apr 2021 03:45:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyiTCIXkknwotYShXVUIfCR1XjC5N9LEkvoMraN8zKz1jILoa5ubv9ZrlbWmnmcXme3CJv+uQ==
X-Received: by 2002:adf:d1cd:: with SMTP id b13mr3909838wrd.126.1619174748828;
        Fri, 23 Apr 2021 03:45:48 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id 66sm12106746wmb.36.2021.04.23.03.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 03:45:47 -0700 (PDT)
Date:   Fri, 23 Apr 2021 12:45:45 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com
Subject: Re: [PATCH 3/3] KVM: selftests: Use a ucall for x86 unhandled vector
 reporting
Message-ID: <20210423104545.dthezamjvogcpwbt@gator>
References: <20210423040351.1132218-1-ricarkol@google.com>
 <20210423040351.1132218-4-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423040351.1132218-4-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Ricardo,

It may be nicer to introduce UCALL_UNHANDLED with this patch and have it
come fist in the series.

Thanks,
drew


On Thu, Apr 22, 2021 at 09:03:51PM -0700, Ricardo Koller wrote:
> x86 reports unhandled vectors using port IO at a specific port number,
> which is replicating what ucall already does for x86.  Aarch64, on the
> other hand, reports unhandled vector exceptions with a ucall using a
> recently added UCALL_UNHANDLED ucall type.
> 
> Replace the x86 unhandled vector exception handling to use ucall
> UCALL_UNHANDLED instead of port IO.
> 
> Tested: Forcing a page fault in the ./x86_64/xapic_ipi_test
> 	halter_guest_code() shows this:
> 
> 	$ ./x86_64/xapic_ipi_test
> 	...
> 	  Unexpected vectored event in guest (vector:0xe)
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/include/x86_64/processor.h      |  2 --
>  .../testing/selftests/kvm/lib/x86_64/processor.c  | 15 ++++++---------
>  2 files changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 0b30b4e15c38..379f12cbdc06 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -53,8 +53,6 @@
>  #define CPUID_PKU		(1ul << 3)
>  #define CPUID_LA57		(1ul << 16)
>  
> -#define UNEXPECTED_VECTOR_PORT 0xfff0u
> -
>  /* General Registers in 64-Bit Mode */
>  struct gpr64_regs {
>  	u64 rax;
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index a8906e60a108..284d26a25cd3 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -1207,7 +1207,7 @@ static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
>  
>  void kvm_exit_unexpected_vector(uint32_t value)
>  {
> -	outl(UNEXPECTED_VECTOR_PORT, value);
> +	ucall(UCALL_UNHANDLED, 1, value);
>  }
>  
>  void route_exception(struct ex_regs *regs)
> @@ -1260,16 +1260,13 @@ void vm_handle_exception(struct kvm_vm *vm, int vector,
>  
>  void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid)
>  {
> -	if (vcpu_state(vm, vcpuid)->exit_reason == KVM_EXIT_IO
> -		&& vcpu_state(vm, vcpuid)->io.port == UNEXPECTED_VECTOR_PORT
> -		&& vcpu_state(vm, vcpuid)->io.size == 4) {
> -		/* Grab pointer to io data */
> -		uint32_t *data = (void *)vcpu_state(vm, vcpuid)
> -			+ vcpu_state(vm, vcpuid)->io.data_offset;
> +	struct ucall uc;
>  
> +	if (get_ucall(vm, vcpuid, &uc) == UCALL_UNHANDLED) {
> +		uint64_t vector = uc.args[0];
>  		TEST_ASSERT(false,
> -			    "Unexpected vectored event in guest (vector:0x%x)",
> -			    *data);
> +			    "Unexpected vectored event in guest (vector:0x%lx)",
> +			    vector);
>  	}
>  }
>  
> -- 
> 2.31.1.498.g6c1eba8ee3d-goog
> 

