Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBB78D091F
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 10:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbfJIIGX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 04:06:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53218 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfJIIGX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 04:06:23 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 23EFD3D966
        for <kvm@vger.kernel.org>; Wed,  9 Oct 2019 08:06:23 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id v17so722321wru.12
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 01:06:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q74ha9OdyhPm3qJhgJ85+EZI2hqHBo4gZcVQeqH6MgU=;
        b=GScFrekXn3Cxk2Q+/P4NJYwG5VWMoWpitr9+kj/fPS/aoaPsVtSrTDvkGjfIDG9jxF
         MaWLdvlCWxQHztPxaVU0aWX38PWTgZJzDbqq5jc9jZfw/TbN/LPWhnLUP/5RyCitvME4
         NF1l7l0TVQ8JPiKtBuiSIobUZY5dlQ9AMpcWScCvLTbVGZLkvG1vcxFpT2xRUbgb+NPZ
         mSNs/xYY3B1JDAEkePHQV0TNZhrEDWQHKnMA/BNAMo75nNE2ENezH15GbH97qlSx5ysE
         cmNwlySxIHX5LSemirtTc/vCd2nIHRuGwTTDMiGcIyud8bcar5VEof0RDjSykqx8lLMB
         ND3g==
X-Gm-Message-State: APjAAAWyPjwr6fT4FdiFQXjo4nW9vOkFzGlOAA6iTPjdOyTtTa59ExwF
        wYiIXkV00KmgfHQy7XhPzGd/D6u9xerbYdhrX46S+QNUk4JDOQa9cKvHcuYPU+Ds/xTsiz9sOwn
        RBY/h0PZZMzzr
X-Received: by 2002:adf:ef0f:: with SMTP id e15mr1837661wro.385.1570608381751;
        Wed, 09 Oct 2019 01:06:21 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzURMAJ7vAXRdu3FKhkm40vp+KgdXTuqatIpx9qvS0DnbB4Qk3LeYwCpkEIQLwlwh+bStTdQQ==
X-Received: by 2002:adf:ef0f:: with SMTP id e15mr1837629wro.385.1570608381497;
        Wed, 09 Oct 2019 01:06:21 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id b7sm1446184wrx.56.2019.10.09.01.06.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 01:06:20 -0700 (PDT)
Subject: Re: [PATCH v5 1/2] x86/cpu: Add support for UMONITOR/UMWAIT/TPAUSE
To:     Tao Xu <tao3.xu@intel.com>, rth@twiddle.net, ehabkost@redhat.com,
        mtosatti@redhat.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, jingqi.liu@intel.com
References: <20190929015718.19562-1-tao3.xu@intel.com>
 <20190929015718.19562-2-tao3.xu@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <6762960d-80a6-be31-399d-f62e33b31f28@redhat.com>
Date:   Wed, 9 Oct 2019 10:06:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190929015718.19562-2-tao3.xu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/09/19 03:57, Tao Xu wrote:
> +    } else if (function == 7 && index == 0 && reg == R_ECX) {
> +        if (enable_cpu_pm) {
> +            ret |= CPUID_7_0_ECX_WAITPKG;

This is incorrect.  You should disable WAITPKG if !enable_cpu_pm, but
you should not enable it forcefully if enable_cpu_pm is true.

Paolo

> +        } else {
> +            ret &= ~CPUID_7_0_ECX_WAITPKG;
> +        }

