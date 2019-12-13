Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A02F411E55E
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 15:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbfLMONJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 09:13:09 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:40067 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727497AbfLMONJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 09:13:09 -0500
Received: by mail-qk1-f196.google.com with SMTP id c17so1766640qkg.7
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 06:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Nid8tA47CgGN/j7YlqJfGqUykgFGi6RHG/gnONQyj4E=;
        b=iiL3UdjaR/ciA0kSMNs852p8OTlOiquuE5fH159L/f/kyYZSKGWMWVam+pUVGCkXzn
         9bgt3SEbd3pKnEhCeny9C42+mC0KXfiMLBQgpimffHI86crwzaVM/11h7Y8coEKA38o+
         tCVCdPV56qNiZgx3KgERpcRrNrVWUEs+0alaL5KGOlujfPecyMF86opv0mn3yFtlMhi/
         HSFudy4nXLFhq55ZzOCCgbDw0syt6JyzB7F1//hQ+zzHl5IqhR2XQhaFKSX6W7QnskC+
         6wTsaWtttmI+TDa2Sz4IrzVt+oKSBMj5Bnc1BiFbug2PEg9RfDO5OiVAlqxNQb7ozfcK
         /Ebg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nid8tA47CgGN/j7YlqJfGqUykgFGi6RHG/gnONQyj4E=;
        b=Mcv1zLSqKty9d8YsU+zO9wAsiFKqLA423WMZ7a9OgORmLff2FLhncJ1ETJRslmXB+O
         ywX2EnJwbscHQ1pMpa/rXkk0lkNyCl1YVyEQMJma1S4dvjvQ4GzM0zHJoTomElqWnQhH
         2WJWUXUhGlKURSLIYPwMuEnWJbSbJz1jeKAIexqg5aNtYXafR5tCiLbG70IbQ6IsvQ0K
         kuV0KctpjjRvfyuHQZhUueNJmm4snJI4JgsgvwUpwCa1KhGlb9woullorIYtRwaIAh/a
         qGXx5mWXYU4Z08tcnbKb71qXKJQ9B11w+YhwmozV36VQN715rD0r8O31P8vVZfN3ZYSb
         wN3w==
X-Gm-Message-State: APjAAAVzLZTzTBC53HH/3/IP20QLqB7jwU2T59bd9owsevUMg7yT3oPE
        xFyvrWUcgAA5ncPUMMiWqm15Ow==
X-Google-Smtp-Source: APXvYqym2ajF5omuu9eNtqjRTVEFjAXQV+T4/+DYjZkhvWoajaXY+wFuOq6d8uOBMk6PvGM6fJu4eg==
X-Received: by 2002:a05:620a:12ae:: with SMTP id x14mr14203983qki.5.1576246387524;
        Fri, 13 Dec 2019 06:13:07 -0800 (PST)
Received: from [192.168.1.10] (c-66-30-119-151.hsd1.ma.comcast.net. [66.30.119.151])
        by smtp.gmail.com with ESMTPSA id z28sm3463658qtz.69.2019.12.13.06.13.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2019 06:13:06 -0800 (PST)
Subject: Re: [PATCH v5 2/2] kvm: Use huge pages for DAX-backed files
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jason.zeng@intel.com
References: <20191212182238.46535-1-brho@google.com>
 <20191212182238.46535-3-brho@google.com>
 <06108004-1720-41EB-BCAB-BFA8FEBF4772@oracle.com>
 <ED482280-CB47-4AB6-9E7E-EEE7848E0F8B@oracle.com>
 <f8e948ff-6a2a-a6d6-9d8e-92b93003354a@google.com>
 <65FB6CC1-3AD2-4D6F-9481-500BD7037203@oracle.com>
From:   Barret Rhoden <brho@google.com>
Message-ID: <90a9af31-304c-e8d5-b17c-0ddb4c98fddb@google.com>
Date:   Fri, 13 Dec 2019 09:13:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <65FB6CC1-3AD2-4D6F-9481-500BD7037203@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/12/19 8:07 PM, Liran Alon wrote:
>> I was a little hesitant to change the this to handle 1 GB pages with this patchset at first.  I didn't want to break the non-DAX case stuff by doing so.
> 
> Why would it affect non-DAX case?
> Your patch should just make hugepage_adjust() to parse page-tables only in case is_zone_device_page(). Otherwise, page tables shouldn’t be parsed.
> i.e. THP merged pages should still be detected by PageTransCompoundMap().

That's what I already do.  But if I wanted to make the hugepage_adjust() 
function also handle the change to 1 GB, then that code would apply to 
THP too.  I didn't want to do that without knowing the implications for THP.

>> Specifically, can a THP page be 1 GB, and if so, how can you tell?  If you can't tell easily, I could walk the page table for all cases, instead of just zone_device().
> 
> I prefer to walk page-tables only for is_zone_device_page().

Is there another way to tell if a THP page is 1 GB?  Anyway, this is the 
sort of stuff I didn't want to mess around with.

hugepage_adjust() seemed like a reasonable place to get a huge (2MB) 
page table entry out of a DAX mapping.  I didn't want to proliferate 
another special case for upgrading to a larger PTE size (i.e. how 
hugetlbfs and THP have separate mechanisms), so I hopped on to the "can 
we do a 2MB mapping even though host_mapping_level() didn't say so" case 
- which is my interpretation of what huge_adjust() is for.

Barret


