Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91FDE4BDDAC
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353251AbiBUKRg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 05:17:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353187AbiBUKRW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 05:17:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E3EE7C01
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 01:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645436195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hxBGcshXAlWLA7OAp43IgLevrCVr0xmO912o00i5QAo=;
        b=X8pGrascTCBxhBS5uP1RnI3E8dwMnI0BOlxwgak1vZKHIf2Mod2KN1jEVC+WeYf9cgwllz
        m+dofvhGCTg0O/o761gvWM/Ht8LGEL5u2qxxv2NeAwqaVoNwPAij7+sxrDdRbrcW3mQYSR
        1ojtIltZdPAFnyaw2QLe93QGD0MdnC0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-zr8hQ_ARPtKnvnvUJ2B0dw-1; Mon, 21 Feb 2022 04:36:32 -0500
X-MC-Unique: zr8hQ_ARPtKnvnvUJ2B0dw-1
Received: by mail-ed1-f72.google.com with SMTP id dy17-20020a05640231f100b00412897682b4so8054664edb.18
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 01:36:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hxBGcshXAlWLA7OAp43IgLevrCVr0xmO912o00i5QAo=;
        b=Ucfrag+nf0dGHKHBSYrFYpjhsdN8uv1v/dYJ8/SMqnKtzEKWkH8gWtUSs43IiPBRFI
         296dFBIdHXd6Iarkdwpg+Qxoh0t5zzmgV8iAFHCZqc0bDWn2zlFJBebRfjHnG7nYZ0JJ
         1qqPGIX6exD5e+vyPbDbDeU4OqLoFy/tBa3M2kP9KzWmNThWYoUD2GBIqkB6ElExc3zm
         vJglG9IRiqoywwe037HOMGslLn0INt5Ym/DF4K64FVK3Jky/I/GqLgmW4eu4z/B0Fx4O
         fwJJqMjz1AMAEHICX2iyk+Yng1b9BKTvn0Gmm4xmhptjGcPAU3IXX3j5JEXverA3hHfk
         UuJQ==
X-Gm-Message-State: AOAM533OUGpWbXemIsAU9zJyJYSoiud/w75H4+FGS0Dl5rk6hOcWDDlq
        +hizsQvTjfGU7uXXxbWFWaMeR+jrg7mMn5aR9wu2TG+40kmDlBwxvkdU2bL3KXTujSpUT3s3gfp
        yEiHlnIMUJua5
X-Received: by 2002:a17:906:f74c:b0:6cf:6f7b:25a8 with SMTP id jp12-20020a170906f74c00b006cf6f7b25a8mr15445534ejb.532.1645436191176;
        Mon, 21 Feb 2022 01:36:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxexHXWrTv7Oe/fsLj1d8vfHP+ilC8LAvyuxLe8mCxZAcQg2mgunRiQV2rxFWigPDhwABDZQQ==
X-Received: by 2002:a17:906:f74c:b0:6cf:6f7b:25a8 with SMTP id jp12-20020a170906f74c00b006cf6f7b25a8mr15445524ejb.532.1645436190969;
        Mon, 21 Feb 2022 01:36:30 -0800 (PST)
Received: from [10.43.2.56] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id r3sm5044262ejd.129.2022.02.21.01.36.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 01:36:30 -0800 (PST)
Message-ID: <d2af5caf-5201-70aa-92cc-16790a8159d1@redhat.com>
Date:   Mon, 21 Feb 2022 10:36:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
Content-Language: en-US
To:     Stefan Hajnoczi <stefanha@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <f7dc638d-0de1-baa8-d883-fd8435ae13f2@redhat.com>
 <bf97384a-2244-c997-ba75-e3680d576401@redhat.com>
 <ad4e6ea2-df38-005a-5d60-375ec9be8c0e@redhat.com>
 <CAJSP0QVNjdr+9GNr+EG75tv4SaenV0TSk3RiuLG01iqHxhY7gQ@mail.gmail.com>
From:   =?UTF-8?B?TWljaGFsIFByw612b3puw61r?= <mprivozn@redhat.com>
In-Reply-To: <CAJSP0QVNjdr+9GNr+EG75tv4SaenV0TSk3RiuLG01iqHxhY7gQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/19/22 14:46, Stefan Hajnoczi wrote:
> On Fri, 18 Feb 2022 at 16:03, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 2/18/22 12:39, Michal Prívozník wrote:
>>> On 2/17/22 18:52, Paolo Bonzini wrote:
>>>> I would like to co-mentor one or more projects about adding more
>>>> statistics to Mark Kanda's newly-born introspectable statistics
>>>> subsystem in QEMU
>>>> (https://patchew.org/QEMU/20220215150433.2310711-1-mark.kanda@oracle.com/),
>>>> for example integrating "info blockstats"; and/or, to add matching
>>>> functionality to libvirt.
>>>>
>>>> However, I will only be available for co-mentoring unfortunately.
>>>
>>> I'm happy to offer my helping hand in this. I mean the libvirt part,
>>> since I am a libvirt developer.
>>>
>>> I believe this will be listed in QEMU's ideas list, right?
>>
>> Does Libvirt participate to GSoC as an independent organization this
>> year?  If not, I'll add it as a Libvirt project on the QEMU ideas list.
> 
> Libvirt participates as its own GSoC organization. If a project has
> overlap we could do it in either org, or have a QEMU project and a
> libvirt project if the amount of work is large enough.

Indeed. Libvirt's participating on its own since 2016, IIRC. Since we're
still in org acceptance phase we have some time to decide this,
actually. We can do the final decision after participating orgs are
announced. My gut feeling says that it's going to be more work on QEMU
side which would warrant it to be on the QEMU ideas page.

But anyway, we can wait an see. Meanwhile, as Stefan is trying to
compile the list for org application, I'm okay with putting it onto
QEMU's list.

Michal

