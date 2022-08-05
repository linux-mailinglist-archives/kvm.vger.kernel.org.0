Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C47B58AA48
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 13:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240334AbiHELms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 07:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236411AbiHELmq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 07:42:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB82322BD9
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 04:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659699764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YULnOCGvgRdgsuI4kIdPgoqcS1vxVsdQD9rykb/ZF+A=;
        b=WMaf6u9a4blHsgbOYWxR8N98FzHqgGdCOt5cFQl+++WjihmsFniazitTEO3sbiq5ik/oKX
        lSO3ob995z+25TR+WmL97I+y8fpbNGYBeoVe8S3NhXUssREpuhLupmUiYVsKg0U8Uye2Kt
        mIB+Mhj7jkz0A01/uoTDHMNQiQ4VGWE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-171-CJLsVd0BP_yh5_mMlqM5JQ-1; Fri, 05 Aug 2022 07:42:43 -0400
X-MC-Unique: CJLsVd0BP_yh5_mMlqM5JQ-1
Received: by mail-ed1-f70.google.com with SMTP id b6-20020a056402278600b0043e686058feso1455048ede.10
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 04:42:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=YULnOCGvgRdgsuI4kIdPgoqcS1vxVsdQD9rykb/ZF+A=;
        b=tIIWAP/2/tnsRIDo/cvh6yHyFrfWu2Trt3g+OFFsYzK08vMXGRv/s3wKzm9JtvIN4Y
         LvdXrKUv0KaEWdFlH17WC0DSirHTC2f8jEvtPVuJ+dI+y8Z4nhb2A29rMuvjimR1li/8
         G8FLlFcyoUis/sICa6XDGE5Fh7PszVCvlEp4cPQY9Iwkx3jzKa7vLkTyuQ0+AQETezkI
         bDnX9PGaj4tAkRqLrOOjsbxSf3zT+Pv3+XbMRRvlDN2goM5Bne8DjxZlaK+tP5EzTZTR
         RIlgwncWRHskDSRMj4kvI73ddQp+l8SRk6vm65OXS3NYUyS5KAvulkvCVaRG4q9fkqs3
         kZtg==
X-Gm-Message-State: ACgBeo3JL62IDiQYisxsplzDO8eDH1FgqVPQ15MgPqACch3NfBL9L8uC
        zpcjcBA3xGl9SLliKL+U6quzPx+UUqb6oFKOH2zmKCbZaHUzEe5Di41TTkG/3y/jLqENTwhfTXG
        qNgVtiCHqTzvl
X-Received: by 2002:a17:907:2848:b0:730:cab8:3ce5 with SMTP id el8-20020a170907284800b00730cab83ce5mr5037959ejc.718.1659699761908;
        Fri, 05 Aug 2022 04:42:41 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5HxMkRlLw6inVe2Nj6HJM817DYecrkEFv6oGLkdtosgwkO1ubuip5wVqyzC5bFkkcud/Rczw==
X-Received: by 2002:a17:907:2848:b0:730:cab8:3ce5 with SMTP id el8-20020a170907284800b00730cab83ce5mr5037937ejc.718.1659699761664;
        Fri, 05 Aug 2022 04:42:41 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id f17-20020a056402005100b0043ceb444515sm1979801edu.5.2022.08.05.04.42.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Aug 2022 04:42:41 -0700 (PDT)
Message-ID: <ae0a0049-8db0-501b-79e4-cd32758156fb@redhat.com>
Date:   Fri, 5 Aug 2022 13:42:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [kvm-unit-tests PATCH 2/4] x86: emulator.c cleanup: Use ASM_TRY
 for the UD_VECTOR cases
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
References: <Yum2LpZS9vtCaCBm@google.com> <20220803172508.1215-1-mhal@rbox.co>
 <20220803172508.1215-2-mhal@rbox.co> <Yuq8mumnrww9rlnz@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yuq8mumnrww9rlnz@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/3/22 20:21, Sean Christopherson wrote:
>> I've noticed test_illegal_movbe() does not execute with KVM_FEP.
>> Just making sure: is it intentional?
> It's intentional.  FEP isn't needed because KVM emulates MOVBE on #UD when it's
> not supported by the host, e.g. to allow migrating to an older host.
> 
> 	GP(EmulateOnUD | ModRM, &three_byte_0f_38_f0),
> 	GP(EmulateOnUD | ModRM, &three_byte_0f_38_f1),
> 

*puts historian hat on*

The original reason was to test Linux using MOVBE even on non-Atom 
machines, when MOVBE was only on Atoms. :)

Paolo

