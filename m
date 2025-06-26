Return-Path: <kvm+bounces-50867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 660B7AEA4E1
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 20:04:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A090B3BE16B
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 18:04:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A23DF2ED87B;
	Thu, 26 Jun 2025 18:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zQTrD8IZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f74.google.com (mail-oa1-f74.google.com [209.85.160.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AA62ED173
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 18:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750961075; cv=none; b=ppc7/nvX2se3aNdmoJlmHTOug67i/mYzu9Casnd4O+HNcvEi6cmAfgVyS+XWe8tj4L7NHakEMNRaIJuPgNH8EFC4rmXLkHe+7IDz5Y9hOhoeO52akC56zmAO6UOgQdBL3bXSNffBonPzJgUsz9ddsS5c67ZdSDviS3rxQr00/Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750961075; c=relaxed/simple;
	bh=lN75Ibt0idSEKyys6kLcLn8xZ5Td72aX5mMAKMkAN+4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CHopBUtAC/slYLclGaiLsalfpR41WtyClWsEYATM0oAqvISm7yODWzN64h+pprzjJCDaA9j4gb2A6UxSELVa/1/v1BeH4hofn4FTQbPQNDqC5Vn2Vncw3gE2Nl+VCUzd67SWgQabtJMNuYKpgmwEEivGYeHmE4YDQp+AYVFnqdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zQTrD8IZ; arc=none smtp.client-ip=209.85.160.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-oa1-f74.google.com with SMTP id 586e51a60fabf-2ea03d4f78cso403167fac.1
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 11:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750961073; x=1751565873; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dW3sRI0GZuC+asX3BLUvar/vNtR6eFgyssaF/JIKHNk=;
        b=zQTrD8IZ74GUO5NPABZAjMUnusNP3j8pZCh8GvZ7Xh7w8hfafSbbw3qxZjMJHQsfO1
         wag302MoZqrrodnTGMj5TI5s1vHIEZLbxcYq8lsTUFIEr7WYfCK215wO6VFp2EbKQo7U
         2LSY5rHCa49XoloK2gXcG+yeW+yf2Cdsp9dcXbc9UgNyrDs7qkUTBnauaudYnMk09L04
         Hk3VCG5ZLpbLyx5lapAluHj4Kjghtv0d6My6yml6OpnjtfKGWOQsi+EFahiUPMp0Ge9F
         kfNn+U75OFwMmYILkqISm/MwNXM1aciRAX+S/nFMkzAb40bI2tIxBy5fQUhqp0Hkkpzn
         AA9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750961073; x=1751565873;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dW3sRI0GZuC+asX3BLUvar/vNtR6eFgyssaF/JIKHNk=;
        b=qU2f0DdO93667qZCbAPUUrEr0+T6JiUWcLZU0DFRBdRVdfk07bZFaF93B+UNV89FNG
         VyESB00pKt3i9xkqyvvcICX5E3sNhQ2zh/1EqIWRF366i013trsW/8Wt1vdtQQGAiqIj
         ZuibqnGGnvBri+X138+NTDoT9OlhVEheG4w03X7XXLrlsBdk+53N/NW55/6xSlRBrqeo
         aQbbgWcMaWXgAAmqJjXYljXpnMwL+LfcUqSOZJHV/RJdVFuneBxY5i6ovBXPjIC4EjwQ
         vRh3OmC+7Z7Mt/D5msw7iBXLpsh5nvkQ7ejcxD2i3jJdcifpVRQtMF6C4QxV+gomreug
         XIRQ==
X-Gm-Message-State: AOJu0YxhDBzruariMIniHYaiE9hyyXMYJcdl+lf3cRGYdXa3T6jfoJNs
	6dsxMw05eL52CvUE9Ugxr69C5N56Qhh0/qyQONgSCyjxENe0jCFwlfEK1YjCwDH3aXFikpZ+d+s
	U/cIKvAsEsTIPsS+xxcu4+A==
X-Google-Smtp-Source: AGHT+IHL+BWnXG+HDoHGV5NZ1Xsbsn237dwce3YpQFyKsKwM4xyfKb0ZhTuHhT79Gi+TDcjyeR4SjqRmZYynd0Ee
X-Received: from oabhe14.prod.google.com ([2002:a05:6870:798e:b0:2ea:c4fa:4916])
 (user=aaronlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6870:522:b0:2eb:adf2:eb2 with SMTP id 586e51a60fabf-2efb296fd9amr5622674fac.36.1750961073463;
 Thu, 26 Jun 2025 11:04:33 -0700 (PDT)
Date: Thu, 26 Jun 2025 18:04:22 +0000
In-Reply-To: <20250626180424.632628-1-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250626180424.632628-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626180424.632628-2-aaronlewis@google.com>
Subject: [RFC PATCH 1/3] vfio: selftests: Allow run.sh to bind to more than
 one device
From: Aaron Lewis <aaronlewis@google.com>
To: alex.williamson@redhat.com, bhelgaas@google.com, dmatlack@google.com, 
	vipinsh@google.com
Cc: kvm@vger.kernel.org, seanjc@google.com, jrhilke@google.com, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Refactor the script "run.sh" to allow it to bind to more than one device
at a time. Previously, the script would allow one BDF to be passed in as
an argument to the script.  Extend this behavior to allow more than
one, e.g.

  $ ./run.sh -d 0000:17:0c.1 -d 0000:17:0c.2 -d 0000:16:01.7 -s

This results in unbinding the devices 0000:17:0c.1, 0000:17:0c.2 and
0000:16:01.7 from their current drivers, binding them to the
vfio-pci driver, then breaking out into a shell.

When testing is complete simply exit the shell to have those devices
unbind from the vfio-pci driver and rebind to their previous ones.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/vfio/run.sh | 73 +++++++++++++++++++----------
 1 file changed, 47 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/vfio/run.sh b/tools/testing/selftests/vfio/run.sh
index 0476b6d7adc3..334934dab5c5 100755
--- a/tools/testing/selftests/vfio/run.sh
+++ b/tools/testing/selftests/vfio/run.sh
@@ -2,11 +2,11 @@
 
 # Global variables initialized in main() and then used during cleanup() when
 # the script exits.
-declare DEVICE_BDF
-declare NEW_DRIVER
-declare OLD_DRIVER
-declare OLD_NUMVFS
-declare DRIVER_OVERRIDE
+declare -a DEVICE_BDFS
+declare -a NEW_DRIVERS
+declare -a OLD_DRIVERS
+declare -a OLD_NUMVFS
+declare -a DRIVER_OVERRIDES
 
 function write_to() {
 	# Unfortunately set -x does not show redirects so use echo to manually
@@ -36,10 +36,20 @@ function clear_driver_override() {
 }
 
 function cleanup() {
-	if [ "${NEW_DRIVER}"      ]; then unbind ${DEVICE_BDF} ${NEW_DRIVER} ; fi
-	if [ "${DRIVER_OVERRIDE}" ]; then clear_driver_override ${DEVICE_BDF} ; fi
-	if [ "${OLD_DRIVER}"      ]; then bind ${DEVICE_BDF} ${OLD_DRIVER} ; fi
-	if [ "${OLD_NUMVFS}"      ]; then set_sriov_numvfs ${DEVICE_BDF} ${OLD_NUMVFS} ; fi
+	for i in "${!DEVICE_BDFS[@]}"; do
+		if [ ${NEW_DRIVERS[$i]} != false      ]; then unbind ${DEVICE_BDFS[$i]} ${NEW_DRIVERS[$i]}; fi
+		if [ ${DRIVER_OVERRIDES[$i]} != false ]; then clear_driver_override ${DEVICE_BDFS[$i]}; fi
+		if [ ${OLD_DRIVERS[$i]} != false      ]; then bind ${DEVICE_BDFS[$i]} ${OLD_DRIVERS[$i]}; fi
+		if [ ${OLD_NUMVFS[$i]} != false       ]; then set_sriov_numvfs ${DEVICE_BDFS[$i]} ${OLD_NUMVFS[$i]}; fi
+	done
+}
+
+function get_bdfs_string() {
+	local bdfs_str;
+
+	printf -v bdfs_str '%s,' "${DEVICE_BDFS[@]}"
+	bdfs_str="${bdfs_str%,}"
+	echo "${bdfs_str}"
 }
 
 function usage() {
@@ -60,7 +70,7 @@ function main() {
 
 	while getopts "d:hs" opt; do
 		case $opt in
-			d) DEVICE_BDF="$OPTARG" ;;
+			d) DEVICE_BDFS+=("$OPTARG") ;;
 			s) shell=true ;;
 			*) usage ;;
 		esac
@@ -73,33 +83,44 @@ function main() {
 	[ ! "${shell}" ] && [ $# = 0 ] && usage
 
 	# Check that the user passed in a BDF.
-	[ "${DEVICE_BDF}" ] || usage
+	[[ -n "${DEVICE_BDFS[@]}" ]] || usage
 
 	trap cleanup EXIT
 	set -e
 
-	test -d /sys/bus/pci/devices/${DEVICE_BDF}
+	for device_bdf in "${DEVICE_BDFS[@]}"; do
+		local old_numvf=false
+		local old_driver=false
+		local driver_override=false
 
-	if [ -f /sys/bus/pci/devices/${DEVICE_BDF}/sriov_numvfs ]; then
-		OLD_NUMVFS=$(cat /sys/bus/pci/devices/${DEVICE_BDF}/sriov_numvfs)
-		set_sriov_numvfs ${DEVICE_BDF} 0
-	fi
+		test -d /sys/bus/pci/devices/${device_bdf}
 
-	if [ -L /sys/bus/pci/devices/${DEVICE_BDF}/driver ]; then
-		OLD_DRIVER=$(basename $(readlink -m /sys/bus/pci/devices/${DEVICE_BDF}/driver))
-		unbind ${DEVICE_BDF} ${OLD_DRIVER}
-	fi
+		if [ -f /sys/bus/pci/devices/${device_bdf}/sriov_numvfs ]; then
+			old_numvf=$(cat /sys/bus/pci/devices/${device_bdf}/sriov_numvfs)
+			set_sriov_numvfs ${device_bdf} 0
+		fi
+
+		if [ -L /sys/bus/pci/devices/${device_bdf}/driver ]; then
+			old_driver=$(basename $(readlink -m /sys/bus/pci/devices/${device_bdf}/driver))
+			unbind ${device_bdf} ${old_driver}
+		fi
 
-	set_driver_override ${DEVICE_BDF} vfio-pci
-	DRIVER_OVERRIDE=true
+		set_driver_override ${device_bdf} vfio-pci
+		driver_override=true
 
-	bind ${DEVICE_BDF} vfio-pci
-	NEW_DRIVER=vfio-pci
+		bind ${device_bdf} vfio-pci
+
+		NEW_DRIVERS+=(vfio-pci)
+		OLD_DRIVERS+=(${old_driver})
+		OLD_NUMVFS+=(${old_numvf})
+		DRIVER_OVERRIDES+=(${driver_override})
+	done
 
 	echo
 	if [ "${shell}" ]; then
-		echo "Dropping into ${SHELL} with VFIO_SELFTESTS_BDF=${DEVICE_BDF}"
-		VFIO_SELFTESTS_BDF=${DEVICE_BDF} ${SHELL}
+		local bdfs_str=$(get_bdfs_string);
+		echo "Dropping into ${SHELL} with VFIO_SELFTESTS_BDFS=${bdfs_str}"
+		VFIO_SELFTESTS_BDFS=${bdfs_str} ${SHELL}
 	else
 		"$@" ${DEVICE_BDF}
 	fi
-- 
2.50.0.727.gbf7dc18ff4-goog


