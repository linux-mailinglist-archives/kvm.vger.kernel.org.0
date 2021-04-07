Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E6335777A
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 00:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbhDGWRQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 18:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhDGWRP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 18:17:15 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B28BC061761
        for <kvm@vger.kernel.org>; Wed,  7 Apr 2021 15:17:04 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id p12so10082833pgj.10
        for <kvm@vger.kernel.org>; Wed, 07 Apr 2021 15:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X9ugYAwXT/ureXX1GFDh8KaDzFpw87RFikpzRN4GEwk=;
        b=cZuDsM0q6rhLG2g/SJJr+U5euIn9viBs/aJrzfiRA3zNllyBdrBv16d+LgOEK7foET
         QCJTaRDolYGWgTNAGHNkJPdWVceGYLXP0P0bj6yNVqJvn5U/uKlXw50KoG7fNljYIAQT
         KwR/z1nZ0JVPvP8oQthtfF3Ky2iZbugdwZPpS3pgCgrYrbdwUzJdbozo1e45tvqzgNmF
         oH7ORLVwxP2VPPaI5hHxjzb0Yzg+pFHn/dMtDnm6P9C77NHwmOrFkovTYEFl21U7yaaa
         6YhJkcA37vyl7uZnMwqQzJ4XcF89j4tXfk2Qw5SYjuOjhx6HDsXrgAzK73p9ZnRdARms
         8Rdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X9ugYAwXT/ureXX1GFDh8KaDzFpw87RFikpzRN4GEwk=;
        b=uZBtXHyXK4wK6uW6znXhSyuMJw0l4HU+1QLIBkjsCPekBCieHnGAp//Epx/JMOjgf9
         XfPvEhpK/Ni7hrWlq28/BRt5CYz4UYqQdtugw9z1DmOKGmN2ErK3OOP1Qp8U0Cd2kdI2
         BFcyBtnKDc0J0cDVIO+ChI4OKAFgL4vi9mCAPiJkUKL4KU2iRXllpSwkSJcBfjmgms5o
         pq84XgsPd7XsUnhi6VVT4x22TNYEPCqnkrbodAMQl2a4DVlbzWuJU3r7hvF+GFg4TJwr
         TLSgDcnEo1aSMyqYe4X5dcSpwmTKaSM06tQ/LxXZ7lrN4p2t1GjCETyWTDa95kI0UMAz
         M3gQ==
X-Gm-Message-State: AOAM532wNOEjYmhzDbgGHEugIjA0DESLDnq25F1tJQoJWOD6ud5gKR8s
        bR/LZbvFPIN3pJcIWrkmxM5SUg==
X-Google-Smtp-Source: ABdhPJzasV5McGx1ICJVbH129PTfPj5PdK2RyMf60yHN7Eh7ZRyxuXX27Fgc6pjFmpL6y47wYURtRw==
X-Received: by 2002:a62:7ccd:0:b029:1fb:2316:b93e with SMTP id x196-20020a627ccd0000b02901fb2316b93emr4694912pfc.34.1617833823931;
        Wed, 07 Apr 2021 15:17:03 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id n73sm23434625pfd.196.2021.04.07.15.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 15:17:03 -0700 (PDT)
Date:   Wed, 7 Apr 2021 22:16:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org,
        pbonzini@redhat.com, bp@alien8.de, jarkko@kernel.org,
        dave.hansen@intel.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com
Subject: Re: [PATCH v4 06/11] KVM: VMX: Frame in ENCLS handler for SGX
 virtualization
Message-ID: <YG4vWwwhr01vZGp6@google.com>
References: <cover.1617825858.git.kai.huang@intel.com>
 <4be4b49f63a6c66911683d0f093ca5ef0d3996d5.1617825858.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4be4b49f63a6c66911683d0f093ca5ef0d3996d5.1617825858.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 08, 2021, Kai Huang wrote:
> +int handle_encls(struct kvm_vcpu *vcpu)
> +{
> +	u32 leaf = (u32)vcpu->arch.regs[VCPU_REGS_RAX];

Please use kvm_rax_read(), I've been trying to discourage direct access to the
array.  Which is ironic because I'm 100% certain I'm to blame for this. :-)

> +
> +	if (!encls_leaf_enabled_in_guest(vcpu, leaf)) {
> +		kvm_queue_exception(vcpu, UD_VECTOR);
> +	} else if (!sgx_enabled_in_guest_bios(vcpu)) {
> +		kvm_inject_gp(vcpu, 0);
> +	} else {
> +		WARN(1, "KVM: unexpected exit on ENCLS[%u]", leaf);
> +		vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
> +		vcpu->run->hw.hardware_exit_reason = EXIT_REASON_ENCLS;
> +		return 0;
> +	}
> +	return 1;
> +}
