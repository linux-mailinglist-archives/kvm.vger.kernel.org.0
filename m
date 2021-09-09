Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E809F405BC3
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 19:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240791AbhIIRK0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 13:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238914AbhIIRKZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 13:10:25 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151C9C061575
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 10:09:16 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id w19-20020a17090aaf9300b00191e6d10a19so1942345pjq.1
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 10:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aBtM+Vc7Pdk2KbXitmQqbb8Smj1Sm+602q1syMUfkco=;
        b=k43+wP4XjElxHdhGoIl3EArpqrrKP9efEUsSpzl8yfxIKXgG2r01TrRNEloYN/070s
         psSDinINGrXnE/sGefyEmidxLuIXLQWbvcuMJTleE/BiRdRurVyA7poDYPnpPuhy/FtY
         loa/sRj7PbmXt9ODqmyRANNK+nidaLFfsOQ0jKtfL4y1dDst2DP5nOZv6y19oDZskDEI
         UjqU0mnTOU3cEdpxzR+p3dpujVrpYIlpaQGOFiM6LwyTtlF+8BvL8Rqzo4CKcE6adPwg
         TYkjbrDih81xcxJNySwqxIcs4foWtqeNzUrEqcwPZDN9/h/evLRd6AccdLMQIwN2JahQ
         JSzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aBtM+Vc7Pdk2KbXitmQqbb8Smj1Sm+602q1syMUfkco=;
        b=Dm1IJogKHQCshMjyeqaPH5bUDX5y2KRNu9du22Hva/JtNoXAT1/nHWX77mX5i/WcJK
         s3gR/XJQMwqhL68XJr5BuOPPRMsmYrPQmoFrs0nsfCQX9d+UqF7lNPnqYtYqfjUmrqJl
         U3udulP8Os0GKHnwAKX9JDSExhrpf+KipFQ3DyHUjcd3MWO7p+ViI4p/+pIJwojdJgJ1
         OBnsba0IIEHCR/plYtIbZnWRNfe2HifKvdxW8klodRFONnmbHB18hDgvr12gzXtSxRi4
         LQeZNhNKKZu6nZc6lOja3lbcL/5J7zEbdzSMo+OBSAoREK3ORgn/Lpmwef/kCQyGQBnF
         3zbA==
X-Gm-Message-State: AOAM533ZpCSbqSRPmYqpTtSAK3H9VgFchtXsTTdqyk0FR/cKZuBe6/yP
        vXnrHFWzGSIiDbkqlFnrgN0gTw==
X-Google-Smtp-Source: ABdhPJycifsJuq88nNWwvxJDYYjyqLf3VbV19NHMcl078B1/FDTeUil2OXWc0PyTR1WOy8TLeCmApQ==
X-Received: by 2002:a17:902:bf07:b0:138:e32d:9f2e with SMTP id bi7-20020a170902bf0700b00138e32d9f2emr3524138plb.59.1631207355415;
        Thu, 09 Sep 2021 10:09:15 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o10sm2854670pjo.47.2021.09.09.10.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 10:09:14 -0700 (PDT)
Date:   Thu, 9 Sep 2021 17:09:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Hou Wenlong <houwenlong93@linux.alibaba.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Avi Kivity <avi@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] kvm: x86: Introduce hypercall x86 ops for
 handling hypercall not in cpl0
Message-ID: <YTo/t4G1iI28oDmk@google.com>
References: <cover.1631188011.git.houwenlong93@linux.alibaba.com>
 <04a337801ad5aaa54144dc57df8ee2fc32bc9c4e.1631188011.git.houwenlong93@linux.alibaba.com>
 <20210909163901.2vvozmkuxjcgabs5@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909163901.2vvozmkuxjcgabs5@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 10, 2021, Yu Zhang wrote:
> On Thu, Sep 09, 2021 at 07:55:23PM +0800, Hou Wenlong wrote:
> > Per Intel's SDM, use vmcall instruction in non VMX operation for cpl3
> > it should trigger a #UD. And in VMX root operation, it should
> 
> Are you sure? IIRC, vmcall will always cause VM exit as long as CPU
> is in non-root mode(regardless the CPL).

Correct, VMCALL unconditionally causes VM-Exit in non-root mode, but Hou is
referring to the first fault condition of "non VMX operation".  The intent of the
patch is to emulate hardware behavior for CPL>0: if L1 is not in VMX operation,
a.k.a. not post-VMXON, then #UD, else #GP (because VMCALL #GPs at CPL>0 in VMX
root).

On one hand, I agree with Hou's logic; injecting #UD/#GP is architecturally
correct if KVM is emulating a bare metal environment for the guest.  On the
other hand, that contradicts with KVM _not_ injecting #UD for guest CPL0, i.e.
KVM is clearly not emulating a bare metal environment.

In the end, this would represent an ABI change for guest CPL>0.  While it's highly
unlikely that such a change would cause problems, maintaining the current behavior
is the safe option unless there's strong motivation for changing the guest ABI.

And injecting #UD/#GP would also mean KVM would again have to change its ABI if
there is a future hypercall KVM wants to allow at CPL>0.  Again, that's unlikely,
but again I don't see sufficient justification.
