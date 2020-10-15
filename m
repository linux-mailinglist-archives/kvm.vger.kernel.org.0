Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90ED28EEB1
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 10:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388232AbgJOInP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Oct 2020 04:43:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30828 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388226AbgJOInN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Oct 2020 04:43:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602751392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TASATbbzMLoiV4MKZ4oARU5/RjZ2xLAUlcSJWsxN5xo=;
        b=EnARmd54d9a21FT/zX6tZ4yRNVHKrMS/zbSzOtqlg7daY4z0AJgSuv82wpr803EMx6ILK3
        tBECVHjywiMXSEuNeIXFMJelaCd3r14L32Ih2lBbmgY0tu+O4qx1hWX4NZTl2b760JB2A/
        I4MUlDeqjOJa5LWpVm5dWon3+uSuU5o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-JNAcG04QOVeV46C3gloj-Q-1; Thu, 15 Oct 2020 04:43:10 -0400
X-MC-Unique: JNAcG04QOVeV46C3gloj-Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0DB4803620
        for <kvm@vger.kernel.org>; Thu, 15 Oct 2020 08:43:09 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 632F360C0F;
        Thu, 15 Oct 2020 08:43:08 +0000 (UTC)
Date:   Thu, 15 Oct 2020 10:43:05 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v2 kvm-unit-tests] runtime.bash: skip test when checked
 file doesn't exist
Message-ID: <20201015084305.ixrvamtpjdhykwgf@kamzik.brq.redhat.com>
References: <20201015083808.2488268-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015083808.2488268-1-vkuznets@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 15, 2020 at 10:38:08AM +0200, Vitaly Kuznetsov wrote:
> Currently, we have the following check condition in x86/unittests.cfg:
> 
> check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
> 
> the check, however, passes successfully on AMD because the checked file
> is just missing. This doesn't sound right, reverse the check: fail
> if the content of the file doesn't match the expectation or if the
> file is not there.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
> Changes since v1:
> - tabs -> spaces [Thomas]
> ---
>  scripts/runtime.bash | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 3121c1ffdae8..99d242d5cf8c 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -118,7 +118,10 @@ function run()
>      for check_param in "${check[@]}"; do
>          path=${check_param%%=*}
>          value=${check_param#*=}
> -        if [ -f "$path" ] && [ "$(cat $path)" != "$value" ]; then
> +        if [ -z "$path" ]; then
> +            continue
> +        fi
> +        if [ ! -f "$path" ] || [ "$(cat $path)" != "$value" ]; then
>              print_result "SKIP" $testname "" "$path not equal to $value"
>              return 2
>          fi
> -- 
> 2.25.4
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

