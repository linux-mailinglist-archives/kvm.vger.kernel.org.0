Return-Path: <kvm+bounces-2235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A9047F399A
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 23:57:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC73CB2199F
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 22:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D29756740;
	Tue, 21 Nov 2023 22:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MtmmtrEV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D684DD;
	Tue, 21 Nov 2023 14:56:58 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1cf6373ce31so2154975ad.0;
        Tue, 21 Nov 2023 14:56:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700607418; x=1701212218; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pHi5YlXCcsX/D19JuU9Nw7CLS9+F6yhOBOO+wjnP29E=;
        b=MtmmtrEVs8W0K7YmHL0aSsy4KlgbCiR/rzEoaxxd5xgwo6yySKIEcftF7a0eDvv5mW
         sV3En1IQR2ITwWxA/VZvWTgYismKndDmu2SujOe6djQOnmzzw5WjZIG/jUf796bR1aMh
         sh2pdnh1tpajr+3Mlca7eIzXmCJhVnnRAJ5DMHZO7Bmzhxs7oS0pe/9DI9kug2oTyeG/
         JsF+ACBz/WxwiOu+PrN2SA/V4/lqhfbljF9Z19dghmlWxf/C2IstNvmhoPhbOF6VKUXI
         dF+6V4pyoJoO00MS6/Yg4floS8gsSbgACoGnjkfmWA5weSVC/ixWDm+VfRESce3FI7d3
         JoUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700607418; x=1701212218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pHi5YlXCcsX/D19JuU9Nw7CLS9+F6yhOBOO+wjnP29E=;
        b=iVwc9nEIheyTCs/+WJ+947PMVdO1zTldADUa5yo0JnccNN5/TOHzAd6HE5iwvqj6ih
         QQuMihy4cGfbENu6+YvjKsWx5L9OUHt5L8jdzbukHqb/vcOszYzqT+iw6wz1JNEAFIsm
         Xnr5JLAlqWhIcfoS6axPBhzgNsGE0oEENFztz6fIBzEglrJBg8jY78riOA/E8IbapcYb
         Dc9/YcZ2XQd1hRBlBSgZ/YOXSrUZG4ecHIFrNp5yJFp2zRFKz2buE/VvGExSACXA+CCz
         bntL2SVz7ABcJ3mywbqw9w2mdh5fJA4RadkIysAYFcK6PRR5fPhDJdhrKtFD3GvhXNaf
         iq8g==
X-Gm-Message-State: AOJu0YzMiCcI1hT2KwER33RCOLOmXYkzq2T7h6/cD4Yy6i7iHYd6jqxN
	k5Jtk/ju2MK5utyvZoFCzXg=
X-Google-Smtp-Source: AGHT+IE6s57NYG7jptMBdy5DVewa70KWUQtBlIN7PP5AfrSGIy85Ot97zH3PYYTC8wgjLQNl/n6VtQ==
X-Received: by 2002:a17:902:c94b:b0:1c5:cf7c:4d50 with SMTP id i11-20020a170902c94b00b001c5cf7c4d50mr1008200pla.18.1700607418027;
        Tue, 21 Nov 2023 14:56:58 -0800 (PST)
Received: from bangji.hsd1.ca.comcast.net ([2601:647:6780:42e0:7377:923f:1ff3:266d])
        by smtp.gmail.com with ESMTPSA id m12-20020a1709026bcc00b001cc47c1c29csm8413189plt.84.2023.11.21.14.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Nov 2023 14:56:57 -0800 (PST)
Sender: Namhyung Kim <namhyung@gmail.com>
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>
Cc: Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-perf-users@vger.kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH 05/14] tools headers UAPI: Update tools's copy of vhost.h header
Date: Tue, 21 Nov 2023 14:56:40 -0800
Message-ID: <20231121225650.390246-5-namhyung@kernel.org>
X-Mailer: git-send-email 2.43.0.rc1.413.gea7ed67945-goog
In-Reply-To: <20231121225650.390246-1-namhyung@kernel.org>
References: <20231121225650.390246-1-namhyung@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

tldr; Just FYI, I'm carrying this on the perf tools tree.

Full explanation:

There used to be no copies, with tools/ code using kernel headers
directly. From time to time tools/perf/ broke due to legitimate kernel
hacking. At some point Linus complained about such direct usage. Then we
adopted the current model.

The way these headers are used in perf are not restricted to just
including them to compile something.

There are sometimes used in scripts that convert defines into string
tables, etc, so some change may break one of these scripts, or new MSRs
may use some different #define pattern, etc.

E.g.:

  $ ls -1 tools/perf/trace/beauty/*.sh | head -5
  tools/perf/trace/beauty/arch_errno_names.sh
  tools/perf/trace/beauty/drm_ioctl.sh
  tools/perf/trace/beauty/fadvise.sh
  tools/perf/trace/beauty/fsconfig.sh
  tools/perf/trace/beauty/fsmount.sh
  $
  $ tools/perf/trace/beauty/fadvise.sh
  static const char *fadvise_advices[] = {
        [0] = "NORMAL",
        [1] = "RANDOM",
        [2] = "SEQUENTIAL",
        [3] = "WILLNEED",
        [4] = "DONTNEED",
        [5] = "NOREUSE",
  };
  $

The tools/perf/check-headers.sh script, part of the tools/ build
process, points out changes in the original files.

So its important not to touch the copies in tools/ when doing changes in
the original kernel headers, that will be done later, when
check-headers.sh inform about the change to the perf tools hackers.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: kvm@vger.kernel.org
Cc: virtualization@lists.linux.dev
Cc: netdev@vger.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/include/uapi/linux/vhost.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/include/uapi/linux/vhost.h b/tools/include/uapi/linux/vhost.h
index f5c48b61ab62..649560c685f1 100644
--- a/tools/include/uapi/linux/vhost.h
+++ b/tools/include/uapi/linux/vhost.h
@@ -219,4 +219,12 @@
  */
 #define VHOST_VDPA_RESUME		_IO(VHOST_VIRTIO, 0x7E)
 
+/* Get the group for the descriptor table including driver & device areas
+ * of a virtqueue: read index, write group in num.
+ * The virtqueue index is stored in the index field of vhost_vring_state.
+ * The group ID of the descriptor table for this specific virtqueue
+ * is returned via num field of vhost_vring_state.
+ */
+#define VHOST_VDPA_GET_VRING_DESC_GROUP	_IOWR(VHOST_VIRTIO, 0x7F,	\
+					      struct vhost_vring_state)
 #endif
-- 
2.43.0.rc1.413.gea7ed67945-goog


