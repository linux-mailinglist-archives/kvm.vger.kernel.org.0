Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4706F35FA22
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 19:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351370AbhDNR5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 13:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351282AbhDNR5z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 13:57:55 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34EAC061756
        for <kvm@vger.kernel.org>; Wed, 14 Apr 2021 10:57:33 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id o123so14264306pfb.4
        for <kvm@vger.kernel.org>; Wed, 14 Apr 2021 10:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bAj/sTVeT3EOEooCD0PWAEK0DFdv0I+bmfSZB33mtXg=;
        b=YKlFCQU3jURALAoms83ymQ5gvp6uDIeOmXii2ecYlnaY3CnAEQDKyFe11bMpij/ofF
         bvcE6c0NQt8C52+fZhUpCcVnJ56ADwd3GERCw21jztW8ge7H6iLIBzEFVgznlUdxw7pO
         GnB2RNc+cUijVVBbHPc7yLqNlFJ0AMoPT8e7fYGjW9FbSCPVJ1tcmkf670aGeGhzLbfn
         G7uKAmN10uawEXHZM3WXgk4wuHT9TNL3FcnnsWId9Lb1R0zD2t6EvnECYZh87Y/ILFFp
         hF4BFmzeV/oh2/ylAWDVPXzudMJtVFR4Jeu2zXoaWZZYomQ6zGjEFAKEctcmfEEhgTAR
         Li3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bAj/sTVeT3EOEooCD0PWAEK0DFdv0I+bmfSZB33mtXg=;
        b=Xz2rHrt9a7biFUHo1wJSRcnLuk6xyo94jwrz/shxY6+BorETzyBxvdVg5lzqeCPk3a
         77zhjuOXs5JYXRN0NhmItxglz9tFSE7r5IjcY7Rz9xqeT+U5tBjThgwPw6W5PPW+Db27
         yUwrBaxMU9cCbbpKAfLRDlqEoyu8qQJrsIyCewSg8uRv9t2jbF8WyMDjzmtz/Dtftye4
         /k/XUy9xsGG9pSvzn579n4rzfZ2aWuGFKe8RyYQpX7QRSA9DKtQm1tNoNHnASv3vIxkV
         a1OKF0Via2upSnYDR3PXTadysu4ilbo9y2lre469sEwgux9mzqI5rPPJ+GD8OiPoxbUA
         rkLg==
X-Gm-Message-State: AOAM533BWe3VenbiFCZyDEcUVB9XjTIzjuWFyF1eSCF6bEnGuagU0NoJ
        DUzYBpzGBnelFi9yh2yLkAQXdg==
X-Google-Smtp-Source: ABdhPJw2RarwNWS5+8HnwKiSHGAsEixnrKltiKCAYoveloZrH9siPOcI5DSj1R2t10EAC+2caMUGjQ==
X-Received: by 2002:a63:c60a:: with SMTP id w10mr37908204pgg.421.1618423052870;
        Wed, 14 Apr 2021 10:57:32 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id r26sm110056pfq.17.2021.04.14.10.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 10:57:32 -0700 (PDT)
Date:   Wed, 14 Apr 2021 17:57:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [RFC PATCH 0/7] KVM: Fix tick-based vtime accounting on x86
Message-ID: <YHctCJDfeTq4zCVn@google.com>
References: <20210413182933.1046389-1-seanjc@google.com>
 <87wnt4vkij.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wnt4vkij.ffs@nanos.tec.linutronix.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 14, 2021, Thomas Gleixner wrote:
> On Tue, Apr 13 2021 at 11:29, Sean Christopherson wrote:
> > This is an alternative to Wanpeng's series[*] to fix tick-based accounting
> > on x86.  The approach for fixing the bug is identical: defer accounting
> > until after tick IRQs are handled.  The difference is purely in how the
> > context tracking and vtime code is refactored in order to give KVM the
> > hooks it needs to fix the x86 bug.
> >
> > x86 compile tested only, hence the RFC.  If folks like the direction and
> > there are no unsolvable issues, I'll cross-compile, properly test on x86,
> > and post an "official" series.
> 
> I like the final outcome of this, but we really want a small set of
> patches first which actually fix the bug and is easy to backport and
> then the larger consolidation on top.
> 
> Can you sort that out with Wanpeng please?

Will do.
