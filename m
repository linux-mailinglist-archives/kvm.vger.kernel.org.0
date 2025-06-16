Return-Path: <kvm+bounces-49631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D6B86ADB471
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 16:53:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB33A188C1B9
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 14:52:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1983621A458;
	Mon, 16 Jun 2025 14:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XK/oEMMB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57040800
	for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 14:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750085511; cv=none; b=s3BONN3hgC8QEN+7sIMigrIgQkzQclp5vlBvVEDfgXFW4aGT4SO5pDwdS/XFj3EyEXr5i+QfTgS4DORWF+zKswz8vHs00T56QOP+NtnlpnbDj7X7wQ2EehVpF6E/jG6V128j7yWzWbJXdTouWzUUK6O9T6+mAnnrUefbbdur7YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750085511; c=relaxed/simple;
	bh=fM5dEQqwAiXD+1IrxGX1Pq9Lhfoon8UuGqtgWNQuMLc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qMNm+ME91AYhBrzB73e7l8OfAm+CqwaMI3Qsvh5rZTds7p4SIH4GC2qduXz5RehnTidSa9bQidqbIctJGRUww7JwdSEpFWicdmj/6w8StKssIz9+ER9i23VXHEbX4/7PBBXsLLTyMZmStawppGiPDNID4e/B5cjkm6zEPSOBDlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XK/oEMMB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750085508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zB0/juvTmsIMPjbtAoDAeMzCmECBZlu9WLKm2WtRE4E=;
	b=XK/oEMMBmbaz/mYjqx9h2zUs2WXiwxfZb1QVfCE8XsJpk9oa+U66ctrGRSmRJjYgxYTfuC
	yq6x5Zq5X3e2bfQMChvX8ve1YjHOEcVEDQnChSJEnxVGRzG12DoDOlkHFQwzXUv5tn9dn0
	RYrFcYZWjqcEXo/YJ4HA/kEmsmxSGGU=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-568-6fBSOXaaN1aamIUFbBS6MQ-1; Mon, 16 Jun 2025 10:51:47 -0400
X-MC-Unique: 6fBSOXaaN1aamIUFbBS6MQ-1
X-Mimecast-MFC-AGG-ID: 6fBSOXaaN1aamIUFbBS6MQ_1750085506
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7111ff9c057so63905577b3.0
        for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 07:51:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750085506; x=1750690306;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zB0/juvTmsIMPjbtAoDAeMzCmECBZlu9WLKm2WtRE4E=;
        b=hITZ8VVXHvzVlNri8+dhtHsXK0/N26SYktyv+kNWE2D8PIdbeYXhh+f77Msth8rE+x
         CGtuqgZOBYF2PtfaEveYTuv0tQGm8ZW7fXPjATx4vSX7prqW2oWPq0NobJBUWIYWjFnl
         eREmGz5s7Yw30DqujSDTa4W/Vsmn+ejP3mYKYiqvxrZjybAMT78xZ2Lqzb6stvNWQu3z
         MyuaU+n7LQr74Dr2aPhlS3s0Q6v1QO7Hd3F+/ml5Vcq32wV4VAGOhGCqut/mXf57GV7Q
         tKmg9k9yOHdyOirBssx17f4HIioBbiAQa54dKeIijD2njl5SZGWklgJAaJ5Vex4ujO3t
         vOaA==
X-Forwarded-Encrypted: i=1; AJvYcCUi81UenYhbRvLYX8hUmXYCC2GViswNMqn3YT/ULVFypxfc6NEUs9mJy5O/G3O9RjvHoPs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKtTwAz8sQINHBUIYY1oSq53DmbOZDSf489H/2f6qBJoluRqO5
	v3jpjcwlBLo4zL6NhLn9zjOK1kUgLlpawy+BzKJrSEBXakvJ24hm2rOIhYF9baLcAZhKEbpbwYC
	OMJmyvcblIV3ll9lwvUO5jK/uSLz0Sp13e+EgJdypYZ4dyezkr4gQlaCg0DEgcY96IrhvXmvcXd
	UEVNCtLPvWEN71/wkTaz+Y83t/dMIy
X-Gm-Gg: ASbGncuS5xJveNH2lSHVluq01ZSLk7uJiAQxmFiBcyWkekTXY8gN2zrHRtOcVNwliBR
	EkLw/1fLiwoZ15kBABnLCRGK7/F2xuR0Cut/tF9ZvOoNPl1DJiWZKzv5EItDK0meBb7Mso0jrf1
	ePQHKR
X-Received: by 2002:a05:690c:c1d:b0:70f:9fcd:2075 with SMTP id 00721157ae682-7117536cfa2mr129054667b3.3.1750085506481;
        Mon, 16 Jun 2025 07:51:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFYU9W5CA6OGz5GV8F5Kca6HL2nfxx98+wK9SD5MXInZikANAipuJ04VBv4A8FLyyEMPh5RPv6YlqBYjCJXTy0=
X-Received: by 2002:a05:690c:c1d:b0:70f:9fcd:2075 with SMTP id
 00721157ae682-7117536cfa2mr129054157b3.3.1750085506091; Mon, 16 Jun 2025
 07:51:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2oxz7toygswngn7kfmsrbmpikk5qggwbvk3oxb5ucrbq3pcfff@azc54m4hwlfb> <20250616143901.1187273-1-niuxuewei.nxw@antgroup.com>
In-Reply-To: <20250616143901.1187273-1-niuxuewei.nxw@antgroup.com>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Mon, 16 Jun 2025 16:51:34 +0200
X-Gm-Features: AX0GCFtzcxtqSQms8qF31ded0ASL17rZKHWqGZvF6K-bj9-TCcblqN-BEMBZdqc
Message-ID: <CAGxU2F6FtJT1fyZQ9JTExYF6OsJ6J8HRiOetX09JB6rTzVtVcQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/3] test/vsock: Add ioctl SIOCINQ tests
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: davem@davemloft.net, fupan.lfp@antgroup.com, jasowang@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com, 
	netdev@vger.kernel.org, niuxuewei.nxw@antgroup.com, pabeni@redhat.com, 
	stefanha@redhat.com, virtualization@lists.linux.dev, 
	xuanzhuo@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Jun 2025 at 16:39, Xuewei Niu <niuxuewei97@gmail.com> wrote:
>
> > On Fri, Jun 13, 2025 at 11:11:52AM +0800, Xuewei Niu wrote:
> > >This patch adds SIOCINQ ioctl tests for both SOCK_STREAM and
> > >SOCK_SEQPACKET.
> > >
> > >The client waits for the server to send data, and checks if the SIOCINQ
> > >ioctl value matches the data size. After consuming the data, the client
> > >checks if the SIOCINQ value is 0.
> > >
> > >Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
> > >---
> > > tools/testing/vsock/util.c       | 36 ++++++++++----
> > > tools/testing/vsock/util.h       |  2 +
> > > tools/testing/vsock/vsock_test.c | 83 +++++++++++++++++++++++++++++++-
> > > 3 files changed, 111 insertions(+), 10 deletions(-)
> > >
> > >diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
> > >index 0c7e9cbcbc85..472246198966 100644
> > >--- a/tools/testing/vsock/util.c
> > >+++ b/tools/testing/vsock/util.c
> > >@@ -97,28 +97,46 @@ void vsock_wait_remote_close(int fd)
> > >     close(epollfd);
> > > }
> > >
> > >-/* Wait until transport reports no data left to be sent.
> > >- * Return false if transport does not implement the unsent_bytes() callback.
> > >+/* Wait until ioctl gives an expected int value.
> > >+ * Return a negative value if the op is not supported.
> > >  */
> > >-bool vsock_wait_sent(int fd)
> > >+int ioctl_int(int fd, unsigned long op, int *actual, int expected)
> > > {
> > >-    int ret, sock_bytes_unsent;
> > >+    int ret;
> > >+    char name[32];
> > >+
> > >+    if (!actual) {
> > >+            fprintf(stderr, "%s requires a non-null pointer\n", __func__);
> > >+            exit(EXIT_FAILURE);
> > >+    }
> > >+
> > >+    snprintf(name, sizeof(name), "ioctl(%lu)", op);
> > >
> > >     timeout_begin(TIMEOUT);
> > >     do {
> > >-            ret = ioctl(fd, SIOCOUTQ, &sock_bytes_unsent);
> > >+            ret = ioctl(fd, op, actual);
> > >             if (ret < 0) {
> > >                     if (errno == EOPNOTSUPP)
> > >                             break;
> > >
> > >-                    perror("ioctl(SIOCOUTQ)");
> > >+                    perror(name);
> > >                     exit(EXIT_FAILURE);
> > >             }
> > >-            timeout_check("SIOCOUTQ");
> > >-    } while (sock_bytes_unsent != 0);
> > >+            timeout_check(name);
> > >+    } while (*actual != expected);
> > >     timeout_end();
> > >
> > >-    return !ret;
> > >+    return ret;
> > >+}
> > >+
> > >+/* Wait until transport reports no data left to be sent.
> > >+ * Return false if transport does not implement the unsent_bytes() callback.
> > >+ */
> > >+bool vsock_wait_sent(int fd)
> > >+{
> > >+    int sock_bytes_unsent;
> > >+
> > >+    return !(ioctl_int(fd, SIOCOUTQ, &sock_bytes_unsent, 0));
> > > }
> >
> > Please split this patch in 2, one where you do the refactoring in
> > util.c/h and one for the new test.
>
> Will do.
>
> > > /* Create socket <type>, bind to <cid, port> and return the file descriptor. */
> > >diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
> > >index 5e2db67072d5..945c85ff8d22 100644
> > >--- a/tools/testing/vsock/util.h
> > >+++ b/tools/testing/vsock/util.h
> > >@@ -3,6 +3,7 @@
> > > #define UTIL_H
> > >
> > > #include <sys/socket.h>
> > >+#include <sys/ioctl.h>
> >
> > Why we need this in util.h?
>
> We call `ioctl()` in the util.c. And we use `TIOCINQ` in the vsock_test.c,
> where includes "util.h". So including `sys/ioctl.h` in util.h is needed.

But we are not using anything in util.c from sys/ioctl.h IIUC, in that
case please move it in util.c where actually is needed.

Thanks,
Stefano


