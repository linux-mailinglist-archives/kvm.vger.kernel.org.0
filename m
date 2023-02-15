Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF626988C3
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 00:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjBOX2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 18:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjBOX2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 18:28:44 -0500
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5093143457
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 15:28:43 -0800 (PST)
Received: by mail-ua1-x932.google.com with SMTP id s21so46934uac.13
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 15:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bOUeJWFvpV4H+dOD0lIXGUYEiNv7vk7Mm3Pftn0hOdg=;
        b=ATNbHY/qOA/meyaYYhpYIn1c4h/RWyY7gYBaWNy/tTa/ed5lkLfPs7+yiWtH/7qIwm
         evUezWZKGO3MDQn/BNax7w4mY21YV0DklYie8AUIAGWDdkaoYaRYGaxq+ogzuKyf3Gk8
         NPLO4Cmf1G8B+yn2Jxf2h61RKscdjhJqXc1w/hWpIKsaiRmMTiUmXD6gwlejrK6YnIew
         NNELUQ70eXbpSm8F5XWU4Yf+DOoAXUtiJINe0Beg9G3NeV7g1BD06PEGpCtMeK90zPrJ
         BHyXEDINnikEkWmBjdDM9oSfVb77KMdvcy/AtPFlcytAW0BsOO4H57ZZqEopRF5WiW1u
         3igw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bOUeJWFvpV4H+dOD0lIXGUYEiNv7vk7Mm3Pftn0hOdg=;
        b=w3+WVAGWNJIm5RafY9wXGYGsCphWSTvGq10U1c1ycRzkKpb4tMtZfRJydV6/zpjkvA
         KceudZUZN1O/DaYiYX845GnmVEj5XZQdbWoWTdPoP38TsZjWnkaWibj4lzYx0CHyCJWz
         elTJqEggIntQ+RqsJMhJNBvQOas+qD/7LvojZ02s2yT8xhwiqUGQ66yE5++AclKLIVK8
         dQ9vMDMZBBiw2oe9At0/AlnKysSyYuUUqkyYEgLT/0Wlzzon5wiUeTQ6GlsPTgs0S43y
         0hCk/L1j8ceS8RComblIA0d5eC3UdCh7dcWHKV3jiSv3jgo5Xi8N3QRjSG44ivdTx5pE
         Aj0w==
X-Gm-Message-State: AO0yUKWIOw6RCAZu+zDF5LkwLSGDjR3cIa17jn3zvXi1yarWQKlvbKSF
        eu6ER+64701nHlRJre6USvOSfEQzjqRmKeMg1yXBaQ==
X-Google-Smtp-Source: AK7set+petihwvjYEiAR/DINUP0S0MHgbGcQm4dM6CcqoPFChMgAb2nx4jmTrPOuzi3uyIEbQoNc3lKvZSD3XBz3PSU=
X-Received: by 2002:ab0:3b56:0:b0:68a:866c:a09b with SMTP id
 o22-20020ab03b56000000b0068a866ca09bmr395108uaw.73.1676503722356; Wed, 15 Feb
 2023 15:28:42 -0800 (PST)
MIME-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-8-amoorthy@google.com>
 <Y+0jcC/Em/cnYe9t@linux.dev>
In-Reply-To: <Y+0jcC/Em/cnYe9t@linux.dev>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Wed, 15 Feb 2023 15:28:31 -0800
Message-ID: <CAF7b7mpbAdQtvXCQCk5kLrSn0bN=fLYVzEWXVW34OgBSxzHA_g@mail.gmail.com>
Subject: Re: [PATCH 7/8] kvm/arm64: Implement KVM_CAP_MEM_FAULT_NOWAIT for arm64
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        James Houghton <jthoughton@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 15, 2023 at 10:24 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> All of Sean's suggestions about writing a change description apply here
> too.

Ack

> > +     if (mem_fault_nowait && pfn == KVM_PFN_ERR_FAULT) {
> > +             vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
> > +             vcpu->run->memory_fault.gpa = gfn << PAGE_SHIFT;
> > +             vcpu->run->memory_fault.size = vma_pagesize;
> > +             return -EFAULT;
>
> We really don't want to get out to userspace with EFAULT. Instead, we
> should get out to userspace with 0 as the return code to indicate a
> 'normal' / expected exit.
>
> That will require a bit of redefinition on user_mem_abort()'s return
> values:
>
>  - < 0, return to userspace with an error
>  - 0, return to userspace for a 'normal' exit
>  - 1, resume the guest

Ok, easy enough: do you want that patch sent separately or as part
of the next version of this series?
