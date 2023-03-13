Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15BE56B7B58
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 16:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbjCMPAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 11:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjCMPAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 11:00:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4FF74A54
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 07:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678719482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FHE3OOJsuZE+xWnYqdvV/G93Sb6IxlKdBHzMbjKAbh0=;
        b=F/CKaci7SbYhkrG4xyqDzld7IzN7J6uc9EDKaJWxxJe+e1Ui7aTKYqxcJt5Tti7MRRS0Ky
        qmf5hV5zCjPs2qtKuwoaWlTRN8IQUjeBFp4xTIBc3L9YIMJPk0VF+8bIdGzer1osz+e9tv
        cUgsxykb/YrdrPt1W5tFtu6rHHDxaZo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-326-Sm96N3PDNtepBxwoUefxCw-1; Mon, 13 Mar 2023 10:56:16 -0400
X-MC-Unique: Sm96N3PDNtepBxwoUefxCw-1
Received: by mail-wr1-f72.google.com with SMTP id c30-20020adfa31e000000b002c59b266371so2173208wrb.6
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 07:56:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678719361;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FHE3OOJsuZE+xWnYqdvV/G93Sb6IxlKdBHzMbjKAbh0=;
        b=xinI8QKf1coz4aHfLVOCCLuDbLHWHVf+sjduCLMCWz7bbbhJgM1UvNAkOcASpwuSRJ
         QRZZ+v1rrykdKYZDyGxDeIsGm5WHc2xq3DotEpt+JRQmhO8aZDxtkOhtGd18CT/go6zc
         pmPwBXGAnJizvKiVwhmb7FbDMTz/baiz59b+kBZzzPY5Zx8KlxZr/EP0WuDX9tMwhEpk
         cf6zNvYGL6wF9vUmsLr1C/EjoMKhmnwPiHTMT1Nn8rZNxo3VoSk3GYRtKjgSnqZ3omeZ
         4+TArWYjqVQHYkzC/WITfQm6qAhtO+zlNLjJlEh1HHGYDi+5k1hvyUf20rrDRydtqDqF
         dxgA==
X-Gm-Message-State: AO0yUKX2iNe+3TAwovBMpOkRmWA3kuVxvlHqpJ4/xju6pvtjun9A59lE
        ltrRQpua7dcjxhGJtZtb/tYoHNO7Z00TNpG82r/xJ6+wHP5KsjI3ko1PaWvnhwlonHK/8wUhYCo
        FxN5q5RRHTYEnDtiEm1h3iA0=
X-Received: by 2002:adf:d0cb:0:b0:2ce:a8f0:5e1f with SMTP id z11-20020adfd0cb000000b002cea8f05e1fmr3894675wrh.71.1678719361027;
        Mon, 13 Mar 2023 07:56:01 -0700 (PDT)
X-Google-Smtp-Source: AK7set9kStWht/z9BJluI0KCsafCM61vGqXAJpPApSQAOKQWDlv3On5a6xFjOEsCx/pXXKyhOA9FaA==
X-Received: by 2002:adf:d0cb:0:b0:2ce:a8f0:5e1f with SMTP id z11-20020adfd0cb000000b002cea8f05e1fmr3894665wrh.71.1678719360744;
        Mon, 13 Mar 2023 07:56:00 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id l8-20020a5d5608000000b002c552c6c8c2sm8135786wrv.87.2023.03.13.07.55.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 07:56:00 -0700 (PDT)
Message-ID: <18b8e0b5-4622-e559-ab0c-81a778c6e2ce@redhat.com>
Date:   Mon, 13 Mar 2023 15:55:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [kvm-unit-tests PATCH 0/2] x86: Fixes for rdpid test
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org
References: <20230307005547.607353-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230307005547.607353-1-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/7/23 01:55, David Matlack wrote:
> Fix 2 small issues with the rdpid test that is a part of x86/tsc.c.
> Notably, the test is not currently running since qemu is not configured
> to advertise RDPID support and fixing that uncovers a bug in the test
> when compiling with Clang.
> 
> David Matlack (2):
>    x86: Run the tsc test with -cpu max
>    x86: Mark RDPID asm volatile to avoid dropping instructions
> 
>   x86/tsc.c         | 2 +-
>   x86/unittests.cfg | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> 
> base-commit: e3c5c3ef2524c58023073c0fadde2e8ae3c04ec6

Queued, thanks.

Paolo

