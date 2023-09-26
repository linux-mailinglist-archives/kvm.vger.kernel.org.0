Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D517AEFCE
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 17:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbjIZPiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 11:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235143AbjIZPiA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 11:38:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C7D116
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 08:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695742626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lo9KXR61pKjsEjnho4ZEkIzeJ3p3t6d0hL05s36O2Ac=;
        b=J1h5pciAs58MvzKblGlglEUNYjBQBBOS2Gzkmrp41EYUCdags2oi0MCX5JO88pZE0PE3mt
        yg3jWb17Xb1BCSQjx8xW5CizKFL+pCWvUNgNpNYzOiYjdc6ET1MMzhklD+fU46FsJczS5q
        feAUbsbdt3qGSQBmHgx0CNKynqZVAW0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-OR2r310nP360Z1Wu73LPvw-1; Tue, 26 Sep 2023 11:37:05 -0400
X-MC-Unique: OR2r310nP360Z1Wu73LPvw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4063dd6729bso10643885e9.2
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 08:37:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695742624; x=1696347424;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lo9KXR61pKjsEjnho4ZEkIzeJ3p3t6d0hL05s36O2Ac=;
        b=ZpEi2M0BZz11iGJlP9ZLHv4lJfwVobRK1i0dIC5zrPuYWGPwnvT977A0/pBryjh5jO
         wU7jSxgRK6QZM9J6dS6oPKcg5ehWrMlWTmxprRZztPLEEdP0Bdwrv/PYF0qlaux/Rmih
         CtvsKcB7UZavFeFRKUN7if8hvgtLBOew3J9UGUhSZytwhyiWmRELydkf0a5AYEsih7xd
         UA1gXIlIloFO8kAo3Aax/7SmHnGa4o1uN5tDvpby1e/VPF9g340e8Idqr25uL3CbTP3H
         VSMUXtA8pY4hNzMJxbEvq4nHDDDUI1lm0TmihdttC+Yb/866DeSHmAvJpxGE/AqtWOJh
         qQAA==
X-Gm-Message-State: AOJu0YwSP4ptcN7940NTGvTaZdpVC9zO3PQuUpvrbhLx1NxBbB75J/8p
        npoXYkfciByTAwL/1q63XYoE/NRQCdJUM5FuZb6qb41GQXih041Yy9/qmiSXDfSLEXol59cwc2D
        gfqS4f4AH8IMi
X-Received: by 2002:a7b:c3cb:0:b0:402:bbe3:827c with SMTP id t11-20020a7bc3cb000000b00402bbe3827cmr8343437wmj.31.1695742623984;
        Tue, 26 Sep 2023 08:37:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEgZbfbn1HshEjjUhkYs+QYTkB7XaKqqvp8tpxKDoNmSm/avWomYIcizb7kscqD4prT8Aa2RQ==
X-Received: by 2002:a7b:c3cb:0:b0:402:bbe3:827c with SMTP id t11-20020a7bc3cb000000b00402bbe3827cmr8343417wmj.31.1695742623606;
        Tue, 26 Sep 2023 08:37:03 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id l7-20020a1c7907000000b003fef60005b5sm7838322wme.9.2023.09.26.08.37.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Sep 2023 08:37:02 -0700 (PDT)
Message-ID: <09ed554b-ceff-4ab5-68b4-f0aa0234b4b7@redhat.com>
Date:   Tue, 26 Sep 2023 17:37:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 3/4] target/i386: enumerate VMX nested-exception support
To:     Xin Li <xin3.li@intel.com>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, seanjc@google.com, chao.gao@intel.com,
        hpa@zytor.com, xiaoyao.li@intel.com, weijiang.yang@intel.com
References: <20230901053022.18672-1-xin3.li@intel.com>
 <20230901053022.18672-4-xin3.li@intel.com>
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230901053022.18672-4-xin3.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/1/23 07:30, Xin Li wrote:
> Allow VMX nested-exception support to be exposed in KVM guests, thus
> nested KVM guests can enumerate it.
> 
> Tested-by: Shan Kang <shan.kang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> ---
>   target/i386/cpu.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 3dba6b46d9..ba579e1fb7 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1340,6 +1340,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>           .feat_names = {
>               [54] = "vmx-ins-outs",
>               [55] = "vmx-true-ctls",
> +            [58] = "vmx-nested-exception",
>           },
>           .msr = {
>               .index = MSR_IA32_VMX_BASIC,

Please also add it to scripts/kvm/vmxcap, and rebase on top of the 
recent introduction of MSR_VMX_BASIC_ANY_ERRCODE.

Paolo


