Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1A524879E
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 16:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgHROcx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 10:32:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40456 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726917AbgHROcx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 10:32:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597761172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K8cRO2wtXBdJSi8onw9kh80jHB123K9vBSP+dfm1bV8=;
        b=Ah2/72DB4wI1OE+EYrdVaqm0XJKXCdNjDO7gDskcAfdPiUtETO8KTPXv3i4QtDJvWCF+ud
        +oL6bjrSQHyn0EVRB0m1QSYl4kGovN2XX++KnuYCnT9eRqNALFz3pudIEerhgdu0vDlpHZ
        b0Udjh9ffOlsiGgxigjUqL4P07xe4zY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-f_V_AheZOa23tbwAxAZHpA-1; Tue, 18 Aug 2020 10:32:49 -0400
X-MC-Unique: f_V_AheZOa23tbwAxAZHpA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 901B6425D1;
        Tue, 18 Aug 2020 14:32:48 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9588D7B909;
        Tue, 18 Aug 2020 14:32:43 +0000 (UTC)
Date:   Tue, 18 Aug 2020 16:32:40 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 3/4] run_tests/mkstandalone: add arch_cmd
 hook
Message-ID: <20200818143240.lhdtsvftvvmukexk@kamzik.brq.redhat.com>
References: <20200818130424.20522-1-mhartmay@linux.ibm.com>
 <20200818130424.20522-4-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818130424.20522-4-mhartmay@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 18, 2020 at 03:04:23PM +0200, Marc Hartmayer wrote:
> This allows us, for example, to auto generate a new test case based on
> an existing test case.
> 
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>  scripts/common.bash | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/common.bash b/scripts/common.bash
> index c7acdf14a835..a6044b7c6c35 100644
> --- a/scripts/common.bash
> +++ b/scripts/common.bash
> @@ -19,7 +19,7 @@ function for_each_unittest()
>  	while read -r -u $fd line; do
>  		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
>  			if [ -n "${testname}" ]; then
> -				"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
> +				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
>  			fi
>  			testname=${BASH_REMATCH[1]}
>  			smp=1
> @@ -49,11 +49,16 @@ function for_each_unittest()
>  		fi
>  	done
>  	if [ -n "${testname}" ]; then
> -		"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
> +		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
>  	fi
>  	exec {fd}<&-
>  }
>  
> +function arch_cmd()
> +{
> +	[ "${ARCH_CMD}" ] && echo "${ARCH_CMD}"
> +}
> +
>  # The current file has to be the only file sourcing the arch helper
>  # file
>  ARCH_FUNC=scripts/${ARCH}/func.bash
> -- 
> 2.25.4
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

