Return-Path: <kvm+bounces-51035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D9E8AEC28F
	for <lists+kvm@lfdr.de>; Sat, 28 Jun 2025 00:19:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 760D8562F7F
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 22:19:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D24BB28D8CF;
	Fri, 27 Jun 2025 22:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FInBfvOF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FD4219E8
	for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 22:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751062753; cv=none; b=r8h8P3VOxNkw3oY5HP3Nu9sVTc8NBOdYtRanean1fI2EujXDOMHu9wWAe+Y7aJZWtuZAmCL+yal9txOXqy32Rj/EabzATGarAjzvVmFLwzYAG5fm2tZYRWxRP1i3RfEd0uzg9l1gUpQIx+h1wOD5YP4xISwL3TZUCPkJ4+Sjt6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751062753; c=relaxed/simple;
	bh=eKIBUIfzD9lTOHa+/WfMJWy244TGxz0H7Msq8K3Zt3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MNcTYnm4efTUBZSVBEDM9NUxrTtARQMqT3azm9QbopuEYmZkQfP6lQdo//laaXjxaoaha+mKUGZFjHd6wnfNiFrF73beXY1Ud1L8nmrwqJ4mKFJNvu1i4JXwtNXHAarsOtWP+wdFGV+9JqepH+zUJZaWkFQCnC5JZi1P22hGOh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FInBfvOF; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-747fc7506d4so509681b3a.0
        for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 15:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751062751; x=1751667551; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RRC+XnzJlYGDMydcUK5LKzM2R9IxhllX2pTcJC7/yJg=;
        b=FInBfvOF3LdX2sG+Cs1ayIxxIIlMaA+nwBJYgcCV1NkfH3WzqYcCb8hW93ktgKTKZP
         fr+QU7kpln9t7x050Ka+VNFW0zsNzpbo26AAaS99/bXwHoodisPBEa83ovAGfmX2oAjH
         UFWBPsaXLdoEsA3iZPEYb/uKc4ZC/1uXKok5uFfxk32MbSdx9vjyTwOWievC1vwaWUUI
         BPetPnjFRTwjyO81ufOXOYWr0s5DI2G/JL7542Pce44HGN3WAgxWaDabIVhq31zZlNMU
         BJNlno6OV/yyU5QB/rI065OpJy58gd4cr1Vn+SWTj1g3WXJLsUFEUFwBXh7wGslhe8OV
         vxzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751062751; x=1751667551;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RRC+XnzJlYGDMydcUK5LKzM2R9IxhllX2pTcJC7/yJg=;
        b=MdQBV6BVgCZ02Aiv0vEuW7qI7Kp8MdsByulffl007QPAeIVwIRoZ5mw7Tin0N1W+D3
         k268rTz4SH4cYWxjKxlr+rzIISW+ZkRmZG1XQD0TUVkS83gA1SMmd2Sh4TftxZFi6nMv
         YKwy6TV5fBK0kZHFhAB3D9gMR19o3SPXLNZ/nnoGkB1SrsNbpmOSsNWD/5Tx29Sh2VWg
         t0p6EhF3pbSkNVfcqoGkjqkzBPoubEDsMtya05vJdlxkDEa07dRBeTLeylgqRHnEss0m
         zY7ZHOc255cf69aIgj4C3RIp76KKY5rHqh3XO/wruxWLHDDmYloPzd7bGf/a+ErCLZfn
         oQPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjROiVtKeRXAiMz1OY7xipClsWlKMxBl9A6C4eSldwFo1mLmYfU+JxntSYy+C4usGQ61k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDNtK+UPv1t3MDzdW4TCX6KTmfFneKERi501ntnYlF4vuOPWtL
	BDOGm1V9xMC6AwQQumdcA47pVyDryxBlW3bBzIQUZ/hfddzy9Ew0icFiaxJ9JTSlhA==
X-Gm-Gg: ASbGncsm3kPDPrcv6dOZOoPYjDkN6G5kcdLdfrzcWnN83/lyrNjeFVx3Y9DEybTeN4M
	IQDQXC7it2Oi3Um0Vv99wZiK8FIowpddQMSsAy64dTsC0HTKoDDD//VM+KD9gZFiuhQZbEGRS7c
	fGDyaxx8tyM0ExGAl71dQT048wmG/he8VC0XaYk3XlI5wAeW5RCYjM+tDpq3gMq9oGba7dfX0hy
	AgUsTv9nnmrWFkmI6hqODx9XRp7naTPa6tFWiucPmqwr0ZcFxaC03Sgh5+JWHl3Dn8DaRnz0joH
	GJNddAiIrA/uFZogdS5D/hdC8AmWMv8ZZw4VN+9tTKJMLNN58i8IE4CY74cei8liHgl7n7QKZJm
	i0kcjZL0Er3g69AXHcryqgQci
X-Google-Smtp-Source: AGHT+IGOmYXmqdQ4YFuo42O9yB9Vgkyt7F9HbdsZMiiAjLB3QMtNfKFDuHMwn/6Dfd2eJo8gbRAYLA==
X-Received: by 2002:a17:90b:1a8f:b0:311:c939:c848 with SMTP id 98e67ed59e1d1-318c8cd690dmr8126496a91.0.1751062750468;
        Fri, 27 Jun 2025 15:19:10 -0700 (PDT)
Received: from google.com (111.67.145.34.bc.googleusercontent.com. [34.145.67.111])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-318c1394288sm3023193a91.2.2025.06.27.15.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 15:19:09 -0700 (PDT)
Date: Fri, 27 Jun 2025 22:19:05 +0000
From: David Matlack <dmatlack@google.com>
To: Aaron Lewis <aaronlewis@google.com>
Cc: alex.williamson@redhat.com, bhelgaas@google.com, vipinsh@google.com,
	kvm@vger.kernel.org, seanjc@google.com, jrhilke@google.com
Subject: Re: [RFC PATCH 1/3] vfio: selftests: Allow run.sh to bind to more
 than one device
Message-ID: <aF8Y2U79haQwUYhz@google.com>
References: <20250626180424.632628-1-aaronlewis@google.com>
 <20250626180424.632628-2-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250626180424.632628-2-aaronlewis@google.com>

On 2025-06-26 06:04 PM, Aaron Lewis wrote:
> Refactor the script "run.sh" to allow it to bind to more than one device
> at a time. Previously, the script would allow one BDF to be passed in as
> an argument to the script.  Extend this behavior to allow more than
> one, e.g.
> 
>   $ ./run.sh -d 0000:17:0c.1 -d 0000:17:0c.2 -d 0000:16:01.7 -s
> 
> This results in unbinding the devices 0000:17:0c.1, 0000:17:0c.2 and
> 0000:16:01.7 from their current drivers, binding them to the
> vfio-pci driver, then breaking out into a shell.
> 
> When testing is complete simply exit the shell to have those devices
> unbind from the vfio-pci driver and rebind to their previous ones.

Thanks for adding this. I also planning to upstream the change I just
made to our Google internal copy of the VFIO selftests to split this
script up into a setup and cleanup that will make it easier to use
multiple devices.

The setup script would let you run it multiple times to set up multiple
devices:

  tools/testing/seftests/vfio/setup.sh -d BDF_1
  tools/testing/seftests/vfio/setup.sh -d BDF_2
  tools/testing/seftests/vfio/setup.sh -d BDF_3
  tools/testing/seftests/vfio/setup.sh -d BDF_4

State about in-use devices are stored on the filesystem so that run.sh
can find it.

Then all devices can later be cleaned up all at once (or individually):

  tools/testing/seftests/vfio/cleanup.sh -d BDF_1
  tools/testing/seftests/vfio/cleanup.sh

Would you be interested in picking up that change as part of this
series?

> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  tools/testing/selftests/vfio/run.sh | 73 +++++++++++++++++++----------
>  1 file changed, 47 insertions(+), 26 deletions(-)
> 
> diff --git a/tools/testing/selftests/vfio/run.sh b/tools/testing/selftests/vfio/run.sh
> index 0476b6d7adc3..334934dab5c5 100755
> --- a/tools/testing/selftests/vfio/run.sh
> +++ b/tools/testing/selftests/vfio/run.sh
> @@ -2,11 +2,11 @@
>  
>  # Global variables initialized in main() and then used during cleanup() when
>  # the script exits.
> -declare DEVICE_BDF
> -declare NEW_DRIVER
> -declare OLD_DRIVER
> -declare OLD_NUMVFS
> -declare DRIVER_OVERRIDE
> +declare -a DEVICE_BDFS
> +declare -a NEW_DRIVERS
> +declare -a OLD_DRIVERS
> +declare -a OLD_NUMVFS
> +declare -a DRIVER_OVERRIDES
>  
>  function write_to() {
>  	# Unfortunately set -x does not show redirects so use echo to manually
> @@ -36,10 +36,20 @@ function clear_driver_override() {
>  }
>  
>  function cleanup() {
> -	if [ "${NEW_DRIVER}"      ]; then unbind ${DEVICE_BDF} ${NEW_DRIVER} ; fi
> -	if [ "${DRIVER_OVERRIDE}" ]; then clear_driver_override ${DEVICE_BDF} ; fi
> -	if [ "${OLD_DRIVER}"      ]; then bind ${DEVICE_BDF} ${OLD_DRIVER} ; fi
> -	if [ "${OLD_NUMVFS}"      ]; then set_sriov_numvfs ${DEVICE_BDF} ${OLD_NUMVFS} ; fi
> +	for i in "${!DEVICE_BDFS[@]}"; do
> +		if [ ${NEW_DRIVERS[$i]} != false      ]; then unbind ${DEVICE_BDFS[$i]} ${NEW_DRIVERS[$i]}; fi
> +		if [ ${DRIVER_OVERRIDES[$i]} != false ]; then clear_driver_override ${DEVICE_BDFS[$i]}; fi
> +		if [ ${OLD_DRIVERS[$i]} != false      ]; then bind ${DEVICE_BDFS[$i]} ${OLD_DRIVERS[$i]}; fi
> +		if [ ${OLD_NUMVFS[$i]} != false       ]; then set_sriov_numvfs ${DEVICE_BDFS[$i]} ${OLD_NUMVFS[$i]}; fi
> +	done

If you want false to work here then you need to preinitialize all of the
arrays with false. Otherwise if an error occurs part-way through the
loop in main then these arrays will be partially initialized.

I think it would be simpler to just continue using the empty string
to indicate "false" since that will also work for uninitialized arrays.

> +}
> +
> +function get_bdfs_string() {
> +	local bdfs_str;
> +
> +	printf -v bdfs_str '%s,' "${DEVICE_BDFS[@]}"
> +	bdfs_str="${bdfs_str%,}"
> +	echo "${bdfs_str}"
>  }
>  
>  function usage() {
> @@ -60,7 +70,7 @@ function main() {
>  
>  	while getopts "d:hs" opt; do
>  		case $opt in
> -			d) DEVICE_BDF="$OPTARG" ;;
> +			d) DEVICE_BDFS+=("$OPTARG") ;;
>  			s) shell=true ;;
>  			*) usage ;;
>  		esac
> @@ -73,33 +83,44 @@ function main() {
>  	[ ! "${shell}" ] && [ $# = 0 ] && usage
>  
>  	# Check that the user passed in a BDF.
> -	[ "${DEVICE_BDF}" ] || usage
> +	[[ -n "${DEVICE_BDFS[@]}" ]] || usage
>  
>  	trap cleanup EXIT
>  	set -e
>  
> -	test -d /sys/bus/pci/devices/${DEVICE_BDF}
> +	for device_bdf in "${DEVICE_BDFS[@]}"; do
> +		local old_numvf=false
> +		local old_driver=false
> +		local driver_override=false

If an error happens between here and where the arrays are updated below
then cleanup() won't unwind the change.

Can you initialize the arrays here instead of local variables? That will
fix it.

>  
> -	if [ -f /sys/bus/pci/devices/${DEVICE_BDF}/sriov_numvfs ]; then
> -		OLD_NUMVFS=$(cat /sys/bus/pci/devices/${DEVICE_BDF}/sriov_numvfs)
> -		set_sriov_numvfs ${DEVICE_BDF} 0
> -	fi
> +		test -d /sys/bus/pci/devices/${device_bdf}
>  
> -	if [ -L /sys/bus/pci/devices/${DEVICE_BDF}/driver ]; then
> -		OLD_DRIVER=$(basename $(readlink -m /sys/bus/pci/devices/${DEVICE_BDF}/driver))
> -		unbind ${DEVICE_BDF} ${OLD_DRIVER}
> -	fi
> +		if [ -f /sys/bus/pci/devices/${device_bdf}/sriov_numvfs ]; then
> +			old_numvf=$(cat /sys/bus/pci/devices/${device_bdf}/sriov_numvfs)
> +			set_sriov_numvfs ${device_bdf} 0
> +		fi
> +
> +		if [ -L /sys/bus/pci/devices/${device_bdf}/driver ]; then
> +			old_driver=$(basename $(readlink -m /sys/bus/pci/devices/${device_bdf}/driver))
> +			unbind ${device_bdf} ${old_driver}
> +		fi
>  
> -	set_driver_override ${DEVICE_BDF} vfio-pci
> -	DRIVER_OVERRIDE=true
> +		set_driver_override ${device_bdf} vfio-pci
> +		driver_override=true
>  
> -	bind ${DEVICE_BDF} vfio-pci
> -	NEW_DRIVER=vfio-pci
> +		bind ${device_bdf} vfio-pci
> +
> +		NEW_DRIVERS+=(vfio-pci)
> +		OLD_DRIVERS+=(${old_driver})
> +		OLD_NUMVFS+=(${old_numvf})
> +		DRIVER_OVERRIDES+=(${driver_override})
> +	done
>  
>  	echo
>  	if [ "${shell}" ]; then
> -		echo "Dropping into ${SHELL} with VFIO_SELFTESTS_BDF=${DEVICE_BDF}"
> -		VFIO_SELFTESTS_BDF=${DEVICE_BDF} ${SHELL}
> +		local bdfs_str=$(get_bdfs_string);
> +		echo "Dropping into ${SHELL} with VFIO_SELFTESTS_BDFS=${bdfs_str}"
> +		VFIO_SELFTESTS_BDFS=${bdfs_str} ${SHELL}

What's the reason to use get_bdfs_string() instead of just:

  VFIO_SELFTESTS_BDFS="${DEVICE_BDFS[@]}" ${SHELL}

?

>  	else
>  		"$@" ${DEVICE_BDF}

This should be:

		"$@" ${DEVICE_BDFS[@]}

>  	fi
> -- 
> 2.50.0.727.gbf7dc18ff4-goog
> 

