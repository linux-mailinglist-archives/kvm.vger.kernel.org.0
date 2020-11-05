Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0770F2A7B31
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 10:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgKEJ7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 04:59:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57552 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725308AbgKEJ7m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Nov 2020 04:59:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604570380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xaMTQxWu5HBp9bZj5lRKG1+oH0KjoVYjzzOCyH1Uh9M=;
        b=i9ICl5JPx5dKyzUoEqA2r/49W6LjZtYh+ivgWgMxEmuMebmiOKy2pKECtz44LYfuSVBNB9
        no212PJagovxG9NjCJqKz8X88BZ8WSmiHkM+1yisgkltRHUE5YxCaSYnAuko5FmotfmjJA
        ywW6W7HvuyGwL/7AfRdJcNLH9oPt2Og=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-m0UIgn1ZOoWN6ARgLtOt8w-1; Thu, 05 Nov 2020 04:59:38 -0500
X-MC-Unique: m0UIgn1ZOoWN6ARgLtOt8w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A81E6804747;
        Thu,  5 Nov 2020 09:59:37 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D837E5C5DE;
        Thu,  5 Nov 2020 09:59:32 +0000 (UTC)
Date:   Thu, 5 Nov 2020 10:59:30 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: Re: [PATCH 09/11] KVM: selftests: Make vm_create_default common
Message-ID: <20201105095930.nofg64qyuf4qertu@kamzik.brq.redhat.com>
References: <20201104212357.171559-1-drjones@redhat.com>
 <20201104212357.171559-10-drjones@redhat.com>
 <20201104213612.rjykwe7pozcoqbcb@kamzik.brq.redhat.com>
 <c2c57735-2d1c-5abf-c2c0-ed04a19db5a0@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2c57735-2d1c-5abf-c2c0-ed04a19db5a0@de.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 05, 2020 at 08:18:37AM +0100, Christian Borntraeger wrote:
> 
> 
> On 04.11.20 22:36, Andrew Jones wrote:
> > On Wed, Nov 04, 2020 at 10:23:55PM +0100, Andrew Jones wrote:
> >> The code is almost 100% the same anyway. Just move it to common
> >> and add a few arch-specific helpers.
> >>
> >> Signed-off-by: Andrew Jones <drjones@redhat.com>
> >> ---
> >>  .../selftests/kvm/include/aarch64/processor.h |  3 ++
> >>  .../selftests/kvm/include/s390x/processor.h   |  4 +++
> >>  .../selftests/kvm/include/x86_64/processor.h  |  4 +++
> >>  .../selftests/kvm/lib/aarch64/processor.c     | 17 ----------
> >>  tools/testing/selftests/kvm/lib/kvm_util.c    | 26 +++++++++++++++
> >>  .../selftests/kvm/lib/s390x/processor.c       | 22 -------------
> >>  .../selftests/kvm/lib/x86_64/processor.c      | 32 -------------------
> >>  7 files changed, 37 insertions(+), 71 deletions(-)
> >>
> >> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> >> index b7fa0c8551db..5e5849cdd115 100644
> >> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> >> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> >> @@ -9,6 +9,9 @@
> >>  
> >>  #include "kvm_util.h"
> >>  
> >> +#define PTRS_PER_PAGE(page_size)	((page_size) / 8)
> >> +#define min_page_size()			(4096)
> >> +#define min_page_shift()		(12)
> >>  
> >>  #define ARM64_CORE_REG(x) (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
> >>  			   KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
> >> diff --git a/tools/testing/selftests/kvm/include/s390x/processor.h b/tools/testing/selftests/kvm/include/s390x/processor.h
> >> index e0e96a5f608c..0952f53c538b 100644
> >> --- a/tools/testing/selftests/kvm/include/s390x/processor.h
> >> +++ b/tools/testing/selftests/kvm/include/s390x/processor.h
> >> @@ -5,6 +5,10 @@
> >>  #ifndef SELFTEST_KVM_PROCESSOR_H
> >>  #define SELFTEST_KVM_PROCESSOR_H
> >>  
> >> +#define PTRS_PER_PAGE(page_size)	((page_size) / 8)
> > 
> > Doh. I think this 8 is supposed to be a 16 for s390x, considering it
> > was dividing by 256 in its version of vm_create_default. I need
> > guidance from s390x gurus as to whether or not I should respin though.
> > 
> > Thanks,
> > drew
> > 
> 
> This is kind of tricky. The last level page table is only 2kb (256 entries = 1MB range).
> Depending on whether the page table allocation is clever or not (you can have 2 page
> tables in one page) this means that indeed 16 might be better. But then you actually 
> want to change the macro name to PTES_PER_PAGE?

Thanks Christian,

I'll respin with the macro name change and 16 for s390.

drew

