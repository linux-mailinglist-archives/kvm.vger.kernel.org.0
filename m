Return-Path: <kvm+bounces-33242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8503E9E7E7F
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 07:15:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FB8616CF24
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 06:15:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0B3C85628;
	Sat,  7 Dec 2024 06:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VEOflQP+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F00A4A1C
	for <kvm@vger.kernel.org>; Sat,  7 Dec 2024 06:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733552133; cv=none; b=Jrmz7diH5J0BYihIjG9k5v8dy9AoOsCvkdoTjILDiMnNcUNw1coq5tndLL/dehq2TsZUhZ1FlPGiFLTFow8s8+XeapgVgyaTdu1Z7PfAOT/DxEnNJYIJxlE/SqRK2rmBWUeIVM/WdkjayG5KZ0367BuLon4SCu0gu8qFKoclqKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733552133; c=relaxed/simple;
	bh=kpg5Ua3RXtqERrM7V2/4bxuOAhBlDv6YWF+SmuSfkeE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=NB5t3Glsbim5ysLxGlZitEq5IiecIbvkpkk0e+ai/fP2HkGvH350CtR8VdKmqhY4t0cgi7UNLlGbIbN1etSRcMCr75LAt3l/D/jvXh0gJA9CyTvh0WUK3uubpzmYf2MmEiUrW1yGcWZSRK44PYDEL6RprTMnM9yDfbxiogXPTtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VEOflQP+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733552130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tILUWkOynGcxZLRqxYuvAMRZoJ7id6suG2iETpQQw8E=;
	b=VEOflQP+PaNqL7s+UVD0t0Xt3pYjBweKbo6ptym2VV43+tBW9lXaLufk74WDABq0dvvdVy
	R0JGbMua0rrhP0PHv3m+Z1fnsbQFP004S1jwkGiA19f4sq7odw0hD89puyMp8R/FnM4h5x
	KoUxQPM0lR8WorZBLIVAbmHzmYFVm7E=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-27-fJJCT3cEO-egzGMfrZ5JHg-1; Sat,
 07 Dec 2024 01:15:26 -0500
X-MC-Unique: fJJCT3cEO-egzGMfrZ5JHg-1
X-Mimecast-MFC-AGG-ID: fJJCT3cEO-egzGMfrZ5JHg
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 42D6919560B6;
	Sat,  7 Dec 2024 06:15:23 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.194.102])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4647A1956095;
	Sat,  7 Dec 2024 06:15:22 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id EABEA21E66D2; Sat,  7 Dec 2024 07:15:19 +0100 (CET)
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
In-Reply-To: <87frn03tun.fsf@pond.sub.org> (Markus Armbruster's message of
	"Sat, 07 Dec 2024 07:11:44 +0100")
References: <cover.1733504943.git.mchehab+huawei@kernel.org>
	<87frn03tun.fsf@pond.sub.org>
Date: Sat, 07 Dec 2024 07:15:19 +0100
Message-ID: <87wmgc2f48.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Markus Armbruster <armbru@redhat.com> writes:

> This is v10, right?

Scratch that, the cover letter explains: "As agreed duing v10 review,
I'll be splitting the big patch series into separate pull requests,
starting with the cleanup series.  This is the first patch set,
containing only such preparation patches."

However, it doesn't apply for me.  What's your base?


