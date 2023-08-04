Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40ADB770747
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 19:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjHDRkN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 13:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjHDRkM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 13:40:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7AB49F2
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 10:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691170762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6weKQD+ozqNv4G1UIrG5/+1TB5PpQPCo1dFnfE0/XVA=;
        b=P2xgtiJVhUiJAG5ZhKfuwkNVlEl7hj5aZTWIERghhkpvBeJ0j2Unt92zpV+HoO913ts0WG
        i6pGDslegnMMUKdFaB8GN1SVEm8kkFM0SEgvmqtrpVfePiISD0vVcR0rMimh5vXVin6Xm8
        lPxilSO0o/VLO6D0QxCDYycw799pMUg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-bW2rIFBuP2SEvspvNYG_-g-1; Fri, 04 Aug 2023 13:39:21 -0400
X-MC-Unique: bW2rIFBuP2SEvspvNYG_-g-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-523204878d9so393891a12.0
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 10:39:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691170760; x=1691775560;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6weKQD+ozqNv4G1UIrG5/+1TB5PpQPCo1dFnfE0/XVA=;
        b=FgXIT4MkFYbwXVY7LPEj0U7oPZEOa44WtV48bK4l9VBU6fmZrjgM0gBxu4mDWkMpt8
         Rc/mrZRbhAK7aEGeR5zLlW6RIJKUpAVKPQDGq14Nj8PIaGN98bZ0zfxp5vGbNjm0kFOF
         tgYGZlKSEuz3CVhSfLi7//4vgIMh1jIZfCuF8GEVQeakCn+eyTjfW3Wm3UxIW+xcQiLS
         vrcJHSKGDCNmrWQkZa5kBgbzZWFirG7GBIlXxwRYwdat9ocss52Xef4rIhZmLsNdX6uu
         F4+B2slB7sTS0ZBNGtm54r64UCwrBj3EONYD3R5Tyi7ieSJUJDuA8O6GiyscYlwHE2hY
         fhKg==
X-Gm-Message-State: AOJu0Yyd4DKZMjan5rP2GqsN2DAePyYhrIsEq+1abO3k8SddSJ+LHZwg
        3MmuWuBTJruNbn5uKsOl+sVmFS84CStPIzUDyqHtISCcsEoET1RmdrRjnRCXJOdyCNc4r6znPvu
        pNJrj3gyhRmcI
X-Received: by 2002:aa7:dc0a:0:b0:522:79e8:e51b with SMTP id b10-20020aa7dc0a000000b0052279e8e51bmr2125748edu.32.1691170760213;
        Fri, 04 Aug 2023 10:39:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFaZEd7/x6GR64ZWOyj478PsDoZMJscVQ1zgnGO6VSfQ5aurf8cwVNnAso80Blhq7blvq+CHg==
X-Received: by 2002:aa7:dc0a:0:b0:522:79e8:e51b with SMTP id b10-20020aa7dc0a000000b0052279e8e51bmr2125736edu.32.1691170759962;
        Fri, 04 Aug 2023 10:39:19 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id i22-20020a50fc16000000b0051d9de03516sm1516807edr.52.2023.08.04.10.39.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Aug 2023 10:39:19 -0700 (PDT)
Message-ID: <4d97b4bf-26a4-1222-a1e4-04c3f33a8170@redhat.com>
Date:   Fri, 4 Aug 2023 19:39:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.5, part #2
Content-Language: en-US
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, rananta@google.com, tabba@google.com,
        arnd@arndb.de, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <ZMi/EkSLgRymQZzN@thinky-boi>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ZMi/EkSLgRymQZzN@thinky-boi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/1/23 10:15, Oliver Upton wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.5-2

Pulled (but not pushed yet), thanks.

Paolo

