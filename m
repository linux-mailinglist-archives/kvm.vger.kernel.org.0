Return-Path: <kvm+bounces-52428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CEEF9B051E6
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 08:37:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 233001AA76F1
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 06:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5596826AAA3;
	Tue, 15 Jul 2025 06:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="sQuvfJDH"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A6519F424
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 06:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752561416; cv=none; b=J1txKFvDX0e4RI4B/6gAsK3fbAu3ZfKlV896jbrukW7sLSybE+hkWhOqQPjBEiZy35ztTl2a1SkfyRpkQyAgbLSPg8xlCPWyQ7anT7S1npS1DZhxwUIE/enD60wzuAVXwZh5LHDYNMN6uo+ZXHCxWOb4gaC3tI7EYDAyhd3R+ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752561416; c=relaxed/simple;
	bh=KmbrVJl+X2fm2+sShaHigMozwWlugdsa2QcUkJcTmGU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OT1ITMjBac84ml5upf4AA6MKCaqHNz2sFGWwzNnzGYlfVP7JHganjiRb8L0na38JFkZNGq5lequZ+rhrWHeDUZxKZV09gxLNyEkSGA0iT1XOYf3UAtLLIxwNxGQ9ghPDHP/LoDz2a0YQ/si4yAtVMdyt1SgQmEBqzkYwpr00FPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=sQuvfJDH reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from [10.105.8.218] ([192.51.222.130])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 56F6aiIJ096903
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 15 Jul 2025 15:36:44 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=LOQN1E291toLyKafWXXcPZDcbvgyynvtNOrWh5q1OLo=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250326; t=1752561404; v=1;
        b=sQuvfJDHujMdjFKLQZjwxQdaG2rH6rHaBviR+BNV/YyP5ibQwLA+gjWMNAqV5ANb
         OGRliRaBv6OqZFpBh1935kPnJFcA6HmRvIpchonmkMt0trX8aA1FfTZd0UrJaLED
         n6KwIrJUMhR8CFXpJn+dWKKvN+v8J1Vz0HcwgpoM6TLqFWCgDXTlcxNRr4fT0nU4
         JP1t9vkSNJG29+nmwBPXlxCVYIBA5MdToOFkNeB6HiQkAIo0ty2d3+viziXxVv1p
         dBf4YrgrWRwt6q2ln5MPCKRjRRZaD6qVlxyNGWm7snfn9R2nELcI7txq0PN5gRQ7
         arPvV0e8eyKYMIWGTqBdwQ==
Message-ID: <d434b098-aebc-42cb-b589-d84f7bd78c21@rsg.ci.i.u-tokyo.ac.jp>
Date: Tue, 15 Jul 2025 15:36:44 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 01/13] net: bundle all offloads in a single struct
To: Paolo Abeni <pabeni@redhat.com>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Jason Wang
 <jasowang@redhat.com>,
        Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, Luigi Rizzo <lrizzo@google.com>,
        Giuseppe Lettieri
 <g.lettieri@iet.unipi.it>,
        Vincenzo Maffione <v.maffione@gmail.com>,
        Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
        kvm@vger.kernel.org
References: <cover.1752229731.git.pabeni@redhat.com>
 <6e85b684df9f953f04b10c75288e2d4065af49a2.1752229731.git.pabeni@redhat.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <6e85b684df9f953f04b10c75288e2d4065af49a2.1752229731.git.pabeni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/07/11 22:02, Paolo Abeni wrote:
> The set_offload() argument list is already pretty long and
> we are going to introduce soon a bunch of additional offloads.
> 
> Replace the offload arguments with a single struct and update
> all the relevant call-sites.
> 
> No functional changes intended.
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> Note: I maintained  the struct usage as opposed to uint64_t bitmask usage
> as suggested by Akihiko, because the latter feel a bit more invasive.

I think a bitmask will be invasive to the same extent with the current 
version; most part of this change comes from the parameter passing, 
which does not depend on the representation of the parameter.

