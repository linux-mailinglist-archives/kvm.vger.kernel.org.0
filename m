Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 996C17B285D
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 00:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbjI1WXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 18:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231980AbjI1WXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 18:23:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1781BB
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 15:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695939700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VYqIaFDftvj8+TDcTZgaXgu9cICTLPBd1GmPz49S0qk=;
        b=ABakTvh+Sb7ohiNbJUAUE+lcOUBdsAskCC2flRA2/pz9KXcsSO8oSqE9F8VCHUL8TMLT2B
        WxjNjNEToipNxKJ2NLkf+5MVoGsN+LW0h/qzM2p6Kz3DtDimxAYX3wg+RBTHNA6LkmgSaj
        1S5AtBMwXCH4mgoHwuXs1GdBDiMqFfo=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-xG2CebwaO9KCY67nCb7czQ-1; Thu, 28 Sep 2023 18:21:39 -0400
X-MC-Unique: xG2CebwaO9KCY67nCb7czQ-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7a2576bdcb7so182513939f.0
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 15:21:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695939698; x=1696544498;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VYqIaFDftvj8+TDcTZgaXgu9cICTLPBd1GmPz49S0qk=;
        b=QbP6PNVr4APGk0qnARIkNHhBcVKzDQIEhpnlhLPIGTYUonBk1tnfk4WHBuxLdj0ZE/
         pmCxo7jd32BDwg7lCr3UqyRG86oVTUq64P6Ll/vYq401qnyaII2p+bMqFO3K7YQbg1wZ
         Li0mcajl/raMBoL7SDNLe3HEgGrmT5v7YMXdMFKQLRuDuAjIX6Qy27o9EJ8tbqQfF668
         UnSGF/QT2S3Zf22Upq/Xyi3HLUTT9pHOUllzcbn+yAdpXRZy0nOMI5aA6xVW7Z/UXdd7
         +LLCWLoSjO7YcA27+165qLbYQ6YWO2ba5mQ0Psf0Ifxmc+46oFkSLDFvftWigaesW9/x
         ZtMA==
X-Gm-Message-State: AOJu0YxCYqF7qLxptsYh6SJirU4PFpMfKMv0LnHZHB3S2Pw6r8/wej0b
        BJXdb5a0Vj7lGUxn4/j6y5iKBy2v/4MC8fsmEVC/aE4M6bm1D7BFKO15uUkB4n8gUkiEuJU3PDc
        oFgDa/DVw1gQD
X-Received: by 2002:a05:6602:2211:b0:798:3cb5:ad30 with SMTP id n17-20020a056602221100b007983cb5ad30mr2909912ion.7.1695939698490;
        Thu, 28 Sep 2023 15:21:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEv0LRR9DkFI1OYy1PoOT1i3eAWQj2VngBzVVO4xeK3kF6WDlUiAdkJKTL/cdHqWL0xs+JJYA==
X-Received: by 2002:a05:6602:2211:b0:798:3cb5:ad30 with SMTP id n17-20020a056602221100b007983cb5ad30mr2909893ion.7.1695939698157;
        Thu, 28 Sep 2023 15:21:38 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id t23-20020a02c497000000b0042b10d42c90sm4610172jam.113.2023.09.28.15.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 15:21:37 -0700 (PDT)
Date:   Thu, 28 Sep 2023 16:21:06 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Andy Lutomirski <luto@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Anish Ghulati <aghulati@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        Andrew Thornton <andrewth@google.com>
Subject: Re: [PATCH 03/26] virt: Declare and define vfio_file_set_kvm() iff
 CONFIG_KVM is enabled
Message-ID: <20230928162106.0b0de53c.alex.williamson@redhat.com>
In-Reply-To: <20230916003118.2540661-4-seanjc@google.com>
References: <20230916003118.2540661-1-seanjc@google.com>
        <20230916003118.2540661-4-seanjc@google.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Sep 2023 17:30:55 -0700
Sean Christopherson <seanjc@google.com> wrote:

> Hide vfio_file_set_kvm() and its unique helpers if KVM is not enabled,
> nothing else in the kernel (or out of the kernel) should be using a
> KVM specific helper.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/vfio/vfio_main.c | 2 +-
>  include/linux/vfio.h     | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)


As Jason noted, s/virt/vfio/ in title.

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 6368eed7b7b2..124cc88966a7 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1352,7 +1352,6 @@ void vfio_device_put_kvm(struct vfio_device *device)
>  clear:
>  	device->kvm = NULL;
>  }
> -#endif
>  
>  static void vfio_device_file_set_kvm(struct file *file, struct kvm *kvm)
>  {
> @@ -1388,6 +1387,7 @@ void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
>  		vfio_device_file_set_kvm(file, kvm);
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
> +#endif
>  
>  /*
>   * Sub-module support
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 454e9295970c..e80955de266c 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -311,7 +311,9 @@ static inline bool vfio_file_has_dev(struct file *file, struct vfio_device *devi
>  #endif
>  bool vfio_file_is_valid(struct file *file);
>  bool vfio_file_enforced_coherent(struct file *file);
> +#if IS_ENABLED(CONFIG_KVM)
>  void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
> +#endif
>  
>  #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
>  

