Return-Path: <kvm+bounces-72513-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OG93O0Cvpmn9SgAAu9opvQ
	(envelope-from <kvm+bounces-72513-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 10:52:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 504C01EC1BA
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 10:52:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3421930EA5E0
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 09:49:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5213A38F639;
	Tue,  3 Mar 2026 09:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fa1QPRwu";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="SEy5+ORm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B99638F653
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 09:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772531392; cv=none; b=ToA34p6qjFQGyH86kmnwauMdd3OUsyd4Og5nW42jBTj5ud7qoe5kNml1GXIpLVO7QUGFM07SNxxHr5954l3SyQHPJu6p1KqBuiOqOGrVKia2zSASBCcdC3KpkI3wU3bNRl1b2Ka68JO4HKNsf0EsXfNRxMbuXJr6HEKACsWR17k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772531392; c=relaxed/simple;
	bh=D82we1/S7CpQEwb5p/LRrkMntBwk09K9srnJc17tQ1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bsq/bdummAhhzRhtJ+e9Rf48p65eE/hia28g7N2pbvgybIWHsnQnIXM43Q4J9zOUncBVJartfbTsz6wy2Ao4nid09DxdKeSSJuE/0q6Ajp7cYvuLh6vil/oKErcDcszGXZia4nMBGYexTWSie2zgMtWWpocQQHamy11yMQ+Pax0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fa1QPRwu; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=SEy5+ORm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772531390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nr4K8j7YtMX/4S/mJWMk637aePMGr7h3tPxcdH4coBg=;
	b=Fa1QPRwuACYHH1DSP9HjCwrwcpfR2LKTL90oP1cYoj6v2XgFAL6MK+bZKQv3/DXiRsjP4N
	fi7Pg1ApKjY7p1dA/ocCwNGCz6qBrZlyrry+wP6Lu16dwVsAYBg/2KAfl8eBr0gLDV0K4M
	DzDXVstXc4bKJ4x/Pbdz6qOWI3dMDNM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-213-l8yNV2oKPfG1OnJv6k4Fqw-1; Tue, 03 Mar 2026 04:49:48 -0500
X-MC-Unique: l8yNV2oKPfG1OnJv6k4Fqw-1
X-Mimecast-MFC-AGG-ID: l8yNV2oKPfG1OnJv6k4Fqw_1772531388
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-439c2a0d821so150370f8f.1
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 01:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772531387; x=1773136187; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nr4K8j7YtMX/4S/mJWMk637aePMGr7h3tPxcdH4coBg=;
        b=SEy5+ORmZmeZfAn7YGQ6bqpOHKTEJYp8mkxCdvX7yeBfTLYlYks16te2GCK9+0tXlZ
         O1/9kLXk8eWLuWN0zAVJ8l3zwJqL+SYcn7KbCmtGLyI1qU9tRnWOEo4DlkQ5Yfyw74af
         qSdhFAHwhOylhLadg2an+2vq/WaRA5uTML4opS9F3Cmme+cTBcwL/D8YVfeKEMuy1tsp
         duAOij7sRnOaApll4+77MAQhspXTyRbYEyLf0OszG+zPe6lLU4SYojxgWeX3hdjfLtBx
         ADXH0BjEKgSr0ljUNQTAR5ypz+oyuq4R485O4hwr/mqhqk7BilavbxPVsM5ti9Emr51K
         7zDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772531387; x=1773136187;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nr4K8j7YtMX/4S/mJWMk637aePMGr7h3tPxcdH4coBg=;
        b=i7oom/pE8kqQ1xhc2OhDrvvquYEaYro3VryVtuodXnJgorlkR+F63Pwqot0s8q0r4B
         p4Goa2b7IWmoFMT1T0DWndfAwPY3HcEwnu+Qgn2NmvX4EhjI/9Iwh28biaSqUDH47blC
         Y5kIo3IXtxevXXHSGts6FcFmjb3s+OB+5USvJrwI8smqESk/v6bG4AeQ8IJkRWItHZCw
         QXsdBXiPMShEvplMTCqeZDGTPDdcmLZmka959IOKp27lU+5xRdFUjoypz5HoCYnftL+z
         jUlqfPjuObdYfZ0zyIX4FwB6c2aR6JAUTJ9V4Jimglnxd//E+KecatTd0FvcTczRNury
         BIGg==
X-Forwarded-Encrypted: i=1; AJvYcCWPWUoB39i/M2DVKi0nJlLPiXCWhZxjUYqgnGH9aT/Nm7NFLROESgROjc0jE/f8OzutNCE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwT7d3ET0GZIgFBOB9WIJkhOhhM8hfdjHwNo2EApcr5jx5mn28K
	RJckBHrejmR/XP86WnQXHxiuNENxxkVhqT8RHsu6hXx3jRiliobpuhOkbEUq91Tr2NSX4B2mgtr
	yrP20AUSQbl2Frm8B3vPOCDo445gtRcujmDUU63g2Pj5oUz2wjuwxSA==
X-Gm-Gg: ATEYQzwdB14pFySSof0lbK1ZSEXqHdS8NqJe4Q60wQTiTbCitpqLEUn1Te02dSnJ8vn
	g4s/XKktjQLC67iRKIrOLosLWn5obviysd0ulymoS1X/9IeUVkfX+CZgw3WHCnDzjW5f3DSb3qN
	ldTnpe8YGq2nsj3o4V3O/M/a1g0n3FZx3SvWOhg7ZXonxbddW1qUEq6OBW+EGXpbFzUvagqwPRW
	AbG9Rn6Fa/aGyXq71GA1AzTIJsnLHovHoQx7Y0xlGnx14fEEeOQ+CcJHfasFhVFDfOXKJ8Zk9HZ
	reWJ/mVGdVbQrgUmirBAcLbJoQX4gasj6kbknTntYLQvmv1IncxmDj55V4xqVHZ8oGShJhKUe3G
	BD9r5wz2R9dXYgfHsE0hb6szAtOlwEnG16eQrAoLvpEgMN5m6oDKXY6RRgjN15yCiSaVEPL4=
X-Received: by 2002:a5d:4a84:0:b0:439:b636:1fa4 with SMTP id ffacd0b85a97d-439b63620admr9237354f8f.48.1772531387585;
        Tue, 03 Mar 2026 01:49:47 -0800 (PST)
X-Received: by 2002:a5d:4a84:0:b0:439:b636:1fa4 with SMTP id ffacd0b85a97d-439b63620admr9237323f8f.48.1772531387058;
        Tue, 03 Mar 2026 01:49:47 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439c2f8c0e7sm1250362f8f.29.2026.03.03.01.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 01:49:46 -0800 (PST)
Date: Tue, 3 Mar 2026 10:49:41 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Alexander Graf <graf@amazon.com>
Cc: Bryan Tan <bryan-bt.tan@broadcom.com>, 
	Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, kvm@vger.kernel.org, eperezma@redhat.com, 
	Jason Wang <jasowang@redhat.com>, mst@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, 
	nh-open-source@amazon.com
Subject: Re: [PATCH] vsock: Enable H2G override
Message-ID: <aaaqLbRNmoRHNTkh@sgarzare-redhat>
References: <20260302104138.77555-1-graf@amazon.com>
 <aaVrsXMmULivV4Se@sgarzare-redhat>
 <aaV80wWlpjEtYCQJ@sgarzare-redhat>
 <17d63837-6028-475a-90df-6966329a0fc2@amazon.com>
 <aaW2FgoaXIJEymyR@sgarzare-redhat>
 <27dcad4e-d658-4b6b-93b2-44c64fcbeb11@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <27dcad4e-d658-4b6b-93b2-44c64fcbeb11@amazon.com>
X-Rspamd-Queue-Id: 504C01EC1BA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72513-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sgarzare@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026 at 08:04:22PM +0100, Alexander Graf wrote:
>
>On 02.03.26 17:25, Stefano Garzarella wrote:
>>On Mon, Mar 02, 2026 at 04:48:33PM +0100, Alexander Graf wrote:
>>>
>>>On 02.03.26 13:06, Stefano Garzarella wrote:
>>>>CCing Bryan, Vishnu, and Broadcom list.
>>>>
>>>>On Mon, Mar 02, 2026 at 12:47:05PM +0100, Stefano Garzarella wrote:
>>>>>
>>>>>Please target net-next tree for this new feature.
>>>>>
>>>>>On Mon, Mar 02, 2026 at 10:41:38AM +0000, Alexander Graf wrote:
>>>>>>Vsock maintains a single CID number space which can be used to
>>>>>>communicate to the host (G2H) or to a child-VM (H2G). The 
>>>>>>current logic
>>>>>>trivially assumes that G2H is only relevant for CID <= 2 
>>>>>>because these
>>>>>>target the hypervisor.  However, in environments like Nitro 
>>>>>>Enclaves, an
>>>>>>instance that hosts vhost_vsock powered VMs may still want 
>>>>>>to communicate
>>>>>>to Enclaves that are reachable at higher CIDs through 
>>>>>>virtio-vsock-pci.
>>>>>>
>>>>>>That means that for CID > 2, we really want an overlay. By 
>>>>>>default, all
>>>>>>CIDs are owned by the hypervisor. But if vhost registers a 
>>>>>>CID, it takes
>>>>>>precedence.  Implement that logic. Vhost already knows which CIDs it
>>>>>>supports anyway.
>>>>>>
>>>>>>With this logic, I can run a Nitro Enclave as well as a 
>>>>>>nested VM with
>>>>>>vhost-vsock support in parallel, with the parent instance able to
>>>>>>communicate to both simultaneously.
>>>>>
>>>>>I honestly don't understand why VMADDR_FLAG_TO_HOST (added 
>>>>>specifically for Nitro IIRC) isn't enough for this scenario 
>>>>>and we have to add this change.  Can you elaborate a bit more 
>>>>>about the relationship between this change and 
>>>>>VMADDR_FLAG_TO_HOST we added?
>>>
>>>
>>>The main problem I have with VMADDR_FLAG_TO_HOST for connect() is 
>>>that it punts the complexity to the user. Instead of a single CID 
>>>address space, you now effectively create 2 spaces: One for 
>>>TO_HOST (needs a flag) and one for TO_GUEST (no flag). But every 
>>>user space tool needs to learn about this flag. That may work for 
>>>super special-case applications. But propagating that all the way 
>>>into socat, iperf, etc etc? It's just creating friction.
>>
>>Okay, I would like to have this (or part of it) in the commit 
>>message to better explain why we want this change.
>>
>>>
>>>IMHO the most natural experience is to have a single CID space, 
>>>potentially manually segmented by launching VMs of one kind within 
>>>a certain range.
>>
>>I see, but at this point, should the kernel set VMADDR_FLAG_TO_HOST 
>>in the remote address if that path is taken "automagically" ?
>>
>>So in that way the user space can have a way to understand if it's 
>>talking with a nested guest or a sibling guest.
>>
>>
>>That said, I'm concerned about the scenario where an application 
>>does not even consider communicating with a sibling VM.
>
>
>If that's really a realistic concern, then we should add a 
>VMADDR_FLAG_TO_GUEST that the application can set. Default behavior of 
>an application that provides no flags is "route to whatever you can 
>find": If vhost is loaded, it routes to vhost. If a vsock backend 

mmm, we have always documented this simple behavior:
- CID = 2 talks to the host
- CID >= 3 talks to the guest

Now we are changing this by adding fallback. I don't think we should 
change the default behavior, but rather provide new ways to enable this 
new behavior.

I find it strange that an application running on Linux 7.0 has a default 
behavior where using CID=42 always talks to a nested VM, but starting 
with Linux 7.1, it also starts talking to a sibling VM.

>driver is loaded, it routes there. But the application has no say in 
>where it goes: It's purely a system configuration thing.

This is true for complex things like IP, but for VSOCK we have always 
wanted to keep the default behavior very simple (as written above). 
Everything else must be explicitly enabled IMHO.

>
>
>>Until now, it knew that by not setting that flag, it could only talk 
>>to nested VMs, so if there was no VM with that CID, the connection 
>>simply failed. Whereas from this patch onwards, if the device in the 
>>host supports sibling VMs and there is a VM with that CID, the 
>>application finds itself talking to a sibling VM instead of a nested 
>>one, without having any idea.
>
>
>I'd say an application that attempts to talk to a CID that it does now 
>know whether it's vhost routed or not is running into "undefined" 
>territory. If you rmmod the vhost driver, it would also talk to the 
>hypervisor provided vsock.

Oh, I missed that. And I also fixed that behaviour with commit 
65b422d9b61b ("vsock: forward all packets to the host when no H2G is 
registered") after I implemented the multi-transport support.

mmm, this could change my position ;-) (although, to be honest, I don't 
understand why it was like that in the first place, but that's how it is 
now).

Please document also this in the new commit message, is a good point.
Although when H2G is loaded, we behave differently. However, it is true 
that sysctl helps us standardize this behavior.

I don't know whether to see it as a regression or not.

>
>
>>Should we make this feature opt-in in some way, such as sockopt or 
>>sysctl? (I understand that there is the previous problem, but 
>>honestly, it seems like a significant change to the behavior of 
>>AF_VSOCK).
>
>
>We can create a sysctl to enable behavior with default=on. But I'm 
>against making the cumbersome does-not-work-out-of-the-box experience 
>the default. Will include it in v2.

The opposite point of view is that we would not want to have different 
default behavior between 7.0 and 7.1 when H2G is loaded.

>
>
>>
>>>
>>>At the end of the day, the host vs guest problem is super similar 
>>>to a routing table.
>>
>>Yeah, but the point of AF_VSOCK is precisely to avoid complexities 
>>such as routing tables as much as possible; otherwise, AF_INET is 
>>already there and ready to be used. In theory, we only want 
>>communication between host and guest.
>
>
>Yes, but nesting is a thing and nobody thought about it :). In 
>retrospect, it would have been to annotate the CID with the direction: 
>H5 goes to CID5 on host and G5 goes to CID5 on guest. But I see no 
>chance to change that by now.

Yep, this is why we added the VMADDR_FLAG_TO_HOST.

Stefano


