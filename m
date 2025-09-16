Return-Path: <kvm+bounces-57719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CBDEB5967F
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 14:46:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0CBE1BC6BD0
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 12:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFBF5186284;
	Tue, 16 Sep 2025 12:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VcrFRUS6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3428841C71
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 12:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758026796; cv=none; b=b3VK19n8TwqSxn1+CAQJrAYGIGe6uwTIlV5DQPkpbAX7HvEVOyR/HPfi2jcXg2apmWgEDuazMepH0RVwPbovShRvAuWmZIltDgjuJSTO43K63KmcAr9/Hi3A8Pu8QJZcXxpngknjXVQcsh6wAdOg6bJedxphtKvEw8uhFn40jcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758026796; c=relaxed/simple;
	bh=PUapnppF64qAhL6E9496CtE7KgDILI6Z7r/OJ+wF8xk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=r8GAlZHPi2r8QPNg8hjH1yzHaYTodwyRy5DxzL+Y6Bd9p4lZzkaRdE9ofg1oQr5yBFTicP1C1xWTsXR1Ltxh9r6AgonsXhXMZECJW4OC3/twc+XGtQMWalj4Fsvj+o7MItBpxlVhpLfzsrQadzoZXq/HI9Rejs0VK+EZ3sT+ycc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VcrFRUS6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758026794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aG4W3mmDglu4lEoQcUF+7rzQ4DSjx/M0FEtfZHT5Tcg=;
	b=VcrFRUS6VLzRDcPMAczDyCQdLfJ0wA5nTSrBGcVAHpIb9iggvRqQeYhhI3vINubvWgvQP6
	h/MbwFd4dCT1aQ4QWco2NEjCw1rzmo1T7CCuYCvwwnbNN8HaMaHSZPqvdml90zvfLbRVYB
	a1KlMViJnOH3N7i/BbeWvOLw2+oarLU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-Hgj-_z-kOoaqxwHRQ_RUwQ-1; Tue,
 16 Sep 2025 08:46:33 -0400
X-MC-Unique: Hgj-_z-kOoaqxwHRQ_RUwQ-1
X-Mimecast-MFC-AGG-ID: Hgj-_z-kOoaqxwHRQ_RUwQ_1758026791
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1D5F519560B4;
	Tue, 16 Sep 2025 12:46:31 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.9])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E911180044F;
	Tue, 16 Sep 2025 12:46:30 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 05C1F21E6A27; Tue, 16 Sep 2025 14:46:28 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  Sean Christopherson
 <seanjc@google.com>,  qemu-devel <qemu-devel@nongnu.org>,
  kvm@vger.kernel.org,  "Daniel P. Berrange" <berrange@redhat.com>,
  Eduardo Habkost <eduardo@habkost.net>,  Eric Blake <eblake@redhat.com>,
  Marcelo Tosatti <mtosatti@redhat.com>,  Zhao Liu <zhao1.liu@intel.com>,
  Nikunj A Dadhania <nikunj@amd.com>,  Tom Lendacky
 <thomas.lendacky@amd.com>,  Michael Roth <michael.roth@amd.com>,  Neeraj
 Upadhyay <neeraj.upadhyay@amd.com>,  Roy Hopkins
 <roy.hopkins@randomman.co.uk>
Subject: Re: [RFC PATCH 3/7] target/i386: SEV: Add support for enabling
 debug-swap SEV feature
In-Reply-To: <m5fnfafkzxqamg4iyc6xjun7jlxulcuufgugtrweap6myvmgov@5cmxu5n3pl2p>
	(Naveen N. Rao's message of "Mon, 15 Sep 2025 19:55:02 +0530")
References: <cover.1757589490.git.naveen@kernel.org>
	<0a77cf472bc36fee7c1be78fc7d6d514d22bca9a.1757589490.git.naveen@kernel.org>
	<87jz239at0.fsf@pond.sub.org>
	<m5fnfafkzxqamg4iyc6xjun7jlxulcuufgugtrweap6myvmgov@5cmxu5n3pl2p>
Date: Tue, 16 Sep 2025 14:46:27 +0200
Message-ID: <87plbqo998.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Naveen N Rao <naveen@kernel.org> writes:

> Hi Markus,
>
> On Fri, Sep 12, 2025 at 01:20:43PM +0200, Markus Armbruster wrote:
>> "Naveen N Rao (AMD)" <naveen@kernel.org> writes:
>> 
>> > Add support for enabling debug-swap VMSA SEV feature in SEV-ES and
>> > SEV-SNP guests through a new "debug-swap" boolean property on SEV guest
>> > objects. Though the boolean property is available for plain SEV guests,
>> > check_sev_features() will reject setting this for plain SEV guests.
>> 
>> Let's see whether I understand...
>> 
>> It's a property of sev-guest and sev-snp-guest objects.  These are the
>> "SEV guest objects".
>> 
>> I guess a sev-snp-guest object implies it's a SEV-SNP guest, and setting
>> @debug-swap on such an object just works.
>> 
>> With a sev-guest object, it's either a "plain SEV guest" or a "SEV-ES"
>> guest.
>> 
>> If it's the latter, setting @debug-swap just works.
>> 
>> If it's the former, and you set @debug-swap to true, then KVM
>> accelerator initialization will fail later on.  This might trigger
>> fallback to TCG.
>> 
>> Am I confused?
>
> You're spot on, except that in the last case above (plain old SEV 
> guest), qemu throws an error:
> 	qemu-system-x86_64: check_sev_features: SEV features require either SEV-ES or SEV-SNP to be enabled

Okay.

Can you (or anyone) explain to me why SEV-SNP gets its own object type,
but SEV-ES does not?

[...]


