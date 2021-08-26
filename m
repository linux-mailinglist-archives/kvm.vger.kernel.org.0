Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850083F8DC5
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 20:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243228AbhHZSWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 14:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbhHZSWF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 14:22:05 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACA3C061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 11:21:17 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id w7so2618716pgk.13
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 11:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ikh4nw6GQUFaIaUFygN35ys+PxM12rR1q0Xpov8w4z4=;
        b=FkDZtcV4x0upZJ5pGiwBa4oNw0Kn5WMWZUOe2sNuNPhI1+xJcU9EInTWdIVaBftZ5p
         V3T1ewSvUDpfhZpKu6sj+kB6whTol2OApF8uMaEhk4bKXPS9SO5LOOjhdJmlNvobVAQV
         eGoeeMxLTGZ/EfvQgqrAcS+y3LZ7/QbF1WljIaO3cFF7q6+9ruTJExO7jJsmXFR9fR0f
         EVyz9sRl1k4x1CqgCisxC5plkPDDQqvo6ZfBvmEWLZIu+6OUvM+TapIQ1TZ8uqYIN5gu
         O6L6RacrlPTBlQ6CrzhZsLmhRphVXe1vsOi9yvaJPRwlYiXp0yBCkdAtwyr9SvQ3KEHe
         PD4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ikh4nw6GQUFaIaUFygN35ys+PxM12rR1q0Xpov8w4z4=;
        b=AVtNkkyA9ubgLYt9+G6EFPpkcMz3nuWX7nn2wNC3h+N5AgXnX4AyqjkRzTHjQ4c3uP
         P1QrXqMiKoqLy3y9QzZ8gScwGNOwVuic6SpydKn6BZPXZOt9Jm/N6JKccPqGS+67oSzE
         3/1TNTHLmalM13B8Z4fl2epDrjIESwTg7Y65L/3m3DzoEiUoe5hnSUxI9Mzvs2oUOUv5
         EGU4Y7bZX+LilT2Y94JLEw2Ekdbsv28WoGc1zHF+IrBpQYAvRjkbl9uQiK6aCpfQzkNs
         PAyPJHIyuRD57ybuRh6vnvz1DHbe0x+Dijd3T/99jm6hPGLdPo7FnzU3uMHhf+nRG5Iv
         rAwg==
X-Gm-Message-State: AOAM532pli0jxnszQsmfVTjfit5U0xm/EaZsaWRcNmeI3c977d+qlJxV
        8IljENzgXLFHAuJ+NflvtGxOUdO1a5/ZTA==
X-Google-Smtp-Source: ABdhPJxhwGU2kdvYHc9DW3srhKR/tUQ1naENWXcs8OcDjfwn+ZiiI2NhGYMdQFwMVV+99ko8HJYm+A==
X-Received: by 2002:a63:4cd:: with SMTP id 196mr4435440pge.239.1630002076943;
        Thu, 26 Aug 2021 11:21:16 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a2sm4363174pgb.19.2021.08.26.11.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 11:21:16 -0700 (PDT)
Date:   Thu, 26 Aug 2021 18:21:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Bill Wendling <morbo@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 0/4] Prevent inlining for asm blocks with labels
Message-ID: <YSfbmPmlGcCM1TPL@google.com>
References: <20210825222604.2659360-1-morbo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825222604.2659360-1-morbo@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021, Bill Wendling wrote:
> Clang may decide to inline some functions that have inline asm with labels.

For all changlogs, it's probably worth clarifying that they have _global_ labels,
e.g. local labels within an asm block are perfectly ok for inlining, as are local
labels in the function (but outside of the block) used by asm goto.

And maybe add a "#define noinline ..." to match the kernel and convert the two
existing uses in pmu_lbr.c as a prep patch?

> Doing this duplicates the labels, causing the assembler to be complain. These
> patches add the "noinline" attribute to the functions to prevent this.
> 
> Bill Wendling (4):
>   x86: realmode: mark exec_in_big_real_mode as noinline
>   x86: svm: mark test_run as noinline
>   x86: umip: mark do_ring3 as noinline
>   x86: vmx: mark some test_* functions as noinline
> 
>  x86/realmode.c | 2 +-
>  x86/svm.c      | 2 +-
>  x86/umip.c     | 2 +-
>  x86/vmx.c      | 6 +++---
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> -- 
> 2.33.0.rc2.250.ged5fa647cd-goog
> 
