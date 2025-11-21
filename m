Return-Path: <kvm+bounces-64149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DA5D0C7A4FB
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 15:52:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4706B4F2BB8
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 14:43:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E2213446B0;
	Fri, 21 Nov 2025 14:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X2gzx6bc";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="V272h6uP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1D42E9730
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 14:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763736147; cv=none; b=GgBw+LqHEji6kNYtipGOL0pxDi+zZaD3r3+TB+ZhsSOCBz2F3x03CSWgiuMoQpnWc1P1S/BPUp7VeZ+1BnhKTXpwy9YUr4BnloIrBtyp1xRGKzkWyyskJiTHkYL72JdiTFcez/uCrU1BFywpz6CVHQBldcEVnC4FifPJ0ZE4vEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763736147; c=relaxed/simple;
	bh=tL0PrPRXzvFMNUmQZS+jeR6hm5nHn34kXXtan4Z4rYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GEc+TFAw3cdzB2t156FdA6wGIAA3gle6k7x8xNWjoPWrNGGxd3QQwqSjGKiWJ+x6DBHVnT3vQTcGa96IVkFpYCUMzd3vAdnI12SVtlW3QWpWuHV/jP5rwhT1IE4AJdB7Va00DzHqQYjFh3DA7BAtKopstnBzl8maMJ9gFbTZqqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X2gzx6bc; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=V272h6uP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763736143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2ff3oUHYY/i63OgG2+W0AQ3qdCRaCGyr4AzC1ltc0qE=;
	b=X2gzx6bc16zSelkG1K/mhldK0obKazHJOWhlq34su6y/xZklYYr27k0QLxSgcfZE5x+Qx5
	jcQjdrFqfm0kpWxBhdu7K81BgGqH/JpmlUtciDSZKwf9AjPObaaPiQc3HIOR5zuERRpLfq
	/nByQC6UEHcwDczRTEA7h3knugMX/Po=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-CLkAYp3sPr6j5W_hss8H2g-1; Fri, 21 Nov 2025 09:42:22 -0500
X-MC-Unique: CLkAYp3sPr6j5W_hss8H2g-1
X-Mimecast-MFC-AGG-ID: CLkAYp3sPr6j5W_hss8H2g_1763736141
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-b73599315adso165790466b.2
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 06:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763736141; x=1764340941; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2ff3oUHYY/i63OgG2+W0AQ3qdCRaCGyr4AzC1ltc0qE=;
        b=V272h6uPvKDmLWXeTnrZtJUWLFDAaaY1sZAO7reLFizcQYkESVK+tT+9qrNdNMc8Ci
         8Zkv9Yh0ESL2ODfjJBh6+TQKsER7Tyg3VT3Yr6/xBE+ALo3nkeWFVbm2UTiC0DOxRyAE
         jipPIAXKZRuexsOMobnma9+IGGimlhlrfiTiB2pqd9w9x/HhhQ5MPuY1IfRcRJbM8Blu
         pDUQDRXw3+zpaOzZ7ROaj5MHc23RWoVssOum9Rp2uqDBQ4Ga2QmhPh7tNS2FKin760TJ
         1kBT4ReV3WZOZfvbn4w/wbOgn5NYTe5F5a/Dv7XFyK5GTgNYAuJS8L7O3m7j6YYZWT3I
         sEDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763736141; x=1764340941;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2ff3oUHYY/i63OgG2+W0AQ3qdCRaCGyr4AzC1ltc0qE=;
        b=AcOfq+UKgSCRcv+D3k3qtMfCW6o0TG1Xw3fnI/sDNs6wKwhmMblFrk1HABTIakjKsw
         6uEl3c7+LF6Pg6KZMzum+dmJzMEhmKkBtcnNfK+VF5+t0Ef+mRtkjt13wWv4EsWltir2
         Le90C6bDHp/9ztxQ0lMNKbU0F7owakKfv4Wz3MnCuhxjpe0e05BZI8IdBgqiAj8iVfv8
         oq9G8Yika/Mu6Gjt8+PX3OZcC8VbQPkhJL65G6hCfR7fduxu4GCxvEHP1oOCgpRDsd4m
         AVksUS0koANXRJFBoenlJw6RZYV4ZfL8qBjnCpAm+ms13knrQ9bQnO04mzFoGGU3a77s
         vJXg==
X-Forwarded-Encrypted: i=1; AJvYcCU+I7i/SwQtYS834P1BmjcWfNqlGjpXRxn44vt3Ob8S8JEimh22BbcmY6joF2+smE5lo0k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxg0isRIvuJL1VV4bYwhkjvf7SOATDfC5ex2tcUaM2wpPozWJRr
	Q3bWwb5bMYyPQdjhDt6EPKOrSTTRBpoVSjyUKnQ6j4ASQcjRIF+toq1qAvqE5Ck8rbEXmLalTRY
	d9nkwexAfvwUj/aAuiWro1SRvv4Q8QwvAmM5hZc5oBWi7SdLonFs8pA==
X-Gm-Gg: ASbGncsZJrwQsUlkLbeT7MtNB15sSpV1an01QOtQRxuZhs0HJynAYW1LjZ33UV1vK8Z
	+9SIbFuMIiQt+3inda7hzFH/cAXQHDITWWHMnEwZvfHKVGAlqNI/NxpVFX96cjERm2tgtzV8b+/
	yMrH/tmJuPdHuPTDQKujRmplfW49yFrGP2AAIvouClrlpJyWMCGIaytibAnEliCwtuc4SKwIts3
	b/pL5OyidECqi1wKBTdwvc/2m4pcUUUgvyVqXorMnq2MPFn+ev6jO0WPDj+ywgR4gwhcithv24J
	wOHzn7SN8Vyr+cq1H2VuELEcEOKd5z69cwSIfUjWnmtF7lTzn/h+8FjGbmd+56gKfLzJ0vQHI4Z
	K70MFRu+wAWRNeLZ3PGF++FBB6nATUEgOW8H3FJibkbmMFVOJFpyZELgY1FLkCA==
X-Received: by 2002:a17:907:3e15:b0:b76:6c85:9b60 with SMTP id a640c23a62f3a-b767125f72amr248163866b.0.1763736141028;
        Fri, 21 Nov 2025 06:42:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGpQh6yhHLGUKo/wsq6kHeGVp0vh9x4lS+/i68Gveg8Lfs4eInJ/Ie4BbRYyCHHJYP4NTl6tw==
X-Received: by 2002:a17:907:3e15:b0:b76:6c85:9b60 with SMTP id a640c23a62f3a-b767125f72amr248158866b.0.1763736140567;
        Fri, 21 Nov 2025 06:42:20 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-139-91.business.telecomitalia.it. [87.12.139.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76550191c8sm460235266b.54.2025.11.21.06.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 06:42:19 -0800 (PST)
Date: Fri, 21 Nov 2025 15:42:16 +0100
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
Subject: Re: [PATCH net-next v11 08/13] selftests/vsock: add
 vm_dmesg_{warn,oops}_count() helpers
Message-ID: <xswlfomv65abcbcp6vcjzu5vr7hen4rvayviniyjynawvq5ghn@wmp224bnmpd4>
References: <20251120-vsock-vmtest-v11-0-55cbc80249a7@meta.com>
 <20251120-vsock-vmtest-v11-8-55cbc80249a7@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251120-vsock-vmtest-v11-8-55cbc80249a7@meta.com>

On Thu, Nov 20, 2025 at 09:44:40PM -0800, Bobby Eshleman wrote:
>From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>These functions are reused by the VM tests to collect and compare dmesg
>warnings and oops counts. The future VM-specific tests use them heavily.
>This patches relies on vm_ssh() already supporting namespaces.
>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>---
>Changes in v11:
>- break these out into an earlier patch so that they can be used
>  directly in new patches (instead of causing churn by adding this
>  later)
>---
> tools/testing/selftests/vsock/vmtest.sh | 19 +++++++++++++++----
> 1 file changed, 15 insertions(+), 4 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
>index 4da91828a6a0..1623e4da15e2 100755
>--- a/tools/testing/selftests/vsock/vmtest.sh
>+++ b/tools/testing/selftests/vsock/vmtest.sh
>@@ -389,6 +389,17 @@ host_wait_for_listener() {
> 	fi
> }
>
>+vm_dmesg_oops_count() {
>+	local ns=$1
>+
>+	vm_ssh "${ns}" -- dmesg 2>/dev/null | grep -c -i 'Oops'
>+}
>+
>+vm_dmesg_warn_count() {
>+	local ns=$1
>+
>+	vm_ssh "${ns}" -- dmesg --level=warn 2>/dev/null | grep -c -i 'vsock'
>+}
>
> vm_vsock_test() {
> 	local ns=$1
>@@ -596,8 +607,8 @@ run_shared_vm_test() {
>
> 	host_oops_cnt_before=$(dmesg | grep -c -i 'Oops')
> 	host_warn_cnt_before=$(dmesg --level=warn | grep -c -i 'vsock')
>-	vm_oops_cnt_before=$(vm_ssh -- dmesg | grep -c -i 'Oops')
>-	vm_warn_cnt_before=$(vm_ssh -- dmesg --level=warn | grep -c -i 'vsock')
>+	vm_oops_cnt_before=$(vm_dmesg_oops_count "init_ns")
>+	vm_warn_cnt_before=$(vm_dmesg_warn_count "init_ns")
>
> 	name=$(echo "${1}" | awk '{ print $1 }')
> 	eval test_"${name}"
>@@ -615,13 +626,13 @@ run_shared_vm_test() {
> 		rc=$KSFT_FAIL
> 	fi
>
>-	vm_oops_cnt_after=$(vm_ssh -- dmesg | grep -i 'Oops' | wc -l)
>+	vm_oops_cnt_after=$(vm_dmesg_oops_count "init_ns")
> 	if [[ ${vm_oops_cnt_after} -gt ${vm_oops_cnt_before} ]]; then
> 		echo "FAIL: kernel oops detected on vm" | log_host
> 		rc=$KSFT_FAIL
> 	fi
>
>-	vm_warn_cnt_after=$(vm_ssh -- dmesg --level=warn | grep -c -i 'vsock')
>+	vm_warn_cnt_after=$(vm_dmesg_warn_count "init_ns")
> 	if [[ ${vm_warn_cnt_after} -gt ${vm_warn_cnt_before} ]]; then
> 		echo "FAIL: kernel warning detected on vm" | log_host
> 		rc=$KSFT_FAIL
>
>-- 
>2.47.3
>


