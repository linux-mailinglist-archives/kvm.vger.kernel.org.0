Return-Path: <kvm+bounces-44284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 28F9FA9C3F4
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 11:41:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F4289C1F3C
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 09:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C35BB24395C;
	Fri, 25 Apr 2025 09:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aGAFROv3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A9C2367BB
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 09:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745573852; cv=none; b=Sckin58q0p5UFM9MgnrbEBCqm2OPR1E5PNqHL2BAY6Ns9LTAiYjbV3eu1FBX6BFoETwIX93uqvx3+72SBFEtrXk4HD5UZ7QzaKFT7HYB9NtCf8F5E4BBhDHELDkrOS9i+EKn51gPzJRtZUb9Zah0dToL7j0UIlqfQJN11lov8Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745573852; c=relaxed/simple;
	bh=yJ0e1wDaEdu3GmTFHVM/+1vxUUTYAG5nC9n80guqzJ0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=aW1eu/v2ld9phfXBPyAkl7gISvCf0iH7GNDOKW7eSqgAGnZmOin+YPOkB93Ge76oQUMCTGLEfucYvykSfbvaK6HIuTz2sq9xIJ4z772ClOuriAAaObSnLwPBt8oTQS0P0fRAO2VKSKy5ZQ+h1AxYOy4N9+zdOMF1fa+1CNFsLtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aGAFROv3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745573850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yJ0e1wDaEdu3GmTFHVM/+1vxUUTYAG5nC9n80guqzJ0=;
	b=aGAFROv3xHFUqHsuKqZeWYqkFLEuSA5QoaNmm0OjCVC0gg353bsf9oAMhhaZ2YnzG9fZhN
	S514CPvgXYwsVz6BqP+EpehXt4Ax1+Y6Fw0NxI31VkUES8omowM0K469QURLa8Sb7TUZmU
	rp9qEoqqmogjVWe0ZrBbsXAMsOlqOcQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-482-CMxPVJDiPI28cWcuwEQ2dQ-1; Fri,
 25 Apr 2025 05:37:26 -0400
X-MC-Unique: CMxPVJDiPI28cWcuwEQ2dQ-1
X-Mimecast-MFC-AGG-ID: CMxPVJDiPI28cWcuwEQ2dQ_1745573845
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EC6CD1955DC5;
	Fri, 25 Apr 2025 09:37:23 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.5])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5D841195608F;
	Fri, 25 Apr 2025 09:37:23 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id DF51521E66C3; Fri, 25 Apr 2025 11:37:20 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  Eric Blake <eblake@redhat.com>,
  Michael Roth <michael.roth@amd.com>,  Daniel P . =?utf-8?Q?Berrang=C3=A9?=
 <berrange@redhat.com>,  Eduardo Habkost <eduardo@habkost.net>,  Marcelo
 Tosatti <mtosatti@redhat.com>,  Shaoqin Huang <shahuang@redhat.com>,  Eric
 Auger <eauger@redhat.com>,  Peter Maydell <peter.maydell@linaro.org>,
  Laurent Vivier <lvivier@redhat.com>,  Thomas Huth <thuth@redhat.com>,
  Sebastian Ott <sebott@redhat.com>,  Gavin Shan <gshan@redhat.com>,
  qemu-devel@nongnu.org,  kvm@vger.kernel.org,  qemu-arm@nongnu.org,
  Dapeng Mi <dapeng1.mi@intel.com>,  Yi Lai <yi1.lai@intel.com>
Subject: Re: [PATCH 4/5] i386/kvm: Support event with masked entry format in
 KVM PMU filter
In-Reply-To: <20250409082649.14733-5-zhao1.liu@intel.com> (Zhao Liu's message
	of "Wed, 9 Apr 2025 16:26:48 +0800")
References: <20250409082649.14733-1-zhao1.liu@intel.com>
	<20250409082649.14733-5-zhao1.liu@intel.com>
Date: Fri, 25 Apr 2025 11:37:20 +0200
Message-ID: <874iycfupb.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Zhao Liu <zhao1.liu@intel.com> writes:

> KVM_SET_PMU_EVENT_FILTER of x86 KVM supports masked events mode, which
> accepts masked entry format event to flexibly represent a group of PMU
> events.
>
> Support masked entry format in kvm-pmu-filter object and handle this in
> i386 kvm codes.
>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> Tested-by: Yi Lai <yi1.lai@intel.com>

My review comments on PATCH 3 apply here as well.


