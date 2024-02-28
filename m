Return-Path: <kvm+bounces-10218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B17C86ABBB
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 10:57:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF41E1F21BE9
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 09:57:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82B3136B0D;
	Wed, 28 Feb 2024 09:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DP4z4SAb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C2536AE0
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 09:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709114240; cv=none; b=F6Zz3FyHsMk/wpCQ8mzTZy2WOAsVnCBUU1IxMf+WzVaVpYc9uLMM+HrkuEidpkVZeuegVTweHUMCSBqZ9gUYZgGRaxfgyHnwA4VkpalH3UFXxsr8yJJckJZ2AW/k6oIvSw8jsfnTN+wLWdFuNHJIMQBdOrgiwuqq6GXXBWU9Qfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709114240; c=relaxed/simple;
	bh=CcbeAJp80KVmz3aYAB63nVgtI5ts2lCKBLqbf4p9u/M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=AlWQ/S4LFmBxH+meJq4CC/ncEBkC2gYioq3UnizLJsq5hcRv4n7ZuDwJyDyfGNieb4YF7aidsRAP3oD2gVtXZAcYacmUDt01UEn3KblnPcGFmqiOfsCqkubgThvSD+Sd9GQTZNGhF/AXl6Rc0cTe/lz6Q/39uBXIQNt0d7gib0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DP4z4SAb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709114237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CcbeAJp80KVmz3aYAB63nVgtI5ts2lCKBLqbf4p9u/M=;
	b=DP4z4SAbPJJDpnPF66Lpj6L1hcHeGF5zKIHR9P0brcOeGNrY+Tr7M208AbMaI95lrm9UiH
	d3T6dDcPkuv8y70Cmuo2UAe4XMr0P+dL9dO/ny9Hd0meK1jPgxGIvwEWItRuy0yuijcB9r
	jNAF7ZP4zt0VIDgv/bPC62RlkgoAdLg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-260-1AGoZHF4OdiTeK4bp1B_lg-1; Wed,
 28 Feb 2024 04:57:13 -0500
X-MC-Unique: 1AGoZHF4OdiTeK4bp1B_lg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9459B1C0983E;
	Wed, 28 Feb 2024 09:57:12 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.193.4])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CBC2401CB7B;
	Wed, 28 Feb 2024 09:57:12 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 1476921E66F9; Wed, 28 Feb 2024 10:57:11 +0100 (CET)
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
Subject: Re: [PATCH v9 03/21] hw/core: Introduce module-id as the topology
 subindex
In-Reply-To: <20240227103231.1556302-4-zhao1.liu@linux.intel.com> (Zhao Liu's
	message of "Tue, 27 Feb 2024 18:32:13 +0800")
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
	<20240227103231.1556302-4-zhao1.liu@linux.intel.com>
Date: Wed, 28 Feb 2024 10:57:11 +0100
Message-ID: <87le74zzbc.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Zhao Liu <zhao1.liu@linux.intel.com> writes:

> From: Zhao Liu <zhao1.liu@intel.com>
>
> Add module-id in CpuInstanceProperties, to locate the CPU with module
> level.
>
> Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

QAPI schema
Acked-by: Markus Armbruster <armbru@redhat.com>


