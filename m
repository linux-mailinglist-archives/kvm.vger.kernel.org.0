Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C58543D22
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 21:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235695AbiFHTxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 15:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiFHTxC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 15:53:02 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2178660B9C
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 12:53:01 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id w2-20020a17090ac98200b001e0519fe5a8so19257723pjt.4
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 12:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CrK6nuHPCK0ai5XnfNscYvGQzujrncbP+EE8Tg1jqVY=;
        b=oz74sLOu1cI/PGZ+9XsXfKfDziDDz9IGD0+aDbA7yqOAHS4MmH2vo+kv9XzWRXZ871
         GmQH4SQsiuLItvHTyX7vUC/OgfoLBsXPlmyyGzoLlT/u74G1Zi3X4eD82L+JQTOVkwnd
         tAhTj28kDkFB/Ekzvhd96nJVKFlMHOf82w07VxVclGShdZMKQ/KmP4OSgNGf6sUn1Omy
         4DxWegvKWXAfOJneXddCGZmHdJvA7Ny+ZUUbSnXnsmfGPVREqteA0+WXDHf1HWFltfvV
         0eey0fM+hW+XPTWG335n987Z4eVSFB83UTTfT/4JleM4qXOdIwqpzexeDPOJrbV/F8Ww
         CRpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CrK6nuHPCK0ai5XnfNscYvGQzujrncbP+EE8Tg1jqVY=;
        b=UDXn2pk+IFkwxxtVCm1+85NNPkPk3i8u/LqMRcNxbvWGs8WiDid6YXtQNUNCkRgQ4e
         O+FeMHBG1AiF/1EGSHS2Q2oJ0+uodfjy+8y1kR2N5rdwWF8Et94LItoINmt94k+xyNZj
         2hyuveBpW4dbbSHZQY0M07FxW0prsb7FQOXvME3y/KXQ2jXmE4iXJlQ7YXUI7xsQym6A
         FLZ48X92DEn8S7nPu2LlC1OTZsBBttehSFyPwLBLXjXiaIwvBW2zmHY0/tkXpY1ZldUl
         CqBhuMeYJW6qF1RvvpuyfM3kUHQrO2cnQI6dZIV+RLb7B5FEsvOZi3amjynysurm1WG4
         rWSw==
X-Gm-Message-State: AOAM530Pr4wHjvfVMxFoNW35HHdqPjfAa9dOb3Ufz+ePdD2ataJIH4ry
        gAXoKaqvou9k+gA9Gephm2zM0w==
X-Google-Smtp-Source: ABdhPJyuyxAZZRxXxEcZjymKkii0h0h5xyEvOsrt+cO8go7KgSQU5KqQ4jlX7YthEbQAfqqtKqeuVA==
X-Received: by 2002:a17:903:1c8:b0:167:67ff:323d with SMTP id e8-20020a17090301c800b0016767ff323dmr21867638plh.22.1654717980268;
        Wed, 08 Jun 2022 12:53:00 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d9-20020a656b89000000b003fd7e217686sm7635036pgw.57.2022.06.08.12.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 12:52:59 -0700 (PDT)
Date:   Wed, 8 Jun 2022 19:52:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 041/144] KVM: selftests: Use vm_create_without_vcpus()
 in hardware_disable_test
Message-ID: <YqD+F5z67aN7b1JQ@google.com>
References: <20220603004331.1523888-1-seanjc@google.com>
 <20220603004331.1523888-42-seanjc@google.com>
 <20220608144332.a5syqvj5ttb2zarw@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608144332.a5syqvj5ttb2zarw@gator>
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

On Wed, Jun 08, 2022, Andrew Jones wrote:
> On Fri, Jun 03, 2022 at 12:41:48AM +0000, Sean Christopherson wrote:
> > Use vm_create_without_vcpus() instead of open coding a rough equivalent
> > in hardware_disable_test.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  tools/testing/selftests/kvm/hardware_disable_test.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
> > index 81ba8645772a..32837207fe4e 100644
> > --- a/tools/testing/selftests/kvm/hardware_disable_test.c
> > +++ b/tools/testing/selftests/kvm/hardware_disable_test.c
> > @@ -104,9 +104,7 @@ static void run_test(uint32_t run)
> >  	for (i = 0; i < VCPU_NUM; i++)
> >  		CPU_SET(i, &cpu_set);
> >  
> > -	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
> > -	kvm_vm_elf_load(vm, program_invocation_name);
> > -	vm_create_irqchip(vm);
> > +	vm  = vm_create_without_vcpus(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
> nit:       ^ extra space

Heh, and I managed to carry that to the end of the series.  At least I'm consistent?
