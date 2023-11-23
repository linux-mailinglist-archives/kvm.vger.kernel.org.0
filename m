Return-Path: <kvm+bounces-2387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E2997F67C2
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 20:43:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECC9D281B09
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 19:43:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E28D4D102;
	Thu, 23 Nov 2023 19:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dp3Pv+Rb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00D8D7F
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 11:43:30 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-6bd20c30831so204685b3a.1
        for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 11:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1700768610; x=1701373410; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WpkzZHg09ad7VkHOnG/quo/T41ONjJ1411UTG4haLXU=;
        b=dp3Pv+RbN7GZ2lrzjUffbQSF0LOT7BAeVxL6NUaQWXL7BGCA8WDsDwdIv1vBi/bJh+
         x+kueLLHCLnZJPbC862Wr+FeUwslFH4KsQDxtO27+z0Knohfoc1/nZaiTZIc1t1+Rm5F
         bvX5ONi4yF1JFQpbP3Y8QFG7vPyFuxrLoF8RUWAS0rpopJh1ZZOocP0Uy5U4Mbs71JTW
         VqkNsfgKvCuwd0Zp3UY9OofwAtmwZAmjrrLLpSdFn8xdFL18Apgz7eraE8iP8965BEqc
         m07TYmEVY2jR+/GcdHXejKJSgc79oFbqpKjLmiJQ2p1a0vrTf4zkItE1lOEdMbMyzUCQ
         ca8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700768610; x=1701373410;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WpkzZHg09ad7VkHOnG/quo/T41ONjJ1411UTG4haLXU=;
        b=JgQ4E4odRkC7DgRkFazvBd5oJngSE7mc2xJOjzi8oanCNsycOcyF+uBxVzpV1ev6/k
         4U2+K/wQfYwBTc0y0E6A82UIaHF9eMNaGmQA0QAM6LMuwdXznQqF8bO1T/tK+65NIPzF
         6HbJojU7vfb2rVZveeOr0ZodTjVEPxVwTSwVar/SgjpQDnuNBkoKthSoH5ghu/93mZ9o
         aJkGM5Mo/J3N2hWCAnZQNARGleSrfUiNuTtxNCDABUpodd/0v4jOUWvUlM4WmzBvhGoi
         Rle7EAGzhqw/gd25DVFATqNIvDK+2q4yWOAtQr2s0XnMDik3zw9Wl1etm2s6qz7BL97x
         xLBw==
X-Gm-Message-State: AOJu0YxQF7oaUY7DP2x3AnZsf1jidFlkEaGHZb0dKqcf4Y04wUKvCeMC
	npEGevNOHtlb7hJuqKFeXN99MQ==
X-Google-Smtp-Source: AGHT+IEPG4J941SLrpY4uC/ri/G2ja2akCNdtY4pHEKeo+HpcNnwpEYC41wSse9D2H40uEI86qohgw==
X-Received: by 2002:a05:6a00:9381:b0:6bc:ff89:a2fc with SMTP id ka1-20020a056a00938100b006bcff89a2fcmr544106pfb.2.1700768610318;
        Thu, 23 Nov 2023 11:43:30 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id n17-20020a056a0007d100b006cb65cfde6dsm1567524pfu.200.2023.11.23.11.43.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Nov 2023 11:43:29 -0800 (PST)
Message-ID: <cb41cf91-1c75-4edc-b00f-59763344b15c@kernel.dk>
Date: Thu, 23 Nov 2023 12:43:23 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] eventfd: simplify signal helpers
Content-Language: en-US
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>,
 Oded Gabbay <ogabbay@kernel.org>, Wu Hao <hao.wu@intel.com>,
 Tom Rix <trix@redhat.com>, Moritz Fischer <mdf@kernel.org>,
 Xu Yilun <yilun.xu@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Zhi Wang <zhi.a.wang@intel.com>, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
 David Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
 Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Frederic Barrat <fbarrat@linux.ibm.com>, Andrew Donnellan
 <ajd@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Eric Farman <farman@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>,
 Halil Pasic <pasic@linux.ibm.com>, Vineeth Vijayan <vneethv@linux.ibm.com>,
 Peter Oberparleiter <oberpar@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Tony Krowiak <akrowiak@linux.ibm.com>,
 Jason Herne <jjherne@linux.ibm.com>,
 Harald Freudenberger <freude@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Diana Craciun <diana.craciun@oss.nxp.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Eric Auger <eric.auger@redhat.com>, Fei Li <fei1.li@intel.com>,
 Benjamin LaHaise <bcrl@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>,
 Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-fpga@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-rdma@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
 linux-usb@vger.kernel.org, virtualization@lists.linux-foundation.org,
 netdev@vger.kernel.org, linux-aio@kvack.org, cgroups@vger.kernel.org,
 linux-mm@kvack.org, Pavel Begunkov <asml.silence@gmail.com>,
 io-uring@vger.kernel.org
References: <20231122-vfs-eventfd-signal-v2-0-bd549b14ce0c@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231122-vfs-eventfd-signal-v2-0-bd549b14ce0c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/22/23 5:48 AM, Christian Brauner wrote:
> Hey everyone,
> 
> This simplifies the eventfd_signal() and eventfd_signal_mask() helpers
> significantly. They can be made void and not take any unnecessary
> arguments.
> 
> I've added a few more simplifications based on Sean's suggestion.
> 
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> 
> Changes in v2:
> - further simplify helpers
> - Link to v1: https://lore.kernel.org/r/20230713-vfs-eventfd-signal-v1-0-7fda6c5d212b@kernel.org

Only oddity I spotted was the kerneldoc, which someone else already
brought up.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe


