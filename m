Return-Path: <kvm+bounces-66829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CA94CE958D
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 11:18:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 47B4F305AE50
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 10:16:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E109284662;
	Tue, 30 Dec 2025 10:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hvoCvzfd";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="lT34bftq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2502E040D
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 10:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089759; cv=none; b=FWm91ZpCwJSA+opAK4/zLUpzWTG/Bh/siuRwSO86vRZa+XwIiTRJt5odqV3SED9DtqKUIpUs6eIoR9jQaaK2SXHNidKbAnJv+eocU6pZXr9fA8u9PcVq+flcbCZz/x2U92h+8Tl0JSmfdJOs9SOC98t9tWvkOQa0MwB5Fi7X984=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089759; c=relaxed/simple;
	bh=1JUA4c0efATkxneQm73kN9tTpnR2rWTicL6pMgMgIPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sROANW+4NBD0m8U+PNBHBhRQEh6zOem9eo4YaZwFqwZpVMTifb0TBwEfeaurxeeYXtsS4t90rkX3d5CakFHOCwD1oSBNw6khMJP+9GU7QS+IyXYdYVP2vrVeY1+5EJdFRgKU4o83UcBGA2WHRcpKFIC/oXHVrxgvHVNJLWThuSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hvoCvzfd; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=lT34bftq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lIFloJTLYi5ioijSED2t687CZ+kUT7GxSlzISMtKW5A=;
	b=hvoCvzfdYVI5QnmibP+2Yajm1ZhOWvPiSLWw22wJxk4akt6ZEkoNRCt/E6rQe8E02O2dG1
	u0+tK8UWATMvs3Q7iUbi4PnqB2fic9QoSW+7L/5kdiCPHLjOpweM/DXA0SwBxigpcCz3qn
	5s1u/+cCMULSkZyYkuzBAFP+x5qYBPM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-Vcow3lNFO_y9I_dQ8CUEew-1; Tue, 30 Dec 2025 05:15:54 -0500
X-MC-Unique: Vcow3lNFO_y9I_dQ8CUEew-1
X-Mimecast-MFC-AGG-ID: Vcow3lNFO_y9I_dQ8CUEew_1767089754
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-477964c22e0so70029615e9.0
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 02:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089753; x=1767694553; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lIFloJTLYi5ioijSED2t687CZ+kUT7GxSlzISMtKW5A=;
        b=lT34bftqfcQNEx1gsdT2Z4JbiLJjkSYCtlmz5O9ObMJdgqltstSG+SMo+X36WAnllf
         MXJzVSiU/jMj2oZaHQ6/o9C+9ZBk2OJfpffBBAWAY+gdiAMmWumyhH9uAo5Vc4SyJi/I
         rtjC0tTxAV+Y2JNaqTth2RIY1NCsPh56gCE614rdOYKjlOOAOQCI2KKN7RE0zal+/kVM
         1QqGHORS/8MDI4BmqZ3J+Z6WZXt+8XSu/mBtAoQpVRLvabg3R1fIJTwGAksWAJUW6JTH
         k/3veBB7vYjqN1fdZxiJeDXiahM4KtcWfKoum16l0Hjn5tPzgPeTLv4E6+8ETMy8/zyK
         rBhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089753; x=1767694553;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lIFloJTLYi5ioijSED2t687CZ+kUT7GxSlzISMtKW5A=;
        b=jDZYv4Q57uSOAH1Hbx60UVM8jCYK4IKTpTOPyG2Iy+lTpRrAR3kAiklZQOPQnhx6L7
         0VFF5rE9lQB9NkYy7Md9MNlOyw7APGg1vFVRSi3pRKDmVcuNEEU0SuCk/w3zasb1aPoz
         v2vkkgLWl4RFT81zxQtkFLQJMVU3PlQ5ZNYt+XpXZgL2xDgLQUE2IflCGzrmfmf6FsCw
         6sRprocMcMn6nO72Yuqnk3NPkx0imFconIq0k91pkWc9YTI0/0U2q4sRBKvk8SkeeHpE
         UTd/o4NLCvo9fqR31ju5z55cx7WQqIWX4Of+5CzEA3zr4fh08toUgJK/YLvrY56kzhWI
         QTKw==
X-Forwarded-Encrypted: i=1; AJvYcCWLc1LdPBl/qAZxrlrKEm8b5VrhxbK+aXnhfR3eicyM5ueSZ+eV+TGLUEZOxeVb5iZGafs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiGcvjs4OTbEWfJAmQEwhO9RnOpjqGea0znW8wA3q63/VNKh9n
	Fs7ipe1T3+ziPh1cWhSLPVwxr+x9GuO7L5gYtzoWtTiXsXjysSGfMDyinAotbOlZzUbz6HbFk1/
	JG6lTQbxVOdJybhtjN2yDIiPaRiVpdSP4b1H2g8J+2/8q9mggvyNgGQ==
X-Gm-Gg: AY/fxX4rcqWL7mIcCnObX4lHF5SjvH2DlpvTD3BvwPvxHIiFETUP3qI37L3HCS/LUru
	cLi5pz3e1Pg1AAwlHveuUf65pjuDwhPpDlYQdn/h74uJhBGPMyaXr1S9QG6LIeQlNqMQ/tLWwCe
	6Vhs/VGb2kST1l/o0USg4OhwLgVPv19EjtcD7djd/pXwGR96oqyK/QaHWbeimZ+m3OQOrWUKejB
	ZDgRTXzmMsW9g9hDc6QlIHLxdjOon9UQMLqPoFrJIh4XI7fYttcDBHFJKG2CcyLXjQp+HzbhlJG
	3PvTyZbn22dtafFY3SZo9At20VuGSDWH/AbECcSdrZEfzXok2/Bc8umc+YdIYtFfar6RxnMhnbd
	XGqkPRmVTgObFxa68Ig8x6YCqsBZ9ZyNBog==
X-Received: by 2002:a05:600c:46cf:b0:477:9e0c:f59 with SMTP id 5b1f17b1804b1-47d18b833a6mr393752935e9.2.1767089753557;
        Tue, 30 Dec 2025 02:15:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF0nrcJnS7RjupXcIyxgJ/7OwvI0dkgJ3plFmvdD3JvcGLBLhWJUwOhq1auRl2SqH+pkIX7dw==
X-Received: by 2002:a05:600c:46cf:b0:477:9e0c:f59 with SMTP id 5b1f17b1804b1-47d18b833a6mr393752425e9.2.1767089752979;
        Tue, 30 Dec 2025 02:15:52 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be272eaf8sm630001695e9.5.2025.12.30.02.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:15:52 -0800 (PST)
Date: Tue, 30 Dec 2025 05:15:49 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Petr Tesarik <ptesarik@suse.com>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH RFC 02/13] docs: dma-api: document __dma_align_begin/end
Message-ID: <192a335d783a2e54f539dc5ff81bf3207dafa88f.1767089672.git.mst@redhat.com>
References: <cover.1767089672.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1767089672.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

Document the __dma_align_begin/__dma_align_end annotations
introduced by the previous patch.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 Documentation/core-api/dma-api-howto.rst | 42 ++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/Documentation/core-api/dma-api-howto.rst b/Documentation/core-api/dma-api-howto.rst
index 96fce2a9aa90..99eda4c5c8e7 100644
--- a/Documentation/core-api/dma-api-howto.rst
+++ b/Documentation/core-api/dma-api-howto.rst
@@ -146,6 +146,48 @@ What about block I/O and networking buffers?  The block I/O and
 networking subsystems make sure that the buffers they use are valid
 for you to DMA from/to.
 
+__dma_from_device_aligned_begin/end annotations
+===============================================
+
+As explained previously, when a structure contains a DMA_FROM_DEVICE buffer
+(device writes to memory) alongside fields that the CPU writes to, cache line
+sharing between the DMA buffer and CPU-written fields can cause data corruption
+on CPUs with DMA-incoherent caches.
+
+The ``__dma_from_device_aligned_begin/__dma_from_device_aligned_end``
+annotations ensure proper alignment to prevent this::
+
+	struct my_device {
+		spinlock_t lock1;
+		__dma_from_device_aligned_begin char dma_buffer1[16];
+		char dma_buffer2[16];
+		__dma_from_device_aligned_end spinlock_t lock2;
+	};
+
+On cache-coherent platforms these macros expand to nothing. On non-coherent
+platforms, they ensure the minimal DMA alignment, which can be as large as 128
+bytes.
+
+.. note::
+
+	To isolate a DMA buffer from adjacent fields, you must apply
+	``__dma_from_device_aligned_begin`` to the first DMA buffer field
+	**and additionally** apply ``__dma_from_device_aligned_end`` to the
+	**next** field in the structure, **beyond** the DMA buffer (as opposed
+	to the last field of the DMA buffer!).  This protects both the head and
+	tail of the buffer from cache line sharing.
+
+	When the DMA buffer is the **last field** in the structure, just
+	``__dma_from_device_aligned_begin`` is enough - the compiler's struct
+	padding protects the tail::
+
+		struct my_device {
+			spinlock_t lock;
+			struct mutex mlock;
+			__dma_from_device_aligned_begin char dma_buffer1[16];
+			char dma_buffer2[16];
+		};
+
 DMA addressing capabilities
 ===========================
 
-- 
MST


