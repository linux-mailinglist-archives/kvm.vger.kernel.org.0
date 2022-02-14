Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6085E4B4F50
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 12:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352668AbiBNLuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 06:50:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351798AbiBNLuO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 06:50:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F282C62
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 03:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644839315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DAU1V9PjadYHsz+MS0nCr09B0ouxSodDBOpNbCwLlT4=;
        b=GVj6jrygiIyVeS2FpI8+VDDf/k/0EPvZZI2nBC12NZhlcWhtF7o9Gexs3MHG3s0pq5olCk
        g3gXE5lFdpsjbtpLSjv6b70BsNQuUe4VH5ySfdQRdiZIUm9e+cmVrhnJaWDM4DidyJqpXb
        y4NQwnQKPLyL2ErHJmvNRb/ySSCBHdU=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-477-opYZ6x4rM_aUtPncdxd9ZQ-1; Mon, 14 Feb 2022 06:48:34 -0500
X-MC-Unique: opYZ6x4rM_aUtPncdxd9ZQ-1
Received: by mail-qv1-f72.google.com with SMTP id k6-20020ad45be6000000b0042c82bd64deso5740363qvc.22
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 03:48:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DAU1V9PjadYHsz+MS0nCr09B0ouxSodDBOpNbCwLlT4=;
        b=d9bWCtFq8gtakcjTiB2m+JzqBMSE1IzIY8UoTbvSmRtDqrIMSq+7063rxjup41zrl2
         WsZYpQwr/WNP4zbyP90Pe+w60vPKQZOF3f7kmPHIer/+StmoF7kULcSEmXyOO1LLAk8A
         VkduzbcZqiaa1Vo0rs3ACRjY17epUCXp/Z7di2InL3cUFz+3jkvkOhxLVBCk6jWcVAGE
         pZmdMDZaMXo7qMPzE7muGFBvh9vbe3reWmkFNhN3c1zWnBW4ksiMBzlcdRi5Juj3j3wL
         4yCJzRuVdlk9a0eBaTc8F+hQvubaIc/UzhZ4NcqJMKyrCcGOfOhdHd4pYxAYREPwZ8he
         dRCA==
X-Gm-Message-State: AOAM532Qyw3oijwgo/pmymxcAUFxDUaYO/Fr94bBTk1EAGRohYwUW00i
        oDIpPf1Kit0rxgQAG0HUfkwaj8sHy8KNKQGRO90giwxgqRuXnWubphJvwcFTquwE4ftaVcQAvZb
        h3w9+5qtPZh7j
X-Received: by 2002:a05:620a:10aa:: with SMTP id h10mr6732814qkk.36.1644839313727;
        Mon, 14 Feb 2022 03:48:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzG+/SNlmMcw5kQF0ct454DFF7SsZ8w10fg2ajvXlYZDkX6Dyiz5Z4BHkpeaNBNol3by4XN2g==
X-Received: by 2002:a05:620a:10aa:: with SMTP id h10mr6732806qkk.36.1644839313519;
        Mon, 14 Feb 2022 03:48:33 -0800 (PST)
Received: from step1g3 (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id x21sm3224474qtp.67.2022.02.14.03.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 03:48:32 -0800 (PST)
Date:   Mon, 14 Feb 2022 12:48:25 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>,
        qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        John Snow <jsnow@redhat.com>, Sergio Lopez <slp@redhat.com>,
        "Florescu, Andreea" <fandree@amazon.com>,
        Alex Agache <aagch@amazon.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
Message-ID: <20220214114825.pi44m7mqyqvvtt52@step1g3>
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <CACGkMEvtENvpubmZY3UKptD-T=c9+JJV1kRm-ZPhP08xOJv2fQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CACGkMEvtENvpubmZY3UKptD-T=c9+JJV1kRm-ZPhP08xOJv2fQ@mail.gmail.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 03:11:20PM +0800, Jason Wang wrote:
>On Fri, Jan 28, 2022 at 11:47 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
>>
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
>>
>> Good project ideas are suitable for remote work by a competent
>> programmer who is not yet familiar with the codebase. In
>> addition, they are:
>> - Well-defined - the scope is clear
>> - Self-contained - there are few dependencies
>> - Uncontroversial - they are acceptable to the community
>> - Incremental - they produce deliverables along the way
>>
>> Feel free to post ideas even if you are unable to mentor the project.
>> It doesn't hurt to share the idea!
>
>Implementing the VIRTIO_F_IN_ORDER feature for both Qemu and kernel
>(vhost/virtio drivers) would be an interesting idea.
>
>It satisfies all the points above since it's supported by virtio spec.

Yep, I agree!

>
>(Unfortunately, I won't have time in the mentoring)

I can offer my time to mentor this idea.

Thanks,
Stefano

