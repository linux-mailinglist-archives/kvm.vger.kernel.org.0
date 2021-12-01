Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800EC46453F
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 04:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346391AbhLADL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 22:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346380AbhLADLz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 22:11:55 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE5EC061746
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 19:08:34 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id u11so16562266plf.3
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 19:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g/5TnmO0gT6CKLi6q8niA4Xjnk2B+JAa0dgcq+oWmgE=;
        b=sz8OfTfEdVypCCUplqFm68nLLrB713ifamjo9FNgw6fxytJB7suIkv97dVHhFtHvIp
         r6xFOTe4ZOtSS6J0BMNf6RUu1F9nxEFmEkOKMeCch/lUeka+ZiZQ94fK7jCzhehNKebD
         ziGr/lC86orMOySYprMqDlPfD+mdiOcfY1SjLYh599iN7kbsQhMOdf6Y7+zFQIzXU2jg
         wbdDB+yuWURoVlOjBXma2j4fnxAsm3Za+OU4j8Qz7+WkaPSh8MMq4zGkvx6QgzT0lreJ
         y23v9KJ76HIwXxCySpNCdkf7NnZ+WMR7ZPgAzissxHyl2iU1M+h98WahNHybCIgmNG5B
         pPqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g/5TnmO0gT6CKLi6q8niA4Xjnk2B+JAa0dgcq+oWmgE=;
        b=QoyhK/akMX3TPuqtDKazLNgmGOK1E7o8Wgz5Od3ZrPnb+m9PNIx8o4CqGj54mbPvO4
         jFmzU8qnOlvqzZ03f1D69AaPNHxSLB6poIOM6AUB9prJCiTcDM0W78eO13AGxVw5/E6W
         kd8Ada3bB08f6GyR20fxf6xa3ezKml9ahpvOkIua8aKJYkjyBa+SFpPYm2wb9VKt5wcW
         BDVda3o/8004DG2/ChuProEL9or8xpjP/C9OAQlxeCN0EmMzpKeo8JoKwgZZKe0qzEGo
         XnBMRAxewymAu/EvbgedErVNQR3imm3L5WSOdI/eUI5IfCuiZIXkU+BLwx2ASz9MWe4C
         oT+A==
X-Gm-Message-State: AOAM533w+yXmDaZLejkHS6nGCclwWGQZ4ddtnvnyFdv2QYtU3Nis9LJ/
        yF6qhG78LBO4OPLjvWYnapqQDw==
X-Google-Smtp-Source: ABdhPJygWMG8G7zSDce5b011s1X4Xdp56pbQ1mwLc1IlSvA0PgBz9ATqm9E4pHlqKImvPGB6/ds8zA==
X-Received: by 2002:a17:90b:3908:: with SMTP id ob8mr3988513pjb.57.1638328114039;
        Tue, 30 Nov 2021 19:08:34 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b15sm23525916pfl.118.2021.11.30.19.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 19:08:33 -0800 (PST)
Date:   Wed, 1 Dec 2021 03:08:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 27/29] KVM: Optimize overlapping memslots check
Message-ID: <YabnLaz3QBbsxLl0@google.com>
References: <cover.1638304315.git.maciej.szmigiero@oracle.com>
 <9698a99ccd1938a36dd0c7399262f888dcdf01ac.1638304316.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9698a99ccd1938a36dd0c7399262f888dcdf01ac.1638304316.git.maciej.szmigiero@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> Do a quick lookup for possibly overlapping gfns when creating or moving
> a memslot instead of performing a linear scan of the whole memslot set.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> [sean: tweaked params to avoid churn in future cleanup]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/kvm_main.c | 35 +++++++++++++++++++++--------------
>  1 file changed, 21 insertions(+), 14 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 086f18969bc3..52117f65bc5b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1817,6 +1817,18 @@ static int kvm_set_memslot(struct kvm *kvm,
>  	return 0;
>  }
>  
> +static bool kvm_check_memslot_overlap(struct kvm_memslots *slots, int id,
> +				      gfn_t start, gfn_t end)
> +{
> +	struct kvm_memslot_iter iter;
> +
> +	kvm_for_each_memslot_in_gfn_range(&iter, slots, start, end)

The for loop needs curly braces, per coding-style.rst:

Also, use braces when a loop contains more than a single simple statement:

.. code-block:: c

        while (condition) {
                if (test)
                        do_something();
        }

With that,

Reviewed-by: Sean Christopherson <seanjc@google.com>
