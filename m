Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC06D5227C8
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 01:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238548AbiEJXp7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 19:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238456AbiEJXp4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 19:45:56 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC23125594
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 16:45:55 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id cq17-20020a17090af99100b001dc0386cd8fso500871pjb.5
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 16:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=QoqmhoJVijxJEwqA6DH3wPhDIm10VpX5UsNvXVMmXaw=;
        b=CZaKyY51AyEq0wEP49YMgPJQn7JQeY/jnsqcUl4i6IKFgfdtTE3Hn8aD+P3ovp1tKT
         Se7jJ6ELuMBQol0V8Y+hy5iia9eRuGm/BhbHPvqMJOhjmRf4PWDYPmnPyF/i5SlTU9o1
         FgFS9q7alymdBOHPZ0025vQoTCX59MhS/gNrFwWM+KmWqgu/T/qjXTpgRRQc5TIn6oPc
         q4fhyzjwrnA8llH+ALICTvBIRmkT8EZja0ZAOLRyDbD36XpoHVbqfUN3HPhb8wCFmHi3
         IgCA+9GBww59wUku55apPIa7HKFjCQAsfB2IsSBB4VG3IFZ9TgOp5Pi5g4PbsR7OLwBo
         FH3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=QoqmhoJVijxJEwqA6DH3wPhDIm10VpX5UsNvXVMmXaw=;
        b=wg6ynT3QA8MedvLqZecowLcu/LE/beAT0SvcChQepFUAtYIZJanFoVLo4JDU161Yzr
         Et7Qr7woPnZQrL4VoXut4SJUhP9D/0DJJi5K5qYSHl7/uKv7JQzN65lWfFr8rfsg3oMK
         MYUjsQj5/ION6ZoMPBfarqvQsupmLjWWALyWWAz9nwyVBsXVVAOdOCJJBzOBUrYZyUiM
         iGbZADylxnN1xy3UOvhMOxn3b4YLvfG3SjPx6/DU4vaX6mO7xvmwzF4U/aFbGQE7h1RJ
         9UZm7nZNKWDoy1fuQyXae4G7VxcJFTnoiEP5Kll2dWXfVV+wGfCyuqhvWD2txBTO0MEc
         1zSA==
X-Gm-Message-State: AOAM533jsgHGnc4O6WSqp2HuxIUPjpkatfr4Ei6gStfWJG6LbCNgFlSR
        JKDhkuR2kKdRR8NMCv0VkfEXBg==
X-Google-Smtp-Source: ABdhPJx/WVHQXojCsdNzfIEY9IGkVQnnK/pBHDnL2wt68lS7jDgOHsrhTO/9FLmQSAktIOY4VL0TPA==
X-Received: by 2002:a17:902:864b:b0:15e:f9e0:20ca with SMTP id y11-20020a170902864b00b0015ef9e020camr16873731plt.122.1652226355057;
        Tue, 10 May 2022 16:45:55 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d14-20020a621d0e000000b0050dc76281b0sm107617pfd.138.2022.05.10.16.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 16:45:54 -0700 (PDT)
Date:   Tue, 10 May 2022 23:45:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shannon Zhao <shannon.zhao@linux.alibaba.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, yijunzhu@linux.alibaba.com
Subject: Re: [PATCH] KVM: SVM: Set HWCR[TscFreqSel] to host's value
Message-ID: <Ynr5L7+OJ23tEowC@google.com>
References: <1652169227-38383-1-git-send-email-shannon.zhao@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1652169227-38383-1-git-send-email-shannon.zhao@linux.alibaba.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 10, 2022, Shannon Zhao wrote:
> KVM sets CPUID.80000007H:EDX[8] to 1, but not set HWCR[TscFreqSel].
> This will cause guest kernel printing below log on AMD platform even
> though the hardware TSC exactly counts with P0 frequency.
> "[Firmware Bug]: TSC doesn't count with P0 frequency!"
> 
> Fix it by setting HWCR[TscFreqSel] to host's value to indicate whether
> the TSC increments at the P0 frequency.

I don't think this is safe.  The APM says

  Some HWCR bits are implementation specific, and are described in the BIOS and
  Kernel Developer’s Guide (BKDG) or Processor Programming Reference Manual
  applicable to your product. Implementation specific HWCR bits are not listed below.

and then omits bit 24.  One thought to handle this would be to let userspace
write all the non-architectural bits, then userspace can set the magic,
non-architectural bits based on CPUID and vCPU FMS.

> Signed-off-by: Shannon Zhao <shannon.zhao@linux.alibaba.com>
> ---
>  arch/x86/kvm/svm/svm.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7e45d03..fb4bb51 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1139,6 +1139,11 @@ static void __svm_vcpu_reset(struct kvm_vcpu *vcpu)
>  	svm_init_osvw(vcpu);
>  	vcpu->arch.microcode_version = 0x01000065;
>  	svm->tsc_ratio_msr = kvm_default_tsc_scaling_ratio;
> +	/* 
> +	 * TSC frequency select is HWCR[24], set it to host's value to indicate

This really should get a #define in msr-index.h, but maybe that's "impossible"
because it's not an architectural bit.

> +	 * whether the TSC increments at the P0 frequency. 
> +	 */
> +	vcpu->arch.msr_hwcr = native_read_msr(MSR_K7_HWCR) & BIT_ULL(24);

This will break live save/restore, a.k.a. live migration.  KVM doesn't allow
writes to MSR_K7_HWCR to set anything other than bit 18, even if the write comes
from userspace.

>  
>  	if (sev_es_guest(vcpu->kvm))
>  		sev_es_vcpu_reset(svm);
> -- 
> 1.8.3.1
> 
