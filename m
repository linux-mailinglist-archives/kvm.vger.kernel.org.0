Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1E5E58EC54
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 14:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbiHJMxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 08:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbiHJMws (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 08:52:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2EC1EAE218
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 05:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660135961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uU8Ji2H2jJkrFfWn1VZHBL0MhVKEFsbTbqMVDnVch7k=;
        b=XXCg5ivvbRgiaiM0U01od4CfYw5gV8MwF3io5xgf8fLJhmWroh9y//uDSEPla9X+SFZRPW
        tu2wWEtsTKnY4Hg1wi50FFaN+ZT1CZ0/LpdGmEnAhFo3M+zG1Bf/Bj1nUYMgV9rwpritPq
        /p010n5DSkM3Nwb9LCd1RG6kDO/NpI0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-p6ZcuvMUNJ6R3aTgVia1_g-1; Wed, 10 Aug 2022 08:52:40 -0400
X-MC-Unique: p6ZcuvMUNJ6R3aTgVia1_g-1
Received: by mail-ej1-f70.google.com with SMTP id ga16-20020a1709070c1000b007331af32d3aso112077ejc.4
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 05:52:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=uU8Ji2H2jJkrFfWn1VZHBL0MhVKEFsbTbqMVDnVch7k=;
        b=M012c04n2Mxa8rXGmwQyeYmAcolbsUqhCxwuctrYmFy92Yk7DXAkSzvZnnZ0W4oG5Y
         4CLAWwpL/GiTngpVvyTEzKLznqOu/SF1a+cdKdSGTL7gO1cU/OSECDtfpjAMCZX9K593
         4juTP04Y5yE2f9zne4I1QLJbCM3brQ65EskHecRm7T13AtDAog23tlA1nk1ydqQOP68n
         uuJw8vhtKv/tXkhfsrWrSNCApOWHq8F9fiWy8yS5a7iw775HQ4MUVLdBLr1KIQILiK7g
         kJdN4+7TTbxTvDOPLgSNSMW55N4n5F33Fx5eWeSbKL05xIw7PlJiKpffUVvH/wWxwGYz
         6d6Q==
X-Gm-Message-State: ACgBeo1ZcZPmNQPnghOkdzhljcKlhEZNxQo99uI81qmeblDU9NKxTsPH
        XtmYrUMrpCKvnrpjZVbLzPEfT0jxPdi1A2XPfi1IuF/q7L7wt9NY1PwFRau8AIVHRKoWOenJL9l
        m+y0XuOkdQtLa
X-Received: by 2002:a17:907:1b25:b0:6da:8206:fc56 with SMTP id mp37-20020a1709071b2500b006da8206fc56mr20613729ejc.81.1660135958968;
        Wed, 10 Aug 2022 05:52:38 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6XzpJkuBwStNL5JtL1fuUuqeVnj1aaChdrmp243FOLsAudH26ztnYFMlhCIjB28Hk+1xAj7g==
X-Received: by 2002:a17:907:1b25:b0:6da:8206:fc56 with SMTP id mp37-20020a1709071b2500b006da8206fc56mr20613723ejc.81.1660135958787;
        Wed, 10 Aug 2022 05:52:38 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id y10-20020a50eb8a000000b0043ccd4d15eesm7559461edr.64.2022.08.10.05.52.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 05:52:38 -0700 (PDT)
Message-ID: <c2335a69-c243-3c5f-b983-938c91cb5c2c@redhat.com>
Date:   Wed, 10 Aug 2022 14:52:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [RFC PATCH 0/3] KVM: x86: Disallow writes to feature MSRs
 post-KVM_RUN
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
References: <20220805172945.35412-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220805172945.35412-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/5/22 19:29, Sean Christopherson wrote:
> Give feature MSRs that same treatment as CPUID and disallow changing said
> MSRs after KVM_RUN.
> 
> RFC as this is lightly tested and should come with a selftests update to
> verify it actually works.  Posting early to get feedback on the overall
> idea, and on the VMX MSRs trickery (though I think patches 1-2 are a good
> idea irrespective of trying to reduce the overhead of the new check).

They are good, just a small style remark on patch 2.

Paolo

