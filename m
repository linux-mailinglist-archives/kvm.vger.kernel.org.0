Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799242553EF
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 07:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbgH1FA3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 01:00:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31152 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725536AbgH1FA2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 01:00:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598590827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eIFpIN9kkK/LUMn/tSwYg4T6VNXptppoOQmdDhylsoc=;
        b=ha6MwzKsMahUGLndUpWcM1rdBMWhkSgmbbL5kuUGEk+dICHgZDbueCjOfER1T+zIrtv2+h
        ET655X8ex3/P68caE1BXS/msWPCH8LfB3nnbdyIynpKrbYUZn/nKPraKBAPifH6fQ11Z6Y
        /ZVgUkC84cjsUJnuQ3Ee+MTPkXdMpzs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-S7xxm0oSMjWQdqmIoxTfog-1; Fri, 28 Aug 2020 01:00:22 -0400
X-MC-Unique: S7xxm0oSMjWQdqmIoxTfog-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86EB383DBBE;
        Fri, 28 Aug 2020 05:00:21 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-79.ams2.redhat.com [10.36.112.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA4397D667;
        Fri, 28 Aug 2020 05:00:20 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 1/7] x86: Makefile: Allow division on
 x86_64-elf binutils
To:     Roman Bolshakov <r.bolshakov@yadro.com>, kvm@vger.kernel.org
Cc:     Cameron Esfahani <dirty@apple.com>
References: <20200810130618.16066-1-r.bolshakov@yadro.com>
 <20200810130618.16066-2-r.bolshakov@yadro.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <ee81540c-9064-4650-8784-d4531eec042c@redhat.com>
Date:   Fri, 28 Aug 2020 07:00:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200810130618.16066-2-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/08/2020 15.06, Roman Bolshakov wrote:
> For compatibility with other SVR4 assemblers, '/' starts a comment on
> *-elf binutils target and thus division operator is not allowed [1][2].
> That breaks cstart64.S build:
> 
>   x86/cstart64.S: Assembler messages:
>   x86/cstart64.S:294: Error: unbalanced parenthesis in operand 1.
> 
> The option is ignored on the Linux target of GNU binutils.
> 
> 1. https://sourceware.org/binutils/docs/as/i386_002dChars.html
> 2. https://sourceware.org/binutils/docs/as/i386_002dOptions.html#index-_002d_002ddivide-option_002c-i386
> 
> Cc: Cameron Esfahani <dirty@apple.com>
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>  x86/Makefile | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/x86/Makefile b/x86/Makefile
> index 8a007ab..22afbb9 100644
> --- a/x86/Makefile
> +++ b/x86/Makefile
> @@ -1 +1,3 @@
>  include $(SRCDIR)/$(TEST_DIR)/Makefile.$(ARCH)
> +
> +COMMON_CFLAGS += -Wa,--divide

Some weeks ago, I also played with an elf cross compiler and came to the
same conclusion, that we need this option there. Unfortunately, it does
not work with clang:

 https://gitlab.com/huth/kvm-unit-tests/-/jobs/707986800#L1629

You could try to wrap it with "cc-option" instead ... or use a proper
check in the configure script to detect whether it's needed or not.

And can you please put it next to the other COMMON_CFLAGS in
x86/Makefile.common instead of x86/Makefile?

 Thanks,
  Thomas

