Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD7D233954
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 21:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730600AbgG3Tuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 15:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730377AbgG3Tuq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 15:50:46 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD3BC061574;
        Thu, 30 Jul 2020 12:50:46 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t10so9795163plz.10;
        Thu, 30 Jul 2020 12:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tMXvAgV7y7E7g3D1Q8GTY7E552yzOC14eLgZur5bOX4=;
        b=kxVJFfipNn+Aa+QD1px2nW0qiEiM/lI4U7W6jk2kqnzMFytG1ybU18pP4MGcrHhYnT
         ZF06DS+lPzJ41rC7TqP6wDhYI8yiae9n4SjJODgj1Hj1CqMErax8rYP3TlyL/cpsahCl
         vvpw9ksu8nT2OhyGyOLfRIlMQQUTXGxyq0009jfWcozRK5tLt0bpJpl+K3RqM7Vg70b8
         pH0GI+TmKPzT0JdOgMH+P3uNQKIMU6EpvTI7x7pxYXyx6uq8E5M4l7vt7CoPtZYQREfo
         X0j97FndDgTSJ092q5QwCB1MporPW5eoJXTXt6mXHOB3gEwdnSZZ55PfIAyu7kwJBEKf
         IPzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tMXvAgV7y7E7g3D1Q8GTY7E552yzOC14eLgZur5bOX4=;
        b=CNpi0TmsbEL//SUb0GNdYR8X3yOc6DIr0c5Q9qZISPxDX5AqJGskdVXgnBA3qfLm+R
         ZRcvb3l4cncKoRnJhOrZjdPx82/Exq42jN52j8EbPBYHTJ7p3W9dJiQgrLPoUxcpNT4y
         fGLuUhI4S2MHlBSPbckkqEvXoNCZic9DpzDqlFnWlbWQt29e5MArkG3EToygNOP4PQHx
         46yHa65kjgY4Md7lDFfPJHvlZWoVcLNzUREIF8ik97tKCa9luQPPjhL0gXHfAEifyifD
         jr0Kp8/H9fM4NeXKCBRuTJqdMNdqwFT6+vzLr8yozniOrXhgk1qdfwKX3C4URlPC9iwh
         yeNg==
X-Gm-Message-State: AOAM532+jQ4xajOzoFv1RxrUZpeV0aklb20qznCdb2C5rH4rlHxRtE6Q
        N1cylgISST9KyXFADCWtFkACWa0DzJBDV5rz7I8=
X-Google-Smtp-Source: ABdhPJy3/p35FG9tefm9R+LVBFlJys79Eb4rSZlOzkM8ZMdIR5Ub5tAyBAc6UmBduAWzlHFwoqdkyJyAXBlq9OwW6mk=
X-Received: by 2002:a17:90a:a393:: with SMTP id x19mr707926pjp.228.1596138645586;
 Thu, 30 Jul 2020 12:50:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200730193510.578309-1-jusual@redhat.com>
In-Reply-To: <20200730193510.578309-1-jusual@redhat.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 30 Jul 2020 22:50:29 +0300
Message-ID: <CAHp75VcyRjAr3ugmAWYcKMrAeea6ioQOPfJnj-Srntdg_W8ScQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Use MMCONFIG for all PCI config space accesses
To:     Julia Suvorova <jusual@redhat.com>
Cc:     "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 30, 2020 at 10:37 PM Julia Suvorova <jusual@redhat.com> wrote:
>
> Using MMCONFIG instead of I/O ports cuts the number of config space
> accesses in half, which is faster on KVM and opens the door for
> additional optimizations such as Vitaly's "[PATCH 0/3] KVM: x86: KVM
> MEM_PCI_HOLE memory":

> https://lore.kernel.org/kvm/20200728143741.2718593-1-vkuznets@redhat.com

You may use Link: tag for this.

> However, this change will not bring significant performance improvement
> unless it is running on x86 within a hypervisor. Moreover, allowing
> MMCONFIG access for addresses < 256 can be dangerous for some devices:
> see commit a0ca99096094 ("PCI x86: always use conf1 to access config
> space below 256 bytes"). That is why a special feature flag is needed.
>
> Introduce KVM_FEATURE_PCI_GO_MMCONFIG, which can be enabled when the
> configuration is known to be safe (e.g. in QEMU).

...

> +static int __init kvm_pci_arch_init(void)
> +{
> +       if (raw_pci_ext_ops &&
> +           kvm_para_has_feature(KVM_FEATURE_PCI_GO_MMCONFIG)) {

Better to use traditional pattern, i.e.
  if (not_supported)
    return bail_out;

  ...do useful things...
  return 0;

> +               pr_info("PCI: Using MMCONFIG for base access\n");
> +               raw_pci_ops = raw_pci_ext_ops;
> +               return 0;
> +       }

> +       return 1;

Hmm... I don't remember what positive codes means there. Perhaps you
need to return a rather error code?

> +}

-- 
With Best Regards,
Andy Shevchenko
