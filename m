Return-Path: <kvm+bounces-47745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75E4EAC4738
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 06:28:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18EEB3B53B3
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 04:27:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25EC31D6195;
	Tue, 27 May 2025 04:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NQeX/UHR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7F0A32
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 04:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748320090; cv=none; b=VOXC0NAejuqZR1Uc2TUf6NHLNO35LdUOYZ+s17+cx1LGdayBE1vMz71AM2nO2csvJ67RWFv88Ys/uXZIlG4w1qB8PrrSXHgG0YthMr9hYM48hGUgqxlUDAlgowrrgwklotBR4qZMOwYn8kB9SlB8uqPjRGTwBxsrIS53IOyGIK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748320090; c=relaxed/simple;
	bh=rIIVqjhK0/cC8BTNLm5P5NvgCUe36XsBl+cOY8bEi4Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=uKTbldaoDjaCpUw6zWEK/9OHZsNCbGK3BmQPdsUgoh/QNbvDFtQYy15cJJq3ASJPDvdEhWtORDtWL5gHjy940+5cb+hj+ulaVxLF8lt9z/vAkfjMcGM5onqXHfgl3qFww7WU1KER3Qt5Jxq3rXNZrA8DfXqR7fGDH/Nj7n+WKpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NQeX/UHR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748320087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g2/YrwlvZsq7+WWHYoQrrt0Mo4CmgOLW02oO+FtHWF0=;
	b=NQeX/UHRAYA9jsHCMPu34UsP7H8tTUUUxq/Wp1kaxSb8F7KNnsCfCeu3dzs5Y+okbJN+ur
	2WcE7DQl2NJWL8iUvUDaE1gJdQFJbHa7trW2fqHhEvT150ylFhx3EkedlD6XM4bo41YJjh
	T8kTAiXeieiFGSVHxUsJLWq3GXlka4Q=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-86-nTHphncVOq-TTXuOZfamwg-1; Tue,
 27 May 2025 00:28:03 -0400
X-MC-Unique: nTHphncVOq-TTXuOZfamwg-1
X-Mimecast-MFC-AGG-ID: nTHphncVOq-TTXuOZfamwg_1748320082
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E3A3180045B;
	Tue, 27 May 2025 04:28:02 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.2])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 25D1A30001A1;
	Tue, 27 May 2025 04:28:01 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 73FF921E66C3; Tue, 27 May 2025 06:27:58 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  Daniel P. =?utf-8?Q?Berrang?=
 =?utf-8?Q?=C3=A9?=
 <berrange@redhat.com>,  Gerd Hoffmann <kraxel@redhat.com>,  "Michael S.
 Tsirkin" <mst@redhat.com>,  Francesco Lavra <francescolavra.fl@gmail.com>,
  Marcelo Tosatti <mtosatti@redhat.com>,  kvm@vger.kernel.org,
  qemu-devel@nongnu.org,  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>,  Zhao
 Liu <zhao1.liu@intel.com>,  Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v9 00/55] QEMU TDX support
In-Reply-To: <792cbff4-6d25-4f39-8a18-3f7affdfe5cd@intel.com> (Xiaoyao Li's
	message of "Tue, 27 May 2025 09:30:53 +0800")
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
	<e994b189-d155-44d0-ae7d-78e72f3ae0de@redhat.com>
	<792cbff4-6d25-4f39-8a18-3f7affdfe5cd@intel.com>
Date: Tue, 27 May 2025 06:27:58 +0200
Message-ID: <87a56ywucx.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> On 5/27/2025 12:12 AM, Paolo Bonzini wrote:
>> On 5/8/25 16:59, Xiaoyao Li wrote:
>>> This is the v9 series of TDX QEMU enabling. The series is also available
>>> at github:
>>> https://github.com/intel-staging/qemu-tdx/tree/tdx-qemu-upstream-v9
>>>
>>> Note, this series has a dependency on
>>> https://lore.kernel.org/qemu-devel/20241217123932.948789-1- xiaoyao.li@intel.com/
>>>
>>> =============
>>> Changes in v9
>>>
>>> Comparing to v8, no big change in v9.
>>>
>>> V9 mainly collects Reviewed-by tags from Daniel and Zhao Liu (Thanks to
>>> their review!) and v9 does some small change according to the review
>>> feedback of them. Please see the individual patch for the detailed
>>> change history.
>>
>> Queued, thanks for your patience - this was a huge effort.

Started late fall 2023?  That's perseverance!

>> I'll wait until the kernel side is picked up and then send the pull request.
>
> Thanks, Paolo!
>
> And thanks to Gerd Hoffmann, Daniel, Markus, Zhao Liu, ... and all the people who helped review and provided valuable feedback.

You're welcome!


