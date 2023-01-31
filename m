Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97329682F8F
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 15:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbjAaOoT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 09:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbjAaOoK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 09:44:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD82125BC
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 06:43:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675176202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LAtdCvaYcBjQla+NfgEkiJO+riIsmgiBoPP1Uy0xazs=;
        b=PNppBzgKtEeV2bhcg9WjBqwpVSrH/RzBd6kgDPtP3Vv9nj09rlao0mj2YyMXNIMwPLgCXs
        1yegoP2J2dPfNRtHxolSkuUh6cpsPnRMGDA5+aNXBsieMLypzsSNY6x2hX2MYVVQlvnshC
        U+f8DwNOMlsAxeljGaxwVBNGDm6Rov0=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-494-l6otsC8kOQ6G5lPsWmM9fA-1; Tue, 31 Jan 2023 09:43:20 -0500
X-MC-Unique: l6otsC8kOQ6G5lPsWmM9fA-1
Received: by mail-qk1-f199.google.com with SMTP id j11-20020a05620a410b00b007066f45a99aso9213717qko.1
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 06:43:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LAtdCvaYcBjQla+NfgEkiJO+riIsmgiBoPP1Uy0xazs=;
        b=t+o8vCh4QRN4nyjWaxftHT71ChCcQ+LjDYnuq6ZasDUsygfs4+ICxFyRoDirB2epgp
         5VJw1QmrjsErGXO887Q4bjMAN/G0LxK19tBiFb/MyRmjnto03YlQnnzDmEwzGBdFao+s
         pnWdgpxm6t410WdDX5bBaLOawdb1ztmdZzZoGNagteVAJnKgCgTdp+FGefYJZ3aNmnqh
         7QfkCWfFx4xIfxoejWZ0UeNweLje7EET5r3fipLyujWe2/KNr8GzG4BzfQX7pZtQEIX8
         5tL3vo0vXG+JrqyIxuBey3h7ZCs7D1EhEXVUrg0yI+ECqDT5eAYw7u82/HjXJuF+uBl+
         neiw==
X-Gm-Message-State: AFqh2kooyLUxwEAhVqpCNiZDNlpZFc5sd8KxOhuXPF6sL9NDeKDHRZ/2
        rM6hkbDD3c+BSJj6iQN48hgU0nF0K4q1/aEFtAtu5uo067o2ALOgwEICVyvM6AhVO5xhlJaADBa
        xd8jnnXlsR0OZ
X-Received: by 2002:ac8:7ec4:0:b0:3b6:3c9c:59f0 with SMTP id x4-20020ac87ec4000000b003b63c9c59f0mr75200617qtj.15.1675176199683;
        Tue, 31 Jan 2023 06:43:19 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuXH7IzWL307K632kUG5faoKR8tSdHwFt5EW1IhyhwYmM3PlJhpLhToOa2tJxLyWOWsmCmU4Q==
X-Received: by 2002:ac8:7ec4:0:b0:3b6:3c9c:59f0 with SMTP id x4-20020ac87ec4000000b003b63c9c59f0mr75200586qtj.15.1675176199464;
        Tue, 31 Jan 2023 06:43:19 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-176-155.web.vodafone.de. [109.43.176.155])
        by smtp.gmail.com with ESMTPSA id z20-20020ac84314000000b003b960aad697sm2448545qtm.9.2023.01.31.06.43.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 06:43:18 -0800 (PST)
Message-ID: <16e95056-919a-47dc-3ed7-50c29d39b6ae@redhat.com>
Date:   Tue, 31 Jan 2023 15:43:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [RFC kvm-unit-tests 01/27] lib/string: include stddef.h for
 size_t
Content-Language: en-US
To:     Joey Gouly <joey.gouly@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Steven Price <steven.price@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, linux-coco@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
 <20230127114108.10025-2-joey.gouly@arm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230127114108.10025-2-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/01/2023 12.40, Joey Gouly wrote:
> Don't implicitly rely on this header being included.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>   lib/string.h | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/lib/string.h b/lib/string.h
> index b07763ea..758dca8a 100644
> --- a/lib/string.h
> +++ b/lib/string.h
> @@ -7,6 +7,8 @@
>   #ifndef _STRING_H_
>   #define _STRING_H_
>   
> +#include <stddef.h>  /* For size_t */
> +
>   extern size_t strlen(const char *buf);
>   extern size_t strnlen(const char *buf, size_t maxlen);
>   extern char *strcat(char *dest, const char *src);

Reviewed-by: Thomas Huth <thuth@redhat.com>

