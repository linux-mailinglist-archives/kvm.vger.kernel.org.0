Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32EA340915
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 16:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbhCRPmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 11:42:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58829 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231901AbhCRPmP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 11:42:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616082134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QeFI2HseGZSsd+lR2NSQGxAFgpdpTkPaeFK7ggBaIVU=;
        b=gO2y1CJr8kCRalTjF2jGtXO9uW8RIhWdG4hpCWu0NRx8ltpD63nZIKVLjhfwOk8dVVb78r
        g+l+wXFNVoiBfCIzcSOfvWLFCIo5jQvdNsfKlfBA92fhpjdh4T5IN2pozz7HTQaKqwr6Oi
        KBjRx4OELaQk9FkAjEg5qHQudlMo25U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-dt-Z2dRQNuuYg3YAJbJsqA-1; Thu, 18 Mar 2021 11:42:12 -0400
X-MC-Unique: dt-Z2dRQNuuYg3YAJbJsqA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFE28EC1A1;
        Thu, 18 Mar 2021 15:42:11 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.196.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F31BF5D6AB;
        Thu, 18 Mar 2021 15:42:06 +0000 (UTC)
Date:   Thu, 18 Mar 2021 16:42:04 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, lvivier@redhat.com, thuth@redhat.com,
        david@redhat.com, pbonzini@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests RFC 2/2] scripts: Set ACCEL in run_tests.sh if
 empty
Message-ID: <20210318154204.3qvzyq3pbb2x57vc@kamzik.brq.redhat.com>
References: <20210318124500.45447-1-frankja@linux.ibm.com>
 <20210318124500.45447-3-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318124500.45447-3-frankja@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 18, 2021 at 12:45:00PM +0000, Janosch Frank wrote:
> The current checks compare the env ACCEL to the unittests.conf
> provided accel. That's all fine as long as the user always specifies
> the ACCEL env variable.
> 
> If that's not the case and KVM is not available or if a test specifies
> tcg and we start a qemu with the kvm acceleration as it's the default
> we'll run into problems.
> 
> So let's fetch the accelerator before calling the arch/run script and
> check it against the test's specified accel. Yes, we now do that
> twice, once in the run_tests.sh and one in arch/run, but I don't think
> there's a good way around it since you can execute arch/run
> without run_tests.sh.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  run_tests.sh          |  6 ++++
>  s390x/run             |  6 +++-
>  scripts/accel.bash    | 63 +++++++++++++++++++++++++++++++++++++++++
>  scripts/arch-run.bash | 66 ++-----------------------------------------
>  scripts/runtime.bash  |  2 +-
>  5 files changed, 77 insertions(+), 66 deletions(-)
>  create mode 100644 scripts/accel.bash
> 
> diff --git a/run_tests.sh b/run_tests.sh
> index 65108e73..9ccb97bd 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -10,6 +10,7 @@ if [ ! -f config.mak ]; then
>  fi
>  source config.mak
>  source scripts/common.bash
> +source scripts/accel.bash
>  
>  function usage()
>  {
> @@ -164,6 +165,11 @@ if [[ $tap_output == "yes" ]]; then
>      echo "TAP version 13"
>  fi
>  
> +qemu=$(search_qemu_binary)
> +if [ -z "$ACCEL" ]; then
> +    ACCEL=$(get_qemu_accelerator)
> +fi
> +
>  trap "wait; exit 130" SIGINT
>  
>  (
> diff --git a/s390x/run b/s390x/run
> index 2ec6da70..df7ef5ca 100755
> --- a/s390x/run
> +++ b/s390x/run
> @@ -12,8 +12,12 @@ fi
>  qemu=$(search_qemu_binary) ||
>  	exit $?
>  
> -ACCEL=$(get_qemu_accelerator) ||
> +if [ -z "$DEF_ACCEL "]; then
> +    ACCEL=$(get_qemu_accelerator) ||
>  	exit $?
> +else
> +    ACCEL=$DEF_ACCEL
> +fi
>  
>  M='-machine s390-ccw-virtio'
>  M+=",accel=$ACCEL"
> diff --git a/scripts/accel.bash b/scripts/accel.bash
> new file mode 100644
> index 00000000..ea12412a
> --- /dev/null
> +++ b/scripts/accel.bash
> @@ -0,0 +1,63 @@
> +search_qemu_binary ()
> +{
> +	local save_path=$PATH
> +	local qemucmd qemu
> +
> +	export PATH=$PATH:/usr/libexec
> +	for qemucmd in ${QEMU:-qemu-system-$ARCH_NAME qemu-kvm}; do
> +		if $qemucmd --help 2>/dev/null | grep -q 'QEMU'; then
> +			qemu="$qemucmd"
> +			break
> +		fi
> +	done
> +
> +	if [ -z "$qemu" ]; then
> +		echo "A QEMU binary was not found." >&2
> +		echo "You can set a custom location by using the QEMU=<path> environment variable." >&2
> +		return 2
> +	fi
> +	command -v $qemu
> +	export PATH=$save_path
> +}
> +
> +kvm_available ()
> +{
> +	if $($qemu -accel kvm 2> /dev/null); then
> +		return 0;
> +	else
> +		return 1;
> +	fi
> +
> +	[ "$HOST" = "$ARCH_NAME" ] ||
> +		( [ "$HOST" = aarch64 ] && [ "$ARCH" = arm ] ) ||
> +		( [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] )
> +}
> +
> +hvf_available ()
> +{
> +	[ "$(sysctl -n kern.hv_support 2>/dev/null)" = "1" ] || return 1
> +	[ "$HOST" = "$ARCH_NAME" ] ||
> +		( [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] )
> +}
> +
> +get_qemu_accelerator ()
> +{
> +	if [ "$ACCEL" = "kvm" ] && ! kvm_available; then
> +		echo "KVM is needed, but not available on this host" >&2
> +		return 2
> +	fi
> +	if [ "$ACCEL" = "hvf" ] && ! hvf_available; then
> +		echo "HVF is needed, but not available on this host" >&2
> +		return 2
> +	fi
> +
> +	if [ "$ACCEL" ]; then
> +		echo $ACCEL
> +	elif kvm_available; then
> +		echo kvm
> +	elif hvf_available; then
> +		echo hvf
> +	else
> +		echo tcg
> +	fi
> +}
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 8cc9a61e..85c07792 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -24,6 +24,8 @@
>  # 1..127 - FAILURE (could be QEMU, a run script, or the unittest)
>  # >= 128 - Signal (signum = status - 128)
>  ##############################################################################
> +source scripts/accel.bash
> +
>  run_qemu ()
>  {
>  	local stdout errors ret sig
> @@ -171,28 +173,6 @@ migration_cmd ()
>  	fi
>  }
>  
> -search_qemu_binary ()
> -{
> -	local save_path=$PATH
> -	local qemucmd qemu
> -
> -	export PATH=$PATH:/usr/libexec
> -	for qemucmd in ${QEMU:-qemu-system-$ARCH_NAME qemu-kvm}; do
> -		if $qemucmd --help 2>/dev/null | grep -q 'QEMU'; then
> -			qemu="$qemucmd"
> -			break
> -		fi
> -	done
> -
> -	if [ -z "$qemu" ]; then
> -		echo "A QEMU binary was not found." >&2
> -		echo "You can set a custom location by using the QEMU=<path> environment variable." >&2
> -		return 2
> -	fi
> -	command -v $qemu
> -	export PATH=$save_path
> -}
> -
>  initrd_create ()
>  {
>  	if [ "$ENVIRON_DEFAULT" = "yes" ]; then
> @@ -339,45 +319,3 @@ trap_exit_push ()
>  	local old_exit=$(trap -p EXIT | sed "s/^[^']*'//;s/'[^']*$//")
>  	trap -- "$1; $old_exit" EXIT
>  }
> -
> -kvm_available ()
> -{
> -	if $($qemu -accel kvm 2> /dev/null); then
> -		return 0;
> -	else
> -		return 1;
> -	fi
> -
> -	[ "$HOST" = "$ARCH_NAME" ] ||
> -		( [ "$HOST" = aarch64 ] && [ "$ARCH" = arm ] ) ||
> -		( [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] )
> -}
> -
> -hvf_available ()
> -{
> -	[ "$(sysctl -n kern.hv_support 2>/dev/null)" = "1" ] || return 1
> -	[ "$HOST" = "$ARCH_NAME" ] ||
> -		( [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] )
> -}
> -
> -get_qemu_accelerator ()
> -{
> -	if [ "$ACCEL" = "kvm" ] && ! kvm_available; then
> -		echo "KVM is needed, but not available on this host" >&2
> -		return 2
> -	fi
> -	if [ "$ACCEL" = "hvf" ] && ! hvf_available; then
> -		echo "HVF is needed, but not available on this host" >&2
> -		return 2
> -	fi
> -
> -	if [ "$ACCEL" ]; then
> -		echo $ACCEL
> -	elif kvm_available; then
> -		echo kvm
> -	elif hvf_available; then
> -		echo hvf
> -	else
> -		echo tcg
> -	fi
> -}
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 132389c7..5d444db4 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -30,7 +30,7 @@ premature_failure()
>  get_cmdline()
>  {
>      local kernel=$1
> -    echo "TESTNAME=$testname TIMEOUT=$timeout ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $opts"
> +    echo "TESTNAME=$testname TIMEOUT=$timeout DEF_ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $opts"

I think this name change can break any $TEST_DIR/run files that aren't
updated to check DEF_ACCEL. This patch only updates the runner for s390.

Also, it'd be better to do the code movement (scripts/accel.bash) of this
patch separately with a patch that does not have any functional change.

Thanks,
drew

