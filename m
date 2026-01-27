Return-Path: <kvm+bounces-69261-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sI4UFt3+eGmOuQEAu9opvQ
	(envelope-from <kvm+bounces-69261-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 19:07:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 053A498CA6
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 19:07:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6E075306376A
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 18:05:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2D0B324B2A;
	Tue, 27 Jan 2026 18:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="tLT1Sit3";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="QYHRbmAH"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18232324B32;
	Tue, 27 Jan 2026 18:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769537157; cv=none; b=afiir2WyR23UY6GOQ2VUEnEfoMjc4RGgm6Cc0q98NMTsxccKac3ez1H0FT76ZWq/UkiifYWOrnwZuy+oIS6WKyfCqf3RFCaGvfGiKnJ5RHpTuPoWIaINKclhnWOgW/xWQbNG5Tfi6Ox2eof3w5OuwxB8tpGcq0Fvy3BpidpWEtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769537157; c=relaxed/simple;
	bh=qQBHbMAtACiHlSAGEXrv4cSeaKK6XQec3OCx60Ekrdc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=FTI6Ho+l35gVjB5/daXFljEYeJ+0kxS95Na1Gtk2T5ODFEy7JsIo/NnV9sjXEG6anPbC9I6DIPVN7ZYGDOKMRnYeBeiAzpC8zFBmrkIY3m3Ctp17GZsnKLP7LHcMsCpSMsSt2XJ78hjqHAuO3/MoE6huFtr51lazGKUEMN3W7u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=tLT1Sit3; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=QYHRbmAH; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 27B317A0085;
	Tue, 27 Jan 2026 13:05:53 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Tue, 27 Jan 2026 13:05:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm2; t=1769537153; x=1769623553; bh=6O
	Exzmcysc+iGcf9EfAPhU7GBejnwiiLO8gSIBbR9Vg=; b=tLT1Sit3+zNmCfpQt1
	vNZ7/paVbCRWhC0XLQ2fozFF5a98J8Gum21zIiqJlC7YFyar8hPjfv5l6lxq9Hny
	dCwMpGCeNcU7OXubbQMRXm/rC1tumUkY57cMurCXXA+/2K28gW8vaaxNuiQR/QxG
	VO3ItbF8sgrh8MAPU/30L8ieNjm7yy73UlcloFsAxiTNcLnNS3x3KBsussVjbgCk
	X2yreSbCPapDF89pbHh01SOzercwX2V40LJg+0U9YalSwEGD6arW/XhF5ZFYCrar
	hcyv+xwhyqBt6yw+fdTx7+risFzqlsB5Z8z5siq6nn1xlQkZg0BzQm0mfmzPHexu
	grag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1769537153; x=1769623553; bh=6OExzmcysc+iGcf9EfAPhU7GBejn
	wiiLO8gSIBbR9Vg=; b=QYHRbmAHdXqpS1bloPr9IPy965o6nYurYikZaO6m6Vpj
	pr3BGCNWmEwEL6ES2rY6mrMbpuMUtgNokyH5wEjOcuJy38zXg/PEjqg/UDF0pUp9
	0e8zo8CrAjYIfvClkv7lUfmnjfV8KMYuT1kLvYbRkenWx3xIOhgJmGz7mALwl3ZB
	obRyXT5gNV5VysXtR3b97JWJnFIQheGnuwK1/6P61Kl8lrthCylRL9u3zSK7ykvz
	NxyZ+dlsFxVKEZHCt5bdAgpHqZLGKssEV/3f05MreWMkDoPLtvspwe/okac14+kZ
	PLrVOnl+KdltHhc7n2zIb/sKuSMaTphR24Mg0SzwTw==
X-ME-Sender: <xms:gP54abXS1gsdFhoHs1PWSoliMt5vJMXg7Q6uLjJo2pKnzE-DWYkO6Q>
    <xme:gP54aVF_Q8ZfPm4dWhV-QS8MHfkM3pWkyE6JEGhHtq7Db0lI-DRy9X2nK9A4yYuDW
    4FL_q0QwVzPEmjdiDk5YZ6hhOay__ruKaD43BIj0J4iMMk0m5iGojo>
X-ME-Received: <xmr:gP54aXe44eB2kLXRDOycnv8Obw7SAjrR51jIoCeup4gWXcc0lURoNju9-fM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieduudeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicuhghi
    lhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrghtth
    gvrhhnpeetteelieeffefhffevteeufeektedulefgueekleeiueelveduheffhefhkeeg
    veenucffohhmrghinhepghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhgpdhn
    sggprhgtphhtthhopeehpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehtohhrvh
    grlhgusheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheplhhi
    nhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkh
    hvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlvghonheskhgvrhhn
    vghlrdhorhhgpdhrtghpthhtohepjhhgghesiihivghpvgdrtggr
X-ME-Proxy: <xmx:gP54aWLOhs_wibp7JNQSHchubcGgMb_wCXCqKT_jrYDqfGCOA2haWQ>
    <xmx:gP54acEzYw49hQJc0yqX-3I6aQSNbfUC59mQx6-Oqt6WRtH5wzJVUA>
    <xmx:gP54aZCwGUxvAnmphFG-SLiyODWFNSt2TfZLYohSXqR02zkbg9SK4Q>
    <xmx:gP54af_nFGln9y-GkrZZY8uMIaaucnuCm_Eoe0mD6V3IQ8uAZYbv9g>
    <xmx:gf54aQQsmXnx2mkQTuhd26Gmin8YODLBRpDmal_VAsGtTpQk6K05FkG6>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 27 Jan 2026 13:05:51 -0500 (EST)
Date: Tue, 27 Jan 2026 11:05:50 -0700
From: Alex Williamson <alex@shazbot.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Leon Romanovsky
 <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Subject: [GIT PULL] VFIO fixes for v6.19-rc8
Message-ID: <20260127110550.6e5dd005@shazbot.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm2,messagingengine.com:s=fm2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-69261-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[shazbot.org:mid,shazbot.org:dkim,messagingengine.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 053A498CA6
X-Rspamd-Action: no action

Hi Linus,

The following changes since commit 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7:

  Linux 6.19-rc6 (2026-01-18 15:42:45 -0800)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.19-rc8

for you to fetch changes up to 61ceaf236115f20f4fdd7cf60f883ada1063349a:

  vfio: Prevent from pinned DMABUF importers to attach to VFIO DMABUF (2026-01-23 08:47:48 -0700)

----------------------------------------------------------------
VFIO fix for v6.19-rc8

 - Fix a gap in the initial VFIO DMABUF implementation where it's
   required to explicitly implement a failing pin callback to prevent
   pinned importers that cannot properly support move_notify.
   (Leon Romanovsky)

----------------------------------------------------------------
Leon Romanovsky (1):
      vfio: Prevent from pinned DMABUF importers to attach to VFIO DMABUF

 drivers/vfio/pci/vfio_pci_dmabuf.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

