Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69A07BEF93
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 12:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbfIZK1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 06:27:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44750 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725787AbfIZK1t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 06:27:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569493667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=Xa/dfJSKTm7j1ZWAmty3bChp2dPXnjKDbYD8f/CYbmY=;
        b=TSZjIhceK+pqX6Oym4i448QOT66TXukmTzePjQXzzYg5XkzEdwjsXQNx2eYnfUzEV+EBjY
        Q90MPLb8pJIFMdpPHbOMkiaD2KY3yZIu4cfxzaXgdoSIrQ9ABNdhgp7mIh4pUhJF8ZhiQB
        itwkaXXwsebShgeHwpGzrOtdMfAlJu0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-tTY9UPq6Pz6HlivU_ScD4g-1; Thu, 26 Sep 2019 06:27:46 -0400
Received: by mail-wr1-f72.google.com with SMTP id t11so739126wrq.19
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 03:27:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XdQ99UTjoh+23t5E4RrOAs0jASBtYy2BAWSyZ2WK8J4=;
        b=C7kLOKRCQKGl1TqopQvQezZ0+GELxKvCdWcs+/HXS3bB0Lky93jshOqHDpSCvkZLCD
         L2MtRod53bENGbpAjXe1c7PNV1i0W+hPyz6MaKfbgUGZ04Ty2hWrRPPGHf/TPVccbOB9
         MJwYLI8GvHXDDjQm6XKr+C92T1Kltzc2JC6i4DNOQoeaJ0lClziJMCFnuNs4ntVCk0bF
         YwrYJouguNWYk45BJgmVE89TfqzY3YUP5WnceMW4UJqh4FOVpegDosa2IQYVU+hZFAGA
         9avLkUtSjhVtmzqRp7gcTTjqVN67BFattEzLVUtrXeFbzfQLpvt37dDv9wg47Dy78nes
         z/BQ==
X-Gm-Message-State: APjAAAXaeHT3MrDQQUa57s9nCDUM/dd9qXWgCbOMRwIwdXiPQGW1bIkV
        GWewMGyrTMfl7N7z51sOTNvqebskaRWQpXChoO4EyNyKI7skEE+YPtDAxQyd2Kfh092u/SFUv3e
        HFjb/wQlTm5Kf
X-Received: by 2002:adf:f343:: with SMTP id e3mr2334482wrp.268.1569493665504;
        Thu, 26 Sep 2019 03:27:45 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwQsTf5KVHNqaAp14gMBi/WQ2TachZwFLYkYISMluIs9bNjR8pE41xCdpGWRsvQbWiiIiTafg==
X-Received: by 2002:adf:f343:: with SMTP id e3mr2334469wrp.268.1569493665250;
        Thu, 26 Sep 2019 03:27:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id q19sm3749943wra.89.2019.09.26.03.27.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 03:27:44 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: Fix a spurious -E2BIG in __do_cpuid_func
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Peter Shier <pshier@google.com>
References: <20190925181714.176229-1-jmattson@google.com>
 <20190925223334.GP31852@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <33d0c488-8fa6-e593-24f5-480a79677fc2@redhat.com>
Date:   Thu, 26 Sep 2019 12:27:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190925223334.GP31852@linux.intel.com>
Content-Language: en-US
X-MC-Unique: tTY9UPq6Pz6HlivU_ScD4g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/09/19 00:33, Sean Christopherson wrote:
> On Wed, Sep 25, 2019 at 11:17:14AM -0700, Jim Mattson wrote:
>> Don't return -E2BIG from __do_cpuid_func when processing function 0BH
>> or 1FH and the last interesting subleaf occupies the last allocated
>> entry in the result array.
>>
>> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Fixes: 831bf664e9c1fc ("KVM: Refactor and simplify kvm_dev_ioctl_get_sup=
ported_cpuid")
>> Signed-off-by: Jim Mattson <jmattson@google.com>
>> Reviewed-by: Peter Shier <pshier@google.com>
>> ---
>=20
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
>=20

Queued, thanks.

Paolo

