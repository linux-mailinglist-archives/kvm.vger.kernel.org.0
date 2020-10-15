Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08F528EE5A
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 10:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387981AbgJOITi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Oct 2020 04:19:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22715 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726018AbgJOITh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Oct 2020 04:19:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602749976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oMTSKe9LoF6Lk+gahJ7SD7KZkJWw+4E1Sb2on7UKf/Q=;
        b=gGdN64PwcM5t4khdWs3n/q0nvr8bPYvhZJ9nv2zIOAIFvObW4zbteZ13iVBgKRllTZ4aqG
        ze2J7wZnQSSb89lch+DbJkCeXUpn6EgjenIilgGHBtz0T3+6rCyTvQXYoMOI4JBCUxu9JG
        ZsBZIf4bgm4qnUzbEHvvf2rK2j0R4z0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-JzTGwbewPACrg2fArGtiIQ-1; Thu, 15 Oct 2020 04:19:33 -0400
X-MC-Unique: JzTGwbewPACrg2fArGtiIQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF7A48030C6
        for <kvm@vger.kernel.org>; Thu, 15 Oct 2020 08:19:32 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-212.ams2.redhat.com [10.36.112.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E262575131;
        Thu, 15 Oct 2020 08:19:31 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests 1/3] lib/string: Fix getenv name matching
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
References: <20201014191444.136782-1-drjones@redhat.com>
 <20201014191444.136782-2-drjones@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <9c7d9d1a-28d7-6aa0-0fed-6ada05d854d8@redhat.com>
Date:   Thu, 15 Oct 2020 10:19:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20201014191444.136782-2-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/10/2020 21.14, Andrew Jones wrote:
> Without confirming that the name length exactly matches too, then
> the string comparison would return the same value for VAR* as for
> VAR, when VAR came first in the environ array.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  lib/string.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/string.c b/lib/string.c
> index 018dcc879516..3a0562120f12 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -171,10 +171,13 @@ extern char **environ;
>  char *getenv(const char *name)
>  {
>      char **envp = environ, *delim;
> +    int len;
>  
>      while (*envp) {
>          delim = strchr(*envp, '=');
> -        if (delim && strncmp(name, *envp, delim - *envp) == 0)
> +        assert(delim);
> +        len = delim - *envp;
> +        if (strlen(name) == len && strncmp(name, *envp, len) == 0)
>              return delim + 1;
>          ++envp;
>      }
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

