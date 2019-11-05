Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB0FEFB9D
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 11:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388513AbfKEKlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 05:41:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46146 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388098AbfKEKlx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 05:41:53 -0500
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3404C83F51
        for <kvm@vger.kernel.org>; Tue,  5 Nov 2019 10:41:53 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id g13so7012178wme.0
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 02:41:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3vylQMkUJh1NXv5AFs3p/CsrpHsIgE1o4KfqJUtKnnU=;
        b=UKiID72Nc/azz7AaH4YiHyG2nQUKzqVg2fa1Zp7v80Ok7qTuXD+Tr9wI44fB5z/iGd
         qozpn5Zlc30IhVv/mVCmEFGIbOt4lcL5GxOMRe6hLpj9P0UlBYsZ2TUfEjUniPrHtDll
         zgix6FgGppODxHRj73Zx1KdpktK8R92NUJTTfXkMUXEFgvYR2+1NQd5io1/yiNI9hquH
         0AJN9yLxgEea90t5XPWDIpvjvkey9Q5eyVF3P+mDh6Udj0tZjg9+CsxPzWKgh/9D4lrK
         BNVwOTf4hh1bPtHoDcDYLkTVzV8dy/qbuqMfJWypjejVqlf7hALifG2LJpeQVEqYnZu2
         flQA==
X-Gm-Message-State: APjAAAW+zcMsen2/JI7zjwtS4a/zgkgZHZYr0HU6+canoXsXIOvTRWQj
        GAZp4DocX1J+66IuCw0aEuKrUjn5/rP4q3eFk+ds4KhjfviKgasA+v/d701o8nCnU+YTPcAaQsE
        n67DgFe/G3hGL
X-Received: by 2002:a5d:5262:: with SMTP id l2mr25986587wrc.113.1572950511841;
        Tue, 05 Nov 2019 02:41:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqxfoLKwc5pAWdk0OCSA0xTHrEjoP5MvmPQspAvCPnkr63IGdyS+ZblecRis4POVc+BNXaFJWQ==
X-Received: by 2002:a5d:5262:: with SMTP id l2mr25986564wrc.113.1572950511557;
        Tue, 05 Nov 2019 02:41:51 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id o18sm22977007wrm.11.2019.11.05.02.41.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 02:41:50 -0800 (PST)
Subject: Re: [PATCH] KVM: X86: Dynamically allocating MSR number
 lists(msrs_to_save[], emulated_msrs[], msr_based_features[])
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20191105092031.8064-1-chenyi.qiang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <8ab7565c-df06-b5a5-d02d-899ba976414b@redhat.com>
Date:   Tue, 5 Nov 2019 11:41:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191105092031.8064-1-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/11/19 10:20, Chenyi Qiang wrote:
> The three msr number lists(msrs_to_save[], emulated_msrs[] and
> msr_based_features[]) are global arrays of kvm.ko, which are
> initialized/adjusted (copy supported MSRs forward to override the
> unsupported MSRs) when installing kvm-{intel,amd}.ko, but it doesn't
> reset these three arrays to their initial value when uninstalling
> kvm-{intel,amd}.ko. Thus, at the next installation, kvm-{intel,amd}.ko
> will initialize the modified arrays with some MSRs lost and some MSRs
> duplicated.
> 
> So allocate and initialize these three MSR number lists dynamically when
> installing kvm-{intel,amd}.ko and free them when uninstalling.

I don't understand.  Do you mean insmod/rmmod when you say
installing/uninstalling? Global data must be reloaded from the ELF file
when insmod is executed.

How is the bug reproducible?

Paolo
