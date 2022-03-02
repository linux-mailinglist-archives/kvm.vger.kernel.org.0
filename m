Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 186014CACEE
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 19:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244365AbiCBSGX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 13:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbiCBSGW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 13:06:22 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2124532F4
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 10:05:38 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id q7-20020a7bce87000000b00382255f4ca9so3339501wmj.2
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 10:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZRbxhyIo7QFTHQ0Q34LjrAc9g2/0XGiPG1hZAulHZkA=;
        b=hsJub/vGwEfrA+G2hsr8g+rc0AVpaF6aurLKrg51ROrT7ZnTPvYMKGJwl7zNZnSLv0
         Fy0VD/4Q5B9H3NZKhr394BjLy9IHTjBJvxUrGk2NMDR4PSElobsxqeORS6l+yz0ocvRd
         zLXKRmo6/lEGxmf0H8dTDhwAJ/cZSG39RNxVRCclUyGQx5+VqDHqt1iVP7BP1a1j7cyk
         uAhE7wiBghcwctCu6EqEi4MX4hXGQ92YmJlXHKPEUH1+lNSAGVWywHH9iO2XUsJ9ZN6f
         mqPYq3UUoeQnD3jBlUZkf6tQO7tItNAS95E0W+hDkXxeCZRTRgujysdQbtqT3rrdI0gN
         fcMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZRbxhyIo7QFTHQ0Q34LjrAc9g2/0XGiPG1hZAulHZkA=;
        b=SAL7lGyal7muZ3ilVltADuHwjUatI7EQJ0kyJ3ETCCFIZYj9EQDAL5dgMq7B/0yh8M
         mOFQrfbxa0OOUbZFxSFsd22UJri5GpwJIAMS30MLuw8f6Rh6NF2ask5gpp+RxdLebzzT
         6YPI6Y1n/bWXbVr3sRyMBL+IPaR5P/PkOt18YO3XVDebcgnMYRa+m64LCNR4efa6Tv1x
         xgSOcxEtwqSUz9E8dAJA8Pdc9q/xt718IE2RiDTd0961j8yTby8Ltz4VUKdnDmK5PFgH
         wtTIDw5Vp/HT8bUDSa33zVdmFHt6iY7r544JoGk0jFzorgwQaIVJXiTClFLlwQgC2enB
         E8Lg==
X-Gm-Message-State: AOAM533MnDyqtVMQfgn8BYdAPuuk5YRCwkn0IyoXhRWytfZ9WDI2CvZw
        MTm28Mvm6049P5yd9EV93FzWXRBV+G0=
X-Google-Smtp-Source: ABdhPJxpLP5NOJ701iz3X3Zgnf2XeBRUTyBosWZDM+/4BJvV/HwR2K/PeATNPdSUZ10EPcXLyzxvfg==
X-Received: by 2002:a05:600c:4e4a:b0:380:e40a:289 with SMTP id e10-20020a05600c4e4a00b00380e40a0289mr807471wmq.17.1646244337368;
        Wed, 02 Mar 2022 10:05:37 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id g11-20020a5d554b000000b001f0326a23ddsm2813797wrw.70.2022.03.02.10.05.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 10:05:36 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <2976a926-9dbf-d955-166f-5677a06d9873@redhat.com>
Date:   Wed, 2 Mar 2022 19:05:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 2/2] Allow building vhost-user in BSD
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= 
        <philippe.mathieu.daude@gmail.com>, Sergio Lopez <slp@redhat.com>
Cc:     qemu-devel@nongnu.org, vgoyal@redhat.com,
        Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, qemu-block@nongnu.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Kevin Wolf <kwolf@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org, Matthew Rosato <mjrosato@linux.ibm.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Thomas Huth <thuth@redhat.com>
References: <20220302113644.43717-1-slp@redhat.com>
 <20220302113644.43717-3-slp@redhat.com>
 <66b68bcc-8d7e-a5f7-5e6c-b2d20c26ab01@redhat.com>
 <8dfc9854-4d59-0759-88d0-d502ae7c552f@gmail.com>
 <20220302173009.26auqvy4t4rx74td@mhamilton>
 <85ed0856-308a-7774-a751-b20588f3d9cd@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <85ed0856-308a-7774-a751-b20588f3d9cd@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/2/22 18:38, Philippe Mathieu-Daudé wrote:
> On 2/3/22 18:31, Sergio Lopez wrote:
>> On Wed, Mar 02, 2022 at 06:18:59PM +0100, Philippe Mathieu-Daudé wrote:
>>> On 2/3/22 18:10, Paolo Bonzini wrote:
>>>> On 3/2/22 12:36, Sergio Lopez wrote:
>>>>> With the possibility of using pipefd as a replacement on operating
>>>>> systems that doesn't support eventfd, vhost-user can also work on BSD
>>>>> systems.
>>>>>
>>>>> This change allows enabling vhost-user on BSD platforms too and
>>>>> makes libvhost_user (which still depends on eventfd) a linux-only
>>>>> feature.
>>>>>
>>>>> Signed-off-by: Sergio Lopez <slp@redhat.com>
>>>>
>>>> I would just check for !windows.
>>>
>>> What about Darwin / Haiku / Illumnos?
>>
>> It should work on every system providing pipe() or pipe2(), so I guess
>> Paolo's right, every platform except Windows. FWIW, I already tested
>> it with Darwin.
> 
> Wow, nice.
> 
> So maybe simply check for pipe/pipe2 rather than !windows?

What you really need is not pipes, but AF_UNIX.

Paolo
