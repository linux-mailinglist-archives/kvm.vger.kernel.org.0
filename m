Return-Path: <kvm+bounces-52847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF8B2B09A94
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 06:39:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 778055A30EC
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 04:39:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDC7C1DDA18;
	Fri, 18 Jul 2025 04:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="W+/ntnUa"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3084F54652
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 04:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752813547; cv=none; b=E+YoQM1W7L+cTY1nHRkSoQh1O2LsGvHkYWa9TlyWtv4QbjkyU+dq/rJQkJI/xH66M3lnEAoqc4jovpyEcBrdRKaLoQ2w+N2wsbnMtgyfTw4L6kTawYF5KaesLwbQmQAU2ME/AJFY6p4CyFQ1Gzeoj6gLhEjd55dCu4Fr15n0eGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752813547; c=relaxed/simple;
	bh=u4hJCbkGlx6CwEFxSNzUTHykA1ejTcHANTgaY1qL8P8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oElbl/xaWvD9rn+EuF50RtEKdXvcZvuePKe4sFwOPUYHGqvWpl0K/ObKOsLIToWD1SB+93JxDf9o1DlqL3Jqs3l3PBjULF9gnYMLNw8wWGwGmyUgOkfD+i1BhzSupk1CBtq6u0IMy6t2MoNdVymAK+bah1xWsy13BnjxCCVk2wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=W+/ntnUa reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from [10.105.8.218] ([192.51.222.130])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 56I4cuIs010090
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 18 Jul 2025 13:38:56 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=DRFKth82aOWZ+jWv0DgMGzCOWSv+/8AQ4+9M9pIi908=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250326; t=1752813536; v=1;
        b=W+/ntnUaXq0BQ1rfuLfPXcBOyiSUgiJxvGMuqhAblJidtrAU6BJsUbqc44PGN0MD
         70G4P5o0ZZucFWihcpTn815bTZtQEf9PT8bOUwPuOucNjPQ5dY29ftO3Is8gFr1+
         CN8RhxHAdq9SE8CEd8AGn1picqqjY5eROXUCMsnUObMhV4WwPzQZCoirUXm8Sfad
         5hUKaWCe+FjPJSMugArHE4EMeuYeAF21gBSIdeSgDXPjMIdXFGofoS24Ms2JFq3E
         C5kExLP/uZ+V54UYnt+2Ltvi6/erstdQifFWeSARGYxoICxTAqYABSpL86kyLhfJ
         6Gdumz0HWHFSBTa+Rxgfew==
Message-ID: <d0c816b5-682f-4c06-b7da-1754fc94507d@rsg.ci.i.u-tokyo.ac.jp>
Date: Fri, 18 Jul 2025 13:38:56 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 12/13] net: implement tunnel probing
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
 <94ffdec876d61f22a90e63d6a79ff5517d1c727c.1752229731.git.pabeni@redhat.com>
 <93de161a-3867-46aa-bfc0-2da951981bcf@rsg.ci.i.u-tokyo.ac.jp>
 <e6626fe6-c66c-4b16-93e4-447e43379424@redhat.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <e6626fe6-c66c-4b16-93e4-447e43379424@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/07/16 0:49, Paolo Abeni wrote:
> On 7/15/25 10:05 AM, Akihiko Odaki wrote:
>> On 2025/07/11 22:02, Paolo Abeni wrote:
>>> diff --git a/net/tap-bsd.c b/net/tap-bsd.c
>>> index 86b6edee94..e7de0672f4 100644
>>> --- a/net/tap-bsd.c
>>> +++ b/net/tap-bsd.c
>>> @@ -217,6 +217,11 @@ int tap_probe_has_uso(int fd)
>>>        return 0;
>>>    }
>>>    
>>> +int tap_probe_has_tunnel(int fd)
>>
>> This should return bool for consistency.
> 
> Some inconsistency will persist, as others bsd helpers supposed to
> return a bool currently return an int. I tried to be consistent with the
> surrounding code, but no strong objections.

That's true, but when considering the entire codebase, it is so common 
to return bool instead of int. So I regard the existing tap-local 
functions as exceptional, and making a new function return bool results 
in a better global consistency.

Regards,
Akihiko Odaki

