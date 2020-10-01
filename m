Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232F327FDB1
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 12:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732116AbgJAKuz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 06:50:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49522 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731131AbgJAKuy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 06:50:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601549453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QjFX6e9cghTx7DqhRBG3J6jv+MSt+PanN5FRPWF2tkg=;
        b=aLwRh/dG9KA2x9Mvc4pzsSM7qI8hoJigGEjpW27oayGAGq+U9wSMi6oHLKOLyBu/zlpCuT
        L9H7GmtqyXAQSqJ0wzATcuVC4K0n6wmWPaMxlBM5ZHETcUFMy6xb7zzruDt3jfne8IOgEn
        JipWt+vog5YFs6u4CvW/IyhOJ9R3VYg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-GylfmTUBOmuS5bdSke_o2g-1; Thu, 01 Oct 2020 06:50:51 -0400
X-MC-Unique: GylfmTUBOmuS5bdSke_o2g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB0C2186DD27
        for <kvm@vger.kernel.org>; Thu,  1 Oct 2020 10:50:50 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CED8C100238C;
        Thu,  1 Oct 2020 10:50:49 +0000 (UTC)
Subject: Re: [PATCH v2 5/7] arm/pmu: Fix inline assembly for Clang
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, lvivier@redhat.com
References: <20201001072234.143703-1-thuth@redhat.com>
 <20201001072234.143703-6-thuth@redhat.com>
 <20201001091239.cfuazqd6ear726pd@kamzik.brq.redhat.com>
 <20201001091435.vhpkrogomzqmihpm@kamzik.brq.redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <331cdf48-d406-1a86-f929-c18f102f339c@redhat.com>
Date:   Thu, 1 Oct 2020 12:50:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20201001091435.vhpkrogomzqmihpm@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/10/2020 11.14, Andrew Jones wrote:
> On Thu, Oct 01, 2020 at 11:12:43AM +0200, Andrew Jones wrote:
>> On Thu, Oct 01, 2020 at 09:22:32AM +0200, Thomas Huth wrote:
>>> Clang complains here:
>>>
>>> arm/pmu.c:201:16: error: value size does not match register size specified by
>>>  the constraint and modifier [-Werror,-Wasm-operand-widths]
>>>         : [pmcr] "r" (pmcr)
>>>                       ^
>>> arm/pmu.c:194:18: note: use constraint modifier "w"
>>>         "       msr     pmcr_el0, %[pmcr]\n"
>>>                                   ^~~~~~~
>>>                                   %w[pmcr]
>>> arm/pmu.c:200:17: error: value size does not match register size specified by
>>>  the constraint and modifier [-Werror,-Wasm-operand-widths]
>>>         : [loop] "+r" (loop)
>>>                        ^
>>> arm/pmu.c:196:11: note: use constraint modifier "w"
>>>         "1:     subs    %[loop], %[loop], #1\n"
>>>                         ^~~~~~~
>>>                         %w[loop]
>>> arm/pmu.c:200:17: error: value size does not match register size specified by
>>>  the constraint and modifier [-Werror,-Wasm-operand-widths]
>>>         : [loop] "+r" (loop)
>>>                        ^
>>> arm/pmu.c:196:20: note: use constraint modifier "w"
>>>         "1:     subs    %[loop], %[loop], #1\n"
>>>                                  ^~~~~~~
>>>                                  %w[loop]
>>> arm/pmu.c:284:35: error: value size does not match register size specified
>>>  by the constraint and modifier [-Werror,-Wasm-operand-widths]
>>>         : [addr] "r" (addr), [pmcr] "r" (pmcr), [loop] "r" (loop)
>>>                                          ^
>>> arm/pmu.c:274:28: note: use constraint modifier "w"
>>>         "       msr     pmcr_el0, %[pmcr]\n"
>>>                                   ^~~~~~~
>>>                                   %w[pmcr]
>>> arm/pmu.c:284:54: error: value size does not match register size specified
>>>  by the constraint and modifier [-Werror,-Wasm-operand-widths]
>>>         : [addr] "r" (addr), [pmcr] "r" (pmcr), [loop] "r" (loop)
>>>                                                             ^
>>> arm/pmu.c:276:23: note: use constraint modifier "w"
>>>         "       mov     x10, %[loop]\n"
>>>                              ^~~~~~~
>>>                              %w[loop]
>>>
>>> pmcr should be 64-bit since it is a sysreg, but for loop we can use the
>>> "w" modifier.
>>>
>>> Suggested-by: Drew Jones <drjones@redhat.com>
> 
> Not a huge deal, but I use my official first name 'Andrew' on my tags.
> I know, I like confusing people by flipping back and forth between
> Andrew and Drew...

Sorry, IIRC I simply copy-n-pasted your name and e-mail address from the
MAINTAINERS file ... maybe you should fix it there to avoid such situations?

 Thomas

