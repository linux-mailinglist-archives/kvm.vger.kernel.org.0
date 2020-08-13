Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FAD2435F8
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 10:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgHMIaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 04:30:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57923 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726100AbgHMIaU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 04:30:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597307417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KqhI5Q8sClvpgxYuJqBvjt7ffftT1d+Bz/45Zz2EEQc=;
        b=FCMALU8uAeQdVzkxiyr6mWuDv0gh2U4eZvKvIeswsM/0x4w2rnHHM8FtxCUOPi7YyezfFv
        nWxDyL4Mh58dRL/8egeVPbm+wkroim8tlGqMti8qa9OvOXpYAgI9eGGMxeR9/K/8jXG48I
        QMq27cOIDIMf48xNo7RXammI563oKqM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-AIFhAaiZO1aHAiZnflsoTQ-1; Thu, 13 Aug 2020 04:30:15 -0400
X-MC-Unique: AIFhAaiZO1aHAiZnflsoTQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B56FE800D55;
        Thu, 13 Aug 2020 08:30:14 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.72])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 21D79100AE54;
        Thu, 13 Aug 2020 08:30:02 +0000 (UTC)
Date:   Thu, 13 Aug 2020 10:30:00 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests RFC v2 3/4] run_tests/mkstandalone: add arch
 dependent function to `for_each_unittest`
Message-ID: <20200813083000.e4bscohuhgl3jdv4@kamzik.brq.redhat.com>
References: <20200812092705.17774-1-mhartmay@linux.ibm.com>
 <20200812092705.17774-4-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812092705.17774-4-mhartmay@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 12, 2020 at 11:27:04AM +0200, Marc Hartmayer wrote:
> This allows us, for example, to auto generate a new test case based on
> an existing test case.
> 
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>  run_tests.sh            |  2 +-
>  scripts/common.bash     | 13 +++++++++++++
>  scripts/mkstandalone.sh |  2 +-
>  3 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/run_tests.sh b/run_tests.sh
> index 24aba9cc3a98..23658392c488 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -160,7 +160,7 @@ trap "wait; exit 130" SIGINT
>     # preserve stdout so that process_test_output output can write TAP to it
>     exec 3>&1
>     test "$tap_output" == "yes" && exec > /dev/null
> -   for_each_unittest $config run_task
> +   for_each_unittest $config run_task arch_cmd

Let's just require that arch cmd hook be specified by the "$arch_cmd"
variable. Then we don't need to pass it to for_each_unittest.

>  ) | postprocess_suite_output
>  
>  # wait until all tasks finish
> diff --git a/scripts/common.bash b/scripts/common.bash
> index f9c15fd304bd..62931a40b79a 100644
> --- a/scripts/common.bash
> +++ b/scripts/common.bash
> @@ -1,8 +1,15 @@
> +function arch_cmd()
> +{
> +	# Dummy function, can be overwritten by architecture dependent
> +	# code
> +	return
> +}

This dummy function appears unused and can be dropped.

>  
>  function for_each_unittest()
>  {
>  	local unittests="$1"
>  	local cmd="$2"
> +	local arch_cmd="${3-}"
>  	local testname
>  	local smp
>  	local kernel
> @@ -19,6 +26,9 @@ function for_each_unittest()
>  		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
>  			if [ -n "${testname}" ]; then
>  				"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
> +				if [ "${arch_cmd}" ]; then
> +					"${arch_cmd}" "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
> +				fi

Rather than assuming we should run both $cmd ... and $arch_cmd $cmd ...,
let's just run $arch_cmd $cmd ..., when it exists. If $arch_cmd wants to
run $cmd ... first, then it can do so itself.

>  			fi
>  			testname=${BASH_REMATCH[1]}
>  			smp=1
> @@ -49,6 +59,9 @@ function for_each_unittest()
>  	done
>  	if [ -n "${testname}" ]; then
>  		"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
> +		if [ "${arch_cmd}" ]; then
> +			"${arch_cmd}" "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
> +		fi
>  	fi
>  	exec {fd}<&-
>  }
> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> index cefdec30cb33..3b18c0cf090b 100755
> --- a/scripts/mkstandalone.sh
> +++ b/scripts/mkstandalone.sh
> @@ -128,4 +128,4 @@ fi
>  
>  mkdir -p tests
>  
> -for_each_unittest $cfg mkstandalone
> +for_each_unittest $cfg mkstandalone arch_cmd
> -- 
> 2.25.4
>

In summary, I think this patch should just be

diff --git a/scripts/common.bash b/scripts/common.bash
index 9a6ebbd7f287..b409b0529ea6 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -17,7 +17,7 @@ function for_each_unittest()
 
        while read -r -u $fd line; do
                if [[ "$line" =~ ^\[(.*)\]$ ]]; then
-                       "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+                       "$arch_cmd" "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
                        testname=${BASH_REMATCH[1]}
                        smp=1
                        kernel=""
@@ -45,6 +45,6 @@ function for_each_unittest()
                        timeout=${BASH_REMATCH[1]}
                fi
        done
-       "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+       "$arch_cmd" "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
        exec {fd}<&-
 }
 

Thanks,
drew

