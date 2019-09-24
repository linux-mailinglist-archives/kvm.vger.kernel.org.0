Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8F03BC964
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 15:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409672AbfIXNzn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 09:55:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57062 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409667AbfIXNzm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 09:55:42 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4797F3DFD7
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 13:55:42 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id r187so966188wme.0
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 06:55:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OsafvY49lv+IdkcQBZiY+1pyMhsITwm284eCfBsvG3Q=;
        b=deguM7uu+8NBq9+WfcCBfoABwpGuYVE1RbS63kZQPsKQ7LK3NAWoEeX9VrOb1npTPP
         5QCqlnZwp0hoHN7SsiOd551lTSfgy5GsyNKo2AR8KpHBf1GZjOnDS4A7G5Yj1XL1MJ/R
         DNcQSd/m9K18c8xbo+xkm6fh/2QXYyTUh7mxMKn/2/OKV6WdTX5D4rxagSL08yvNwUA/
         gcTyHnW7VLp8MTCcXeBHZhHW38OMeykPHpvcceO4qAnvKRCd79jTfYUMsIX0jI4Unwup
         AH3e7W6A6QGLVjE6HrIUZwVh6oDHwqDMpSJKXj3MHpPJiFn4cLs/FI0IIjULWojDmK+t
         pBCA==
X-Gm-Message-State: APjAAAUcXXodS8IP18DP8DJHosdj8kdkx1KTGtKj5AVcpxNI4kQuhTuI
        6ShFO/ZGqdfW7Fp5f2E99HzvuyaEmw7SJqEHc05HJHZCWzhBB67KQTVFMJI/EJ/as/P34md1SYT
        yRV0rKv6H+FOQ
X-Received: by 2002:a05:6000:12:: with SMTP id h18mr2412462wrx.156.1569333340904;
        Tue, 24 Sep 2019 06:55:40 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwg4Zkq5DqRbVkfGA29BmZtf2KR4d9hVorp2wEdWQ5fXNb3WiB0tDW4Xw1GTkf7h7ZkJFH54w==
X-Received: by 2002:a05:6000:12:: with SMTP id h18mr2412442wrx.156.1569333340651;
        Tue, 24 Sep 2019 06:55:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id s1sm4225070wrg.80.2019.09.24.06.55.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2019 06:55:39 -0700 (PDT)
Subject: Re: [PATCH v2 2/3] KVM: X86: Fix userspace set broken combinations of
 CPUID and CR4
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org
References: <1568708186-20260-1-git-send-email-wanpengli@tencent.com>
 <1568708186-20260-2-git-send-email-wanpengli@tencent.com>
 <20190917173258.GB2876@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d0c35f21-b262-2c4e-9109-4ab803487705@redhat.com>
Date:   Tue, 24 Sep 2019 15:55:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190917173258.GB2876@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/09/19 19:32, Sean Christopherson wrote:
> 
> Paolo, can you provide an "official" ruling on how KVM_SET_SREGS should
> interact with reserved bits?  It's not at all clear from the git history
> if skipping the checks was intentional or an oversight.

It's okay to make it fail as long as KVM already checks the value of the
reserved bits on vmexit.  If not, some care might be required.

Paolo
