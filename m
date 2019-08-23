Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8359AB36
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 11:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfHWJPW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 05:15:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59390 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727142AbfHWJPW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 05:15:22 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1C54F859FE
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 09:15:22 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id k14so4536301wrv.2
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 02:15:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Fogl+Xs+eEecVqlA/+UJZO2WdJiNWt+Dkg9XFhlgz2U=;
        b=DSnDTAJ2rVeS+MBg/3PvWgRZ1kAueCd6d1vW9mdX0CeFRauBWPedGztqkKgdXxBK8N
         A/Lnh++FyTkCNW+QTzUOD2gvosS7lkDS+InlAouXF8SKIPmn6oDj1yX2LDugPTgYBked
         QqrqAkDyn8iqnNQVILqoVaR0a4lfMTHLW1v1yOQUaGsO0Sp94pCP+3SYbRFuJ+SK4gRq
         pI/cI8qRhvemvWIDjok/mx7ozm/rPcPGqfusSoX0SBTiCp1LS2o1bXsgdttCvubdSmU7
         qtOAvw0I/smGDT+CDHZmBQI5H21nBv9are1raWRJlBa/H5PNokM45eWvZuu20uKaftAj
         NCJQ==
X-Gm-Message-State: APjAAAW6aak8FoyPh2J4ey7QWCR8vxdtz3mfS/qkiEI0NgHVjkGEd8Tg
        bmZsDTSfK/M+tpMvJwJDNOX2Z4V9OZZU0FBsAtTyZeFq/3NKyEMyw+Ao7i+/UIt2dVurzgfeUhx
        mFWnMgZ6PH1Ao
X-Received: by 2002:adf:dcc2:: with SMTP id x2mr3492108wrm.295.1566551720233;
        Fri, 23 Aug 2019 02:15:20 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzCFMlFThRSbr0p2bFyKMbVO+GhKtybrGNQbyE4KaJLTqw6rB3fsEgDC8WW2wselB1EwGJhig==
X-Received: by 2002:adf:dcc2:: with SMTP id x2mr3492071wrm.295.1566551719960;
        Fri, 23 Aug 2019 02:15:19 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a142sm3258237wme.2.2019.08.23.02.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2019 02:15:19 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [RESEND PATCH 01/13] KVM: x86: Relocate MMIO exit stats counting
In-Reply-To: <20190823010709.24879-2-sean.j.christopherson@intel.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com> <20190823010709.24879-2-sean.j.christopherson@intel.com>
Date:   Fri, 23 Aug 2019 11:15:18 +0200
Message-ID: <87d0gwp7ix.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Move the stat.mmio_exits update into x86_emulate_instruction().  This is
> both a bug fix, e.g. the current update flows will incorrectly increment
> mmio_exits on emulation failure, and a preparatory change to set the
> stage for eliminating EMULATE_DONE and company.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

This, however, makes me wonder why this is handled in x86-specific code
in the first place, can we just count KVM_EXIT_MMIO exits when handling
KVM_RUN?

> ---
>  arch/x86/kvm/mmu.c     | 2 --
>  arch/x86/kvm/vmx/vmx.c | 1 -
>  arch/x86/kvm/x86.c     | 2 ++
>  3 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 4c45ff0cfbd0..845e39d8a970 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -5437,8 +5437,6 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
>  	case EMULATE_DONE:
>  		return 1;
>  	case EMULATE_USER_EXIT:
> -		++vcpu->stat.mmio_exits;
> -		/* fall through */
>  	case EMULATE_FAIL:
>  		return 0;
>  	default:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 570a233e272b..18286e5b5983 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5200,7 +5200,6 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
>  		err = kvm_emulate_instruction(vcpu, 0);
>  
>  		if (err == EMULATE_USER_EXIT) {
> -			++vcpu->stat.mmio_exits;
>  			ret = 0;
>  			goto out;
>  		}
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b4cfd786d0b6..cd425f54096a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6598,6 +6598,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
>  		}
>  		r = EMULATE_USER_EXIT;
>  	} else if (vcpu->mmio_needed) {
> +		++vcpu->stat.mmio_exits;
> +
>  		if (!vcpu->mmio_is_write)
>  			writeback = false;
>  		r = EMULATE_USER_EXIT;

-- 
Vitaly
