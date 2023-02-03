Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B03A568A0C8
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 18:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbjBCRtX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 12:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbjBCRtQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 12:49:16 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED25E34306
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 09:48:56 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id mi9so5731909pjb.4
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 09:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1t48P/jVd6+3dhw3pck4JM1odaqwThYt8bjKIe9FySY=;
        b=YUGCo4ZbvxduWRBHH9xOGxUv8LoaXyN+VOL8K8Kve/u16uDaalEXH+kBO1C3PAOZdM
         U2FdeDmTEYvv/Khm9Hp1pGOcZfLi1gl8qmki4SmGN3WfKIsCemaDy6HsGXS8a2DwuvSq
         p7nNVpP/rnqBe+1jiPBY7eVjGaGnTjSVk5H8VHlpO4DlQHD7k1TC35BcdqTcy2ZQRaSF
         4md/KQ7IeYFOS2FYZ+qMRDUx2NMJplrAtBdVvGxGX0DbpsM7eAfg2iIiZtKPhF8ngclz
         nFNAH/NrZwg3lKNjgzMI4QsgFt81DdqqGb/JrZPeZ3VqGuwxbqlyijT98K4d4Jb58ATa
         yKNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1t48P/jVd6+3dhw3pck4JM1odaqwThYt8bjKIe9FySY=;
        b=dfR7fufDpVAtbzbYuijD89zS70X8y8Z5IuOGgKjf87qeOEyLjbkWTAKDA7sRojx4eh
         2KBvdOS9i4LQyHmetK9x8O9Zz8bgpZ/j3ZCJZ+KtGxybItCQpThCAcKozxdjSb9AW9sz
         2ZP2ZqFtNFhxLfq4oHMpZHxCsmo+vrdsKA8vjOcSGk3WDM3faaWyzV7rwZDFVvwrfkvK
         2ycjilHXGvtJR7Wqkjib3F8rdnkEnZql1SI6wv9yjOCu6Hq6JdBR9yTfPhpVk5oxyAMZ
         nXSqJYOaEr+HTNpjP2IEg6Lp/1n1IC1lLRLUQclzPwKGimuRPBffOaIc7lOFeCekFV6g
         sFEQ==
X-Gm-Message-State: AO0yUKW9AGV+O4rmsPWPzs+CXVKyfN9Pg1QnFHNh24wUgRZzNnWI78Nk
        ru7fMJY/dYX0ubV4rWq0juogFOooBaNpV3QMV+M=
X-Google-Smtp-Source: AK7set8NtYpsGJ6byRewhpDzAYHCL4kVnwYOuRswQz6j6iO+lQNMoz+KA+gf7NkDr7m6tVMm7U3Fmg==
X-Received: by 2002:a17:902:d1d5:b0:198:d5cc:44a8 with SMTP id g21-20020a170902d1d500b00198d5cc44a8mr260726plb.19.1675446534414;
        Fri, 03 Feb 2023 09:48:54 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b2-20020a1709027e0200b00194b3a7853esm1865998plm.181.2023.02.03.09.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 09:48:53 -0800 (PST)
Date:   Fri, 3 Feb 2023 17:48:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/7] KVM: x86: Improve return type handling in
 kvm_vm_ioctl_get_nr_mmu_pages()
Message-ID: <Y91JAb0kKBYQjO8a@google.com>
References: <20230203094230.266952-1-thuth@redhat.com>
 <20230203094230.266952-3-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203094230.266952-3-thuth@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 03, 2023, Thomas Huth wrote:
> kvm_vm_ioctl_get_nr_mmu_pages() tries to return a "unsigned long" value,
> but its caller only stores ther return value in an "int" - which is also
> what all the other kvm_vm_ioctl_*() functions are returning. So returning
> values that do not fit into a 32-bit integer anymore does not work here.
> It's better to adjust the return type, add a sanity check and return an
> error instead if the value is too big.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index da4bbd043a7b..caa2541833dd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6007,8 +6007,11 @@ static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
>  	return 0;
>  }
>  
> -static unsigned long kvm_vm_ioctl_get_nr_mmu_pages(struct kvm *kvm)
> +static int kvm_vm_ioctl_get_nr_mmu_pages(struct kvm *kvm)
>  {
> +	if (kvm->arch.n_max_mmu_pages > INT_MAX)
> +		return -EOVERFLOW;
> +
>  	return kvm->arch.n_max_mmu_pages;
>  }

My vote is to skip this patch, skip deprecation, and go straight to deleting
KVM_GET_NR_MMU_PAGES.  The ioctl() has never worked[*], and none of the VMMs I
checked use it (QEMU, Google's internal VMM, kvmtool, CrosVM).

[*] https://lore.kernel.org/all/YpZu6%2Fk+8EydfBKf@google.com
