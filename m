Return-Path: <kvm+bounces-72514-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cJkSKtixpmn9SgAAu9opvQ
	(envelope-from <kvm+bounces-72514-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 11:03:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D84C1EC428
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 11:03:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BEBEF3088259
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 09:57:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84708390206;
	Tue,  3 Mar 2026 09:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c3GhRHEa";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="AbZ9oMV1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F245282F1D
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 09:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772531833; cv=none; b=NfaenIMErniO80OxNvqzww0Z1REo1SPtevIjxoyrBytoqXhF8RmSXiqRzQ1TjSKY68LJHDkG2oKkU7iDn44pv2znhzZhXGvTAKfqb0mva5e88WJ45MKJscN1ux3O+7Nzhmy29o3nqokmzNMg038Pnu78d1W628GFJ8gKaZQnZKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772531833; c=relaxed/simple;
	bh=aSsbmcc3uv2X4kalVkoQ6KfLu1yix/ZoBPk6o3r4yzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p+WWG+XgSwAnwi/++KhqOjfgR3pAV+P/V77ubv7/P1Rl9fW7RgehkNSbFcbNOqvlmi/2jf/gH/aZHTygJWw+1EB07cpY75SyuolfH84i1lvJ9KCRgA0+WjjN0+Oy++2lwnQ/9wlMJRyFiG+J0tvrx+ZfbfooGDGY8R6mTTkrQ2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c3GhRHEa; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=AbZ9oMV1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772531831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2C72I9p1Nz7IP8frqX4kg2UxiKmszT8JtYVPjpeLGo0=;
	b=c3GhRHEaU434ZA4sccAR9F4WLkZOMf5wrUW2FQE9V2o0a9+kBMznyOiG5GB4jU5ey2xTz7
	QRw5+EG9sDgpYVBaRhPjCwLHTjQ6RGYnRAJPgwb669jWDYfpJbHgFKcywPs/QP5TzY38eb
	rp3o2WfWAfB+mFWD27EZdySQBRDQ7Xk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-9sG700gtN36sRfml3apIZg-1; Tue, 03 Mar 2026 04:57:10 -0500
X-MC-Unique: 9sG700gtN36sRfml3apIZg-1
X-Mimecast-MFC-AGG-ID: 9sG700gtN36sRfml3apIZg_1772531829
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4837bfcfe0dso68598245e9.1
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 01:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772531829; x=1773136629; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2C72I9p1Nz7IP8frqX4kg2UxiKmszT8JtYVPjpeLGo0=;
        b=AbZ9oMV1R4IxENJ/igmrvz3H68v6kzkBQ49uCwRBJ6l0orLSDDutNHol9KCF8Yc3z4
         vyE/1eaGnZCT92CbIXJgmXo6R45pfH6lCyMyekDVlTbZPjUCZfqRp5+z3T7H+FVsUhc7
         oevm0MqR3uYNlHPB8Pt3V10yfVpLPjWdI8oe9EdFRaj8zhrWMP69QPWxKKGh6Tqm1i3Z
         hA2nXNM/tx+nyGgX+xxyVSWCVMgbVuHSJiaMqbweISsNzsBo9j8klAaUqdRZBw/cQ8Ns
         bXp84P+47K8TMPTMWJ4XoO56tq15mE8UWQzQ2gsh26wFnrBlmLLcahXfwKj8eQb40zNK
         7lgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772531829; x=1773136629;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2C72I9p1Nz7IP8frqX4kg2UxiKmszT8JtYVPjpeLGo0=;
        b=daCd42n9kmvh8xYqD1eCJoAsoCe0YKypfgEe8xXTbc86fhjsuCMuB4wDLsXH8IA3WT
         0vSOPn8oFa63tVARLwE2u/14FFg8UrMiDIeGBq4F9J22IgVnaA2yhFH8bpLA8ArHirBV
         TRraHdmHUFLWVe3cUmkoaoTbLGxxbyZy0TTKzYs0JCjClxXC4GsLTcru287TZqFmsMbc
         VbaA0GJIEA9naSJhVFEsLAQvCnHQGIfZHF6rglvhwzYwr8wa9iiBLH9t6NXyDJ8U4BnM
         OMlIbaLnD+E5nzzWAZqOTwprZNbmIk+uVGITGy8x+SXwyW2+sLMcIs47cLPpEQkvaaq8
         oULQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmMUNTPPDABCl7Ae4AtYle7+biKH95HFFyJub2tFq+rRo8XDVH0DVIDeDLRUGHp1B4UJg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqMRzMd+7zuwxgarp4JDxOw/B8mo61J5hhE7KuYYYYDt/0PX/N
	EAfZxdKEChjduMQJ9XWLCbhBkbXpT1MrD1a3isxwKjt4/3NCv5i6kMWLrcIjd2J/REP6DIfXtf9
	QCTDzkZ8AI5LA48HdN1dvimQlWg7t0vsaB8Gx0tbSxCpP7uHuJKH4Hw==
X-Gm-Gg: ATEYQzy2LJ0qpxPYlx6kkLC/Q8wooLhwZof/UQF33ke4gx8tCWuPfdy+6fjZ1oL9e2R
	xFaT+Ho9Gz7ZnwckINQV/nQZk8+triGAUfXUs8XkxHpZLcJTHXENfj0AcPtfMAADvezzhDw5dZY
	Fw9u+4eDAM5tmHgkrRvNepMKyu1mAPIrxFA7xL9B1K6Bo4D7s18bYO/bcqNLuqMy/fPYZE5351P
	5kO/900xlcd/PnwUPZz4qJuwojNeGSTVZYm/FESp+PK5umrXOpbUlyPI0rChUJ7SwScSvyDwkSQ
	2doTLeXkxIIbATr9C5VKTld/YJ1t3qHvb2VkjxXcX3WbZjszednx2Mw9p3FojJxiOp5GtkrFxgu
	K02b8EH9/nyLoEq3M2VQXlGo3siMebsjza4A9wMot+OpeG2XLS8/9dtYY0GIwHwSh0Orhb8Q=
X-Received: by 2002:a05:600c:154b:b0:477:b734:8c53 with SMTP id 5b1f17b1804b1-483c9b9ebd0mr256452545e9.12.1772531828869;
        Tue, 03 Mar 2026 01:57:08 -0800 (PST)
X-Received: by 2002:a05:600c:154b:b0:477:b734:8c53 with SMTP id 5b1f17b1804b1-483c9b9ebd0mr256452075e9.12.1772531828251;
        Tue, 03 Mar 2026 01:57:08 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485125bbb48sm21095135e9.0.2026.03.03.01.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 01:57:07 -0800 (PST)
Date: Tue, 3 Mar 2026 10:57:01 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Alexander Graf <graf@amazon.com>, 
	Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, kvm@vger.kernel.org, eperezma@redhat.com, 
	Jason Wang <jasowang@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, nh-open-source@amazon.com
Subject: Re: [PATCH] vsock: Enable H2G override
Message-ID: <aaau2WWQa9T0zTg2@sgarzare-redhat>
References: <20260302104138.77555-1-graf@amazon.com>
 <aaVrsXMmULivV4Se@sgarzare-redhat>
 <aaV80wWlpjEtYCQJ@sgarzare-redhat>
 <17d63837-6028-475a-90df-6966329a0fc2@amazon.com>
 <20260302145121-mutt-send-email-mst@kernel.org>
 <079fcb93-cd01-45db-9ff7-d6cafd8fb7d5@amazon.com>
 <20260303021723-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260303021723-mutt-send-email-mst@kernel.org>
X-Rspamd-Queue-Id: 3D84C1EC428
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72514-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sgarzare@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oasis-open.org:url,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 02:19:13AM -0500, Michael S. Tsirkin wrote:
>On Tue, Mar 03, 2026 at 07:51:32AM +0100, Alexander Graf wrote:
>>
>> On 02.03.26 20:52, Michael S. Tsirkin wrote:
>> > On Mon, Mar 02, 2026 at 04:48:33PM +0100, Alexander Graf wrote:
>> > > On 02.03.26 13:06, Stefano Garzarella wrote:
>> > > > CCing Bryan, Vishnu, and Broadcom list.
>> > > >
>> > > > On Mon, Mar 02, 2026 at 12:47:05PM +0100, Stefano Garzarella wrote:
>> > > > > Please target net-next tree for this new feature.
>> > > > >
>> > > > > On Mon, Mar 02, 2026 at 10:41:38AM +0000, Alexander Graf wrote:
>> > > > > > Vsock maintains a single CID number space which can be used to
>> > > > > > communicate to the host (G2H) or to a child-VM (H2G). The current logic
>> > > > > > trivially assumes that G2H is only relevant for CID <= 2 because these
>> > > > > > target the hypervisor.  However, in environments like Nitro
>> > > > > > Enclaves, an
>> > > > > > instance that hosts vhost_vsock powered VMs may still want to
>> > > > > > communicate
>> > > > > > to Enclaves that are reachable at higher CIDs through virtio-vsock-pci.
>> > > > > >
>> > > > > > That means that for CID > 2, we really want an overlay. By default, all
>> > > > > > CIDs are owned by the hypervisor. But if vhost registers a CID,
>> > > > > > it takes
>> > > > > > precedence.  Implement that logic. Vhost already knows which CIDs it
>> > > > > > supports anyway.
>> > > > > >
>> > > > > > With this logic, I can run a Nitro Enclave as well as a nested VM with
>> > > > > > vhost-vsock support in parallel, with the parent instance able to
>> > > > > > communicate to both simultaneously.
>> > > > > I honestly don't understand why VMADDR_FLAG_TO_HOST (added
>> > > > > specifically for Nitro IIRC) isn't enough for this scenario and we
>> > > > > have to add this change.  Can you elaborate a bit more about the
>> > > > > relationship between this change and VMADDR_FLAG_TO_HOST we added?
>> > >
>> > > The main problem I have with VMADDR_FLAG_TO_HOST for connect() is that it
>> > > punts the complexity to the user. Instead of a single CID address space, you
>> > > now effectively create 2 spaces: One for TO_HOST (needs a flag) and one for
>> > > TO_GUEST (no flag). But every user space tool needs to learn about this
>> > > flag. That may work for super special-case applications. But propagating
>> > > that all the way into socat, iperf, etc etc? It's just creating friction.
>> > >
>> > > IMHO the most natural experience is to have a single CID space, potentially
>> > > manually segmented by launching VMs of one kind within a certain range.
>> > >
>> > > At the end of the day, the host vs guest problem is super similar to a
>> > > routing table.
>> > If this is what's desired, some bits could be stolen from the CID
>> > to specify the destination type. Would that address the issue?
>> > Just a thought.

Nope :-( VMMs some times use random u32 to set CID (avoiding reserved 
ones like 0, 1, 2, 3, U32_MAX). We also documented them in virtio spec:
https://docs.oasis-open.org/virtio/virtio/v1.3/csd01/virtio-v1.3-csd01.html#x1-4780004

>>
>>
>> If we had thought of this from the beginning, yes. But now that everyone
>> thinks CID (guest) == CID (host), I believe this is no longer feasible.

We added a new flag (VMADDR_FLAG_TO_HOST) in struct sockaddr_vm exactly 
for that use case around 6 years ago [1], but not much work was done to 
propagate that change to userspace tools.

IMO that should be improved, and if for Nitro this is useful, you should 
try to help on that effort.

Stefano

[1] 
https://lore.kernel.org/netdev/20201214161122.37717-1-andraprs@amazon.com/

>>
>>
>> Alex
>
>
>I don't really insist, but just to point out that if we wanted to, we
>could map multiple CIDs to host. Anyway.


