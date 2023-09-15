Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D328B7A15DF
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 08:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbjIOGGK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 02:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjIOGGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 02:06:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D95731BF2
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 23:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694757916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3vjvuseUg6qNQpV7yl7mlZYb0V/K1W4pCetzu6/7ou8=;
        b=M9flNbqPlEluOlI0/VBJLcFzoQxk4P+eXz9MwDiwVDV2ZRL7RogKVDs3Ygbo+2+jlIGDjv
        bwfO1oiSeZmDTrufDC5uasSQUYeBUcreRvuod0LWKiriuL4nqIxqf08YM9e/+k3oaUwl7z
        C6v3cThvmrpvncrDH/PCiXy6asq3xi8=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-288-HsDuOLb4Oyu8zyMwLAh8IQ-1; Fri, 15 Sep 2023 02:05:15 -0400
X-MC-Unique: HsDuOLb4Oyu8zyMwLAh8IQ-1
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-6c0dbf0734eso2231181a34.3
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 23:05:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694757915; x=1695362715;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3vjvuseUg6qNQpV7yl7mlZYb0V/K1W4pCetzu6/7ou8=;
        b=q7ZYwgRYKhhS3byV8m6agRGeDpqPFPdoAhNVLnVydukwymeOT0ql7T2gwW/2h3jg5e
         oVBxLgYo67zloMyX65bnBhzQ0Rh1j3qcKFpXdgCFNGNZPK8L6DEspeo652fd4YxfW2Nl
         jK5Asr4aklTNkQCVBV5B2XK9eKstt93DCdTuOQdKU4SDdHGHXQHDVvEN3TVVORQObCmj
         ljsgpcBQHQJj+qDZT2pQqJdBLEIPfbuQSkepM6OHtAhIF43FKOXKdlCgGdJVWCBcPmXN
         cV+EW785h/uIRs78oq1s/Fwaq6/Qqe6pjvC8NwlMVvtxuVCrp/VHF+vUsMt90dXBbl18
         /8Xw==
X-Gm-Message-State: AOJu0Ywj7XgixS4jHDrp5x/iW5De4hgcgtVh6ND15M8I0Ewl44/69CKv
        Rym0XDo9CDKKcGfQDxLsSKz/ukCms95FOmGdCVvDGt/XhnTI6fSedPpSijSlUOiNu3TElDMmsnL
        uPiApoVQ6s4OH
X-Received: by 2002:a9d:639a:0:b0:6bb:1c21:c52e with SMTP id w26-20020a9d639a000000b006bb1c21c52emr621368otk.15.1694757914809;
        Thu, 14 Sep 2023 23:05:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHNTkcLzZRrBx+Jpr7GLG62ISgWsC1FQJ/6MO+vKOCF0E/D50pmRfuPJnzxZifFOuWDgu4/ZQ==
X-Received: by 2002:a9d:639a:0:b0:6bb:1c21:c52e with SMTP id w26-20020a9d639a000000b006bb1c21c52emr621363otk.15.1694757914520;
        Thu, 14 Sep 2023 23:05:14 -0700 (PDT)
Received: from redhat.com ([2804:1b3:a803:4ff9:7c29:fe41:6aa7:43df])
        by smtp.gmail.com with ESMTPSA id c9-20020a056830000900b006ba864f5b37sm1353275otp.12.2023.09.14.23.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 23:05:13 -0700 (PDT)
Date:   Fri, 15 Sep 2023 03:05:04 -0300
From:   Leonardo Bras <leobras@redhat.com>
To:     guoren@kernel.org
Cc:     paul.walmsley@sifive.com, anup@brainfault.org,
        peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        palmer@rivosinc.com, longman@redhat.com, boqun.feng@gmail.com,
        tglx@linutronix.de, paulmck@kernel.org, rostedt@goodmis.org,
        rdunlap@infradead.org, catalin.marinas@arm.com,
        conor.dooley@microchip.com, xiaoguang.xing@sophgo.com,
        bjorn@rivosinc.com, alexghiti@rivosinc.com, keescook@chromium.org,
        greentime.hu@sifive.com, ajones@ventanamicro.com,
        jszhang@kernel.org, wefu@redhat.com, wuwei2016@iscas.ac.cn,
        linux-arch@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-csky@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>
Subject: Re: [PATCH V11 12/17] RISC-V: paravirt: pvqspinlock: Add nopvspin
 kernel parameter
Message-ID: <ZQP0EJc4ClA-iT6J@redhat.com>
References: <20230910082911.3378782-1-guoren@kernel.org>
 <20230910082911.3378782-13-guoren@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230910082911.3378782-13-guoren@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 10, 2023 at 04:29:06AM -0400, guoren@kernel.org wrote:
> From: Guo Ren <guoren@linux.alibaba.com>
> 
> Disables the qspinlock slow path using PV optimizations which
> allow the hypervisor to 'idle' the guest on lock contention.
> 
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Guo Ren <guoren@kernel.org>
> ---
>  Documentation/admin-guide/kernel-parameters.txt |  2 +-
>  arch/riscv/kernel/qspinlock_paravirt.c          | 13 +++++++++++++
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index f75bedc50e00..e74aed631573 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -3857,7 +3857,7 @@
>  			as generic guest with no PV drivers. Currently support
>  			XEN HVM, KVM, HYPER_V and VMWARE guest.
>  
> -	nopvspin	[X86,XEN,KVM]
> +	nopvspin	[X86,XEN,KVM,RISC-V]
>  			Disables the qspinlock slow path using PV optimizations
>  			which allow the hypervisor to 'idle' the guest on lock
>  			contention.
> diff --git a/arch/riscv/kernel/qspinlock_paravirt.c b/arch/riscv/kernel/qspinlock_paravirt.c
> index 85ff5a3ec234..a0ad4657f437 100644
> --- a/arch/riscv/kernel/qspinlock_paravirt.c
> +++ b/arch/riscv/kernel/qspinlock_paravirt.c
> @@ -41,8 +41,21 @@ EXPORT_STATIC_CALL(pv_queued_spin_lock_slowpath);
>  DEFINE_STATIC_CALL(pv_queued_spin_unlock, native_queued_spin_unlock);
>  EXPORT_STATIC_CALL(pv_queued_spin_unlock);
>  
> +static bool nopvspin;

It is only used in init, so it makes sense to add __initdata.

static bool nopvspin __initdata;

Other than that, LGTM:
Reviewed-by: Leonardo Bras <leobras@redhat.com>

Thanks!
Leo

> +static __init int parse_nopvspin(char *arg)
> +{
> +       nopvspin = true;
> +       return 0;
> +}
> +early_param("nopvspin", parse_nopvspin);
> +
>  void __init pv_qspinlock_init(void)
>  {
> +	if (nopvspin) {
> +		pr_info("PV qspinlocks disabled\n");
> +		return;
> +	}
> +
>  	if (num_possible_cpus() == 1)
>  		return;
>  
> -- 
> 2.36.1
> 

