Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9AA5699B4F
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 18:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbjBPRa5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 12:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjBPRay (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 12:30:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73534C6FD
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 09:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676568610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a6vhfPC9iLZDFDVrE3a8fWLbQZznkkIIcfW6D4cCJsY=;
        b=Z7cWLBakfV1t+oXIQXsUx+vmIdNXfDEzphUq+o57wVVCjwh2ogqRtXfJPuJzZRazoy93it
        sLG5MsQTIzM1VzLRjhdqkg0TRKQcFAofBgYfSewCU1vuJ/qNrBR6fKf5FWjQmRAIY7lnm7
        t01HvNWg559GUiikvRcsdoiqFZFxMmM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-640-by2a6nOwNFes-ZLo6SQyiw-1; Thu, 16 Feb 2023 12:30:08 -0500
X-MC-Unique: by2a6nOwNFes-ZLo6SQyiw-1
Received: by mail-qk1-f199.google.com with SMTP id x17-20020a05620a449100b00731b7a45b7fso1619111qkp.2
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 09:30:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a6vhfPC9iLZDFDVrE3a8fWLbQZznkkIIcfW6D4cCJsY=;
        b=8Iu5Dp2S9+A3OKVif2e/wJIJ1Bd84niBcaBiRLmOyUlefyq+JN2r9o6Etr6hH2/s/J
         wbjAnTnYDL/dUPwm5jYL+2Cm1qbrMnJqWkLNcoRMmnvZxUhKyXFAqSrWvHN36oRu+t4u
         Ret/IUpx8QDBdzZRf3G6cwVI/GLCg4r+VuRuk8KRIqKQ/DKvx64ga5UQoxbW2jeexWPj
         RWt2U3+h/J0qBvFqjnbm0fcgu7/rhX7rNJ4g/RoW+NhkuFiJ8AzqTS9TQSksJffU4FZY
         eszStAA0wPJXjCZTD6Wgz7/PyIx7glDB+dfKoRJqh2xwSvGCsOt46lKu7lZIIfq0kAmt
         ci0g==
X-Gm-Message-State: AO0yUKWNLUZBXcUTuDxKzANHOxaEI7IGrNlebJXaYFTzWHqZ6MOSex9F
        Y1OL1boWPZqJ7na7eYC6DZlWQfibcR/lxk8PRa+kpwRtL1eY25n0aUxt2vWWiGLud7HXQVmowvA
        eM5klUfY18X7T
X-Received: by 2002:ac8:7d07:0:b0:3ab:ceb9:10fd with SMTP id g7-20020ac87d07000000b003abceb910fdmr11329513qtb.25.1676568607730;
        Thu, 16 Feb 2023 09:30:07 -0800 (PST)
X-Google-Smtp-Source: AK7set/RXqxYufSS98eBf9fAvzFVkJZ6G6zOY3tClRRFyhFCt0yJMI00Jb8V3g55XI8CToBOWpOw7w==
X-Received: by 2002:ac8:7d07:0:b0:3ab:ceb9:10fd with SMTP id g7-20020ac87d07000000b003abceb910fdmr11329487qtb.25.1676568607461;
        Thu, 16 Feb 2023 09:30:07 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id c75-20020a379a4e000000b0073b6a06911asm1570977qke.95.2023.02.16.09.30.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 09:30:06 -0800 (PST)
Message-ID: <f993d409-8769-ac87-020f-cf8fd03cb496@redhat.com>
Date:   Thu, 16 Feb 2023 18:30:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v5 3/3] qtests/arm: add some mte tests
Content-Language: en-US
To:     Cornelia Huck <cohuck@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
References: <20230203134433.31513-1-cohuck@redhat.com>
 <20230203134433.31513-4-cohuck@redhat.com>
 <a7904d6e-c8e5-055b-34f7-8ea2956ec65f@redhat.com> <874jrndwjm.fsf@redhat.com>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <874jrndwjm.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Connie,

On 2/15/23 11:59, Cornelia Huck wrote:
> On Mon, Feb 06 2023, Eric Auger <eauger@redhat.com> wrote:
> 
>> Hi,
>>
>> On 2/3/23 14:44, Cornelia Huck wrote:
>>> @@ -517,6 +583,13 @@ static void test_query_cpu_model_expansion_kvm(const void *data)
>>>          assert_set_feature(qts, "host", "pmu", false);
>>>          assert_set_feature(qts, "host", "pmu", true);
>>>  
>>> +        /*
>>> +         * Unfortunately, there's no easy way to test whether this instance
>>> +         * of KVM supports MTE. So we can only assert that the feature
>>> +         * is present, but not whether it can be toggled.
>>> +         */
>>> +        assert_has_feature(qts, "host", "mte");
>> I know you replied in v4 but I am still confused:
>> What does
>>       (QEMU) query-cpu-model-expansion type=full model={"name":"host"}
>> return on a MTE capable host and and on a non MTE capable host?
> 
> FWIW, it's "auto" in both cases, but the main problem is actually
> something else...
> 
>>
>> If I remember correctly qmp_query_cpu_model_expansion loops over the
>> advertised features and try to set them explicitly so if the host does
>> not support it this should fail and the result should be different from
>> the case where the host supports it (even if it is off by default)
>>
>> Does assert_has_feature_enabled() returns false?
> 
> I poked around a bit with qmp on a system (well, model) with MTE where
> starting a guest with MTE works just fine. I used the minimal setup
> described in docs/devel/writing-monitor-commands.rst, and trying to do a
> cpu model expansion with mte=on fails because the KVM ioctl fails with
> -EINVAL (as we haven't set up proper memory mappings). The qtest setup
> doesn't do any proper setup either AFAICS, so enabling MTE won't work
> even if KVM and the host support it. (Trying to enable MTE on a host
> that doesn't support it would also report an error, but a different one,
> as KVM would not support the MTE cap at all.) We don't really know
> beforehand what to expect ("auto" is not yet expanded, see above), so
> I'm not sure how to test this in a meaningful way, even if we did set up
> memory mappings (which seems like overkill for a feature test.)
> 
> The comment describing this could be improved, though :)
> 

OK fair enough, don't make it a blocking issue for the series and simply
update the comment up to your knowledge.

Thanks

Eric

