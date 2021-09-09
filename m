Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7F04045E7
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 09:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352563AbhIIHEh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 03:04:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30226 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350467AbhIIHEX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 03:04:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631170994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HUBvw8j4TFsIarEE3fvS4je6Jlh+kiHU2Hz8uuU8quY=;
        b=OMHBICrXOX3Wd5IKXUVlPp9xsXdieMxv9xiTrqDnKWdJQ6yo69nG61tE+NGOUzgzHTAHXt
        PktDFLZ0DXX9AZT9YRETBnwSdF0ssgYt1fQEZWJIv91vWBrHUpctqbbjOrW47hKkiVq1BH
        NH7OU8yDPOOeETnOisouxY0WncUq+Y4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-qUg1ZrOdMAS82wNaZ_fSbQ-1; Thu, 09 Sep 2021 03:03:13 -0400
X-MC-Unique: qUg1ZrOdMAS82wNaZ_fSbQ-1
Received: by mail-wm1-f69.google.com with SMTP id c4-20020a1c9a04000000b002e864b7edd1so388673wme.6
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 00:03:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=HUBvw8j4TFsIarEE3fvS4je6Jlh+kiHU2Hz8uuU8quY=;
        b=r1MKRHcooHYQ1/WhOadY1c+ljXY921kVxnoFo06r7jl4ic4ZYmePPQRAzedHKTRnH2
         yWChxRg/NloRvs9sBH27c/vxSUxVCKi2m7NwrLn6Ls00IG2CKdwVKyTzYHUkb7LjdFGu
         LOsGVYuXBhgrJeCP26mYgeNjIH1nqngmrcwsW7+UOpGKJMySOdW6gg65Bc0skyZ86O5M
         7a0Sld/3x/D95oblN3XBnvIRg+Ve58h8c5pxvAmJKiuHACCG3/4kaMv1QmuZ6ArpCKb6
         zU9zihAGchn5IcBkid+fqzYwgR7dDplnMxRh9u1nYwurAgIRW1oUWW6DvxUG6LS422un
         9DVA==
X-Gm-Message-State: AOAM531PInYFqpFHGwprl1LJykm23ND9bX+B+56NA/KhIHld/3P69s5Y
        LdowxF8PoO9mr66E60hCDan4fawd2f4NwS6vik/mMJayCAiurgkXy8iISa2awTkPuYOdV+rKQH6
        g1wBlLvTqk5Lp
X-Received: by 2002:a7b:c5d8:: with SMTP id n24mr1273455wmk.51.1631170992024;
        Thu, 09 Sep 2021 00:03:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5z30hb9JghYpVAxn6JQxbFF6EQTeK8au3fTsIagXnuaKAVmndHuei2cK1lD1nFMAodiZ0bg==
X-Received: by 2002:a7b:c5d8:: with SMTP id n24mr1273436wmk.51.1631170991804;
        Thu, 09 Sep 2021 00:03:11 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id l1sm266046wmq.8.2021.09.09.00.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 00:03:11 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Filter out all unsupported controls when
 eVMCS was activated
In-Reply-To: <YTkwvrMl7SSCtQF7@google.com>
References: <20210907163530.110066-1-vkuznets@redhat.com>
 <YTkwvrMl7SSCtQF7@google.com>
Date:   Thu, 09 Sep 2021 09:03:10 +0200
Message-ID: <87v93a2pu9.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Sep 07, 2021, Vitaly Kuznetsov wrote:
>> Let's be bold this time and instead of playing whack-a-mole just filter out
>> all unsupported controls from VMX MSRs.
>
> Out of curiosity, why didn't we do this from the get-go?

We actually did, the initial implementation (57b119da3594f) was
filtering out everything but then things changed in "only clear controls
which are known to cause issues" (31de3d2500e4). I forgot everything
already but was able to google this suggestion from Paolo:

https://www.lkml.org/lkml/2020/1/22/1108

so finally we've settled on a shortened list. Now as new Windows version
is out, we have new problems to solve)

-- 
Vitaly

