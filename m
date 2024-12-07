Return-Path: <kvm+bounces-33241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E356E9E7E7A
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 07:12:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A48CA282147
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 06:12:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 652E612E1CD;
	Sat,  7 Dec 2024 06:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UBUzQ1yL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B8D4A24
	for <kvm@vger.kernel.org>; Sat,  7 Dec 2024 06:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733551922; cv=none; b=ZFOuSQq99tKvdDVnxu3rvhaso/4QKRiF7Fy8GPFZphHFFdvWEXEzJTKFRgraFNcFxTDU0XR+4j7T1gS6/o3XNtVF6P03KltcRRB18GNcBB9lEAujSfgzjVz7mpFIN9+Gsaw8r7N9HPD88l97EXwgK3l5Jok5vlKFMWewyD+zuro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733551922; c=relaxed/simple;
	bh=JAegydEK5SrtzTkPOXHrT+W/4/CJo0xAyxfDyv2CBHQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kwKn8+2XGRqZQi0OLGSKdwKGYS4Mj4WYmB1G0W/RFLK8C967dSeu1jVf76zH22akWZywh9nZBNIlGZ096hd2d1+XHjcwZj6XzEBwHuENR36pPARdyhhngT5ZBf1fiDvEQ1nkKc7mHiu0ApLdgtCd1yqXfy6dwAdedur7Sfy+4fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UBUzQ1yL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733551919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JAegydEK5SrtzTkPOXHrT+W/4/CJo0xAyxfDyv2CBHQ=;
	b=UBUzQ1yLXYTwrdEd+4yYMPrc1gZfXo9NqRvZnVoc2jD8kDct6Cr5esi+L6Sd7kb5cD4dKI
	ZWmrXV/iftew+Bjx5gXgvf6kkQAIk7DJQr96jLRk0y2x7AV/OU/Legmt73Sa0iPgUCWHQW
	NLJOfJtCuHFLO4oBh4ejF0+lBdGakZ0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-503-toCfbjYRNISInvXD0fdnEw-1; Sat,
 07 Dec 2024 01:11:55 -0500
X-MC-Unique: toCfbjYRNISInvXD0fdnEw-1
X-Mimecast-MFC-AGG-ID: toCfbjYRNISInvXD0fdnEw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFD66195608B;
	Sat,  7 Dec 2024 06:11:47 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.194.102])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7D7E81955F3F;
	Sat,  7 Dec 2024 06:11:46 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 4AD2621E66D2; Sat,  7 Dec 2024 07:11:44 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: "Michael S . Tsirkin" <mst@redhat.com>,  Jonathan Cameron
 <Jonathan.Cameron@huawei.com>,  Shiju Jose <shiju.jose@huawei.com>,
  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Ani Sinha
 <anisinha@redhat.com>,  Cleber Rosa <crosa@redhat.com>,  Dongjiu Geng
 <gengdongjiu1@gmail.com>,  Eduardo Habkost <eduardo@habkost.net>,  Eric
 Blake <eblake@redhat.com>,  Igor Mammedov <imammedo@redhat.com>,  John
 Snow <jsnow@redhat.com>,  Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
  Michael Roth <michael.roth@amd.com>,  Paolo Bonzini
 <pbonzini@redhat.com>,  Peter Maydell <peter.maydell@linaro.org>,  Shannon
 Zhao <shannon.zhaosl@gmail.com>,  Yanan Wang <wangyanan55@huawei.com>,
  Zhao Liu <zhao1.liu@intel.com>,  kvm@vger.kernel.org,
  linux-kernel@vger.kernel.org,  qemu-arm@nongnu.org,
  qemu-devel@nongnu.org
Subject: Re: [PATCH 00/31] Prepare GHES driver to support error injection
In-Reply-To: <cover.1733504943.git.mchehab+huawei@kernel.org> (Mauro Carvalho
	Chehab's message of "Fri, 6 Dec 2024 18:12:22 +0100")
References: <cover.1733504943.git.mchehab+huawei@kernel.org>
Date: Sat, 07 Dec 2024 07:11:44 +0100
Message-ID: <87frn03tun.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

This is v10, right?


