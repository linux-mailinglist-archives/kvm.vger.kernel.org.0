Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D997A233F1E
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 08:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731351AbgGaGcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 02:32:10 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38749 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731269AbgGaGcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 02:32:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596177129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jUqlOS0LGIgs5xxc+eVW16fZljaITYx6kre8je7X1Zk=;
        b=RpeHP0hA3D7P+ZEvqdWWGv+l9/vYTdYOTBRR/2dj6Z4jQSF9xD8i3Jll+5dd+xSvaCRi/9
        23wW0/Jbjfw+2KxkEpCGIcFiUxvMYrzwEjTrh/l/i0F3StcKCe+FguGUNtX8fLURL0XHV1
        fdlLGq1dn/WD5XCGgYD0cuHoSHI1ZWE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-XdAYOR7bPSSlzBGA623goQ-1; Fri, 31 Jul 2020 02:32:06 -0400
X-MC-Unique: XdAYOR7bPSSlzBGA623goQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2142D107ACCA
        for <kvm@vger.kernel.org>; Fri, 31 Jul 2020 06:32:06 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.116])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A789573037;
        Fri, 31 Jul 2020 06:32:02 +0000 (UTC)
Date:   Fri, 31 Jul 2020 08:32:00 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH] scripts/runtime: Replace "|&" with "2>&1
 |"
Message-ID: <20200731063200.ylvid4qrtvyduagr@kamzik.brq.redhat.com>
References: <20200731060909.1163-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731060909.1163-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 31, 2020 at 08:09:09AM +0200, Thomas Huth wrote:
> The "|&" only works with newer versions of the bash. For compatibility
> with older versions, we should use "2>&1 |" instead.

Hi Thomas,

Which bash version are you targeting with this change?

I think it's time we pick a bash version that we want to support
(thoroughly test all the scripts with it) and then document it. As
part of the CI we should test with both that version and with the
latest released version (394d1421 ("run_migration: Implement our own
wait") is an example of why only testing with our supported version
wouldn't be sufficient, unless we required everyone to use that
version when running the tests, and I don't want to do that.)

> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  scripts/runtime.bash | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index c88e246..35689a7 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -172,7 +172,7 @@ function run()
>  # "arm/arm64: KVM: Remove 'config KVM_ARM_MAX_VCPUS'". So, at some
>  # point when maintaining the while loop gets too tiresome, we can
>  # just remove it...
> -while $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
> -		|& grep -qi 'exceeds max CPUs'; do
> +while $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP 2>&1 \
> +		| grep -qi 'exceeds max CPUs'; do
>  	MAX_SMP=$((MAX_SMP >> 1))
>  done
> -- 
> 2.18.1
>

Anyway
 
Reviewed-by: Andrew Jones <drjones@redhat.com>

