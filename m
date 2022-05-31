Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B732538C6E
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 10:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244604AbiEaIDG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 04:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235885AbiEaIDE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 04:03:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AA91091542
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 01:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653984182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yyZQADKZC4ReRzpE60kxchJgWQOZMoqrjCrM2arpsng=;
        b=Es1tYI22HwwRtMhEMoJq/3ruI5VtLJq7PJRo+6LE0sxQFKXOl9NPThrzX8cxLSrCS7iufU
        bhASeRZgCWdAExUFqopIvVh7LMA7vyDy5YSrcwpnOsd5bgFvUINEg9ZGtHCihYTJ2WstNq
        CaOWax0ilrXL1O+pNHSUXciU8Tqkqxw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-Aru-xEm6NoWQUO0khl4p_Q-1; Tue, 31 May 2022 04:03:01 -0400
X-MC-Unique: Aru-xEm6NoWQUO0khl4p_Q-1
Received: by mail-wr1-f70.google.com with SMTP id e7-20020adfa747000000b0020fe61b0c62so1858225wrd.22
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 01:03:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=yyZQADKZC4ReRzpE60kxchJgWQOZMoqrjCrM2arpsng=;
        b=OTsVbqqKUgMX51X9OsaJJGXTLvCuqIhUBYAyzhaP/iAtqXlF6v/Sxro3S9JQ5k3xI3
         mOHzd4cBnND8v0hb6xwqq0h9ioWGcX7j1d/0rlyuxCY3q1icD1IO7kYj87Ia+E3RqLYl
         gkZZr+A9BrcdAuBE1oiq3FvdHBIhDWNDYLxatCsDbeEFsHXmxfONl/hHxz42Wfs8BZXM
         LRRvg/EUSJGl35V3KP4BEcgvUviYIJUSlEQF8jqIkHjo5PHOEqZaKzq7WSBFhgXqp6I0
         R3arZdONM6nXpz+CjmxcTpqxB0r0Fe8tpB2LTqpdplpJkp0FS3GH1FrGiv4FkMW0bUQb
         dN5g==
X-Gm-Message-State: AOAM5338v03n1WGO5siO46LUyf42+Mkps2VD8kOcYTDR5qFgA3yHSG9+
        NEXfGzFO40Vz35Ye0kHToH/qwzTJ737D305gzmqIcp0D0eNwxxc3+3hphqx7NblMsKN9KN8fu74
        NsohP2Ce7NupKDPdSZ7qjacGLnrQMbYToQs/tSxGMzcwVvcxj3HHEsMB31rPf
X-Received: by 2002:a7b:ca59:0:b0:397:8c63:4bd2 with SMTP id m25-20020a7bca59000000b003978c634bd2mr18044084wml.76.1653984180282;
        Tue, 31 May 2022 01:03:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvK+kVHptLw/I1R4X+Hc3Su3WAjoCzlHqw32wWdDS/iEXLwXclgerYkX9VR5zibNnxhwKRgg==
X-Received: by 2002:a7b:ca59:0:b0:397:8c63:4bd2 with SMTP id m25-20020a7bca59000000b003978c634bd2mr18044015wml.76.1653984179461;
        Tue, 31 May 2022 01:02:59 -0700 (PDT)
Received: from [192.168.0.2] (ip-109-43-177-214.web.vodafone.de. [109.43.177.214])
        by smtp.gmail.com with ESMTPSA id j14-20020a05600c190e00b00397381a7ae8sm1525224wmq.30.2022.05.31.01.02.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 01:02:58 -0700 (PDT)
Message-ID: <e39149e0-e6c4-f850-cd0f-cbdb453ee0c2@redhat.com>
Date:   Tue, 31 May 2022 10:02:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v3 0/4] KVM: s390: selftests: Provide TAP output in tests
Content-Language: en-US
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        linux-s390@vger.kernel.org
References: <20220429063724.480919-1-thuth@redhat.com>
In-Reply-To: <20220429063724.480919-1-thuth@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/2022 08.37, Thomas Huth wrote:
> This patch series is motivated by Shuah's suggestion here:
> 
>   https://lore.kernel.org/kvm/d576d8f7-980f-3bc6-87ad-5a6ae45609b8@linuxfoundation.org/
> 
> Many s390x KVM selftests do not output any information about which
> tests have been run, so it's hard to say whether a test binary
> contains a certain sub-test or not. To improve this situation let's
> add some TAP output via the kselftest.h interface to these tests,
> so that it easier to understand what has been executed or not.
> 
> v3:
>   - Added comments / fixed cosmetics according to Janosch's and
>     Janis' reviews of the v2 series
>   - Added Reviewed-by tags from the v2 series
> 
> v2:
>   - Reworked the extension checking in the first patch
>   - Make sure to always print the TAP 13 header in the second patch
>   - Reworked the SKIP printing in the third patch
> 
> Thomas Huth (4):
>    KVM: s390: selftests: Use TAP interface in the memop test
>    KVM: s390: selftests: Use TAP interface in the sync_regs test
>    KVM: s390: selftests: Use TAP interface in the tprot test
>    KVM: s390: selftests: Use TAP interface in the reset test
> 
>   tools/testing/selftests/kvm/s390x/memop.c     | 90 +++++++++++++++----
>   tools/testing/selftests/kvm/s390x/resets.c    | 38 ++++++--
>   .../selftests/kvm/s390x/sync_regs_test.c      | 87 +++++++++++++-----
>   tools/testing/selftests/kvm/s390x/tprot.c     | 29 ++++--
>   4 files changed, 193 insertions(+), 51 deletions(-)

Ping!

  Thomas


