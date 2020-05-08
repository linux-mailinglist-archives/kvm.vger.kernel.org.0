Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653411CB2E2
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 17:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgEHPcT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 11:32:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53128 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726817AbgEHPcS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 11:32:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588951936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0DyykdflDVUki0L9BuRfwBnn/zEUOvBXEj/RVUNAsOM=;
        b=NfTtVMLFaieeL1lb+TtnfRXHcqC3uhuoVhSTp7+PrD2Wr2/Fa0BNQulef9CReZ3jog0C+X
        mBj27eM9nY3Ih2Bh+Iy95CkKyqVKlpiVOs6aPmlhjW3ncuI3k+P97LQPE2RACcGY92PPnD
        ScDOPUWbIOousQgvjCJP8Xi1yUjI9aE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-iR52HCW0Pr-wgBzHa5zUDg-1; Fri, 08 May 2020 11:32:13 -0400
X-MC-Unique: iR52HCW0Pr-wgBzHa5zUDg-1
Received: by mail-qv1-f70.google.com with SMTP id j6so2124440qvn.9
        for <kvm@vger.kernel.org>; Fri, 08 May 2020 08:32:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0DyykdflDVUki0L9BuRfwBnn/zEUOvBXEj/RVUNAsOM=;
        b=RyNHYbr84j9jRZVucvGnTjcQN20dc1krtjXeJmSo87Shy7L9stAhOGEjz5QU9Jo8eW
         oDsmhJqpnVk17twF0Bve/CXWsJXwHAoJAT0UXyyoMwu1q+XSaItkoWpT04wxL6i1C5Z5
         8QHNwvVjHk+Y8vj88PTjAH0rX1nI5DHtg1bidhSVYvyuKK2qQSRSWq7joHB7+X1KnmdZ
         UjWOBTj9q7oDsjv0pIObiVjED7CseRz2MrYpmPliKS1U+u0Jklmi94tZSt7zlXpoOLdn
         Cb6vBvsSNznPuiW8lDSah+/g2KsH+8HaW3wmEaLSgmCq92n2ovJ0c9lTe2AOjF+Lii6+
         wlsg==
X-Gm-Message-State: AGi0Pua2gAM+vN0eLhx+NLjJbGDBs2Ek77EbnxvpoPIGN4zWaLEfYWv6
        OBTKUQHwzljM0eEMPiX44JSNtITxppnSVxAneBPtMxLFMkAcpR3QLQf1xLvR3SOB2fErP3fcvgE
        +SvV4y+V5fAe2
X-Received: by 2002:ad4:4d06:: with SMTP id l6mr3440389qvl.34.1588951933134;
        Fri, 08 May 2020 08:32:13 -0700 (PDT)
X-Google-Smtp-Source: APiQypKTUxfYKuj8cTaLbMJPJDpg+HZLLUYd2UvsYRdIdNjT8g6WJWzBB/nG1RdQZ6kL7p6i2SbCbQ==
X-Received: by 2002:ad4:4d06:: with SMTP id l6mr3440362qvl.34.1588951932758;
        Fri, 08 May 2020 08:32:12 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id u7sm1422893qkc.1.2020.05.08.08.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 08:32:12 -0700 (PDT)
Date:   Fri, 8 May 2020 11:32:10 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 8/9] KVM: x86, SVM: isolate vcpu->arch.dr6 from
 vmcb->save.dr6
Message-ID: <20200508153210.GZ228260@xz-x1>
References: <20200507115011.494562-1-pbonzini@redhat.com>
 <20200507115011.494562-9-pbonzini@redhat.com>
 <20200507192808.GK228260@xz-x1>
 <dd8eb45b-4556-6aaa-0061-11b9124020b1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dd8eb45b-4556-6aaa-0061-11b9124020b1@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 08, 2020 at 12:33:57AM +0200, Paolo Bonzini wrote:
> On 07/05/20 21:28, Peter Xu wrote:
> >> -	svm->vcpu.arch.dr6 = dr6;
> >> +	WARN_ON(svm->vcpu.arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT);
> >> +	svm->vcpu.arch.dr6 &= ~(DR_TRAP_BITS | DR6_RTM);
> >> +	svm->vcpu.arch.dr6 |= dr6 & ~DR6_FIXED_1;
> > I failed to figure out what the above calculation is going to do... 
> 
> The calculation is merging the cause of the #DB with the guest DR6.
> It's basically the same effect as kvm_deliver_exception_payload. The
> payload has DR6_RTM flipped compared to DR6, so you have the following
> simplfications:
> 
> 	payload = (dr6 ^ DR6_RTM) & ~DR6_FIXED_1;
> 	/* This is kvm_deliver_exception_payload: */
>         vcpu->arch.dr6 &= ~DR_TRAP_BITS;
>         vcpu->arch.dr6 |= DR6_RTM;
> 	/* copy dr6 bits other than RTM */
>         vcpu->arch.dr6 |= payload;
> 	/* copy flipped RTM bit */
>         vcpu->arch.dr6 ^= payload & DR6_RTM;
> 
> ->
> 
> 	payload = (dr6 ^ DR6_RTM) & ~DR6_FIXED_1;
> 	/* clear RTM here, so that we can OR it below */
>         vcpu->arch.dr6 &= ~(DR_TRAP_BITS | DR6_RTM);
> 	/* copy dr6 bits other than RTM */
>         vcpu->arch.dr6 |= payload & ~DR6_RTM;
> 	/* copy flipped RTM bit */
>         vcpu->arch.dr6 |= (payload ^ DR6_RTM) & DR6_RTM;
> 
> ->
> 
> 	/* we can drop the double XOR of DR6_RTM */
> 	dr6 &= ~DR6_FIXED_1;
>         vcpu->arch.dr6 &= ~(DR_TRAP_BITS | DR6_RTM);
>         vcpu->arch.dr6 |= dr6 & ~DR6_RTM;
>         vcpu->arch.dr6 |= dr6 & DR6_RTM;
> 
> ->
> 
> 	/* we can do the two ORs with a single operation */
>         vcpu->arch.dr6 &= ~(DR_TRAP_BITS | DR6_RTM);
>         vcpu->arch.dr6 |= dr6 & ~DR6_FIXED_1;

Oh that's quite some math. :) Thanks Paolo!

Shall we introduce a helper for both kvm_deliver_exception_payload and here
(e.g. kvm_merge_dr6)?  Also, wondering whether this could be a bit easier to
follow by defining:

/*
 * These bits could be kept being set until the next #DB if not
 * explicitly cleared.
 */
#define  DR6_CARRY_OVER_BITS  (DR6_BT | DR6_BS | DR6_BD)

Then the imho above calculation could also become:

    vcpu->arch.dr6 = (vcpu->arch.dr6 & DR6_CARRY_OVER_BITS) | save.dr6;

What do you think?

> 
> > E.g., I
> > think the old "BT|BS|BD" bits in the old arch.dr6 cache will be leftover even
> > if none of them is set in save.dr6, while we shouldn't?
> 
> Those bits should be kept; this is covered for example by the "hw
> breakpoint (test that dr6.BS is not cleared)" testcase in kvm-unit-tests
> x86/debug.c.

Right.  Thanks!

-- 
Peter Xu

