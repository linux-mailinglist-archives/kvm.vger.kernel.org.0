Return-Path: <kvm+bounces-72330-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4O7rEnnVpGmyswUAu9opvQ
	(envelope-from <kvm+bounces-72330-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 01:10:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A45601D2080
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 01:10:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4221030191AC
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 00:10:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2B3326290;
	Mon,  2 Mar 2026 00:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JxruV2Et";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nViAaVNJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EC84A23
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 00:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772410213; cv=none; b=O8pCc1KtzPyqjZ6RuuYAvi2ekZ/mVPi+OaojbC0p7eJfx7tq7hXR8hx2HK6pgLM2RhMAiwmiGb2TDgk4dU6ukQQM1jLOQHAGjJbbmP0vB/MD7MYd8C1kFHCbTRlkFHe7LsHBuKNbSZYzZ+LyBsd3JLnKR/YkZkZkjW5pEFGPG+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772410213; c=relaxed/simple;
	bh=d3go857C3XICc8MKrQoqnJS5JBMZD9L2ydEsTsmHHY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gohs0ITSdvrR/v7l2kF4aSdgLBX0eLVgXHgjlYqqol52E8ts1K+ko8zZamdCfgtqVTZOcP3TYaG0TZUTtcbgkTPSN9mvRd6/llCoEzI7eHdLiweDzM3G05TZqg2DbH9YxhunVhfj7Rqj5O3hClfw9MwlXZ/UjhVPPb1Q8kRzINQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JxruV2Et; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nViAaVNJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772410209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MpxCTRSJjeW1MLXWf2X8Dcr2BcSTB+ElcgetpkYQgRE=;
	b=JxruV2EtD+TTzdOO6A3UPzuUiy6FqJIZSodCGcBmx/sbafU3rtOitc0tHFX1IPIlfLHNOz
	tgeCuWeyTgCsaVlhnxg6BO7sot0xtcg1IPJNqI9ToYWZYrIuino35EIAWlKZeInV1UBGEC
	P8gAPD4dQTLi3R0SgSXv33uD5VnVePA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-bx5Fz60kMPieJisjiVrmEQ-1; Sun, 01 Mar 2026 19:10:08 -0500
X-MC-Unique: bx5Fz60kMPieJisjiVrmEQ-1
X-Mimecast-MFC-AGG-ID: bx5Fz60kMPieJisjiVrmEQ_1772410207
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-439bab2d095so14376f8f.3
        for <kvm@vger.kernel.org>; Sun, 01 Mar 2026 16:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772410207; x=1773015007; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MpxCTRSJjeW1MLXWf2X8Dcr2BcSTB+ElcgetpkYQgRE=;
        b=nViAaVNJaUN+ppLz25WThrSX7QKYxfegwrqipHksJaqyUqzceLj6Y9OW+9bd6/xtZC
         +HGn7d/JDwLQa9eQI6odY3kwMoYZOQR7zLxAYNl8Vhrr2/865Rxox1zmj1Nfqn3ZmrvC
         J4Au3t1QU0EnZAO4tx66wXzqt8pMC+QJGuKapZlh0b7vxk4ONJNFnzsWaBJpv/nm+nEU
         ILeTfF4o0K+mZUcX9pZO6LU3xS4jIN3kvdTM/viZlyKFN2udte+LTT9N0t+aQxdRaCUU
         1XI3IvkuX0y97fyZ8Bbkoj/2nDZzmOX6RdTPZ9KFwXwbVgfao7C+KHPl8Reg3NG6wjSi
         pEUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772410207; x=1773015007;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MpxCTRSJjeW1MLXWf2X8Dcr2BcSTB+ElcgetpkYQgRE=;
        b=c9D0XGkROSGWVE8ZnQgLvaOrk1WYM80402iKDR6U8OBRi0tArQK2oob5Df5oX2PQ4F
         tDc7pFk9DVyUBloJGzVxU9EECwWMmRbSdgFc6IYq9j2/QRos5tULPT8nG1k7kw0ZoHKD
         9Jw5dYjqGZ9/Cf8PpJBIvR3UOsydGMNTEGGTFGpPmgrznpC1zMB7cDLuI4b8Zm+1gzbc
         GqXxpr7ws/iMABsNy6GptauYWg4Narf06V5IKYoz1cm0T/nV16UDVgZmOFDFHWaqAmEY
         avahAbUFdPlrq5cM60kYZ+aUwsV4x4Z4BMIpa55X1v2GV+6IHqIpLlv7dtm+yYOIkGbe
         6jcA==
X-Forwarded-Encrypted: i=1; AJvYcCUqh41THDjmqQMd1d1Pgyt93T31ZSLkb7WoVvuCLbq+gY5WKRtSFevOGivCDQBLdzcfPEI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxO37ER8R4qfSKc+AMpcd6YT+KNVyssdadazpzIqgYR3QpOfGX9
	GqXy/TyZNLnU6DHxnOKgCA0UY/Om4w1O6QwFWrOuMAnxIyTniRD0IT/davc3cv2SejCXfMrwH/A
	DjYIvg8NQXmZFY+D6d5Ik5rMJueyT5k5y/KmbOT2ZjN0UhQRTCarXHQ==
X-Gm-Gg: ATEYQzz7cHA6zDseClZZZ4FaPJrSbQTIZy5gmgT5ZoRdTQL7JAD3JrYLskYjNdKQLto
	LGQYZGmILx9FFY8mklnuM1kZgGL0Db/Fq/RB7YISfzntjAj12lGI9YwaS1g790iW1lGcInKbFrL
	/4DctEAcQxOOTraHkw6emBRhFZczem2fqRwWO7+8rGCRWPvnXWeujB+0dGRQBsIwxSkgbDx0b7/
	6CsOr89tT+KcLc5maHjl/xF41b7FjMaELaN2XQVwAzXYR1PXL0mfz38oCd++DGTnmcwj1qqVOfD
	WrqpUExc5zvAnaFBCawseWb2rOtueGPHpcBtQbXUe1O4a3HYU0EAmrNTh36s12OhLo/FqFn1rXy
	Hj6H/p01scLTYSM0yjVBZiMaZywYKJKXEIwwMlSU4qoqbOg==
X-Received: by 2002:a05:6000:1889:b0:439:afcc:8a2f with SMTP id ffacd0b85a97d-439afcc8ab6mr6991039f8f.18.1772410207231;
        Sun, 01 Mar 2026 16:10:07 -0800 (PST)
X-Received: by 2002:a05:6000:1889:b0:439:afcc:8a2f with SMTP id ffacd0b85a97d-439afcc8ab6mr6991008f8f.18.1772410206755;
        Sun, 01 Mar 2026 16:10:06 -0800 (PST)
Received: from redhat.com (IGLD-80-230-79-166.inter.net.il. [80.230.79.166])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4399c75a523sm23000888f8f.19.2026.03.01.16.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2026 16:10:05 -0800 (PST)
Date: Sun, 1 Mar 2026 19:10:02 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: ShuangYu <shuangyu@yunyoo.cc>
Cc: "jasowang@redhat.com" <jasowang@redhat.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [BUG] vhost_net: livelock in handle_rx() when GRO packet exceeds
 virtqueue capacity
Message-ID: <20260301190906-mutt-send-email-mst@kernel.org>
References: <9ac0a071e79e9da8128523ddeba19085f4f8c9aa.decbd9ef.1293.41c3.bf27.48cdc12b9ce6@larksuite.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9ac0a071e79e9da8128523ddeba19085f4f8c9aa.decbd9ef.1293.41c3.bf27.48cdc12b9ce6@larksuite.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72330-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mst@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A45601D2080
X-Rspamd-Action: no action

On Sun, Mar 01, 2026 at 10:36:39PM +0000, ShuangYu wrote:
> Hi,
> 
> We have hit a severe livelock in vhost_net on 6.18.x. The vhost
> kernel thread spins at 100% CPU indefinitely in handle_rx(), and
> QEMU becomes unkillable (stuck in D state).
> [This is a text/plain messages]
> 
> Environment
> -----------
>   Kernel:  6.18.10-1.el8.elrepo.x86_64
>   QEMU:    7.2.19
>   Virtio:  VIRTIO_F_IN_ORDER is negotiated
>   Backend: vhost (kernel)
> 
> Symptoms
> --------
>   - vhost-<pid> kernel thread at 100% CPU (R state, never yields)
>   - QEMU stuck in D state at vhost_dev_flush() after receiving SIGTERM
>   - kill -9 has no effect on the QEMU process
>   - libvirt management plane deadlocks ("cannot acquire state change lock")
> 
> Root Cause
> ----------
> The livelock is triggered when a GRO-merged packet on the host TAP
> interface (e.g., ~60KB) exceeds the remaining free capacity of the
> guest's RX virtqueue (e.g., ~40KB of available buffers).
> 
> The loop in handle_rx() (drivers/vhost/net.c) proceeds as follows:
> 
>   1. get_rx_bufs() calls vhost_get_vq_desc_n() to fetch descriptors.
>     It advances vq->last_avail_idx and vq->next_avail_head as it
>     consumes buffers, but runs out before satisfying datalen.
> 
>   2. get_rx_bufs() jumps to err: and calls
>     vhost_discard_vq_desc(vq, headcount, n), which rolls back
>     vq->last_avail_idx and vq->next_avail_head.
> 
>     Critically, vq->avail_idx (the cached copy of the guest's
>     avail->idx) is NOT rolled back. This is correct behavior in
>     isolation, but creates a persistent mismatch:
> 
>       vq->avail_idx      = 108  (cached, unchanged)
>       vq->last_avail_idx = 104  (rolled back)
> 
>   3. handle_rx() sees headcount == 0 and calls vhost_enable_notify().
>     Inside, vhost_get_avail_idx() finds:
> 
>       vq->avail_idx (108) != vq->last_avail_idx (104)
> 
>     It returns 1 (true), indicating "new buffers available."
>     But these are the SAME buffers that were just discarded.
> 
>   4. handle_rx() hits `continue`, restarting the loop.
> 
>   5. In the next iteration, vhost_get_vq_desc_n() checks:
> 
>       if (vq->avail_idx == vq->last_avail_idx)
> 
>     This is FALSE (108 != 104), so it skips re-reading the guest's
>     actual avail->idx and directly fetches the same descriptors.
> 
>   6. The exact same sequence repeats: fetch -> too small -> discard
>     -> rollback -> "new buffers!" -> continue. Indefinitely.
> 
> This appears to be a regression introduced by the VIRTIO_F_IN_ORDER
> support, which added vhost_get_vq_desc_n() with the cached avail_idx
> short-circuit check, and the two-argument vhost_discard_vq_desc()
> with next_avail_head rollback. The mismatch between the rollback
> scope (last_avail_idx, next_avail_head) and the check scope
> (avail_idx vs last_avail_idx) was not present before this change.
> 
> bpftrace Evidence
> -----------------
> During the 100% CPU lockup, we traced:
> 
>   @get_rx_ret[0]:      4468052   // get_rx_bufs() returns 0 every time
>   @peek_ret[60366]:    4385533   // same 60KB packet seen every iteration
>   @sock_err[recvmsg]:        0   // tun_recvmsg() is never reached
> 
> vhost_get_vq_desc_n() was observed iterating over the exact same 11
> descriptor addresses millions of times per second.
> 
> Workaround
> ----------
> Either of the following avoids the livelock:
> 
>   - Disable GRO/GSO on the TAP interface:
>      ethtool -K <tap> gro off gso off
> 
>   - Switch from kernel vhost to userspace QEMU backend:
>      <driver name='qemu'/> in libvirt XML
> 
> Bisect
> ------
> We have not yet completed a full git bisect, but the issue does not
> occur on 6.17.x kernels which lack the VIRTIO_F_IN_ORDER vhost
> support. We will follow up with a Fixes: tag if we can identify the
> exact commit.
> 
> Suggested Fix Direction
> -----------------------
> In handle_rx(), when get_rx_bufs() returns 0 (headcount == 0) due to
> insufficient buffers (not because the queue is truly empty), the code
> should break out of the loop rather than relying on
> vhost_enable_notify() to make that determination. For example, when
> get_rx_bufs() returns r == 0 with datalen still > 0, this indicates a
> "packet too large" condition, not a "queue empty" condition, and
> should be handled differently.
> 
> Thanks,
> ShuangYu

Hmm. On a hunch, does the following help? completely untested,
it is night here, sorry.


diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 2f2c45d20883..aafae15d5156 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1522,6 +1522,7 @@ static void vhost_dev_unlock_vqs(struct vhost_dev *d)
 static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq)
 {
 	__virtio16 idx;
+	u16 avail_idx;
 	int r;
 
 	r = vhost_get_avail(vq, idx, &vq->avail->idx);
@@ -1532,17 +1533,19 @@ static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq)
 	}
 
 	/* Check it isn't doing very strange thing with available indexes */
-	vq->avail_idx = vhost16_to_cpu(vq, idx);
-	if (unlikely((u16)(vq->avail_idx - vq->last_avail_idx) > vq->num)) {
+	avail_idx = vhost16_to_cpu(vq, idx);
+	if (unlikely((u16)(avail_idx - vq->last_avail_idx) > vq->num)) {
 		vq_err(vq, "Invalid available index change from %u to %u",
 		       vq->last_avail_idx, vq->avail_idx);
 		return -EINVAL;
 	}
 
 	/* We're done if there is nothing new */
-	if (vq->avail_idx == vq->last_avail_idx)
+	if (avail_idx == vq->avail_idx)
 		return 0;
 
+	vq->avail_idx == avail_idx;
+
 	/*
 	 * We updated vq->avail_idx so we need a memory barrier between
 	 * the index read above and the caller reading avail ring entries.


