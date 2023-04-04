Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4336D5951
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 09:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbjDDHTL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 03:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbjDDHTK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 03:19:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1C3210C
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 00:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680592705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EgJnOdp/ZioLEfs3ME3hFk19aCJYusVB5BBhbxm9Z+Q=;
        b=D9TfVJxHSnKNTyQjOpLJyje5W3xYUHDriRgjNEmMXkAQCv67pHUZ/lwYHwHkBCFtK/AorM
        8QmK5ClcQupyxLvcwGs7DulKGkJgeW92xTWe9FgSLqrWFRfLQqVLo2odQ2BSC59FecL2Qc
        WLj+nXl/UBtTQrZI8PRbfm00IUHgj4w=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-xUO1PAyDMt-EWv7S5p3IWg-1; Tue, 04 Apr 2023 03:18:24 -0400
X-MC-Unique: xUO1PAyDMt-EWv7S5p3IWg-1
Received: by mail-qt1-f197.google.com with SMTP id h6-20020a05622a170600b003e22c6de617so21586245qtk.13
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 00:18:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680592703;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EgJnOdp/ZioLEfs3ME3hFk19aCJYusVB5BBhbxm9Z+Q=;
        b=n3p2a+KtCtR95e5zOczjG8Qjr/CRWS9SmEXZ0aKS9SwZnYsLjQ/5+KVB2UWC3c7OXO
         4zTahBqwmYK0LKDH32Nd48SwTzVTHtycOcDaIecPYI7hmQKHu/2hCV8tZLmxufY9ZX93
         71vAfA3/+sSBfQnwPKBFgzRerQbF9Iw7wHL+hKH34r2tMF8AGfYukVxvSRUVdcQJGwel
         1+jCl0VYn+CD6xikqB5/jcBXDCABYa5y+vGihWASqxX/lo4oAIRH8taROLHELDfxJfT8
         LZYITwshU0aaKm15GMFOFS94jeQ9h1atFi5SkU60nXuZdK2EqrqZK1uG0B8QNnsgJY0V
         yIhg==
X-Gm-Message-State: AAQBX9fYI1MdWBHuzHNtAbXkwSdtQZHmvDI6unOuTCbRWws0iAdw8CJn
        hCj28qBvhRiLloWWLYYWT5ujYU084gIQQ+gTyVEK2Ce3Z0SUc2yVZtebdxJim977ivFJvYXM5c7
        9BLRlSJ/V3iA2/xFnlDujfls=
X-Received: by 2002:a05:622a:1890:b0:3e3:913c:1c9c with SMTP id v16-20020a05622a189000b003e3913c1c9cmr2565558qtc.1.1680592703634;
        Tue, 04 Apr 2023 00:18:23 -0700 (PDT)
X-Google-Smtp-Source: AKy350ax08d6VzguvXyv/lwJjbdIl+nJ0c64Jz/6oChv9QsegzYe3tY0ptJC6OrkeLLUFF2canVQSw==
X-Received: by 2002:a05:622a:1890:b0:3e3:913c:1c9c with SMTP id v16-20020a05622a189000b003e3913c1c9cmr2565540qtc.1.1680592703436;
        Tue, 04 Apr 2023 00:18:23 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-178-74.web.vodafone.de. [109.43.178.74])
        by smtp.gmail.com with ESMTPSA id t2-20020ac865c2000000b003b635a5d56csm3064528qto.30.2023.04.04.00.18.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 00:18:22 -0700 (PDT)
Message-ID: <cf3a5ab8-8e3a-d8ef-c391-6b1644652261@redhat.com>
Date:   Tue, 4 Apr 2023 09:18:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests v3 09/13] powerpc: Expand exception handler
 vector granularity
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>
References: <20230327124520.2707537-1-npiggin@gmail.com>
 <20230327124520.2707537-10-npiggin@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230327124520.2707537-10-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/03/2023 14.45, Nicholas Piggin wrote:
> Exception handlers are currently indexed in units of 0x100, but
> powerpc can have vectors that are aligned to as little as 0x20
> bytes. Increase granularity of the handler functions before
> adding support for thse vectors.

s/thse/those/

  Thomas

