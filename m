Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B299210C453
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 08:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbfK1Hbu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 02:31:50 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53508 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726963AbfK1Hbu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Nov 2019 02:31:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574926309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2+dRvlx+eQQA6adZpF/lnm3ZtobUApPByXipVXNiVMQ=;
        b=JU+eCkGLNCUlLauA6xVda9qjgFLtz22v7hFOwKcpp+0xc1RTqrQ3IJwPpqk+BCiqjasm8T
        LAvdu7mUMPOneIVF0oRBV9c1mh3ceaJ+DA6hz118roNaOM/8ofM+R+DfRSCe4lRTW24WIa
        F0uOQZPDJCtDmZP29hahW+ssBhz06Co=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-Eukrc5hgNyibHDXTIpoCOg-1; Thu, 28 Nov 2019 02:31:47 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3A57800D4C;
        Thu, 28 Nov 2019 07:31:46 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-114.ams2.redhat.com [10.36.116.114])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 73B2E5C1B0;
        Thu, 28 Nov 2019 07:31:45 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 1/6] x86: emulator: use "SSE2" for the
 target
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     jmattson@google.com, sean.j.christopherson@intel.com
References: <20191015000411.59740-1-morbo@google.com>
 <20191030210419.213407-1-morbo@google.com>
 <20191030210419.213407-2-morbo@google.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <1f1aa364-c07e-743f-65b0-acdad5c10fe2@redhat.com>
Date:   Thu, 28 Nov 2019 08:31:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191030210419.213407-2-morbo@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: Eukrc5hgNyibHDXTIpoCOg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/10/2019 22.04, Bill Wendling wrote:
> The movdqu and movapd instructions are SSE2 instructions. Clang
> interprets the __attribute__((target("sse"))) as allowing SSE only
> instructions. Using SSE2 instructions cause an error.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>   x86/emulator.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/x86/emulator.c b/x86/emulator.c
> index 621caf9..bec0154 100644
> --- a/x86/emulator.c
> +++ b/x86/emulator.c
> @@ -657,7 +657,7 @@ static bool sseeq(sse_union *v1, sse_union *v2)
>       return ok;
>   }
>   
> -static __attribute__((target("sse"))) void test_sse(sse_union *mem)
> +static __attribute__((target("sse2"))) void test_sse(sse_union *mem)
>   {
>       sse_union v;

That seems to work fine with both, gcc and clang, thus:

Tested-by: Thomas Huth <thuth@redhat.com>

