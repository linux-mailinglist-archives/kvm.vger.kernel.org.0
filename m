Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFC127ADF3
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 14:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgI1Mhm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 08:37:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60913 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726281AbgI1Mhm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 08:37:42 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601296661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TAkxtK+gKnvxnTjXjc1lUlmVEVaqMIlO1AdygvcB4bg=;
        b=AXZgT8KZmZ1y5P0uNtLMH4Xeljd0HUka3Dv68ECKmGO3FERNqE7k896zn/cPlTXEKSTflS
        lkmv6uUU2pYNS49sD1O1dFvUXirrQPKE0QwU6oIyYWoGbC6qrq+BlyR99N5KqfuXqSx4gw
        nOHGoY7Lrh05UKUAfoUpaqGJbtWyc8o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-5YB3pMgnMa-AVhjbKc95BA-1; Mon, 28 Sep 2020 08:37:39 -0400
X-MC-Unique: 5YB3pMgnMa-AVhjbKc95BA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E9201084CA5
        for <kvm@vger.kernel.org>; Mon, 28 Sep 2020 12:37:38 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.221])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 79B4E49F7;
        Mon, 28 Sep 2020 12:37:37 +0000 (UTC)
Date:   Mon, 28 Sep 2020 14:37:34 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests] runtime.bash: fix check for parameter
 files
Message-ID: <20200928123734.mxfiyadnhftlcguw@kamzik.brq.redhat.com>
References: <20200928113412.2419974-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928113412.2419974-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 28, 2020 at 07:34:12AM -0400, Paolo Bonzini wrote:
> We need to check if the file exists, not just if it is a non-empty string.
> While an empty $path would have the unfortunate effect that "cat" would
> read from stdin, that is not an issue as you can simply not do that.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  scripts/runtime.bash | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 294e6b1..3121c1f 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -118,7 +118,7 @@ function run()
>      for check_param in "${check[@]}"; do
>          path=${check_param%%=*}
>          value=${check_param#*=}
> -        if [ "$path" ] && [ "$(cat $path)" != "$value" ]; then
> +        if [ -f "$path" ] && [ "$(cat $path)" != "$value" ]; then
>              print_result "SKIP" $testname "" "$path not equal to $value"
>              return 2
>          fi
> -- 
> 2.26.2
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

