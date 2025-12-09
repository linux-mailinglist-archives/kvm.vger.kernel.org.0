Return-Path: <kvm+bounces-65550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 057C8CB002C
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 14:06:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0D38A3022181
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 13:06:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13C7E331A7E;
	Tue,  9 Dec 2025 13:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aAuKquFS";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LCi5HFGP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8BE331A61
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 13:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765285563; cv=none; b=K1Mbr4ZAhf/OZEQ44T1av14fNVS/mM0qj3pAlqzvmEyKEzyjIpbnj+IzfEq5pUHCkXk00QQPftcUqYf6BeQXsSSSHCU2M6s/oXeLaSs/gSe17qPZEowMlnvScTl9KXNucrIVFLfwywfMuRAEIaZpzxwCeoTo9wNuqukxZRopATI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765285563; c=relaxed/simple;
	bh=8OpYSPc6f7O8KOMZoMzcw+MLAH+EZekjJDAjQynD8mQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kM4SJvYMDZQMy0LySwp4p+fK2mfjeLw6F0icBOnha9jOQRjVTxV77ptHY3sAYyUrAx/mi0jAg4ACai74XixVp6/E8TdjS7OKukfAxMrIvAH8reQkpz0ZzwRSftXNNqO9zf3a/LCu0W5iB5JtXh7h+MuyLWZbEKcKhBYj7HFaCyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aAuKquFS; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LCi5HFGP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765285559;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C7bt9DIhoeZ6jD2VdZvxOLbQYfNsQNZi6wdwI6g+uRA=;
	b=aAuKquFSznDBlYW64+YRxrVpjtx1H6MlUK0/gojFXzC5q0YF4rr2eIt+KQslQmCdNolJNz
	ILYByigZYfME70FFZgZB+RJxhdxsSUbWSp2GmVDc+G7Lf/UkB6MwSj5sDGxYag6w76AngH
	nFT2nkDrAM91S6AKyYzd2+jiymnLFTw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-407-lvyQgW0LMFSKMP2VI-Y2-g-1; Tue, 09 Dec 2025 08:05:55 -0500
X-MC-Unique: lvyQgW0LMFSKMP2VI-Y2-g-1
X-Mimecast-MFC-AGG-ID: lvyQgW0LMFSKMP2VI-Y2-g_1765285554
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-477a0ddd1d4so32567495e9.0
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 05:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765285554; x=1765890354; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C7bt9DIhoeZ6jD2VdZvxOLbQYfNsQNZi6wdwI6g+uRA=;
        b=LCi5HFGP4mMudbYx5DhGs7rzLdnMbK1o+k8SosTdQc5PM5g9VdnO+f2QKrsz3N7yxY
         jb/iMV5fSHuLCivLkavWbDh8m/tJUuXPuwUCHv8bEc/5KlEl9zCJwdAmmRmP6ylVyDlZ
         miLRZ9PWu1ldk0xw70QGuV5cGhf+7E3lFfMTSiOiZ6Th/2R/5jekURdkNSq6ztwoqrqO
         xb/lmtIX0N9xfUSBC2sF1mwYk26OGOSHhGyuCpmOXXr5PIFG7TkT+VXb+et6kdXf/Aal
         XtOOGZOllHCchSwR1AKY949MCZaqX2W299b+SlvVE3j3KeJ3ZhI1kHnAHsF7bQlPoGZt
         vmyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765285554; x=1765890354;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C7bt9DIhoeZ6jD2VdZvxOLbQYfNsQNZi6wdwI6g+uRA=;
        b=moiYOdBdAQwV/GYC9ovAF4o052wcnfxif6Bft0fyJepMVtz7tbyOSMVKngp5Wj3tZg
         tMn/4+S2EAPqJtSRbn/BEF2RiTS8Nibaz7H2uP6fATNMA5KsEgA/C6vEQ5jINt2RXuHf
         cWWmlX1sm4IvtCN10U481fU5BpKUj0VEPMwO8cAqKinsorrv/gSAOild8wu7/BJMQGgG
         Fse+4fV3Q0BdGIrFN/bQNY8WXlYXlgBTp411CKsatd+FUymgzpm0RYeOjAjparSFdGKE
         nRGhN256JgcLbBOEYemgz+/sD2izNWRJQe3rrr4SEOKR1yMa/f/5FRnH7G2qlmCj4f1h
         QOhQ==
X-Forwarded-Encrypted: i=1; AJvYcCV54H0bVQ4QvLYxvyEVMRWYR0YfOvlNtBV0hJaX2BD642fl2/8wSTgH53dI2T51aFUYnwI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf651fU/9IpTo3kVpjapEuAvEsBHhdPpKv2AnLMj1cPm1cFO+E
	d1Qq3mlsRT0PEx7GwZwWcQqeMOT/iFuFV8HI/UxMXo22GvABplVbUxugvcegXJehKQtpRkDzNcD
	lalhhSJP8bpmnZQXkzdDrRSHO1ch6evwBkqJhQkZBgZ1B6VqKFn2MGg==
X-Gm-Gg: ASbGncsyWWW2Nwfvs8STRCAuOtkh/4AEJKxMf3l0VvrEoPlqq/dqEehWe8KJhlVoihL
	BHCUUdS3Y3sIbNgc1xk6rNrEypTBLZGfwmYUr96skZ6gla1S0CfWLdp/Wu73DT80n2gkcVaoFt1
	hKBQ1+7s5WjF8TWmxsBdU6JtbVc5TgvMToXu8TJPgm+jv3VPsWw3XHEaU6HEEaFFML5URYEqOBe
	TXRHz9HVsrZSwcmhSbkr+jI0tFYUKoe/R8aZMTeyldb+1ybJSbLRcs0qR7bbonNw5/DrVFoarRE
	A9mdBKbPzvoGKzWol+4uOdjygz73tfH2sAakJiCQF9J5OP1zaZA694Qe/+njKnNzrYP29Ne/Usv
	8XZrfnbWWCCbSPt5HkXQjEhSJBO9vKzr7iQ==
X-Received: by 2002:a05:600c:1c1b:b0:477:b734:8c53 with SMTP id 5b1f17b1804b1-47939dfa09fmr106050935e9.12.1765285554110;
        Tue, 09 Dec 2025 05:05:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHuQABtiUkLD+rMxYkpHCMPJ0jWGiDwWoX4yNSI50FHhHBBQ+qu1qOfQtW9LU1ZqHfufP6qYw==
X-Received: by 2002:a05:600c:1c1b:b0:477:b734:8c53 with SMTP id 5b1f17b1804b1-47939dfa09fmr106050485e9.12.1765285553476;
        Tue, 09 Dec 2025 05:05:53 -0800 (PST)
Received: from redhat.com (IGLD-80-230-38-228.inter.net.il. [80.230.38.228])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a7d357820sm17802735e9.2.2025.12.09.05.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 05:05:52 -0800 (PST)
Date: Tue, 9 Dec 2025 08:05:50 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: virtualization@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	netdev@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost/vsock: improve RCU read sections around
 vhost_vsock_get()
Message-ID: <20251209080528-mutt-send-email-mst@kernel.org>
References: <20251126133826.142496-1-sgarzare@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126133826.142496-1-sgarzare@redhat.com>

On Wed, Nov 26, 2025 at 02:38:26PM +0100, Stefano Garzarella wrote:
> From: Stefano Garzarella <sgarzare@redhat.com>
> 
> vhost_vsock_get() uses hash_for_each_possible_rcu() to find the
> `vhost_vsock` associated with the `guest_cid`. hash_for_each_possible_rcu()
> should only be called within an RCU read section, as mentioned in the
> following comment in include/linux/rculist.h:
> 
> /**
>  * hlist_for_each_entry_rcu - iterate over rcu list of given type
>  * @pos:	the type * to use as a loop cursor.
>  * @head:	the head for your list.
>  * @member:	the name of the hlist_node within the struct.
>  * @cond:	optional lockdep expression if called from non-RCU protection.
>  *
>  * This list-traversal primitive may safely run concurrently with
>  * the _rcu list-mutation primitives such as hlist_add_head_rcu()
>  * as long as the traversal is guarded by rcu_read_lock().
>  */
> 
> Currently, all calls to vhost_vsock_get() are between rcu_read_lock()
> and rcu_read_unlock() except for calls in vhost_vsock_set_cid() and
> vhost_vsock_reset_orphans(). In both cases, the current code is safe,
> but we can make improvements to make it more robust.
> 
> About vhost_vsock_set_cid(), when building the kernel with
> CONFIG_PROVE_RCU_LIST enabled, we get the following RCU warning when the
> user space issues `ioctl(dev, VHOST_VSOCK_SET_GUEST_CID, ...)` :
> 
>   WARNING: suspicious RCU usage
>   6.18.0-rc7 #62 Not tainted
>   -----------------------------
>   drivers/vhost/vsock.c:74 RCU-list traversed in non-reader section!!
> 
>   other info that might help us debug this:
> 
>   rcu_scheduler_active = 2, debug_locks = 1
>   1 lock held by rpc-libvirtd/3443:
>    #0: ffffffffc05032a8 (vhost_vsock_mutex){+.+.}-{4:4}, at: vhost_vsock_dev_ioctl+0x2ff/0x530 [vhost_vsock]
> 
>   stack backtrace:
>   CPU: 2 UID: 0 PID: 3443 Comm: rpc-libvirtd Not tainted 6.18.0-rc7 #62 PREEMPT(none)
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-7.fc42 06/10/2025
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x75/0xb0
>    dump_stack+0x14/0x1a
>    lockdep_rcu_suspicious.cold+0x4e/0x97
>    vhost_vsock_get+0x8f/0xa0 [vhost_vsock]
>    vhost_vsock_dev_ioctl+0x307/0x530 [vhost_vsock]
>    __x64_sys_ioctl+0x4f2/0xa00
>    x64_sys_call+0xed0/0x1da0
>    do_syscall_64+0x73/0xfa0
>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
>    ...
>    </TASK>
> 
> This is not a real problem, because the vhost_vsock_get() caller, i.e.
> vhost_vsock_set_cid(), holds the `vhost_vsock_mutex` used by the hash
> table writers. Anyway, to prevent that warning, add lockdep_is_held()
> condition to hash_for_each_possible_rcu() to verify that either the
> caller is in an RCU read section or `vhost_vsock_mutex` is held when
> CONFIG_PROVE_RCU_LIST is enabled; and also clarify the comment for
> vhost_vsock_get() to better describe the locking requirements and the
> scope of the returned pointer validity.
> 
> About vhost_vsock_reset_orphans(), currently this function is only
> called via vsock_for_each_connected_socket(), which holds the
> `vsock_table_lock` spinlock (which is also an RCU read-side critical
> section). However, add an explicit RCU read lock there to make the code
> more robust and explicit about the RCU requirements, and to prevent
> issues if the calling context changes in the future or if
> vhost_vsock_reset_orphans() is called from other contexts.
> 
> Fixes: 834e772c8db0 ("vhost/vsock: fix use-after-free in network stack callers")
> Cc: stefanha@redhat.com
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>


queued, thanks!

> ---
>  drivers/vhost/vsock.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index ae01457ea2cd..78cc66fbb3dd 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -64,14 +64,15 @@ static u32 vhost_transport_get_local_cid(void)
>  	return VHOST_VSOCK_DEFAULT_HOST_CID;
>  }
>  
> -/* Callers that dereference the return value must hold vhost_vsock_mutex or the
> - * RCU read lock.
> +/* Callers must be in an RCU read section or hold the vhost_vsock_mutex.
> + * The return value can only be dereferenced while within the section.
>   */
>  static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
>  {
>  	struct vhost_vsock *vsock;
>  
> -	hash_for_each_possible_rcu(vhost_vsock_hash, vsock, hash, guest_cid) {
> +	hash_for_each_possible_rcu(vhost_vsock_hash, vsock, hash, guest_cid,
> +				   lockdep_is_held(&vhost_vsock_mutex)) {
>  		u32 other_cid = vsock->guest_cid;
>  
>  		/* Skip instances that have no CID yet */
> @@ -707,9 +708,15 @@ static void vhost_vsock_reset_orphans(struct sock *sk)
>  	 * executing.
>  	 */
>  
> +	rcu_read_lock();
> +
>  	/* If the peer is still valid, no need to reset connection */
> -	if (vhost_vsock_get(vsk->remote_addr.svm_cid))
> +	if (vhost_vsock_get(vsk->remote_addr.svm_cid)) {
> +		rcu_read_unlock();
>  		return;
> +	}
> +
> +	rcu_read_unlock();
>  
>  	/* If the close timeout is pending, let it expire.  This avoids races
>  	 * with the timeout callback.
> -- 
> 2.51.1


