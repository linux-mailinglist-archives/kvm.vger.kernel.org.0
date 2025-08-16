Return-Path: <kvm+bounces-54818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A76AB2891F
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 02:13:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 434381C25C5E
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 00:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1354B186A;
	Sat, 16 Aug 2025 00:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b="F3JJqTfE"
X-Original-To: kvm@vger.kernel.org
Received: from r3-20.sinamail.sina.com.cn (r3-20.sinamail.sina.com.cn [202.108.3.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C37C1FC3
	for <kvm@vger.kernel.org>; Sat, 16 Aug 2025 00:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.108.3.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755302962; cv=none; b=EpcWw5Vb6yMixh/m/nfsFFDOqHFvr5kNyUayMGsmzPMPmYvQZRH9S0lJHS/6do1t76rQXS4OAHDOxA0tpWNzhX8ncEYNypjdCHg6xfP8Z3BwUjv5srxqz57907bL2QJkCd2BB0I3oOTwPxb1h8FkHJlorePmCJxeDVe4GFpXkUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755302962; c=relaxed/simple;
	bh=F0CG0VqNgeqX8oh+TQB3QzFWHslyU8JjBLjUk9bCwbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCLTxQEBIjKwp951hFevDYux5L5XcufMvgfcolrMJAFJBCfakwc1qXn+8/uZZ51JhXQv0PgSfbpKSloNc+KJxGIyfX9vfrdry3Ig7gAboFPiF6OqyaQzeSgNiFIad2uOuT7R7hBv9Cn1zFakKAQdCDj8+Hd+VM9KTL5LucQbR/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b=F3JJqTfE; arc=none smtp.client-ip=202.108.3.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1755302959;
	bh=bdkGAoWrdbVzcqO40aR6fwo0x6+ClWirQe96L5A0gRY=;
	h=From:Subject:Date:Message-ID;
	b=F3JJqTfEjrYaZENNBeFhIjZE8TUT+6ph6zuaWBnDYu24/lbC2zT76q5Z+ZnoY2bIs
	 rHyXHbCQSWalasINiOeFxaNQNcYovKXHUZy0MWPYP/zRLkOUdOdfM8r2Pfk+dmY8CO
	 thEWv9mhX7nB+VcwOm4DMi31qjh2EyHnVDW1vrao=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.32) with ESMTP
	id 689FCC2400004CB2; Sat, 16 Aug 2025 08:09:10 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 6044754456638
X-SMAIL-UIID: 66DD780839E84197B5EAAF0360550DC7-20250816-080910-1
From: Hillf Danton <hdanton@sina.com>
To: Will Deacon <will@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	syzbot <syzbot+b4d960daf7a3c7c2b7b1@syzkaller.appspotmail.com>,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	stefanha@redhat.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [kvm?] [net?] [virt?] WARNING in virtio_transport_send_pkt_info
Date: Sat, 16 Aug 2025 08:08:56 +0800
Message-ID: <20250816000900.4653-1-hdanton@sina.com>
In-Reply-To: <aJ9WsFovkgZM3z09@willie-the-truck>
References: <20250812052645-mutt-send-email-mst@kernel.org> <689b1156.050a0220.7f033.011c.GAE@google.com> <20250812061425-mutt-send-email-mst@kernel.org> <aJ8HVCbE-fIoS1U4@willie-the-truck> <20250815063140-mutt-send-email-mst@kernel.org> <aJ8heyq4-RtJAPyI@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 15 Aug 2025 16:48:00 +0100 Will Deacon wrote:
>On Fri, Aug 15, 2025 at 01:00:59PM +0100, Will Deacon wrote:
>> On Fri, Aug 15, 2025 at 06:44:47AM -0400, Michael S. Tsirkin wrote:
>> > On Fri, Aug 15, 2025 at 11:09:24AM +0100, Will Deacon wrote:
>> > > On Tue, Aug 12, 2025 at 06:15:46AM -0400, Michael S. Tsirkin wrote:
>> > > > On Tue, Aug 12, 2025 at 03:03:02AM -0700, syzbot wrote:
>> > > > > Hello,
>> > > > > 
>> > > > > syzbot has tested the proposed patch but the reproducer is still triggering an issue:
>> > > > > WARNING in virtio_transport_send_pkt_info
>> > > > 
>> > > > OK so the issue triggers on
>> > > > commit 6693731487a8145a9b039bc983d77edc47693855
>> > > > Author: Will Deacon <will@kernel.org>
>> > > > Date:   Thu Jul 17 10:01:16 2025 +0100
>> > > > 
>> > > >     vsock/virtio: Allocate nonlinear SKBs for handling large transmit buffers
>> > > >     
>> > > > 
>> > > > but does not trigger on:
>> > > > 
>> > > > commit 8ca76151d2c8219edea82f1925a2a25907ff6a9d
>> > > > Author: Will Deacon <will@kernel.org>
>> > > > Date:   Thu Jul 17 10:01:15 2025 +0100
>> > > > 
>> > > >     vsock/virtio: Rename virtio_vsock_skb_rx_put()
>> > > >     
>> > > > 
>> > > > 
>> > > > Will, I suspect your patch merely uncovers a latent bug
>> > > > in zero copy handling elsewhere.
>> 
>> I'm still looking at this, but I'm not sure zero-copy is the right place
>> to focus on.
>> 
>> The bisected patch 6693731487a8 ("vsock/virtio: Allocate nonlinear SKBs
>> for handling large transmit buffers") only has two hunks. The first is
>> for the non-zcopy case and the latter is a no-op for zcopy, as
>> skb_len == VIRTIO_VSOCK_SKB_HEADROOM and so we end up with a linear SKB
>> regardless.
>
>It's looking like this is caused by moving from memcpy_from_msg() to
>skb_copy_datagram_from_iter(), which is necessary to handle non-linear
>SKBs correctly.
>
>In the case of failure (i.e. faulting on the source and returning
>-EFAULT), memcpy_from_msg() rewinds the message iterator whereas
>skb_copy_datagram_from_iter() does not. If we have previously managed to
>transmit some of the packet, then I think
>virtio_transport_send_pkt_info() can end up returning a positive "bytes
>written" error code and the caller will call it again. If we've advanced
>the message iterator, then this can end up with the reported warning if
>we run out of input data.
>
>As a hack (see below), I tried rewinding the iterator in the error path
>of skb_copy_datagram_from_iter() but I'm not sure whether other callers
>would be happy with that. If not, then we could save/restore the
>iterator state in virtio_transport_fill_skb() if the copy fails. Or we
>could add a variant of skb_copy_datagram_from_iter(), say
>skb_copy_datagram_from_iter_full(), which has the rewind behaviour.
>
>What do you think?
>
>Will
>
>--->8

#syz test

diff --git a/net/core/datagram.c b/net/core/datagram.c
index 94cc4705e91d..62e44ab136b7 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -551,7 +551,7 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 				 int len)
 {
 	int start = skb_headlen(skb);
-	int i, copy = start - offset;
+	int i, copy = start - offset, start_off = offset;
 	struct sk_buff *frag_iter;
 
 	/* Copy header. */
@@ -614,6 +614,7 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 		return 0;
 
 fault:
+	iov_iter_revert(from, offset - start_off);
 	return -EFAULT;
 }
 EXPORT_SYMBOL(skb_copy_datagram_from_iter);
--

