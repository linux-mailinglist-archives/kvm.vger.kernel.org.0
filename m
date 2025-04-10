Return-Path: <kvm+bounces-43089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0C9EA8463F
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 16:25:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5262917F4DC
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 14:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A329528CF48;
	Thu, 10 Apr 2025 14:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C5xoD+Rd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2863528C5DE
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 14:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744294879; cv=none; b=RqA71kW0nJZZrlqBIRsdQ4XSqpcTY2S7QlM8TN0TLEIQjkCszs7omDvcIW+yX5TLLnl8buxl0PImOgR+1awAS0JnWojk7Yyibs2JqXWJ/Ju9BFK/FTBDFc/xxXJfPXkAlfdvwsO7p5dGg2mD9NbbBqU7O+7893/GZd8V5HU1GB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744294879; c=relaxed/simple;
	bh=Kc2TVRHiTykmeQIkKxd/ssOaR0rdTQOCp3RyHik1FvA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=c/H36+qH8HYbdMxtE4PykJtUFC7tabsqxmW9NoJu033bBwIHIYPmyjQFwwwZkIto5UWr4wb59JH17nPqYzHnxyFH4FwUYS5Ox0vUR1temyWD97yKtJLFvFuwWX2UOr25OwPzLZs7wIheqSyD0Oj0rnTX+V1+PP6A0fphqgIQeDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C5xoD+Rd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744294874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kc2TVRHiTykmeQIkKxd/ssOaR0rdTQOCp3RyHik1FvA=;
	b=C5xoD+RdfnnW9ZBR1MLFek9PmWuV3e8HOJ+EerO0cUK2Ct8B5OzQSgTvQrZQ4s4p6Bx7aY
	8eUk+oNCrHE7JSF/4IQI5nlmHONta4PT+1a6DlJZyFT1H5xnBAvuRmfMergAl8MmVA+p3j
	9muL6tH9XHFKnXViieAlM2ocgCmqMl4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-630-TnHPTNUmOGCrjIo8aGsMRg-1; Thu,
 10 Apr 2025 10:21:11 -0400
X-MC-Unique: TnHPTNUmOGCrjIo8aGsMRg-1
X-Mimecast-MFC-AGG-ID: TnHPTNUmOGCrjIo8aGsMRg_1744294870
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B973F180AF53;
	Thu, 10 Apr 2025 14:21:06 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.44.22.7])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3CFF5191F245;
	Thu, 10 Apr 2025 14:21:04 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id B6BD921E6757; Thu, 10 Apr 2025 16:21:01 +0200 (CEST)
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
In-Reply-To: <20250409082649.14733-2-zhao1.liu@intel.com> (Zhao Liu's message
	of "Wed, 9 Apr 2025 16:26:45 +0800")
References: <20250409082649.14733-1-zhao1.liu@intel.com>
	<20250409082649.14733-2-zhao1.liu@intel.com>
Date: Thu, 10 Apr 2025 16:21:01 +0200
Message-ID: <878qo8yu5u.fsf@pond.sub.org>
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

> Introduce the kvm-pmu-filter object and support the PMU event with raw
> format.

Remind me, what does the kvm-pmu-filter object do, and why would we want
to use it?

> The raw format, as a native PMU event code representation, can be used
> for several architectures.
>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> Tested-by: Yi Lai <yi1.lai@intel.com>


