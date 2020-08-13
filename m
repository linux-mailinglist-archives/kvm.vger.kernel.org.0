Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24968243983
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 13:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgHML6c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 07:58:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25240 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726635AbgHML4y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Aug 2020 07:56:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597319812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T2adinmHfJvUDKoCJtxWeLxcPFFPkkiVZwiU0FDrjdQ=;
        b=T3jkHKOaTMYYd2egN1ozoJuvmZo0KTEf0XrMhWT+NPbCMxx7Oj+ZSORx1csG01La3Uxh+Q
        gvgGM9AAg8kFulStYAPSz4doGZzvqTqykGb127THUgS1VhEgoiCa56fDDYV/zHAPqQpX+h
        sU6xK4vFLfISW4AQUrta1j+aS++jZio=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-B6lnio5tNQCiW7c87Xi3lw-1; Thu, 13 Aug 2020 07:56:50 -0400
X-MC-Unique: B6lnio5tNQCiW7c87Xi3lw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8447F800D53;
        Thu, 13 Aug 2020 11:56:49 +0000 (UTC)
Received: from gondolin (ovpn-112-216.ams2.redhat.com [10.36.112.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E1FEB60BFA;
        Thu, 13 Aug 2020 11:56:44 +0000 (UTC)
Date:   Thu, 13 Aug 2020 13:56:42 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests RFC v2 4/4] s390x: add Protected VM support
Message-ID: <20200813135642.4f493049.cohuck@redhat.com>
In-Reply-To: <20200812092705.17774-5-mhartmay@linux.ibm.com>
References: <20200812092705.17774-1-mhartmay@linux.ibm.com>
        <20200812092705.17774-5-mhartmay@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 12 Aug 2020 11:27:05 +0200
Marc Hartmayer <mhartmay@linux.ibm.com> wrote:

> Add support for Protected Virtual Machine (PVM) tests. For starting a
> PVM guest we must be able to generate a PVM image by using the
> `genprotimg` tool from the s390-tools collection. This requires the
> ability to pass a machine-specific host-key document, so the option
> `--host-key-document` is added to the configure script.
> 
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>  configure               |  8 ++++++++
>  s390x/Makefile          | 17 +++++++++++++++--
>  s390x/selftest.parmfile |  1 +
>  s390x/unittests.cfg     |  1 +
>  scripts/s390x/func.bash | 18 ++++++++++++++++++
>  5 files changed, 43 insertions(+), 2 deletions(-)
>  create mode 100644 s390x/selftest.parmfile
>  create mode 100644 scripts/s390x/func.bash
> 
> diff --git a/configure b/configure
> index f9d030fd2f03..aa528af72534 100755
> --- a/configure
> +++ b/configure
> @@ -18,6 +18,7 @@ u32_long=
>  vmm="qemu"
>  errata_force=0
>  erratatxt="$srcdir/errata.txt"
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

Maybe a bit more verbose? If I see only this option, I have no idea
what it is used for and where to get it.

>  EOF
>      exit 1
>  }
> @@ -92,6 +95,9 @@ while [[ "$1" = -* ]]; do
>  	    erratatxt=
>  	    [ "$arg" ] && erratatxt=$(eval realpath "$arg")
>  	    ;;
> +	--host-key-document)
> +	    host_key_document="$arg"
> +	    ;;
>  	--help)
>  	    usage
>  	    ;;
> @@ -205,6 +211,8 @@ PRETTY_PRINT_STACKS=$pretty_print_stacks
>  ENVIRON_DEFAULT=$environ_default
>  ERRATATXT=$erratatxt
>  U32_LONG_FMT=$u32_long
> +GENPROTIMG=${GENPROTIMG-genprotimg}
> +HOST_KEY_DOCUMENT=$host_key_document
>  EOF
>  
>  cat <<EOF > lib/config.h
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 0f54bf43bfb7..cd4e270952ec 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -18,12 +18,19 @@ tests += $(TEST_DIR)/skrf.elf
>  tests += $(TEST_DIR)/smp.elf
>  tests += $(TEST_DIR)/sclp.elf
>  tests += $(TEST_DIR)/css.elf
> -tests_binary = $(patsubst %.elf,%.bin,$(tests))
>  
> -all: directories test_cases test_cases_binary
> +tests_binary = $(patsubst %.elf,%.bin,$(tests))
> +ifneq ($(HOST_KEY_DOCUMENT),)
> +tests_pv_binary = $(patsubst %.bin,%.pv.bin,$(tests_binary))
> +else
> +tests_pv_binary =
> +endif
> +
> +all: directories test_cases test_cases_binary test_cases_pv
>  
>  test_cases: $(tests)
>  test_cases_binary: $(tests_binary)
> +test_cases_pv: $(tests_pv_binary)
>  
>  CFLAGS += -std=gnu99
>  CFLAGS += -ffreestanding
> @@ -72,6 +79,12 @@ FLATLIBS = $(libcflat)
>  %.bin: %.elf
>  	$(OBJCOPY) -O binary  $< $@
>  
> +%selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin,%.parmfile,$@)
> +	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --parmfile $(patsubst %.pv.bin,%.parmfile,$@) --no-verify --image $< -o $@
> +
> +%.pv.bin: %.bin $(HOST_KEY_DOCUMENT)
> +	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify --image $< -o $@
> +
>  arch_clean: asm_offsets_clean
>  	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d lib/s390x/.*.d
>  
> diff --git a/s390x/selftest.parmfile b/s390x/selftest.parmfile
> new file mode 100644
> index 000000000000..5613931aa5c6
> --- /dev/null
> +++ b/s390x/selftest.parmfile
> @@ -0,0 +1 @@
> +test 123
> \ No newline at end of file

Maybe add one? :)

> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 0f156afbe741..12f6fb613995 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -21,6 +21,7 @@
>  [selftest-setup]
>  file = selftest.elf
>  groups = selftest
> +# please keep the kernel cmdline in sync with $(TEST_DIR)/selftest.parmfile
>  extra_params = -append 'test 123'
>  
>  [intercept]
> diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
> new file mode 100644
> index 000000000000..5c682cb47f73
> --- /dev/null
> +++ b/scripts/s390x/func.bash
> @@ -0,0 +1,18 @@
> +# Run Protected VM test
> +function arch_cmd()
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
> +	kernel=${kernel%.elf}.pv.bin
> +	# do not run PV test cases by default
> +	"$cmd" "${testname}_PV" "$groups pv nodefault" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"

If we don't run this test, can we maybe print some informative message
like "PV tests not run; specify --host-key-document to enable" or so?
(At whichever point that makes the most sense.)

> +}

