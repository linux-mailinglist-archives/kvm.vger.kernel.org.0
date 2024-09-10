Return-Path: <kvm+bounces-26268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5528C97390E
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 15:49:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B2CA9B224BB
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 13:49:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2106192B61;
	Tue, 10 Sep 2024 13:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MDOC61pt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6776018CBE0
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 13:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725976157; cv=none; b=OC8XfczbuRhhXi5q1vdoQdjOeO2VJ9YhhY3EVrNMP8vSCoyoLe6TDdZUKzPoalU6DFRYONv6BwaPWvn2PiIzFUYOYxwNKB28Y0tVBhzR5yGzkLSB2Z96UE6cb5vDYPA3ZjTXxfVc0/BQGR4ffIQwqy9Q2jOqQIyoo8zLAcdJVDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725976157; c=relaxed/simple;
	bh=4JNw6rrSp4cCnobv17r+ShXKCZXmS751AIzhP1PC59M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=f27RXEZt1dnpM9vlaciz6ZJGNZc58ub3OgnsETrtD/gpd6Eam8dzCO2KOwFhg2/Yijhib/cqD6LstSuIibvL0qp35F35MCxiFAVQRnOJ1wGmJ/hH9VP2Bj4S/GmgOBsu3JiqwIpeKUacuyMObZ6ZtSc9k0G2GHnInV+OWw2Y7/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MDOC61pt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725976154;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qTs7EoPQVez3aXX8JsX51lTV8mb5LjE0tb3w8l85Occ=;
	b=MDOC61ptCqRfUSSkKSYy/bxJn9QPzvPaRXmtWiohppS1d0EZ2EnYG9ePSBTJ3N6QwgY05i
	ruFei+31PjmW5U7PgppWFfbkp3BWu/EuMSExCAtNKF6c7BzQGdlGO6KZslufia6E2VtjSi
	Q/eAu/wX+4fTSrbygIDXssyts5M+Bs0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-323-ESztjxKPM9CNYEqruCwyzA-1; Tue,
 10 Sep 2024 09:49:11 -0400
X-MC-Unique: ESztjxKPM9CNYEqruCwyzA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A1F81195394C;
	Tue, 10 Sep 2024 13:49:08 +0000 (UTC)
Received: from localhost (dhcp-192-244.str.redhat.com [10.33.192.244])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E6F6B19560AD;
	Tue, 10 Sep 2024 13:49:06 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Xianglai Li <lixianglai@loongson.cn>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Song Gao <gaosong@loongson.cn>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>, Huacai Chen
 <chenhuacai@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
 kvm@vger.kernel.org, Bibo Mao <maobibo@loongson.cn>
Subject: Re: [RFC PATCH V2 1/5] include: Add macro definitions needed for
 interrupt controller kvm emulation
In-Reply-To: <2182eb694629ee3f2859e441b8076d62d3606ee2.1725969898.git.lixianglai@loongson.cn>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <cover.1725969898.git.lixianglai@loongson.cn>
 <2182eb694629ee3f2859e441b8076d62d3606ee2.1725969898.git.lixianglai@loongson.cn>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Tue, 10 Sep 2024 15:49:03 +0200
Message-ID: <87cylbvcts.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Tue, Sep 10 2024, Xianglai Li <lixianglai@loongson.cn> wrote:

> Add macro definitions needed for interrupt controller kvm emulation.
>
> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
> ---
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Song Gao <gaosong@loongson.cn>
> Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: Bibo Mao <maobibo@loongson.cn>
> Cc: Xianglai Li <lixianglai@loongson.cn>
>
>  include/hw/intc/loongarch_extioi.h    | 38 ++++++++++++++++--
>  include/hw/intc/loongarch_ipi.h       | 15 +++++++
>  include/hw/intc/loongarch_pch_pic.h   | 58 +++++++++++++++++++++++++--
>  include/hw/intc/loongson_ipi.h        |  1 -
>  include/hw/intc/loongson_ipi_common.h |  2 +
>  include/hw/loongarch/virt.h           | 15 +++++++
>  linux-headers/asm-loongarch/kvm.h     | 18 +++++++++
>  linux-headers/linux/kvm.h             |  6 +++
>  8 files changed, 146 insertions(+), 7 deletions(-)

The parts you need to split out into a separate patch are the changes
under linux-headers/ (because they get updated via a script); the
changes under include/hw/ are internal to QEMU and should go where it
makes sense (probably with the actual changes in .c files, but I didn't
check what the patch actually does.)


