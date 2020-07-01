Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C70321089C
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 11:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729689AbgGAJwO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 05:52:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59766 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729109AbgGAJwN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 05:52:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593597132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yr9P8koL5cZlRAIrdh7l0eAB/Gw7Y7XsrIkuWI4cPoQ=;
        b=d4UzVqmGyfb3TYxNXch7r8B1f8SaNlu3+DXFrnLYXmM82QrdaBBO9Xi7fmZWOpFtOsIJvB
        bjr/UiKmMuWk9x2bZkIZ9Hb7jUH+9WWrAgmADsFTQ9xuQz7HiCbpahgrI2Lrkh2deSx8uq
        PYhwyCTrum93GDH/XWIf7260rPOLVN8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-MYO1jJjpMoKn1LFgohiKlA-1; Wed, 01 Jul 2020 05:52:10 -0400
X-MC-Unique: MYO1jJjpMoKn1LFgohiKlA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3715F80183C
        for <kvm@vger.kernel.org>; Wed,  1 Jul 2020 09:52:09 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-45.ams2.redhat.com [10.36.114.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 957D07CAC4;
        Wed,  1 Jul 2020 09:52:08 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] scripts: Fix the check whether testname is
 in the only_tests list
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20200701094635.19491-1-pbonzini@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <db772d67-a16a-086b-bfc3-e9348ea27c16@redhat.com>
Date:   Wed, 1 Jul 2020 11:52:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200701094635.19491-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/07/2020 11.46, Paolo Bonzini wrote:
> When you currently run
> 
>    ./run_tests.sh ioapic-split
> 
> the kvm-unit-tests run scripts do not only execute the "ioapic-split"
> test, but also the "ioapic" test, which is quite surprising. This
> happens because we use "grep -w" for checking whether a test should
> be run or not.  Because "grep -w" does not consider the "-" character as
> part of a word, "ioapic" successfully matches against "ioapic-split".
> 
> To fix the issue, use spaces as the only delimiter when running "grep",
> removing the problematic "-w" flag from the invocation.
> 
> Reported-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   scripts/runtime.bash | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 8bfe31c..6158e37 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -68,6 +68,11 @@ function print_result()
>       fi
>   }
>   
> +function find_word()
> +{
> +    grep -q " $1 " <<< " $2 "
> +}

Ah, clever idea with the surrounding spaces here!

Works great for me, so:
Tested-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>

