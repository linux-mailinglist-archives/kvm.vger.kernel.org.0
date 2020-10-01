Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDE127FEBF
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 14:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731926AbgJAMDN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 08:03:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25930 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731670AbgJAMDN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 08:03:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601553791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=smb2PNf8Ga+Tor67zpM7vfwNtCnWzdEItAJpAqUFNd4=;
        b=HNMSH5wBT7T90YtL3X92QRhlbFcPEuuV1KFJsMPbXlFg1aKFmins5/H+dBwSQ7JlqWqAM3
        TUw0UVMPi04XHtPvLe+pCpkEtoWBh3jhhAN5/qeptJhJN3b75EAu8gb5IvhZoMUArXyiFy
        30o69XfUR3U74NY3fFl1vK8i+NgFUiU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-kU_bOL4ENFmRdD49987vuA-1; Thu, 01 Oct 2020 08:03:08 -0400
X-MC-Unique: kU_bOL4ENFmRdD49987vuA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E60984E218
        for <kvm@vger.kernel.org>; Thu,  1 Oct 2020 12:03:08 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.100])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C67007D51F;
        Thu,  1 Oct 2020 12:02:44 +0000 (UTC)
Date:   Thu, 1 Oct 2020 14:02:42 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, lvivier@redhat.com
Subject: Re: [PATCH v2 5/7] arm/pmu: Fix inline assembly for Clang
Message-ID: <20201001120242.ywmlfn3t6d277j4x@kamzik.brq.redhat.com>
References: <20201001072234.143703-1-thuth@redhat.com>
 <20201001072234.143703-6-thuth@redhat.com>
 <20201001091239.cfuazqd6ear726pd@kamzik.brq.redhat.com>
 <20201001091435.vhpkrogomzqmihpm@kamzik.brq.redhat.com>
 <331cdf48-d406-1a86-f929-c18f102f339c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <331cdf48-d406-1a86-f929-c18f102f339c@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 01, 2020 at 12:50:48PM +0200, Thomas Huth wrote:
> On 01/10/2020 11.14, Andrew Jones wrote:
> > On Thu, Oct 01, 2020 at 11:12:43AM +0200, Andrew Jones wrote:
> >> On Thu, Oct 01, 2020 at 09:22:32AM +0200, Thomas Huth wrote:
> >>> Clang complains here:
> >>>
> >>> arm/pmu.c:201:16: error: value size does not match register size specified by
> >>>  the constraint and modifier [-Werror,-Wasm-operand-widths]
> >>>         : [pmcr] "r" (pmcr)
> >>>                       ^
> >>> arm/pmu.c:194:18: note: use constraint modifier "w"
> >>>         "       msr     pmcr_el0, %[pmcr]\n"
> >>>                                   ^~~~~~~
> >>>                                   %w[pmcr]
> >>> arm/pmu.c:200:17: error: value size does not match register size specified by
> >>>  the constraint and modifier [-Werror,-Wasm-operand-widths]
> >>>         : [loop] "+r" (loop)
> >>>                        ^
> >>> arm/pmu.c:196:11: note: use constraint modifier "w"
> >>>         "1:     subs    %[loop], %[loop], #1\n"
> >>>                         ^~~~~~~
> >>>                         %w[loop]
> >>> arm/pmu.c:200:17: error: value size does not match register size specified by
> >>>  the constraint and modifier [-Werror,-Wasm-operand-widths]
> >>>         : [loop] "+r" (loop)
> >>>                        ^
> >>> arm/pmu.c:196:20: note: use constraint modifier "w"
> >>>         "1:     subs    %[loop], %[loop], #1\n"
> >>>                                  ^~~~~~~
> >>>                                  %w[loop]
> >>> arm/pmu.c:284:35: error: value size does not match register size specified
> >>>  by the constraint and modifier [-Werror,-Wasm-operand-widths]
> >>>         : [addr] "r" (addr), [pmcr] "r" (pmcr), [loop] "r" (loop)
> >>>                                          ^
> >>> arm/pmu.c:274:28: note: use constraint modifier "w"
> >>>         "       msr     pmcr_el0, %[pmcr]\n"
> >>>                                   ^~~~~~~
> >>>                                   %w[pmcr]
> >>> arm/pmu.c:284:54: error: value size does not match register size specified
> >>>  by the constraint and modifier [-Werror,-Wasm-operand-widths]
> >>>         : [addr] "r" (addr), [pmcr] "r" (pmcr), [loop] "r" (loop)
> >>>                                                             ^
> >>> arm/pmu.c:276:23: note: use constraint modifier "w"
> >>>         "       mov     x10, %[loop]\n"
> >>>                              ^~~~~~~
> >>>                              %w[loop]
> >>>
> >>> pmcr should be 64-bit since it is a sysreg, but for loop we can use the
> >>> "w" modifier.
> >>>
> >>> Suggested-by: Drew Jones <drjones@redhat.com>
> > 
> > Not a huge deal, but I use my official first name 'Andrew' on my tags.
> > I know, I like confusing people by flipping back and forth between
> > Andrew and Drew...
> 
> Sorry, IIRC I simply copy-n-pasted your name and e-mail address from the
> MAINTAINERS file ... maybe you should fix it there to avoid such situations?
>

Thanks for pointing that out. Patch sent.

drew 

