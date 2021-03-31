Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4921B34FD3A
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 11:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbhCaJlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 05:41:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36125 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234697AbhCaJlL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Mar 2021 05:41:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617183670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=13ETPGXsf76nLgxQSYUcOfnDRwF5dXOwh3DpIOsgydE=;
        b=RI1K6Fssqt7hUlhyzbMKI4QBb13TuCj0sR1qxdT2zpsJX5eEBTwH41nrGg66jFIFLks5cj
        wCA6xSTfgSkES/2Pm4VJzUOZgswA9oFGBYwpb5jxIlH51xia4Lg1awqDbGr1lQIba67LE1
        H3Cr9eOiXaYTJa6fel6vf9JWsjenQoY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-UsKvg8rCOJ2eeY306qGLqg-1; Wed, 31 Mar 2021 05:41:08 -0400
X-MC-Unique: UsKvg8rCOJ2eeY306qGLqg-1
Received: by mail-ej1-f69.google.com with SMTP id di5so547757ejc.1
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 02:41:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=13ETPGXsf76nLgxQSYUcOfnDRwF5dXOwh3DpIOsgydE=;
        b=GtmTYocI0i4DXw2Gk5yw96q8eG+1DWaU1fbInffqw+To/6gW67GvRUmSqhfPN0ljru
         HQWnJHV1494wqcscoEpjh8JKUPJmL4U3fI2L1jBAwC5ATFp6SLWVVsyPOThzWslocO7X
         yvR13W3lPj4SSEEfhR8E0qo36mXr+juUlwA7ZVQx8soCV2MucCUcPqydO+0HukMiCSbH
         zkAokgsHw2fhobSqx6kRYUozevOXUDuZEhNNXPpa8DxE7mQgdH5EqA1cp3dEaqxsFAUn
         UP7Dva1CMaxuE6/FbQqx3UZFhuPbg0a91pyN0Wzw7UPuTghW2XUTgwWlkXi2YFMfEMUI
         /8Xw==
X-Gm-Message-State: AOAM5317VpF+F4k0M+sN8gOQyhm9b32bJknB961ntDOklN5h5JVNdlDm
        eKxVmeA8lh9yI9DON4aVRAokJWUpY7ffNLcOi9wYOZ3+yedDH9unLbL4Xtju5RrUn+5peUfyixD
        AY6NqSFDHYfHY
X-Received: by 2002:a17:906:2bc3:: with SMTP id n3mr2580936ejg.418.1617183667253;
        Wed, 31 Mar 2021 02:41:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSsS0Tsx00ZWZ0/lu50AT1LbGXR9x8m5wdROjQWRD+Wcg6SCBEWtjgSLJ9LavhsubZOMOLAQ==
X-Received: by 2002:a17:906:2bc3:: with SMTP id n3mr2580906ejg.418.1617183667053;
        Wed, 31 Mar 2021 02:41:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id t15sm1151761edc.34.2021.03.31.02.41.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 02:41:05 -0700 (PDT)
Subject: Re: [PATCH 00/18] KVM: Consolidate and optimize MMU notifiers
To:     Marc Zyngier <maz@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <a2ca8cb2-5c91-b971-9b6e-65cf9ee97ffa@redhat.com>
 <e50f6f28c0446cd328e475859ef05dc4@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <569a089e-471f-8182-cdb2-74188f0cc81d@redhat.com>
Date:   Wed, 31 Mar 2021 11:41:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <e50f6f28c0446cd328e475859ef05dc4@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/03/21 11:34, Marc Zyngier wrote:
> 
>> Queued and 1-9 and 18, thanks.  There's a small issue in patch 10 that
>> prevented me from committing 10-15, but they mostly look good.
> 
> Can you please push the resulting merge somewhere?
> 
> I'm concerned that it will conflict in interesting way with other stuff
> that is on its way on the arm64 side, not to mentiobn that this hasn't
> been tested at all on anything but x86 (and given the series was posted
> on Friday, that's a bit of a short notice).

Yes, I will push it shortly to kvm/queue.  Note that the patches I have 
pushed are x86 only apart from changes to tracepoints.  The rest will 
certainly need a lot more baking, which is also why I got rid quickly of 
the easy ones.

Paolo

