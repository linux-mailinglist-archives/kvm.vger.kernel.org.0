Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D894765E8A2
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 11:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbjAEKIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 05:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbjAEKIR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 05:08:17 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FAC13E32;
        Thu,  5 Jan 2023 02:08:16 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id cl14so2884183pjb.2;
        Thu, 05 Jan 2023 02:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zzFihM3brSUyhj9EQhpuT0935H6SDBtRIpGFGva+eS0=;
        b=oSjh5hcWGIuSYuO5td5hhVRavQ3Vt1WzvJZhVJyr8FVBTs23efK4B+POjJaG6Oz1JG
         ovuSeRe2ObLwoojm8lON2+VROXpAPPnvSHafe3NPPFz7cMTF7FO5WqgiunIt0yWzXiY6
         AvO0fuP+yaH1dvnRB6RTUM9CVbWsTowY1O7+GX6SMeLJwJ7mKkLmPFczGoJx7AxLjl6m
         GwNRvif7hmWll+dR3m1jUzdIpCL027EClLrnpuWOYQ7pBY1EhJLj3Sourm76MSVCbN1E
         lS6yyz9hbDPHz1tEkiAPb9+Avtm2AJ9irIy2XL91GtlRAmNSTtwH1bYmQ+R7jgZZ0i2a
         DAZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zzFihM3brSUyhj9EQhpuT0935H6SDBtRIpGFGva+eS0=;
        b=fB7wf16sLGfCL2RbnROWJ6OdiViRkf/Z29zigNKrhcsTJeMX+4uOh1HKGXGYFIh60N
         2aijhF8po0kK46Y/ym7YTfqD8MBSMx0QsdYG/SCRaKEVeg0oOueFMiuvE0RnjLWzsyDq
         q9WOwZgj8j5id548AFdfzmpuU8qYnm6vzgqIxgdYHQNVqznwu68G9ETiTZ8ncABTLYAf
         05UzKB8vjOR7vgYdENwkW0OPgN/uGaDYJfsohMAw6z6LaViI97FaUfSTlPKwA9aNzdi4
         arRDhCSVxHUe9K0yQRfKhQ1RJz7AihPwadakbPhZm717t+QyAdpK5zcmEe3WLVwf220x
         O8Fg==
X-Gm-Message-State: AFqh2krFWqsxKArrp03XfmAUjGyqcySitqkQMlPU/h0uqxyHKKu4a7hg
        Ryyyd6VmGYQwR8ogr0g+XsxU0bTKRMhbOtzvx30=
X-Google-Smtp-Source: AMrXdXvjp1meTbVB5nMu2waw0fxTnKJif53X3ZH3aZyWTxjNKcfWJiywbQM+3V4l8MtNMu75EBpZmAqe/NabinEIFDc=
X-Received: by 2002:a17:90a:19d7:b0:212:b43b:ffe5 with SMTP id
 23-20020a17090a19d700b00212b43bffe5mr3786650pjj.32.1672913296192; Thu, 05 Jan
 2023 02:08:16 -0800 (PST)
MIME-Version: 1.0
References: <20221212153205.3360-1-jiangshanlai@gmail.com> <20221212153205.3360-2-jiangshanlai@gmail.com>
 <Y5jAbS4kwRAdrWwM@google.com>
In-Reply-To: <Y5jAbS4kwRAdrWwM@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Thu, 5 Jan 2023 18:08:04 +0800
Message-ID: <CAJhGHyCRf_M8XD23VT1wRCL1KTCyA6z46enr1i+HxYMi9tvAAA@mail.gmail.com>
Subject: Re: [PATCH 1/2] kvm: x86/mmu: Reduce the update to the spte in FNAME(sync_page)
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022 at 2:12 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Dec 12, 2022, Lai Jiangshan wrote:
> > From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> >
> > Sometimes when the guest updates its pagetable, it adds only new gptes
> > to it without changing any existed one, so there is no point to update
> > the sptes for these existed gptes.
> >
> > Also when the sptes for these unchanged gptes are updated, the AD
> > bits are also removed since make_spte() is called with prefetch=true
> > which might result unneeded TLB flushing.
>
> If either of the proposed changes is kept, please move this to a separate patch.
> Skipping updates for PTEs with the same protections is separate logical change
> from skipping updates when making the SPTE writable.
>

Did as you suggested:
https://lore.kernel.org/lkml/20230105095848.6061-5-jiangshanlai@gmail.com/
