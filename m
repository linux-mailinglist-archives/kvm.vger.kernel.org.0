Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07E824D603
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 15:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbgHUNRC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 09:17:02 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52179 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728791AbgHUNQx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 09:16:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598015811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Nd6XNkr5iHHdOJEBEi186SqoP5KhFFwMU5ZlupF+bPA=;
        b=ZSZRSCdZW4Y6p7waqM9BCj6TmPwgRYv/EE4+E9fKYPC7MNCvMRk4gfgDKO12qkvtCOTz7C
        svloTUqWlXEUpPjJle3Nil9I3xCvrfp8SpUp87peKAtBxzBAUeERzJLMURoeoNVg5Y1eSN
        xaV/7r4qh19Dm8ZPGgCX/KnugbU2SCY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-JNA_MDIBPO-S20dSBiauRg-1; Fri, 21 Aug 2020 09:16:48 -0400
X-MC-Unique: JNA_MDIBPO-S20dSBiauRg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D2921005E78;
        Fri, 21 Aug 2020 13:16:47 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 195F4795AE;
        Fri, 21 Aug 2020 13:16:42 +0000 (UTC)
Date:   Fri, 21 Aug 2020 15:16:40 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] Use same test names in the default
 and the TAP13 output format
Message-ID: <20200821131640.iknz634ja7rd6tnh@kamzik.brq.redhat.com>
References: <20200821123744.33173-1-mhartmay@linux.ibm.com>
 <20200821123744.33173-3-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821123744.33173-3-mhartmay@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 21, 2020 at 02:37:44PM +0200, Marc Hartmayer wrote:
> Use the same test names in the TAP13 output as in the default output
> format. This makes the output more consistent. To achieve this, we
> need to pass the test name as an argument to the function
> `process_test_output`.
> 
> Before this change:
> $ ./run_tests.sh
> PASS selftest-setup (14 tests)
> ...
> 
> vs.
> 
> $ ./run_tests.sh -t
> TAP version 13
> ok 1 - selftest: true
> ok 2 - selftest: argc == 3
> ...
> 
> After this change:
> $ ./run_tests.sh
> PASS selftest-setup (14 tests)
> ...
> 
> vs.
> 
> $ ./run_tests.sh -t
> TAP version 13
> ok 1 - selftest-setup: true
> ok 2 - selftest-setup: argc == 3
> ...
> 
> While at it, introduce a local variable `kernel` in
> `RUNTIME_log_stdout` since this makes the function easier to read.
> 
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>  run_tests.sh         | 15 +++++++++------
>  scripts/runtime.bash |  6 +++---
>  2 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/run_tests.sh b/run_tests.sh
> index 01e36dcfa06e..b5812336866f 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -81,18 +81,19 @@ if [[ $tap_output == "no" ]]; then
>      postprocess_suite_output() { cat; }
>  else
>      process_test_output() {
> +        local testname="$1"
>          CR=$'\r'
>          while read -r line; do
>              line="${line%$CR}"
>              case "${line:0:4}" in
>                  PASS)
> -                    echo "ok TEST_NUMBER - ${line#??????}" >&3
> +                    echo "ok TEST_NUMBER - ${testname}:${line#*:*:}" >&3
>                      ;;
>                  FAIL)
> -                    echo "not ok TEST_NUMBER - ${line#??????}" >&3
> +                    echo "not ok TEST_NUMBER - ${testname}:${line#*:*:}" >&3
>                      ;;
>                  SKIP)
> -                    echo "ok TEST_NUMBER - ${line#??????} # skip" >&3
> +                    echo "ok TEST_NUMBER - ${testname}:${line#*:*:} # skip" >&3
>                      ;;
>                  *)
>                      ;;
> @@ -114,12 +115,14 @@ else
>      }
>  fi
>  
> -RUNTIME_log_stderr () { process_test_output; }
> +RUNTIME_log_stderr () { process_test_output "$1"; }
>  RUNTIME_log_stdout () {
> +    local testname="$1"
>      if [ "$PRETTY_PRINT_STACKS" = "yes" ]; then
> -        ./scripts/pretty_print_stacks.py $1 | process_test_output
> +        local kernel="$2"
> +        ./scripts/pretty_print_stacks.py "$kernel" | process_test_output "$testname"
>      else
> -        process_test_output
> +        process_test_output "$testname"
>      fi
>  }
>  
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index caa4c5ba18cc..294e6b15a5e2 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -140,10 +140,10 @@ function run()
>      # extra_params in the config file may contain backticks that need to be
>      # expanded, so use eval to start qemu.  Use "> >(foo)" instead of a pipe to
>      # preserve the exit status.
> -    summary=$(eval $cmdline 2> >(RUNTIME_log_stderr) \
> -                             > >(tee >(RUNTIME_log_stdout $kernel) | extract_summary))
> +    summary=$(eval $cmdline 2> >(RUNTIME_log_stderr $testname) \
> +                             > >(tee >(RUNTIME_log_stdout $testname $kernel) | extract_summary))
>      ret=$?
> -    [ "$STANDALONE" != "yes" ] && echo > >(RUNTIME_log_stdout $kernel)
> +    [ "$STANDALONE" != "yes" ] && echo > >(RUNTIME_log_stdout $testname $kernel)
>  
>      if [ $ret -eq 0 ]; then
>          print_result "PASS" $testname "$summary"
> -- 
> 2.25.4
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

