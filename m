Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFD267482
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 19:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfGLRo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 13:44:59 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35103 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbfGLRo7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 13:44:59 -0400
Received: by mail-wr1-f66.google.com with SMTP id y4so10824037wrm.2;
        Fri, 12 Jul 2019 10:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lHUKPh97ovneR+jDvYGIi2nNeLvm3FEJyqMoQsO3Cw8=;
        b=QCGUlMqK5B1quSCyGoAcIkiOgg388g7Xls60Fqvq4ZpodWBQxwUoFPlvE33KbN47lj
         B9LpGCdbIDsiKme2dxcVxhmWO1rhaAkIYanx5X7FynPmshJg7ey1svufsGYSrEWELbzL
         P+jn4+eEcQo6588FehkRMIV6YVWfnVmTuIwmacXYWLV3GezbW3qCeK0DJb1bb3S6Lnrj
         psG+mI6PR+cl5hSQo1kgW+o26sR+eRoovKl88jbNkYH2uB5qT89oRkfGWikS3uxDd9Qe
         E28x1azhylqQ7v/2r3vReiX0PZZbSwmmGPJK+YfH0E1aBngKVJP4gWrbGKGXBvTKAkYD
         YxcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lHUKPh97ovneR+jDvYGIi2nNeLvm3FEJyqMoQsO3Cw8=;
        b=f9VzFiGZ/cX9nyyNa6zTlPqFcG1EWTzyKA//5ve/XCpEh5fEqnWGCsCohOO4dcTESM
         rBeJodTRXCqu5ekiyrq7h+gwQaDkAQDXnq/bnC17Ctpm+e2wPDvlvNAVl8VT6f2qEDbd
         meg4WUtjAIs4/ndXJoQ0nSDFIUFACKuyqQAvkDbjgNshVjPUlOU/j1oIMrHPjqoKXIQ8
         jTluH6/HQMHzOypzHPWCTkkjftd+45XmPZhTR3HDwK0E/ZIrKJ8fOR0VqHoUUoKyQgJE
         1Y5JM0puPTJbk8ZU84vXyoria+FGcBlDmI/RhKfqi3Iw1OTpo7Mgqb1ebxqzPz/CRGj0
         QQLA==
X-Gm-Message-State: APjAAAWoaDvz8d9Lh/y1c0FR+In+cpnz4VlLNf+Ju3l25G1/ot37PqB2
        rFFhtiMAdmcx6QCu1GVJItk=
X-Google-Smtp-Source: APXvYqy4KqpsDEOZJLk74bD59Jir3YB8IxQwIxc2RMK8xRXK5QNzAgrcRcH00VOIA9PzEKl403m2Bw==
X-Received: by 2002:adf:f6cb:: with SMTP id y11mr13510997wrp.245.1562953497008;
        Fri, 12 Jul 2019 10:44:57 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id v18sm10522732wrs.80.2019.07.12.10.44.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 12 Jul 2019 10:44:56 -0700 (PDT)
Date:   Fri, 12 Jul 2019 10:44:54 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Liran Alon <liran.alon@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] [v3] x86: kvm: avoid -Wsometimes-uninitized warning
Message-ID: <20190712174454.GA3845@archlinux-threadripper>
References: <20190712141322.1073650-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712141322.1073650-1-arnd@arndb.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 12, 2019 at 04:13:09PM +0200, Arnd Bergmann wrote:
> Clang notices a code path in which some variables are never
> initialized, but fails to figure out that this can never happen
> on i386 because is_64_bit_mode() always returns false.
> 
> arch/x86/kvm/hyperv.c:1610:6: error: variable 'ingpa' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>         if (!longmode) {
>             ^~~~~~~~~
> arch/x86/kvm/hyperv.c:1632:55: note: uninitialized use occurs here
>         trace_kvm_hv_hypercall(code, fast, rep_cnt, rep_idx, ingpa, outgpa);
>                                                              ^~~~~
> arch/x86/kvm/hyperv.c:1610:2: note: remove the 'if' if its condition is always true
>         if (!longmode) {
>         ^~~~~~~~~~~~~~~
> arch/x86/kvm/hyperv.c:1595:18: note: initialize the variable 'ingpa' to silence this warning
>         u64 param, ingpa, outgpa, ret = HV_STATUS_SUCCESS;
>                         ^
>                          = 0
> arch/x86/kvm/hyperv.c:1610:6: error: variable 'outgpa' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
> arch/x86/kvm/hyperv.c:1610:6: error: variable 'param' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
> 
> Flip the condition around to avoid the conditional execution on i386.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
