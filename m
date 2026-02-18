Return-Path: <kvm+bounces-71220-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8C7lDyKYlWk1SgIAu9opvQ
	(envelope-from <kvm+bounces-71220-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 11:44:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9362A1559D3
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 11:44:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7C147304AACE
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 10:43:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B8253009DA;
	Wed, 18 Feb 2026 10:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hac+poap";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sSanYZb0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39672FFF98
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 10:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771411433; cv=none; b=lR9NTJFlv4AYDP+uxH2+m2FEsRj56G0qok5+7SIk8HuJmgtbQNQ50epm+HC/xNqvOvX/TDFaDhwz6FyjiQL8kUz3redk+zNcsX5nKAkCQrSrpX4Vaxnz4+g5hu9n8cg8Z7+/RaXBM1uIMF1cshK8TPijE0JQQzXBCvoHyYs+T5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771411433; c=relaxed/simple;
	bh=vs01qvgYJsnWbZD7RPRe5+RrLzHQ11mT4rvtlCK+odQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QONNFsrw6gDCVT2rVWudBx4QAlhThnRs3p0sxj8MjaDsPu3SM+z6eUdnKrEwirxs2Icz4fq82IL1B0t8Yp8oHx/EwlDZbw9CFodryvGRMGG9YPlSoxbObDWEv0LYi99/5sytT/c+7ZtAPW8lAAMG5CQsSZszO0LGUXIg7TjxKV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hac+poap; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sSanYZb0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771411431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fe1gy+WdvmYe1mvohV7Dt8/rkDiaG76OuN5B9cWwu48=;
	b=hac+poapF49eo0IImtqHHUQaq4skFHjsgobTTmxdxeYfqCor7hoMqhg1vU7BmzgGiCBDPm
	eaXBwiiz7rmCCPShFthFghGtvVUxeTb18qg27qb0gUqGpEon1S8C3e2tW9S43YlfqWT0KZ
	bXJAWK5VYEK6weNOFVfjyVydtkyX+Q8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-8ZQY4YiMOJiHswMg0WJLDQ-1; Wed, 18 Feb 2026 05:43:49 -0500
X-MC-Unique: 8ZQY4YiMOJiHswMg0WJLDQ-1
X-Mimecast-MFC-AGG-ID: 8ZQY4YiMOJiHswMg0WJLDQ_1771411428
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4830e7c6131so50585185e9.2
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 02:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771411428; x=1772016228; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fe1gy+WdvmYe1mvohV7Dt8/rkDiaG76OuN5B9cWwu48=;
        b=sSanYZb0SfrlWqK1KrAPv7ShKmrLg9iC+uRUj0ymn24HnjIna1Fy1BL7sNLh8sa6k2
         +heZ3dAm7TSG4oKb1EokbLKYFyVUHA9mKpgFHCF2RbxfwhYpi9nGSLkrNqILfJlf0/6Y
         RD+pr8UMMupHEAPDB7TdcNwNIVKKGlPBBZmrdAzY2s/H/YqjTrgF8ZbERyElswroqWaP
         YXv+I5NmGYNCmsxtIbEwR6jbQ8JdkfT9yAdx1yKWbTgfa2GOY0sHZ2Rm8dlOo/3AO1iZ
         bQDf6ZPpR/Z6Nxl7HIZ3gkRYQdcVdZTuCbJuoSfp9r0b2bQvQG9c9/cFvVNdIwxDlpL+
         RMxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771411428; x=1772016228;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fe1gy+WdvmYe1mvohV7Dt8/rkDiaG76OuN5B9cWwu48=;
        b=ZzieUf6rsKUTfDp3YSp6lmPnuezpQY2kVSLsdS1hl5yqwyWt8mcXK/nhOXCmn9+3Gg
         Qkp7D5TQkuE0YnZF5kEsY/Qi12+e9qFHwPBmFmLfttIAikFv7r2PaC2yfKuixcJVYwHN
         GibUV86RuT7pyGjTYkU6/WG/moSdMtqFEOhN2wMC650i1I7VqgwKjNH8sW13hL2TWn45
         IRxYNu8R08aMaeS3U+E2p5r8RX2FJOYMaN1kfOIKdsLYUUE8vjLA8OsE+eJ0erbeww9B
         LKXWMwASpHJ2/wvlKdCvTiPQcywFN2+3eYf8fRF6MFNfe5Umik/cegbg2TJzwtosw++h
         CXhQ==
X-Forwarded-Encrypted: i=1; AJvYcCWbFQcGVrk43o0WEq3qgRa2y4MuybgGPE+dC9Iw0NdYNchpm9u/L2HSWtvSg1LdsFJjxxM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvYNRyNmepNZ144aEE2ZMga7CCNVrNJuQEvbvU5FZCXGA1L/Zh
	FzxhTLXkb0xJS3QNoO4aBD+yMnC/RoWM5PtgeN0JQ2mzCa++aaIy0AoblUbkDd3YC9W1dXNu5d6
	ewm9xJUp3XG7NgscexOnXHBv6TyGmflIUwKDF3nbxM+r5GhReDN5maw==
X-Gm-Gg: AZuq6aKapNVG//5cxGeY5Mp+bNCS8qPyF9yo5wT61KLAKM1bELGfpPlrRm7nuP8OsMS
	VRuprbAhBJ1nR7aGQakaZiuDJT8e3AxaMxgqOBtaUumH5+5rp+HTvP9oFIG7c1JoFHVVVIbUnN6
	rOfiPo7wMv+i/iS4PAK/3w0CVYsZ6sHXc3y9ZbPUW8jTwwABgdWruT/ey95sKCo9DAvnabcmddH
	bfOPTdHlztm3yxRuoANXRa1Zn0RZthWy6DCsw2DCYlIOkOx9fO11g7ZyL9khGYfoOHh8KI/+wJS
	uuFuqmBeuardbkO0F0uO7RovrdCjYXlg3oaRMiBaF71bIzJiRDqyRZ54VNs9rIurQA+B03wf7Cz
	Se8x7Qz4Wc5PBD8dY7tfvAvGO6lddxb35Xu07FKM/j6tzCgwgWWASWCzaRyBW7EAAd5hL9YA=
X-Received: by 2002:a05:600c:1d0b:b0:475:dde5:d91b with SMTP id 5b1f17b1804b1-48379be820fmr252895275e9.17.1771411428169;
        Wed, 18 Feb 2026 02:43:48 -0800 (PST)
X-Received: by 2002:a05:600c:1d0b:b0:475:dde5:d91b with SMTP id 5b1f17b1804b1-48379be820fmr252894855e9.17.1771411427663;
        Wed, 18 Feb 2026 02:43:47 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796a5d156sm44633988f8f.5.2026.02.18.02.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 02:43:46 -0800 (PST)
Date: Wed, 18 Feb 2026 11:43:42 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Bobby Eshleman <bobbyeshleman@meta.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Daan De Meyer <daan.j.demeyer@gmail.com>
Subject: Re: [PATCH net] vsock: lock down child_ns_mode as write-once
Message-ID: <aZWUmbiH11Eh3Y4v@sgarzare-redhat>
References: <20260217-vsock-ns-write-once-v1-1-a1fb30f289a9@meta.com>
 <aZV6HRAIsf_rNRM2@sgarzare-redhat>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aZV6HRAIsf_rNRM2@sgarzare-redhat>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71220-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[davemloft.net,google.com,kernel.org,redhat.com,meta.com,lists.linux.dev,vger.kernel.org,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sgarzare@redhat.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,meta.com:email]
X-Rspamd-Queue-Id: 9362A1559D3
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 11:02:02AM +0100, Stefano Garzarella wrote:
>On Tue, Feb 17, 2026 at 05:45:10PM -0800, Bobby Eshleman wrote:
>>From: Bobby Eshleman <bobbyeshleman@meta.com>
>>
>>To improve the security posture of vsock namespacing, this patch locks
>>down the vsock child_ns_mode sysctl setting with a write-once policy.
>>The user may write to child_ns_mode only once in each namespace, making
>>changes to either local or global mode be irreversible.
>>
>>This avoids security breaches where a process in a local namespace may
>>attempt to jailbreak into the global vsock ns space by setting
>>child_ns_mode to "global", creating a new namespace, and accessing the
>>global space through the new namespace.
>
>Commit 6a997f38bdf8 ("vsock: prevent child netns mode switch from 
>local to global") should avoid exactly that, so I don't get this. Can 
>you elaborate more how this can happen without this patch?
>
>I think here we should talk more about what we described in 
>https://lore.kernel.org/netdev/aZNNBc390y6V09qO@sgarzare-redhat/ which 
>is that two administrator processes could compete in setting 
>`child_ns_mode` and end up creating a namespace with an `ns_mode` 
>different from the one set in `child_ns_mode`. But I would also 
>explain that this can still be detected by the process by looking at 
>`ns_mode` and trying again.  With this patch, we avoid this and allow 
>the namespace manager to set it once and be sure that it cannot be 
>changed again.
>
>>
>>Additionally, fix the test functions that this change would otherwise
>>break by adding "global-parent" and "local-parent" namespaces and using
>>them as intermediaries to spawn namespaces in the given modes. This
>>avoids the need to change "child_ns_mode" in the init_ns. nsenter must
>>be used because ip netns unshares the mount namespace so nested "ip
>>netns add" breaks exec calls from the init ns.
>
>I'm not sure what the policy is in netdev, but I would prefer to have 
>selftest changes in another patch (I think earlier in the series so as 
>not to break the bisection), in order to simplify backporting (e.g. in 
>CentOS Stream, to keep the backport small, I didn't backport the 
>dozens of patches for selftest that we did previously).
>
>Obviously, if it's not possible and breaks the bisection, I can safely 
>skip these changes during the backport.
>
>>
>>Test run:
>>
>>1..25
>>ok 1 vm_server_host_client
>>ok 2 vm_client_host_server
>>ok 3 vm_loopback
>>ok 4 ns_host_vsock_ns_mode_ok
>>ok 5 ns_host_vsock_child_ns_mode_ok
>>ok 6 ns_global_same_cid_fails
>>ok 7 ns_local_same_cid_ok
>>ok 8 ns_global_local_same_cid_ok
>>ok 9 ns_local_global_same_cid_ok
>>ok 10 ns_diff_global_host_connect_to_global_vm_ok
>>ok 11 ns_diff_global_host_connect_to_local_vm_fails
>>ok 12 ns_diff_global_vm_connect_to_global_host_ok
>>ok 13 ns_diff_global_vm_connect_to_local_host_fails
>>ok 14 ns_diff_local_host_connect_to_local_vm_fails
>>ok 15 ns_diff_local_vm_connect_to_local_host_fails
>>ok 16 ns_diff_global_to_local_loopback_local_fails
>>ok 17 ns_diff_local_to_global_loopback_fails
>>ok 18 ns_diff_local_to_local_loopback_fails
>>ok 19 ns_diff_global_to_global_loopback_ok
>>ok 20 ns_same_local_loopback_ok
>>ok 21 ns_same_local_host_connect_to_local_vm_ok
>>ok 22 ns_same_local_vm_connect_to_local_host_ok
>>ok 23 ns_delete_vm_ok
>>ok 24 ns_delete_host_ok
>>ok 25 ns_delete_both_ok
>>SUMMARY: PASS=25 SKIP=0 FAIL=0
>
>IMO this can be removed from the commit message, doesn't add much 
>value other than say that all test passes.
>
>>
>>Fixes: eafb64f40ca4 ("vsock: add netns to vsock core")
>>Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>>Suggested-by: Daan De Meyer <daan.j.demeyer@gmail.com>
>>Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
>>---
>>include/net/af_vsock.h                  |  6 +++++-
>>include/net/netns/vsock.h               |  1 +
>>net/vmw_vsock/af_vsock.c                | 10 ++++++----
>>tools/testing/selftests/vsock/vmtest.sh | 35 
>>+++++++++++++++------------------
>>4 files changed, 28 insertions(+), 24 deletions(-)
>>
>>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>>index d3ff48a2fbe0..c7de33039907 100644
>>--- a/include/net/af_vsock.h
>>+++ b/include/net/af_vsock.h
>>@@ -276,10 +276,14 @@ static inline bool vsock_net_mode_global(struct vsock_sock *vsk)
>>	return vsock_net_mode(sock_net(sk_vsock(vsk))) == VSOCK_NET_MODE_GLOBAL;
>>}
>>
>>-static inline void vsock_net_set_child_mode(struct net *net,
>>+static inline bool vsock_net_set_child_mode(struct net *net,
>>					    enum vsock_net_mode mode)
>>{
>>+	if (xchg(&net->vsock.child_ns_mode_locked, 1))
>>+		return false;
>>+
>>	WRITE_ONCE(net->vsock.child_ns_mode, mode);
>>+	return true;
>>}
>>
>>static inline enum vsock_net_mode vsock_net_child_mode(struct net *net)
>>diff --git a/include/net/netns/vsock.h b/include/net/netns/vsock.h
>>index b34d69a22fa8..8c855fff8039 100644
>>--- a/include/net/netns/vsock.h
>>+++ b/include/net/netns/vsock.h
>>@@ -17,5 +17,6 @@ struct netns_vsock {
>>
>>	enum vsock_net_mode mode;
>>	enum vsock_net_mode child_ns_mode;
>>+	int child_ns_mode_locked;
>>};
>>#endif /* __NET_NET_NAMESPACE_VSOCK_H */
>>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>index 9880756d9eff..35e097f4fde8 100644
>>--- a/net/vmw_vsock/af_vsock.c
>>+++ b/net/vmw_vsock/af_vsock.c
>>@@ -90,14 +90,15 @@
>> *
>> *   - /proc/sys/net/vsock/ns_mode (read-only) reports the current namespace's
>> *     mode, which is set at namespace creation and immutable thereafter.
>>- *   - /proc/sys/net/vsock/child_ns_mode (writable) controls what mode future
>>+ *   - /proc/sys/net/vsock/child_ns_mode (write-once) controls what mode future
>> *     child namespaces will inherit when created. The initial value matches
>> *     the namespace's own ns_mode.
>> *
>> *   Changing child_ns_mode only affects newly created namespaces, not the
>> *   current namespace or existing children. A "local" namespace cannot set
>>- *   child_ns_mode to "global". At namespace creation, ns_mode is inherited
>>- *   from the parent's child_ns_mode.
>>+ *   child_ns_mode to "global". child_ns_mode is write-once, so that it may
>>+ *   be configured and locked down by a namespace manager. At namespace
>>+ *   creation, ns_mode is inherited from the parent's child_ns_mode.
>
>We just merged commit a07c33c6f2fc ("vsock: document namespace mode 
>sysctls") in the net tree, so we should update also 
>Documentation/admin-guide/sysctl/net.rst
>
>> *
>> *   The init_net mode is "global" and cannot be modified.
>
>Maybe we should also emphasise in the documentation and in the commit 
>description that `child_ns_mode` in `init_net` also is write-once, so
>writing `local` to that one by the init process (e.g. systemd), 
>essentially will make all the new namespaces in `local` mode. This 
>could be useful for container/namespace managers.
>
>> *
>>@@ -2853,7 +2854,8 @@ static int vsock_net_child_mode_string(const struct ctl_table *table, int write,
>>		    new_mode == VSOCK_NET_MODE_GLOBAL)
>>			return -EPERM;
>>
>>-		vsock_net_set_child_mode(net, new_mode);
>>+		if (!vsock_net_set_child_mode(net, new_mode))
>>+			return -EPERM;
>
>So, if `child_ns_mode` is set to `local` but locked, writing `local` 
>again will return -EPERM, is this really what we want?
>
>I'm not sure if we can relax it a bit, but then we may race between 
>reader and writer, so maybe it's fine like it is in this patch, but we 
>should document better that any writes (even same value) after the 
>first one will return -EPERM.

I think we can try in this way:

static inline bool vsock_net_set_child_mode(struct net *net,
					    enum vsock_net_mode mode)
{
	int new_locked = mode + 1;
	int old_locked = 0;

	if (try_cmpxchg(&net->vsock.child_ns_mode_locked,
			&old_locked, new_locked)) {
		WRITE_ONCE(net->vsock.child_ns_mode, mode);
		return true;
	}

	return old_locked == new_locked;
}

With a comment like this near child_ns_mode_locked in struct 
netns_vsock:
/* 0 = unlocked
  * 1 = locked to GLOBAL (VSOCK_NET_MODE_GLOBAL + 1)
  * 2 = locked to LOCAL  (VSOCK_NET_MODE_LOCAL + 1)
  */

While writing that, I thought that we can even remove 
`child_ns_mode_locked` and use a single variable where encode the value 
and the state, but maybe it's an unnecessary extra complexity.

Stefano

>
>About that, should we return something different, like -EBUSY ?
>Not a strong opinion, just to differentiate with the other check before.
>
>Thanks,
>Stefano


