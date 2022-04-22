Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBA750B443
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 11:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446145AbiDVJoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 05:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356118AbiDVJod (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 05:44:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A856644A2D
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 02:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650620499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=htBc+tkv2t0KCV7NxZPr1OZ70wCiPUIfu1Kk+i4HfxA=;
        b=fMJL1lNI/C3bZ+8ObPJoJ9isV5/17AB2tkIUZ6yJTP/syiE6BZlRrZKRzSegpdYdS7X55K
        XpgqDPy9Gw41JarhiJnK+QX81R5uzwctbZMFF7+czoI9OcR1yrbfQTQ9H8qhzz3tV32phT
        ZNludOnsRQtBOR6rLGOO6yh5YaAl/t0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-RZq7xuovOb2yrUKXq6PNnw-1; Fri, 22 Apr 2022 05:41:38 -0400
X-MC-Unique: RZq7xuovOb2yrUKXq6PNnw-1
Received: by mail-ej1-f70.google.com with SMTP id i14-20020a17090639ce00b006dabe6a112fso3824708eje.13
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 02:41:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=htBc+tkv2t0KCV7NxZPr1OZ70wCiPUIfu1Kk+i4HfxA=;
        b=NlC385LXMOWap00FuwaJ5fGRZFih1dFDjf37HibBBbhp66WzTrpwBO0OquDF3Y6GFl
         NSV1fnQ4IvR4KFUWyANkVzHPXZI4Qn77egeEeBo7FEDvGfFxuOUCjuSxgz+8+V3L0NkD
         wBz4QQiIyDV5zNRYrQnGbbbjnEHXaqzm4bZddxWNjzhPD9u7cyag1GhQFxOOeNxz8SiL
         G1p0m0AofQ1WBL1EWS5sh3BKoQWty9ZBdh2Vi1nDfiPqVtAi6K6wWYHrEXIyzpp/jwlO
         bffEH2FyRVwmjmm4GB5XCoIFwyovVzzEp2+eJQLqYZqU1n7X8BWr+Hct7uINIk0AShpw
         s1VA==
X-Gm-Message-State: AOAM531kOBuLPl2t9G4vyqsUKslI8i7i7Uj8dLqhSwutrUUUAMX1JTi8
        X8nOjdDB9OhNp2ONYvcIHV+d94y3yD2Oz/VKKvyPNHZoCxlAJL0MkQrZck/qShaMonqGs/7Dl7O
        k8OrXCEjkRCNw
X-Received: by 2002:a05:6402:330a:b0:41d:9477:4ee4 with SMTP id e10-20020a056402330a00b0041d94774ee4mr3858048eda.41.1650620497311;
        Fri, 22 Apr 2022 02:41:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy3+W8XeooBv/xYG8vXSPaTlAAiTLR9U3UtE31iprIJBj9s/wuC7xpO4ci6HkA1+ALchq0hCw==
X-Received: by 2002:a05:6402:330a:b0:41d:9477:4ee4 with SMTP id e10-20020a056402330a00b0041d94774ee4mr3858034eda.41.1650620497057;
        Fri, 22 Apr 2022 02:41:37 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id y14-20020a056402440e00b00416046b623csm727084eda.2.2022.04.22.02.41.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Apr 2022 02:41:36 -0700 (PDT)
Message-ID: <ef5c6c5b-2ed1-7d4c-e757-ed8bcead5d18@redhat.com>
Date:   Fri, 22 Apr 2022 11:41:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 0/4] KVM: fix KVM_EXIT_SYSTEM_EVENT mess
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, will@kernel.org,
        maz@kernel.org, apatel@ventanamicro.com, atishp@rivosinc.com,
        seanjc@google.com, pgonda@google.com
References: <20220421180443.1465634-1-pbonzini@redhat.com>
 <YmJgIQe+5zGbrxoF@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YmJgIQe+5zGbrxoF@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/22/22 09:58, Oliver Upton wrote:
> Is there any way we could clean this up in 5.18 and leave the whole
> ndata/data pattern for 5.19?
> 
> IOW, for 5.18 go back and fix the padding:
> 
> 	struct {
> 		__u32 type;
> 		__u32 pad;
> 		__u64 flags;
> 	} system_event;
> 
> Then for 5.19 circle back on the data business, except use a flag bit
> for it:
> 
> 	struct {
> 		__u32 type;
> 		__u32 pad;
> 	#define KVM_SYSTEM_EVENT_NDATA_VALID	(1u << 63)
> 		__u64 flags;
> 		__u64 ndata;
> 		__u64 data[16];
> 	} system_event;
> 
> Where we apply that bit to system_event::flags this time instead of
> ::type. Could also go the CAP route.

These patches are against kvm/next, so that is already what I did. :)

On the other hand right now the ARM and RISC-V flags are unusable with 
32-bit userspace, so we need to fix _something_ in 5.18 as well.  For 
your proposal, all that's missing is a 5.18 patch to add the padding. 
But since the flags UAPI was completely unused before 5.18 and there's 
no reason to inflict the different naming of fields to userspace.  So I 
think we want to apply this UAPI change in 5.18 too.

Paolo

