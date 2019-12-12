Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5120511C13D
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 01:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbfLLAWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 19:22:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40550 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727220AbfLLAWa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 19:22:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576110148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KfDIK/cTZhxbWFyQXhJ/o6g67eom+8/Zr11enJF7XGs=;
        b=XAtAEKil8EIIXyqcC9XjtP6S8LLpxhEKbgDKcEY16rpfmjBzehCL+7mPykrlQ/p7lo/62G
        +vJu9aN8E9tZRr4DrRM5k5ZalWzr6wKmVTi1jIkfFKgq/yCYxbDlS+7bQjOleoo6yHzxhy
        /4Gv+IVg9vo34RWpfuX2PYgnj7FM3FU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-Y0pr2N6KMPix1VByMZ41fg-1; Wed, 11 Dec 2019 19:22:23 -0500
X-MC-Unique: Y0pr2N6KMPix1VByMZ41fg-1
Received: by mail-wr1-f71.google.com with SMTP id i9so309755wru.1
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 16:22:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KfDIK/cTZhxbWFyQXhJ/o6g67eom+8/Zr11enJF7XGs=;
        b=q3WpxdTP0HOCwPqyVtD+AJniOiIZBRTH3ZKDQtLFQ8eJnfRXbsdByAed82AoF43Vhl
         e+PRO+hglQ32wG0swCHmvnwA96MIVfrm0PtqI1eoHDRlMEpe8XQsbdo1eu7mm4gL84aI
         edPiNDl4PUz3f9qZ5SUnEgSRFAJGCeGBQmzbnzmCmU27GI3g2uy4pqHtIvTeibmE3j+L
         i6Ye27id+SPtdzI/jmpUfuUQqsnrjQpzuj7UXiQXaMAjJ3ci+ajDtrtuSnuevFCDwZOL
         Lj2I+xuYsdf8NU97gzz86YPXw5C0KC0UBQ+x5KwTjpE7Zj1IQbKoPht7WpeMOUEM+hWG
         w7uQ==
X-Gm-Message-State: APjAAAVowLU0PDImklmg+m8shb3dCJNkZ8N2X+SGv3fo5v+W/I5U33KW
        4QjBxuAPsZ0Ieefup9VVkqQnUPvbjk8sxEBa7X8AQ7c4IinIKWf603T4ZTFw1x+CHI2F255QOBt
        pw6Dd0H0CBqs7
X-Received: by 2002:a1c:7c11:: with SMTP id x17mr2826037wmc.168.1576110141845;
        Wed, 11 Dec 2019 16:22:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqyHQ9pKCsQmECWYzfqmUaqKH3GIHVXeXl2UOPNAEoUlpehzQP2zvMDzXZHDtpibHFnJA7IUJQ==
X-Received: by 2002:a1c:7c11:: with SMTP id x17mr2826004wmc.168.1576110141556;
        Wed, 11 Dec 2019 16:22:21 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id t12sm4018033wrs.96.2019.12.11.16.22.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 16:22:21 -0800 (PST)
Subject: Re: [PATCH v4 0/2] kvm: Use huge pages for DAX-backed files
To:     Barret Rhoden <brho@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc:     linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jason.zeng@intel.com
References: <20191211213207.215936-1-brho@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <473dbb9d-b2ab-31ba-48ac-3b8216be46de@redhat.com>
Date:   Thu, 12 Dec 2019 01:22:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191211213207.215936-1-brho@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/19 22:32, Barret Rhoden wrote:
> This patchset allows KVM to map huge pages for DAX-backed files.
> 
> I held previous versions in limbo while people were sorting out whether
> or not DAX pages were going to remain PageReserved and how that relates
> to KVM.
> 
> Now that that is sorted out (DAX pages are PageReserved, but they are
> not kvm_is_reserved_pfn(), and DAX pages are considered on a
> case-by-case basis for KVM), I can repost this.
> 
> v3 -> v4:
> v3: https://lore.kernel.org/lkml/20190404202345.133553-1-brho@google.com/
> - Rebased onto linus/master
> 
> v2 -> v3:
> v2: https://lore.kernel.org/lkml/20181114215155.259978-1-brho@google.com/
> - Updated Acks/Reviewed-by
> - Rebased onto linux-next
> 
> v1 -> v2:
> https://lore.kernel.org/lkml/20181109203921.178363-1-brho@google.com/
> - Updated Acks/Reviewed-by
> - Minor touchups
> - Added patch to remove redundant PageReserved() check
> - Rebased onto linux-next
> 
> RFC/discussion thread:
> https://lore.kernel.org/lkml/20181029210716.212159-1-brho@google.com/
> 
> Barret Rhoden (2):
>   mm: make dev_pagemap_mapping_shift() externally visible
>   kvm: Use huge pages for DAX-backed files
> 
>  arch/x86/kvm/mmu/mmu.c | 36 ++++++++++++++++++++++++++++++++----
>  include/linux/mm.h     |  3 +++
>  mm/memory-failure.c    | 38 +++-----------------------------------
>  mm/util.c              | 34 ++++++++++++++++++++++++++++++++++
>  4 files changed, 72 insertions(+), 39 deletions(-)
> 

Thanks, with the Acked-by already in place for patch 1 I can pick this up.

Paolo

