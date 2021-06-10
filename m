Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7333A2CD6
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 15:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhFJNZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 09:25:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44379 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230035AbhFJNZ2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 09:25:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623331412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=88ww2xQY0H+0+XkZE9y7YZG1xhuZT7Zms2aalO6pzRo=;
        b=dN/SKWoOMtsPnwSsqg61lvd5Pjqpc2bKrciIu9DNRD7PxgmdSnea/NJht8BX7ikzN70d3L
        V4gTBD6YnptLwiLitinPROxd+Bcwdc31IuNvrwhfZMx2aj3RKMdRJKocgidqs8FQJaVo95
        oXZnxq+cFNV5vZj0Oq3baslnSUSg3Us=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-bR_FwCu_MxePc3mMe2BA8Q-1; Thu, 10 Jun 2021 09:23:30 -0400
X-MC-Unique: bR_FwCu_MxePc3mMe2BA8Q-1
Received: by mail-wr1-f69.google.com with SMTP id k25-20020a5d52590000b0290114dee5b660so888175wrc.16
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 06:23:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=88ww2xQY0H+0+XkZE9y7YZG1xhuZT7Zms2aalO6pzRo=;
        b=Ux3jy79y18Zalsx56HlqyG47hspU1K+DUjsYyAMuVt1ovPmcR27D2AjWvSnsvrlkJ9
         5OCYiQ5KX1XGnvWUX+MjIfcpWbFzfkj5d8u47GxvE1zzV5g9TRqrQ4x9FETR6+Udf8we
         pVo9bB5L5aYyiYdjWF1EeHmCPADHp2c/hL0LzbxOZm64xtHeBpsdvjH9hiqlPJFhb1kJ
         3UeqreldbXUqVIL9/O/tSEsJpRHYgkE7rj9nilimTYrx7AVznLumfZPqoN8jBtlpg7/H
         10W9I/GPy/M+Z0C0kjzUnA2Dq1GaQEqPclEfdFFGYPa8XuRYPhH7EUmzoH9OxmHfHs3v
         qGjA==
X-Gm-Message-State: AOAM532Lz7X+fZ6OvOisUQsAPOcsjaWKwyV4zB0VwE2QzZhE0GO+f16H
        0bmVkTMrwKxAkRyN9IcVclcA5lYK1dclN51+zjrW5x1PR7hHA/tC3xoFzAlaDuVr5Le7ZqW1QAl
        wcHE/jeLQRH0n
X-Received: by 2002:a05:600c:350a:: with SMTP id h10mr5114452wmq.164.1623331409572;
        Thu, 10 Jun 2021 06:23:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw79lNKYMmKsJc+6kNvOS13CVwEmBkp0QyLoPEBLj7gbej3FcuzIUPP6197YkoOsIew2kREgw==
X-Received: by 2002:a05:600c:350a:: with SMTP id h10mr5114437wmq.164.1623331409407;
        Thu, 10 Jun 2021 06:23:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id o3sm4347353wrc.0.2021.06.10.06.23.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 06:23:28 -0700 (PDT)
Subject: Re: [PATCH 2/9] KVM: x86: Emulate triple fault shutdown if RSM
 emulation fails
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+fb0b6a7e8713aeb0319c@syzkaller.appspotmail.com
References: <20210609185619.992058-1-seanjc@google.com>
 <20210609185619.992058-3-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <520185e2-fe95-6ab6-163c-a46bfaa1f5d5@redhat.com>
Date:   Thu, 10 Jun 2021 15:23:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609185619.992058-3-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/21 20:56, Sean Christopherson wrote:
> For recent Intel CPUs, restoring NMI blocking is technically wrong, but
> so is restoring NMI blocking in the first place, and Intel's RSM
> "architecture" is such a mess that just about anything is allowed and can
> be justified as micro-architectural behavior.

The Intel manual is an absolute mess with respect to NMI blocking, and 
for once AMD followed suit.

Some versions of the AMD BIOS and Kernel Developer Manual provide the 
offset of the "NMI masked" flag in the SMM state save area, but 
unfortunately that was discovered too late.

Paolo

