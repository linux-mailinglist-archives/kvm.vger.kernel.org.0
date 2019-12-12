Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54E0511D7B1
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 21:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730785AbfLLUIJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 15:08:09 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37023 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730748AbfLLUII (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 15:08:08 -0500
Received: by mail-pg1-f196.google.com with SMTP id q127so103019pga.4
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 12:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aJrWupuoqlaE+s8IR7dca1FQsV4mMbu8eS/d2O5egGs=;
        b=nAuBzaZ+M+jU9nrAWBIdAEOhgQaiL9q7FlV99s2L52qnyjGadAJ83ru2N1aLv4ymbI
         iVLz0nc9/aARTcufEm2u3ijh7pYZzCvqEVP4PMX5VTo71rUNDqyrRTjpiaixcRgds8I9
         VRkPInO7qAnHDfzLkFgt44gmER5AcTNO0w/gs/WBjtpQDhnllAIylznHTIlsopMn6df3
         auMaJiKcjyOeJk97/R6Xh6LncbaErvwiexu1ld6WqzUD/trx9J7mZP0Q5u4CT1I45snZ
         eVbXTPSXqOjg5grHcF9/d3UlX2UXs8/IjIF+hAGoyc8irYKiKTb7iAexn4HQ7NifbTCY
         xalQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aJrWupuoqlaE+s8IR7dca1FQsV4mMbu8eS/d2O5egGs=;
        b=SX8hVvB+1ql50KeewHpHmbVlSIR/3ex5v+nYxkiMoLQPZjNgXmTsGLGNO+X5ZG2A8I
         LJChlKGByoL+W5pH8aaZd25S0kctUVcS8frK9zWH/2Jo18Rf038MXXjpRIB/e4tZ1Jio
         XGKbd+Yw0eXcwxqg3UiVf0GFRvfnPXwa7YaTs6hlLyrXmXnyoVlpEUaRYRSmV65c6ED2
         KAoR1Nsrtu4UZ7b3Nl3NDR/nOjMXh37Tzxi4o7kDrsKNRnDja6cnmBDCxbONtd/iLoGU
         ngJ2Phtr+0XE9pLO4eB2Daw4IfUYygTwts/ZuHhFE9d1yte1nYHoMHncaRBm0W31Rs3E
         YdIA==
X-Gm-Message-State: APjAAAWU65Mru2piX9bHyQyqo6trA90uewJJJcYPIeGfU4FXPfQdTOZA
        ADkftOkKRFsUPVQSlgJTVUm2Eg==
X-Google-Smtp-Source: APXvYqzwcu39VfGPwDpwrOKuS2wqc4pCHbQDMsKrEcbai6c25uGI5sp3lG7XYlmkvLROu8NJdfy3sQ==
X-Received: by 2002:a63:e17:: with SMTP id d23mr12668781pgl.173.1576181287757;
        Thu, 12 Dec 2019 12:08:07 -0800 (PST)
Received: from gnomeregan.cam.corp.google.com ([2620:15c:6:14:ad22:1cbb:d8fa:7d55])
        by smtp.googlemail.com with ESMTPSA id g19sm8087571pfh.134.2019.12.12.12.08.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2019 12:08:07 -0800 (PST)
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
        "Zeng, Jason" <jason.zeng@intel.com>,
        Christoph Hellwig <hch@lst.de>
References: <20191211213207.215936-1-brho@google.com>
 <20191211213207.215936-3-brho@google.com>
 <20191212173413.GC3163@linux.intel.com>
 <CAPcyv4hkz8XCETELBaUOjHQf3=VyVB=KWeRVEPYejvdsg3_MWA@mail.gmail.com>
 <b50720a2-5358-19ea-a45e-a0c0628c68b0@google.com>
 <CAPcyv4h19dKGpz0XzEHz0nOddnRAefE=rOuhGTHEL6FPhqk8GQ@mail.gmail.com>
From:   Barret Rhoden <brho@google.com>
Message-ID: <7e3d9ac4-5577-c8a3-a23c-655266376101@google.com>
Date:   Thu, 12 Dec 2019 15:08:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAPcyv4h19dKGpz0XzEHz0nOddnRAefE=rOuhGTHEL6FPhqk8GQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/12/19 2:48 PM, Dan Williams wrote:
> On Thu, Dec 12, 2019 at 11:16 AM Barret Rhoden <brho@google.com> wrote:
>>
>> On 12/12/19 12:37 PM, Dan Williams wrote:
>>> Yeah, since device-dax is the only path to support longterm page
>>> pinning for vfio device assignment, testing with device-dax + 1GB
>>> pages would be a useful sanity check.
>>
>> What are the issues with fs-dax and page pinning?  Is that limitation
>> something that is permanent and unfixable (by me or anyone)?
> 
> It's a surprisingly painful point of contention...

Thanks for the info; I'll check out those threads.

[snip]

>> I'd like to put a lot more in a DAX/pmem region than just a guest's
>> memory, and having a mountable filesystem would be extremely convenient.
> 
> Why would page pinning be involved in allowing the guest to mount a
> filesystem on guest-pmem? That already works today, it's just the
> device-passthrough that causes guest memory to be pinned indefinitely.

I'd like to mount the pmem filesystem on the *host* and use its files 
for the guest's memory.  So far I've just been making an ext4 FS on 
/dev/pmem0 and creating a bunch of files in the FS.  Some of the files 
are the guest memory: one file for each VM.  Other files are just 
metadata that the host uses.

That all works right now, but I'd also like to use VFIO with the guests.

Thanks,

Barret




