Return-Path: <kvm+bounces-72202-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wXaILMXwoWkNxgQAu9opvQ
	(envelope-from <kvm+bounces-72202-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 20:30:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BA3D1BCCCA
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 20:30:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A6CDC306340C
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 19:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 345F036A017;
	Fri, 27 Feb 2026 19:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="qYFS1EiG";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BSzjpY3l"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978AF35B654;
	Fri, 27 Feb 2026 19:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772220605; cv=none; b=X8mCw6E+u/u5ERbrDWHpX+RwNX+w90cwEwp9hZ+hUjUPLdfDjhWH1+uPVW0zH6J5OisHHiGfN0CVjU6qFo3nlqOnqHKmen7DDyP4eloXf1GkmVBNtrPkffd/d4iV0m7ARdrb4eMdRjJMZX3seLwSb6yr+X9iN3GgUC6ldpOpZGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772220605; c=relaxed/simple;
	bh=s1gTp1jZw16CUyo8V+a1DUpGAcUwBfdcaAPRIjUBVnE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o1TIfgN4aHyqv3DwOS2yW41fUpKwSj9d2CG4HO6lMCuaFoUpDTY9FgdNfVAkH+9P3kUma18Bddo4HbzcW+aN1LFNTd7r9aMi89S4hG1YQ5e63icTULxQtnn0oUCafUQS8MVtNSysktrvRiHdx7Qa1a3OGNYm8K2OXG0WoGIY5d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=qYFS1EiG; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=BSzjpY3l; arc=none smtp.client-ip=202.12.124.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 29E9E7A011E;
	Fri, 27 Feb 2026 14:30:01 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 27 Feb 2026 14:30:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772220600;
	 x=1772307000; bh=hghdzLvxEFhVmI/9kLmg5WuFIjmbso+tE5FO2QLH96g=; b=
	qYFS1EiG6A7MpOu0Bt5e15wUtQamtscyW+iDYZmWVwLfkx5QxzEj3zuOAvES26KZ
	Yo4pFUymf2xmR0kqLSIMpKCg+8CdjNg8hOReEnaiZUYx8XizJWrDX+/RBU8C2NO4
	bZ+/kcQxBUhXemclADgrKfnGKZTGPzgf5QJh53mcQ5BSXIfuBtx0V9PAvnXeMgNU
	zqWltYuzvRcy75MFyQKky5P30sh8fZ9brG9csnmjV7ecxw8XEJRM5lZ4IqT4woGi
	XIt0/Wr2FJZdH429j/W2Txx0yCzPt58HB6lO2/Y2gk62VkQiu4mlkxjqb9cj2J02
	do08CPonRVCPDetj/pgYJg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772220600; x=
	1772307000; bh=hghdzLvxEFhVmI/9kLmg5WuFIjmbso+tE5FO2QLH96g=; b=B
	SzjpY3l4iZRKLMGzZjIJgLDkjdPmyTQHSxFu9VkgRV5x3hUE0u5JsZ6NIaha4GSk
	PIBiVXWCTnYkoRi2TIfGhCBLbA1lnltCQkXk8sEyQ6GZwfpRuGI+MJjjbw3sANvp
	yJMIz1VoUiKxTVLzmMUHnQ4MFZ+bVkLfgAhkWUJ8NjSFa+NNfex1PqFo4aPjYJUn
	eX8wGfI2Wj/Up0TLdAj/RnFS1SMDP/q5CHuRy5Wc4t6kzHUBPjKIYOycvAM9/nzm
	Fklt9gzClkp84bYnsAiJ3YRbbFl1LBBb68kpm1SOGWsTkTZ0F0hWANWgMmFMwbTr
	1K5gRc5mH6PN7LlgDtvUw==
X-ME-Sender: <xms:uPChaZqvicvOZ66pdHjGOSTMzWRXNWBNAYCRCHpmsMpzpZRbGTVKTg>
    <xme:uPChaUl6WM_y-cjA-sDBXpHDqUCV7Yjajsmx8B02sGwgkaqrUcWjvcDHB5CAOqUXr
    y4aNpo49Y5ZeDD8paAykHFnTR7dJqqavpsiJ4R03i_We5kM0gfHJQ>
X-ME-Received: <xmr:uPChaRzvDibvDe94R6uEdGYs4pmBDnuwuUxS53KC-ekIfDbhCQ2NQg327J8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhfogggtgfesthejre
    dtredtvdenucfhrhhomheptehlvgigucghihhllhhirghmshhonhcuoegrlhgvgiesshhh
    rgiisghothdrohhrgheqnecuggftrfgrthhtvghrnhepvdekfeejkedvudfhudfhteekud
    fgudeiteetvdeukedvheetvdekgfdugeevueeunecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhgpdhnsg
    gprhgtphhtthhopeehpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehmrhgrthhh
    ohhrsehlihhnuhigrdhmihgtrhhoshhofhhtrdgtohhmpdhrtghpthhtohepkhhvmhesvh
    hgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopeifvghirdhlihhusehkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehlihhnuhigqdhhhihpvghrvhesvhhgvghrrdhkvghrnh
    gvlhdrohhrghdprhgtphhtthhopegrlhgvgiesshhhrgiisghothdrohhrgh
X-ME-Proxy: <xmx:uPChaU84cEwcYPU4jB-qBOADuKUzCkKtIjDWIJA1Ejf9dnR1jpR_tQ>
    <xmx:uPChaVJO9hGcCrep2P89mN9DzFEHr845ziZRN-1vkJ5zleIPq_b4gg>
    <xmx:uPChaad0wiOWE4dQMYlbspGyd-790pnnawdf_rdTC_a35f-0KSZqPA>
    <xmx:uPChaU-EA7HHmMAwMvD6jwXGFh46wX0b8V0jEN9UIJwWKLy91_uBuw>
    <xmx:uPChaXZz631LLdH7Y3rrGIRiXg6DJ3M5ywMcZQT0gm_O4pu0Htte7v4b>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:29:59 -0500 (EST)
Date: Fri, 27 Feb 2026 12:29:57 -0700
From: Alex Williamson <alex@shazbot.org>
To: Mukesh R <mrathor@linux.microsoft.com>
Cc: kvm@vger.kernel.org, "wei.liu@kernel.org" <wei.liu@kernel.org>,
 "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
 alex@shazbot.org
Subject: Re: VFIO support on hyperv (vfio_pci_core_ioctl())
Message-ID: <20260227122957.1e555024@shazbot.org>
In-Reply-To: <1f50dae2-ec4a-7914-a14f-2ada803eb0e3@linux.microsoft.com>
References: <1f50dae2-ec4a-7914-a14f-2ada803eb0e3@linux.microsoft.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72202-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,shazbot.org:mid,shazbot.org:dkim,messagingengine.com:dkim]
X-Rspamd-Queue-Id: 2BA3D1BCCCA
X-Rspamd-Action: no action

On Wed, 25 Feb 2026 14:04:49 -0800
Mukesh R <mrathor@linux.microsoft.com> wrote:

> Hi Alex et al:
> 
> I've been looking at making pci passthru irq setup/remap work on hyperv
> for the latest (6.19) version using vfio core. Unfortunately, it's just
> not fitting well because in case of hyperv the irq remap is done by
> the hypervisor. Specifically, for a robust and proper solution, we need
> to override vfio_pci_set_msi_trigger(). As such, for the best way forward
> I am trying to figure how much flexibility there is to modify
> vfio_pci_intrs.c with "if (running_on_hyperv())" branches (putting hyperv
> code in separate file).
> 
> If none, then the alternative would be to create vfio-hyperv.c with
> vfio_device_ops.ioctl = hyperv_vfio_pci_core_ioctl(). But, then I'd
> be replicating code for other sub ioctls like vfio_pci_ioctl_get_info(),
> vfio_pci_ioctl_get_irq_info(), etc. Would it be acceptable to make them
> non static in this case?
> 
> Please let me know your thoughts or if you have other suggestions.

Hi Mukesh,

In general, littering the code with running_on_hyperv() tests is not
acceptable, but the presented alternative isn't really accurate either.
If you want to substitute in your own ioctl callback, you can still
call vfio_pci_core_ioctl() for all the unhandled ioctls, without extra
exports.  We can also look at whether vfio_pci_device_ops could have a
callback specifically addressing an alternative set_msi_trigger
handler.  Thanks,

Alex

