Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E843154E2FF
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 16:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376655AbiFPOH4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 10:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377315AbiFPOHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 10:07:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A7CD911C20
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 07:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655388472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vj6vIUe+P865+ulNfTshQe6lyGdt3w3qdMjI5aQiat4=;
        b=JqMEZBwTN4+k5OPzUvar8kqv6GrrljFPlkICwa/rJqt7APT8vHtJ9HhZ5mcsihSg2s525j
        V8ymoqITsoR48OCaoFaw4wj6+3M7oOkjIZ9DNiVFDnaOJRVaAJQbTrc+1pcA0G6VA27ali
        vsj/zQPcCPargCkJfJM49o7BO+O9H1Y=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459--r3EnrBUM7e31fw6YBK9PA-1; Thu, 16 Jun 2022 10:07:49 -0400
X-MC-Unique: -r3EnrBUM7e31fw6YBK9PA-1
Received: by mail-ej1-f70.google.com with SMTP id gh36-20020a1709073c2400b0070759e390fbso652279ejc.13
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 07:07:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vj6vIUe+P865+ulNfTshQe6lyGdt3w3qdMjI5aQiat4=;
        b=nRPGtWtbce/IcT/0xJ7TDyV1JuC0QdeQVhnTtiwfm1BJRa9c9i7aSaAu1E4od3QMhN
         lyXFf6z1/h7y8Xend6rSR9sS1GCL6wQCJW3Zu3odK0160sg1A/Ic/VHh2aiPQWXKMc/4
         cWfbYKO65MEKzQf4WQYYUBrssiT8eEHOmeIegjTE98GxkF+AHw0ITbZP2FEtDQjwwTDJ
         qWPxRJ2Rz9tq627JUFVT/5oJ7AfWlzdjLJjPNWSzsGuxsNotXkdUyDzOiaHaxgFDdduP
         bAPKxzaqqPZTzzvF5T9hd2cDDq/Bn4y7ev+DA20lj3e4eYsfmyCd1AHIk4WFVLLgLBCP
         bppg==
X-Gm-Message-State: AJIora9YPPPNjRemt81kywEFzftG4CdIa30Ix1yUlzawOkX/ocqNPqPN
        rexZ6tOzqbfZmJMT1bk9tEccY3IKOWW07ensq+/ArZSe+BrQbCgqr3mY5ODEnZeOrQuY2Eaqm1B
        FCGi0nZ+YGE1t
X-Received: by 2002:a17:906:1501:b0:715:76d0:862a with SMTP id b1-20020a170906150100b0071576d0862amr4631440ejd.681.1655388466604;
        Thu, 16 Jun 2022 07:07:46 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tjkTdqr/3szBK+kh0+YeurMBpG7920Nr3gO+Ai5BarLS9mhezzaOW933L2KCBhcv/9T2taOg==
X-Received: by 2002:a17:906:1501:b0:715:76d0:862a with SMTP id b1-20020a170906150100b0071576d0862amr4631421ejd.681.1655388466369;
        Thu, 16 Jun 2022 07:07:46 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
        by smtp.gmail.com with ESMTPSA id rh17-20020a17090720f100b006fef5088792sm812870ejb.108.2022.06.16.07.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 07:07:45 -0700 (PDT)
Date:   Thu, 16 Jun 2022 16:07:43 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH 1/2] KVM: selftests: kvm_vm_elf_load() and elfhdr_get()
 should close fd
Message-ID: <20220616140743.gnokbxu67pjz6phs@gator>
References: <20220217034947.180935-1-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217034947.180935-1-reijiw@google.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Can you pick this old patch up?

Thanks,
drew

On Wed, Feb 16, 2022 at 07:49:46PM -0800, Reiji Watanabe wrote:
> kvm_vm_elf_load() and elfhdr_get() open one file each, but they
> never close the opened file descriptor.  If a test repeatedly
> creates and destroys a VM with vm_create_with_vcpus(), which
> (directly or indirectly) calls those two functions, the test
> might end up getting a open failure with EMFILE.
> Fix those two functions to close the file descriptor.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  tools/testing/selftests/kvm/lib/elf.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
> index 13e8e3dcf984..9b23537a3caa 100644
> --- a/tools/testing/selftests/kvm/lib/elf.c
> +++ b/tools/testing/selftests/kvm/lib/elf.c
> @@ -91,6 +91,7 @@ static void elfhdr_get(const char *filename, Elf64_Ehdr *hdrp)
>  		"  hdrp->e_shentsize: %x\n"
>  		"  expected: %zx",
>  		hdrp->e_shentsize, sizeof(Elf64_Shdr));
> +	close(fd);
>  }
>  
>  /* VM ELF Load
> @@ -190,4 +191,5 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
>  				phdr.p_filesz);
>  		}
>  	}
> +	close(fd);
>  }
> -- 
> 2.35.1.473.g83b2b277ed-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

