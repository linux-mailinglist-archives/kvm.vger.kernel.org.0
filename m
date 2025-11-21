Return-Path: <kvm+bounces-64152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 64127C7A483
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 15:49:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 652B12DEDB
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 14:49:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDA4129B233;
	Fri, 21 Nov 2025 14:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yo1QhP+3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GRtP+FRY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24362882C5
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 14:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763736540; cv=none; b=aK355oMGXS8lMcjXF+XKBVFySFJ1Qc3NjDXMhf5soQauAFeOeaMw/lWpgajDrsdGN36FelyiXGQ5VI5mPBoHBEK39bN2qUQLK7sZObDDP6zyUeIoWUWNEE2V5UWeGs7aKN+YILCrDSLzzj0KMAi1mR8EUYVMX/jdhGh+dav0eEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763736540; c=relaxed/simple;
	bh=9ksRgIEpFArrDBwuWTU+fH3xIEsF+1N4YpMi7lIilCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mqsdBVHAI3Z8maEWtrBRNHxkKUjTkm0RlKrScHKG2NHIP5orE5S0YY/RLx+IBc3lOfOIBX2kOPcqteTKcaKsejmev7CWhSwcR5ABvf4tiiEoGeXsNnvmPHbQ6Xkyg2fDNnoWZODLcaBQCGekiuun8CskQrHMuWE+NWeH5rz3sG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yo1QhP+3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GRtP+FRY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763736537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qElSsFo0aW6CHPj9+eW97E36THKCE3lxiDkjHrXDAbA=;
	b=Yo1QhP+3kXxZ+bnRkd7tyvlHuNTMHqNNE/gRsHbrujC8PmTWLDJLrcMU9gkdTLLAqkzg6s
	1S/ioa50hkJaqLqXXfFMDi0VySfJC+1dtpbfNDixkHOE/5Hb7gih35kSqDgg1dYzmH542U
	VBXZgttMXHri9GnI+gt4o73kGMM2uwE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-O2nH_ClwPUW2Z_oHVUrfiA-1; Fri, 21 Nov 2025 09:48:55 -0500
X-MC-Unique: O2nH_ClwPUW2Z_oHVUrfiA-1
X-Mimecast-MFC-AGG-ID: O2nH_ClwPUW2Z_oHVUrfiA_1763736534
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-640ace5f40dso2134112a12.3
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 06:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763736534; x=1764341334; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qElSsFo0aW6CHPj9+eW97E36THKCE3lxiDkjHrXDAbA=;
        b=GRtP+FRYWH+cKEmhFTxSrAp+qgb02DIzaRMXa/S3rumesM16JfDg1+mURMWjyHMJBr
         EaVlXM6palPZApdwQsxzgTF/IoV+As2Rwad0A4WPaGLlqVwpPVzQqqfeOLiUpN9ez84h
         /myMEfm8VQ2Ba5TjEzg29laaoAdWhBA6/B0Vx71PkMvPelIueqRzgkWbPzAdf+Pp9h9t
         2/dI8y6s9Gds8ObQHGoU1MSMSq9zQ/uyqodz21xOs3ffhQR/3ruFUeNGBa1P2nUp8JwO
         EOBcuh0tGv4TXQcx+4iZ/o+yJ3cf+sdTxSIpXFkrhQVri3wTiFyEu9/l+/6eIqB5XNME
         /aAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763736534; x=1764341334;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qElSsFo0aW6CHPj9+eW97E36THKCE3lxiDkjHrXDAbA=;
        b=bNCeC61Y1//L8YDqRhHjmuZeTaF+pk3AOuoHpD5SqsBqriZEq/XRhSbSlRNIBMT4z/
         lQhe6w+XEbZ2BGBoq5J672ujOWYfZSxG8Xgdcj6x7PstNh2Gcwgq7HWwECywbhlL9GdV
         W+HvRYOxG1bp/eyL4EC19Wwo7Zbz/gT7TLUXOGcAq0thdgoB3zQqfq5KOakTqOsHkEJd
         qQNE8ZTc0Ve6ulNvo98HTcZiB81qeBibcboPKOuv2sNDaYHyMa60MBHNmCo1luX/aaKN
         NP28XQj4VLdoN5+cp34+User3IozdHuK9pI2amw/1GKp3a7cffypfqBYtFVEbHBTiT5z
         x8lA==
X-Forwarded-Encrypted: i=1; AJvYcCXmLzGI0BV7IDLqtZ18jY9cJaJSJ5Xjgx+OVNUu9Y6aOqRTIwwKYOmaUF5M9Ju+wsS0iTw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwoEh/1RdQxEaWYMSh+Fjwh6lKi3kBdwImMA9lyRPN2fKktPzKE
	xlk+lmMlUaoU5mGLQhSjy2rm5/Uovg6VmZCM8r6tP1vZjfK6VGpJg1AiqD2oLx+gAN1xqAxN3vS
	tHIu78DIj6Jv/4ebbu5UJMt1vP+Cw6Xv/RSScCFU07vD7dL7kbcu1cw==
X-Gm-Gg: ASbGnct3qHoL6Md7ee7H4Yl/npS9jvf9Boz32GdxJex1qSf3yr5bnaK3J1/eoFj8QlT
	MSmMEOfMYr5Ji3pgJale518veuTeOlEEdzcWfSdftpT23cNSjjeltz/2q8eXt27SAK+ObHIIwME
	tRjIBtTdwmpuc3lcljOsFrnR+gW6Nb0UGsOwAKCikFGdpb179FBxjt/pSf1EC/MBd/0RgbEjc+Y
	VX++WkmjufDuAUDiy63VQ9sa/lyFBI2DCICSW1vTFv4GXt1mKqhhV73nR6PjS07RuD7E3YVxpgm
	CHSBmZbp71jHwOGqy9vGrvhCgc99BMSTEl4IeQBpgTOzH4uXLlvGXx1ykZHJOU4cLYdMN3CdeE/
	tc2x7Fiu8p0DVaNr8A8V5xV4tYXFCq8HjspwpArkw3Tj9gm7V/X3L4vjXXf0/vQ==
X-Received: by 2002:a05:6402:50d0:b0:643:804a:fb54 with SMTP id 4fb4d7f45d1cf-64554335d3emr2541671a12.13.1763736534243;
        Fri, 21 Nov 2025 06:48:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFYJ6NYmSLizuNfGJGB7tJ5ZuOQzhRvgxOwNrAKBcDD7p9ENJ1FC64SfddE4bzlIpGVmVbelg==
X-Received: by 2002:a05:6402:50d0:b0:643:804a:fb54 with SMTP id 4fb4d7f45d1cf-64554335d3emr2541631a12.13.1763736533716;
        Fri, 21 Nov 2025 06:48:53 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-139-91.business.telecomitalia.it. [87.12.139.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6453645f2easm4585052a12.33.2025.11.21.06.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 06:48:53 -0800 (PST)
Date: Fri, 21 Nov 2025 15:48:41 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, kvm@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-kselftest@vger.kernel.org, berrange@redhat.com, 
	Sargun Dhillon <sargun@sargun.me>, Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v11 11/13] selftests/vsock: add namespace tests
 for CID collisions
Message-ID: <zpfacrsl6dxmo3ltwiovrcj4rtbqgnms4z6rwnw7o2jncgjw5c@hrorb4elx6mm>
References: <20251120-vsock-vmtest-v11-0-55cbc80249a7@meta.com>
 <20251120-vsock-vmtest-v11-11-55cbc80249a7@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251120-vsock-vmtest-v11-11-55cbc80249a7@meta.com>

On Thu, Nov 20, 2025 at 09:44:43PM -0800, Bobby Eshleman wrote:
>From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>Add tests to verify CID collision rules across different vsock namespace
>modes.
>
>1. Two VMs with the same CID cannot start in different global namespaces
>   (ns_global_same_cid_fails)
>2. Two VMs with the same CID can start in different local namespaces
>   (ns_local_same_cid_ok)
>3. VMs with the same CID can coexist when one is in a global namespace
>   and another is in a local namespace (ns_global_local_same_cid_ok and
>   ns_local_global_same_cid_ok)
>
>The tests ns_global_local_same_cid_ok and ns_local_global_same_cid_ok
>make sure that ordering does not matter.
>
>The tests use a shared helper function namespaces_can_boot_same_cid()
>that attempts to start two VMs with identical CIDs in the specified
>namespaces and verifies whether VM initialization failed or succeeded.
>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>---
>Changes in v11:
>- check vm_start() rc in namespaces_can_boot_same_cid() (Stefano)
>- fix ns_local_same_cid_ok() to use local0 and local1 instead of reusing
>  local0 twice. This check should pass, ensuring local namespaces do not
>  collide (Stefano)
>---
> tools/testing/selftests/vsock/vmtest.sh | 78 +++++++++++++++++++++++++++++++++
> 1 file changed, 78 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
>index 2e077e8a1777..f84da1e8ad14 100755
>--- a/tools/testing/selftests/vsock/vmtest.sh
>+++ b/tools/testing/selftests/vsock/vmtest.sh
>@@ -51,6 +51,10 @@ readonly TEST_NAMES=(
> 	ns_host_vsock_ns_mode_ok
> 	ns_host_vsock_ns_mode_write_once_ok
> 	ns_vm_local_mode_rejected
>+	ns_global_same_cid_fails
>+	ns_local_same_cid_ok
>+	ns_global_local_same_cid_ok
>+	ns_local_global_same_cid_ok
> )
> readonly TEST_DESCS=(
> 	# vm_server_host_client
>@@ -70,6 +74,18 @@ readonly TEST_DESCS=(
>
> 	# ns_vm_local_mode_rejected
> 	"Test that guest VM with G2H transport cannot set namespace mode to 'local'"
>+
>+	# ns_global_same_cid_fails
>+	"Check QEMU fails to start two VMs with same CID in two different global namespaces."
>+
>+	# ns_local_same_cid_ok
>+	"Check QEMU successfully starts two VMs with same CID in two different local namespaces."
>+
>+	# ns_global_local_same_cid_ok
>+	"Check QEMU successfully starts one VM in a global ns and then another VM in a local ns with the same CID."
>+
>+	# ns_local_global_same_cid_ok
>+	"Check QEMU successfully starts one VM in a local ns and then another VM in a global ns with the same CID."
> )
>
> readonly USE_SHARED_VM=(
>@@ -581,6 +597,68 @@ test_ns_host_vsock_ns_mode_ok() {
> 	return "${KSFT_PASS}"
> }
>
>+namespaces_can_boot_same_cid() {
>+	local ns0=$1
>+	local ns1=$2
>+	local pidfile1 pidfile2
>+	local rc
>+
>+	pidfile1="$(create_pidfile)"
>+
>+	# The first VM should be able to start. If it can't then we have
>+	# problems and need to return non-zero.
>+	if ! vm_start "${pidfile1}" "${ns0}"; then
>+		return 1
>+	fi
>+
>+	pidfile2="$(create_pidfile)"
>+	vm_start "${pidfile2}" "${ns1}"
>+	rc=$?
>+	terminate_pidfiles "${pidfile1}" "${pidfile2}"
>+
>+	return "${rc}"
>+}
>+
>+test_ns_global_same_cid_fails() {
>+	init_namespaces
>+
>+	if namespaces_can_boot_same_cid "global0" "global1"; then
>+		return "${KSFT_FAIL}"
>+	fi
>+
>+	return "${KSFT_PASS}"
>+}
>+
>+test_ns_local_global_same_cid_ok() {
>+	init_namespaces
>+
>+	if namespaces_can_boot_same_cid "local0" "global0"; then
>+		return "${KSFT_PASS}"
>+	fi
>+
>+	return "${KSFT_FAIL}"
>+}
>+
>+test_ns_global_local_same_cid_ok() {
>+	init_namespaces
>+
>+	if namespaces_can_boot_same_cid "global0" "local0"; then
>+		return "${KSFT_PASS}"
>+	fi
>+
>+	return "${KSFT_FAIL}"
>+}
>+
>+test_ns_local_same_cid_ok() {
>+	init_namespaces
>+
>+	if namespaces_can_boot_same_cid "local0" "local1"; then
>+		return "${KSFT_PASS}"
>+	fi
>+
>+	return "${KSFT_FAIL}"
>+}
>+
> test_ns_host_vsock_ns_mode_write_once_ok() {
> 	for mode in "${NS_MODES[@]}"; do
> 		local ns="${mode}0"
>
>-- 
>2.47.3
>


