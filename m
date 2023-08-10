Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B73A7774D9
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 11:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbjHJJpO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 05:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbjHJJpM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 05:45:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038BB1BD9
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 02:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691660666;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lf+g7H8c+D8XIdvK87t5LbaETche7IdF7H8+sxCRQxo=;
        b=e2jlKN1Wib8eVdDn7s9VzJg/5KvnLETHAlAL5GsFp8nGZxUHYHt8dl9oVH9a2cUGC3WqLg
        a4hK64v72j1HKsahYaf1478eEQ6KtYJLBoVrztnTrRClbXdgshDIjqxSQkTtEOZfbMjk5m
        CHNFec8rx2BQ9VJdor4MRQ7AZv0WZ2Y=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-1lqTY6UKO4iuwVZAy7BUIw-1; Thu, 10 Aug 2023 05:44:25 -0400
X-MC-Unique: 1lqTY6UKO4iuwVZAy7BUIw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3fe1521678fso4416685e9.1
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 02:44:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691660663; x=1692265463;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lf+g7H8c+D8XIdvK87t5LbaETche7IdF7H8+sxCRQxo=;
        b=G9Ij4o4PKy5iaPFhAzXNoli0sVHoNITgrljfeUvmpYOHNwvgWJva6XgACZDQSKBLMo
         fgBSt9d5TyzvVly4USOEzY21yCvyyNPA+5ypZX6mAnU7QsNv4hPLPFIQO3cIDgXq327z
         OrcYWn+LYTsUzvxr6vZU2l7DyHFycYFhmodblXlVBwVQERvrrbGQIumNdJMt4Va8xVwF
         K37NH0C6C6/arm8Vi8bRFHmDJ+JjKJDUNW0uBHvzpjIAbnEAG9XMqX58t1C9rQKXqV6D
         Ga/UOE79QIzbe/r9YsmwjpcBTox2mxcmFOhWiXdXUt8uH1Cal/Eh/SZ8y4U7AU7Kz3Kh
         VlPg==
X-Gm-Message-State: AOJu0YwRQKsb3TLxQ1RazQ1XYFq+ubtN7B6fquaBX4wX3yExpivSy+4E
        RVYE5m1cbuPU2rEDhgTjB9AV6GTKPU49U8jjWT4HKeoXMzZ37yloo7vygQ88Artnqn9e3fACzvA
        yqU6XY7mA8vBQ
X-Received: by 2002:a05:600c:213:b0:3fa:934c:8356 with SMTP id 19-20020a05600c021300b003fa934c8356mr1511167wmi.10.1691660663603;
        Thu, 10 Aug 2023 02:44:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHETQi0vth3YGZzAHlU+FHSXk47nzzZTe9HU1FXKIvTwI+udFnJZFW42tqkZkyIGRj6hC56qA==
X-Received: by 2002:a05:600c:213:b0:3fa:934c:8356 with SMTP id 19-20020a05600c021300b003fa934c8356mr1511152wmi.10.1691660663318;
        Thu, 10 Aug 2023 02:44:23 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id y24-20020a05600c365800b003fe2b081661sm4429254wmq.30.2023.08.10.02.44.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 02:44:22 -0700 (PDT)
Message-ID: <367481f1-e1ee-9a2d-8822-2653c73ec746@redhat.com>
Date:   Thu, 10 Aug 2023 11:44:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 25/27] KVM: arm64: nv: Expose FGT to nested guests
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20230808114711.2013842-1-maz@kernel.org>
 <20230808114711.2013842-26-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230808114711.2013842-26-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/8/23 13:47, Marc Zyngier wrote:
> Now that we have FGT support, expose the feature to NV guests.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 7f80f385d9e8..3facd8918ae3 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -71,8 +71,9 @@ void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
>  		break;
>  
>  	case SYS_ID_AA64MMFR0_EL1:
> -		/* Hide ECV, FGT, ExS, Secure Memory */
> -		val &= ~(GENMASK_ULL(63, 43)		|
> +		/* Hide ECV, ExS, Secure Memory */
> +		val &= ~(NV_FTR(MMFR0, ECV)		|
> +			 NV_FTR(MMFR0, EXS)		|
>  			 NV_FTR(MMFR0, TGRAN4_2)	|
>  			 NV_FTR(MMFR0, TGRAN16_2)	|
>  			 NV_FTR(MMFR0, TGRAN64_2)	|
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

