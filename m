Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A834BB863
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 12:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbiBRLke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 06:40:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234996AbiBRLk2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 06:40:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 535AF60F3
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 03:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645184389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u6oPFlqZUUf9Ilo74KAr7+ULBewI1p3jLa6moAZI9Uo=;
        b=OXz2W3bhYu5nRB6oiomQWOexEMP2iMiqIFWV6SYrTy2+oaW3p/AOylF29b3mDqkDXeZZ46
        YcoH3ucOfA4aem6txqF8y0yBZhYTHd+kyNJkhAEAnX69T8WDp8vu8rEGUA7POeLXbzmAnk
        idjerrEb5Fo6vb9nY8PIXQJi/4ZRj+U=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-Kz3yBH8mM6KikIH69V-D6A-1; Fri, 18 Feb 2022 06:39:47 -0500
X-MC-Unique: Kz3yBH8mM6KikIH69V-D6A-1
Received: by mail-wm1-f70.google.com with SMTP id n26-20020a05600c3b9a00b0037c524e6d97so2732176wms.9
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 03:39:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=u6oPFlqZUUf9Ilo74KAr7+ULBewI1p3jLa6moAZI9Uo=;
        b=DT/wNKSTg2r/l6MJV5+hkke/z1BqD/6GbqoATd2vBNtEXPJzC4tke+uJ8tUl0U9dXc
         V5Nfo5xD5iuIwkMN8DcojxiHZ6nzrcPDFDaZsAJ2vO80pA/SNjEdcYzqX6QjJ2za/Yab
         7mOLu6NSKAwEWXQ7hY/iZfYc1bPLIeKB0ysox4/w9j/RDmsrHQWW2NDA0Jq7ozo2A26a
         A1563mafP1ZFDpS/Fg9eTciXHUzuhpul9tKmqlO0n+uz7GtIydSJcx2F/C8hrpS0kOZc
         4z4DnnR3Aw0Pp99xJTftXeSgoasS1PV11WE+qnT9SkADBNIT2mSNiKR6FrLw9td5ENqn
         3COg==
X-Gm-Message-State: AOAM530vHJ8LJDm48HiuS61L41EsL6GXKzbwBMDU1TP96GQbFV+f/MCh
        2fGhhEa+CtF8uLqDJk/joEDWy5+sTS1OeXNMgycmD54CGIQXWowwh/GOUkJvDHg5KqsjIpuu95V
        gTjAsvIs7TwbN
X-Received: by 2002:a5d:6d85:0:b0:1e2:f9f9:ab97 with SMTP id l5-20020a5d6d85000000b001e2f9f9ab97mr5649467wrs.469.1645184386292;
        Fri, 18 Feb 2022 03:39:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwGK/FyLZfrD5HIi49gEBBhO4Pe3orBzg+nmlIsf6SrirbQns/xRDOAPKkpjRc47sEkm+NhlA==
X-Received: by 2002:a5d:6d85:0:b0:1e2:f9f9:ab97 with SMTP id l5-20020a5d6d85000000b001e2f9f9ab97mr5649455wrs.469.1645184386090;
        Fri, 18 Feb 2022 03:39:46 -0800 (PST)
Received: from [192.168.0.5] (ip4-95-82-160-17.cust.nbox.cz. [95.82.160.17])
        by smtp.gmail.com with ESMTPSA id p16sm4322038wmq.18.2022.02.18.03.39.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 03:39:45 -0800 (PST)
Message-ID: <bf97384a-2244-c997-ba75-e3680d576401@redhat.com>
Date:   Fri, 18 Feb 2022 12:39:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>
Cc:     Mark Kanda <mark.kanda@oracle.com>
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <f7dc638d-0de1-baa8-d883-fd8435ae13f2@redhat.com>
From:   =?UTF-8?B?TWljaGFsIFByw612b3puw61r?= <mprivozn@redhat.com>
In-Reply-To: <f7dc638d-0de1-baa8-d883-fd8435ae13f2@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/17/22 18:52, Paolo Bonzini wrote:
> On 1/28/22 16:47, Stefan Hajnoczi wrote:
>> Dear QEMU, KVM, and rust-vmm communities,
>> QEMU will apply for Google Summer of Code 2022
>> (https://summerofcode.withgoogle.com/) and has been accepted into
>> Outreachy May-August 2022 (https://www.outreachy.org/). You can now
>> submit internship project ideas for QEMU, KVM, and rust-vmm!
>>
>> If you have experience contributing to QEMU, KVM, or rust-vmm you can
>> be a mentor. It's a great way to give back and you get to work with
>> people who are just starting out in open source.
>>
>> Please reply to this email by February 21st with your project ideas.
> 
> I would like to co-mentor one or more projects about adding more
> statistics to Mark Kanda's newly-born introspectable statistics
> subsystem in QEMU
> (https://patchew.org/QEMU/20220215150433.2310711-1-mark.kanda@oracle.com/),
> for example integrating "info blockstats"; and/or, to add matching
> functionality to libvirt.
> 
> However, I will only be available for co-mentoring unfortunately.

I'm happy to offer my helping hand in this. I mean the libvirt part,
since I am a libvirt developer.

I believe this will be listed in QEMU's ideas list, right?

Michal

