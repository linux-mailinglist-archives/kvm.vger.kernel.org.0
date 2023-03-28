Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8136CBA5C
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 11:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbjC1JVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 05:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjC1JV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 05:21:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C95A195
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 02:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679995240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cmenFZrPmab5EsKw3TDMXYEC3Wdv3EkUt5K0GPSSZs0=;
        b=fz7l7tiKbQlSyglQ8VimGjBmkU9MMDEulhBOabibeOBY1SLdChJl2CAwG8YO31Mb1RM914
        k1VQPKZSXJ7lkUnYfuS/bs86otIR7vUfL5kWRQFSV5yc6F8PpvoBGM7Tl4vtlNsDiJGxpS
        K3+0cCL9Lb/VU9ZdrQ5Y2oB8MRDQYsw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-8hnrj13LMQq6f0Y_Ry1ChA-1; Tue, 28 Mar 2023 05:20:39 -0400
X-MC-Unique: 8hnrj13LMQq6f0Y_Ry1ChA-1
Received: by mail-wm1-f72.google.com with SMTP id n19-20020a05600c3b9300b003ef63ef4519so4558888wms.3
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 02:20:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679995238;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cmenFZrPmab5EsKw3TDMXYEC3Wdv3EkUt5K0GPSSZs0=;
        b=QSCGyPwpR9u8zWQiPqbwFqn4BHnN3sqtwVk3meXuz6hYASqihS7eWxOkqLecRKRvkV
         Vq1QOwKl2BpQFLVGXsnPCdAeGQGRXxt1Cj9eIwJqVrbvAO6gddibVZo1lrlHiuv6BG8t
         +3Zy8MY+L2+yCOizV1KXt3/GmWw0vauE7X8U80154tCkTUVksRst4IIm/MKWKEMEEV5E
         rTj6e3NLUux4+KiQC67rPQPQGMmdzANnnuEMvdHKHgOBRSAFUFgRW6Z8+nw8cwvk1Idj
         TgjtPP43pB59z5h6pLL0PF2nuPHcU91lD5eAXcZjeiUitFvIvAXEEneXsclRSMMRXEAo
         w5mQ==
X-Gm-Message-State: AAQBX9dMv8WS8XERwRxdPnGgyxKUZZsZERmO78iA773esS/LH0Ys+prd
        eJazjQn26f8NcvyTq7EicN+VePLkhsek+lth2z4C5HFtwYU2q/TttsZ9Od2QxFcHgEBb0gmq0nc
        gLSvXyXvKJYIj
X-Received: by 2002:a5d:4b0d:0:b0:2d7:8254:bc14 with SMTP id v13-20020a5d4b0d000000b002d78254bc14mr11626370wrq.47.1679995238003;
        Tue, 28 Mar 2023 02:20:38 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZzbnxZqk7E1yEYPpAjTaJXCiLIyKzmOLraPzZ/v8H+G8UaOf8S3BcIKhbMbICZjtEJDUPb6w==
X-Received: by 2002:a5d:4b0d:0:b0:2d7:8254:bc14 with SMTP id v13-20020a5d4b0d000000b002d78254bc14mr11626354wrq.47.1679995237687;
        Tue, 28 Mar 2023 02:20:37 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id p5-20020a5d4e05000000b002d75909c76esm20275639wrt.73.2023.03.28.02.20.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 02:20:36 -0700 (PDT)
Message-ID: <fce5c1ad-24a3-febf-127e-e97238492143@redhat.com>
Date:   Tue, 28 Mar 2023 11:20:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2] KVM: x86/pmu: Fix emulation on Intel counters' bit
 width
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230322093117.48335-1-likexu@tencent.com>
 <CABgObfYfiUDf4zY=izcg_32yGCbUxxVc+JAkHGHwiQ0VmGdOgA@mail.gmail.com>
 <871434fe-ae80-bec6-9920-a6411f5842c0@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <871434fe-ae80-bec6-9920-a6411f5842c0@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/28/23 11:16, Like Xu wrote:
> 
> 
> If IA32_PERF_CAPABILITIES.FW_WRITE[bit 13] =1, each IA32_PMCi is 
> accompanied by a
> corresponding alias address starting at 4C1H for IA32_A_PMC0.
> 
> The bit width of the performance monitoring counters is specified in 
> CPUID.0AH:EAX[23:16].
> If IA32_A_PMCi is present, the 64-bit input value (EDX:EAX) of WRMSR to 
> IA32_A_PMCi will cause
> IA32_PMCi to be updated by:
> 
>      COUNTERWIDTH =
>          CPUID.0AH:EAX[23:16] bit width of the performance monitoring 
> counter
>      IA32_PMCi[COUNTERWIDTH-1:32] := EDX[COUNTERWIDTH-33:0]);
>      IA32_PMCi[31:0] := EAX[31:0];
>      EDX[63:COUNTERWIDTH] are reserved
> 
> ---
> 
> Some might argue that this is all talking about GP counters, not
> fixed counters. In fact, the full-width write hw behaviour is
> presumed to do the same thing for all counters.
But the above behavior, and the #GP, is only true for IA32_A_PMCi (the 
full-witdh MSR).  Did I understand correctly that the behavior for fixed 
counters is changed without introducing an alias MSR?

Paolo

