Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54D14B80C2
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 20:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391517AbfISS01 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 14:26:27 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:36882 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391505AbfISS00 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 14:26:26 -0400
Received: by mail-io1-f67.google.com with SMTP id b19so10135723iob.4
        for <kvm@vger.kernel.org>; Thu, 19 Sep 2019 11:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IwUvR/4tcp2TNPi5HKxxq+Q4HUm6QLsbgorFVB29v+M=;
        b=DR961+H7n5xGa/DM4V8+cpf2x0cChPz1xhRRQCZdHXeNit+95FTKO6LUECwBMbmHJA
         qAGl1Xb48BQRwFOlLRiOr5aM+/wP/hvWw/8Zw2+Q3RTKSBDBO5EoQX0SSnFOfATu5V9Z
         xHQPvh1EMnFvIqvazC+dH3wM2LH+jWSzBh9iZUrTU+t/QVcuAr5v6VrDOrIK3LBoQAkm
         USDen0KpevVPE1RhR8AGF4F5FtdKmRf41dExn2SYxxAEB7U+ArbyotCqaTX/2146SRWn
         dEV6LhRSOQbQE0rP6wD195XYTfmEFcBdJuVfqHBpYgXyies2mvlYN2b7ZSIHlx5ZO2PW
         BAOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IwUvR/4tcp2TNPi5HKxxq+Q4HUm6QLsbgorFVB29v+M=;
        b=B4FJPJ+J7Cjn0D6+tkQx1CCY65A5spCl+GDaTmY9rc4S/L77a+i+ACM1O+jEju+Wet
         2yHKutF+IR/k2RwQyKLmxsjsPiV701CTkl13BH7r3jKmGKDz75S2+Qa3/W8U/VmRpP33
         i18ZrSyHj2nP+YybUvE+cZKcAWVPbEemt12Bvbr1dATGLZ/7E5fo6/fOI3q3OkDHjIFI
         SIHQY4W05lAdakP4wvGsFLOCwu90LhedRqWCPVijmOZm+VBaEwZ21GHU0Jpbq9IKuijm
         AzTD0IdqP2Jvbs3eXAImEvSMEKsj8kd46c1mE3RktZ1TsCn5fvvSeobeBJSlznOven9K
         fhDA==
X-Gm-Message-State: APjAAAVRvm9YmfIYx9cmFNyjVF3GGG6sCtWX8CQBdrLyDV7X1SvNwoMw
        Hj0hKsNNdgbR2Bl+V0II+nP0MdOGZjvV20YK9N7hjg==
X-Google-Smtp-Source: APXvYqytVUJayJBVODl0Bphjg7wIJBjyMctGjETjfcnzsErgZzYiihVLBdG9YxB5VwQLuKJK7iFSYF3tSZo438cvK0k=
X-Received: by 2002:a5e:8a43:: with SMTP id o3mr13747952iom.296.1568917584206;
 Thu, 19 Sep 2019 11:26:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190912232753.85969-1-jmattson@google.com> <20190918174308.GC14850@linux.intel.com>
 <CALMp9eQSd8kMKEdLYTF2ugAYjQO-wAR-PoYmf0NgD2Z4ZVr5FA@mail.gmail.com>
 <CALMp9eSJkjO0CX2_s1QpgaYk-pDVCYoof_QVjxf9cpquaMOr1A@mail.gmail.com> <b3ebf989-8da9-6fa6-9296-ec694988e645@intel.com>
In-Reply-To: <b3ebf989-8da9-6fa6-9296-ec694988e645@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 19 Sep 2019 11:26:13 -0700
Message-ID: <CALMp9eRQRsOekTCnSvafrMv79WAymFtPcGGLvqSFPPoH0YnBJw@mail.gmail.com>
Subject: Re: [RFC][PATCH] kvm: x86: Improve emulation of CPUID leaves 0BH and 1FH
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        Steve Rutherford <srutherford@google.com>,
        Jacob Xu <jacobhxu@google.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 18, 2019 at 10:31 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> I vote for Sean's one-off case, how about something like this:
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 22c2720cd948..6af5febf7b12 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -976,11 +976,23 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax,
> u32 *ebx,
>                 u32 *ecx, u32 *edx, bool check_limit)
>   {
>          u32 function = *eax, index = *ecx;
> -       struct kvm_cpuid_entry2 *best;
> +       struct kvm_cpuid_entry2 *best, tmp;
>          bool entry_found = true;
>
>          best = kvm_find_cpuid_entry(vcpu, function, index);
>
> +       if (!best && (fuction == 0xb || function == 0x1f) && index > 0) {
> +               best = kvm_find_cpuid_entry(vcpu, function, 0);
> +               if (best) {
> +                       tmp.eax = 0;
> +                       tmp.ebx = 0;
> +                       tmp.ecx = index & 0xff;
> +                       tmp.edx = best->edx;
> +                       best = &tmp;
> +                       goto out;
> +               }
> +       }
> +

I don't believe this works for the case where 0BH or 1FH is the
maximum basic leaf, in which case all out-of-range leaves should have
this behavior. But I'll go ahead and work up a solution using this
two-off :-) approach.
