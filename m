Return-Path: <kvm+bounces-71345-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UNiMMYnnlmmNqwIAu9opvQ
	(envelope-from <kvm+bounces-71345-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 11:35:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F5AB15DD71
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 11:35:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E80AA303745A
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 10:35:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C9F533710F;
	Thu, 19 Feb 2026 10:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OnG8/tQg";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="oQV4QSAi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2D62F39A7
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 10:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771497328; cv=none; b=uzSHHFpCasooR9ilED3hiA2fEpTNw4XXgu3eRbu8pTmqhICuWVSNXWJ6uWpZDx0oeJ7r2sJKudCBdCTP6g9x3Fr7zczGZwzH9yZ3yWjXy06uwIp1ozInFcu28N0aWj3M2Y7QBs1EXIPRNj7QuHUwXkphzT+UUpZ/In4uchs8KOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771497328; c=relaxed/simple;
	bh=JzgTJfCZThD8ADnrrzOcTouopRq3PU+mfSlCjHNTIqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ueT5vjad0i6Drvd2WS917GJ/oIh5UIRpmGBOcsO++Zabrd42boTPRur8H2SkQlg1Trhka/HBdioZTbkVFBcJ1aH+FUQoyWZcA7aAh2empw/299VzXPXJR8fAAob8TYRfQnCed3vnh0ByRpwdhHbDW6OQDtKHn3AHgk3Ji32fFoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OnG8/tQg; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=oQV4QSAi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771497326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3F3zYoVrT9qjM5rAq+b6pbd+/hnAt//GBzSEVJjvXTQ=;
	b=OnG8/tQggtNY3Lr8AVEqC7zh+Z9YSUah4pY0sWAoRIIuSTRkvgs6IF4gZ0p/eAp0HPkIJl
	AylTvKx/xPsLLPhd6v+kEDs83ueNQjuD48QiNLTnnCJ5RsSp1alM34hMg5nOA4tXb9SQ5D
	xXCtUegkUnaM24GQp9g9qfKoIwXmhYk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-318-RyNX1KEvOHqvCep9ptaxjw-1; Thu, 19 Feb 2026 05:35:24 -0500
X-MC-Unique: RyNX1KEvOHqvCep9ptaxjw-1
X-Mimecast-MFC-AGG-ID: RyNX1KEvOHqvCep9ptaxjw_1771497324
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4836abfc742so5248985e9.0
        for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 02:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771497323; x=1772102123; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3F3zYoVrT9qjM5rAq+b6pbd+/hnAt//GBzSEVJjvXTQ=;
        b=oQV4QSAim8zkAt72BCdWOW/0atkiHhZffjQCtYsgFklc3kS/jwjCiz8u1e7HRW5oTk
         Wuv9hWwMByh8Msm3JXH3PJoq9LT/SkPDTNWr08vO4/QUVKyZ5Ef6pWjWLG/SGaar/x0S
         yUNvU0yGNfcEd+sd6IyJwSqnz1lnRE+oqlWP6drNX6iy52JR/THCXp86qo9MMdqmR6HB
         9aHAbROjJoIxgfIgUhjHChfivheG1D8prFps4MwahKkkiCI/8DqBkdyJIr8ifNVepgJ1
         EM2rgXoUInohlTguN+Y9HTXjJenj7LRm0Sntz03CRG3ZDhlzaJNpzgqhSrzTdYLCWCgQ
         vZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771497323; x=1772102123;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3F3zYoVrT9qjM5rAq+b6pbd+/hnAt//GBzSEVJjvXTQ=;
        b=ob4S+1S0BwEuFRgLKhsLNW58pgesqHEVi1m+J2PZbGdrIFFVedYh4PkecN8o5F1B+G
         XujIFXkefsdKry0HED9tI0TxjyxhmkxezPd0gW0l4Yyp9i/KIEIf2xkniLSisLZpK+o8
         SOHQ1DCo3RGAafWbUbaUqcbyb/7gyC/e3tILa13u+dmDILKs+Cs8OrE4lE/W69GYLPx6
         jOcikycp8nqrhB9wsaonbzDzqVhikEQT3mgF0+d+oeHYYbrULzlNH4SImo74YooV36Cg
         h8lSwEZNYX574mJmJxmnRZOKZeTjvCalsVfDOi6OrGj1dI7sLl8dVfqRY1fIcVFzQxEV
         QnMA==
X-Forwarded-Encrypted: i=1; AJvYcCXcnUmRjHTiFoLSUdLiUswX5FuseUsCvNBRryyQbaSMEpCT/+JDB8nfeKgRGzaVYqC7XSw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSZ95vvd2TuyuvCG+bJEuiIzp58QYat/NlhoR4YhNcVxiCVUGp
	QtYnEI+KhT+f46CJT7q+3ez2vae285Q3hI1IVcX8GPQtfMfVBYRcBQex2MmVV8GLzrBZ3T7e9PW
	wPgGnBTjRgupAfEft8vOO4pV2quKoirsCtKkC/IQDn1pYcFEJpN1qUg==
X-Gm-Gg: AZuq6aKJilJgOtJ5+TerR8WMoEFjEsMS5jI8IRPYRc2pZks9ABm6vRIRwVBGaPZDvC7
	gKWAwlQOj2WO/R3XhFMzKwTQdeLbF1H3OuJrajndJB/LNPsD6bmGEx1xQyoNiFPAkIFQvUIJ7LO
	xNunFFY+4Z20ELmmAROyBhC+6oBbGMOcwE69UlaIN+/vAmmzJjklK8j4ViG2paEiijlkIy0wlFf
	YajH9M6Ez75iHUMiZT5Mkecha/3PffQvRQCPeoDtk/nUaLbJ4T3JUmqgp265p8hStITobfDcDBc
	xmmVPKmcqWQ/NpdXbe0VZWoFHBiLZBcD1S7yr7p3YFuBWHxt6ili4xZ4Q/WjFubTtRl8KVzasbN
	pJ2lhTyvIU70PM9w4qh+Ybi/HiDJfGrAdMaq5Vul2zkHH1W3fwLRnUdumXrGWn0efciyLTg8=
X-Received: by 2002:a05:600c:4eca:b0:483:6d4a:7e6d with SMTP id 5b1f17b1804b1-48379be60camr248733835e9.30.1771497323436;
        Thu, 19 Feb 2026 02:35:23 -0800 (PST)
X-Received: by 2002:a05:600c:4eca:b0:483:6d4a:7e6d with SMTP id 5b1f17b1804b1-48379be60camr248733415e9.30.1771497322976;
        Thu, 19 Feb 2026 02:35:22 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4839f96967bsm19658265e9.3.2026.02.19.02.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 02:35:21 -0800 (PST)
Date: Thu, 19 Feb 2026 11:35:19 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Bobby Eshleman <bobbyeshleman@meta.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH net v2 1/3] selftests/vsock: change tests to respect
 write-once child ns mode
Message-ID: <aZbNwPMSd6ridmBn@sgarzare-redhat>
References: <20260218-vsock-ns-write-once-v2-0-19e4c50d509a@meta.com>
 <20260218-vsock-ns-write-once-v2-1-19e4c50d509a@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260218-vsock-ns-write-once-v2-1-19e4c50d509a@meta.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71345-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	DKIM_TRACE(0.00)[redhat.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sgarzare@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,meta.com:email]
X-Rspamd-Queue-Id: 1F5AB15DD71
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 10:10:36AM -0800, Bobby Eshleman wrote:
>From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>The child_ns_mode sysctl parameter becomes write-once in a future patch
>in this series, which breaks existing tests. This patch updates the
>tests to respect this new policy. No additional tests are added.
>
>Add "global-parent" and "local-parent" namespaces as intermediaries to
>spawn namespaces in the given modes. This avoids the need to change
>"child_ns_mode" in the init_ns. nsenter must be used because ip netns
>unshares the mount namespace so nested "ip netns add" breaks exec calls
>from the init ns. Adds nsenter to the deps check.
>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>---
> tools/testing/selftests/vsock/vmtest.sh | 35 +++++++++++++++------------------
> 1 file changed, 16 insertions(+), 19 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
>index dc8dbe74a6d0..e1e78b295e41 100755
>--- a/tools/testing/selftests/vsock/vmtest.sh
>+++ b/tools/testing/selftests/vsock/vmtest.sh
>@@ -210,16 +210,17 @@ check_result() {
> }
>
> add_namespaces() {
>-	local orig_mode
>-	orig_mode=$(cat /proc/sys/net/vsock/child_ns_mode)
>+	ip netns add "global-parent" 2>/dev/null
>+	echo "global" | ip netns exec "global-parent" \
>+		tee /proc/sys/net/vsock/child_ns_mode &>/dev/null
>+	ip netns add "local-parent" 2>/dev/null
>+	echo "local" | ip netns exec "local-parent" \
>+		tee /proc/sys/net/vsock/child_ns_mode &>/dev/null
>
>-	for mode in "${NS_MODES[@]}"; do
>-		echo "${mode}" > /proc/sys/net/vsock/child_ns_mode
>-		ip netns add "${mode}0" 2>/dev/null
>-		ip netns add "${mode}1" 2>/dev/null
>-	done
>-
>-	echo "${orig_mode}" > /proc/sys/net/vsock/child_ns_mode
>+	nsenter --net=/var/run/netns/global-parent ip netns add "global0" 2>/dev/null
>+	nsenter --net=/var/run/netns/global-parent ip netns add "global1" 2>/dev/null
>+	nsenter --net=/var/run/netns/local-parent ip netns add "local0" 2>/dev/null
>+	nsenter --net=/var/run/netns/local-parent ip netns add "local1" 2>/dev/null
> }
>
> init_namespaces() {
>@@ -237,6 +238,8 @@ del_namespaces() {
> 		log_host "removed ns ${mode}0"
> 		log_host "removed ns ${mode}1"
> 	done
>+	ip netns del "global-parent" &>/dev/null
>+	ip netns del "local-parent" &>/dev/null
> }
>
> vm_ssh() {
>@@ -287,7 +290,7 @@ check_args() {
> }
>
> check_deps() {
>-	for dep in vng ${QEMU} busybox pkill ssh ss socat; do
>+	for dep in vng ${QEMU} busybox pkill ssh ss socat nsenter; do
> 		if [[ ! -x $(command -v "${dep}") ]]; then
> 			echo -e "skip:    dependency ${dep} not found!\n"
> 			exit "${KSFT_SKIP}"
>@@ -1231,12 +1234,8 @@ test_ns_local_same_cid_ok() {
> }
>
> test_ns_host_vsock_child_ns_mode_ok() {
>-	local orig_mode
>-	local rc
>-
>-	orig_mode=$(cat /proc/sys/net/vsock/child_ns_mode)
>+	local rc="${KSFT_PASS}"
>
>-	rc="${KSFT_PASS}"
> 	for mode in "${NS_MODES[@]}"; do
> 		local ns="${mode}0"
>
>@@ -1246,15 +1245,13 @@ test_ns_host_vsock_child_ns_mode_ok() {
> 			continue
> 		fi
>
>-		if ! echo "${mode}" > /proc/sys/net/vsock/child_ns_mode; then
>-			log_host "child_ns_mode should be writable to ${mode}"
>+		if ! echo "${mode}" | ip netns exec "${ns}" \
>+			tee /proc/sys/net/vsock/child_ns_mode &>/dev/null; then
> 			rc="${KSFT_FAIL}"
> 			continue
> 		fi
> 	done
>
>-	echo "${orig_mode}" > /proc/sys/net/vsock/child_ns_mode
>-
> 	return "${rc}"
> }
>
>
>-- 
>2.47.3
>


