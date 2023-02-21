Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1097069DABE
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 07:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbjBUGto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 01:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbjBUGtn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 01:49:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4249EE39A
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 22:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676962135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/4RqSw1XtxIt+7T5LPnP71jA7CIJFVNO0c6Q67Mzo/8=;
        b=Vhih3EO6rFuejZhKZ6pxKI3ll/ehrstIvsxW3HgWUuNvqRl9CC2wnIkXu2qrWffYjbd2+N
        HOU7COM5kbbctlaElKtdiKTyqG6kzz2eUVDw4ujAc/tQyPper3HXcu3bx1HuredC/3hZAw
        HEmeV3Xz4gXy0kpiTmrzX1+6UvXbZ+A=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-527-naMhrV7KNpuKGp9uyVNT9g-1; Tue, 21 Feb 2023 01:48:54 -0500
X-MC-Unique: naMhrV7KNpuKGp9uyVNT9g-1
Received: by mail-ed1-f70.google.com with SMTP id q13-20020a5085cd000000b004af50de0bcfso1947972edh.15
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 22:48:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/4RqSw1XtxIt+7T5LPnP71jA7CIJFVNO0c6Q67Mzo/8=;
        b=lOqnDuDFtbdwEckXoiyUcANrQ15IrGCwlMR1JsvN+15GJekRdvHewtka1TLLA6/bLX
         AGK/eCd/hzcFLsURz1xc2AvJQQPB5HCH6QQfrJAoALdhCRq5OYYV187XukK0vAxNW/QA
         JJoEnRQn+nipV04x9eVdyXV4gTSHX0d5f1twJFL1FX+05elVKB1caXnXV0Gxj2eOurH7
         KKbzeibkoCwiTUtijYeSQq9d28DKY+eM0kCDgYIq8uL71FpRPUxR+6v1zG/I/uMf7RYT
         nCi9RBjsB6qoN4NXlwLWG5RpzM/lst2wQ8ZowJLSFtw1UNUTIQOR8x1fZMN8pvjb+DUb
         wSmQ==
X-Gm-Message-State: AO0yUKXAsluumtR3uJBxSGHR753e8JJI3KaLs8cLl0/S+sl1I6zGlrMi
        zgeW5zHyfYTyl7V7NpKUY6oFh5W+YCbwthGxbIjqXR+uZnF9CZoOZDnxz+/6C6l+YSszicGdR6l
        Tb7MqOJSgXViT
X-Received: by 2002:a05:6402:f1c:b0:4a2:5652:d8ba with SMTP id i28-20020a0564020f1c00b004a25652d8bamr5332472eda.18.1676962132953;
        Mon, 20 Feb 2023 22:48:52 -0800 (PST)
X-Google-Smtp-Source: AK7set8OROvf5Bh5jDHrJVburrSnt8NDJGx/6Ow909cgcPMIfLuRt+lxg6/X2dSI775gjXgSytXoRQ==
X-Received: by 2002:a05:6402:f1c:b0:4a2:5652:d8ba with SMTP id i28-20020a0564020f1c00b004a25652d8bamr5332456eda.18.1676962132632;
        Mon, 20 Feb 2023 22:48:52 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id c4-20020a50d644000000b004aabb714230sm2711546edj.35.2023.02.20.22.48.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Feb 2023 22:48:52 -0800 (PST)
Message-ID: <53900813-ff1b-2451-d962-6114b3d4ade0@redhat.com>
Date:   Tue, 21 Feb 2023 07:48:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 05/29] LoongArch: KVM: Add vcpu related header files
Content-Language: en-US
To:     maobibo <maobibo@loongson.cn>, Xi Ruoyao <xry111@xry111.site>,
        Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>
References: <20230220065735.1282809-1-zhaotianrui@loongson.cn>
 <20230220065735.1282809-6-zhaotianrui@loongson.cn>
 <497693ca2cbc443c1d9f796c3aace6c9987bec72.camel@xry111.site>
 <7d6125dd-29e8-14d8-b1d7-d8c14d7bec80@loongson.cn>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <7d6125dd-29e8-14d8-b1d7-d8c14d7bec80@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/21/23 07:46, maobibo wrote:
>>> +       asm volatile (
>>> +               "parse_r __reg, %[val]\n\t"
>>> +               ".word 0x5 << 24 | %[reg] << 10 | 0 << 5 | __reg\n\t"
>> Don't do this.  You should add the instruction to binutils first, then
>> make CONFIG_KVM depend on the assembler supporting this instruction.
>> This is completely unreadable and only fine for an internal PoC.
> We are preparing to submit these instruction support for binutils,
> however it is still necessary. Supposing that it is supported in future
> gcc version, we can not drop existing gcc 12/13 supporting to compiling
> kernel with LoongArch architecture.
> 
> Maybe there will be human readable code like this:
> #if GCC_SUPPORT_KVM_INSTR
>    ...
> #else
>    asm volatile (".word   "
>    ...
> #endif

I agree, just add a comment with what would be the assembly code, i.e. 
something like

	/* Instructions only available in binutils v.... or later */
	asm volatile (
                "parse_r __reg, %[val]\n\t"
	       /* instrname %[val], %[reg] */
                ".word 0x5 << 24 | %[reg] << 10 | 0 << 5 | __reg\n\t"

Paolo

