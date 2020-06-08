Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211781F14D3
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 10:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729144AbgFHI5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 04:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgFHI5H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 04:57:07 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B1CC08C5C3;
        Mon,  8 Jun 2020 01:57:07 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id p20so17663760iop.11;
        Mon, 08 Jun 2020 01:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dl5xv/IGmW59O6enCMfcyhbX0k4Cox4q6lQplQWI50g=;
        b=n69Rj4B317q2AUkFxmxxCNdE3kD8/kgP//csqFWYb9IxlektA3qJLb4csUHzN4Fl8y
         ivL16ciXx349vbCQZrEMphHtlcbJhKgT+WhtCA5zhYOwtHbhwhbKfz8hJgAuXmfwGBMI
         lHPk7EDSgfwr1fd45vQJ0S22yScT0iaSX+RSzdjB3oRkMMUjC6GPDTBD98pV+ws2GRIj
         M4iE/ZZKSMW8pIaaGox0gwC+xA5qMBAHAXCHldJvqPjqBfikj+7cM9KCYtQaxCT29K5c
         XqqXB2VvOI0boHGZ2KbezKV2THiExcTvbSfxJx2gyqKEDQZvFA3J4KaZgqDULPn9HkEZ
         fjSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dl5xv/IGmW59O6enCMfcyhbX0k4Cox4q6lQplQWI50g=;
        b=q9KLVGI8rEgEDqNFLTF7xgEoqNtkuAH1UqjbTY/1qwFJ7RSZpdi0424zhs5YOXpSd2
         F6SKQR+BAsf0tdkUlGd5MNuj+PIopfxsxq7UVunUPjBwedpDuCW25fc23if1KDBE7keO
         mWDU9FJVOnDCdwpPEoV6W9TgrQjGhSoJNNj6WP4l9pyMpxcNSPo89XFVz/qNlUgH2+Za
         uRO2qvgaMDRsbJADUf87W6+FPXkt7OonJdCBQGODhcicWymymZgwc209/sZ5AK00V237
         ectz3diwI6HyLa+NTVC4ruhxQTM1JlfEODNF29fRQIcz/Jxs4hfVVM0mYf3Krg2w1i80
         vO+Q==
X-Gm-Message-State: AOAM531ngdMU78Dcujg6lM3j6cEL720eFFrTUudKFvppfHDYSlLrt9S6
        z1YNqrcS4lAQnJgt3U05SrClJ0tjzYPq8ZNGogg=
X-Google-Smtp-Source: ABdhPJyqapi7KbQS7kw+93/4pmWdcph1yT6gP2ngPU+7u2tF0I6b3vpCSASJKLF1zq7aDFqM5yDJCLKmeao6ImlWGzc=
X-Received: by 2002:a05:6638:dd3:: with SMTP id m19mr21525269jaj.106.1591606626515;
 Mon, 08 Jun 2020 01:57:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com> <20200605213853.14959-21-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-21-sean.j.christopherson@intel.com>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Mon, 8 Jun 2020 16:56:55 +0800
Message-ID: <CAAhV-H6eyj2ihKAygqkCvgfCnBnAhx7Eu6Vooh2FHqQdRcdhrA@mail.gmail.com>
Subject: Re: [PATCH 20/21] KVM: MIPS: Account pages used for GPA page tables
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Huacai Chen <chenhc@lemote.com>

On Sat, Jun 6, 2020 at 5:40 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Use GFP_KERNEL_ACCOUNT instead of GFP_KERNEL when allocating pages for
> the the GPA page tables.  The primary motivation for accounting the
> allocations is to align with the common KVM memory cache helpers in
> preparation for moving to the common implementation in a future patch.
> The actual accounting is a bonus side effect.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/mips/kvm/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
> index 94562c54b930..41a4a063a730 100644
> --- a/arch/mips/kvm/mmu.c
> +++ b/arch/mips/kvm/mmu.c
> @@ -32,7 +32,7 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache, int min)
>         if (cache->nobjs >= min)
>                 return 0;
>         while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
> -               page = (void *)__get_free_page(GFP_KERNEL);
> +               page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
>                 if (!page)
>                         return -ENOMEM;
>                 cache->objects[cache->nobjs++] = page;
> --
> 2.26.0
>
