Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CACC5009ED
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 11:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241818AbiDNJet (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 05:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241096AbiDNJer (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 05:34:47 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B269F70F48;
        Thu, 14 Apr 2022 02:32:23 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id x200so8308866ybe.13;
        Thu, 14 Apr 2022 02:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=18iN7isOnbwaCP/A+6P5FUZa7tPpEP9mZVkoMTWqVbk=;
        b=TaiSOkeG0C4eCouXZg0Cyq9AzWHpM+023cwzNOxyLUeMgaHNwgys3LzUfQSa+8lcyk
         tc0wP3ET5ZCnxwFPmu874Ex5pQ0hAm2LrgwJdhvNXVvSX7kQLQgacueikDMxqwAjiaf6
         CTg/9CQ3tfr/lSaW9M9Dlv+CAZxQpu/u5F8SXHyDRXCEFzfUpnlfqlArAiVeLrBiPnlC
         IZlEu5dmRiC5hlpYtFE16mXx0n+JCyz/LVf55wFifLy2SZ8tf7JAmeXWhuGaSZR2GFYr
         /mEdk+bF0X4vKkkS17+h4yscsq1DHS3G8VYuqaqiI9Jkowu7zNMXKyetJ6NHiiHsf0AQ
         J02w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=18iN7isOnbwaCP/A+6P5FUZa7tPpEP9mZVkoMTWqVbk=;
        b=RDTNLlBOld9ONIXGzvzDT208ZS4bHhBEOqEw2PwFlmPNmRZepW7J7L8A690SaNpxk+
         PGw+dFg2ggdjRfDUwXhwRdHQSg2+F9OMk4XqHR6JkHRr4JbaAcb4jEdrmMzxKraI6Ac7
         c/HyRuLv3sQzNwjb068+dDJ0YY0GA3ViqSHDcOCxT0qWp9D1AnGQeIjFB0jQCm7gb8Eb
         Hz13n1XI2cr2IRNgHa7zLNZB4Ax9mlSNGL06OXtda/HqQIyh5icBv3qxOZcpVGDbS89d
         RXJMdi6a5/O7Hainhg1oZi060EQfapRSYG2VjSL1Nt//FU14RT2rwbp/PLomlA/q68nr
         3tzQ==
X-Gm-Message-State: AOAM5306bsSZsAM5moKAZ35QhRMnz6UVHQeTNOvmX9svXnyxHv6qbkeP
        QIu41con4kIyxq4P3QFW5clYpW4iIFuTUi3zbpU=
X-Google-Smtp-Source: ABdhPJzgK9aC518klHOSSzwcux3CKiMlGdS3vuNoXXMM7KFp3sHe6L7qBScGGrXRgCJrCFXtsycXOEsGhbOrTGlARtM=
X-Received: by 2002:a05:6902:124a:b0:641:c7b8:9833 with SMTP id
 t10-20020a056902124a00b00641c7b89833mr1017162ybu.428.1649928742386; Thu, 14
 Apr 2022 02:32:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220330132152.4568-1-jiangshanlai@gmail.com> <20220330132152.4568-4-jiangshanlai@gmail.com>
 <YlXrshJa2Sd1WQ0P@google.com> <CAJhGHyD-4YFDhkxk2SQFmKe3ooqw_0wE+9u3+sZ8zOdSUfbnxw@mail.gmail.com>
 <683974e7-5801-e289-8fa4-c8a8d21ec1b2@redhat.com>
In-Reply-To: <683974e7-5801-e289-8fa4-c8a8d21ec1b2@redhat.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Thu, 14 Apr 2022 17:32:11 +0800
Message-ID: <CAJhGHyCgo-FEgvuRfuLZikgJSyo7HGm1OfU3gme35-WBmqo7yQ@mail.gmail.com>
Subject: Re: [RFC PATCH V3 3/4] KVM: X86: Alloc role.pae_root shadow page
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 14, 2022 at 5:08 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 4/14/22 11:07, Lai Jiangshan wrote:
> >> I don't think this will work for shadow paging.  CR3 only has to be 32-byte aligned
> >> for PAE paging.  Unless I'm missing something subtle in the code, KVM will incorrectly
> >> reuse a pae_root if the guest puts multiple PAE CR3s on a single page because KVM's
> >> gfn calculation will drop bits 11:5.
> >
> > I forgot about it.
>
>
> Isn't the pae_root always rebuilt by
>
>          if (!tdp_enabled && memcmp(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs)))
>                  kvm_mmu_free_roots(vcpu->kvm, mmu, KVM_MMU_ROOT_CURRENT);
>
> in load_pdptrs?  I think reuse cannot happen.
>

In this patchset, root sp can be reused if it is found from the hash,
including new pae root.

All new kinds of sp added in this patchset are in the hash too.

No more special root pages.

kvm_mmu_free_roots() can not free those new types of sp if they are still
valid.  And different vcpu can use the same pae root sp if the guest cr3
of the vcpus are the same.

And new pae root can be put in prev_root too (not implemented yet)
because they are not too special anymore.  As long as sp->gfn, sp->pae_off,
sp->role are matched, they can be reused.
