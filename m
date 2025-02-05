Return-Path: <kvm+bounces-37333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 92EAEA28A58
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 13:32:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56B0B168284
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 12:32:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38021229B20;
	Wed,  5 Feb 2025 12:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dYzbYTtK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A422063C0
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 12:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738758751; cv=none; b=Td/dA+VqA3whyLjomGmCjYRL2tlpmLWFP0uXaJOg33HUK0k8PygN/IAO9XCpTdzmCyDJODtQzoZTw36jCqlHgvZpnz+65zgJZ93OBZuq8bsAoVRsv8dp8ml/PE6Wu/5tDUWKFJ/yKyCWP+sMWS8cu0t2zdo3K+1RmyAz0eBgaJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738758751; c=relaxed/simple;
	bh=3dgy86L8Ba3zeQZaRJngvq48ydoqQemSV6DLcbLAx80=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=IErFz/aUiny4KcrJAync79juIrp+6rnegkipRONuZNtRirEHqcsGXBkQizTu4Cy+hCQHU60rjUDNxDKWFVIm3BpqkRPlu/mK5tvFrW+VNQFYXH0w+NZJyx5Aw+JCCri5J+cBeAz07FIcisv6nYh04ye15sn3zza0H1OL2H9k0g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dYzbYTtK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738758748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ehjN23UhFLOEmMg/5tKtfppC4JFaMbK0Ow+1rDoliVo=;
	b=dYzbYTtKAN/G0JBt1+9gkOdPljqo/QYkLxcCtTWogl9KLp2gNThcO+9kwXAEr/ehMpQjXn
	licM+SBrXdUTIuId9wp8G78TGCZWR99zaBOP3tzUqBAG4cRhm7YBW7udxH7Skv4/6h15C6
	fzG5RnHIj3wPvLan8DtbvijLORq9OwQ=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-527-U5A50OZTPn2gbVlkgZ3HUQ-1; Wed,
 05 Feb 2025 07:32:25 -0500
X-MC-Unique: U5A50OZTPn2gbVlkgZ3HUQ-1
X-Mimecast-MFC-AGG-ID: U5A50OZTPn2gbVlkgZ3HUQ
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F047B195608E;
	Wed,  5 Feb 2025 12:32:22 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.40])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E11E01800872;
	Wed,  5 Feb 2025 12:32:21 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 88EE621E6A28; Wed, 05 Feb 2025 13:32:19 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  Philippe =?utf-8?Q?Mathieu-Daud?=
 =?utf-8?Q?=C3=A9?=
 <philmd@linaro.org>,  Daniel P . =?utf-8?Q?Berrang=C3=A9?=
 <berrange@redhat.com>,  Igor
 Mammedov <imammedo@redhat.com>,  "Michael S . Tsirkin" <mst@redhat.com>,
  Richard Henderson <richard.henderson@linaro.org>,  Eduardo Habkost
 <eduardo@habkost.net>,  Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
  Yanan Wang <wangyanan55@huawei.com>,  Jonathan Cameron
 <Jonathan.Cameron@huawei.com>,  Alireza Sanaee
 <alireza.sanaee@huawei.com>,  Sia Jee Heng <jeeheng.sia@starfivetech.com>,
  qemu-devel@nongnu.org,  kvm@vger.kernel.org
Subject: Re: [PATCH v7 RESEND 0/5] i386: Support SMP Cache Topology
In-Reply-To: <20250110145115.1574345-1-zhao1.liu@intel.com> (Zhao Liu's
	message of "Fri, 10 Jan 2025 22:51:10 +0800")
References: <20250110145115.1574345-1-zhao1.liu@intel.com>
Date: Wed, 05 Feb 2025 13:32:19 +0100
Message-ID: <87jza4zi5o.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Zhao Liu <zhao1.liu@intel.com> writes:

> Hi folks,
>
> This is my v7 resend version (updated the commit message of origin
> v7's Patch 1).

If anything changed, even if it's just a commit message, make it a new
version, not a resend, to avoid confusion.  Next time :)

[...]


