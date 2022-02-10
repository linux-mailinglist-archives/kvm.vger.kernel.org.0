Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844954B15A8
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 19:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343602AbiBJS5C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 13:57:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241471AbiBJS5B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 13:57:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 066B810B7
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 10:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644519421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DWbyQbdk9qYouLFOqzK9so4MUWtuTXwuFOQGtTfjM4U=;
        b=AN34HMogNuk47vWFY8E/EpE+yrzx2k1IXrObTgHhnn0hB2Y+dP9wyAoh+kvAt9wqeEnpWZ
        x8wRuPRgYlhhh/6GE5zKR44f1QxllJdh1x0DLITfWfL+PUjrpFsg5H1wbyHRg9AKf2ZRSX
        OQg6cl3AtdzWpYXHj01OOMeBSYPmLvg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193-1jUvnTokOaqCAoF9DiJCiQ-1; Thu, 10 Feb 2022 13:56:59 -0500
X-MC-Unique: 1jUvnTokOaqCAoF9DiJCiQ-1
Received: by mail-ed1-f70.google.com with SMTP id bq19-20020a056402215300b0040f276105a4so3896214edb.2
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 10:56:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DWbyQbdk9qYouLFOqzK9so4MUWtuTXwuFOQGtTfjM4U=;
        b=InbDZ9bXxDw7HLN1qaOFgI0mvmcRdik9V9Hxa4Bh9WccZ7rjjELtIz9LW2RwwMf+X7
         NGOwHekPVEF0JaAaVxXmuXr2/H4lmdqrU+lF28Yv9M/dKus2GKDlc/e6cMTpDB4+BKmc
         XzAnXzNTNlmaF6bZUHQjI9PxJrv6Z2cOTEnp8H0sJoP2iEZPram7+d5vW44itiapDqul
         WzWWRfFk7zp/t9LvpW+Sd9qCawQQYePgB24oIDm662wPGOzRRwqtzYLtRJTPbRX3uy79
         ULGQ8EnJSnSAkosh49o9MlgTHRmeXlK0sMFpT6jdlcg1nyMBhCefvMfBwkusFVO7JUIj
         BERQ==
X-Gm-Message-State: AOAM533YhTzRsObkEYxufA/wNKmaa3LAB/enbnlJXjRg65cknrK4qFls
        d8WPZ+StgcZnRB0rNUrF7GX1jwOlAxw0NUvoclJ28WhnnWp+VIvfJArhQYH/qMbkeODfun0pl37
        e6jPI1uoUkknr
X-Received: by 2002:a17:907:2da9:: with SMTP id gt41mr7685857ejc.513.1644519418708;
        Thu, 10 Feb 2022 10:56:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxvFJcAbdybxVzcC8D3D9vkzAiD98jI69gE2Nw72A19tnn9TpZ23h5B47EVgBdJZZI5zNg0+g==
X-Received: by 2002:a17:907:2da9:: with SMTP id gt41mr7685844ejc.513.1644519418519;
        Thu, 10 Feb 2022 10:56:58 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id i6sm7304048eja.132.2022.02.10.10.56.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 10:56:57 -0800 (PST)
Message-ID: <eb4e24c6-41d0-4f3a-2af0-3008db408da6@redhat.com>
Date:   Thu, 10 Feb 2022 19:56:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH V2] selftests: kvm: Remove absent target file
Content-Language: en-US
To:     Shuah Khan <skhan@linuxfoundation.org>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Shuah Khan <shuah@kernel.org>, Peter Gonda <pgonda@google.com>
Cc:     kernel@collabora.com, kernelci@groups.io,
        "kernelci.org bot" <bot@kernelci.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220210172352.1317554-1-usama.anjum@collabora.com>
 <f9893f6a-b68b-e759-54f5-eef73e8a9eef@linuxfoundation.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <f9893f6a-b68b-e759-54f5-eef73e8a9eef@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/10/22 19:02, Shuah Khan wrote:
> 
> I am fine with the change itself. For this patch:
> 
> Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
> 
> However, are we missing a vmx_pi_mmio_test and that test needs to be added.
> 
> Just in case the test didn't make it into the 6a58150859fd and the intent
> was to add it - hence the Makefile addition? This can be addressed in
> another patch. Just want to make sure we aren't missing a test.

This was probably a rebase resolution issue.  The vmx_pi_mmio_test fails 
in the mainline tree, and is lingering in my tree together with the fix 
because somebody promised a better fix for it.  I included the 
TEST_GEN_PROGS_x86_64 line by mistake when rebasing Peter Gonda's test 
below vmx_pi_mmio_test.

Thanks for the fix,

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

