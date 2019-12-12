Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C05DF11D30F
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 18:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730022AbfLLRDl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 12:03:41 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:45265 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbfLLRDk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 12:03:40 -0500
Received: by mail-qv1-f68.google.com with SMTP id c2so1213906qvp.12
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 09:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BFu2QWawMDo8B85b8x7NXC6lIZ2Hbdt7KAZDH/cd0Mw=;
        b=uJQ81efnMOHOq6dmsBK8drxQnWrVDOdv8wGOOqXsdXxN7MhmstzRl6qMKoIgIuASAY
         lEMPd/dfy/crfpO/6N/VYadcmKGFrnXX4+mmXiFkiUzG5PU/Xej146ZJHj/dEykZgxvy
         O+736S4rCVpZL8qO9PDMpS7ySgMAdKBw9pj7/tzKtk7CI7RTtduMaLcqZk07DY8+moZF
         bhUxoQO5G3JypRZzuwZiBUVL1eXd8sas3jVkAS5Wsw+g0QVTow0WeUF7SMo0GvEb1yGN
         kTpPj0oqoIC97Z/MBaZkh6bNy1JKFpcUqpZ4ZUFKziv0r5L1pZe+Jr9MM94NAGfLXcIO
         wA3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BFu2QWawMDo8B85b8x7NXC6lIZ2Hbdt7KAZDH/cd0Mw=;
        b=QKN3LDwu8LPe8Bad5Z8X4D9OYBW3PXkIdgMkQY2Nas4+Aglh3Gg13QLc+9QGlgf8rF
         HyG+3SYrFji1Ts3VNpgHWMDTaPhWcMDLZRinxtsSPdG+BUX6G4DDjYLDPacMR1wgJg69
         LF6GFyFs15jXyaE9SqJ4dSoeikG45BAxNHchTKSzD7yUsWdlXiYr1JHy0NToLd9294YZ
         eSBbopSM7iW6J/lKOWn5+R1tf4v5vrMdfsy8R0E0FmE5KNVMH/T7mgL8D2RHAoVwz0kz
         OAvqpSxiBQt3JUOyaFVr332CnVxou7Z27+HvZLnhTHfeuopZZ3tewLpMmZPtaakVHspD
         3eNw==
X-Gm-Message-State: APjAAAXARt1qkhuTziHucNPIn+SrEI3bU94lHyS5c5aIwcGB/Jc/oXR2
        GoN5G82BiSyhrLFP7IxWW3yGxw==
X-Google-Smtp-Source: APXvYqyixXbMscj+Nh5/8lf0UVe2+f6RVkD6z054yrZ1R+8RY56Ujz8IweJ8MUL8w3BnzkuS2BNpnA==
X-Received: by 2002:ad4:580b:: with SMTP id dd11mr9025509qvb.242.1576170219393;
        Thu, 12 Dec 2019 09:03:39 -0800 (PST)
Received: from ?IPv6:2620:0:1004:a:6e2b:60f7:b51b:3b04? ([2620:0:1004:a:6e2b:60f7:b51b:3b04])
        by smtp.gmail.com with ESMTPSA id b7sm1906173qkh.106.2019.12.12.09.03.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2019 09:03:38 -0800 (PST)
Subject: Re: [PATCH v4 2/2] kvm: Use huge pages for DAX-backed files
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jason.zeng@intel.com
References: <20191211213207.215936-1-brho@google.com>
 <20191211213207.215936-3-brho@google.com>
 <376DB19A-4EF1-42BF-A73C-741558E397D4@oracle.com>
From:   Barret Rhoden <brho@google.com>
Message-ID: <ce8fa354-4530-2a01-6ccc-3cffd0692547@google.com>
Date:   Thu, 12 Dec 2019 12:03:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <376DB19A-4EF1-42BF-A73C-741558E397D4@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/12/19 7:33 AM, Liran Alon wrote:
>> +	/*
>> +	 * Our caller grabbed the KVM mmu_lock with a successful
>> +	 * mmu_notifier_retry, so we're safe to walk the page table.
>> +	 */
>> +	switch (dev_pagemap_mapping_shift(hva, current->mm)) {
> Doesn’t dev_pagemap_mapping_shift() get “struct page” as first parameter?
> Was this changed by a commit I missed?

I changed this in Patch 1.  The place I call it in KVM has the address 
and mm available, which is the only think dev_pagemap_mapping_shift() 
really needs.  (The first thing it did was convert page to address).

I'll add some more text to patch 1's commit message about that.

Thanks,

Barret


