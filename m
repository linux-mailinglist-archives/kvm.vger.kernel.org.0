Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE266340C6
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234208AbiKVQDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbiKVQDD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:03:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D28A725D8
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:02:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669132928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D2WgN9uHr4xkqV1mAsY0pHQqDjGcrUIp9oZrUjlU7AA=;
        b=aJWnN66N7r0WfSxDRG8vndJmeaVNPIa09MGk4iml8zWv/NNkYUxnM1Qwmad0EYAuWVMau6
        uigk+SL3+/AhAaiGAO3sMc8yfW3WSv5n3u2w2YWM2XKbVbxjo/hNQ/6ir90rNkDK/KO6dG
        WFa6ZsJAgJjDv+Wsx2KXx3bN0yqa1/A=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-390-OaVjqFT6OpCDUbYcuQQu6w-1; Tue, 22 Nov 2022 11:02:07 -0500
X-MC-Unique: OaVjqFT6OpCDUbYcuQQu6w-1
Received: by mail-ed1-f69.google.com with SMTP id f17-20020a056402355100b00466481256f6so9045687edd.19
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:02:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D2WgN9uHr4xkqV1mAsY0pHQqDjGcrUIp9oZrUjlU7AA=;
        b=qzO90e0wMdbL3NPpr6kXLrjN4ixzn9NbB/hXTts7QZsiH1J2X8juoIAUs/vh2NCORv
         NU6dDBb5csIlhEogcYrJxXvH6omVqZnQq4knz0vPXH3xQSeQLKhWOQ/JTkSEOx3chLJS
         Z44Y0RwNdZ3Ikgs5iIApJn9HWZkTAehv047K4ejuiljFq9jqyn5emmzBo20H9S/AMB5u
         LIWXz05ZgNSmnZ8RG7eLj8kkDCGy5jTiFI2MMBcvwtZ3NRH7KMYc9AouPrSW/+JJvoH5
         MSdgIeCE5P+aTmgqMa//nfkZ0Y0sBb6Dty5RU5bBvpZW3jZug2h+0cXcjaKgQKUH1uun
         5S6w==
X-Gm-Message-State: ANoB5plGt2cmN2SwXqs+xuJiyNuM93Qpntmf57cTNS4n2N4t6/dblDkX
        Cukx0QFRZsAzjrrw8izeFsatYUTz/FFidAZC8ZR7i3aTmgi7SNset4FUaZlygLTBSwLSB0scEyR
        AwpG0t5YHpZaQ
X-Received: by 2002:a05:6402:181:b0:461:ea0c:e151 with SMTP id r1-20020a056402018100b00461ea0ce151mr7561104edv.376.1669132925660;
        Tue, 22 Nov 2022 08:02:05 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6TDMkrWDIXsg+TPevcjHIgzRaABa4hBY5DAEMlRIwo/X5HFFnfDWRG2OY4xwCS3WES306BUA==
X-Received: by 2002:a05:6402:181:b0:461:ea0c:e151 with SMTP id r1-20020a056402018100b00461ea0ce151mr7561077edv.376.1669132925356;
        Tue, 22 Nov 2022 08:02:05 -0800 (PST)
Received: from ovpn-194-185.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id r11-20020a056402034b00b004587f9d3ce8sm6535802edw.56.2022.11.22.08.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 08:02:04 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Subject: Re: [PATCH v2 3/6] KVM: selftests: Test Hyper-V extended hypercall
 enablement
In-Reply-To: <20221121234026.3037083-4-vipinsh@google.com>
References: <20221121234026.3037083-1-vipinsh@google.com>
 <20221121234026.3037083-4-vipinsh@google.com>
Date:   Tue, 22 Nov 2022 17:02:03 +0100
Message-ID: <87h6yrou4k.fsf@ovpn-194-185.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vipin Sharma <vipinsh@google.com> writes:

> Test Hyper-V extended hypercall, HV_EXT_CALL_QUERY_CAPABILITIES
> (0x8001), access denied and invalid parameter
> cases.
>
> Access is denied if CPUID.0x40000003.EBX BIT(20) is not set.
> Invalid parameter if call has fast bit set.
>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  tools/testing/selftests/kvm/include/x86_64/hyperv.h  | 4 ++++
>  tools/testing/selftests/kvm/x86_64/hyperv_features.c | 9 +++++++++
>  2 files changed, 13 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> index 9218bb5f44bf..8813c1bb74a0 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> @@ -112,6 +112,7 @@
>  #define HV_ACCESS_STATS				BIT(8)
>  #define HV_DEBUGGING				BIT(11)
>  #define HV_CPU_MANAGEMENT			BIT(12)
> +#define HV_ENABLE_EXTENDED_HYPERCALLS		BIT(20)
>  #define HV_ISOLATION				BIT(22)
>  
>  /* HYPERV_CPUID_FEATURES.EDX */
> @@ -166,6 +167,9 @@
>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
>  
> +/* Extended hypercalls */
> +#define HV_EXT_CALL_QUERY_CAPABILITIES		0x8001
> +
>  #define HV_FLUSH_ALL_PROCESSORS			BIT(0)
>  #define HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES	BIT(1)
>  #define HV_FLUSH_NON_GLOBAL_MAPPINGS_ONLY	BIT(2)
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> index 3163c3e8db0a..a5a3146fc299 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> @@ -583,6 +583,15 @@ static void guest_test_hcalls_access(void)
>  			hcall->expect = HV_STATUS_SUCCESS;
>  			break;
>  		case 19:
> +			hcall->control = HV_EXT_CALL_QUERY_CAPABILITIES;
> +			hcall->expect = HV_STATUS_ACCESS_DENIED;
> +			break;
> +		case 20:
> +			feat->ebx |= HV_ENABLE_EXTENDED_HYPERCALLS;

As I've mentioned on another patch, things look significantly better
after https://lore.kernel.org/kvm/20221013095849.705943-6-vkuznets@redhat.com/
cleanup, hope we can have it in soon.

> +			hcall->control = HV_EXT_CALL_QUERY_CAPABILITIES | HV_HYPERCALL_FAST_BIT;
> +			hcall->expect = HV_STATUS_INVALID_PARAMETER;
> +			break;
> +		case 21:
>  			kvm_vm_free(vm);
>  			return;
>  		}

-- 
Vitaly

