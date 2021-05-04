Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F0E372E7F
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 19:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbhEDRKu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 13:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbhEDRKt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 13:10:49 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443FCC061574
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 10:09:54 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id e2so5413252plh.8
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 10:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Apx1mPPo9jw/DJuFJCfp1cuIUyNCtJscROEa9WeUops=;
        b=iG8yuyjj3NEBh1SqCU8M9JffkR8pCwPcnuH0m7vDo3ondigxJXorbh1Pi91xJDWadu
         Y/76aELlhAnKrGShMNapHEYxB31edsVGsdbLRnkKy+bhOCkuOe8fy0UT+Qm+qMHGmFd0
         LkcLkT2tdsMFXazYapkFLgX+sAZlCRRQr101i4syKA8Lmnq7Dv5Td2FWjYf0A/GJ+M6I
         yK5bYbMqdZ0JWup+yR2XJPGcDWi5JGRldJDr5MbtOrmISmJf94KM+1Ym00gjKi/yA90M
         NRiv2oveh8iBy0Q7xx0OcTU1hPDdVJUJMFVx2KIX4Wv9g69TRejkyA7ugYspstU8sAF7
         Aocg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Apx1mPPo9jw/DJuFJCfp1cuIUyNCtJscROEa9WeUops=;
        b=XiDAdVE1SFlS+Q1klyK5WtjUmiazYNkvoXWhAv8SE+dOfj4+n1BMkZPacJbMZMiIgo
         4abXbVjMtezs0SFC8R3Quf2CIwiUZUzqyiFInO5lBctpEX6ffHQxxdgeBrbe/sICouD0
         R4ROf5k5fSuomILivqFM0sqo0ptw65NrcByUwutpXfSw+4+kS0a8YZdsb6i5tmAITUl9
         HuPDobirq+MFJf/eYhFBHjNXDP5Z31NMczbSIvxirEItFUS6f9RNiXrQ4I5lBbtGGv7D
         55ED7sdgqvKvYrcWHpfiNF1XEifR5tvW6612E1YpEK4A3l8j3dGR/pLXfmy6i8sWqTRP
         sCSw==
X-Gm-Message-State: AOAM530/q1k/PtesWQ3wKpeXgLh8MsTV8JPKK7oRWqHmBElO3guMlNva
        wmxdfsRZWKl6UiewvgybksiiyH+PNkGRDg==
X-Google-Smtp-Source: ABdhPJwseKiZuqCpuvF5P24NikxzpjspdnX4lap/dpWFtDHUHsQBhTSbgNowcR9B15ig34yjMDUlxg==
X-Received: by 2002:a17:902:9893:b029:ee:e8a8:688c with SMTP id s19-20020a1709029893b02900eee8a8688cmr6335873plp.84.1620148193646;
        Tue, 04 May 2021 10:09:53 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id w1sm6648874pfj.46.2021.05.04.10.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 10:09:53 -0700 (PDT)
Date:   Tue, 4 May 2021 17:09:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        srutherford@google.com, joro@8bytes.org, brijesh.singh@amd.com,
        thomas.lendacky@amd.com, ashish.kalra@amd.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        x86@kernel.org
Subject: Re: [PATCH v3 2/2] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Message-ID: <YJF/3d+VBfJKqXV4@google.com>
References: <20210429104707.203055-1-pbonzini@redhat.com>
 <20210429104707.203055-3-pbonzini@redhat.com>
 <YIxkTZsblAzUzsf7@google.com>
 <c4bf8a05-ec0d-9723-bb64-444fe1f088b5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4bf8a05-ec0d-9723-bb64-444fe1f088b5@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 01, 2021, Paolo Bonzini wrote:
> - make it completely independent from migration, i.e. it's just a facet of
> MSR_KVM_PAGE_ENC_STATUS saying whether the bitmap is up-to-date.  It would
> use CPUID bit as the encryption status bitmap and have no code at all in KVM
> (userspace needs to set up the filter and implement everything).

If the bit is purely a "page encryption status is up-to-date", what about
overloading KVM_HC_PAGE_ENC_STATUS to handle that status update as well?   That
would eliminate my biggest complaint about having what is effectively a single
paravirt feature split into two separate, but intertwined chunks of ABI.

#define KVM_HC_PAGE_ENC_UPDATE		12

#define KVM_HC_PAGE_ENC_REGION_UPDATE	0 /* encrypted vs. plain text */
#define KVM_HC_PAGE_ENC_STATUS_UPDATE	1 /* up-to-date vs. stale */

		ret = -KVM_ENOSYS;
		if (!vcpu->kvm->arch.hypercall_exit_enabled)
		        break;

		ret = -EINVAL;
		if (a0 == KVM_HC_PAGE_ENC_REGION_UPDATE) {
			u64 gpa = a1, npages = a2;

			if (!PAGE_ALIGNED(gpa) || !npages ||
			    gpa_to_gfn(gpa) + npages <= gpa_to_gfn(gpa))
				break;
		} else if (a0 != KVM_HC_PAGE_ENC_STATUS_UPDATE) {
			break;
		}

		vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
		vcpu->run->hypercall.nr       = KVM_HC_PAGE_ENC_STATUS;
		vcpu->run->hypercall.args[0]  = a0;
		vcpu->run->hypercall.args[1]  = a1;
		vcpu->run->hypercall.args[2]  = a2;
		vcpu->run->hypercall.args[3]  = a3;
		vcpu->run->hypercall.longmode = op_64_bit;
		vcpu->arch.complete_userspace_io = complete_hypercall_exit;
		return 0;

