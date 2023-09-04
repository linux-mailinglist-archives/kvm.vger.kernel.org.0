Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC50F79156E
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 12:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjIDKAn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 06:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbjIDKAm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 06:00:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752AB1B9
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 02:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693821574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/gLQONe3A7A3zhpq2R2f2t/QPz1+qDDXvx06VKYHFco=;
        b=GTxicPdNtOoCNWUBEHaD+9dZVoAjtyQfJMWrJhL+DtLoO3DZCyfNCbhKM32t61rEmiYSWo
        ZzzT8eZhpxp0jNyPBp8wyz4D2ZbgkPDMKoEzqIt3zgQTktLnP34oSPqT6VOK/BbxwKttNq
        btBgx8Mgk2r1ZCZ2S3c+B4ROtdxOiDY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-McadVaAdOnKuZCkSQdYf8g-1; Mon, 04 Sep 2023 05:59:33 -0400
X-MC-Unique: McadVaAdOnKuZCkSQdYf8g-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-314256aedcbso648923f8f.0
        for <kvm@vger.kernel.org>; Mon, 04 Sep 2023 02:59:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693821572; x=1694426372;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/gLQONe3A7A3zhpq2R2f2t/QPz1+qDDXvx06VKYHFco=;
        b=DGgonmaG5dc6xLJFxWbmqLP9ryz3FfBeDH4o7+qR+v/kBJSMwJYmpMU9Ra+tq4LHIS
         wmxmSxWoBX32JGXRNqhoVzovMvkVUiRGu+9T20Af+x8oEXKuy/VJl4OSZCc9Gfj6ed23
         OCdocMKesucXoK2AYOUwrgjt50hBQt/mBzFAZNIzgPGjz9uMjOCkaKbBlu9ByY1EkVER
         60Sr2AzL396yLCLJMGN2TQZCqdYfxIC/GXuSsxX5fz13jq2m7zKP6+IqlZTR37FYCBSL
         gc7FcMfX8kx/ZpS3wcF7Xf+TsS6l2ouPWPlHt+tMYXK1qyJzkoyagpKgDgsPUP2PWf3D
         Otmg==
X-Gm-Message-State: AOJu0YziTM73lY93MkLPRHEQhgNODJaXq8JlMS/UzFwAvP3WAdR2gOU0
        Vfp9QP78igwviqP4dR0NgVGwQsdUay+oA9ITKQuuQAZRHhIpwWgrQR2+PFnTsUcB8sZgmyMNrZ/
        YzuONZ/ZyajWp0IZDI9TfbBU=
X-Received: by 2002:a5d:4803:0:b0:313:f5f8:a331 with SMTP id l3-20020a5d4803000000b00313f5f8a331mr5923392wrq.34.1693821572322;
        Mon, 04 Sep 2023 02:59:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEaOZWp3NC9aQ89fp1eDlPRv2ilOOeQD7G7e3dFArroHsCUJ+caLPVVnJf4hSIVe9Nl9ly3vw==
X-Received: by 2002:a5d:4803:0:b0:313:f5f8:a331 with SMTP id l3-20020a5d4803000000b00313f5f8a331mr5923382wrq.34.1693821572032;
        Mon, 04 Sep 2023 02:59:32 -0700 (PDT)
Received: from [10.33.192.199] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id n18-20020a5d4012000000b0031c79de4d8bsm14060748wrp.106.2023.09.04.02.59.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Sep 2023 02:59:31 -0700 (PDT)
Message-ID: <e6b8a718-4c99-cd37-c73f-fcb604a67af4@redhat.com>
Date:   Mon, 4 Sep 2023 11:59:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [kvm-unit-tests PATCH v6 3/8] s390x: sie: switch to home space
 mode before entering SIE
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230904082318.1465055-1-nrb@linux.ibm.com>
 <20230904082318.1465055-4-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230904082318.1465055-4-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/09/2023 10.22, Nico Boehr wrote:
> This is to prepare for running guests without MSO/MSL, which is
> currently not possible.
> 
> We already have code in sie64a to setup a guest primary ASCE before
> entering SIE, so we can in theory switch to the page tables which
> translate gpa to hpa.
> 
> But the host is running in primary space mode already, so changing the
> primary ASCE before entering SIE will also affect the host's code and
> data.
> 
> To make this switch useful, the host should run in a different address
> space mode. Hence, set up and change to home address space mode before
> installing the guest ASCE.
> 
> The home space ASCE is just copied over from the primary space ASCE, so
> no functional change is intended, also for tests that want to use
> MSO/MSL. If a test intends to use a different primary space ASCE, it can
> now just set the guest.asce in the save_area.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   lib/s390x/asm/arch_def.h |  1 +
>   lib/s390x/sie.c          | 26 ++++++++++++++++++++++++++
>   2 files changed, 27 insertions(+)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 5638fd01fd85..90a178ca0351 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -93,6 +93,7 @@ enum address_space {
>   };
>   
>   #define PSW_MASK_DAT			0x0400000000000000UL
> +#define PSW_MASK_HOME			0x0000C00000000000UL
>   #define PSW_MASK_IO			0x0200000000000000UL
>   #define PSW_MASK_EXT			0x0100000000000000UL
>   #define PSW_MASK_KEY			0x00F0000000000000UL
> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> index b44febdeaaac..7f4474555ff7 100644
> --- a/lib/s390x/sie.c
> +++ b/lib/s390x/sie.c
> @@ -52,6 +52,8 @@ void sie_handle_validity(struct vm *vm)
>   
>   void sie(struct vm *vm)
>   {
> +	uint64_t old_cr13;
> +
>   	if (vm->sblk->sdf == 2)
>   		memcpy(vm->sblk->pv_grregs, vm->save_area.guest.grs,
>   		       sizeof(vm->save_area.guest.grs));
> @@ -59,6 +61,24 @@ void sie(struct vm *vm)
>   	/* Reset icptcode so we don't trip over it below */
>   	vm->sblk->icptcode = 0;
>   
> +	/*
> +	 * Set up home address space to match primary space. Instead of running
> +	 * in home space all the time, we switch every time in sie() because:
> +	 * - tests that depend on running in primary space mode don't need to be
> +	 *   touched
> +	 * - it avoids regressions in tests
> +	 * - switching every time makes it easier to extend this in the future,
> +	 *   for example to allow tests to run in whatever space they want

If we want tests to be able in other modes in the future...

> +	 */
> +	old_cr13 = stctg(13);
> +	lctlg(13, stctg(1));
> +
> +	/* switch to home space so guest tables can be different from host */
> +	psw_mask_set_bits(PSW_MASK_HOME);
> +
> +	/* also handle all interruptions in home space while in SIE */
> +	irq_set_dat_mode(true, AS_HOME);
> +
>   	while (vm->sblk->icptcode == 0) {
>   		sie64a(vm->sblk, &vm->save_area);
>   		sie_handle_validity(vm);
> @@ -66,6 +86,12 @@ void sie(struct vm *vm)
>   	vm->save_area.guest.grs[14] = vm->sblk->gg14;
>   	vm->save_area.guest.grs[15] = vm->sblk->gg15;
>   
> +	irq_set_dat_mode(true, AS_PRIM);
> +	psw_mask_clear_bits(PSW_MASK_HOME);

... we should maybe restore the previous mode here instead of switching 
always to primary mode?

Anyway, could be done later, but you might want to update your comment.

Reviewed-by: Thomas Huth <thuth@redhat.com>

