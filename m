Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB7BCAFDD8
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 15:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbfIKNnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 09:43:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726954AbfIKNnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 09:43:02 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DBA2B64047
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 13:43:01 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id f23so618852wmh.9
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 06:43:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uILuaY4Jq2695TWu56J3y6F5NZFuYXplWVAtT0E+8mM=;
        b=e1RUATuc8joaPBCBwpuKhrBNB6JDjPMtGukWmqRc0L3w32AT1AsC3aDafP9lwJzoA7
         HpLeERL8dYjHl2ceFBs6q2bFtClaA14Hg/lHQV+xI40+dOfOcWxq+Zax/AzukifAHSq4
         tsILio9Ny7IkJmO19I/dOeGTz0lUM98rqtxR30RO77+cRUCdK8kkrtAWSGkzZ5nCtJPX
         GAqRxwmVQs9jLtqweqgwqM/KVy08LLX8BivHdbEBf0+YUZiMMchHHYF9fHTD8nzuFLtK
         HmK+qTfW/0ZHY9z9flngQybUuJ5cwRyhV6r/hkj5jFXZRSx9GRKpy30+KhNMAZmpA1gk
         Rcxg==
X-Gm-Message-State: APjAAAXYgWwlYSlP0CEhbvhxbKP2j/FFcICKsfwcV1LlMNKRDBUJTXRj
        +O1ooMG3H3R8zn8Z/Fqyzkw0QIZCC87YxiaSPdZWVP0qpZDtpPtMeaWNXRek84pyetwxy4Gr6ZI
        AcuQe/NcjlXTe
X-Received: by 2002:adf:ed44:: with SMTP id u4mr1233632wro.185.1568209380588;
        Wed, 11 Sep 2019 06:43:00 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyAZ+KEumdgfYnjCjJO4D8hpV64NvblKjguSqcYjEvq4MppVDpgDEgmfRNHbq6e47tqBOYBaQ==
X-Received: by 2002:adf:ed44:: with SMTP id u4mr1233614wro.185.1568209380352;
        Wed, 11 Sep 2019 06:43:00 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id b144sm3131235wmb.3.2019.09.11.06.42.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2019 06:42:59 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Return to userspace with internal error on
 unexpected exit reason
To:     Liran Alon <liran.alon@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Mihai Carabas <mihai.carabas@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
References: <20190826101643.133750-1-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <551194ce-1b35-44af-e797-de7382a4b025@redhat.com>
Date:   Wed, 11 Sep 2019 15:42:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190826101643.133750-1-liran.alon@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/08/19 12:16, Liran Alon wrote:
> Receiving an unexpected exit reason from hardware should be considered
> as a severe bug in KVM. Therefore, instead of just injecting #UD to
> guest and ignore it, exit to userspace on internal error so that
> it could handle it properly (probably by terminating guest).
> 
> In addition, prefer to use vcpu_unimpl() instead of WARN_ONCE()
> as handling unexpected exit reason should be a rare unexpected
> event (that was expected to never happen) and we prefer to print
> a message on it every time it occurs to guest.
> 
> Furthermore, dump VMCS/VMCB to dmesg to assist diagnosing such cases.
> 
> Reviewed-by: Mihai Carabas <mihai.carabas@oracle.com>
> Reviewed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>

Queued, thanks.

Paolo
