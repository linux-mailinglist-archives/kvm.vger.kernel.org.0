Return-Path: <kvm+bounces-11499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BDF4D877B2F
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 08:19:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03C6E1C20FBE
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 07:19:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 273B311C8B;
	Mon, 11 Mar 2024 07:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EFwbavc4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB6C11712
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 07:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710141588; cv=none; b=HXEciSf8uKt/y1qvZNpezYGxGCFw65M1B61keCjFgcpyOj+lrRzZlx3rjAgxPtn1+Kx+lxJJYlnS8j/tUyj5ZW8Gm8YdFzVgf0Hzf1yprX3SSfKlvQA4dZT4kge9JXdwNu0roohlr8qFkokDIVByrII6HWTfvyM4KBjhC0pJwnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710141588; c=relaxed/simple;
	bh=EW87+QbkUKdnV3/X2cJ/2egTg4ykdbKwxMuwy2x4hE8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lF1WkmF1kzjCoN0i1H4cbQC8mDyBEiYFbRrT5NgiZzEe124hNa1f5McTURSik5wzdSOZ1ZLOUfYPzhnj/vjNCI3e9KHlgJBClo7zu68NzY/Sszgd3f1yDZqyk4u1vP+7fDF+xGAwOzRNyxzFN0mAI+JqDqVCD628qqffpQeg41Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EFwbavc4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710141585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KzmgNmvdgICSA1NYTbStaHOdkDJR2rq7jAMYhzhcMos=;
	b=EFwbavc4E+a2apWNKU1amXkx7ltELYnBYi+w6KA8Bt9vKlRFzl6P0lPuWoomhWzUBjcJ1L
	B79bCAxJkSJwA+8OIRsN6VunHefIccydtCTQYz0bCyjOIqSNJEcy+YLoC7i2dF5XW3F/ln
	H9Zm2SDELUSm42UyHm9ircASihFHmoU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-533-r3vqO6KEOmuA7R-NVAsR8g-1; Mon,
 11 Mar 2024 03:19:42 -0400
X-MC-Unique: r3vqO6KEOmuA7R-NVAsR8g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B893628116A4;
	Mon, 11 Mar 2024 07:19:41 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.138])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 45E543C23;
	Mon, 11 Mar 2024 07:19:41 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 1A6EA21E6A24; Mon, 11 Mar 2024 08:19:40 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  David Hildenbrand
 <david@redhat.com>,  Igor Mammedov <imammedo@redhat.com>,  Eduardo Habkost
 <eduardo@habkost.net>,  Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Yanan Wang
 <wangyanan55@huawei.com>,  "Michael S. Tsirkin" <mst@redhat.com>,  Richard
 Henderson <richard.henderson@linaro.org>,  Ani Sinha
 <anisinha@redhat.com>,  Peter Xu <peterx@redhat.com>,  Cornelia Huck
 <cohuck@redhat.com>,  Daniel P. =?utf-8?Q?Berrang=C3=A9?=
 <berrange@redhat.com>,  Eric
 Blake <eblake@redhat.com>,  Marcelo Tosatti <mtosatti@redhat.com>,
  kvm@vger.kernel.org,  qemu-devel@nongnu.org,  Michael Roth
 <michael.roth@amd.com>,  Claudio Fontana <cfontana@suse.de>,  Gerd
 Hoffmann <kraxel@redhat.com>,  Isaku Yamahata <isaku.yamahata@gmail.com>,
  Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v5 30/65] i386/tdx: Support user configurable
 mrconfigid/mrowner/mrownerconfig
In-Reply-To: <5f426c46-1a8b-426d-bd7f-aeee95cc5219@intel.com> (Xiaoyao Li's
	message of "Mon, 11 Mar 2024 09:25:24 +0800")
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
	<20240229063726.610065-31-xiaoyao.li@intel.com>
	<87edcv1x9j.fsf@pond.sub.org>
	<f9774e89-399c-42ad-8fa8-dd4050ee46da@intel.com>
	<871q8vxuzx.fsf@pond.sub.org>
	<4602df24-029e-4a40-bdec-1b0a6aa30a3c@intel.com>
	<87v85yv3j9.fsf@pond.sub.org>
	<0f3df4b7-ffb9-4fc5-90eb-8a1d6fea5786@intel.com>
	<87ttli87sw.fsf@pond.sub.org>
	<5f426c46-1a8b-426d-bd7f-aeee95cc5219@intel.com>
Date: Mon, 11 Mar 2024 08:19:40 +0100
Message-ID: <87v85tutf7.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> On 3/7/2024 9:56 PM, Markus Armbruster wrote:

[...]

>> Alright, the doc comment is not the place to educate me about TDX.
>
> I'm pleased to help you (on or off the maillist) if you have any question on TDX. :)

I can't possibly become knowledgable about QEMU's entire external
interface, it's simply too much.  Where I'm ignorant, I try to learn
just enough to ensure the documentation is useful.

I appreciate your kind & patient help with that.

>> Perhaps we can go with
>> # @mrconfigid: ID for non-owner-defined configuration of the guest TD,
>> #     e.g., run-time or OS configuration (base64 encoded SHA384 digest).
>> #     Defaults to all zeroes.
>> 
>
> I will update to this in next version.
> Huge thanks for your help!

You're welcome!


