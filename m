Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF3569D24F
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 18:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbjBTRrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 12:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbjBTRrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 12:47:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643FB206A1
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 09:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676915181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ck/8YAQ6br4cg4ndwhAICwHSU+oSs0QdaDqjZp8nNfE=;
        b=D8Jilf6to6LqQ5fttr2vt2BOjQDwMzw9V9PqwzjKtsZtgus3F1jU2gnfG8Uot2bCZBTHyj
        9q1PQSxAUgEKb1TBBI2iIXDs/Z/EMWu7oCHkLDMBnuYhzO7iCgMv8w5jTFxVpWT4T+3HId
        llOLE+Z8Dmg99ZGAkGjwrYNthWokbFU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-427-zqk_0xjWPgeCL0tv4gs6yg-1; Mon, 20 Feb 2023 12:46:20 -0500
X-MC-Unique: zqk_0xjWPgeCL0tv4gs6yg-1
Received: by mail-ed1-f69.google.com with SMTP id k12-20020a50c8cc000000b004accf30f6d3so2586569edh.14
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 09:46:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ck/8YAQ6br4cg4ndwhAICwHSU+oSs0QdaDqjZp8nNfE=;
        b=r5w6PfAmz0tSggappmzZma9qBz8wg2N5IcP9Mx4SCowXKyOZ3N7OI2y1tAConjivM7
         pid/HfKzN8WOYk/GWHXGxV9Lxl3wJ5N+E6/u456enuhhWZTj1dOFfeDwEY/PQL69kC3G
         Paqee6RCrIJPlbgwgb+shoDcUeunbuokeh+HE1YbaE0iOFsw7THGyrRFwcm7Ftzr7jKR
         KB7DGBbVDtNFyNhc7bubVZ2RsMAyGEp5EfnvT8tHHqAPawcZuplOClm4A+2ubWG3OSZe
         MyuF73Lpo4Y34lykZ7BpVO03tdIIFc59goPGceGrJJrK4eXPeyZrNHsCfHh5wolHRjy+
         4FXw==
X-Gm-Message-State: AO0yUKUWXx3hjsik9bxsr0t2oVK31lbvbNeDK8ypfKhFBngX9SHBmvzO
        +SUuH9eszSijX4IUg7GVCR1QC3O77eEFbOuCULvpc3GCfpNSpD94UEXWVRerpoMbjp4H7nX9+Bl
        4By2LpRt8W9Av
X-Received: by 2002:a17:907:9714:b0:8b1:7eba:de5 with SMTP id jg20-20020a170907971400b008b17eba0de5mr9354783ejc.10.1676915179027;
        Mon, 20 Feb 2023 09:46:19 -0800 (PST)
X-Google-Smtp-Source: AK7set/Tg+D8jplbtCuUA/KAbL7Qq6RReoePpMuhnouFw3R+uTK3cUHQ5gyse11r3SB4HbH+iQqFqw==
X-Received: by 2002:a17:907:9714:b0:8b1:7eba:de5 with SMTP id jg20-20020a170907971400b008b17eba0de5mr9354767ejc.10.1676915178760;
        Mon, 20 Feb 2023 09:46:18 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:4783:a68:c1ee:15c5? ([2001:b07:6468:f312:4783:a68:c1ee:15c5])
        by smtp.googlemail.com with ESMTPSA id ce6-20020a170906b24600b008b1fc59a22esm4860751ejb.65.2023.02.20.09.46.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Feb 2023 09:46:18 -0800 (PST)
Message-ID: <bf4111f9-f722-1847-4f1d-964c5356f392@redhat.com>
Date:   Mon, 20 Feb 2023 18:46:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn
References: <20230220065735.1282809-1-zhaotianrui@loongson.cn>
 <20230220065735.1282809-3-zhaotianrui@loongson.cn>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 02/29] LoongArch: KVM: Implement kvm module related
 interface
In-Reply-To: <20230220065735.1282809-3-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/20/23 07:57, Tianrui Zhao wrote:
> +	order = get_order(kvm_vector_size + kvm_enter_guest_size);
> +	addr = (void *)__get_free_pages(GFP_KERNEL, order);
> +	if (!addr) {
> +		free_percpu(vmcs);
> +		return -ENOMEM;
> +	}
> +
> +	memcpy(addr, kvm_vector_entry, kvm_vector_size);
> +	memcpy(addr + kvm_vector_size, kvm_enter_guest, kvm_enter_guest_size);
> +	flush_icache_range((unsigned long)addr, (unsigned long)addr +
> +				kvm_vector_size + kvm_enter_guest_size);
> +
> +	vpid_mask = read_csr_gstat();
> +	vpid_mask = (vpid_mask & CSR_GSTAT_GIDBIT) >> CSR_GSTAT_GIDBIT_SHIFT;
> +	if (vpid_mask)
> +		vpid_mask = GENMASK(vpid_mask - 1, 0);
> +
> +	for_each_possible_cpu(cpu) {
> +		context = per_cpu_ptr(vmcs, cpu);
> +		context->vpid_mask = vpid_mask;
> +		context->vpid_cache = context->vpid_mask + 1;
> +		context->last_vcpu = NULL;
> +		context->kvm_eentry = addr;
> +		context->kvm_enter_guest = addr + kvm_vector_size;
> +		context->page_order = order;
> +	}

A lot of these variables are constant across all pCPUs, any reason to 
have them in a per-CPU variable?  Likewise, since they are all the same 
as the constant global vmcs variable, why make them part of struct 
kvm_context instead of just making them globals?

Also, why does the world switch code need a copy?

Paolo

