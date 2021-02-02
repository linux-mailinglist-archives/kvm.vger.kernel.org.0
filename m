Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD1330C9D9
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 19:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238658AbhBBSau (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 13:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238675AbhBBS2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 13:28:33 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2F0C06178C
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:27:34 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id v19so15426131pgj.12
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SC3rKuGVWGUhGIOfG1ib7Xm/x7d+KrijGRV0dEv5seE=;
        b=jhojw4GTwHhDsFg3m7iA8QIEZgvPBDxG0go35LBsSKrcZvgGJOrwLlkEwuFf1WBGeE
         H5nMd72cFUBRhwFktDi4uAhRobOFDMNbs7u/Xm7n3NwiOMKPDEph4rwYMibzP9vztbPt
         ydRFureZbxp6F2B7Cl0zKpfWEOHQ3Ckzo+MPm2wvHXKmnWoWnWE0mawj9WZuWkw6PPZU
         dHBomOfRAxbi3dk148ukbtmI7kf/Aqbe3kQxI4EL3QN4jqL4JBW8QvrTM6KVw/yW0yqo
         Bc6BuaaSckaAsws31mGM58ztCN4Ik0gwBOQv1rXOEJScfbgj+yaQfmsx8hUTlM7/Ui6S
         16Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SC3rKuGVWGUhGIOfG1ib7Xm/x7d+KrijGRV0dEv5seE=;
        b=uJkst2TgTq6Y9HmuDhMHERwTfMHfrxwob3iLBFxn6TJETcajAfP58ASkduxl9Ib3Lo
         JeeBDkltalaxx/W00s9bPyobcrNqYKykTplbvMeaiRu4THlh3c/7VPjPoo6HyP+nKwsf
         KHKQxnpic4hAYKDaJShJgLFglxNd/lYgKzfa59HFya6upAgX4cetIL7uzTu4xUhLK+PX
         OjZI3KFVpcMPYeV9RMv+4yfaw+dhQHxeio0H/fUd2csXz37VQ5UpgVMAcoLwviWQDE+k
         MPfDZFNeUeZ1XPGf3V9h9xoftK2HdpAF54PdvCu1VThE+QCVAkIBK8aI/5jk2m5FWwmw
         AUpg==
X-Gm-Message-State: AOAM532TY8JBn5saXW72Gi7FfaYXv/1sFDCumOvw/ReY5u6U8Z5c9BFb
        XcN/9Ssi/RhaeFbDK5pqd/dJiz77nluXmw==
X-Google-Smtp-Source: ABdhPJzOjK4GFjSpShw4k9iAWSxnQGb31YkPiR67M3ngvzaER0BWAtZq0Mv4wdUu4ZwnIYB2XCBxMQ==
X-Received: by 2002:a65:4101:: with SMTP id w1mr11491494pgp.323.1612290453602;
        Tue, 02 Feb 2021 10:27:33 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1bc:da69:2e4b:ce97])
        by smtp.gmail.com with ESMTPSA id y67sm21976222pfb.211.2021.02.02.10.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 10:27:33 -0800 (PST)
Date:   Tue, 2 Feb 2021 10:27:27 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: cleanup DR6/DR7 reserved bits checks
Message-ID: <YBmZj0uukimn3G7E@google.com>
References: <20210202170246.89436-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202170246.89436-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021, Paolo Bonzini wrote:
> kvm_dr6_valid and kvm_dr7_valid check that bits 63:32 are zero.  Using
> them makes it easier to review the code for inconsistencies.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 97674204bf44..e52e38f8c74d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4414,9 +4414,9 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
>  	if (dbgregs->flags)
>  		return -EINVAL;
>  
> -	if (dbgregs->dr6 & ~0xffffffffull)

Oof, you weren't kidding.

Reviewed-by: Sean Christopherson <seanjc@google.com> 

> +	if (!kvm_dr6_valid(dbgregs->dr6))
>  		return -EINVAL;
> -	if (dbgregs->dr7 & ~0xffffffffull)
> +	if (!kvm_dr7_valid(dbgregs->dr7))
>  		return -EINVAL;
>  
>  	memcpy(vcpu->arch.db, dbgregs->db, sizeof(vcpu->arch.db));
> -- 
> 2.26.2
> 
