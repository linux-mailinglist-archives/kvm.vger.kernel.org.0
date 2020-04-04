Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFB419E6BE
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 19:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgDDRWx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Apr 2020 13:22:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48741 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726066AbgDDRWx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Apr 2020 13:22:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586020971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZCCdVWSfV0c6U3cyZbiv8Vt2n/y32og0HL8bxYgBpkY=;
        b=MqtTXC2e0IhvKiE5ISmSW1z+jukHYxSnWZt4EH8v87YTQem3DzwIa4jBBHrD6c2vgnJkMJ
        2/H9m0tBjGQ+jZzs3JuVO8jxb4vIYSuTHK9REfAa8LTP5XHeqFtfRu6sjEdqz+VrfdV1kQ
        3iU44qrv3uK/JkTMXaKI4+dLWBK2HII=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-eVdGsW3UN4SwIXCJ2GcnTg-1; Sat, 04 Apr 2020 13:22:44 -0400
X-MC-Unique: eVdGsW3UN4SwIXCJ2GcnTg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BB2A8017CE;
        Sat,  4 Apr 2020 17:22:43 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FE6BB19A6;
        Sat,  4 Apr 2020 17:22:37 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     lvivier@redhat.com, thuth@redhat.com, david@redhat.com,
        frankja@linux.ibm.com, pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests] arch-run: Add reserved variables to the default environ
Date:   Sat,  4 Apr 2020 19:22:35 +0200
Message-Id: <20200404172235.238065-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the already reserved (see README) variables to the default
environ. To do so neatly we rework the environ creation a bit too.
mkstandalone also learns to honor config.mak as to whether or not
to make environs, and we allow the $ERRATATXT file to be selected
at configure time.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 configure               |  12 +++-
 scripts/arch-run.bash   | 120 ++++++++++++++++++++++++----------------
 scripts/mkstandalone.sh |   4 +-
 3 files changed, 86 insertions(+), 50 deletions(-)

diff --git a/configure b/configure
index 579765165fdf..5e858899987c 100755
--- a/configure
+++ b/configure
@@ -17,6 +17,7 @@ environ_default=3Dyes
 u32_long=3D
 vmm=3D"qemu"
 errata_force=3D0
+erratatxt=3D"errata.txt"
=20
 usage() {
     cat <<-EOF
@@ -37,6 +38,7 @@ usage() {
 	    --[enable|disable]-default-environ
 	                           enable or disable the generation of a defaul=
t environ when
 	                           no environ is provided by the user (enabled =
by default)
+	    --erratatxt=3DFILE       specify a file to use instead of errata.tx=
t
 EOF
     exit 1
 }
@@ -85,6 +87,9 @@ while [[ "$1" =3D -* ]]; do
 	--disable-default-environ)
 	    environ_default=3Dno
 	    ;;
+	--erratatxt)
+	    erratatxt=3D"$arg"
+	    ;;
 	--help)
 	    usage
 	    ;;
@@ -94,6 +99,11 @@ while [[ "$1" =3D -* ]]; do
     esac
 done
=20
+if [ ! -f $erratatxt ]; then
+    echo "erratatxt: $erratatxt does not exist or is not a regular file"
+    exit 1
+fi
+
 arch_name=3D$arch
 [ "$arch" =3D "aarch64" ] && arch=3D"arm64"
 [ "$arch_name" =3D "arm64" ] && arch_name=3D"aarch64"
@@ -194,7 +204,7 @@ FIRMWARE=3D$firmware
 ENDIAN=3D$endian
 PRETTY_PRINT_STACKS=3D$pretty_print_stacks
 ENVIRON_DEFAULT=3D$environ_default
-ERRATATXT=3Derrata.txt
+ERRATATXT=3D$erratatxt
 U32_LONG_FMT=3D$u32_long
 EOF
=20
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index da1a9d7871e5..12bd62399a14 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -29,8 +29,8 @@ run_qemu ()
 	local stdout errors ret sig
=20
 	echo -n "$@"
-	initrd_create &&
-		echo -n " #"
+	initrd_create
+	[ "$ENVIRON_DEFAULT" =3D "yes" ] && echo -n " #"
 	echo " $INITRD"
=20
 	# stdout to {stdout}, stderr to $errors and stderr
@@ -195,60 +195,86 @@ search_qemu_binary ()
=20
 initrd_create ()
 {
-	local ret
-
-	env_add_errata
-	ret=3D$?
+	if [ "$ENVIRON_DEFAULT" =3D "yes" ]; then
+		trap_exit_push 'rm -f $KVM_UNIT_TESTS_ENV; [ "$KVM_UNIT_TESTS_ENV_OLD"=
 ] && export KVM_UNIT_TESTS_ENV=3D"$KVM_UNIT_TESTS_ENV_OLD" || unset KVM_=
UNIT_TESTS_ENV; unset KVM_UNIT_TESTS_ENV_OLD'
+		[ -f "$KVM_UNIT_TESTS_ENV" ] && export KVM_UNIT_TESTS_ENV_OLD=3D"$KVM_=
UNIT_TESTS_ENV"
+		export KVM_UNIT_TESTS_ENV=3D$(mktemp)
+		env_params
+		env_file
+		env_errata
+	fi
=20
 	unset INITRD
 	[ -f "$KVM_UNIT_TESTS_ENV" ] && INITRD=3D"-initrd $KVM_UNIT_TESTS_ENV"
+}
+
+env_add_params ()
+{
+	local p
+
+	for p in "$@"; do
+		if eval test -v $p; then
+			eval export "$p"
+		else
+			eval export "$p=3D"
+		fi
+		grep "^$p=3D" <(env) >>$KVM_UNIT_TESTS_ENV
+	done
+}
=20
-	return $ret
+env_params ()
+{
+	local qemu have_qemu
+	local t1 t2 t3 rest
+
+	qemu=3D$(search_qemu_binary) && have_qemu=3D1
+
+	if [ "$have_qemu" ]; then
+		if [ -n "$ACCEL" ] || [ -n "$QEMU_ACCEL" ]; then
+			[ -n "$ACCEL" ] && QEMU_ACCEL=3D$ACCEL
+		fi
+		QEMU_VERSION_STRING=3D"$($qemu -h | head -1)"
+		IFS=3D'[ .]' read -r t1 t2 t3 QEMU_MAJOR QEMU_MINOR QEMU_MICRO rest <<=
<"$QEMU_VERSION_STRING"
+	fi
+	env_add_params QEMU_ACCEL QEMU_VERSION_STRING QEMU_MAJOR QEMU_MINOR QEM=
U_MICRO
+
+	KERNEL_VERSION_STRING=3D$(uname -r)
+	IFS=3D. read -r KERNEL_VERSION KERNEL_PATCHLEVEL rest <<<"$KERNEL_VERSI=
ON_STRING"
+	IFS=3D- read -r KERNEL_SUBLEVEL KERNEL_EXTRAVERSION <<<"$rest"
+	KERNEL_SUBLEVEL=3D${KERNEL_SUBLEVEL%%[!0-9]*}
+	KERNEL_EXTRAVERSION=3D${KERNEL_EXTRAVERSION%%[!0-9]*}
+	! [[ $KERNEL_SUBLEVEL =3D~ ^[0-9]+$ ]] && unset $KERNEL_SUBLEVEL
+	! [[ $KERNEL_EXTRAVERSION =3D~ ^[0-9]+$ ]] && unset $KERNEL_EXTRAVERSIO=
N
+	env_add_params KERNEL_VERSION_STRING KERNEL_VERSION KERNEL_PATCHLEVEL K=
ERNEL_SUBLEVEL KERNEL_EXTRAVERSION
 }
=20
-env_add_errata ()
+env_file ()
 {
-	local line errata ret=3D1
+	local line var
+
+	[ ! -f "$KVM_UNIT_TESTS_ENV_OLD" ] && return
=20
-	if [ -f "$KVM_UNIT_TESTS_ENV" ] && grep -q '^ERRATA_' <(env); then
-		for line in $(grep '^ERRATA_' "$KVM_UNIT_TESTS_ENV"); do
-			errata=3D${line%%=3D*}
-			[ -n "${!errata}" ] && continue
+	for line in $(grep -E '^[[:blank:]]*[[:alpha:]_][[:alnum:]_]*=3D' "$KVM=
_UNIT_TESTS_ENV_OLD"); do
+		var=3D${line%%=3D*}
+		if ! grep -q "^$var=3D" $KVM_UNIT_TESTS_ENV; then
 			eval export "$line"
-		done
-	elif [ ! -f "$KVM_UNIT_TESTS_ENV" ]; then
+			grep "^$var=3D" <(env) >>$KVM_UNIT_TESTS_ENV
+		fi
+	done
+}
+
+env_errata ()
+{
+	if [ -f "$ERRATATXT" ]; then
 		env_generate_errata
 	fi
-
-	if grep -q '^ERRATA_' <(env); then
-		export KVM_UNIT_TESTS_ENV_OLD=3D"$KVM_UNIT_TESTS_ENV"
-		export KVM_UNIT_TESTS_ENV=3D$(mktemp)
-		trap_exit_push 'rm -f $KVM_UNIT_TESTS_ENV; [ "$KVM_UNIT_TESTS_ENV_OLD"=
 ] && export KVM_UNIT_TESTS_ENV=3D"$KVM_UNIT_TESTS_ENV_OLD" || unset KVM_=
UNIT_TESTS_ENV; unset KVM_UNIT_TESTS_ENV_OLD'
-		[ -f "$KVM_UNIT_TESTS_ENV_OLD" ] && grep -v '^ERRATA_' "$KVM_UNIT_TEST=
S_ENV_OLD" > $KVM_UNIT_TESTS_ENV
-		grep '^ERRATA_' <(env) >> $KVM_UNIT_TESTS_ENV
-		ret=3D0
-	fi
-
-	return $ret
+	sort <(env | grep '^ERRATA_') <(grep '^ERRATA_' $KVM_UNIT_TESTS_ENV) | =
uniq -u >>$KVM_UNIT_TESTS_ENV
 }
=20
 env_generate_errata ()
 {
-	local kernel_version_string=3D$(uname -r)
-	local kernel_version kernel_patchlevel kernel_sublevel kernel_extravers=
ion
 	local line commit minver errata rest v p s x have
=20
-	IFS=3D. read -r kernel_version kernel_patchlevel rest <<<"$kernel_versi=
on_string"
-	IFS=3D- read -r kernel_sublevel kernel_extraversion <<<"$rest"
-	kernel_sublevel=3D${kernel_sublevel%%[!0-9]*}
-	kernel_extraversion=3D${kernel_extraversion%%[!0-9]*}
-
-	! [[ $kernel_sublevel =3D~ ^[0-9]+$ ]] && unset $kernel_sublevel
-	! [[ $kernel_extraversion =3D~ ^[0-9]+$ ]] && unset $kernel_extraversio=
n
-
-	[ "$ENVIRON_DEFAULT" !=3D "yes" ] && return
-	[ ! -f "$ERRATATXT" ] && return
-
 	for line in $(grep -v '^#' "$ERRATATXT" | tr -d '[:blank:]' | cut -d: -=
f1,2); do
 		commit=3D${line%:*}
 		minver=3D${line#*:}
@@ -269,16 +295,16 @@ env_generate_errata ()
 		! [[ $s =3D~ ^[0-9]+$ ]] && unset $s
 		! [[ $x =3D~ ^[0-9]+$ ]] && unset $x
=20
-		if (( $kernel_version > $v ||
-		      ($kernel_version =3D=3D $v && $kernel_patchlevel > $p) )); then
+		if (( $KERNEL_VERSION > $v ||
+		      ($KERNEL_VERSION =3D=3D $v && $KERNEL_PATCHLEVEL > $p) )); then
 			have=3Dy
-		elif (( $kernel_version =3D=3D $v && $kernel_patchlevel =3D=3D $p )); =
then
-			if [ "$kernel_sublevel" ] && [ "$s" ]; then
-				if (( $kernel_sublevel > $s )); then
+		elif (( $KERNEL_VERSION =3D=3D $v && $KERNEL_PATCHLEVEL =3D=3D $p )); =
then
+			if [ "$KERNEL_SUBLEVEL" ] && [ "$s" ]; then
+				if (( $KERNEL_SUBLEVEL > $s )); then
 					have=3Dy
-				elif (( $kernel_sublevel =3D=3D $s )); then
-					if [ "$kernel_extraversion" ] && [ "$x" ]; then
-						if (( $kernel_extraversion >=3D $x )); then
+				elif (( $KERNEL_SUBLEVEL =3D=3D $s )); then
+					if [ "$KERNEL_EXTRAVERSION" ] && [ "$x" ]; then
+						if (( $KERNEL_EXTRAVERSION >=3D $x )); then
 							have=3Dy
 						else
 							have=3Dn
diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index c1ecb7f99cdc..96158b015e78 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -36,7 +36,7 @@ generate_test ()
=20
 	echo "#!/usr/bin/env bash"
 	echo "export STANDALONE=3Dyes"
-	echo "export ENVIRON_DEFAULT=3Dyes"
+	echo "export ENVIRON_DEFAULT=3D$ENVIRON_DEFAULT"
 	echo "export HOST=3D\$(uname -m | sed -e 's/i.86/i386/;s/arm.*/arm/;s/p=
pc64.*/ppc64/')"
 	echo "export PRETTY_PRINT_STACKS=3Dno"
=20
@@ -59,7 +59,7 @@ generate_test ()
 		echo 'export FIRMWARE'
 	fi
=20
-	if [ "$ERRATATXT" ]; then
+	if [ "$ENVIRON_DEFAULT" =3D "yes" ] && [ "$ERRATATXT" ]; then
 		temp_file ERRATATXT "$ERRATATXT"
 		echo 'export ERRATATXT'
 	fi
--=20
2.25.1

