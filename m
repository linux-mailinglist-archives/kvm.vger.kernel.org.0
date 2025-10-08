Return-Path: <kvm+bounces-59661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 14399BC6DA1
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 01:26:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9863B4E19E7
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 23:26:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48B382C235B;
	Wed,  8 Oct 2025 23:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vUHstLwp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC88227BF7D
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 23:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759965960; cv=none; b=imNcwRrBAcCKLSNtx4qc7WQAC/HMlBL48rGiq9X+WmRZxf/acAeSvWqxV9LwLz4dLyf7D4Q3BMaNm+2J+bMv89emm0TDSPlpj6Jvijtbj1it5VxqvIIZ/B3MlTDzwdQYBkurnzy7oLQf9qAQgM+4PrSzZGIpXv/9wzGOZktth6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759965960; c=relaxed/simple;
	bh=1+UvxfwidzENik/RR9oJx6wEDmvbbPazjG7M0DjD/fE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bn+xJ+2txOdiIVZXWwlLWcQYTcVaVNAZo23lYhlFMc2f2sZUSrKPi33q1diFF19sjJtaxvhPqIH5NqQJWNvBbhAV5YOxEEXVtlS3a8lwkSwAFTKGAqJVH2d2OMEsGbF5qwsDOLwHsWvX+yeLJ8ScAPtQ/bvFJDSnswZ2AVrtWf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vUHstLwp; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7810289cd5eso711009b3a.1
        for <kvm@vger.kernel.org>; Wed, 08 Oct 2025 16:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759965958; x=1760570758; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y0mF7CedyABcMukAXyn9NCIvBZDCaVv6Ot9GFWW8DEU=;
        b=vUHstLwp5Rud1hCJkQhbF6zjO241CnH58hmvV43SC6vrtk1JHS3NhbM85tYbfFm9gY
         5K2HuNyF1T8gYczsKPlNl23m572Xa+1aRyJu1glJQUrnQjflRNN6iqArOYrzPi5a3/uD
         lOy4was+ZYV98X4ij0nqeQB4Qgx0Oqd8P1chFc2DN3lQEl8P7zu/d8nYGoSOiaH2f+oC
         w9w65Roi+lSkL8CzzzEOotiIVvxo4Ma3OI25P5aUQlbsN+ztc1gdMoPSt5pZFzh17Rx5
         7iHXIV8iOoYA+QxwYogkYq26Xoqt3SPyqCRhEu2NLKoISIibbX6dKnXk6/fFJakg/xdk
         2Z4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759965958; x=1760570758;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y0mF7CedyABcMukAXyn9NCIvBZDCaVv6Ot9GFWW8DEU=;
        b=ogb3gKmaRsw9qFyWVjTggoz7whpm+IB6O51Wv5pz7pOp1t6L6LdNrE7ji835azArBR
         XLCmZJpNrEZJBvlWyb5AP8x5jY8HLtpE6qPgN00Z+jdeT7a8zwDqzUf5UNYReMz8PJ81
         h1YaFx1RiUP3qgXswGjqbuhbhCpxUtio1q2pQbEJOhmwGzCKsRhj3SA5cfsYn7n6KXfw
         hWg3/vHWL3zNoYvsXhfRDvB93xHEEnr30h7AZjg8zVy/V01AZGkiJPcd1YDTHbf7tchp
         zUKxidk/SBIbEvf1e0XzermoxdGyPRHfABlIedWB3ro8YgLaPQjJmgYNxcyZZ9+VZEfW
         KI8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVuPa+leOXTNFuhlCVnXOP+WUVS10KDM7/1kY61tXadKnx+Dg+SG0U1ur36wl0C5auxtJw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPR6HHrafmhAGX5TlXWkKs9aKrIG54xDNys6l2dRzM+nueyJUz
	/cAuZ+gqcyupmzTQjMBqnAfXSkzZIPpSfR33LmWalrZEc/fVNxjCyNCd2BlRqDFWWB71gB4gwd1
	kj8Uj+tippHwO1Q==
X-Google-Smtp-Source: AGHT+IHbJrnbl3o/SG9GesZcUtq7PCZf/LLBJJMhj9uS77STqjb+3AbxqxPpzAXtn3Jg3Vw5ROvxjNBQYFXH7A==
X-Received: from pfbfr20.prod.google.com ([2002:a05:6a00:8114:b0:793:b157:af4a])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:66c4:b0:781:2558:6a3e with SMTP id d2e1a72fcca58-79385517fccmr6529976b3a.14.1759965958023;
 Wed, 08 Oct 2025 16:25:58 -0700 (PDT)
Date: Wed,  8 Oct 2025 23:25:20 +0000
In-Reply-To: <20251008232531.1152035-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008232531.1152035-1-dmatlack@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008232531.1152035-2-dmatlack@google.com>
Subject: [PATCH 01/12] vfio: selftests: Split run.sh into separate scripts
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Matlack <dmatlack@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, 
	kvm@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Split run.sh into separate scripts (setup.sh, run.sh, cleanup.sh) to
enable multi-device testing, and prepare for VFIO selftests
automatically detecting which devices to use for testing by storing
device metadata on the filesystem.

 - setup.sh takes one or more BDFs as arguments and sets up each device.
   Metadata about each device is stored on the filesystem in the
   directory:

	   ${TMPDIR:-/tmp}/vfio-selftests-devices

   Within this directory is a directory for each BDF, and then files in
   those directories that cleanup.sh uses to cleanup the device.

 - run.sh runs a selftest by passing it the BDFs of all set up devices.

 - cleanup.sh takes zero or more BDFs as arguments and cleans up each
   device. If no BDFs are provided, it cleans up all devices.

This split enables multi-device testing by allowing multiple BDFs to be
set up and passed into tests:

For example:

  $ tools/testing/selftests/vfio/scripts/setup.sh <BDF1> <BDF2>
  $ tools/testing/selftests/vfio/scripts/setup.sh <BDF3>
  $ tools/testing/selftests/vfio/scripts/run.sh echo
  <BDF1> <BDF2> <BDF3>
  $ tools/testing/selftests/vfio/scripts/cleanup.sh

If the future, VFIO selftests can automatically detect set up devices by
inspecting ${TMPDIR:-/tmp}/vfio-selftests-devices. This will avoid the
need for the run.sh script.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/run.sh           | 109 ------------------
 .../testing/selftests/vfio/scripts/cleanup.sh |  42 +++++++
 tools/testing/selftests/vfio/scripts/lib.sh   |  42 +++++++
 tools/testing/selftests/vfio/scripts/run.sh   |  16 +++
 tools/testing/selftests/vfio/scripts/setup.sh |  48 ++++++++
 5 files changed, 148 insertions(+), 109 deletions(-)
 delete mode 100755 tools/testing/selftests/vfio/run.sh
 create mode 100755 tools/testing/selftests/vfio/scripts/cleanup.sh
 create mode 100755 tools/testing/selftests/vfio/scripts/lib.sh
 create mode 100755 tools/testing/selftests/vfio/scripts/run.sh
 create mode 100755 tools/testing/selftests/vfio/scripts/setup.sh

diff --git a/tools/testing/selftests/vfio/run.sh b/tools/testing/selftests/vfio/run.sh
deleted file mode 100755
index 0476b6d7adc3..000000000000
--- a/tools/testing/selftests/vfio/run.sh
+++ /dev/null
@@ -1,109 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-or-later
-
-# Global variables initialized in main() and then used during cleanup() when
-# the script exits.
-declare DEVICE_BDF
-declare NEW_DRIVER
-declare OLD_DRIVER
-declare OLD_NUMVFS
-declare DRIVER_OVERRIDE
-
-function write_to() {
-	# Unfortunately set -x does not show redirects so use echo to manually
-	# tell the user what commands are being run.
-	echo "+ echo \"${2}\" > ${1}"
-	echo "${2}" > ${1}
-}
-
-function bind() {
-	write_to /sys/bus/pci/drivers/${2}/bind ${1}
-}
-
-function unbind() {
-	write_to /sys/bus/pci/drivers/${2}/unbind ${1}
-}
-
-function set_sriov_numvfs() {
-	write_to /sys/bus/pci/devices/${1}/sriov_numvfs ${2}
-}
-
-function set_driver_override() {
-	write_to /sys/bus/pci/devices/${1}/driver_override ${2}
-}
-
-function clear_driver_override() {
-	set_driver_override ${1} ""
-}
-
-function cleanup() {
-	if [ "${NEW_DRIVER}"      ]; then unbind ${DEVICE_BDF} ${NEW_DRIVER} ; fi
-	if [ "${DRIVER_OVERRIDE}" ]; then clear_driver_override ${DEVICE_BDF} ; fi
-	if [ "${OLD_DRIVER}"      ]; then bind ${DEVICE_BDF} ${OLD_DRIVER} ; fi
-	if [ "${OLD_NUMVFS}"      ]; then set_sriov_numvfs ${DEVICE_BDF} ${OLD_NUMVFS} ; fi
-}
-
-function usage() {
-	echo "usage: $0 [-d segment:bus:device.function] [-s] [-h] [cmd ...]" >&2
-	echo >&2
-	echo "  -d: The BDF of the device to use for the test (required)" >&2
-	echo "  -h: Show this help message" >&2
-	echo "  -s: Drop into a shell rather than running a command" >&2
-	echo >&2
-	echo "   cmd: The command to run and arguments to pass to it." >&2
-	echo "        Required when not using -s. The SBDF will be " >&2
-	echo "        appended to the argument list." >&2
-	exit 1
-}
-
-function main() {
-	local shell
-
-	while getopts "d:hs" opt; do
-		case $opt in
-			d) DEVICE_BDF="$OPTARG" ;;
-			s) shell=true ;;
-			*) usage ;;
-		esac
-	done
-
-	# Shift past all optional arguments.
-	shift $((OPTIND - 1))
-
-	# Check that the user passed in the command to run.
-	[ ! "${shell}" ] && [ $# = 0 ] && usage
-
-	# Check that the user passed in a BDF.
-	[ "${DEVICE_BDF}" ] || usage
-
-	trap cleanup EXIT
-	set -e
-
-	test -d /sys/bus/pci/devices/${DEVICE_BDF}
-
-	if [ -f /sys/bus/pci/devices/${DEVICE_BDF}/sriov_numvfs ]; then
-		OLD_NUMVFS=$(cat /sys/bus/pci/devices/${DEVICE_BDF}/sriov_numvfs)
-		set_sriov_numvfs ${DEVICE_BDF} 0
-	fi
-
-	if [ -L /sys/bus/pci/devices/${DEVICE_BDF}/driver ]; then
-		OLD_DRIVER=$(basename $(readlink -m /sys/bus/pci/devices/${DEVICE_BDF}/driver))
-		unbind ${DEVICE_BDF} ${OLD_DRIVER}
-	fi
-
-	set_driver_override ${DEVICE_BDF} vfio-pci
-	DRIVER_OVERRIDE=true
-
-	bind ${DEVICE_BDF} vfio-pci
-	NEW_DRIVER=vfio-pci
-
-	echo
-	if [ "${shell}" ]; then
-		echo "Dropping into ${SHELL} with VFIO_SELFTESTS_BDF=${DEVICE_BDF}"
-		VFIO_SELFTESTS_BDF=${DEVICE_BDF} ${SHELL}
-	else
-		"$@" ${DEVICE_BDF}
-	fi
-	echo
-}
-
-main "$@"
diff --git a/tools/testing/selftests/vfio/scripts/cleanup.sh b/tools/testing/selftests/vfio/scripts/cleanup.sh
new file mode 100755
index 000000000000..f436e4dabbcb
--- /dev/null
+++ b/tools/testing/selftests/vfio/scripts/cleanup.sh
@@ -0,0 +1,42 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+source $(dirname ${BASH_SOURCE[0]})/lib.sh
+
+function cleanup_devices() {
+	local device_bdf
+	local device_dir
+
+	for device_bdf in "$@"; do
+		device_dir=${DEVICES_DIR}/${device_bdf}
+
+		if [ -f ${device_dir}/vfio-pci ]; then
+			unbind ${device_bdf} vfio-pci
+		fi
+
+		if [ -f ${device_dir}/driver_override ]; then
+			clear_driver_override ${device_bdf}
+		fi
+
+		if [ -f ${device_dir}/driver ]; then
+			bind ${device_bdf} $(cat ${device_dir}/driver)
+		fi
+
+		if [ -f ${device_dir}/sriov_numvfs ]; then
+			set_sriov_numvfs ${device_bdf} $(cat ${device_dir}/sriov_numvfs)
+		fi
+
+		rm -rf ${device_dir}
+	done
+
+	rm -rf ${DEVICES_DIR}
+}
+
+function main() {
+	if [ $# = 0 ]; then
+		cleanup_devices $(ls ${DEVICES_DIR})
+	else
+		cleanup_devices "$@"
+	fi
+}
+
+main "$@"
diff --git a/tools/testing/selftests/vfio/scripts/lib.sh b/tools/testing/selftests/vfio/scripts/lib.sh
new file mode 100755
index 000000000000..9f05f29c7b86
--- /dev/null
+++ b/tools/testing/selftests/vfio/scripts/lib.sh
@@ -0,0 +1,42 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+readonly DEVICES_DIR="${TMPDIR:-/tmp}/vfio-selftests-devices"
+
+function write_to() {
+	# Unfortunately set -x does not show redirects so use echo to manually
+	# tell the user what commands are being run.
+	echo "+ echo \"${2}\" > ${1}"
+	echo "${2}" > ${1}
+}
+
+function get_driver() {
+	if [ -L /sys/bus/pci/devices/${1}/driver ]; then
+		basename $(readlink -m /sys/bus/pci/devices/${1}/driver)
+	fi
+}
+
+function bind() {
+	write_to /sys/bus/pci/drivers/${2}/bind ${1}
+}
+
+function unbind() {
+	write_to /sys/bus/pci/drivers/${2}/unbind ${1}
+}
+
+function set_sriov_numvfs() {
+	write_to /sys/bus/pci/devices/${1}/sriov_numvfs ${2}
+}
+
+function get_sriov_numvfs() {
+	if [ -f /sys/bus/pci/devices/${1}/sriov_numvfs ]; then
+		cat /sys/bus/pci/devices/${1}/sriov_numvfs
+	fi
+}
+
+function set_driver_override() {
+	write_to /sys/bus/pci/devices/${1}/driver_override ${2}
+}
+
+function clear_driver_override() {
+	set_driver_override ${1} ""
+}
diff --git a/tools/testing/selftests/vfio/scripts/run.sh b/tools/testing/selftests/vfio/scripts/run.sh
new file mode 100755
index 000000000000..da08753892c4
--- /dev/null
+++ b/tools/testing/selftests/vfio/scripts/run.sh
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+source $(dirname ${BASH_SOURCE[0]})/lib.sh
+
+function main() {
+	local device_bdfs=$(ls ${DEVICES_DIR})
+
+	if [ -z "${device_bdfs}" ]; then
+		echo "No devices found, skipping."
+		exit 4
+	fi
+
+	"$@" ${device_bdfs}
+}
+
+main "$@"
diff --git a/tools/testing/selftests/vfio/scripts/setup.sh b/tools/testing/selftests/vfio/scripts/setup.sh
new file mode 100755
index 000000000000..cd229442ef89
--- /dev/null
+++ b/tools/testing/selftests/vfio/scripts/setup.sh
@@ -0,0 +1,48 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+set -e
+
+source $(dirname ${BASH_SOURCE[0]})/lib.sh
+
+function main() {
+	local device_bdf
+	local device_dir
+	local numvfs
+	local driver
+
+	if [ $# = 0 ]; then
+		echo "usage: $0 segment:bus:device.function ..." >&2
+		exit 1
+	fi
+
+	for device_bdf in "$@"; do
+		test -d /sys/bus/pci/devices/${device_bdf}
+
+		device_dir=${DEVICES_DIR}/${device_bdf}
+		if [ -d "${device_dir}" ]; then
+			echo "${device_bdf} has already been set up, exiting."
+			exit 0
+		fi
+
+		mkdir -p ${device_dir}
+
+		numvfs=$(get_sriov_numvfs ${device_bdf})
+		if [ "${numvfs}" ]; then
+			set_sriov_numvfs ${device_bdf} 0
+			echo ${numvfs} > ${device_dir}/sriov_numvfs
+		fi
+
+		driver=$(get_driver ${device_bdf})
+		if [ "${driver}" ]; then
+			unbind ${device_bdf} ${driver}
+			echo ${driver} > ${device_dir}/driver
+		fi
+
+		set_driver_override ${device_bdf} vfio-pci
+		touch ${device_dir}/driver_override
+
+		bind ${device_bdf} vfio-pci
+		touch ${device_dir}/vfio-pci
+	done
+}
+
+main "$@"
-- 
2.51.0.710.ga91ca5db03-goog


