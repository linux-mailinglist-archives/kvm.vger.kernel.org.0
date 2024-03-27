Return-Path: <kvm+bounces-12910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0284988F353
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 00:44:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F57129A81A
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 23:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87AB415530E;
	Wed, 27 Mar 2024 23:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="G+/0RXGe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BFD1534EC
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 23:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711583058; cv=none; b=vDstBDi7b7mCoUd65NyqsxtGvQPSB8XYBNUKkzHjsZ6JVD51bQoLMJPoKbd19MpXTW2G4ki8blMaiCDc+ZgbVWWLQ/wJR2I/flgHsnF029eH8W5ELxJNcO5VTgQEdHWYX5hwS3g4CSAW/0nglTFZTRlGNosm+JcHm1kDAHkByJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711583058; c=relaxed/simple;
	bh=dzBreCw05Zj1z2WXknwvtlBCs0CVANyQ6oNok2B+YWI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mcz6Bnc+Shp2gbf+xRfRR9nPI2i+dZz0B4uzQ/KUaeMGXQJE7qZqsWwhoe+kggTPfN39v6KuA71x9rMFCsX33MAOrBVs6PIaNzQ/yhLBAU42qJcw9I6y+L4tdnyif2BDIYsVzLohTjK00lsTgSclowTv4rk6JPgXy8atV4DHJpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=G+/0RXGe; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a465ddc2c09so19777666b.2
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 16:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1711583055; x=1712187855; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uafOqS8+Hx03UMEMNJ98UkxQPudcualGmS525ViN+u4=;
        b=G+/0RXGemv25P/Hg9aic/QOJWWkPl3ECvxPJ5Z8ILPNBe41hiuMiw7rnT95hKNdUMW
         w3FzNtE11lJdGGK+mjV+Nde35g4YUELzWMGPZRURdsj0xmuyOnEe3MXOdNYtSqIGePfJ
         hrukdWGqK6iCM73WjsVfVJSOpLbjG4XABs2bcRay+WM0v1hnfe9J/MmCRy5d+7M08Qw3
         2deBSbvtz/8Ox2BrbkSOyJmIUgSnymNtX/rwm8cWOezqJ8pkjsAYXGQ+zUCuj6w3kJ6R
         eG7zc4ifb3iFLkEK+0YTW8pg67F5XLJQ/CdqTiArIFbgB94X6J1gURX3BYzDkyJQpdEy
         NH/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711583055; x=1712187855;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uafOqS8+Hx03UMEMNJ98UkxQPudcualGmS525ViN+u4=;
        b=okux54zBYOxrwkMXJV97e07MUQQPOgrwdeNHPtxJtz8WF1LT/vrQlvBuKlv6Aix/Lu
         mhfrIunZPCo7xPJDoB8Oa1yzU/BZq5AK01EY1GgH1e6sgrsBnWLaftwqM5yKP6lDSifL
         Jjg75SeMotHyBE3lrkr+yrclq0sK02oPG1qeblhb3tT2xknqTgPa45KDsggMWHh14Hxh
         V3ZQMMOuzcLIARkg9Lc3CxBUZBQgL2CM55eSw+pfEsim++T0+PBq7k+cXMgkCOCPQtnG
         rPVzIu1vVuosWZQdPRhFXYRhG1xdOX4C45A4MwCYWL1a/FdzTEumlsNTUWiayDegsaah
         GtPA==
X-Forwarded-Encrypted: i=1; AJvYcCWG/1jmj4UfCICnRksJ2z+dgu6XGS/+J440m/DyWhSUgsfHi7lpZXQgIGQcz6XdEKaELM5x6/rDuRVkOU50Iuiieyau
X-Gm-Message-State: AOJu0YxKP/dPD9XDhOX4U0R9cp/9C7wqwz7ii1s+22DwTHh2QnEcrxSs
	P+1cBF0cse/igGjeUv6afcCc23tiY4lcgRtZBHP3dYj2/ML3Bgn+3ZrPvhV5+LM=
X-Google-Smtp-Source: AGHT+IG7URuP7axjuQKV/J+VTSyGmCmmaOiCo+Mv3EERteoqR/3prQyrSPwxKzpmfIt9Ury01gmlHg==
X-Received: by 2002:a50:8a93:0:b0:56c:18b4:d2ab with SMTP id j19-20020a508a93000000b0056c18b4d2abmr1042066edj.42.1711583054754;
        Wed, 27 Mar 2024 16:44:14 -0700 (PDT)
Received: from localhost.localdomain (178.165.195.38.wireless.dyn.drei.com. [178.165.195.38])
        by smtp.gmail.com with ESMTPSA id eo12-20020a056402530c00b00568afb0e731sm139243edb.63.2024.03.27.16.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 16:44:14 -0700 (PDT)
From: Andrew Melnychenko <andrew@daynix.com>
To: mst@redhat.com,
	jasowang@redhat.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	davem@davemloft.net,
	kuba@kernel.org,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Cc: yuri.benditovich@daynix.com,
	yan@daynix.com
Subject: [PATCH v2 1/1] vhost: Added pad cleanup if vnet_hdr is not present.
Date: Thu, 28 Mar 2024 01:18:26 +0200
Message-ID: <20240327231826.1725488-1-andrew@daynix.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Qemu launched with vhost but without tap vnet_hdr,
vhost tries to copy vnet_hdr from socket iter with size 0
to the page that may contain some trash.
That trash can be interpreted as unpredictable values for
vnet_hdr.
That leads to dropping some packets and in some cases to
stalling vhost routine when the vhost_net tries to process
packets and fails in a loop.

Qemu options:
  -netdev tap,vhost=on,vnet_hdr=off,...

From security point of view, wrong values on field used later
tap's tap_get_user_xdp() and will affect skb gso and options.
Later the header(and data in headroom) should not be used by the stack.
Using custom socket as a backend to vhost_net can reveal some data
in the vnet_hdr, although it would require kernel access to implement.

The issue happens because the value of sock_len in virtqueue is 0.
That value is set at vhost_net_set_features() with
VHOST_NET_F_VIRTIO_NET_HDR, also it's set to zero at device open()
and reset() routine.
So, currently, to trigger the issue, we need to set up qemu with
vhost=on,vnet_hdr=off, or do not configure vhost in the custom program.

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 drivers/vhost/net.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index f2ed7167c848..57411ac2d08b 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -735,6 +735,9 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
 	hdr = buf;
 	gso = &hdr->gso;
 
+	if (!sock_hlen)
+		memset(buf, 0, pad);
+
 	if ((gso->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
 	    vhost16_to_cpu(vq, gso->csum_start) +
 	    vhost16_to_cpu(vq, gso->csum_offset) + 2 >
-- 
2.43.0


