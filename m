Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F57C4D1FF1
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 19:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349481AbiCHSTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 13:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349466AbiCHSTj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 13:19:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F1B7B39156
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 10:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646763522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SS6f7dRwxzKIXX1gLdfWCfBLoUQykjMr5LR57Ii/WgE=;
        b=hGcOw1cfvZ3AHtfUmxyiuCJSMi2V4/7vMt0Ev/2lFK8zrwneOhaV6uiolF2iLJuns7+EuX
        Lzpz3OIZtmB51gi6Mxz1Shqxp7TcUVIBWDeOtQX/wBHUJ+24LSZj7r3kxVMKF0UOqvNRrk
        wbMcQ5iIR3LlhgEMBwjwcp/rLILbe6U=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-224-oW59LBQNNPy2sVgIyfSm3g-1; Tue, 08 Mar 2022 13:18:40 -0500
X-MC-Unique: oW59LBQNNPy2sVgIyfSm3g-1
Received: by mail-ej1-f69.google.com with SMTP id le4-20020a170907170400b006dab546bc40so5855916ejc.15
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 10:18:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SS6f7dRwxzKIXX1gLdfWCfBLoUQykjMr5LR57Ii/WgE=;
        b=ec/QTexItVKa5Pc7+c1cZQM23Pn/ff0uLvGZ4PHjCn/MX8E3MP3KCIciXZw/6uIW7S
         AiaypXFztpxix4p73CzVj8d3HngSuYtsb1KhwXXNFPTbopcBeRqGrkzKPjq0l9PH9cEB
         ZGNB0pa2Lc1WxI6BitGlEkI1xZAVCYf61xtD/3KogDY+8epICiosNdAzAgtv8UR4QN/b
         deUSwwb8qttnxNiuIpbRF9DvVNhaHWtlRCJzzbmJFdxu5UoHi28l7Ew5dM/g73WejVrg
         jlEOh1WOkPLKIrsbZFRRPuWKvfL7fMuVow9vb85jN7w67lzkbFzzTFiTGtPd354VzQnt
         uIvQ==
X-Gm-Message-State: AOAM533IKdU0d1VFmHWLwTEY43n69BcwnW6j3Y9G1+GwtaUb6bwj71mn
        NETZkqrhFr70wzA3slUGfE0bnM+Lxdh+urTNtf7aXG4Q1T2cZMXyFZ0wxCfiRjwOL16mgMXtqbe
        /9CY0uGYfpacs
X-Received: by 2002:a17:907:1c0a:b0:6da:7ac4:5349 with SMTP id nc10-20020a1709071c0a00b006da7ac45349mr14620589ejc.596.1646763519560;
        Tue, 08 Mar 2022 10:18:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy9UKSdlIjJiXmn1spywhUg4vxQcqmWsv7ZWbx3Y7a36yveI+/CikgqEVMnFw0WXKZw0Rc7ZQ==
X-Received: by 2002:a17:907:1c0a:b0:6da:7ac4:5349 with SMTP id nc10-20020a1709071c0a00b006da7ac45349mr14620563ejc.596.1646763519291;
        Tue, 08 Mar 2022 10:18:39 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id hb19-20020a170906b89300b006daa95d178esm5501118ejb.60.2022.03.08.10.18.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 10:18:38 -0800 (PST)
Message-ID: <17bc86ec-b470-e6ce-d467-fdc3b11c9c16@redhat.com>
Date:   Tue, 8 Mar 2022 19:18:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 11/25] KVM: x86/mmu: remove
 kvm_calc_shadow_root_page_role_common
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-12-pbonzini@redhat.com> <YieW+PZarPdsSnO7@google.com>
 <f9e7903a-72b6-5bd7-4795-6c568b98f09d@redhat.com>
 <Yiedukl6MC8OAAog@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yiedukl6MC8OAAog@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/8/22 19:17, Sean Christopherson wrote:
>>> +	role.base.direct = !____is_cr0_pg(regs);
> 
> On a serious note, can we add a WARN_ON_ONCE(role.base.direct)?  Not so much that
> the WARN will be helpful, but to document the subtle dependency?  If the relevant
> code goes away in the end, ignore this requrest.

Ok, that can be done.  Either that or !is_cr0_pg().

Paolo

