Return-Path: <kvm+bounces-62469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A0C5C44D32
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 04:21:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 699C4345836
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 03:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9AF3278E53;
	Mon, 10 Nov 2025 03:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b0tvY7PB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7B3277CA4
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 03:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762744879; cv=none; b=G2+o29Ku0vObij44B98gOPIIxG+a7XU4XToezvtiti7z6c1zd9cs8GPbspxRaNvUbMXWl8GvMjMmaEW/wwKsTU+wXMyGvIN6iLxIDioot/xbpKH4KRYdumsAyqhuNLywm9PYTLyX5kEPSanyXooAQAL2STf9tyloF9DcacSPbrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762744879; c=relaxed/simple;
	bh=gzM+vlTr+o3A6bHYSbV/oKHwhIbCDmtA7CbDMkQN5O0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CYAv+rzmgDhJrZsP+exdt3pe7iXOlStFfVtQhDUfIu0wIa+FCnrdM0+8ZXQhp5YghO+OGoU/g5ASh3DcXl4SeRCTqrKFmPI93RCtY6vJ1pD+DKA5ltLRgu8FudFTrWQ5SxpPdq4nIMZhQHimwipHmc5zexlHEqAvUxsu96/GU74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b0tvY7PB; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ed6ca52a0bso367951cf.1
        for <kvm@vger.kernel.org>; Sun, 09 Nov 2025 19:21:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762744877; x=1763349677; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yE7D/d+hGdhAKDgwl768mwdCQafBz0+8l/dqc+yorAM=;
        b=b0tvY7PBmJYo7EgQ1wYjJpRDuKQU7+OsbqNoBS9UbCV4mhxwBM0RJ6owekT/T21w5A
         xs+kg3BAaE0gK+DwAEHVnaBatNt2+iU8+656qM9KDlDokEI1uLxTSaIoPSCwC9ngopBY
         ryZwPsYZM92Kghoh8e8za+GRcUe0HmgM9iPpehKPdvh6I0e5RzPV9l5nyU1v+uLKjRZp
         iDIq0bKOoxSLR5p4RsN/ZMOwFCxW/Zixi9J7RQoVGIaJVhDR9lVSuRUk+zZjqeRCKfpR
         Cn/0DC+miIGX7vgCzmHe8h0tGopZAU0/wkZlnuqnmZeww3vFQuUkHddm5SMThSxPMoh5
         AGnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762744877; x=1763349677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yE7D/d+hGdhAKDgwl768mwdCQafBz0+8l/dqc+yorAM=;
        b=goznsB7rAbcwwP0DSP7BMNmdYLPq9K2VP2OLedATl1nm1uLD1Q8xzmE83EyRHBuKh7
         FWP8fV5HTJDowP4gw81t2cWFsTYp8g6KDPX4ywa33oBAXi0qJUKUzvZF/rBrd+kybM4q
         BkIqTk14oge3KVdD66QGuxKoMxS/t/2c21I8q29raTMHrQCnTdQNXI7AOui/u9v/kAcB
         l5p9fA/F1jcbER7XfZXzTTRdjMat7NnsLsuLB47/FcHRhuVPso6nq7bcCMVsTNmvRMqZ
         EspzE4bU+n0PWMMfoHmiEt9FPI9PbLMMnRUulWQyYV8DR/vrBh709hiOM4lAwm300Cb4
         L50A==
X-Forwarded-Encrypted: i=1; AJvYcCWpdIMAY1RM58fRoEIqXtWdnNHzcON76PmR7ga/8mIFKpenLSY9zXujoa/TG0s1ikx9hR0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZhqySn05dsVO8dKT2+hnKToIQD9GIWgcyn2JN3kJh8fsH0bkR
	h3VCsBFI8Rd0w38MfJpZkCqcBtmtgPCQUspXH3WnxBNxDIYSHbr99/6MCx2FzGVRNWWTXHw2en0
	1lVb0WKE1MOTChKmzrVWnRGMtl9etYknBnycqY9mx
X-Gm-Gg: ASbGncv6kfPclYZtlsE/eoDpL55VL/Mr4OE5N3mMWRggX510SIAXZ5okhEMB8ZGTTxN
	2wGvqoMWpEj1EReGd5+ZEDpwrK6pI8ipnlcJbbANStXL4duthTcEfbNxquKSCYZhwiwh2sk4G45
	ShV+Xn6ENJte3Iu8APAeEBNeKbATMmnhXtEbekT/z2EUwfMj98pAvdw2muZgPkPBn8fsa+5yYqR
	OiieTSz2jW2lXqiVPARDFY2ciu0SpF5GlKQRl28uE3a8VSb0TPxwb2Ybq2kWS/sqt7rNcf2oDiC
	+DyPDZU9NGhc4kny1HI=
X-Google-Smtp-Source: AGHT+IHTvnVy1l0rm+BFORVUUEfLKOlwJnqtvG3gXrIJ1FwHdaAORHS/9A1l3DtEpwVnabO57rnBlivuANM0BA6TlN0=
X-Received: by 2002:a05:622a:2cc:b0:4ed:8103:8c37 with SMTP id
 d75a77b69052e-4eda4e2c1abmr11969011cf.12.1762744876361; Sun, 09 Nov 2025
 19:21:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251008232531.1152035-1-dmatlack@google.com> <20251008232531.1152035-2-dmatlack@google.com>
In-Reply-To: <20251008232531.1152035-2-dmatlack@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 10 Nov 2025 08:51:03 +0530
X-Gm-Features: AWmQ_bl6vRLXX6m0U52FQ2DFoq5CI8K9OrJ5lHyMJ06MscHnHBGcXaJnerylvnA
Message-ID: <CAJHc60y=rcbXixxT+dmKebQP3txcQbCDKr_tGrqVxjn9AFHuVg@mail.gmail.com>
Subject: Re: [PATCH 01/12] vfio: selftests: Split run.sh into separate scripts
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 9, 2025 at 4:56=E2=80=AFAM David Matlack <dmatlack@google.com> =
wrote:
>
> Split run.sh into separate scripts (setup.sh, run.sh, cleanup.sh) to
> enable multi-device testing, and prepare for VFIO selftests
> automatically detecting which devices to use for testing by storing
> device metadata on the filesystem.
>
>  - setup.sh takes one or more BDFs as arguments and sets up each device.
>    Metadata about each device is stored on the filesystem in the
>    directory:
>
>            ${TMPDIR:-/tmp}/vfio-selftests-devices
>
>    Within this directory is a directory for each BDF, and then files in
>    those directories that cleanup.sh uses to cleanup the device.
>
>  - run.sh runs a selftest by passing it the BDFs of all set up devices.
>
>  - cleanup.sh takes zero or more BDFs as arguments and cleans up each
>    device. If no BDFs are provided, it cleans up all devices.
>
> This split enables multi-device testing by allowing multiple BDFs to be
> set up and passed into tests:
>
> For example:
>
>   $ tools/testing/selftests/vfio/scripts/setup.sh <BDF1> <BDF2>
>   $ tools/testing/selftests/vfio/scripts/setup.sh <BDF3>
>   $ tools/testing/selftests/vfio/scripts/run.sh echo
>   <BDF1> <BDF2> <BDF3>
>   $ tools/testing/selftests/vfio/scripts/cleanup.sh
>
> If the future, VFIO selftests can automatically detect set up devices by
nit: s/If/In

> +function cleanup_devices() {
> +       local device_bdf
> +       local device_dir
> +
> +       for device_bdf in "$@"; do
> +               device_dir=3D${DEVICES_DIR}/${device_bdf}
> +
> +               if [ -f ${device_dir}/vfio-pci ]; then
> +                       unbind ${device_bdf} vfio-pci
> +               fi
> +
> +               if [ -f ${device_dir}/driver_override ]; then
> +                       clear_driver_override ${device_bdf}
> +               fi
> +
> +               if [ -f ${device_dir}/driver ]; then
> +                       bind ${device_bdf} $(cat ${device_dir}/driver)
> +               fi
> +
> +               if [ -f ${device_dir}/sriov_numvfs ]; then
> +                       set_sriov_numvfs ${device_bdf} $(cat ${device_dir=
}/sriov_numvfs)
> +               fi
> +
> +               rm -rf ${device_dir}
> +       done
> +
> +       rm -rf ${DEVICES_DIR}
Since the cleanup.sh can potentially be run against a single device,
we should probably check if no devices exist under ${DEVICES_DIR}
before removing the entire dir.

> +}
> +
> +function main() {
> +       if [ $# =3D 0 ]; then
> +               cleanup_devices $(ls ${DEVICES_DIR})
> +       else
> +               cleanup_devices "$@"
> +       fi
> +}
> +
> +main "$@"

> diff --git a/tools/testing/selftests/vfio/scripts/lib.sh b/tools/testing/=
selftests/vfio/scripts/lib.sh
> new file mode 100755
> index 000000000000..9f05f29c7b86
> --- /dev/null
> +++ b/tools/testing/selftests/vfio/scripts/lib.sh
> @@ -0,0 +1,42 @@
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +
> +readonly DEVICES_DIR=3D"${TMPDIR:-/tmp}/vfio-selftests-devices"
> +
> +function write_to() {
> +       # Unfortunately set -x does not show redirects so use echo to man=
ually
> +       # tell the user what commands are being run.
> +       echo "+ echo \"${2}\" > ${1}"
> +       echo "${2}" > ${1}
> +}
> +
> +function get_driver() {
> +       if [ -L /sys/bus/pci/devices/${1}/driver ]; then
> +               basename $(readlink -m /sys/bus/pci/devices/${1}/driver)
> +       fi
> +}
> +
> +function bind() {
> +       write_to /sys/bus/pci/drivers/${2}/bind ${1}
> +}
Since these scripts reside within the selftests/vfio/ dir, and most of
these functions target PCI aspects, should we hardcode `vfio-pci` as
the driver instead of passing the arg around? This is a general
question/suggestion for the patch. We can even rename it to
<op>_vfio_pci() (bind_vfio_pci() for example) for better clarity.

> +
> +function unbind() {
> +       write_to /sys/bus/pci/drivers/${2}/unbind ${1}
> +}
> +
> +function set_sriov_numvfs() {
> +       write_to /sys/bus/pci/devices/${1}/sriov_numvfs ${2}
> +}
> +
Similar to get_sriov_numvfs(), shall we check the existence of the
'sriov_numvfs' first? In the current workflow, we indirectly check for
the file using get_sriov_numvfs() or look for 'sriov_numvfs' in the
${device_bdf}. However, an independent check would be cleaner and
safer (for any future references). WDYT?

> +function get_sriov_numvfs() {
> +       if [ -f /sys/bus/pci/devices/${1}/sriov_numvfs ]; then
> +               cat /sys/bus/pci/devices/${1}/sriov_numvfs
> +       fi
> +}
> +

> +function main() {
> +       local device_bdf
> +       local device_dir
> +       local numvfs
> +       local driver
> +
> +       if [ $# =3D 0 ]; then
> +               echo "usage: $0 segment:bus:device.function ..." >&2
> +               exit 1
> +       fi
> +
> +       for device_bdf in "$@"; do
> +               test -d /sys/bus/pci/devices/${device_bdf}
> +
> +               device_dir=3D${DEVICES_DIR}/${device_bdf}
> +               if [ -d "${device_dir}" ]; then
> +                       echo "${device_bdf} has already been set up, exit=
ing."
> +                       exit 0
> +               fi
> +
> +               mkdir -p ${device_dir}
> +
> +               numvfs=3D$(get_sriov_numvfs ${device_bdf})
> +               if [ "${numvfs}" ]; then
> +                       set_sriov_numvfs ${device_bdf} 0
> +                       echo ${numvfs} > ${device_dir}/sriov_numvfs
> +               fi
> +
> +               driver=3D$(get_driver ${device_bdf})
> +               if [ "${driver}" ]; then
> +                       unbind ${device_bdf} ${driver}
> +                       echo ${driver} > ${device_dir}/driver
Sorry, what is the purpose of writing the driver's name to the
"driver" file? Isn't "unbind" sufficient?

> +               fi
> +
Since vfio-pci can be built as a module that may not be loaded yet (or
even disabled), do you think it's worth checking before binding the
device to the driver? Of course, these operations would fail, but
would it be better if we informed users why?

> +               set_driver_override ${device_bdf} vfio-pci
> +               touch ${device_dir}/driver_override
> +
> +               bind ${device_bdf} vfio-pci
> +               touch ${device_dir}/vfio-pci
> +       done
> +}
> +
> +main "$@"
> --

Thank you.
Raghavendra

