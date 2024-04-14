Return-Path: <kvm+bounces-14600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 110EA8A412B
	for <lists+kvm@lfdr.de>; Sun, 14 Apr 2024 10:21:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B629F1F21E09
	for <lists+kvm@lfdr.de>; Sun, 14 Apr 2024 08:21:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E52F428DA5;
	Sun, 14 Apr 2024 08:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LkCO+Gnx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EE222638
	for <kvm@vger.kernel.org>; Sun, 14 Apr 2024 08:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713082856; cv=none; b=PQu8w+Dlw3/yhGA4H5cep0n+M1LgNEIUL2vQnbwQJJGeT1fy5OZR4piqrEP8clU+ixP8NnbYdIaBA03uyPDOUpETNzPM1KH0Jkf3sWtEy4tbGsVHVCDgxcfMXfoLNZ8c0Qaa1CwSRxEXrWnC++bwt6ytUePV4Vsl3IQ+NeYvv+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713082856; c=relaxed/simple;
	bh=n2KAAD78OMxGo0jZELGn7CmgUzJxWbOTMafuTjmtr8k=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=p98DK0LAoJZtqLMOfIsCCdJwpLP6gPi/a2Dv9+wEHwf4FLU52mYRKADywHJGaEtIrYJ7IFR2pjJDTbO5i7jot0s+Do2FsB1VaqydNUTa9I5gqQYvSbxPYA8ANns3tZiJyGxvJuu/s0sif4jUY1xeQDAAfewGTwKu11yaT9sIe3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LkCO+Gnx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713082852;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=scFFEffqql5VQw/Qv/aXLLxw/eS8TS+7oq2PNwfkz2I=;
	b=LkCO+GnxhD/lBfTHmSvgQwbFTBOnJ+qZ+bFSI2yN1hlCrcDBgq8XTtSlMnSP+F43n+vuvI
	P57J+eZZf1SzUho+kO9WpA8ZqVyzPJ5SvCWDEzr9qRUPbbJAKIT/ycRL4ArRv2vfGr35SF
	4y16rCA2eBqzohWbUu6FcwP/2Sb4pNk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-Q53FLqDbNXWn7vzUsfQf6g-1; Sun, 14 Apr 2024 04:20:50 -0400
X-MC-Unique: Q53FLqDbNXWn7vzUsfQf6g-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3479b511725so280720f8f.3
        for <kvm@vger.kernel.org>; Sun, 14 Apr 2024 01:20:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713082849; x=1713687649;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=scFFEffqql5VQw/Qv/aXLLxw/eS8TS+7oq2PNwfkz2I=;
        b=YwVljgcc9BQVKBSTdHE8OpVODI8hISHq26Es+pTqF0BNXV4XOdUa8btx/3K+r8VxhX
         sAOQOVvvFgF3X1HbnsiWBxlaDOhJokYh7RRCMBelTT/20NfL7+RlcTVznSEema8D6P6w
         SjVd3g9dzCxrlIvIlzhGJ/+vWGCjTmgmWi4+pykGpCQUSB2tRWVxuWtU1BxYOYbKTvKe
         X86u/JT+Q/5i15OwU3HGvOFt2CacqGN0KLhvXrlqJkkZci8CBCRY/bozyiux722PC0yj
         TktBu5XEe2ZiWYCH6k5vazzrrSpxJZCheiFMnHfGnEbfmCAxxBmFTnOTfsPCFeiz489X
         1DRw==
X-Gm-Message-State: AOJu0YyufG8xgIuc1e25YIFfXVmuKKoimAnEWl42rxxJrrhEYvamAb2V
	cdt6qcB1g/koWIJKrIb5+crikWRYwtx/+5qD0rVIDN0MLZLw+L3pxpl3Vl5x4KPysh88uULRRsr
	fIj9/rL/aDlXHtZI7I6+vizGVWuZx/VTp5wdVYeeKY6bzDTC+5A==
X-Received: by 2002:a5d:5982:0:b0:343:72d3:8bf9 with SMTP id n2-20020a5d5982000000b0034372d38bf9mr5520281wri.47.1713082848860;
        Sun, 14 Apr 2024 01:20:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGV2guaUDq+KT8qZEYNEDAPvDV9IQkfqcCeSva0EuQiOh6/tEv0M8rQI8Ss1T1bEmXAO0Z4xA==
X-Received: by 2002:a5d:5982:0:b0:343:72d3:8bf9 with SMTP id n2-20020a5d5982000000b0034372d38bf9mr5520260wri.47.1713082848235;
        Sun, 14 Apr 2024 01:20:48 -0700 (PDT)
Received: from redhat.com ([31.187.78.68])
        by smtp.gmail.com with ESMTPSA id g13-20020a5d488d000000b00347321735a6sm4416572wrq.66.2024.04.14.01.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Apr 2024 01:20:47 -0700 (PDT)
Date: Sun, 14 Apr 2024 04:20:47 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	acme@kernel.org, gshan@redhat.com, jasowang@redhat.com,
	jie.deng@intel.com, krzysztof.kozlowski@linaro.org,
	lingshan.zhu@intel.com, mst@redhat.com, namhyung@kernel.org,
	stable@kernel.org, xianting.tian@linux.alibaba.com,
	yihyu@redhat.com
Subject: [GIT PULL] virtio: bugfixes
Message-ID: <20240414042047-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent

The following changes since commit fec50db7033ea478773b159e0e2efb135270e3b7:

  Linux 6.9-rc3 (2024-04-07 13:22:46 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 76f408535aab39c33e0a1dcada9fba5631c65595:

  vhost: correct misleading printing information (2024-04-08 04:11:04 -0400)

----------------------------------------------------------------
virtio: bugfixes

Some small, obvious (in hindsight) bugfixes:

- new ioctl in vhost-vdpa has a wrong # - not too late to fix

- vhost has apparently been lacking an smp_rmb() -
  due to code duplication :( The duplication will be fixed in
  the next merge cycle, this is a minimal fix.

- an error message in vhost talks about guest moving used index -
  which of course never happens, guest only ever moves the
  available index.

- i2c-virtio didn't set the driver owner so it did not get
  refcounted correctly.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Gavin Shan (2):
      vhost: Add smp_rmb() in vhost_vq_avail_empty()
      vhost: Add smp_rmb() in vhost_enable_notify()

Krzysztof Kozlowski (1):
      virtio: store owner from modules with register_virtio_driver()

Michael S. Tsirkin (1):
      vhost-vdpa: change ioctl # for VDPA_GET_VRING_SIZE

Xianting Tian (1):
      vhost: correct misleading printing information

 .../driver-api/virtio/writing_virtio_drivers.rst   |  1 -
 drivers/vhost/vhost.c                              | 30 ++++++++++++++++++----
 drivers/virtio/virtio.c                            |  6 +++--
 include/linux/virtio.h                             |  7 +++--
 include/uapi/linux/vhost.h                         | 15 ++++++-----
 5 files changed, 42 insertions(+), 17 deletions(-)


