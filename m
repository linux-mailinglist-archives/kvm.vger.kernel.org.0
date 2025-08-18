Return-Path: <kvm+bounces-54916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F74CB2B24E
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 22:23:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70B1C7B0ED8
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 20:21:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4480322F767;
	Mon, 18 Aug 2025 20:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SEwIqwxj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A421FDD;
	Mon, 18 Aug 2025 20:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755548592; cv=none; b=CZvN79K7hu249LqUtPiSWhAfeLkzNFH3aGI/rwQsxw6rVpkUCg+OXDnEKfJ0QghUjtNMtAWa4VyBO0rjUnt1x1ihWePJ5s0AtLJPCAdOOaMp6BxF+Ip9KKFxiigb/iTlRZPWk7TXrS8PvIROyI47EtqG1opb7Q7n54yI+SD3QkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755548592; c=relaxed/simple;
	bh=paZXHZUb1fzhcnc2wDA0DtvK7mIVyCpv9tTBz23+m8M=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=bHioteEvE5FLavvo2MhFVv2PS2VkX7Zem5hMRrQDWTsOJfKR3Hi4WaozUWmM4FSGBLsumK879PFK0QY1+LI6EMGdS5r5y/K2bCJmZbNrXf1J3LSVmT0oC7jwX+eE9BPoc5iNseCmid+Z/eGFaAnQ30Bxu8yYFNY7TYea9DDKLbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SEwIqwxj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA6CC4CEEB;
	Mon, 18 Aug 2025 20:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755548591;
	bh=paZXHZUb1fzhcnc2wDA0DtvK7mIVyCpv9tTBz23+m8M=;
	h=Date:From:To:Cc:Subject:From;
	b=SEwIqwxjyK9xCAiMFtBRL+A1jtt2xU9bnDqEYndUh6jR0rCfxr9LB3qGiBf1BYy5X
	 2UuEbzV6yB9AVE+51Z2KpadGlo/wzvxUm8cCEqyK6I2zGtNYcynNCYCJFS2gbkpBgE
	 cbB5iV7dOvYPRpRNgoKCsDLxX56zmeKvbGs6VDlcOsPv6v/WR/qPnYGvO1V99S3jOj
	 Lw1wcufepA7Foq3g6ByFBnxjyxotf+jveqEPnuHqksyNtVKmM/kMQKTJ7ZdX/W0HZp
	 2YfepyIwurLJyeydyKJzJjdlyu79pG0oJIymgVu1y7lE6B2iU9kYoFqtfX4zOeXYv0
	 j5+bVBD3ILsKA==
Date: Mon, 18 Aug 2025 13:23:10 -0700
From: Namhyung Kim <namhyung@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: [BUG] vhost: perf tools build error after syncing vhost.h
Message-ID: <aKOLrqklBb9jdSxF@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hello,

I was sync'ing perf tools copy of kernel sources to apply recent
changes.  But there's a build error when it converts vhost ioctl
commands due to a conflicting slot like below.

  In file included from trace/beauty/ioctl.c:93:
  tools/perf/trace/beauty/generated/ioctl/vhost_virtio_ioctl_array.c: In function ‘ioctl__scnprintf_vhost_virtio_cmd’:
  tools/perf/trace/beauty/generated/ioctl/vhost_virtio_ioctl_array.c:36:18: error: initialized field overwritten [-Werror=override-init]
     36 |         [0x83] = "SET_FORK_FROM_OWNER",
        |                  ^~~~~~~~~~~~~~~~~~~~~
  tools/perf/trace/beauty/generated/ioctl/vhost_virtio_ioctl_array.c:36:18: note: (near initialization for ‘vhost_virtio_ioctl_cmds[131]’)
  
I think the following changes both added entries to 0x83.

  7d9896e9f6d02d8a vhost: Reintroduce kthread API and add mode selection
  333c515d189657c9 vhost-net: allow configuring extended features

The below patch fixes it for me.

Thanks,
Namhyung


---8<---
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 283348b64af9ac59..c57674a6aa0dbbea 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -260,7 +260,7 @@
  * When fork_owner is set to VHOST_FORK_OWNER_KTHREAD:
  *   - Vhost will create vhost workers as kernel threads.
  */
-#define VHOST_SET_FORK_FROM_OWNER _IOW(VHOST_VIRTIO, 0x83, __u8)
+#define VHOST_SET_FORK_FROM_OWNER _IOW(VHOST_VIRTIO, 0x84, __u8)
 
 /**
  * VHOST_GET_FORK_OWNER - Get the current fork_owner flag for the vhost device.
@@ -268,6 +268,6 @@
  *
  * @return: An 8-bit value indicating the current thread mode.
  */
-#define VHOST_GET_FORK_FROM_OWNER _IOR(VHOST_VIRTIO, 0x84, __u8)
+#define VHOST_GET_FORK_FROM_OWNER _IOR(VHOST_VIRTIO, 0x85, __u8)
 
 #endif


