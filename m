Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F26F257FA1
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 19:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbgHaRbC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 13:31:02 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:34458 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729003AbgHaRbB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 13:31:01 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 3DAF4574E8;
        Mon, 31 Aug 2020 17:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1598895058;
         x=1600709459; bh=DSYSWzfMMJXZgSzVlu8gq6zZP9VMQAGt/8U3c8m/fGg=; b=
        lOC82w3+Nf1sF/LAbhXiYjXrIMVShdrSe85NMYIteBFVqgLnXNUjmHyXXiqcDRqJ
        0zLO26PK1atCSWSC0mpZeZjND+aar5jbqnuPCbZX4E6aoddutWjyWvAk1S1Q+bcr
        Z2AhvErlvcFNw075BbODUl2oN/g4OmkahnJlxIbic4E=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FWix9LOsqcSc; Mon, 31 Aug 2020 20:30:58 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id C9FFF54302;
        Mon, 31 Aug 2020 20:30:58 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 31
 Aug 2020 20:30:58 +0300
Date:   Mon, 31 Aug 2020 20:30:58 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Thomas Huth <thuth@redhat.com>
CC:     <kvm@vger.kernel.org>, Cameron Esfahani <dirty@apple.com>
Subject: Re: [kvm-unit-tests PATCH 1/7] x86: Makefile: Allow division on
 x86_64-elf binutils
Message-ID: <20200831173058.GA22344@SPB-NB-133.local>
References: <20200810130618.16066-1-r.bolshakov@yadro.com>
 <20200810130618.16066-2-r.bolshakov@yadro.com>
 <ee81540c-9064-4650-8784-d4531eec042c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ee81540c-9064-4650-8784-d4531eec042c@redhat.com>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 28, 2020 at 07:00:19AM +0200, Thomas Huth wrote:
> On 10/08/2020 15.06, Roman Bolshakov wrote:
> > +
> > +COMMON_CFLAGS += -Wa,--divide
> 
> Some weeks ago, I also played with an elf cross compiler and came to the
> same conclusion, that we need this option there. Unfortunately, it does
> not work with clang:
> 
>  https://gitlab.com/huth/kvm-unit-tests/-/jobs/707986800#L1629
> 
> You could try to wrap it with "cc-option" instead ... or use a proper
> check in the configure script to detect whether it's needed or not.
> 

Hi Thomas,

I've wrapped it but clang can't deal with another option:
-Woverride-init

Even if I wrap it with cc-option and add wrapped clang's
-Winitializer-overrides, the build fails with:

x86/vmexit.c:577:5: error: no previous prototype for function 'main'
      [-Werror,-Wmissing-prototypes]
int main(int ac, char **av)
    ^
1 error generated.
<builtin>: recipe for target 'x86/vmexit.o' failed

I'm puzzled with this one.

CI log (ubuntu focal + clang 10):
https://travis-ci.com/github/roolebo/kvm-unit-tests/jobs/379561410

Now I wonder if wrong clang is used... Perhaps I should try
--cc=clang-10 in .travis.yml instead of --cc=clang.

Thanks,
Roman
