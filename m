Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A74243A85
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 15:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgHMNJD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 09:09:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43550 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726053AbgHMNJC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Aug 2020 09:09:02 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07DD2nkx012303;
        Thu, 13 Aug 2020 09:09:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=UaUIsI9OtK1Lols709hQrbTJkoZaj5DUrAjlItwEpsA=;
 b=lS8Gu6evF8v3HFlKywXhers2tigGWG0Q17bw72oVQPlYX2IX3tX9ryJPMDFr22nFpthv
 QDUbTwYpI1N+wrdHN0+ZFh1KosEIxRhZqvTDGDiq2MoGq/7opQ+CiTa9oVSJxsi/ouwt
 uHO161KpMwtXmMqzEHmmLK37Am7B95XB3G+G4Rh+QEQr4/LjuUwI8EdnTSQ2mIswzDim
 r6yKYqlHWKAf7/oE2H484Ur0YDjO7lKhawVpOkhtXa91wuQ2QFtJF2PyCV5XplgBGHI8
 DJECYNHo4BUG3PoxBmAcskaG0CThMvIud4c+HHiUY87PdTPl1KYqVRrJYTlZ/SwfDL6c vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32w30q5s0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 09:09:00 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07DD7GxM032236;
        Thu, 13 Aug 2020 09:08:59 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32w30q5ry6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 09:08:59 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07DD6lnP006746;
        Thu, 13 Aug 2020 13:08:57 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 32skp7uen3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 13:08:56 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07DD8sjE25231804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Aug 2020 13:08:54 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C9AEA4040;
        Thu, 13 Aug 2020 13:08:54 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E0B1A404D;
        Thu, 13 Aug 2020 13:08:53 +0000 (GMT)
Received: from marcibm (unknown [9.145.178.142])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 13 Aug 2020 13:08:53 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests RFC v2 4/4] s390x: add Protected VM support
In-Reply-To: <20200813135642.4f493049.cohuck@redhat.com>
References: <20200812092705.17774-1-mhartmay@linux.ibm.com> <20200812092705.17774-5-mhartmay@linux.ibm.com> <20200813135642.4f493049.cohuck@redhat.com>
Date:   Thu, 13 Aug 2020 15:08:51 +0200
Message-ID: <87d03uhevw.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-13_10:2020-08-13,2020-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0 suspectscore=2
 impostorscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008130094
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 13, 2020 at 01:56 PM +0200, Cornelia Huck <cohuck@redhat.com> w=
rote:
> On Wed, 12 Aug 2020 11:27:05 +0200
> Marc Hartmayer <mhartmay@linux.ibm.com> wrote:
>
>> Add support for Protected Virtual Machine (PVM) tests. For starting a
>> PVM guest we must be able to generate a PVM image by using the
>> `genprotimg` tool from the s390-tools collection. This requires the
>> ability to pass a machine-specific host-key document, so the option
>> `--host-key-document` is added to the configure script.
>>=20
>> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> ---
>>  configure               |  8 ++++++++
>>  s390x/Makefile          | 17 +++++++++++++++--
>>  s390x/selftest.parmfile |  1 +
>>  s390x/unittests.cfg     |  1 +
>>  scripts/s390x/func.bash | 18 ++++++++++++++++++
>>  5 files changed, 43 insertions(+), 2 deletions(-)
>>  create mode 100644 s390x/selftest.parmfile
>>  create mode 100644 scripts/s390x/func.bash
>>=20
>> diff --git a/configure b/configure
>> index f9d030fd2f03..aa528af72534 100755
>> --- a/configure
>> +++ b/configure
>> @@ -18,6 +18,7 @@ u32_long=3D
>>  vmm=3D"qemu"
>>  errata_force=3D0
>>  erratatxt=3D"$srcdir/errata.txt"
>> +host_key_document=3D
>>=20=20
>>  usage() {
>>      cat <<-EOF
>> @@ -40,6 +41,8 @@ usage() {
>>  	                           no environ is provided by the user (enabled=
 by default)
>>  	    --erratatxt=3DFILE       specify a file to use instead of errata.t=
xt. Use
>>  	                           '--erratatxt=3D' to ensure no file is used.
>> +	    --host-key-document=3DHOST_KEY_DOCUMENT
>> +	                           host-key-document to use (s390x only)
>
> Maybe a bit more verbose? If I see only this option, I have no idea
> what it is used for and where to get it.

=E2=80=9CSpecifies the machine-specific host-key document required to creat=
e a
PVM image using the `genprotimg` tool from the s390-tools collection
(s390x only)=E2=80=9D

Better?

>
>>  EOF
>>      exit 1
>>  }
>> @@ -92,6 +95,9 @@ while [[ "$1" =3D -* ]]; do
>>  	    erratatxt=3D
>>  	    [ "$arg" ] && erratatxt=3D$(eval realpath "$arg")
>>  	    ;;
>> +	--host-key-document)
>> +	    host_key_document=3D"$arg"
>> +	    ;;
>>  	--help)
>>  	    usage
>>  	    ;;
>> @@ -205,6 +211,8 @@ PRETTY_PRINT_STACKS=3D$pretty_print_stacks
>>  ENVIRON_DEFAULT=3D$environ_default
>>  ERRATATXT=3D$erratatxt
>>  U32_LONG_FMT=3D$u32_long
>> +GENPROTIMG=3D${GENPROTIMG-genprotimg}
>> +HOST_KEY_DOCUMENT=3D$host_key_document
>>  EOF
>>=20=20
>>  cat <<EOF > lib/config.h
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index 0f54bf43bfb7..cd4e270952ec 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -18,12 +18,19 @@ tests +=3D $(TEST_DIR)/skrf.elf
>>  tests +=3D $(TEST_DIR)/smp.elf
>>  tests +=3D $(TEST_DIR)/sclp.elf
>>  tests +=3D $(TEST_DIR)/css.elf
>> -tests_binary =3D $(patsubst %.elf,%.bin,$(tests))
>>=20=20
>> -all: directories test_cases test_cases_binary
>> +tests_binary =3D $(patsubst %.elf,%.bin,$(tests))
>> +ifneq ($(HOST_KEY_DOCUMENT),)
>> +tests_pv_binary =3D $(patsubst %.bin,%.pv.bin,$(tests_binary))
>> +else
>> +tests_pv_binary =3D
>> +endif
>> +
>> +all: directories test_cases test_cases_binary test_cases_pv
>>=20=20
>>  test_cases: $(tests)
>>  test_cases_binary: $(tests_binary)
>> +test_cases_pv: $(tests_pv_binary)
>>=20=20
>>  CFLAGS +=3D -std=3Dgnu99
>>  CFLAGS +=3D -ffreestanding
>> @@ -72,6 +79,12 @@ FLATLIBS =3D $(libcflat)
>>  %.bin: %.elf
>>  	$(OBJCOPY) -O binary  $< $@
>>=20=20
>> +%selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bi=
n,%.parmfile,$@)
>> +	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --parmfile $(pa=
tsubst %.pv.bin,%.parmfile,$@) --no-verify --image $< -o $@
>> +
>> +%.pv.bin: %.bin $(HOST_KEY_DOCUMENT)
>> +	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify --i=
mage $< -o $@
>> +
>>  arch_clean: asm_offsets_clean
>>  	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d lib/s390x/.*.d
>>=20=20
>> diff --git a/s390x/selftest.parmfile b/s390x/selftest.parmfile
>> new file mode 100644
>> index 000000000000..5613931aa5c6
>> --- /dev/null
>> +++ b/s390x/selftest.parmfile
>> @@ -0,0 +1 @@
>> +test 123
>> \ No newline at end of file
>
> Maybe add one? :)

No, this=E2=80=99s intended, otherwise the test case fails.

>
>> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
>> index 0f156afbe741..12f6fb613995 100644
>> --- a/s390x/unittests.cfg
>> +++ b/s390x/unittests.cfg
>> @@ -21,6 +21,7 @@
>>  [selftest-setup]
>>  file =3D selftest.elf
>>  groups =3D selftest
>> +# please keep the kernel cmdline in sync with $(TEST_DIR)/selftest.parm=
file
>>  extra_params =3D -append 'test 123'
>>=20=20
>>  [intercept]
>> diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
>> new file mode 100644
>> index 000000000000..5c682cb47f73
>> --- /dev/null
>> +++ b/scripts/s390x/func.bash
>> @@ -0,0 +1,18 @@
>> +# Run Protected VM test
>> +function arch_cmd()
>> +{
>> +	local cmd=3D$1
>> +	local testname=3D$2
>> +	local groups=3D$3
>> +	local smp=3D$4
>> +	local kernel=3D$5
>> +	local opts=3D$6
>> +	local arch=3D$7
>> +	local check=3D$8
>> +	local accel=3D$9
>> +	local timeout=3D${10}
>> +
>> +	kernel=3D${kernel%.elf}.pv.bin
>> +	# do not run PV test cases by default
>> +	"$cmd" "${testname}_PV" "$groups pv nodefault" "$smp" "$kernel" "$opts=
" "$arch" "$check" "$accel" "$timeout"
>
> If we don't run this test, can we maybe print some informative message
> like "PV tests not run; specify --host-key-document to enable" or so?
> (At whichever point that makes the most sense.)

Currently, the output looks like this:

$ ./run_tests.sh=20=20=20=20
PASS selftest-setup (14 tests)
SKIP selftest-setup_PV (test marked as manual run only)
PASS intercept (20 tests)
SKIP intercept_PV (test marked as manual run only)
=E2=80=A6

And if you=E2=80=99re trying to run the PV tests without specifying the hos=
t-key
document it results in:

$ ./run_tests.sh -a
PASS selftest-setup (14 tests)
FAIL selftest-setup_PV=20
PASS intercept (20 tests)
FAIL intercept_PV=20
=E2=80=A6

But if you like I can return a hint that the PVM image was not
generated. Should the PV test case then be skipped?

>
>> +}
>
--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
