Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 935DD4F6A27
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 21:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbiDFTnj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 15:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbiDFTnG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 15:43:06 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D572C49A3
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 10:59:07 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id g21so3850529iom.13
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 10:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uzEOiJ6yDVmM4HwbN1L4uOpeHV1JQRyCSJYZVvMlr1o=;
        b=motzZ0l4IuCGRfjFIbn/j/l6b/79dg82LGotCDSKTUlBOlU79sQkFVQlJY/zgNuuGO
         qrc6E+V7IDoo1WNAtR9oz02dK3FVRHsx6cwF+L0lbfMjdJbKqLzRmKJQQOFZ/18+f9Wv
         ywS3sVrMYOheluSEb1K9sTiCJQi1PCOVm+iFMXiGqwXKzB1W57TZgXccUUBHE71bGQif
         aJFn1HhosoMK2BV6YkjK9rprCz8cEHwbJgky7RalXATFkXLSHLjc4fG7u3xTBzdIurXC
         kyyZrWzB34DR1pRnhgCsaopxNoUTmGkQ6d0llq+91D1FtRqZAS+HSJMP4ZQUhGkhYe1h
         MRRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uzEOiJ6yDVmM4HwbN1L4uOpeHV1JQRyCSJYZVvMlr1o=;
        b=ZhUHa5vuSw/qaMILjO2e+w5YBGyA1eD4TdEcG8CijIoIcBQxSTkIg9vXXoQDzyji2q
         pvn0uezn5d5iWjV2NCrMJJIibXBb9xWkP8dvlgi9qR6jxhb4Pzr8fuVTBKCrlnmP+RPA
         kCOpeTHOiAZrHFstvuOPKG3wQ2TW+jLaUV4sH7EbfLeMhKPxhuhb9iFrNubT0Eg3vq+g
         LFi92BHjVEVpbPle9brrpg1LGI609Fyi+k0btkZUiEEcc1SXjsKEUCh0yXbOLGgE0VQU
         eoOP1PIa4bHDBIjYS/pwtJNCw41rqVyb8gsb9w13jB71+5370oXyHqjXb2EPOglISbr/
         iuNg==
X-Gm-Message-State: AOAM531Xs+lDYqDT/GYB1SMN6LXP4mzin0zolvp2F1rcD1YhQN6D/jgh
        ByUN0+sxUKYcuEtgNtyKd9OM1ix7zsA2/A==
X-Google-Smtp-Source: ABdhPJxLKN+3WYbccJPvru/x2ek/ZrRCnqaiXkp6CDMNszfPgh1LY5ykqVNoCgkQNqIn3Xt1jtTcLA==
X-Received: by 2002:a5e:c702:0:b0:64d:1640:9f8c with SMTP id f2-20020a5ec702000000b0064d16409f8cmr180542iop.176.1649267946850;
        Wed, 06 Apr 2022 10:59:06 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id t8-20020a056e02010800b002ca36a382c5sm6339873ilm.52.2022.04.06.10.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 10:59:06 -0700 (PDT)
Date:   Wed, 6 Apr 2022 17:59:02 +0000
From:   Oliver Upton <oupton@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, stable@kernel.org
Subject: Re: [PATCH v2 1/3] KVM: Don't create VM debugfs files outside of the
 VM directory
Message-ID: <Yk3U5tfqBQBOeSs+@google.com>
References: <20220404182119.3561025-1-oupton@google.com>
 <20220404182119.3561025-2-oupton@google.com>
 <87fsmqvgaf.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fsmqvgaf.wl-maz@kernel.org>
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

On Wed, Apr 06, 2022 at 08:10:00AM +0100, Marc Zyngier wrote:
> Hi Oliver,
> 
> On Mon, 04 Apr 2022 19:21:17 +0100,
> Oliver Upton <oupton@google.com> wrote:
> > 
> > Unfortunately, there is no guarantee that KVM was able to instantiate a
> > debugfs directory for a particular VM. To that end, KVM shouldn't even
> > attempt to create new debugfs files in this case. If the specified
> > parent dentry is NULL, debugfs_create_file() will instantiate files at
> > the root of debugfs.
> > 
> > For arm64, it is possible to create the vgic-state file outside of a
> > VM directory, the file is not cleaned up when a VM is destroyed.
> > Nonetheless, the corresponding struct kvm is freed when the VM is
> > destroyed.
> > 
> > Nip the problem in the bud for all possible errant debugfs file
> > creations by initializing kvm->debugfs_dentry to -ENOENT. In so doing,
> > debugfs_create_file() will fail instead of creating the file in the root
> > directory.
> > 
> > Cc: stable@kernel.org
> > Fixes: 929f45e32499 ("kvm: no need to check return value of debugfs_create functions")
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  virt/kvm/kvm_main.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 70e05af5ebea..04a426e65cb8 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -932,7 +932,7 @@ static void kvm_destroy_vm_debugfs(struct kvm *kvm)
> >  	int kvm_debugfs_num_entries = kvm_vm_stats_header.num_desc +
> >  				      kvm_vcpu_stats_header.num_desc;
> >  
> > -	if (!kvm->debugfs_dentry)
> > +	if (!IS_ERR(kvm->debugfs_dentry))
> >  		return;
> 
> Shouldn't this condition be inverted? It certainly looks odd.

Err... Yep, this is plain wrong. Let me fix this obvious mistake.

--
Thanks,
Oliver
