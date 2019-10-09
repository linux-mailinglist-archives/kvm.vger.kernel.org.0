Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9EE2D092A
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 10:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729879AbfJIIHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 04:07:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35374 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729768AbfJIIHs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 04:07:48 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 57B92C028320
        for <kvm@vger.kernel.org>; Wed,  9 Oct 2019 08:07:48 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id p6so182310wmc.3
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 01:07:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z0y/kaqROMSQwixPGrDGFO1uNp0GzEL3EiMZkT03d78=;
        b=Qemqxeswa4vHDmWFjtgneN8BNBkF9S3AZAK5DntGJuy57uKkDXsqrGmvShAObkCqTX
         Vg8o7BzvjdgOPm/lAT/AUz7kLn5uT1LGN6liNBXOBb5x2iE6+owmxod5FJE4XuslNMKF
         AIDsWO1iUxXCULbQ3UJ4otC2OVznKaM0PK9gm9m4gIPQ4Vrk5kigM3y7O1bJF+v6vj1f
         dhgczA1rcrj/yGDkul+v4McxtxMXwqFVXhRmDNl0k7esvTI3BcxSRK+fmUAhv7TMoRsj
         9as75bs7i74o70/0oYYETEwrL0j0yvIxPlFE55PzGmZrXDfr4VAZIbLXX1ZaGvT2bU+D
         vj3A==
X-Gm-Message-State: APjAAAXTbau/TXbtwMQZqmlrj7IB3VgkkZDW5S/9YwpMbY3baiXSrcnP
        4xB9A/2AlGUN8yaWojDUvm3j6hkz+D5cvTBXBHBo543mRfr8/hStbWTVegywuIZYpkO5tdnh+/J
        5iZCEP7J2YuS+
X-Received: by 2002:a05:6000:11c7:: with SMTP id i7mr1777960wrx.231.1570608467043;
        Wed, 09 Oct 2019 01:07:47 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz/eHrg0/wcEpQE6iKLjzqO5LVj8GZku3C/nkYgSAPsWhpBLDl4gU2YAKzvz9fKLln3dIXYBA==
X-Received: by 2002:a05:6000:11c7:: with SMTP id i7mr1777945wrx.231.1570608466817;
        Wed, 09 Oct 2019 01:07:46 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id e15sm1410502wrt.94.2019.10.09.01.07.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 01:07:46 -0700 (PDT)
Subject: Re: [PATCH 0/3] selftests: kvm: improvements to VMX support check
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
References: <20191008194338.24159-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e331c1a7-b102-956c-9f26-170966872ff2@redhat.com>
Date:   Wed, 9 Oct 2019 10:07:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191008194338.24159-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/10/19 21:43, Vitaly Kuznetsov wrote:
> vmx_dirty_log_test fails on AMD and this is no surprise as it is VMX
> specific. Consolidate checks from other VMX tests into a library routine
> and add a check to skip the test when !VMX.
> 
> Vitaly Kuznetsov (3):
>   selftests: kvm: vmx_set_nested_state_test: don't check for VMX support
>     twice
>   selftests: kvm: consolidate VMX support checks
>   selftests: kvm: vmx_dirty_log_test: skip the test when VMX is not
>     supported
> 
>  tools/testing/selftests/kvm/include/x86_64/vmx.h    |  2 ++
>  tools/testing/selftests/kvm/lib/x86_64/vmx.c        | 10 ++++++++++
>  .../kvm/x86_64/vmx_close_while_nested_test.c        |  6 +-----
>  .../selftests/kvm/x86_64/vmx_dirty_log_test.c       |  2 ++
>  .../kvm/x86_64/vmx_set_nested_state_test.c          | 13 ++-----------
>  .../selftests/kvm/x86_64/vmx_tsc_adjust_test.c      |  6 +-----
>  6 files changed, 18 insertions(+), 21 deletions(-)
> 

Queued, thanks.

Paolo
