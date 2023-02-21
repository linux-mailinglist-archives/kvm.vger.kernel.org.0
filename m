Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C72FB69DBCB
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 09:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbjBUITU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 03:19:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbjBUITS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 03:19:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B08D61B2
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 00:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676967508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Q9DXR9c/98x6MLgurW6BjSZNM+15j/q21SM5lNGnmM=;
        b=hC8zLqq6ivlDho9H6SceYexnRhGAFO0SzSAOlVOgTsxd6CHvP3mfwXoKvxPxFUsyAbpe2k
        DPvnAO9rr2ta6kJdCxtjSlJniwmXG6wXDSUHoMrZy+yLLIxmvtj7MkSyTjeRIrZWjfmZ/d
        RC0O2etZ0GIO2wkFEtRq2pk3WG5jZJQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-671-Rkm7A5SMNQulxst9eWDV-Q-1; Tue, 21 Feb 2023 03:18:27 -0500
X-MC-Unique: Rkm7A5SMNQulxst9eWDV-Q-1
Received: by mail-ed1-f72.google.com with SMTP id fi8-20020a056402550800b004a26cc7f6cbso4827040edb.4
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 00:18:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Q9DXR9c/98x6MLgurW6BjSZNM+15j/q21SM5lNGnmM=;
        b=lL6a5sE0jUTWLPsDq0iGKny2sVcLviCdcOnogz/HOpuROf7W8PYV2YYKUvoCztr7FC
         4aSn6TeNJAgiWjbgfGvE3MUsUHyPftC5iXeGZaLkqNHXLj0y6EEz5tizT4RoGhCJ/C3Z
         RFuie5091wIkezSIqdy7NCK/49LSCp+LQU0L5i0UYwGJXDL+WMem+iDpuiX66T2wkQJ9
         q31p/UqOQprtrFXnDAPrHbqgsvz2ZbN7/g8dzrbwDTLOjrrdQIQDyUTvnII+Xv0XZV6+
         zs/dUx+dD1eFSFFaK0TvlzCbfsdd3SCh/Wh6paG6dwUFt1fq+Hhi2TGikvJ5s7b5YGmg
         zNug==
X-Gm-Message-State: AO0yUKXymosioRWhKvaBn1Rv4P4W7NlTU34s9taJVxbFoOB4SFEFB1WQ
        8xp+tajQ1/AxnpJr19oTMZ/PlozuFsRz8swWsvkAE20M8ZsS5Ycj3WfnFFlOt1nd993BL7HO+e1
        7Yw1uA+zqEabq
X-Received: by 2002:a05:6402:4d7:b0:4aa:a4e6:249b with SMTP id n23-20020a05640204d700b004aaa4e6249bmr3187526edw.7.1676967506599;
        Tue, 21 Feb 2023 00:18:26 -0800 (PST)
X-Google-Smtp-Source: AK7set8xPE7WF5tDEzWbZK1Iiga5OQ9VlwlnqkIhKs0RrfYvTje5J5MCyKIkQTgUywWNW3v04H6uPQ==
X-Received: by 2002:a05:6402:4d7:b0:4aa:a4e6:249b with SMTP id n23-20020a05640204d700b004aaa4e6249bmr3187517edw.7.1676967506319;
        Tue, 21 Feb 2023 00:18:26 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id f7-20020a50d547000000b00488117821ffsm1415752edj.31.2023.02.21.00.18.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 00:18:25 -0800 (PST)
Message-ID: <884fdf34-e675-2ebe-e37f-6aeb696a0922@redhat.com>
Date:   Tue, 21 Feb 2023 09:18:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 27/29] LoongArch: KVM: Implement vcpu world switch
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
 <20230220065735.1282809-28-zhaotianrui@loongson.cn>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230220065735.1282809-28-zhaotianrui@loongson.cn>
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
> +	or	a0, s0, zero
> +	or	a1, s1, zero
> +	ld.d	t8, a2, KVM_ARCH_HANDLE_EXIT
> +	jirl	ra,t8, 0
> +	ori	t0, zero, CSR_CRMD_IE
> +	csrxchg	zero, t0, LOONGARCH_CSR_CRMD

_kvm_handle_exit returns with the interrupts disabled.

Can you please add a comment to explain why CRMD.IE needs to be cleared 
here, or remove these two instructions if unnecessary?

Paolo

> +	or	a2, s1, zero
> +	addi.d	a2, a2, KVM_VCPU_ARCH
> +
> +	andi	t0, a0, RESUME_HOST
> +	bnez	t0, ret_to_host

