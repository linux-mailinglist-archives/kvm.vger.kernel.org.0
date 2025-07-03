Return-Path: <kvm+bounces-51385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2303DAF6BB5
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 09:36:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5466C17D752
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 07:36:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FDDB29A30E;
	Thu,  3 Jul 2025 07:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SPZOpcSM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16E923D291
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 07:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751528180; cv=none; b=opUyKfUqzJRadvHAoEzz3ZNAOunNaM+vQPA1AjTVsyj3TSG5MyTpyz1o03koRXM4rW9ZhBrXGf45M9xoOOFviSBUUqe3iih2wA1oQaAiJEkpa44aCjxI5ao7pteNZQwmi67i8igDV53O4XdCeaxptrCcYpofu/loZ/fru4lfe4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751528180; c=relaxed/simple;
	bh=t0n49iCwwU2GbeVi3ix5QZaF6IORs6m35hJ68NMxb5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VkZ4RmiBXwqqYJuDSlJsnLrJRfQ4SzjyqLY4T8gsuGppkaXuqCell7/R3+4YqGgOon27VE6A+KOXC7H9u5aksXFUlddmSr6SfbEzwcjncNaUlXSBm24MrwPVXLd55OOPU+DNbiPzoVmR+raaQNB7pPZEV8GE4TN6stQQ3L3ZZsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SPZOpcSM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751528177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0myZD3/gO82VfB/RKtfXzE7O1oy/XulbCjkjJQJqz/o=;
	b=SPZOpcSMXFeF392gNNWwinxty6f7fpwVIBLt4BrTJQzKQhwfQcM8uqWcaUN/LGKrlX4h+5
	NWsN+eGWwdU5DzT/2+iPjHpsrgeCwLjXAxr2kG0hJLpkg/RoUaC0ibuP7Qyq0QWqanGIXq
	BGkl5dvhW+peHTSBkxns+sb5ROpFytE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-92-SJ8aNa1JNuyWlM0nCsV6Iw-1; Thu, 03 Jul 2025 03:36:14 -0400
X-MC-Unique: SJ8aNa1JNuyWlM0nCsV6Iw-1
X-Mimecast-MFC-AGG-ID: SJ8aNa1JNuyWlM0nCsV6Iw_1751528174
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4537f56ab74so36308505e9.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 00:36:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751528173; x=1752132973;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0myZD3/gO82VfB/RKtfXzE7O1oy/XulbCjkjJQJqz/o=;
        b=oyk2wtJ5HOF+U6RIX8WgnczIbm906JK9+9c2DVlW03futiVqqs/3S5TpFQlqXR6bH5
         q67Zja88FuDUD0z60SsM0UOPDjX9/ZJu9E4oKRfPNbTG038RlxXmr+CI8nuYVhpw/Qsg
         2wlVOmr4S8iq/kROwTQevWp2l96CeLuyOUMqEPh8o3/uZP2WwrzEs/rf4Ed5I7H8304V
         Xs0mXlLWiBgQQ5hADL0F9kvNA9wqsxNkFFsqfl36IT8RlK6BfodS65o9ID5Pp//nmUGO
         HY3YnAGIDdVMFcS7FcVbiDQMLOpz3d+p9XKhqmJVAzmTNK3Bvp4zqH2subhrdujKwMJ+
         mPNg==
X-Forwarded-Encrypted: i=1; AJvYcCXenc5MCLk3SnPYzjt73Jgy2KdW6Aq4f29dHwUf3lIiZiEEXdV9KK6UUVRgkcK8NQt/2qE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYPcQwvmqcbu6uhV9+SFAwDvPmmvyBBwY/ngZ+Q3tlr0WZI2JB
	mAncqDmhMWZA+qEt7/K52Jw8WdWQuQSU4P2mroSxlBLhYW1k8+Ff/OdGehgAKyHMSMGjG7KVuMj
	HqxlmZmPBsIr5E8StPgr7kPE9dje5dwzV/hMpC1LTOpjRPv1HTYxxkw==
X-Gm-Gg: ASbGncupzGvUj07QEuD5WHQzQGL25MPSK6esicywCBk+xXMblT6w62SpO7Uw5UAjR8d
	tR9x9j7qzdClaT71K4ItqmZyQCOgLzCL+kb2eLtmmWdvLO4CewSW+ArQGG1p0p+x5ETdzhBCJgZ
	5zjIsiwvlTJ0gbtt7C0NpbXYfHYOu7YYGtE/n6ayL49Il9jOMaUju8CiT09ejRQcdeY9WKgfFbO
	JCDdZbDYeVaFL1/xXsSVFur4pipu3KtQSkKYWKD13aXjJZip5hdVNlf/oKgMUkpjwWj2+nF4FH+
	GeAwH0IaC0ivQXS7/9o/7tAuUYE=
X-Received: by 2002:a05:600c:3b88:b0:453:78f:faa8 with SMTP id 5b1f17b1804b1-454ab520a21mr15158095e9.6.1751528173419;
        Thu, 03 Jul 2025 00:36:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFhjcnveMpvTzezAJ9GXUGkphlFIge/CXQt5U7gjqv9xWH7A+a8gl4/9NaXMc4bKYzsomAqnQ==
X-Received: by 2002:a05:600c:3b88:b0:453:78f:faa8 with SMTP id 5b1f17b1804b1-454ab520a21mr15157605e9.6.1751528172730;
        Thu, 03 Jul 2025 00:36:12 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.200.84])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e5f8e1sm17681937f8f.88.2025.07.03.00.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jul 2025 00:36:12 -0700 (PDT)
Date: Thu, 3 Jul 2025 09:36:00 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: davem@davemloft.net, decui@microsoft.com, fupan.lfp@antgroup.com, 
	jasowang@redhat.com, kvm@vger.kernel.org, leonardi@redhat.com, 
	linux-kernel@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org, 
	niuxuewei.nxw@antgroup.com, pabeni@redhat.com, stefanha@redhat.com, 
	virtualization@lists.linux.dev, xuanzhuo@linux.alibaba.com
Subject: Re: [RESEND PATCH net-next v4 3/4] test/vsock: Add retry mechanism
 to ioctl wrapper
Message-ID: <ceulzs7srd77t57ozaauveim4dlp6stqmbvvjh5dketapmjzhv@nu6gruoyidze>
References: <2cpqw23kr4qiatpzcty6wve4qdyut5su7g7fr4kg52dx33ikdu@ljicf6mktu5z>
 <20250703030514.845623-1-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250703030514.845623-1-niuxuewei.nxw@antgroup.com>

On Thu, Jul 03, 2025 at 11:05:14AM +0800, Xuewei Niu wrote:
>Resend: the previous message was rejected due to HTML
>Resend: forgot to reply all...
>
>> On Mon, Jun 30, 2025 at 03:57:26PM +0800, Xuewei Niu wrote:
>> >Wrap the ioctl in `ioctl_int()`, which takes a pointer to the actual
>> >int value and an expected int value. The function will not return until
>> >either the ioctl returns the expected value or a timeout occurs, thus
>> >avoiding immediate failure.
>> >
>> >Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
>> >---
>> > tools/testing/vsock/util.c | 32 +++++++++++++++++++++++---------
>> > tools/testing/vsock/util.h |  1 +
>> > 2 files changed, 24 insertions(+), 9 deletions(-)
>> >
>> >diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
>> >index 0c7e9cbcbc85..481c395227e4 100644
>> >--- a/tools/testing/vsock/util.c
>> >+++ b/tools/testing/vsock/util.c
>> >@@ -16,6 +16,7 @@
>> > #include <unistd.h>
>> > #include <assert.h>
>> > #include <sys/epoll.h>
>> >+#include <sys/ioctl.h>
>> > #include <sys/mman.h>
>> > #include <linux/sockios.h>
>> >
>> >@@ -97,28 +98,41 @@ void vsock_wait_remote_close(int fd)
>> > 	close(epollfd);
>> > }
>> >
>> >-/* Wait until transport reports no data left to be sent.
>> >- * Return false if transport does not implement the unsent_bytes()
>> >callback.
>> >+/* Wait until ioctl gives an expected int value.
>> >+ * Return false if the op is not supported.
>> >  */
>> >-bool vsock_wait_sent(int fd)
>> >+bool vsock_ioctl_int(int fd, unsigned long op, int *actual, int expected)
>>
>> Why we need the `actual` parameter?
>
>We can exit early `if (*actual == expected)`, and the `expected` can be any integer.
>I also make it to be a pointer, because the caller might need to have the actual value.

IIUC this function return true if `*actual == expected` or false if 
there was an error, so I don't see the point of aving `actual`, since it 
can only be equal to `expected` if it returns true, or invalid if it 
returs false.

Thanks,
Stefano

>
>Thanks,
>Xuewei
>
>> > {
>> >-	int ret, sock_bytes_unsent;
>> >+	int ret;
>> >+	char name[32];
>> >+
>> >+	snprintf(name, sizeof(name), "ioctl(%lu)", op);
>> >
>> > 	timeout_begin(TIMEOUT);
>> > 	do {
>> >-		ret = ioctl(fd, SIOCOUTQ, &sock_bytes_unsent);
>> >+		ret = ioctl(fd, op, actual);
>> > 		if (ret < 0) {
>> > 			if (errno == EOPNOTSUPP)
>> > 				break;
>> >
>> >-			perror("ioctl(SIOCOUTQ)");
>> >+			perror(name);
>> > 			exit(EXIT_FAILURE);
>> > 		}
>> >-		timeout_check("SIOCOUTQ");
>> >-	} while (sock_bytes_unsent != 0);
>> >+		timeout_check(name);
>> >+	} while (*actual != expected);
>> > 	timeout_end();
>> >
>> >-	return !ret;
>> >+	return ret >= 0;
>> >+}
>> >+
>> >+/* Wait until transport reports no data left to be sent.
>> >+ * Return false if transport does not implement the unsent_bytes() callback.
>> >+ */
>> >+bool vsock_wait_sent(int fd)
>> >+{
>> >+	int sock_bytes_unsent;
>> >+
>> >+	return vsock_ioctl_int(fd, SIOCOUTQ, &sock_bytes_unsent, 0);
>> > }
>> >
>> > /* Create socket <type>, bind to <cid, port> and return the file descriptor. */
>> >diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
>> >index 5e2db67072d5..d59581f68d61 100644
>> >--- a/tools/testing/vsock/util.h
>> >+++ b/tools/testing/vsock/util.h
>> >@@ -54,6 +54,7 @@ int vsock_stream_listen(unsigned int cid, unsigned int port);
>> > int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
>> > 			   struct sockaddr_vm *clientaddrp);
>> > void vsock_wait_remote_close(int fd);
>> >+bool vsock_ioctl_int(int fd, unsigned long op, int *actual, int expected);
>> > bool vsock_wait_sent(int fd);
>> > void send_buf(int fd, const void *buf, size_t len, int flags,
>> > 	      ssize_t expected_ret);
>> >--
>> >2.34.1
>> >
>


