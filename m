Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEF144DE6A
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 00:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbhKKXVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 18:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233659AbhKKXVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 18:21:44 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52224C061767
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 15:18:54 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id y1so6931484plk.10
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 15:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+nKH7Jq3NhdojnXvW4tSs4Y1mW4omOFE5WjvvSn/QaY=;
        b=I71bHlbQUhfwehM8/SoRzotkYdMbLUDdbrA0MiFSXN+xlvotJKaZtDnt7V12t9sslN
         um32cxesImgEOA4PaEPF1+qS3ikzl75FWY0zfizWeAvkXVNKwnQXw8XxyV/kruDjc4tz
         mpDX76rp7J+/TFUL4yfOB4bmJZF2qBiXejsuiF1D7QxFKHaF9ZVm8nNI4T+lwcG/LUWV
         opHzuqSEJ+RdN29wXNShJvHOLh5wAtzMu57LLAeM0RNzJHlQPbcXVRwfPO70Hso+zsKw
         uhtVLx8zXcdPKcQLdu08TY46m0aQzn58fs0hLPCVA2PLGqGzzrYC7riajTqqmIleohUC
         zfBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+nKH7Jq3NhdojnXvW4tSs4Y1mW4omOFE5WjvvSn/QaY=;
        b=qMjJ8JbNYI8xR8gX6aR+dpziH5X1tB7TvU6xdq4OXSFeRjZcZrJbI5pHbaBdBhvY37
         FGfx9ZXD2OOuLiHghdGwYeOm3DH3M8I63w8UNA+qiykxiSuw7xW8DzX9SQPenb9eMsal
         Xqtml1DQ0PAsiFxlF9zywi/ZBKX76MSk5AeXUohCL/JsHjf+cvFhlIZ3YYxuzBYCPR/d
         2hoZ379LfmL81lLgEIuJRXDmMtQHz0kDQPW9QY9K1loQTM2vV8+ReExZfWGtM5WB14F8
         GDcmB8MpvrTPhGxNAow503O40LgNit9295TmLxT029p4i8rLBAUAdgjlJSqpV2dwJmGV
         jl4A==
X-Gm-Message-State: AOAM531wAS2iqi2p/aYOgcLTfQOUqnORWJhIJ5ffhb9VKPFkXwQUvX9b
        BMhuposVNuPYe4BJzzQm2ezc+w==
X-Google-Smtp-Source: ABdhPJz2o2C+7XQx4Gb6IYiglolaPY8Msws8BYacdvjrJxiyEhBfppRRfzHavmUxB66jqMYJDw8njA==
X-Received: by 2002:a17:902:f092:b0:141:ccb6:897 with SMTP id p18-20020a170902f09200b00141ccb60897mr3090951pla.89.1636672733617;
        Thu, 11 Nov 2021 15:18:53 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b19sm4491094pfv.63.2021.11.11.15.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 15:18:52 -0800 (PST)
Date:   Thu, 11 Nov 2021 23:18:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Update number of zapped pages even if page
 list is stable
Message-ID: <YY2k2VdRuYPZI/xO@google.com>
References: <20211111221448.2683827-1-seanjc@google.com>
 <CANgfPd98+K-ELe0eAN0d+eqFjSa6ypOOP3MDb_nSwfrCZzpdCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd98+K-ELe0eAN0d+eqFjSa6ypOOP3MDb_nSwfrCZzpdCw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 11, 2021, Ben Gardon wrote:
> On Thu, Nov 11, 2021 at 2:14 PM Sean Christopherson <seanjc@google.com> wrote:
> > Fixes: fbb158cb88b6 ("KVM: x86/mmu: Revert "Revert "KVM: MMU: zap pages in batch""")
> > Reported-by: David Matlack <dmatlack@google.com>
> > Cc: Ben Gardon <bgardon@google.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> 
> While I can see this fixing the above stall, there's still a potential
> issue where zapped_obsolete_pages can accumulate an arbitrary number
> of pages from multiple batches of zaps. If this list gets very large,
> we could see a stall after the loop while trying to free the pages.
> I'm not aware of this ever happening, but it could be worth yielding
> during that freeing process as well.

Ya.  I tagged this one for stable because its very much a regression that I
introduced when reverting the revert, i.e. the very original implemenation worked.
Sadly, I did not get to do a triple revert :-)
