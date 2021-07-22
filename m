Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB983D2B7E
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 19:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhGVRM4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 13:12:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45916 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229914AbhGVRMz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 13:12:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626976410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=goPIQXYK/DFw8OEXLsDnPAwSK6aFUoV5iM0rGEZcve4=;
        b=LdvksYLZ9WnMrcfdmuq8Sa0fXFuhSrIeijPLa/deYIodPuAvgimLGE9hzBzkKIWTw16/0v
        YaJmSUtvL43bvRNPA5mj5mLV0I7dpgZiQL2U0anmO+tCfOlN2z39i5AmhhI/egGAjghCXN
        3nO3EXs/rji7uLMXh8bMY8nbRiLEge8=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-vVNacFLfOrGBGMrZmWgnJQ-1; Thu, 22 Jul 2021 13:53:29 -0400
X-MC-Unique: vVNacFLfOrGBGMrZmWgnJQ-1
Received: by mail-oo1-f72.google.com with SMTP id q22-20020a0568200296b0290264198007e0so2362608ood.14
        for <kvm@vger.kernel.org>; Thu, 22 Jul 2021 10:53:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=goPIQXYK/DFw8OEXLsDnPAwSK6aFUoV5iM0rGEZcve4=;
        b=PIyA4w3CakRt7bitMJd4gI0ybtxozA0txN4J2ZO5b3FY53m53++F4tS3rpfUih04js
         WU4NkAMKzb5L3xL+K3gPl545fo+K9EXyYLH8cOip5InrKdZzNU6+oLZ+WasBffevVd6+
         qI20uyw4liTfkOPTAQtjMPmdBeGsRbLrDXOYo80OF1ChTivMaycvgOji+uPLRV+Iw0tr
         2VFXW6mERfX+qPGK5LvELSqDns4dyQWozI9JMXMnHAjed1xRvERq4QTFNap4l1aUkieN
         +qo/0yKUYumHQu7RJBkN3Fzr/goOZVV6KNIRVOlBuFxDOm8BcZ+o46VqKoobO1Zc1csM
         W3iA==
X-Gm-Message-State: AOAM532jqBgxBKHdckQJ09tXqXSl4klTQue4mshURSA9fp+PSMVkHJu2
        Ph30nLPjOu8MK536WKA3AUbYJ8tZBJuloE6X/4gDFRlGehNnRpBa3BXqoT6hih1DyWicR+WTKBs
        pZERRyHU6AX4ci+SVkcj4F3qN7WN3U5cfiA6La5G8xOb0Cdyqlrdod8v4fmvr0g==
X-Received: by 2002:a9d:c67:: with SMTP id 94mr638284otr.344.1626976408413;
        Thu, 22 Jul 2021 10:53:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0/4rDUJ5QsQwh5b/vrnNR7o/qqhiIVkiRUlwu1yZ7R+x1acnO6FfIOQlFiEg38eNqdDaXEw==
X-Received: by 2002:a9d:c67:: with SMTP id 94mr638259otr.344.1626976408044;
        Thu, 22 Jul 2021 10:53:28 -0700 (PDT)
Received: from [192.168.0.173] (ip68-102-25-176.ks.ok.cox.net. [68.102.25.176])
        by smtp.gmail.com with ESMTPSA id q13sm4996825oov.6.2021.07.22.10.53.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 10:53:27 -0700 (PDT)
From:   Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v2 06/44] hw/i386: Introduce kvm-type for TDX guest
To:     isaku.yamahata@gmail.com, qemu-devel@nongnu.org,
        pbonzini@redhat.com, alistair@alistair23.me, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, mst@redhat.com, cohuck@redhat.com,
        mtosatti@redhat.com, xiaoyao.li@intel.com, seanjc@google.com,
        erdemaktas@google.com
Cc:     isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <04c08d0770736cfa2e3148489602bc42492c78f3.1625704980.git.isaku.yamahata@intel.com>
Message-ID: <9ae8bb84-7e6b-28d2-b240-7c07d14f6f50@redhat.com>
Date:   Thu, 22 Jul 2021 12:53:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <04c08d0770736cfa2e3148489602bc42492c78f3.1625704980.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/7/21 7:54 PM, isaku.yamahata@gmail.com wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> Introduce a machine property, kvm-type, to allow the user to create a
> Trusted Domain eXtensions (TDX) VM, a.k.a. a Trusted Domain (TD), e.g.:
> 
>   # $QEMU \
> 	-machine ...,kvm-type=tdx \
> 	...
> 
> Only two types are supported: "legacy" and "tdx", with "legacy" being
> the default.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

I am not a QEMU command line expert, so my mental model of this may be
wrong, but:

This seems to have a very broad scope on the command line and I
am wondering if it's possible to associate it with a TDX command
line object specifically to narrow its scope.

I.e., is it possible to express this on the command line when
launching something that is _not_ meant to be powered by TDX,
such as an SEV guest? If it doesn't make sense to express that
command line argument in a situation like that, perhaps it could
be constrained only to the TDX-specific commandline objects.

