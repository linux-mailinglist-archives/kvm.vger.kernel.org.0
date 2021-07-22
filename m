Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752BC3D2B7B
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 19:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhGVRMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 13:12:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55973 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230090AbhGVRMg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 13:12:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626976391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Duk7mz1WDAtfAVpo8VpdbrMWMtr8blQZG/OHLGs0DI=;
        b=ZAY9oaor2dcdfN4QK/qiW9CUL+Br1nt4JJve98ZhOTLtYV3R5RErT7dNclG38sekb7sWvD
        mDxac9HzEeDJTP1iDHLd/xOj4YQejIJAsqKIOkcG3jm4emuL+m0wHpsQLgk1KPl4H4LTYy
        Lyt29XpPUep9Yft7QWwOHMDKJ193g5M=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-QSP8mP6TP36uTm7dJbRrEA-1; Thu, 22 Jul 2021 13:53:09 -0400
X-MC-Unique: QSP8mP6TP36uTm7dJbRrEA-1
Received: by mail-ot1-f70.google.com with SMTP id c3-20020a9d61430000b0290474c23d2dbcso4142424otk.15
        for <kvm@vger.kernel.org>; Thu, 22 Jul 2021 10:53:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4Duk7mz1WDAtfAVpo8VpdbrMWMtr8blQZG/OHLGs0DI=;
        b=TPEuveeZvExevNqgUiYATG5nBRqRYwaiUNjyaz3X9E7HLecNLZe3C4eN5w1F+OPMIC
         NJ6HtxaCKTL62OdD5BY1OJebdoC90X0FvnAKK7+SQjb8tDBun3UlwmBRE+8349PNCJoj
         Sl+AK6dj7wgjgxk3tFHNxP6+fuwIXGelMhMNYoLGSSS468+g6w15QsrvGmgzf0XAiYfo
         u+jCT4Zjk7v4yXRMVm+IIWMIEJrstTJkKp0B4y7VN8nFYcJBTJ3kbR/VvrRev8liHU0T
         GOdd04y9wWRs83MZJIL61ZXPlooaKyfUj+RfP84DRvA6i4JXYNDY+JZhGmZ1MEaVUh+i
         cK0w==
X-Gm-Message-State: AOAM530fRb5c8gfDHYTPWhcOg37q93lYe/6qO83Ak4qQM/jl8LY3gjUF
        Bzlga6XMuH0lK5nkcN+8NNkT1M6O9xKRYlTPizQkjaIp7KpXaS/zCCPPl0ALrUYaPvR04RA7weV
        yzn8Fa+08EfTj/CLB5HVskZk55SHYXppZne5m6BqD8ZETIB3KmyUmJNjOOoAHhA==
X-Received: by 2002:a05:6808:aa3:: with SMTP id r3mr830783oij.133.1626976388884;
        Thu, 22 Jul 2021 10:53:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyofKsPcap+O4oiIqmCn7MJJqc8IOb4IQe62OYV/zwglIDRtc3PJTwMH/WWNqgtp7kkhKR5zw==
X-Received: by 2002:a05:6808:aa3:: with SMTP id r3mr830763oij.133.1626976388728;
        Thu, 22 Jul 2021 10:53:08 -0700 (PDT)
Received: from [192.168.0.173] (ip68-102-25-176.ks.ok.cox.net. [68.102.25.176])
        by smtp.gmail.com with ESMTPSA id q186sm2533040oib.31.2021.07.22.10.53.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 10:53:08 -0700 (PDT)
From:   Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v2 09/44] target/i386: kvm: don't synchronize guest
 tsc for TD guest
To:     isaku.yamahata@gmail.com, qemu-devel@nongnu.org,
        pbonzini@redhat.com, alistair@alistair23.me, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, mst@redhat.com, cohuck@redhat.com,
        mtosatti@redhat.com, xiaoyao.li@intel.com, seanjc@google.com,
        erdemaktas@google.com
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <b28fcb79c5fbc219b6664f7239215360c5fda04d.1625704981.git.isaku.yamahata@intel.com>
Message-ID: <f0ee77b5-eafe-ce5e-b665-0a07756efc20@redhat.com>
Date:   Thu, 22 Jul 2021 12:53:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <b28fcb79c5fbc219b6664f7239215360c5fda04d.1625704981.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/7/21 7:54 PM, isaku.yamahata@gmail.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Make kvm_synchronize_all_tsc() nop for TD-guest.

s/nop/noop

> 
> TDX module specification, 9.11.1 TSC Virtualization

This appears in 9.12.1 of the latest revision as of this writing.

https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-module-1eas-v0.85.039.pdf

> "Virtual TSC values are consistent among all the TD;s VCPUs at the

s/TD;s/TDs

> level suppored by the CPU".

s/suppored/supported

> There is no need for qemu to synchronize tsc and VMM can't access
> to guest TSC. Actually do_kvm_synchronize_tsc() hits assert due to
> failure to write to guest tsc.
> 
>> qemu/target/i386/kvm.c:235: kvm_get_tsc: Assertion `ret == 1' failed.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Connor Kuehl <ckuehl@redhat.com>

