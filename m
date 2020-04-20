Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7E51B1156
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 18:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgDTQTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 12:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726036AbgDTQTH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Apr 2020 12:19:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0B9C061A0C
        for <kvm@vger.kernel.org>; Mon, 20 Apr 2020 09:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=o3r/9H1g4XVNttUz12GoHBi/9Qq29h3HAKyoLq5UF/U=; b=sBTQ54BbtwXNAtdG5APYhkaBDp
        EiVjrwn7pGkTjG5p+xCltaOxOTvguxGKTw4786cBWW3W4tZ5oPuOx7WN0LYOgA6AKPIPCF2XLkq7E
        E+f6vc2imOkli+zgkRWDSjWpbPYqSAhy1IqPIFRSKHajT7bV5rx02Os8U2DLH4xgbagED/zb2WLGh
        WVEDU2Y0BG9TOJde68PeFvGuJgF47hv3OVMKb1ZPaY5hlpQB1uVC7doYQmZ8GzyWT/E8ANAkbSFA8
        yQZpPFJ6KbCjhBG9BenG+GPeMDBDRUOplZMLB9YFQxMkWlE2y1tkeEZqpTuNqgwA3R/Cqxh819ZaP
        G+DzgUnA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jQZ8U-00014x-Ta; Mon, 20 Apr 2020 16:19:07 +0000
Subject: Re: [PATCH] kvm: Disable objtool frame pointer checking for vmenter.S
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
References: <01fae42917bacad18be8d2cbc771353da6603473.1587398610.git.jpoimboe@redhat.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <3da1077d-c1b0-4fb0-693b-c124e8e4ca0f@infradead.org>
Date:   Mon, 20 Apr 2020 09:19:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <01fae42917bacad18be8d2cbc771353da6603473.1587398610.git.jpoimboe@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/20/20 9:17 AM, Josh Poimboeuf wrote:
> Frame pointers are completely broken by vmenter.S because it clobbers
> RBP:
> 
>   arch/x86/kvm/svm/vmenter.o: warning: objtool: __svm_vcpu_run()+0xe4: BP used as a scratch register
> 
> That's unavoidable, so just skip checking that file when frame pointers
> are configured in.
> 
> On the other hand, ORC can handle that code just fine, so leave objtool
> enabled in the !FRAME_POINTER case.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Thanks.

> ---
>  arch/x86/kvm/Makefile | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index a789759b7261..4a3081e9f4b5 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -3,6 +3,10 @@
>  ccflags-y += -Iarch/x86/kvm
>  ccflags-$(CONFIG_KVM_WERROR) += -Werror
>  
> +ifeq ($(CONFIG_FRAME_POINTER),y)
> +OBJECT_FILES_NON_STANDARD_vmenter.o := y
> +endif
> +
>  KVM := ../../../virt/kvm
>  
>  kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
> 


-- 
~Randy
