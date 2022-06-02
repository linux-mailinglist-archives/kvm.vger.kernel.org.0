Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8187853BC0B
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 18:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236715AbiFBQBd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 12:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234778AbiFBQBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 12:01:31 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA32F2A8928
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 09:01:30 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id v11-20020a17090a4ecb00b001e2c5b837ccso9798979pjl.3
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 09:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FBRJMzvAGkJGILGKDbXoB8GLtDkkWNL+J8Ai62jsA+Q=;
        b=LhSseVAFwzWc/U+GtdQ+rNb9khcuSQv817u+uRBRcRw+c1lr5UkuGwWphoEVkRJju0
         +tIhZb39WMVHD5ZhtSUIP3kWxE3u/c4nvYQPz/w0QN0n5qE0gf7m/8QnnpvljBxz5IW1
         Il34Ze/l9MNa848R8LhloC0klP5/0Qig5LjbH0Z2ODIZ66c/VZ7q7vs70cVICYLuHxEM
         +mxI7MDFfUnr6SfELj/1bIqipbprfpYCdDEZkAYcZg7zDuBEcsQfwWPZGQ48yJrj4Wgl
         OQ18YYCroOU+oBwthmEboLwX4a7y49QuaO/M4Gd2XtIGmHc5lGxqoi1mDzgdtP8R5Sar
         xK9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FBRJMzvAGkJGILGKDbXoB8GLtDkkWNL+J8Ai62jsA+Q=;
        b=JM5hJkP+0s7N9AkDj3pasA2u1Hhxl+sAyda9MQTMzT+hE2ZifWzmoDam7PLxW32GO5
         vMHzUqbE8pV3joPXYn556CZPOiuW+e+PzFG4xStEoZ56G13IzgZjLGkhxTzm1OGbqWvl
         JoFvb2Lh4LVB2K5c7gip8vcsVuRr8eT++7RnI3o8HpLK0oN//6g6Z2g0u7O5niJrvHMy
         sLF4Ux41p2PzAAhXc4E+c7zWKbI5uBk7JrO6eeCOni62CCUen38HpyahvRIDKuC4S14o
         p6g7v+XhX09cUGsTbsHGx4j34nit/AeH64ZZIkgvkshC5adugSwWftsBrEGQE7l0yj5a
         oeQw==
X-Gm-Message-State: AOAM533oSVrNEaMI0AqjuwCgoq1GseafLcFkBomTbffEeVed1L/oBWa+
        Q4qzwkvYbkL0QJrC1FOWoadhoA==
X-Google-Smtp-Source: ABdhPJz2IAfCKOE9RlomIcAKq3CSGTE1uFkWqYXOJ7w0xR/St7BpuaqLXukIggRC2picMNq2mluBgA==
X-Received: by 2002:a17:90a:aa8a:b0:1c9:bfd8:9a90 with SMTP id l10-20020a17090aaa8a00b001c9bfd89a90mr6083378pjq.118.1654185690041;
        Thu, 02 Jun 2022 09:01:30 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id iz3-20020a170902ef8300b0015edc07dcf3sm3741600plb.21.2022.06.02.09.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 09:01:29 -0700 (PDT)
Date:   Thu, 2 Jun 2022 16:01:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Robert Dinse <nanook@eskimo.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 6/8] KVM: x86: Bug the VM if the emulator accesses a
 non-existent GPR
Message-ID: <Ypje1evt/iNB2+MH@google.com>
References: <20220526210817.3428868-1-seanjc@google.com>
 <20220526210817.3428868-7-seanjc@google.com>
 <87o7zcokgl.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o7zcokgl.fsf@redhat.com>
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

On Wed, Jun 01, 2022, Vitaly Kuznetsov wrote:
> >  static const struct x86_emulate_ops emulate_ops = {
> > +	.vm_bugged           = emulator_vm_bugged,
> >  	.read_gpr            = emulator_read_gpr,
> >  	.write_gpr           = emulator_write_gpr,
> >  	.read_std            = emulator_read_std,
> 
> Is it actually "vm_bugged" or "kvm_bugged"? :-)

vm_bugged.  KVM_BUG_ON() because it's a KVM bug on the condition, but the invididual
VM is what's bugged/dead, i.e. other VMs and thus KVM itself get to live on. :-)
