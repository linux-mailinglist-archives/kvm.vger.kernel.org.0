Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C326340B7
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234024AbiKVQBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233983AbiKVQBP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:01:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FC86546
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669132814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UH2NKASbFNrFdasvahoGiAeoT+d8FFw4FDleUBrke7c=;
        b=dyBGXbiIoLsapNBbBoa5hAfcWKHd0r0jTM/kr3/hUoYThKyiy5ltGWiDJagCMStlbJweff
        NVqGDiGxzDWBXmM1/PVSjo4akfFd0gTeq6mfMcPz/N1GsReKcnenaRTsnDMUfKNeKmpYcr
        VfD5mzAZ5CP9d0O3eYrglmRFubtDf94=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-61-KO9uCfm3O3ee3oz7C1meDA-1; Tue, 22 Nov 2022 11:00:12 -0500
X-MC-Unique: KO9uCfm3O3ee3oz7C1meDA-1
Received: by mail-ed1-f72.google.com with SMTP id w4-20020a05640234c400b004631f8923baso9077231edc.5
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:00:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UH2NKASbFNrFdasvahoGiAeoT+d8FFw4FDleUBrke7c=;
        b=c3/jEJkz3HMFehfsRFBD8le+m1OyBwYfndAWQ5hZhftfpo+ozB52qSgQmqIFSpXBDA
         loNOjFGIJyDQ+27kpU6Us4u+a08oO03jML7RSldgB9gmovs3Q9/nxNV7xRUVEN4/PUoz
         4J6BRkhtH/UhBZmV7m/2DD5EiuUeKahgulfj5JvAZA6v9P096Oa9Et0Y5ZoX46oyqqVw
         SJKZpQ3bzYu/yZmTaYcRSgMlmJULRd0IXi4154AKqAiOgKYW8I1VTN1TZwtq0QkuMpRO
         Bvnmej2nESeQGKo9kwtrQTgxn28fXXjGbCt6dSJ+5aHIQNY59FYPyk+uR59XAeqjM6Uu
         QUHQ==
X-Gm-Message-State: ANoB5pk0q8D8V5065Ip4PRqoMwJ+frEsPn+5Fuz+/ptpbnbmLFZCDhGL
        e/ByRZXh1xeTncrJry7B3QWT+ai+Pu8a0F8Gx21o+NElC8rzq4bWMYuQW0uRyzSPnpkjw1dsGsD
        KfhViT6cuNo2Q
X-Received: by 2002:a05:6402:5011:b0:469:9c84:3bdd with SMTP id p17-20020a056402501100b004699c843bddmr9158210eda.302.1669132811289;
        Tue, 22 Nov 2022 08:00:11 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6IMRfjjWtDhhBIWcX2jWUelv73XRu4/xzCW+gQPl4m2UG8bjSYPEa1GIZh3z8eFBgWtUqRJw==
X-Received: by 2002:a05:6402:5011:b0:469:9c84:3bdd with SMTP id p17-20020a056402501100b004699c843bddmr9158186eda.302.1669132811001;
        Tue, 22 Nov 2022 08:00:11 -0800 (PST)
Received: from ovpn-194-185.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p22-20020a17090653d600b0078c213ad441sm6201926ejo.101.2022.11.22.08.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 08:00:10 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Subject: Re: [PATCH v2 4/6] KVM: selftests: Replace hardcoded Linux OS id
 with HYPERV_LINUX_OS_ID
In-Reply-To: <20221121234026.3037083-5-vipinsh@google.com>
References: <20221121234026.3037083-1-vipinsh@google.com>
 <20221121234026.3037083-5-vipinsh@google.com>
Date:   Tue, 22 Nov 2022 17:00:09 +0100
Message-ID: <87k03nou7q.fsf@ovpn-194-185.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vipin Sharma <vipinsh@google.com> writes:

> Use HYPERV_LINUX_OS_ID macro instead of hardcoded 0x8100 << 48
>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  tools/testing/selftests/kvm/x86_64/hyperv_clock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
> index d576bc8ce823..2ee0af0d449e 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
> @@ -104,7 +104,7 @@ static void guest_main(struct ms_hyperv_tsc_page *tsc_page, vm_paddr_t tsc_page_
>  
>  	/* Set Guest OS id to enable Hyper-V emulation */
>  	GUEST_SYNC(1);
> -	wrmsr(HV_X64_MSR_GUEST_OS_ID, (u64)0x8100 << 48);
> +	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
>  	GUEST_SYNC(2);
>  
>  	check_tsc_msr_rdtsc();

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

