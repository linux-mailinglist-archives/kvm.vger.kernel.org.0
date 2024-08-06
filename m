Return-Path: <kvm+bounces-23422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A432949731
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 19:57:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 12733B21AF0
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 17:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A3F5770FD;
	Tue,  6 Aug 2024 17:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QOrGkEHb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13E2757F8
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 17:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722967054; cv=none; b=HjdgRtQkSlVcEmKj+O4jbeTm+bEcdSIi9i6EdFli2VXn97gD/6mOA6dKjBjb2yvJOYy6vdD6pjxww4+xhKSFV6zy27ZWTlCs2B4KwyA5CJNPiVygbj0NM4c+pv4YllaXnLyTKbTIVTQ02DExtlgJCbrcOzmaNahNH01JX+ABCsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722967054; c=relaxed/simple;
	bh=Y3kpDopP34wSS4aefVZmlrz8cQFzCX6exogFHU3d/Qg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=A9UPgO694XVsFR+5+zu0b47xhpDfGHc2FMXGKVviYHX7vA0t/qEG8g4gyxaNlmxSFAmtQDkgrOLdKyeSobkREFkEI/I9oolXfcRIP/lWmurYnrxgdb/DZb5TNX8vjgXuf9luH6ogJrwixFTt9C65QrAkJGUKqyFk1sryckCYXSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QOrGkEHb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722967050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=PCE6y3gd/ZLdIqr+zXDfXpXA+sJAwSBPUwATht6B/14=;
	b=QOrGkEHbq18AlKXPOs5GgVYjKtcUBLYRET7OWvQPpOqEZ+FgEQR2WVsuWvotDJ+6iQUL/V
	Io6lMOFhkRfYwSoJF6BTijEFr6mXED1+pmh52s1YpeAlsvtpAf2zb1iAaFj9XcwUfTk/mw
	V+BSqEXJPq/O4XGQ59SRm8egiJryrjI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-d4H4NTY8N7aLB-9T6UOFJA-1; Tue, 06 Aug 2024 13:57:29 -0400
X-MC-Unique: d4H4NTY8N7aLB-9T6UOFJA-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5a37b858388so698275a12.1
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2024 10:57:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722967048; x=1723571848;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PCE6y3gd/ZLdIqr+zXDfXpXA+sJAwSBPUwATht6B/14=;
        b=rqndrrCVggGQ+dJ3sqHyqK5whcIoyuNw6swkvp1kikACXCbcGF6uxV+ok8me61K0j5
         FX8UjEgIC1ZdmuzWCgaeb4hh/6PS/geFazOC3t82sa4aLh+jSgj8Ka1OzFntuOcXx1dR
         8zTFW49+7s5TT9Hs3lLqI4+e8PYtG5bD4XBNGtSP8aE3YxzcFXN/+hDdbIuE8/vWfT8W
         Cz8EZdaMnbyVlvUZOZSeiVajzG4NjH+E8r0tJIPHXgFlVheJSI1m3qF0UXSgC+yf9ohw
         annMDLpBhlZEmUr0sr4JvqcwJ3MwxAgCTrqjiAfEAH/KecXGxgLixIxbAKqRaF2qlP+J
         fzaA==
X-Gm-Message-State: AOJu0Yw+4jdgSBlf568sPW1iTKMWDOF2JH4iKfma4bzgywCJCU7JnHFs
	Kl16NzLdo3WcnY4n9gITs/61A+4B6lKZZw/VHLRG5fxI7ukyyyOSaEcew+AtCmx4LnnTQpGIsxT
	KiIriVF02z469zsvw3XtMPk4lnyUkebnKZDBf60stjJWLXTyGPw==
X-Received: by 2002:aa7:dcd9:0:b0:5a1:40d9:6a46 with SMTP id 4fb4d7f45d1cf-5b7f5dc5d68mr10453927a12.36.1722967048117;
        Tue, 06 Aug 2024 10:57:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9wiBpXfkiQpEvZZyARq7/ap2Ik8pTsT+kT/0l0ZHqK+AvR7K5fHmkyUYpLFX0WwVH0aYZHw==
X-Received: by 2002:aa7:dcd9:0:b0:5a1:40d9:6a46 with SMTP id 4fb4d7f45d1cf-5b7f5dc5d68mr10453907a12.36.1722967047202;
        Tue, 06 Aug 2024 10:57:27 -0700 (PDT)
Received: from redhat.com ([2.55.35.170])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ba442ed7f1sm4421307a12.81.2024.08.06.10.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Aug 2024 10:57:26 -0700 (PDT)
Date: Tue, 6 Aug 2024 13:57:22 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	dtatulea@nvidia.com, jasowang@redhat.com, mst@redhat.com,
	stable@vger.kernel.org
Subject: [GIT PULL] virtio: bugfix
Message-ID: <20240806135722-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent

The following changes since commit 6d834691da474ed1c648753d3d3a3ef8379fa1c1:

  virtio_pci_modern: remove admin queue serialization lock (2024-07-17 05:43:21 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 0823dc64586ba5ea13a7d200a5d33e4c5fa45950:

  vhost-vdpa: switch to use vmf_insert_pfn() in the fault handler (2024-07-26 03:26:02 -0400)

----------------------------------------------------------------
virtio: bugfix

Fixes a single, long-standing issue with kick pass-through vdpa.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Jason Wang (1):
      vhost-vdpa: switch to use vmf_insert_pfn() in the fault handler

 drivers/vhost/vdpa.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)


