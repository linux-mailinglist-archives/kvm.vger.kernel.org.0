Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF2D30A546
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 11:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbhBAKYy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 05:24:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56634 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232290AbhBAKYx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 05:24:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612175006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P3maFpmEyWTTIxJdB5XqMO6xuqP9Omhc7XlJTDFaYw0=;
        b=ZVm24BRa0jYW6CFsLw9y527DAPr0Dx/YLxBjDeHKw3pJKZjOTQtIMUu7TxeSCrhwWWPIYh
        PrNK7v/zdjS1bf7isjve5M4hAk5lMPvIjRzJQkXO9F3cKyPbwrshK9YzzPT2mbD89KGd4X
        Sl+234IGOMjJnF3Gb2x3M+RPzgsR2WQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-v_8qlaHJMUGC6TCA0CeawQ-1; Mon, 01 Feb 2021 05:23:24 -0500
X-MC-Unique: v_8qlaHJMUGC6TCA0CeawQ-1
Received: by mail-wm1-f72.google.com with SMTP id z188so7539908wme.1
        for <kvm@vger.kernel.org>; Mon, 01 Feb 2021 02:23:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=P3maFpmEyWTTIxJdB5XqMO6xuqP9Omhc7XlJTDFaYw0=;
        b=mAL5RNIXcoAqD+YlTKjxUlxJ1mq/DELjg1Oc8/gQuzosyzaCJ9UgkxM5MBSNiUlCiU
         7Iy3MXURX0nC9wTu299Yy9gzoiC3xBEbKyVzKL0Xzrl2k6yjMa/mRq0c6zsZZ5Lh+KwS
         1lpB/opa/OCNQc8rFC6OU3QB9UHUyhO82HAvmLcADpY5IJLCPVbRAm1HyphIRb+krHfK
         E4bhBD1fn2zcffpE/yqbunvInmS3ai8i5QcPByHsrbS7fperY194IwQxbfZy0yW2SVY9
         JeKPLHFan7AKRjt9L0F3Sck9NSk06brbKBj+F2GQ9JxozyIYdfpffA2jPM3VvYpX//3F
         xoWw==
X-Gm-Message-State: AOAM531Puyum+nLgp5oSJNiu4cuG7Ry8khAed/x9iIQLJ7Jv8sfRhMFl
        L8fd2G2Rda8HCC4MCkxHA0OYtzxvtaAIZ9zMNP2w6b66RH9UHHCPIlkSWisAFqGmemifcDpqoqS
        vuhZLPumyQmQJ
X-Received: by 2002:a05:600c:154c:: with SMTP id f12mr14733435wmg.40.1612175003524;
        Mon, 01 Feb 2021 02:23:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwV/0SDXh0y/M5k5EK03Sm9O7AP+3Ymc68INpoLqvlEB+qZ48bkqmuuTgVUacF0hlX4wt0Axw==
X-Received: by 2002:a05:600c:154c:: with SMTP id f12mr14733418wmg.40.1612175003301;
        Mon, 01 Feb 2021 02:23:23 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id a17sm23415082wrx.63.2021.02.01.02.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 02:23:22 -0800 (PST)
Date:   Mon, 1 Feb 2021 11:23:20 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFC v2 04/10] vringh: implement vringh_kiov_advance()
Message-ID: <20210201102320.rk77l2aus3ku4ezz@steredhat>
References: <20210128144127.113245-1-sgarzare@redhat.com>
 <20210128144127.113245-5-sgarzare@redhat.com>
 <78247eb0-8e6e-f2fa-a693-1b0f14db61dd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <78247eb0-8e6e-f2fa-a693-1b0f14db61dd@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 01, 2021 at 01:43:23PM +0800, Jason Wang wrote:
>
>On 2021/1/28 下午10:41, Stefano Garzarella wrote:
>>In some cases, it may be useful to provide a way to skip a number
>>of bytes in a vringh_kiov.
>>
>>Let's implement vringh_kiov_advance() for this purpose, reusing the
>>code from vringh_iov_xfer().
>>We replace that code calling the new vringh_kiov_advance().
>
>
>Acked-by: Jason Wang <jasowang@redhat.com>
>
>In the long run we need to switch to use iov iterator library instead.

Yes I agree.
I've tried to do this, but it requires quite a bit of work to change 
vringh, I'll put it on my todo list.

Thanks,
Stefano

>
>Thanks
>
>
>>
>>Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>---
>>  include/linux/vringh.h |  2 ++
>>  drivers/vhost/vringh.c | 41 +++++++++++++++++++++++++++++------------
>>  2 files changed, 31 insertions(+), 12 deletions(-)
>>
>>diff --git a/include/linux/vringh.h b/include/linux/vringh.h
>>index 9c077863c8f6..755211ebd195 100644
>>--- a/include/linux/vringh.h
>>+++ b/include/linux/vringh.h
>>@@ -199,6 +199,8 @@ static inline void vringh_kiov_cleanup(struct vringh_kiov *kiov)
>>  	kiov->iov = NULL;
>>  }
>>+void vringh_kiov_advance(struct vringh_kiov *kiov, size_t len);
>>+
>>  int vringh_getdesc_kern(struct vringh *vrh,
>>  			struct vringh_kiov *riov,
>>  			struct vringh_kiov *wiov,
>>diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
>>index bee63d68201a..4d800e4f31ca 100644
>>--- a/drivers/vhost/vringh.c
>>+++ b/drivers/vhost/vringh.c
>>@@ -75,6 +75,34 @@ static inline int __vringh_get_head(const struct vringh *vrh,
>>  	return head;
>>  }
>>+/**
>>+ * vringh_kiov_advance - skip bytes from vring_kiov
>>+ * @iov: an iov passed to vringh_getdesc_*() (updated as we consume)
>>+ * @len: the maximum length to advance
>>+ */
>>+void vringh_kiov_advance(struct vringh_kiov *iov, size_t len)
>>+{
>>+	while (len && iov->i < iov->used) {
>>+		size_t partlen = min(iov->iov[iov->i].iov_len, len);
>>+
>>+		iov->consumed += partlen;
>>+		iov->iov[iov->i].iov_len -= partlen;
>>+		iov->iov[iov->i].iov_base += partlen;
>>+
>>+		if (!iov->iov[iov->i].iov_len) {
>>+			/* Fix up old iov element then increment. */
>>+			iov->iov[iov->i].iov_len = iov->consumed;
>>+			iov->iov[iov->i].iov_base -= iov->consumed;
>>+
>>+			iov->consumed = 0;
>>+			iov->i++;
>>+		}
>>+
>>+		len -= partlen;
>>+	}
>>+}
>>+EXPORT_SYMBOL(vringh_kiov_advance);
>>+
>>  /* Copy some bytes to/from the iovec.  Returns num copied. */
>>  static inline ssize_t vringh_iov_xfer(struct vringh *vrh,
>>  				      struct vringh_kiov *iov,
>>@@ -95,19 +123,8 @@ static inline ssize_t vringh_iov_xfer(struct vringh *vrh,
>>  		done += partlen;
>>  		len -= partlen;
>>  		ptr += partlen;
>>-		iov->consumed += partlen;
>>-		iov->iov[iov->i].iov_len -= partlen;
>>-		iov->iov[iov->i].iov_base += partlen;
>>-		if (!iov->iov[iov->i].iov_len) {
>>-			/* Fix up old iov element then increment. */
>>-			iov->iov[iov->i].iov_len = iov->consumed;
>>-			iov->iov[iov->i].iov_base -= iov->consumed;
>>-
>>-			
>>-			iov->consumed = 0;
>>-			iov->i++;
>>-		}
>>+		vringh_kiov_advance(iov, partlen);
>>  	}
>>  	return done;
>>  }
>

