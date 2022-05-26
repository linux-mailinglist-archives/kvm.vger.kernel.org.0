Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F3B534C58
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 11:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234223AbiEZJMl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 05:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240989AbiEZJMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 05:12:38 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D9B6BFE7;
        Thu, 26 May 2022 02:12:35 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-2ff7b90e635so8846647b3.5;
        Thu, 26 May 2022 02:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kxgT774Qxw4EYAS+7FY5ihsIiTdaohje5ogQP3Nlw3Y=;
        b=IFoKDCnHMITS1rmf6GIDh0SET6EK6ERswWD44RknloIwWbnABxHBvG0ltlA/h/F20d
         F1egXvDuPV3Rc+fQpE3hMRr8Lt1goyKzW/+xf77bFqmNQE7KOYDL4i1sbVZUV9d1iV5E
         pCHEcVwRve02gBXrom4fW+zdOsWGJBZCiXyjjWixdHaGy4mLzn/vygrI/Y3Kzem/H7+C
         pdwVCpbk2tewPP/dLwZM7CRWAoVm2aLbj9cuX0RG4CtZekIwJY9MiQMJGAZvoqzyZLJ1
         m0etk1RqQSPdlDZBTzJcwfFdCLfZlDkELIzYCUxbl+NqxTUClYqNnpkiGJTTnqoZPM+f
         lvHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kxgT774Qxw4EYAS+7FY5ihsIiTdaohje5ogQP3Nlw3Y=;
        b=r0Qdv3ZcLKrhzscEI5+hIeU+gViQmHLlYsif9tu/j8wxXuUTP0hMfkZSjN7g5Rm0ta
         YJq2DF7U+R0VOCzVPy7fn24mj6EbzPgGZpJNiF7Cwy2booEsKtCRtMH0Dqzh9n1Ccyzn
         L1HSVGgjSUcCDsHB/H9dOn1/hVM1Zt9v9Q0WmgAQ6DeVVu/GxkUOZal/co4Kk4BbkSq7
         MZAW56fYBM7W5wROcLHDC79PkM0Yt0VDzg+vF42NIH9k8tz2EQYK0CPYVN5coskhSf87
         GNHXd6HYS2/vHs7RdWtltaHr2wBOy3uvsPcj0f+rKXtnA3vlt1sWqASV84ZqCsO2Hdbn
         Vn3A==
X-Gm-Message-State: AOAM532Ml282B7pwhGEgsq9QRa4VwAmMPch0IPiR3WI4wzaddIZWKahN
        WezH8VMDUqBIGf6VPhkfF9JeIoXdkYkmqZb5t00=
X-Google-Smtp-Source: ABdhPJy5/1a9V5AeBTGx0W1Wv5fKBpBkkU+bJS9RIJdceCEJ1OcJacD4hkRJoVyVdHwwGlp+aFRcniMGq3m6nDgQHbw=
X-Received: by 2002:a81:b80d:0:b0:2ff:db8b:333a with SMTP id
 v13-20020a81b80d000000b002ffdb8b333amr20453256ywe.17.1653556354906; Thu, 26
 May 2022 02:12:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220503150735.32723-1-jiangshanlai@gmail.com>
 <20220503150735.32723-4-jiangshanlai@gmail.com> <YoLlzcejEDh8VpoB@google.com>
 <CAJhGHyCKdxti0gDjDP27MDd=bK+0BecXqzExo5t-WAOQLO5WwA@mail.gmail.com> <YoPQV0wDIMBr3HKG@google.com>
In-Reply-To: <YoPQV0wDIMBr3HKG@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Thu, 26 May 2022 17:12:23 +0800
Message-ID: <CAJhGHyD0d_dpfKQ9F-Q7nThGYwzjKv_2gnphKUAVtEYZsDygUw@mail.gmail.com>
Subject: Re: [PATCH V2 3/7] KVM: X86/MMU: Link PAE root pagetable with its children
To:     David Matlack <dmatlack@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
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

On Wed, May 18, 2022 at 12:42 AM David Matlack <dmatlack@google.com> wrote:

>
> Ah of course. e.g. FNAME(fetch) will call is_shadow_present_pte() on PAE
> PDPTEs.
>
> Could you also update the comment above SPTE_MMU_PRESENT_MASK? Right now it
> says: "Use bit 11, as it is ignored by all flavors of SPTEs and checking a low
> bit often generates better code than for a high bit, e.g. 56+." I think it
> would be helpful to also meniton that SPTE_MMU_PRESENT_MASK is also used in
> PDPTEs which only ignore bits 11:9.
>

Hello

Thank you for the review.

I think using BUILD_BUG_ON() in the place that requires the constraint
can avoid exploding comments in the definition since it is a build
time check and there are not too many constraints.

So I didn't change it in V3.

Or better (still using build-time check rather than comments):

#define PT_PTE_IGNORE_BITS xxxx
#define PAE_PTE_IGNORE_BITS xxxx
#define EPT_PTE_IGNORE_BITS xxxx

static_assert(PT_PTE_IGNORE_BITS & PAE_PTE_IGNORE_BITS &
              EPT_PTE_IGNORE_BITS & SPTE_MMU_PRESENT_MASK);

Thanks
Lai
