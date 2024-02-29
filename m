Return-Path: <kvm+bounces-10461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 99EE686C448
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 09:55:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBDB11C23724
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 08:55:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2244955798;
	Thu, 29 Feb 2024 08:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cU2Y+vn2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E967E54BFC
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 08:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709196904; cv=none; b=Y5nUhzbEJRjrTMFpGE2fIIyTsVHdeddJBZjSUFlOBKq7wSp9+V9SxX1Rr+CggHJ5TgheGG99vwptkcp3ttvVuG3VTaDmhf41uSh7EkX3pdR+1Fr+gQXpS9DyQghtuMN6qTudjaG8mBGzy8il+g5PU4MKeJk8A5kBuZgJr1tuBxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709196904; c=relaxed/simple;
	bh=y9asdLDJW5F8/Xn5cOrHeoDoQaLxekt/hEU83ScBOKo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=udHvnaPwbuef9NPrFbd9ur7RLtfJctvX0E5mCoIpY10ApUPuHNmyRTOxede8Dl604wSf6bQt3M5XbMvW5vNC379/cxjFGTsQBdBpkzmNLjBHYE9NVI6hBMvC+zw3FE1loGxoPtbtcGxfIQK3oiPiNN6kmtq6F6HlfbOaXmyKBbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cU2Y+vn2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709196901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 resent-to:resent-from:resent-message-id:in-reply-to:in-reply-to:
	 references:references; bh=YjLQuBE8VjLTG15gnUduGLzgQ7fKqrsO+ViK7/wp2qU=;
	b=cU2Y+vn2Tu27TlC37wxUt8pxMQid2BYKmqW4oeaL44phg/NkbslFfd0amVpmQ6KmkpLPbJ
	wpiqe7J0b9IgfO4vecL0uW1d/tP68VHETxyv9K2bi6totpcdowqycKwOW5/Nje1rEUJ2wm
	VdP+CR4FDSV14FsgmEeTRo5lOgTpklA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-BH8tX2uONB-YXM_sbWV4-Q-1; Thu, 29 Feb 2024 03:54:57 -0500
X-MC-Unique: BH8tX2uONB-YXM_sbWV4-Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D63287B2A0;
	Thu, 29 Feb 2024 08:54:56 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.193.4])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 48497492BC6;
	Thu, 29 Feb 2024 08:54:56 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 4F4D321E6740; Thu, 29 Feb 2024 09:54:55 +0100 (CET)
Resent-To: michael.roth@amd.com, isaku.yamahata@gmail.com,
 marcel.apfelbaum@gmail.com, eduardo@habkost.net, wangyanan55@huawei.com,
 chenyi.qiang@intel.com, xiaoyao.li@intel.com, philmd@linaro.org,
 richard.henderson@linaro.org, qemu-devel@nongnu.org, cfontana@suse.de,
 kvm@vger.kernel.org
Resent-From: Markus Armbruster <armbru@redhat.com>
Resent-Date: Thu, 29 Feb 2024 09:54:55 +0100
Resent-Message-ID: <87plwfzm3k.fsf@pond.sub.org>
From: Markus Armbruster <armbru@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  David Hildenbrand
 <david@redhat.com>,  Igor Mammedov <imammedo@redhat.com>,  Eduardo Habkost
 <eduardo@habkost.net>,  Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Yanan Wang
 <wangyanan55@huawei.com>,  "Michael S. Tsirkin" <mst@redhat.com>,  Richard
 Henderson <richard.henderson@linaro.org>,  Ani Sinha
 <anisinha@redhat.com>,  Peter Xu <peterx@redhat.com>,  Cornelia Huck
 <cohuck@redhat.com>,  Daniel P. =?utf-8?Q?Berrang=C3=A9?=
 <berrange@redhat.com>,  Eric
 Blake <eblake@redhat.com>,  Marcelo Tosatti <mtosatti@redhat.com>,
  kvm@vger.kernel.org,  qemu-devel@nongnu.org,  Michael Roth
 <michael.roth@amd.com>,  Claudio Fontana <cfontana@suse.de>,  Gerd
 Hoffmann <kraxel@redhat.com>,  Isaku Yamahata <isaku.yamahata@gmail.com>,
  Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v5 12/65] i386: Introduce tdx-guest object
In-Reply-To: <20240229063726.610065-13-xiaoyao.li@intel.com> (Xiaoyao Li's
	message of "Thu, 29 Feb 2024 01:36:33 -0500")
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
	<20240229063726.610065-13-xiaoyao.li@intel.com>
Date: Thu, 29 Feb 2024 09:19:55 +0100
Message-ID: <87msrj1y38.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Lines: 18
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> Introduce tdx-guest object which inherits CONFIDENTIAL_GUEST_SUPPORT,
> and will be used to create TDX VMs (TDs) by
>
>   qemu -machine ...,confidential-guest-support=tdx0	\
>        -object tdx-guest,id=tdx0
>
> So far, it has no QAPI member/properety decleared and only one internal
> member 'attributes' with fixed value 0 that not configurable.
>
> QAPI properties will be added later.
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> Acked-by: Markus Armbruster <armbru@redhat.com>

I'm happy with the commit message now.  Thanks!


