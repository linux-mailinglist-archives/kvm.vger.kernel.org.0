Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67FBC1FB221
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 15:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgFPNbu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 09:31:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26698 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726306AbgFPNbu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 09:31:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592314309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u61RpdMscoHeTdORBxhLwpDbzwZOQNb6d43/mYq7rnk=;
        b=Ce3yWHbPMARpOsMommjnr2S+PVFZ5K/lhtv6F5Y9UEVtePts2uk8YpYJ4i8VfqMjaXLVW8
        SiDvn3tDb+HH9YHM4No0cBZ0Nx+D+ciwTJlZ/nmoz30HUUBiB4zlobEvX9z6m/fooXvjzu
        bUYMGTcEWcozumXWvTtcJXyTixXJ8io=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-r58t3GNCO364Ch-cCLWmtw-1; Tue, 16 Jun 2020 09:31:47 -0400
X-MC-Unique: r58t3GNCO364Ch-cCLWmtw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58F20100A620
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 13:31:46 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-121.rdu2.redhat.com [10.10.116.121])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EF64D5D9D3;
        Tue, 16 Jun 2020 13:31:45 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] x86: always set up SMP
To:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20200608160033.392059-1-pbonzini@redhat.com>
 <630b9d53-bac2-378f-aa0a-99f45a0e80d5@redhat.com>
From:   Cathy Avery <cavery@redhat.com>
Message-ID: <a6827d26-d1fc-d2cd-b3b0-f11cc7df30eb@redhat.com>
Date:   Tue, 16 Jun 2020 09:31:44 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <630b9d53-bac2-378f-aa0a-99f45a0e80d5@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/16/20 9:02 AM, Thomas Huth wrote:
> On 08/06/2020 18.00, Paolo Bonzini wrote:
>> Currently setup_vm cannot assume that it can invoke IPIs, and therefore
>> only initializes CR0/CR3/CR4 on the CPU it runs on.  In order to keep the
>> initialization code clean, let's just call smp_init (and therefore
>> setup_idt) unconditionally.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   x86/access.c              | 2 --
>>   x86/apic.c                | 1 -
>>   x86/asyncpf.c             | 1 -
>>   x86/cmpxchg8b.c           | 1 -
>>   x86/cstart.S              | 6 +++---
>>   x86/cstart64.S            | 6 +++---
>>   x86/debug.c               | 1 -
>>   x86/emulator.c            | 1 -
>>   x86/eventinj.c            | 1 -
>   Hi Paolo,
>
> this patch broke the eventinj test on i386 on gitlab:
>
>   https://gitlab.com/huth/kvm-unit-tests/-/jobs/597447047#L1933
>
> if I revert the patch, the test works again:
>
>   https://gitlab.com/huth/kvm-unit-tests/-/jobs/597455720#L1934
>
> Any ideas how to fix that?
>
>   Thanks,
>    Thomas

I am not seeing a failure running eventinj standalone on AMD.

SUMMARY: 13 tests
PASS eventinj (13 tests)

