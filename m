Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1521C7218
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 15:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgEFNur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 09:50:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40022 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725966AbgEFNur (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 09:50:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588773044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ydaIFwMMzx0j2HtzhBzJ331DU6hPIzZi0BzXXWc1Q4k=;
        b=Hj2TuodZCAcYlU/ybs1RUbMcrhklyXigqyC2znY27MwI8DnObSDrANzksOpxd9bos1I/1U
        wRdPp9biPprID+P78P7Sqe8FCAz0w5N0jZPNALyNk9z8CUmLtOXS2r4zXIbMbFzwCmH9P8
        l+Em1c9DEXCGN0vNs+CEdEwHmim1oM4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-sftRZzvDNZCzlUtB6xVtGA-1; Wed, 06 May 2020 09:50:42 -0400
X-MC-Unique: sftRZzvDNZCzlUtB6xVtGA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B5F3835B8C;
        Wed,  6 May 2020 13:50:41 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.195.220])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F06E0707D6;
        Wed,  6 May 2020 13:50:19 +0000 (UTC)
Date:   Wed, 6 May 2020 15:50:16 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests RFC] s390x: Add Protected VM support
Message-ID: <20200506135016.ml3k73siokhltyl5@kamzik.brq.redhat.com>
References: <20200506124636.21876-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506124636.21876-1-mhartmay@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 06, 2020 at 02:46:36PM +0200, Marc Hartmayer wrote:
> Add support for Protected Virtual Machine (PVM) tests. For starting a
> PVM guest we must be able to generate a PVM image by using the
> `genprotimg` tool from the s390-tools collection. This requires the
> ability to pass a machine-specific host-key document, so the option
> `--host-key-document` is added to the configure script.
> 
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>  .gitignore          |  1 +
>  configure           |  8 ++++++++
>  s390x/Makefile      | 16 +++++++++++++---
>  s390x/unittests.cfg | 20 ++++++++++++++++++++
>  scripts/common.bash | 30 +++++++++++++++++++++++++++++-
>  5 files changed, 71 insertions(+), 4 deletions(-)
> 
> diff --git a/.gitignore b/.gitignore
> index 784cb2ddbcb8..1fa5c0c0ea76 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -4,6 +4,7 @@
>  *.o
>  *.flat
>  *.elf
> +*.img
>  .pc
>  patches
>  .stgit-*
> diff --git a/configure b/configure
> index 5d2cd90cd180..29191f4b0994 100755
> --- a/configure
> +++ b/configure
> @@ -18,6 +18,7 @@ u32_long=
>  vmm="qemu"
>  errata_force=0
>  erratatxt="errata.txt"
> +host_key_document=
>  
>  usage() {
>      cat <<-EOF
> @@ -40,6 +41,8 @@ usage() {
>  	                           no environ is provided by the user (enabled by default)
>  	    --erratatxt=FILE       specify a file to use instead of errata.txt. Use
>  	                           '--erratatxt=' to ensure no file is used.
> +	    --host-key-document=HOST_KEY_DOCUMENT
> +	                           host-key-document to use (s390x only)
>  EOF
>      exit 1
>  }
> @@ -91,6 +94,9 @@ while [[ "$1" = -* ]]; do
>  	--erratatxt)
>  	    erratatxt="$arg"
>  	    ;;
> +	--host-key-document)
> +	    host_key_document="$arg"
> +	    ;;
>  	--help)
>  	    usage
>  	    ;;
> @@ -207,6 +213,8 @@ PRETTY_PRINT_STACKS=$pretty_print_stacks
>  ENVIRON_DEFAULT=$environ_default
>  ERRATATXT=$erratatxt
>  U32_LONG_FMT=$u32_long
> +GENPROTIMG=genprotimg
> +HOST_KEY_DOCUMENT=$host_key_document
>  EOF
>  
>  cat <<EOF > lib/config.h
> diff --git a/s390x/Makefile b/s390x/Makefile
> index ddb4b48ecbf9..a57655dcce10 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -17,12 +17,19 @@ tests += $(TEST_DIR)/stsi.elf
>  tests += $(TEST_DIR)/skrf.elf
>  tests += $(TEST_DIR)/smp.elf
>  tests += $(TEST_DIR)/sclp.elf
> -tests_binary = $(patsubst %.elf,%.bin,$(tests))
>  
> -all: directories test_cases test_cases_binary
> +tests_binary = $(patsubst %.elf,%.bin,$(tests))
> +ifneq ($(HOST_KEY_DOCUMENT),)
> +tests_pv_img = $(patsubst %.elf,%.pv.img,$(tests))
> +else
> +tests_pv_img =
> +endif
> +
> +all: directories test_cases test_cases_binary test_cases_pv
>  
>  test_cases: $(tests)
>  test_cases_binary: $(tests_binary)
> +test_cases_pv: $(tests_pv_img)
>  
>  CFLAGS += -std=gnu99
>  CFLAGS += -ffreestanding
> @@ -68,8 +75,11 @@ FLATLIBS = $(libcflat)
>  %.bin: %.elf
>  	$(OBJCOPY) -O binary  $< $@
>  
> +%.pv.img: %.bin $(HOST_KEY_DOCUMENT)
> +	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify --image $< -o $@
> +
>  arch_clean: asm_offsets_clean
> -	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d lib/s390x/.*.d
> +	$(RM) $(TEST_DIR)/*.{o,elf,bin,img} $(TEST_DIR)/.*.d lib/s390x/.*.d
>  
>  generated-files = $(asm-offsets)
>  $(tests:.elf=.o) $(cstart.o) $(cflatobjs): $(generated-files)
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index b307329354f6..6beaca45fb20 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -16,6 +16,8 @@
>  #			 # a test. The check line can contain multiple files
>  #			 # to check separated by a space but each check
>  #			 # parameter needs to be of the form <path>=<value>
> +# pv_support = 0|1       # Optionally specify whether a test supports the
> +#                        # execution as a PV guest.

Maybe pv_supported vs. pv_support?

>  ##############################################################################
>  
>  [selftest-setup]
> @@ -25,62 +27,80 @@ extra_params = -append 'test 123'
>  
>  [intercept]
>  file = intercept.elf
> +pv_support = 1
>  
>  [emulator]
>  file = emulator.elf
> +pv_support = 1
>  
>  [sieve]
>  file = sieve.elf
>  groups = selftest
>  # can take fairly long when KVM is nested inside z/VM
>  timeout = 600
> +pv_support = 1
>  
>  [sthyi]
>  file = sthyi.elf
> +pv_support = 1
>  
>  [skey]
>  file = skey.elf
> +pv_support = 1
>  
>  [diag10]
>  file = diag10.elf
> +pv_support = 1
>  
>  [diag308]
>  file = diag308.elf
> +pv_support = 1
>  
>  [pfmf]
>  file = pfmf.elf
> +pv_support = 1
>  
>  [cmm]
>  file = cmm.elf
> +pv_support = 1
>  
>  [vector]
>  file = vector.elf
> +pv_support = 1
>  
>  [gs]
>  file = gs.elf
> +pv_support = 1
>  
>  [iep]
>  file = iep.elf
> +pv_support = 1
>  
>  [cpumodel]
>  file = cpumodel.elf
> +pv_support = 1
>  
>  [diag288]
>  file = diag288.elf
>  extra_params=-device diag288,id=watchdog0 --watchdog-action inject-nmi
> +pv_support = 1
>  
>  [stsi]
>  file = stsi.elf
>  extra_params=-name kvm-unit-test --uuid 0fb84a86-727c-11ea-bc55-0242ac130003 -smp 1,maxcpus=8
> +pv_support = 1
>  
>  [smp]
>  file = smp.elf
>  smp = 2
> +pv_support = 1
>  
>  [sclp-1g]
>  file = sclp.elf
>  extra_params = -m 1G
> +pv_support = 1
>  
>  [sclp-3g]
>  file = sclp.elf
>  extra_params = -m 3G
> +pv_support = 1
> diff --git a/scripts/common.bash b/scripts/common.bash
> index 9a6ebbd7f287..971d0661287c 100644
> --- a/scripts/common.bash
> +++ b/scripts/common.bash
> @@ -1,3 +1,20 @@
> +function pv_cmd ()
> +{
> +	local cmd=$1
> +	local testname=$2
> +	local groups=$3
> +	local smp=$4
> +	local kernel=$5
> +	local opts=$6
> +	local arch=$7
> +	local check=$8
> +	local accel=$9
> +	local timeout=${10}
> +
> +	kernel=${kernel%.elf}.pv.img
> +	# do not run the PV test cases by default
> +	"$cmd" "${testname}_PV" "$groups pv nodefault" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
> +}
>  
>  function for_each_unittest()
>  {
> @@ -12,12 +29,16 @@ function for_each_unittest()
>  	local check
>  	local accel
>  	local timeout
> +	local pv_support
>  
>  	exec {fd}<"$unittests"
>  
>  	while read -r -u $fd line; do
>  		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
> -			"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
> +			if [ "${pv_support}" == 1 ]; then
> +				pv_cmd "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
> +			fi
> +
>  			testname=${BASH_REMATCH[1]}
>  			smp=1
>  			kernel=""
> @@ -27,6 +48,7 @@ function for_each_unittest()
>  			check=""
>  			accel=""
>  			timeout=""
> +			pv_support=""
>  		elif [[ $line =~ ^file\ *=\ *(.*)$ ]]; then
>  			kernel=$TEST_DIR/${BASH_REMATCH[1]}
>  		elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
> @@ -43,8 +65,14 @@ function for_each_unittest()
>  			accel=${BASH_REMATCH[1]}
>  		elif [[ $line =~ ^timeout\ *=\ *(.*)$ ]]; then
>  			timeout=${BASH_REMATCH[1]}
> +		elif [[ $line =~ ^pv_support\ *=\ *(.*)$ ]]; then
> +			pv_support=${BASH_REMATCH[1]}
>  		fi
>  	done
> +
>  	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
> +	if [ "${pv_support}" == 1 ]; then
> +		pv_cmd "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
> +	fi
>  	exec {fd}<&-
>  }
> -- 
> 2.17.0
>

I don't think making the changes to scripts/common.bash will work for
standalone tests. Why not do this stuff in s390x/run instead? Also,
do you need the pv_support[ed] parameter? You could just do a
[ -f "${kernel%.elf}.pv.img" ] to decide if you should run again
with PV, right?

Thanks,
drew

