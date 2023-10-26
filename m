Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7D407D7C19
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 07:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbjJZFNy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 01:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233628AbjJZFNw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 01:13:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DC4C0
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 22:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698297185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=BVx1AcfmiusGDmDtqdB8zdIarJ1uI9ASHw/bYgS4xWw=;
        b=WLxtTrmSBPSzJynUtR9d/xTmYPJo6fHtVrrwVTOS6aLcrTQi1L/LkXZUBBgQYCGn8JWSEl
        YkkfOYnZQGpZgeh4Qoc5LkLFF1prAMhKIThWlkcN0Aw7iQJPI4ZC8VdmcWDKGCkQSDqkly
        VEj9MJ73iCt7eSrC8yN2HCVbxiSlmrU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-4WQm63UJNbqTqogPXTLMgw-1; Thu, 26 Oct 2023 01:12:53 -0400
X-MC-Unique: 4WQm63UJNbqTqogPXTLMgw-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9cd789f0284so28909566b.3
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 22:12:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698297172; x=1698901972;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BVx1AcfmiusGDmDtqdB8zdIarJ1uI9ASHw/bYgS4xWw=;
        b=oo3RhywUy4aFlUYPculJWLx8nO7cc7twRjADdfliy1c7OQ20n1p19iBOZRx6QxhZ4g
         0+hUsHvdDeSDeoR0wQSs3k+9beAgGNZU5Z99Fp4EwrXmBiOYnrViy9M+1lfH9IstmDhk
         bnFwMcEy4Cn620ByRE8KXOmGoa+bH4kSD6t1fWf+cvmO/7i2kGzCr7EIitEHRrw7Zq3O
         4Riap412H1f8MKFJ30fzOPxECW5tWJ9Rx6ELvoopBMR657OPJxxYptzTYqLYKHJzIHio
         9dxapcL4v2rBG8IUhmbCM/3M1UZQ+5Ra9PrjfGAfT5/+oo55G6vDKblXxbeORTvsG1u3
         V3PA==
X-Gm-Message-State: AOJu0YyM02ZuSW46FjcAW0O0JzhyHEvOo6RWrZlmPCrtM/TPEXNZOOGL
        /U6L1H88w8VBp9wMusxjKnJH7JfyrmGcpZN+WAurR1RBlOh5YUn/TZKbuQ1yEBSitFuAZXZBlRX
        gk5OUmjxqUsJo
X-Received: by 2002:a17:907:36cc:b0:9ae:5523:3f84 with SMTP id bj12-20020a17090736cc00b009ae55233f84mr12610757ejc.72.1698297172645;
        Wed, 25 Oct 2023 22:12:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG8kGQza57e77dxesG4rYr7dN11M4gYW3mVnVCFnI96yljz31I7VDbuVkUYpKD4fxOtL+CLqA==
X-Received: by 2002:a17:907:36cc:b0:9ae:5523:3f84 with SMTP id bj12-20020a17090736cc00b009ae55233f84mr12610744ejc.72.1698297172318;
        Wed, 25 Oct 2023 22:12:52 -0700 (PDT)
Received: from [192.168.0.6] (ip-109-43-176-238.web.vodafone.de. [109.43.176.238])
        by smtp.gmail.com with ESMTPSA id 10-20020a17090602ca00b009b2f2451381sm11082500ejk.182.2023.10.25.22.12.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Oct 2023 22:12:51 -0700 (PDT)
Message-ID: <e318cd46-b871-448a-b95a-01647d8afc43@redhat.com>
Date:   Thu, 26 Oct 2023 07:12:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v1] configure: arm64: Add support for
 dirty-ring in migration
Content-Language: en-US
To:     Shaoqin Huang <shahuang@redhat.com>, andrew.jones@linux.dev,
        kvmarm@lists.linux.dev
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org
References: <20231026034042.812006-1-shahuang@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20231026034042.812006-1-shahuang@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/10/2023 05.40, Shaoqin Huang wrote:
> Add a new configure option "--dirty-ring-size" to support dirty-ring
> migration on arm64. By default, the dirty-ring is disabled, we can
> enable it by:
> 
>    # ./configure --dirty-ring-size=65536
> 
> This will generate one more entry in config.mak, it will look like:
> 
>    # cat config.mak
>      :
>    ACCEL=kvm,dirty-ring-size=65536
> 
> With this configure option, user can easy enable dirty-ring and specify
> dirty-ring-size to test the dirty-ring in migration.

Do we really need a separate configure switch for this? If it is just about 
setting a value in the ACCEL variable, you can also run the tests like this:

ACCEL=kvm,dirty-ring-size=65536 ./run_tests.sh

  Thomas

