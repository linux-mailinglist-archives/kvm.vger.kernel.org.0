Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F1F23436B
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 11:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732204AbgGaJlX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 05:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732080AbgGaJlX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 05:41:23 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD3BC061574;
        Fri, 31 Jul 2020 02:41:23 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id bh1so3791750plb.12;
        Fri, 31 Jul 2020 02:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=60oA9rNnse/fDL09mT4gNyvwtlkjkgn68ejSkWL01U4=;
        b=jFUk/3lgMKRsuw2kqebmjsqO3kZlYUfWJDtyz7dnP7klnelndxxizX1YTwf1x6TM2R
         O1lgLRyPxdNgntgUQJexNMdBjlD+BqsqKwpT9VelCtT40egjJ4ldVWBfu8Nhw9R65JJ0
         LVY09ZubTy0a09ES38ILxS6WZg/nkZr1DQicrZdzpHDvTrdA2oMqwr/NDkD7em1lra5Y
         CF6HjTo7QB6XxCpWfZEA1UU/XuxbvrE9lDmlqtCLC33e2Oi8+1N/Jtzixb7fhiwaYJMp
         +Bv7tociKsr2tF6b3fa3I/8aPu5hShX37foP6lyH37KpNsGRzzpMOTlnkx8CmODYL0iH
         Dpdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=60oA9rNnse/fDL09mT4gNyvwtlkjkgn68ejSkWL01U4=;
        b=CiZ0vmpJl8BYck6ljAIGvcF0bJCPqPxs6Uz0I8CtIR5tRG4YUkEzi9gF65S4P6P0KV
         2jIekKnTJo3M9meX7l0VEdHhlXszx4fevhifXYGBjaWRTrpNCyMlqAXmfxb+4K6cGC6c
         /sD41gE9Di/FVx/eEwJiU7KaQ3bpmWsuO29HfLG4emyswjE0Ehp7JpyHsz0uWrEt6LZE
         NnIOy2CuJS2bDvkysZHRBLEdeqRaI04TmC7kBSLfFNCC4islQQDnlpFCXRYxupeyig0d
         JL3vclfMy2OyjhVeIl4IMyGoCBVIPE2NTmAv4JjUeMWgAtUjCgwr1Y3ZMBME9HGHC1WG
         VhEA==
X-Gm-Message-State: AOAM530wJQcfWPlHz3TxNt3zr5qHUtrijTtcZF5hxQjU5wLNBltlOwFi
        Ttu1r1rccPFU77FOAEIDEZI6hdR2OfCpMel/1FwQMBjw
X-Google-Smtp-Source: ABdhPJxcqKLMLWULglf9HaGDtkBv3V/+Irpwu3izGZjgy3swW/REesBO3cHyi7PIGB2vTTxtdDvdfyXPkcJBDeX5wTM=
X-Received: by 2002:a63:ce41:: with SMTP id r1mr2998288pgi.203.1596188482768;
 Fri, 31 Jul 2020 02:41:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200730193510.578309-1-jusual@redhat.com> <CAHp75VcyRjAr3ugmAWYcKMrAeea6ioQOPfJnj-Srntdg_W8ScQ@mail.gmail.com>
 <873658kpj2.fsf@vitty.brq.redhat.com>
In-Reply-To: <873658kpj2.fsf@vitty.brq.redhat.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 31 Jul 2020 12:41:06 +0300
Message-ID: <CAHp75Vfp8aabZo_NW78kM-OLLKDgK1CwvLZNwmPZyQgaw6bXtQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Use MMCONFIG for all PCI config space accesses
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Julia Suvorova <jusual@redhat.com>,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 31, 2020 at 12:22 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> Andy Shevchenko <andy.shevchenko@gmail.com> writes:
> > On Thu, Jul 30, 2020 at 10:37 PM Julia Suvorova <jusual@redhat.com> wrote:

...

> >> +static int __init kvm_pci_arch_init(void)
> >> +{
> >> +       if (raw_pci_ext_ops &&

> >> +               return 0;
> >> +       }
> >
> >> +       return 1;
> >
> > Hmm... I don't remember what positive codes means there. Perhaps you
> > need to return a rather error code?
>
> If I'm reading the code correctly,
>
> pci_arch_init() has the following:
>
>         if (x86_init.pci.arch_init && !x86_init.pci.arch_init())
>                 return 0;
>
>
> so returning '1' here means 'continue' and this seems to be
> correct. (E.g. Hyper-V's hv_pci_init() does the same). What I'm not sure
> about is 'return 0' above as this will result in skipping the rest of
> pci_arch_init(). Was this desired or should we return '1' in both cases?

I think it depends what you want. In complex cases we recognize three
possibilities

-ERRNO: function failed, we have to stop and bailout with error from callee
0: function OK, stop and return 0
1: function OK, continue the rest in callee

Do we have needs in this or is the current enough for all (exist) callees?

-- 
With Best Regards,
Andy Shevchenko
