Return-Path: <kvm+bounces-25228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5BC9961E3D
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 07:34:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 041211C21283
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 05:34:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CEF8142903;
	Wed, 28 Aug 2024 05:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y+jpIlX8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F26D512
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 05:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724823246; cv=none; b=MtIlKsbETd3aY4K0FK0LsMDU4pQiQwH3ZoQnFbTNPW9FlreDrGBZmtwSQ2g+Dp5MeHUVcTiegQiBDy98hxEI0c/BSdUxUY7AOHEiy9aTGU7+wV1IPK0di8b4npIufMQ/czjynucLbzAzRPm7NPoTWt+X+6Zaqe5XosplB2IFPXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724823246; c=relaxed/simple;
	bh=UA/+RqDrOCk+oYc+QQr8ZQ8csnbYVHT3jQysDSl4/yg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hVrMvWcFC9MiXVdvM418EJh4mOuSZyZ7kgOHGodsnU1EUFbOlj+6HoJv0G/EJi2laJA98j8b/fo3Mv17jLbK+dQiC2y0Y2/2Ry1CTzasfSkug2/1ebCHtiLHC5KTtTTM1eRdIYyJvhpSWJusRdz4R68lsO++YpfNdxSt3z6l5fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y+jpIlX8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724823243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UA/+RqDrOCk+oYc+QQr8ZQ8csnbYVHT3jQysDSl4/yg=;
	b=Y+jpIlX8TkoYYelBcCxhG0DjRVgtR0tfRGvOp+NlREuubHnl8jxSmQKwdntGE3uIu68vfT
	eArL6Wm2GvxFaKdRkpZGrvZ2WWaiPvCWCyI3mj+NsIAjxL8ii99S9bJkUTXvsb8xuRPDRv
	vgxt5JwEW7K9UQwvieriSc0i/Drpo8k=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-602-1nMCIYwaP1-Zu7m_jpaKmw-1; Wed,
 28 Aug 2024 01:34:00 -0400
X-MC-Unique: 1nMCIYwaP1-Zu7m_jpaKmw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B1111955D4B;
	Wed, 28 Aug 2024 05:33:59 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.112])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 89BFE1955D42;
	Wed, 28 Aug 2024 05:33:57 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 54B6221E6A28; Wed, 28 Aug 2024 07:33:55 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Ani Sinha <anisinha@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>,  Paolo Bonzini
 <pbonzini@redhat.com>,  Zhao Liu <zhao1.liu@intel.com>,  cfontana@suse.de,
  qemu-trivial@nongnu.org,  kvm@vger.kernel.org,  qemu-devel
 <qemu-devel@nongnu.org>
Subject: Re: [PATCH v4 2/2] kvm: refactor core virtual machine creation into
 its own function
In-Reply-To: <CAK3XEhPPWvRuzc=DZiP0ni-c9-KsT6=R+9_XAM5224KsiARh=g@mail.gmail.com>
	(Ani Sinha's message of "Tue, 27 Aug 2024 21:05:41 +0530")
References: <20240827151022.37992-1-anisinha@redhat.com>
	<20240827151022.37992-3-anisinha@redhat.com>
	<CAFEAcA9Xq7S6_-hYkNYdv6-z7tM7xSgDGyC92L19kTm02qScAw@mail.gmail.com>
	<CAK3XEhPPWvRuzc=DZiP0ni-c9-KsT6=R+9_XAM5224KsiARh=g@mail.gmail.com>
Date: Wed, 28 Aug 2024 07:33:55 +0200
Message-ID: <87a5gxgqik.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Ani Sinha <anisinha@redhat.com> writes:

> On Tue, 27 Aug, 2024, 8:59 pm Peter Maydell, <peter.maydell@linaro.org>
> wrote:
>
>> On Tue, 27 Aug 2024 at 16:11, Ani Sinha <anisinha@redhat.com> wrote:
>> >
>> > Refactoring the core logic around KVM_CREATE_VM into its own separate
>> function
>> > so that it can be called from other functions in subsequent patches.
>> There is
>> > no functional change in this patch.
>>
>> What subsequent patches? This is patch 2 of 2...
>
> I intend to post them later as a part of a larger patch series when my
> changes have stabilized.

Call them "future patches" then :)


