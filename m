Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35A835926D
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 05:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbhDIDDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 23:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbhDIDDY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 23:03:24 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657A5C061761;
        Thu,  8 Apr 2021 20:03:12 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id i25-20020a4aa1190000b02901bbd9429832so1026847ool.0;
        Thu, 08 Apr 2021 20:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b5jzvm1TkxrqBLNEIG6q7Y2Z+t2I7/nQYypifdCCGdE=;
        b=UVmuotY1CFUNf09XV4Nmp7kYFh4TOMlQCTIgOPJyMGaqQS8pl0i2scWwot7aJxWFu9
         Y9QqvVTPRRZPbouThjWuSr33Sj0bIt2xecymayeMQY1m5y/29BNZJhFjwN+cU8GcCTOh
         0xY++LPPH2T4bR785aA4fNLpL5gT/NqQnS603gVVKI0b2FzFhjq0HKhcLcsRnOLDEGTw
         INcggpEdMu2BMlYF5mx/EuDFKy/I4dcZUhhxkmHJDOXCkFWJFqH5oAZmIdEGD2e+Nnx6
         36SI+IyHrGlR0pGR26x+0OVzjbnIA86nXN3QvY/jjwwJo3aOxpvoIKmOXV/A0wcGZcUx
         CsfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b5jzvm1TkxrqBLNEIG6q7Y2Z+t2I7/nQYypifdCCGdE=;
        b=a1ggJw7jkKTKQbRSWjzldzTyup6XbV40Z0hkSlWr3mRm5ueoVi2nAWWmpbTUaVSCrV
         dzcXI8y8UQRNev3oroa/VyZSHph8n3hdTSkVuALu0y1+hOkmFvIFbrguVAJRXMbDaH10
         YTlliDxmiSmRuP3EvhugZfS0V3I02apCRBbvVZWvaGnEv8P66I5lEgB/ReuXHLelmg4V
         9cW/hobUlNQ5TxI9Db7owmb+2Kj26b5ivfoauf8g4Fzjaz72y8Ekdr2ZydnA75pryhTx
         o3wF6rYpTflxRkzW3bR7u2/ZABFjZioxuu4nSA+By1BXtgU0mjzDWrco7fjtPpR9SdmB
         0R9g==
X-Gm-Message-State: AOAM530Ww5VLA/Wvo9jFdlLlCxBYNzO5/F7kiT/XksUnavopbJHHkECO
        EQHhrf5okYp6Z9Ew68pgB3ZD7UTInO4k/eVuTGM=
X-Google-Smtp-Source: ABdhPJyU3w7bOSbj802Bq0sGLVZBDN0iH4QBVraQl45rJJkyW7MD97IbKIFXV2CGqTEIhWjYZvyaifZ5L7sKCv/F63U=
X-Received: by 2002:a4a:395d:: with SMTP id x29mr10171748oog.41.1617937391914;
 Thu, 08 Apr 2021 20:03:11 -0700 (PDT)
MIME-Version: 1.0
References: <1617785588-18722-1-git-send-email-wanpengli@tencent.com> <YG9ln4d0tm4acVdG@google.com>
In-Reply-To: <YG9ln4d0tm4acVdG@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 9 Apr 2021 11:03:00 +0800
Message-ID: <CANRm+Cx-tfomRgV-QbyfvZZ7g7HBskm+p97zifUS8C0bdZyR8w@mail.gmail.com>
Subject: Re: [PATCH] x86/kvm: Don't alloc __pv_cpu_mask when !CONFIG_SMP
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 9 Apr 2021 at 04:20, Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Apr 07, 2021, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Enable PV TLB shootdown when !CONFIG_SMP doesn't make sense. Let's move
> > it inside CONFIG_SMP. In addition, we can avoid alloc __pv_cpu_mask when
> > !CONFIG_SMP and get rid of 'alloc' variable in kvm_alloc_cpumask.
>
> ...
>
> > +static bool pv_tlb_flush_supported(void) { return false; }
> > +static bool pv_ipi_supported(void) { return false; }
> > +static void kvm_flush_tlb_others(const struct cpumask *cpumask,
> > +                     const struct flush_tlb_info *info) { }
> > +static void kvm_setup_pv_ipi(void) { }
>
> If you shuffle things around a bit more, you can avoid these stubs, and hide the
> definition of __pv_cpu_mask behind CONFIG_SMP, too.

Thanks, I will move around.

    Wanpeng
