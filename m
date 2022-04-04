Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE2F4F1BA5
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380746AbiDDVV6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379723AbiDDR7Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 13:59:16 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3722B34BB9
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 10:57:20 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id y16so7444976ilq.6
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 10:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GmQMDW9Kl2RXHFpra8Cb+yFdRaCEgtk0WeuxWIun/PE=;
        b=T/YID3m7jqfMsZdI5yipTxP6mq1tBCIPkkaeRZEOGXJXCRTNAVRLgO6d3oGPKiaIsM
         hB1IuYXuYvxwGnm/jAntlYOH177EGDJShNXiQsKuSX5zmuTfztgeEwn8fCn3X5foUENF
         tSPmbGrEqNTLnjaKU1LnFelmOozabOJ/CJhjHjgSpIDgJsIVglglRlphqOF6I5tZB4fN
         RjXIJozATO4FyKzOy/3PbchB4/uuHz062rsh7sbqfMMWRA2/+03t3OuXgIyBsGiXxQuP
         s6lHlTJrjRufZd9tiwr5+a8oqSI3d98djdhUvx2xfaAT94UiQ2BSWSf8Or0aJ0TjXzUY
         Cssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GmQMDW9Kl2RXHFpra8Cb+yFdRaCEgtk0WeuxWIun/PE=;
        b=pQP1lZzFSbjd00Ei4gFqylUzj1VHncfVUDhzDSCQlrVeOY2UbMQjlbaaeyEezrrT6v
         RJbdx23H5GstkLB6lvo2DN/7KuW+fC0UAIzNf9gV5TZiCu1kmIx0dpyMOgG7a5FfAhPr
         USkh2GnmYxOb7h4IHi6m7NUyQ8Bv6/f1NP9tqZEsd1qaFEhgZ9cSV+KxWk7+L/nfVdxA
         5GLxI+grIhIxDtgVyM1fu5ZYWOmeFLndh4lbPc4SLFKTlH9aaEWPySCCKrTY/qfVRvyO
         iZER1qydLxf7x2+/pft9S9k2zQdQFOc0/tYd2k7U5aW3FTfFnZR3+X9/9gwNoKvMBFpV
         SjjA==
X-Gm-Message-State: AOAM532mM2s6QP4h6TZVeubMF3IQSLKcnL+hW63fCxh1wG/jcwjMrZZa
        jcRHX96ouQ/G4MqwKgKMG+iDfA==
X-Google-Smtp-Source: ABdhPJyxcxrXm46aKYYcD84LuHXVzCCX7Rui8hCXMmO19c75bw55+ZX3BLOKGyUKxAuIXD3PlAjPvg==
X-Received: by 2002:a92:3405:0:b0:2c8:70ad:fa86 with SMTP id b5-20020a923405000000b002c870adfa86mr483750ila.268.1649095039360;
        Mon, 04 Apr 2022 10:57:19 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id d15-20020a92d78f000000b002ca4c409d1asm1036438iln.83.2022.04.04.10.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 10:57:18 -0700 (PDT)
Date:   Mon, 4 Apr 2022 17:57:14 +0000
From:   Oliver Upton <oupton@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, stable@kernel.org
Subject: Re: [PATCH 2/4] KVM: Only log about debugfs directory collision once
Message-ID: <Yksxeo7IhzyFS8AM@google.com>
References: <20220402174044.2263418-1-oupton@google.com>
 <20220402174044.2263418-3-oupton@google.com>
 <Yksr6etwnN0iW8ZH@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yksr6etwnN0iW8ZH@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On Mon, Apr 04, 2022 at 05:33:29PM +0000, Sean Christopherson wrote:
> On Sat, Apr 02, 2022, Oliver Upton wrote:
> > In all likelihood, a debugfs directory name collision is the result of a
> > userspace bug. If userspace closes the VM fd without releasing all
> > references to said VM then the debugfs directory is never cleaned.
> > 
> > Even a ratelimited print statement can fill up dmesg, making it
> > particularly annoying for the person debugging what exactly went wrong.
> > Furthermore, a userspace that wants to be a nuisance could clog up the
> > logs by deliberately holding a VM reference after closing the VM fd.
> > 
> > Dial back logging to print at most once, given that userspace is most
> > likely to blame. Leave the statement in place for the small chance that
> > KVM actually got it wrong.
> > 
> > Cc: stable@kernel.org
> > Fixes: 85cd39af14f4 ("KVM: Do not leak memory for duplicate debugfs directories")
> 
> I don't think this warrants Cc: stable@, the whole point of ratelimiting printk is
> to guard against this sort of thing.  If a ratelimited printk can bring down the
> kernel and/or logging infrastructure, then the kernel is misconfigured for the
> environment.

Good point.

> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  virt/kvm/kvm_main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 69c318fdff61..38b30bd60f34 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -959,7 +959,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
> >  	mutex_lock(&kvm_debugfs_lock);
> >  	dent = debugfs_lookup(dir_name, kvm_debugfs_dir);
> >  	if (dent) {
> > -		pr_warn_ratelimited("KVM: debugfs: duplicate directory %s\n", dir_name);
> > +		pr_warn_once("KVM: debugfs: duplicate directory %s\n", dir_name);
> 
> I don't see how printing once is going to be usefull for a human debugger.  If we
> want to get rid of the ratelimited print, why not purge it entirely?

I'd really like to drop it altogether. I've actually looked at several
instances of this printk firing internally, and all of it had to do with
some leak in userspace.

I'll pull this patch out of the series for v2 and maybe just propose we
drop it altogether.

--
Thanks,
Oliver
