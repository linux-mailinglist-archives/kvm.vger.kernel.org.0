Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E3B545088
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 17:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344421AbiFIPTS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 11:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344451AbiFIPTF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 11:19:05 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE004B1FC
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 08:19:02 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id v11-20020a17090a4ecb00b001e2c5b837ccso26913971pjl.3
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 08:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wTdq1MpfqeaEs3uTSCeLsZfhQfEFbVtUVDZA72dHYVY=;
        b=qBsY/I3/F82alD68P8X+OLRta8tAqIZbD1PCcX2tcAHtC3jCOyy0UfxSsf9epYhhdO
         F2ESHgHk2msF/0p4riD46L6O3zNymLh7bJddNlnBmQCd78c+xt/c+pzf4nvan/0vU4EB
         KH1xU82N0zSToqT7ISm8kZAaEkGRHiJ1Lu/8t/VunfBydMdsIcoJDJ//BUJWo5bLN8vj
         HmglcwoCP9yQMGBGti0ev9w1xhEECNuVMNMU1htcVv0yF8pcth7PImv/vIKsnZNItKjy
         maKejGzGx9HL9JGnnFZ00NTidiOiMVap8kPLvUMy5YOyonFHPVSfZlomoDItQutHOxKa
         ej0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wTdq1MpfqeaEs3uTSCeLsZfhQfEFbVtUVDZA72dHYVY=;
        b=TK456hthcJBygoPhjysbQ80Nz1CVHlh9a7K15DT1u9AkkFVVH8z87dP1D/gJ4bSHCl
         wK2oOmgddlGleuaMAZslSK5zDiApNYN3knCLvHtWJJ+S3soz4uaKDnlAauuOGHcz1/lp
         lGquYFmVX1/rgACGuOl2SfeQl6mHYxLfLimzXamUA3lmIJu0O7clF5oBfo1M3OkX6D43
         gVQ+u//eax66VUWrhRaPjDbfSSXsypmarOEFWnWDkOcj+YwpONfTx78JCjc26vaH+Ov8
         GJH80n+6eIjBvRazBNmdzZZje50cwu4mWF6P0rC5mpviU3yvbnGsAmCoU0ghJIb0l2Tk
         Kt/Q==
X-Gm-Message-State: AOAM530fAynAR6x4bwJtZeN9SxrdiltYAURPAwwv6QwKoyAdr6oU/gKR
        EfWNbXW+UXh4ouP90KrbgQgXdg==
X-Google-Smtp-Source: ABdhPJwYooFWDaQWi2NjSXXQIYWroSCwZ87Tdf6uJWZOVPzmRSGktbNejTbz+Gp01XhHv8VDjeRObQ==
X-Received: by 2002:a17:902:f68b:b0:163:f358:d4ad with SMTP id l11-20020a170902f68b00b00163f358d4admr40639075plg.23.1654787941366;
        Thu, 09 Jun 2022 08:19:01 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q17-20020a656851000000b003f5d7f0ad6asm17975915pgt.48.2022.06.09.08.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 08:18:59 -0700 (PDT)
Date:   Thu, 9 Jun 2022 15:18:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org,
        anup@brainfault.org, Raghavendra Rao Ananta <rananta@google.com>,
        eric.auger@redhat.com
Subject: Re: [PATCH v2 000/144] KVM: selftests: Overhaul APIs, purge VCPU_ID
Message-ID: <YqIPYP0gKIoU7JLG@google.com>
References: <20220603004331.1523888-1-seanjc@google.com>
 <21570ac1-e684-7983-be00-ba8b3f43a9ee@redhat.com>
 <93b87b7b5a599c1dfa47ee025f0ae9c4@kernel.org>
 <YqEupumS/m5IArTj@google.com>
 <20220609074027.fntbvcgac4nroy35@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609074027.fntbvcgac4nroy35@gator>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 09, 2022, Andrew Jones wrote:
> On Wed, Jun 08, 2022 at 11:20:06PM +0000, Sean Christopherson wrote:
> > diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > index b3116c151d1c..17f7ef975d5c 100644
> > --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > @@ -419,7 +419,7 @@ static void run_test(struct vcpu_config *c)
> > 
> >         check_supported(c);
> > 
> > -       vm = vm_create_barebones();
> > +       vm = vm_create(1);
> 
> Hmm, looks like something, somewhere for AArch64 needs improving to avoid
> strangeness like this. I'll look into it after we get this series merged.

Huh, you're right, that is odd.  Ah, duh, aarch64_vcpu_add() allocates a stack
for the vCPU, and that will fail if there's no memslot from which to allocate
guest memory.

So, this is my goof in

  KVM: selftests: Rename vm_create() => vm_create_barebones(), drop param

get-reg-list should first be converted to vm_create_without_vcpus().  I'll also
add a comment explaining that vm_create_barebones() can be used with __vm_vcpu_add(),
but not the "full" vm_vcpu_add() or vm_arch_vcpu_add() variants.

> >         prepare_vcpu_init(c, &init);
> >         vcpu = aarch64_vcpu_add(vm, 0, &init, NULL);
> >         finalize_vcpu(vcpu, c);
> > 
> 
> Thanks,
> drew
> 
