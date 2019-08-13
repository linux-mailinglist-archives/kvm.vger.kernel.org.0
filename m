Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF0F38B36C
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 11:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfHMJLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 05:11:15 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39588 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfHMJLO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 05:11:14 -0400
Received: by mail-wr1-f67.google.com with SMTP id t16so16923318wra.6
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 02:11:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZLfQUKMyIX+ZNqu061niPgB5QJHAS9O4tJDY0/iOqpI=;
        b=lOZXU/zclWmshHdXMM/D2ddmTZKFZri68sKT3eyhLg8iegBo2sgFbvXKDap4ciCgNl
         67KJ9HG1RT9mXe1z+oAQrbMCmINbLEVq0Ujw8FFaDUwo02Drbf0dIcj1zr9VlCWcPoK4
         HM0vKknuuZpPJfH+d4tF05By2YxKPCnxHOsQ8W37hLQtWIomVQQPSe+uQG9D6Ib28ziU
         jDEaCGvX6s9y9lJr6xkDUr+cCiyv1dJZ90yeQ2YvjZh92B7mYR54Ry29b3P9Z+MkoQzt
         UJCPADW78Ho1GocFB2+mtHEtyU5t0LI5h+ptQx3OB0pP4ANUoPd61fEKBfv71YE9c3Gu
         eBgw==
X-Gm-Message-State: APjAAAXE4YhPByql+/4Nznyq9+tsD7N4WdVyjQkp8RSUFpH3P0uBbf1U
        f8mvoA/Dk3ngSMGunzCRVzcRUQ==
X-Google-Smtp-Source: APXvYqy7VmidnHameXLpWAVfWnBv9skdiBmqhQxOPN9tWRfiYQG3zhEjwfDUfIpUfac5Z2c42ezw5A==
X-Received: by 2002:a5d:4f01:: with SMTP id c1mr20624055wru.43.1565687472832;
        Tue, 13 Aug 2019 02:11:12 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id x24sm898079wmh.5.2019.08.13.02.11.11
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 02:11:12 -0700 (PDT)
Subject: Re: [RFC PATCH v6 01/92] kvm: introduce KVMI (VM introspection
 subsystem)
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        virtualization@lists.linux-foundation.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>,
        =?UTF-8?Q?Mircea_C=c3=aerjaliu?= <mcirjaliu@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-2-alazar@bitdefender.com>
 <20190812202030.GB1437@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <81f6c33e-6851-8272-bd8e-7b0bf9ef1ff9@redhat.com>
Date:   Tue, 13 Aug 2019 11:11:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812202030.GB1437@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/08/19 22:20, Sean Christopherson wrote:
> The refcounting approach seems a bit backwards, and AFAICT is driven by
> implementing unhook via a message, which also seems backwards.  I assume
> hook and unhook are relatively rare events and not performance critical,
> so make those the restricted/slow flows, e.g. force userspace to quiesce
> the VM by making unhook() mutually exclusive with every vcpu ioctl() and
> maybe anything that takes kvm->lock. 

The reason for the unhook event, as far as I understand, is because the
introspection appliance can poke int3 into the guest and needs an
opportunity to undo that.

I don't have a big problem with that and the refcounting, at least for
this first iteration---it can be tackled later, once the general event
loop is simplified---however I agree with the other comments that Sean
made.  Fortunately it should not be hard to apply them to the whole
patchset with search and replace on the patches themselves.

Paolo
