Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64489462804
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 00:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbhK2XRr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 18:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbhK2XRP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 18:17:15 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA46C04CBFD
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 15:02:24 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id o6-20020a17090a0a0600b001a64b9a11aeso15508846pjo.3
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 15:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5a51HHAlmvwZ4louf7BpP5Hqt9OEE3aP2v9d9QqHJnw=;
        b=qPA3DIaq0Od5zGgLMz6HGxg69fH0WykvmkLJ26uaFu5vMfq9pEM7FgFFsfn9L9l5kW
         +dEFj2wPl44m/4dZeGBQo9eOSSUjqw4OO0Q1zwgiqDR5q4qeJgxlBsu1aeGW7PU+Cxwq
         OVFEyN8br4Xp11RmWfMkG70pdZAuYwAFvTGiQKScgcAgga02bf3q2Zdurssf/KUZ3ql8
         dwJ3j5YeyfuECdMJMdtwYWJhxXRaK9NCIW0RUUV1CHO6c4zqHMCRlLlizaYS8N1p/c2c
         WfhaM5hhpYzQcZFDLEb2MoZALBn48kWkBuL2P96yJnzP50sp5RgnT1OOnURiUSoYjYYr
         Q/PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5a51HHAlmvwZ4louf7BpP5Hqt9OEE3aP2v9d9QqHJnw=;
        b=k1HJX/U3meUBnbQXpUDxP/bUILEX3+xchX3acBLwY/jnveHQUxrLiNLVjdWEBzzttk
         zev89bAWfwZEePGwQSNyTraXDiazNJmzoohFI4hiVQWLc5PhEX0Z0qBKnSQIbOBRpUUm
         C+GeA+c88p99leu/oox1ortBBLv1KSRZbYDEYB5npnSHrInn34W3pagekvlqNcJknfJ8
         HTVw7BPf9DNUz87ssJUvxIq/UgLoJCqXJOEFt9tdGhiZJNkZ74UZlQSgWw0/igJzBYuR
         e+a1+Q3/AFSEkY5HXaKOWnn841JBsr1pcshfghK93H4oITGGvofJayINd3kEO4Wwv5Oa
         GlAQ==
X-Gm-Message-State: AOAM533v4582n6zcNUpJqDG3NsYTdJatGPmIdgg8LgVczJ98M7UJl7Gi
        soVJvn2DeK/1Bo8dqTtyLyYOjg==
X-Google-Smtp-Source: ABdhPJxDc4fdjeNo5wWaUGcPMMZWT+SnSRyS+vg4m56zi4TAQ897Pj2YLa27yLnYP9WB9IFG/oWe5g==
X-Received: by 2002:a17:902:b718:b0:143:72b7:409e with SMTP id d24-20020a170902b71800b0014372b7409emr62235145pls.28.1638226944014;
        Mon, 29 Nov 2021 15:02:24 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v13sm19657612pfu.38.2021.11.29.15.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 15:02:23 -0800 (PST)
Date:   Mon, 29 Nov 2021 23:02:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pgonda@google.com
Subject: Re: [PATCH 07/12] KVM: SEV: move mirror status to destination of
 KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM
Message-ID: <YaVb/B9gmLTIM19q@google.com>
References: <20211123005036.2954379-1-pbonzini@redhat.com>
 <20211123005036.2954379-8-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123005036.2954379-8-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021, Paolo Bonzini wrote:
> Allow intra-host migration of a mirror VM; the destination VM will be
> a mirror of the same ASID as the source.
> 
> Fixes: b56639318bb2 ("KVM: SEV: Add support for SEV intra host migration")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm/sev.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index dc974c1728b6..c1eb1c83401d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1616,11 +1616,13 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
>  	dst->asid = src->asid;
>  	dst->handle = src->handle;
>  	dst->pages_locked = src->pages_locked;
> +	dst->enc_context_owner = src->enc_context_owner;
>  
>  	src->asid = 0;
>  	src->active = false;
>  	src->handle = 0;
>  	src->pages_locked = 0;
> +	src->enc_context_owner = NULL;

Ah, since this is effectively transferring the kvm_put_kvm() "owner", I definitely
think a refcount on the number of mirrors is the way to go.

Reviewed-by: Sean Christopherson <seanjc@google.com>
