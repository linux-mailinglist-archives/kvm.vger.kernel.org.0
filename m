Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 815B711D6ED
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 20:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730548AbfLLTQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 14:16:37 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:41909 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730512AbfLLTQg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 14:16:36 -0500
Received: by mail-pj1-f66.google.com with SMTP id ca19so1460384pjb.8
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 11:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MNaR/QuknJAHIB0pQcQsq4R3Kk/5rQ+DPsOAQIxnnSw=;
        b=KAaolzVGGhfdtct3LZlhCTEopQdtdhFue5scfWobqwTsj8pWuL8PPQeLqKwSEwDDPT
         RH6zj3ONxLD+ZNNz2rnjB8aOkq+zyRGMUKrwm47RHKOKhZLJjBMEFm+Oprp2T+rETJsj
         u3YQMbP2yvBsoYxCqcj4VtuRXuZgqZI06zy9VGC0ph50IaQHvHUlW6pvuzBQqamMWb/6
         MxKKPVfqkUfpOJKet7l4NXuP1wWltJKpviBeyXO6YQd5nklpHbB09zTViE0KGCvRYD1e
         mgR27tzL277oAJHraSihXtCCjBO3L65OKHZ0vDGDPX7aHDav/w/EBjeVOcSGNbXhWfOg
         tltA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MNaR/QuknJAHIB0pQcQsq4R3Kk/5rQ+DPsOAQIxnnSw=;
        b=ObFKPn0hWuhZhGfw0G2FXpuuToBHMC1kERYCRz1OSkzIazcmxMzGTtXo8pmgJpcz8u
         6KoAUOs8qp48vIQCHSvIL/RPeyMvptgwXd3hYIP3rOisIvdGMgNZCoEV45yJgCvH7ZsA
         4jW7wILq2kwLmqUX5W/eMzGCHGGeZm2xwdq0UXKDLu517AfODjr2RM4f/WoHP+b/323A
         +k7UaMoQhHrehvehkISQjtYgZbcTpAyccHzCyU8Cv7gpA7PF7p+jbAmoxaQsXResHR6P
         DHSMcNTF5DIEaB8vkFVuN8cHTS9eEGqQKUi1M77nFlbLB3dTP+QNXTJNNBWOAW1QVW88
         /kzA==
X-Gm-Message-State: APjAAAWD4VnQhNEoJXbMRzo3TXcpw2GPZQiWYX+JxT87Chb96j6s4IgX
        b9McKF3/SGj44NzoTYJckaVX/A==
X-Google-Smtp-Source: APXvYqx/9O2gkZlxhLDydhoZN8PUSRgnOhN7UqLc/bxYHtv2gdkUDry2PRLvM5QCHRSKPYXaQiMGYg==
X-Received: by 2002:a17:90b:85:: with SMTP id bb5mr11377895pjb.22.1576178195916;
        Thu, 12 Dec 2019 11:16:35 -0800 (PST)
Received: from gnomeregan.cam.corp.google.com ([2620:15c:6:14:ad22:1cbb:d8fa:7d55])
        by smtp.googlemail.com with ESMTPSA id e1sm8314913pfl.98.2019.12.12.11.16.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2019 11:16:35 -0800 (PST)
Subject: Re: [PATCH v4 2/2] kvm: Use huge pages for DAX-backed files
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Zeng, Jason" <jason.zeng@intel.com>
References: <20191211213207.215936-1-brho@google.com>
 <20191211213207.215936-3-brho@google.com>
 <20191212173413.GC3163@linux.intel.com>
 <CAPcyv4hkz8XCETELBaUOjHQf3=VyVB=KWeRVEPYejvdsg3_MWA@mail.gmail.com>
From:   Barret Rhoden <brho@google.com>
Message-ID: <b50720a2-5358-19ea-a45e-a0c0628c68b0@google.com>
Date:   Thu, 12 Dec 2019 14:16:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hkz8XCETELBaUOjHQf3=VyVB=KWeRVEPYejvdsg3_MWA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/12/19 12:37 PM, Dan Williams wrote:
> Yeah, since device-dax is the only path to support longterm page
> pinning for vfio device assignment, testing with device-dax + 1GB
> pages would be a useful sanity check.

What are the issues with fs-dax and page pinning?  Is that limitation 
something that is permanent and unfixable (by me or anyone)?

I'd like to put a lot more in a DAX/pmem region than just a guest's 
memory, and having a mountable filesystem would be extremely convenient.

Thanks,

Barret


