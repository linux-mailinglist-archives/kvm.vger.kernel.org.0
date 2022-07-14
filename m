Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B7C57463B
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 09:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237208AbiGNH40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 03:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235310AbiGNH4Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 03:56:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8D98DBDE
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 00:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657785381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SE9eAN5X+ShMxtdmF41zDz1yLtEpxxR36zmsks8hPS0=;
        b=cXGfdvXzsY3YJ1qv6UoZHxJ4cEUrr8xWfdykgUAeD32dZqkbPD7qCU8PvAUI7FP2xGi7O6
        EdXW47cdF9CuMrBEo1CTn3u+ZN6hFnHTXkTiSzqdETPcGIs7qOhg/ZfKP5i07SgEismp1w
        +bSfCfzhxneowe1s85dPsA62Ba+vh6k=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-pHryeRSaPzyNGH5FZtr7Mg-1; Thu, 14 Jul 2022 03:55:54 -0400
X-MC-Unique: pHryeRSaPzyNGH5FZtr7Mg-1
Received: by mail-ed1-f71.google.com with SMTP id w13-20020a05640234cd00b0043a991fb3f3so1008116edc.3
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 00:55:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SE9eAN5X+ShMxtdmF41zDz1yLtEpxxR36zmsks8hPS0=;
        b=QiVtBKRgUZBU7aE0CE6DVSoYEfXQq/z17cnKn++FE+4TItxWiLW6Dl8ehJgStMlDoV
         HP/DvE1TpbPmyDF0VVT3HZNATj0OlstS0FrrSuYgeNN94n5Mb5l2zOc0Y/qGaPhn84c1
         N0velQHj4N/QVqI2/twSxF5hId6aYyXbnbVNV8rRiuvzVHWyjKlSwLR2mlhGiYeVn0KC
         Q/ZX0eeDXqdsHR7rWPS1VaPsnXvcAKOTFpe+syOdZ6xuksYCgz7T4yG4/dP7NvNivWyB
         YqQ77QAUUHmOwgj5qjfRf8XJbRzy+/dTtVPz8yeNzKVxF8Ki0Mzn7z2xL5My4RH5tQJc
         0y2A==
X-Gm-Message-State: AJIora9bj1I9OYND4iLmbwwOBgZlqGxjpEoMxjajKvi1XjgkIFPFxgbf
        tyX3ZC9IJ2P4F/vOSJSvFAJvJQ1Wo+XOZNnl5NzUAwF0UL6rHctqNLxwBEQxl2AHr4Y/gMVQ3Ja
        rYGd+BuYSSApR
X-Received: by 2002:a05:6402:34c1:b0:43a:bd7a:898a with SMTP id w1-20020a05640234c100b0043abd7a898amr10764876edc.426.1657785344688;
        Thu, 14 Jul 2022 00:55:44 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1um/IMU8CKiTuPcepZAnSTRYoRBRZ2ZH0kI9/eLTdxlSioknmf1mGAkVR3V+y/TA4I2nzD2xg==
X-Received: by 2002:a05:6402:34c1:b0:43a:bd7a:898a with SMTP id w1-20020a05640234c100b0043abd7a898amr10764856edc.426.1657785344487;
        Thu, 14 Jul 2022 00:55:44 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id kv10-20020a17090778ca00b0072eddc468absm385354ejc.134.2022.07.14.00.55.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 00:55:43 -0700 (PDT)
Message-ID: <52ef13d4-068d-bd2c-11aa-c7053798aee9@redhat.com>
Date:   Thu, 14 Jul 2022 09:55:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 0/9] KVM: x86/MMU: Optimize disabling dirty logging
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
References: <20220321224358.1305530-1-bgardon@google.com>
 <dba0ecc8-90ae-975f-7a27-3049d6951ba0@redhat.com>
 <YszQcBy1RwGmkkht@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YszQcBy1RwGmkkht@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/12/22 03:37, Sean Christopherson wrote:
> This fell through the cracks.  Ben is on a long vacation, I'll find my copy of
> the Necronomicon and do a bit of resurrection, and address the feedback from v2
> along the way.

This was superseded by the simple patch to zap only the leaves I think?

Paolo

