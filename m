Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393FA485798
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 18:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242498AbiAERqk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 12:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242486AbiAERqj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 12:46:39 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AD8C061245
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 09:46:39 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id x194so12916086pgx.4
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 09:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kukafVx7055r8OcVvqLzxD7DUbrJSCUpCeX5KLtoe+4=;
        b=M22wNw8Ag6nNk/CCBGok616/uNIatExoP5zvfwTiJeJtGC2X3te82k04ifGULNQ3dp
         IZ4GhWDyehtar1ZxQFtOxwSG8KAlWvmeXwjL6IY8Gb8Mn8eME+l2Hyulw+6BxhXt42W7
         +qejfmnhDbh0fUwK+gbY0pixmm2l+xJpl25CMXciNAtSMgkp1tukQUcbPhy7scSIgWD2
         SQS/T21VRKmUgxTk9w9vC1fmO43KqNuVNk2I+ZJHRW52d/TnCNw/g/tcxktjrfUTFoIi
         7XfxeMEqeMCa1YRMk7r3X25peeefoYjMqrKApr5ZDbe8NPtESx0BhWHg+/d+qjnEKxbL
         IGOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kukafVx7055r8OcVvqLzxD7DUbrJSCUpCeX5KLtoe+4=;
        b=uhyKmndyPnBPHeLXnI7+Qu4lGCEpw57bM85EkW2d7quF17kiXq6CgnwD+UPvfo5jlP
         Jy7TM3qIdMWr6eWGmc8O0q0OO52rgjTTj7ORZ7rJrTcVOKOtsKt6TcbzFTQA/9Gtb+9n
         IkEQWeFfWEVX7CLCpYLt+1TbPKdC48dcKgXGUbnVcwBn2LGq+DH4IUvUYq1jXJ8dm3u9
         vsMeaX4gRI9tBK6AqEzKrUrO8hWByg3SWhxDPyQNWJ8iyvXQetZnWIGn2AKTPT5luz9r
         z1tJn23EkjV3IXTiiB/NFofQ/fXBuVmWETlJNc/4qYb9Ia0oTwtgYhNj1aUl2LOdd67P
         SD4Q==
X-Gm-Message-State: AOAM5312srhfd8SZdIF0m6bxkgPBI+bET+HPBArU0lXW5H21KzrQ+eHs
        H0uu9XKdXkKvMvShZz8Fox3VRQ==
X-Google-Smtp-Source: ABdhPJyFwjYQf5hPBRwiSxtXmUuk3gBK75txy6WOHVYaJF2EbPU3M40gOP5ibeGVz1vFJzTc/ztwbg==
X-Received: by 2002:aa7:88ce:0:b0:4ba:efec:39e0 with SMTP id k14-20020aa788ce000000b004baefec39e0mr56680934pff.80.1641404798687;
        Wed, 05 Jan 2022 09:46:38 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l2sm45836425pfu.13.2022.01.05.09.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 09:46:38 -0800 (PST)
Date:   Wed, 5 Jan 2022 17:46:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 2/5] KVM: SVM: allow to force AVIC to be enabled
Message-ID: <YdXZeuCKo58t3kD5@google.com>
References: <20211213104634.199141-1-mlevitsk@redhat.com>
 <20211213104634.199141-3-mlevitsk@redhat.com>
 <YdTJPTSsM1feVwt/@google.com>
 <dd7caa75ae9aef07d51043c01f073c6c23a3a445.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd7caa75ae9aef07d51043c01f073c6c23a3a445.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 05, 2022, Maxim Levitsky wrote:
> On Tue, 2022-01-04 at 22:25 +0000, Sean Christopherson wrote:
> > This is all more than a bit terrifying, though I can see the usefuless for a
> > developer.  At the very least, this should taint the kernel.  This should also
> > probably be buried behind a Kconfig that is itself buried behind EXPERT.
> > 
> I used 'module_param_unsafe' which does taint the kernel.

Ah, neat, TIL.  Thanks!
