Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD492F5CB6
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 09:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbhANI6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 03:58:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48972 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726742AbhANI6J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 03:58:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610614603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5mIiTKZ0bfdwT4qAJDHJUFiHYjyZoxrSZVhHEnOGK0k=;
        b=RgMMlFB12rgTatAK+ZF2lL5yVKHCZvAKPQpx/QrZv080SuO+Y4eGG4I+YRK2VT0z/7Mz1d
        jkusICgFRdfAceB1jSJ3S2V2wAIjrfizOfgCBmlo3d2OjO57otxbv2XkcHGswe5tMDL6FW
        /GAAM3wt2e7qeUuVaDVKg5mfZQ6Nz8o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-ydnULg91ODGgpsJD_s2gLA-1; Thu, 14 Jan 2021 03:54:11 -0500
X-MC-Unique: ydnULg91ODGgpsJD_s2gLA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB2571572A;
        Thu, 14 Jan 2021 08:54:09 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-108.ams2.redhat.com [10.36.112.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E88A077715;
        Thu, 14 Jan 2021 08:54:04 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v4 4/9] s390x: Split assembly into multiple
 files
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20210112132054.49756-1-frankja@linux.ibm.com>
 <20210112132054.49756-5-frankja@linux.ibm.com>
 <c07280f6-f56c-ea6c-1255-28a36a2385c0@redhat.com>
 <fce05f26-8cdb-009d-a88d-c799c3784506@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <46f771fa-f1a2-825e-8cd0-d9a81d1b1d73@redhat.com>
Date:   Thu, 14 Jan 2021 09:54:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <fce05f26-8cdb-009d-a88d-c799c3784506@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/01/2021 13.15, Janosch Frank wrote:
> On 1/13/21 1:04 PM, Thomas Huth wrote:
>> On 12/01/2021 14.20, Janosch Frank wrote:
>>> I've added too much to cstart64.S which is not start related
>>> already. Now that I want to add even more code it's time to split
>>> cstart64.S. lib.S has functions that are used in tests. macros.S
>>> contains macros which are used in cstart64.S and lib.S
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> ---
>>>    s390x/Makefile   |   6 +--
>>>    s390x/cstart64.S | 119 ++---------------------------------------------
>>>    s390x/lib.S      |  65 ++++++++++++++++++++++++++
>>
>> lib.S is a very generic name ... maybe rather use cpuasm.S or something similar?
> 
> instr.S ?

Hmm, no, if I read something like that, I'd expect wrapper functions for 
single instructions, which is not what we have here.

Looking at the two functions, both are related to CPU stuff (reset and 
state), so something with "cpu" in the name would be best, I think. Maybe 
just cpu.S ?

Or if you intend to add non-CPU related stuff here later, maybe something 
like misc.S ?

> Or maybe entry.S to make it similar to the kernel?

No, entry.S sounds like a startup code, which we already have in cstart64.S, 
so I'd rather avoid that name.

  Thomas

