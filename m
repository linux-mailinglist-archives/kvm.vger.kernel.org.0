Return-Path: <kvm+bounces-10217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 31E6486ABB5
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 10:56:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E20A828BDC9
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 09:56:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A76636B00;
	Wed, 28 Feb 2024 09:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VghRF4On"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E426B36AE0
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 09:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709114211; cv=none; b=KDz9bq4U/itl3ZewV/eMebPqZnqbq9lNNVIWaP60i9V/V21y/ArfTmGGlVSX+IesiCa5oHTCvDFAUP01rN/Lqkx6ubObrnOS8xDo1U+khwjPaj6vwuApBl9cKYdfAZ6WhZEJzr7wGsu7JP8O+k4N1sTJ/pFy70TYTlOGG6boVDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709114211; c=relaxed/simple;
	bh=c08ZVTu7WMCexIeTAilRWGnCaG1JQhYHaW9QSRRnGaQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=F98tnvdX8Ne4X7ob9QWE7S3ifpFAnz5jROP6Bp3lIlpzQuyo89j4s2Q4JW18IknfFZ+f+pQiPnvp+j1AdkBT812KrAFA5q/WRUgXh9mXrdTruUIewT6atf/oxAnkpY3ZSYPF3vHVgPFf1lNKp0eNinIe6fS28r70k0yWj6ISMjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VghRF4On; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709114208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c08ZVTu7WMCexIeTAilRWGnCaG1JQhYHaW9QSRRnGaQ=;
	b=VghRF4OnMOCxzqPw7OKiEiiYOMVGh59Q8zkW7BuKQJPVLcpViVWs3WxIsEEE3eNuFKfcjU
	d6mdSRkAhem4+6CbTDoRvqmLCEwlQi13VOvfo5CkBloPVqk9Vc8ggjnG80j8JKI25tz+Pt
	g0/gjv4MDxA1HE+TjMJ3fPd0P2X0ooc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-438-RsRko6unP86Tw6VHFT0Tuw-1; Wed,
 28 Feb 2024 04:56:45 -0500
X-MC-Unique: RsRko6unP86Tw6VHFT0Tuw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC4A01C09833;
	Wed, 28 Feb 2024 09:56:44 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.193.4])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 46E4CC01644;
	Wed, 28 Feb 2024 09:56:44 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 38B5A21E66F9; Wed, 28 Feb 2024 10:56:43 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Zhao Liu <zhao1.liu@linux.intel.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,  Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>,  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>,
  Yanan Wang <wangyanan55@huawei.com>,  "Michael S . Tsirkin"
 <mst@redhat.com>,  Richard Henderson <richard.henderson@linaro.org>,
  Paolo Bonzini <pbonzini@redhat.com>,  Eric Blake <eblake@redhat.com>,
  Marcelo Tosatti <mtosatti@redhat.com>,  Daniel P . =?utf-8?Q?Berrang?=
 =?utf-8?Q?=C3=A9?=
 <berrange@redhat.com>,  Xiaoyao Li <xiaoyao.li@intel.com>,
  qemu-devel@nongnu.org,  kvm@vger.kernel.org,  Zhenyu Wang
 <zhenyu.z.wang@intel.com>,  Zhuocheng Ding <zhuocheng.ding@intel.com>,
  Babu Moger <babu.moger@amd.com>,  Yongwei Ma <yongwei.ma@intel.com>,
  Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v9 02/21] hw/core/machine: Support modules in -smp
In-Reply-To: <20240227103231.1556302-3-zhao1.liu@linux.intel.com> (Zhao Liu's
	message of "Tue, 27 Feb 2024 18:32:12 +0800")
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
	<20240227103231.1556302-3-zhao1.liu@linux.intel.com>
Date: Wed, 28 Feb 2024 10:56:43 +0100
Message-ID: <87plwgzzc4.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Zhao Liu <zhao1.liu@linux.intel.com> writes:

> From: Zhao Liu <zhao1.liu@intel.com>
>
> Add "modules" parameter parsing support in -smp.
>
> Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

QAPI schema
Acked-by: Markus Armbruster <armbru@redhat.com>


