Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04A254ABCB
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 10:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354291AbiFNI3T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 04:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355599AbiFNI2q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 04:28:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9633B3B561
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 01:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655195324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KByEBSgeM4obm3XP5zIe1UTexQSKb/lcAH9UJiuFrIw=;
        b=VJx5DdY1w5aImPc2rtTc8czfc8DRw5rnYeEm856KnSfrJpqD2HfMVwOj3+90ACWnu6nwZl
        Cgf0u2jEnyDxLilYYA4ojAno4Qz2TAUgoRT2cRSkbeAOdV9/MwB1WxAgQw6OVqXeWLunXQ
        Y58j5UUKamcgxe33a14yGErlugNulwg=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-m1F7fpccNX-yK1UZv0-C-w-1; Tue, 14 Jun 2022 04:28:43 -0400
X-MC-Unique: m1F7fpccNX-yK1UZv0-C-w-1
Received: by mail-ej1-f70.google.com with SMTP id x2-20020a1709065ac200b006d9b316257fso2576031ejs.12
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 01:28:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KByEBSgeM4obm3XP5zIe1UTexQSKb/lcAH9UJiuFrIw=;
        b=3cFTlc622XQXdtvpN+F/Rwm91y9d4a3I37ah7h9iEHW8xVFuZixa9lz4x0HC8bB0+u
         n0hgywqy6fnXzKmmOSfeMLrpgTARq+n9yJPNCG65rmjb9h0ah6tdbE8QlYVxT0issO9r
         9JFEkUnFC0z7MJn3KpG94K3ij6pE/WZw9F9kXgmg9Oq+vwCEAJWM9bofz97US5u2RoTE
         PGsqlFpvEbGG5WAN1FYbMaokCI+LfyWo2Vwl8N4ifUBcPXLttz5cFKrEPhICZAPoRwwV
         2hlO0zVGrD9qGMGlFuK+i3evMu4t+ghDvVItF6xpfAeaRCmqoTg5DYMTHtBPPaV+9ldC
         HpVg==
X-Gm-Message-State: AOAM531dFbZzUlgnkD3OJSdMAE8ZznNKKu62T9udR76Y6Xsy1s4L8/MI
        jS8QaNW6/NLQnsNptulrEHNKfK5xU/9b7R+KIZP8BhiumR+f00I7x3NnGJRqKg9DOKrrx+m823V
        4n5hkmbpe11Ct
X-Received: by 2002:a17:906:51d6:b0:712:c9:8a1b with SMTP id v22-20020a17090651d600b0071200c98a1bmr3307718ejk.656.1655195322085;
        Tue, 14 Jun 2022 01:28:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDLxiVy9ewakvDf7UcsKF/XgtCeL1lKugQaZWmd6BWzHidp+NQWZiN7h5adae5T4y9GLP1Mw==
X-Received: by 2002:a17:906:51d6:b0:712:c9:8a1b with SMTP id v22-20020a17090651d600b0071200c98a1bmr3307700ejk.656.1655195321888;
        Tue, 14 Jun 2022 01:28:41 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
        by smtp.gmail.com with ESMTPSA id zj11-20020a170907338b00b006ff0fe78cb7sm4751566ejb.133.2022.06.14.01.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 01:28:41 -0700 (PDT)
Date:   Tue, 14 Jun 2022 10:28:39 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     shaoqin.huang@intel.com
Cc:     pbonzini@redhat.com, Shuah Khan <shuah@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Peter Gonda <pgonda@google.com>,
        David Dunn <daviddunn@google.com>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Remove the mismatched parameter comments
Message-ID: <20220614082839.a5iqpk4td2allbwu@gator>
References: <20220614224126.211054-1-shaoqin.huang@intel.com>
 <20220614074835.qto55feu74ionlh5@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614074835.qto55feu74ionlh5@gator>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022 at 09:48:35AM +0200, Andrew Jones wrote:
> On Tue, Jun 14, 2022 at 04:41:19PM -0600, shaoqin.huang@intel.com wrote:
> > From: Shaoqin Huang <shaoqin.huang@intel.com>
> > 
> > There are some parameter being removed in function but the parameter
> > comments still exist, so remove them.
> > 
> > Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
> > ---
> >  tools/testing/selftests/kvm/lib/kvm_util.c | 3 ---
> >  1 file changed, 3 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 1665a220abcb..58fdc82b20f4 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -1336,8 +1336,6 @@ static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
> >   *   vm - Virtual Machine
> >   *   sz - Size in bytes
> >   *   vaddr_min - Minimum starting virtual address
> > - *   data_memslot - Memory region slot for data pages
> > - *   pgd_memslot - Memory region slot for new virtual translation tables
> >   *
> >   * Output Args: None
> >   *
> > @@ -1423,7 +1421,6 @@ vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm)
> >   *   vaddr - Virtuall address to map
> >   *   paddr - VM Physical Address
> >   *   npages - The number of pages to map
> > - *   pgd_memslot - Memory region slot for new virtual translation tables
> >   *
> >   * Output Args: None
> >   *
> > -- 
> > 2.30.2
> >
> 
> Hi Shaoqin,
> 
> Please check kvm/queue, the extra parameter comments have already been
> removed.
>

Eh, never mind, I looked at the wrong functions. Your patch does indeed
apply to kvm/queue and is indeed necessary. Sorry for the noise.

Thanks,
drew 

