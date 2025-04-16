Return-Path: <kvm+bounces-43404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C94F4A8B330
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 10:17:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF0D2444991
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 08:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A631230BE7;
	Wed, 16 Apr 2025 08:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DeW0GEcx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6C022D7BC
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 08:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744791441; cv=none; b=sfC+3xjmDikyBzqBeVfqGv9Zwl5P3zTZConfHg84t4xFPiYJa85sqtglJmQFoiPoKuAuQBzE66MlsCvNeyWwNwqJ7BG4duAYCoaNJRXqqPpGTagTLVIUficMk/rxBqDaLl3Eq+WfaZe2x5CWKR/FhBzblHLjib/kB2KneT6ZKrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744791441; c=relaxed/simple;
	bh=hGK36dqVuYa9Hoa5jNnlWPUMMV2VDbIGZcqBMN6kn7I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=PY08hSCex48hynx25ek8FAr/9vHnjtO2hz/Z65iQocM35EZqh245ZSDEqsMWC1r6V570MkaZg2CIbeLRh3LTzmVeH2Ex/QN+5Me0kZuyPCxND2zdi/71fzLBibhF3DKur6NssWsZXLJMRGiOOXqol4bryuwYMzugJ3dE7J1w0Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DeW0GEcx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744791438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+prEyTRWGZcBrE/AIyoW4nEtdjv1GtfBf5zu6/qquhE=;
	b=DeW0GEcxO0ZckpkcDt8GSKEZvxqm5iz4ClCcyAiby76nR3OGQehj8VpJ6F7J1jtfVcvbPe
	CX5rKfq9jjjIr08UU+85MTNXcx8WKs0u3DDXGxVoktUFB7sfGcw7yfxXmTTm1qE92JCUGa
	mNnfLylfH/EuAjpQ5C40fwj1d7+L6uM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-249-QmzrYM3kNo6d5vwj2mc6gQ-1; Wed,
 16 Apr 2025 04:17:14 -0400
X-MC-Unique: QmzrYM3kNo6d5vwj2mc6gQ-1
X-Mimecast-MFC-AGG-ID: QmzrYM3kNo6d5vwj2mc6gQ_1744791433
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2AD2A1800570;
	Wed, 16 Apr 2025 08:17:12 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.3])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4E5141800367;
	Wed, 16 Apr 2025 08:17:11 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id D569121E66C3; Wed, 16 Apr 2025 10:17:08 +0200 (CEST)
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
Subject: Re: [PATCH 1/5] qapi/qom: Introduce kvm-pmu-filter object
In-Reply-To: <Z/i3+l3uQ3dTjnHT@intel.com> (Zhao Liu's message of "Fri, 11 Apr
	2025 14:34:34 +0800")
References: <20250409082649.14733-1-zhao1.liu@intel.com>
	<20250409082649.14733-2-zhao1.liu@intel.com>
	<878qo8yu5u.fsf@pond.sub.org> <Z/iUiEXZj52CbduB@intel.com>
	<87frifxqgk.fsf@pond.sub.org> <Z/i3+l3uQ3dTjnHT@intel.com>
Date: Wed, 16 Apr 2025 10:17:08 +0200
Message-ID: <87fri8o70b.fsf@pond.sub.org>
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

Zhao Liu <zhao1.liu@intel.com> writes:

> On Fri, Apr 11, 2025 at 06:38:35AM +0200, Markus Armbruster wrote:
>> Date: Fri, 11 Apr 2025 06:38:35 +0200
>> From: Markus Armbruster <armbru@redhat.com>
>> Subject: Re: [PATCH 1/5] qapi/qom: Introduce kvm-pmu-filter object
>>=20
>> Zhao Liu <zhao1.liu@intel.com> writes:
>>=20
>> > Hi Markus
>> >
>> > On Thu, Apr 10, 2025 at 04:21:01PM +0200, Markus Armbruster wrote:
>> >> Date: Thu, 10 Apr 2025 16:21:01 +0200
>> >> From: Markus Armbruster <armbru@redhat.com>
>> >> Subject: Re: [PATCH 1/5] qapi/qom: Introduce kvm-pmu-filter object
>> >>=20
>> >> Zhao Liu <zhao1.liu@intel.com> writes:
>> >>=20
>> >> > Introduce the kvm-pmu-filter object and support the PMU event with =
raw
>> >> > format.
>> >>=20
>> >> Remind me, what does the kvm-pmu-filter object do, and why would we
>> >> want to use it?
>> >
>> > KVM PMU filter allows user space to set PMU event whitelist / blacklist
>> > for Guest. Both ARM and x86's KVMs accept a list of PMU events, and x86
>> > also accpets other formats & fixed counter field.
>>=20
>> But what does the system *do* with these event lists?
>
> This is for security purposes, and can restrict Guest users from
> accessing certain sensitive hardware information on the Host via perf or
> PMU counter.
>
> When a PMU event is blocked by KVM, Guest users can't get the
> corresponding event count via perf/PMU counter.
>
> EMM, if =E2=80=98system=E2=80=99 refers to the QEMU part, then QEMU is re=
sponsible
> for checking the format and passing the list to KVM.
>
> Thanks,
> Zhao

This helped some, thanks.  To make sure I got it:

KVM can restrict the guest's access to the PMU.  This is either a
whitelist (guest can access exactly what's on this list), or a blacklist
(guest can access exactly what's not this list).

QEMU's kvm-pmu-filter object provides an interface to this KVM feature.

KVM takes "raw" list entries: an entry is a number, and the number's
meaning depends on the architecture.  The kvm-pmu-filter object can take
such entries, and passes them to straight to KVM.

On x86, we commonly use two slightly higher level formats: select &
umask, and masked.  The kvm-pmu-filter object can take entries in either
format, and maps them to "raw".

Correct?


