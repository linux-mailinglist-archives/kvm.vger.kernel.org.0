Return-Path: <kvm+bounces-67355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 913C5D01786
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 08:56:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 17EF730F1029
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 07:52:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72103368263;
	Thu,  8 Jan 2026 07:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Eoqsk7sc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44E5364052
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 07:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767858186; cv=none; b=uExXRm9FmMl9keJ26QEmm25N6cr8Pqz5wXYH8OSPjv0i93QasusuFWxefhHoheUxeAdyE3cAL1za55LoyZYLFmmDEvIskECdwQS4cbj/5Rk/LDE7am+VRMAyAyCVwak7CtnGYHQlPKKmlat+T3/kpzTwXG7+4oihd/B51XmW8c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767858186; c=relaxed/simple;
	bh=tddeTnRUgVN+e64V1snNfXJgvD6BvamIEVL59AUKxHM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=N9GSGFC7TXmwbCbQp2izXnyCCCKzQv9da1MtJJil1eAxqiplBOEwPRLuPlO4Y/lCKgSHcDLAxJm/4HTQNOHaicqfKvT7X3yIeHVMecvTq3IV32oD8wI3QuTX9Erv+7IjGKUML8Ega/GlByG5EXarV0DAJRyyNbsEfg4TCMDvi1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Eoqsk7sc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767858174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k3FzPRS+RgMd8UQLcnPbqoudPHP8jY+HPpfvQH1V/9E=;
	b=Eoqsk7scOJJBWZ86JrMKzmOyfICPfkRiK4Tp8/MscS5HfmBj7sXH+MAKYGSfxo4xBJ6WOH
	+KhHLvgEn89fwmQluhAup9jtoVjoa+oqrMoGkTAu2O9IGpiYhzQrit7Y/D1SRVC2baKe9v
	CKrZsFHJens6vUM2n4gYKNJebHZvBuo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-587-3WipRJTAPa2juzPfQXW3xA-1; Thu,
 08 Jan 2026 02:42:50 -0500
X-MC-Unique: 3WipRJTAPa2juzPfQXW3xA-1
X-Mimecast-MFC-AGG-ID: 3WipRJTAPa2juzPfQXW3xA_1767858168
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58352195608A;
	Thu,  8 Jan 2026 07:42:47 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.32])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1E88A18004D8;
	Thu,  8 Jan 2026 07:42:46 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 8B20D21E66CC; Thu, 08 Jan 2026 08:42:43 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org,  "Dr. David Alan Gilbert" <dave@treblig.org>,
  Pierrick Bouvier <pierrick.bouvier@linaro.org>,  Richard Henderson
 <richard.henderson@linaro.org>,  Paolo Bonzini <pbonzini@redhat.com>,
  qemu-riscv@nongnu.org,  "Michael S. Tsirkin" <mst@redhat.com>,  Marcel
 Apfelbaum <marcel.apfelbaum@gmail.com>,  Eduardo Habkost
 <eduardo@habkost.net>,  Zhao Liu <zhao1.liu@intel.com>,  Marcelo Tosatti
 <mtosatti@redhat.com>,  Laurent Vivier <laurent@vivier.eu>,  Palmer
 Dabbelt <palmer@dabbelt.com>,  Alistair Francis
 <alistair.francis@wdc.com>,  Weiwei Li <liwei1518@gmail.com>,  Daniel
 Henrique Barboza <dbarboza@ventanamicro.com>,  Liu Zhiwei
 <zhiwei_liu@linux.alibaba.com>,  Yoshinori Sato
 <yoshinori.sato@nifty.com>,  Max Filippov <jcmvbkbc@gmail.com>,
  kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] monitor/hmp: Reduce target-specific definitions
In-Reply-To: <20260107182019.51769-3-philmd@linaro.org> ("Philippe
	=?utf-8?Q?Mathieu-Daud=C3=A9=22's?= message of "Wed, 7 Jan 2026 19:20:19
 +0100")
References: <20260107182019.51769-1-philmd@linaro.org>
	<20260107182019.51769-3-philmd@linaro.org>
Date: Thu, 08 Jan 2026 08:42:43 +0100
Message-ID: <87jyxsczyk.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:

> From "monitor/hmp-target.h", only the MonitorDef structure
> is target specific (by using the 'target_long' type). All
> the rest (even target_monitor_defs and target_get_monitor_def)
> can be exposed to target-agnostic units, allowing to build
> some of them in meson common source set.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>

The only use of the ->get_value() callback I can see is in
get_monitor_def(), to implement HMP's $register feature.  I can't see
the callback being set.  Is it dead?


