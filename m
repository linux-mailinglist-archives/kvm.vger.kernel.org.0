Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6BC38CF7B
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 22:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhEUVAB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 17:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhEUVAA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 17:00:00 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A97DC061574
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 13:58:36 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id d3-20020a9d29030000b029027e8019067fso19196123otb.13
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 13:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uOZT2Ou5tObhOBCDNOWWA/rpw5kE2+A9ovvTsmzCKFE=;
        b=q6BKxyiTMSs0PrH5oSzdVILV9hDktAmcKvYnuBToYdHD1QuTGpjOcy8pcZiOFJDofN
         xypCXUsAO9HGyxC4JiQlWSYmztJ79mx8KpMzOBerG3HafxqhpGXJhYHeo9jg64063uuc
         i5AbBPsX5zukvtms88BjitQhqnxg8Lzl/T6YRKk8P72wYFa37CJOvVLp9pXAvT8SsF/A
         o1oxAQUtiERLdgTjuqrRgfnb6peNfTx9aTYOhYbXDHCE54MIhxLiy0FBiIsyKxcA3OA+
         eR3z4Z/zIcn8t6ojqUjLL7czEJZVGQ1dr0ZBXlcxDgZHWEP2lmxQ1VbOvn1hmwaLbQfk
         kuTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uOZT2Ou5tObhOBCDNOWWA/rpw5kE2+A9ovvTsmzCKFE=;
        b=QXTHC0CXfUQkqETuf13yDKXOp5I5qCm747j6Vsk+eDQzY1ol9WV7dK6DJjGf5uFiiW
         d8DDNok/UuRQU1RytM1EeCGhrgXb1oodijLN1ix+0RHrBQGf8Ty7eJRDIqGeACJbeUQ6
         JqZFR08FrwUczgCrpja/jyS0r8J/yCoor7krpcvQlGjosVSknUfqf5QBB8r6guN8mh32
         I1YuOVaAgXFLvDDSURbfE7ZHAF15h5h1J8z7XSeZ8NXZaZ7UxMdMj949S4za6J2Nl9MQ
         pwXZ5HZzgxLMyFVnWGkrlB7Xmydf5y2JhabmXoAqzO07a+mqmyKA8lSsOkiflhOtN2iY
         FEbA==
X-Gm-Message-State: AOAM530XgNCBQjjoCf0j9CfNjj1Sxz9ynzjg0ssTlGDxqSJomcC1MEtU
        SlxVMMvbz8dkgUKd1jR9IHdwkLSTQKfhL+5VnkIT/RUTJ1o=
X-Google-Smtp-Source: ABdhPJz43aUqmxNKLHB8T2m+OyxCPGWuzF54C1dSdNGXoLEJais/r9JBa6glP49U4DBuSdCxwNuuk7t+f0o/Z0dbusU=
X-Received: by 2002:a9d:5786:: with SMTP id q6mr10115227oth.56.1621630715374;
 Fri, 21 May 2021 13:58:35 -0700 (PDT)
MIME-Version: 1.0
References: <20181031234928.144206-1-marcorr@google.com>
In-Reply-To: <20181031234928.144206-1-marcorr@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 21 May 2021 13:58:24 -0700
Message-ID: <CALMp9eT-tKmt2nFy4eQ0bfLqHrZd9EruQ45p=AsR2aPWnj97gA@mail.gmail.com>
Subject: Re: [kvm PATCH v6 0/2] shrink vcpu_vmx down to order 2
To:     Marc Orr <marcorr@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <kernellwp@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 31, 2018 at 4:49 PM Marc Orr <marcorr@google.com> wrote:
>
> Compared to the last version, I've:
> (1) dropped the vmalloc patches
> (2) updated the kmem cache for the guest_fpu field in the kvm_vcpu_arch
>     struct to be sized according to fpu_kernel_xstate_size
> (3) Added minimum FPU checks in KVM's x86 init logic to avoid memory
>     corruption issues.
>
> Marc Orr (2):
>   kvm: x86: Use task structs fpu field for user
>   kvm: x86: Dynamically allocate guest_fpu
>
>  arch/x86/include/asm/kvm_host.h | 10 +++---
>  arch/x86/kvm/svm.c              | 10 ++++++
>  arch/x86/kvm/vmx.c              | 10 ++++++
>  arch/x86/kvm/x86.c              | 55 ++++++++++++++++++++++++---------
>  4 files changed, 65 insertions(+), 20 deletions(-)
>
> --

Whatever happened to this series?
