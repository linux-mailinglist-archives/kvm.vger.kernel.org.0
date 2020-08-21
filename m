Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4298824D478
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 13:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbgHULuU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 07:50:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22160 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728533AbgHULrs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Aug 2020 07:47:48 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LBVk7l096336;
        Fri, 21 Aug 2020 07:47:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=YepbGdf680li5Nsp+gkpuGGE/6+5+ZDG8FcNxFbWS7M=;
 b=ARIpHdCwK0Wrx9EKBbMu4ctjahaMd+27esNB8JMaJ+Z4diugR2stN8cKR+TI1Jxl7xSV
 eueIP7huSAitMer7xd4ERpnFDAxWA15tiD6TPVhNgT9t2ACscF0zD0U6YcfgslST29yY
 CKBeP0eVXAWpLg607JIAJHtc+2M0pwpNEBUIZ7s2TBp8UZtqamZXUbYsOH/UdS0crVYS
 OuEU9sGPYxFtt5kf6sAlcx96+yaHD5k8XSyCv9TS9J7vSFt2u9d+6Qia6kp7mVaypOVl
 v3cz4wO+ktgwDphMMVYYIFuXLzLqVQQxd+J9si8EOJlilbvYgPy7uLUIqyczc8RG6NOz sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3329c3ejad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 07:47:39 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07LBVmjt096472;
        Fri, 21 Aug 2020 07:47:39 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3329c3ej9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 07:47:39 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07LBdpxh018612;
        Fri, 21 Aug 2020 11:47:37 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3313xbhgfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 11:47:36 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07LBlXhE31130012
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 11:47:34 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2425A405F;
        Fri, 21 Aug 2020 11:47:33 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5DEB2A4066;
        Fri, 21 Aug 2020 11:47:33 +0000 (GMT)
Received: from marcibm (unknown [9.145.60.23])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 21 Aug 2020 11:47:33 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 4/4] s390x: add Protected VM support
In-Reply-To: <20200818130424.20522-5-mhartmay@linux.ibm.com>
References: <20200818130424.20522-1-mhartmay@linux.ibm.com> <20200818130424.20522-5-mhartmay@linux.ibm.com>
Date:   Fri, 21 Aug 2020 13:47:32 +0200
Message-ID: <878se8fcff.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_06:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0
 adultscore=0 suspectscore=1 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 18, 2020 at 03:04 PM +0200, Marc Hartmayer <mhartmay@linux.ibm.=
com> wrote:
> Add support for Protected Virtual Machine (PVM) tests. For starting a
> PVM guest we must be able to generate a PVM image by using the
> `genprotimg` tool from the s390-tools collection. This requires the
> ability to pass a machine-specific host-key document, so the option
> `--host-key-document` is added to the configure script.
>
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>  configure               |  9 +++++++++
>  s390x/Makefile          | 17 +++++++++++++++--
>  s390x/selftest.parmfile |  1 +
>  s390x/unittests.cfg     |  1 +
>  scripts/s390x/func.bash | 35 +++++++++++++++++++++++++++++++++++
>  5 files changed, 61 insertions(+), 2 deletions(-)
>  create mode 100644 s390x/selftest.parmfile
>  create mode 100644 scripts/s390x/func.bash
>
> diff --git a/configure b/configure
> index f9d030fd2f03..0e64af58b3c1 100755
> --- a/configure
> +++ b/configure
> @@ -18,6 +18,7 @@ u32_long=3D
>  vmm=3D"qemu"
>  errata_force=3D0
>  erratatxt=3D"$srcdir/errata.txt"
> +host_key_document=3D
>
>  usage() {
>      cat <<-EOF
> @@ -40,6 +41,9 @@ usage() {
>  	                           no environ is provided by the user (enabled =
by default)
>  	    --erratatxt=3DFILE       specify a file to use instead of errata.tx=
t. Use
>  	                           '--erratatxt=3D' to ensure no file is used.
> +	    --host-key-document=3DHOST_KEY_DOCUMENT
> +	                           Specify the machine-specific host-key docume=
nt for creating
> +	                           a PVM image with 'genprotimg' (s390x only)
>  EOF
>      exit 1
>  }
> @@ -92,6 +96,9 @@ while [[ "$1" =3D -* ]]; do
>  	    erratatxt=3D
>  	    [ "$arg" ] && erratatxt=3D$(eval realpath "$arg")
>  	    ;;
> +	--host-key-document)
> +	    host_key_document=3D"$arg"
> +	    ;;
>  	--help)
>  	    usage
>  	    ;;
> @@ -205,6 +212,8 @@ PRETTY_PRINT_STACKS=3D$pretty_print_stacks
>  ENVIRON_DEFAULT=3D$environ_default
>  ERRATATXT=3D$erratatxt
>  U32_LONG_FMT=3D$u32_long
> +GENPROTIMG=3D${GENPROTIMG-genprotimg}
> +HOST_KEY_DOCUMENT=3D$host_key_document
>  EOF
>
>  cat <<EOF > lib/config.h
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 0f54bf43bfb7..cd4e270952ec 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -18,12 +18,19 @@ tests +=3D $(TEST_DIR)/skrf.elf
>  tests +=3D $(TEST_DIR)/smp.elf
>  tests +=3D $(TEST_DIR)/sclp.elf
>  tests +=3D $(TEST_DIR)/css.elf
> -tests_binary =3D $(patsubst %.elf,%.bin,$(tests))
>
> -all: directories test_cases test_cases_binary
> +tests_binary =3D $(patsubst %.elf,%.bin,$(tests))
> +ifneq ($(HOST_KEY_DOCUMENT),)
> +tests_pv_binary =3D $(patsubst %.bin,%.pv.bin,$(tests_binary))
> +else
> +tests_pv_binary =3D
> +endif
> +
> +all: directories test_cases test_cases_binary test_cases_pv
>
>  test_cases: $(tests)
>  test_cases_binary: $(tests_binary)
> +test_cases_pv: $(tests_pv_binary)
>
>  CFLAGS +=3D -std=3Dgnu99
>  CFLAGS +=3D -ffreestanding
> @@ -72,6 +79,12 @@ FLATLIBS =3D $(libcflat)
>  %.bin: %.elf
>  	$(OBJCOPY) -O binary  $< $@
>
> +%selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin=
,%.parmfile,$@)
> +	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --parmfile $(pat=
subst %.pv.bin,%.parmfile,$@) --no-verify --image $< -o $@
> +
> +%.pv.bin: %.bin $(HOST_KEY_DOCUMENT)
> +	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify --im=
age $< -o $@
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
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 0f156afbe741..12f6fb613995 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -21,6 +21,7 @@
>  [selftest-setup]
>  file =3D selftest.elf
>  groups =3D selftest
> +# please keep the kernel cmdline in sync with $(TEST_DIR)/selftest.parmf=
ile
>  extra_params =3D -append 'test 123'
>
>  [intercept]
> diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
> new file mode 100644
> index 000000000000..b2d59d0d6f25
> --- /dev/null
> +++ b/scripts/s390x/func.bash
> @@ -0,0 +1,35 @@
> +# The file scripts/common.bash has to be the only file sourcing this
> +# arch helper file
> +source config.mak
> +
> +ARCH_CMD=3Darch_cmd_s390x
> +
> +function arch_cmd_s390x()
> +{
> +	local cmd=3D$1
> +	local testname=3D$2
> +	local groups=3D$3
> +	local smp=3D$4
> +	local kernel=3D$5
> +	local opts=3D$6
> +	local arch=3D$7
> +	local check=3D$8
> +	local accel=3D$9
> +	local timeout=3D${10}
> +
> +	# run the normal test case
> +	"$cmd" "${testname}" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check=
" "$accel" "$timeout"
> +
> +	# run PV test case
> +	kernel=3D${kernel%.elf}.pv.bin
> +	if [ ! -f "${kernel}" ]; then
> +		if [ -z "${HOST_KEY_DOCUMENT}" ]; then
> +			print_result 'SKIP' $testname '(no host-key document specified)'

One argument for =E2=80=98print_result=E2=80=98 is missing and $testname ha=
s to be
${testname}_PV.

> +			return 2
> +		fi
> +
> +		print_result 'SKIP' $testname '(PVM image was not created)'

=E2=80=A6and here as well. I=E2=80=99ll fix it.

> +		return 2
> +	fi
> +	"$cmd" "${testname}_PV" "$groups pv" "$smp" "$kernel" "$opts" "$arch" "=
$check" "$accel" "$timeout"
> +}
> --=20
> 2.25.4
>
--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
