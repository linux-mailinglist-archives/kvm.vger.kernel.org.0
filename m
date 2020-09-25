Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9F52783C4
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 11:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgIYJQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 05:16:42 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:59626 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726990AbgIYJQm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 05:16:42 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 5C19558089;
        Fri, 25 Sep 2020 09:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1601025398;
         x=1602839799; bh=O4NvdRfYmNELvyXNyO4j1LWxpAr7DHrinRknM25HkGU=; b=
        evP/U6/NXeSMdxs16plnzlplW9fa+UOQ5YD/x2xAVlKY+9zzOllNts9gtWWKKO++
        q7eQmk9gBJt3fkwOz/V9Slhjm6DHVnsBSzSafqg/Yh7Mat8Du4vrY5wV3foFw78j
        az7XLIhzw5wODeAR/+mvL3UDkiv0IWr2xiWEO/kCY4U=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vM_EvN1fbxtZ; Fri, 25 Sep 2020 12:16:38 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id B007A58086;
        Fri, 25 Sep 2020 12:16:38 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 25
 Sep 2020 12:16:38 +0300
Date:   Fri, 25 Sep 2020 12:16:37 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] configure: Test if compiler supports -m16
 on x86
Message-ID: <20200925091637.GB85563@SPB-NB-133.local>
References: <20200924182401.95891-1-r.bolshakov@yadro.com>
 <36271d1b-70b5-a6d8-41df-d1c94a9c6504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <36271d1b-70b5-a6d8-41df-d1c94a9c6504@redhat.com>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 09:17:00AM +0200, Paolo Bonzini wrote:
> On 24/09/20 20:24, Roman Bolshakov wrote:
> > -m16 option is available only since GCC 4.9.0 [1]. That causes a build
> > failure on centos-7 [2] that has GCC 4.8.5.
> > 
> > Fallback to -m32 if -m16 is not available.
> > 
> > 1. http://gcc.gnu.org/bugzilla/show_bug.cgi?id=59672
> > 2. https://gitlab.com/bonzini/kvm-unit-tests/-/jobs/755368387
> > 
> > Fixes: 2616ad934e2 ("x86: realmode: Workaround clang issues")
> > Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> 
> This is a simpler way to do it:
> 
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index 5567d66..781dba6 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -72,7 +72,7 @@ $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
>  	$(CC) -m32 -nostdlib -o $@ -Wl,-m,elf_i386 \
>  	      -Wl,-T,$(SRCDIR)/$(TEST_DIR)/realmode.lds $^
>  
> -$(TEST_DIR)/realmode.o: bits = 16
> +$(TEST_DIR)/realmode.o: bits := $(if $(call cc-option,-m16,""),16,32)
>  
>  $(TEST_DIR)/kvmclock_test.elf: $(TEST_DIR)/kvmclock.o
> 
> It's a tiny bit slower because the check is done on every compilation,
> but only if realmode.o is stale.
> 
> It passes CI (https://gitlab.com/bonzini/kvm-unit-tests/-/pipelines/194356382)
> so I plan to commit it.
> 

That's fine,
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

Thanks,
Roman
