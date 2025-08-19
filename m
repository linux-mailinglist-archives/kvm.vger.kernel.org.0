Return-Path: <kvm+bounces-54954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CBFDB2B9B9
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 08:42:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA1DE3BB916
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 06:40:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B21D26CE1A;
	Tue, 19 Aug 2025 06:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VgWy9ue4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735AD2690C0;
	Tue, 19 Aug 2025 06:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755585599; cv=none; b=t8qA1ZdaKiaZIIBAEZux4wDZ9VhjGaYvhot3GvdriWX4CFzFoWaX/i2Ku2EQrH1a0ihIz6xWi4uYRbU3r1JbLpOkOydRzblVa3/tdicyhr52MTRO4QszCKWD9wlqWrVoDrKvf0BzpSQZDAn8i3RnOM0fEjBRUPH8+28wj/E6l6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755585599; c=relaxed/simple;
	bh=HoWbYmhsA8SL51aANKCLbtiNokkLG98QFcJSsUgJGr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gG12yTib02L4yPd0jAOrJKw0PgMLpDXXFUptrNb32+GIHNuyfYFg63Dyn4/PFckyC9b8KU2sPQQ+hYS4TJwy+aG/DMMFkDYGbAjKZwifGZthx5PIj7ERDLXzjumX4GcNYrxZwe2pES/1AbzJrlqoT8fsPLmF8YffyZ6/BJhNEs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VgWy9ue4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CCAC4CEF4;
	Tue, 19 Aug 2025 06:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755585599;
	bh=HoWbYmhsA8SL51aANKCLbtiNokkLG98QFcJSsUgJGr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VgWy9ue4oVQqA5ZXVBseBthE4nnglgr43ZXl4X9E5o2Ay/SK4naLQc5zWOIsTceZu
	 HYU1x5v7StG2UxeYvtCCwTNIy2gcWOgWjUw3uSBgOoZ0+INlxskI5dkmJrvZxVV8Dh
	 g0K5cm2fI75meYpfhLVMySZ+DNrJnuAFC79DhotYXJfHguvhlzjpzk2ExUy5HfQwSD
	 QauFX7ONxWXOAPJXpkPNt7OaI+G72mA9CTdS511Yy6NA5ZCKHEuWHeMcCXEQV+gIi0
	 ejZ911WLs5Aocd9i0PH1y4FrYqsVb3t7z+sus4EfmxwO25EmUoa0GLzcvcPHVynkNA
	 f8PLz6FE6fLYw==
From: Namhyung Kim <namhyung@kernel.org>
To: Jason Wang <jasowang@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: [PATCH] vhost: Fix ioctl # for VHOST_[GS]ET_FORK_FROM_OWNER
Date: Mon, 18 Aug 2025 23:39:57 -0700
Message-ID: <20250819063958.833770-1-namhyung@kernel.org>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
In-Reply-To: <CACGkMEvm-wFV8TqX039CZU1JKnztft5Hp7kt6hqoqHCNyn3=jg@mail.gmail.com>
References: <CACGkMEvm-wFV8TqX039CZU1JKnztft5Hp7kt6hqoqHCNyn3=jg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The VHOST_[GS]ET_FEATURES_ARRAY ioctl already took 0x83 and it would
result in a build error when the vhost uapi header is used for perf tool
build like below.

  In file included from trace/beauty/ioctl.c:93:
  tools/perf/trace/beauty/generated/ioctl/vhost_virtio_ioctl_array.c: In function ‘ioctl__scnprintf_vhost_virtio_cmd’:
  tools/perf/trace/beauty/generated/ioctl/vhost_virtio_ioctl_array.c:36:18: error: initialized field overwritten [-Werror=override-init]
     36 |         [0x83] = "SET_FORK_FROM_OWNER",
        |                  ^~~~~~~~~~~~~~~~~~~~~
  tools/perf/trace/beauty/generated/ioctl/vhost_virtio_ioctl_array.c:36:18: note: (near initialization for ‘vhost_virtio_ioctl_cmds[131]’)

Fixes: 7d9896e9f6d02d8a ("vhost: Reintroduce kthread API and add mode selection")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 include/uapi/linux/vhost.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
-- 
2.51.0.rc1.167.g924127e9c0-goog


