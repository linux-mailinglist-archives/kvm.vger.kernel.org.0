Return-Path: <kvm+bounces-46305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7FEBAB4DEA
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:19:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4145B8C1851
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 08:18:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 509EF201262;
	Tue, 13 May 2025 08:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TYXETnoj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1072AEE1
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 08:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747124350; cv=none; b=lCFrFxxszjgBec6O2r2xjgGZ/wP/Wc584fOsuLgrZmpprWMocDPqKGVGOCowLgqqnVBDK6QVs1ibrA1SFCdvxkxskWtOo0NfvsowS8TVyMwSx+0/G5htzpsbqW7J90fseqCDgqVMDYlasSji95gV0an3tFlEdgCRKwLE8RXClUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747124350; c=relaxed/simple;
	bh=Su6QEfqVQhlYWCGByUc3CjzhnmYrhcigEMloWS5yMs8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Q78KMXdeJW27kS1zSPNshEgD1WxGXt/iY9iN6kvyIU0c1po0Q2kHmYAK5GuniYsAF+5apeT3E6nPzVkKOmrziZqY0pJ7nBB20lZyy/urlmdKmWM8FfNSW2BM3hQvqihU75rVJYEXx59u395y7bIGKBEVtD4O8HHyb16/+76yJK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TYXETnoj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747124347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cvwaWtricW1FLg5RbIrhWuiuXIjHoaZjwfgC/DtHd8o=;
	b=TYXETnojCn4XxORgq9eWplenz47EHTj7jomjEDj49lJ8Mu69ZaZFjxPmXIjnKosJWovvhg
	pu+/4EC2fsp/MGNpPgKIH9VgYW0NqrvJezU6c+dn+X12X02Q1vyIFk05256a7+SD9EfY6M
	Z4MWz3QRvOat/c8EO/RoxVRzyVsVoh4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-113-8v6VDVqdObG3jXi-EDCLSg-1; Tue,
 13 May 2025 04:19:02 -0400
X-MC-Unique: 8v6VDVqdObG3jXi-EDCLSg-1
X-Mimecast-MFC-AGG-ID: 8v6VDVqdObG3jXi-EDCLSg_1747124340
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 29F15195396A;
	Tue, 13 May 2025 08:18:59 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.27])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D641C19560BC;
	Tue, 13 May 2025 08:18:57 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 50D3521E66C2; Tue, 13 May 2025 10:18:55 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Mark Cave-Ayland <mark.caveayland@nutanix.com>
Cc: Daniel P. =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>,  Peter
 Maydell
 <peter.maydell@linaro.org>,  Thomas Huth <thuth@redhat.com>,  Zhao Liu
 <zhao1.liu@intel.com>,  Xiaoyao Li <xiaoyao.li@intel.com>,  Philippe
 =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Paolo Bonzini
 <pbonzini@redhat.com>,
  qemu-devel@nongnu.org,  Richard Henderson <richard.henderson@linaro.org>,
  kvm@vger.kernel.org,  Gerd Hoffmann <kraxel@redhat.com>,  Laurent Vivier
 <lvivier@redhat.com>,  Jiaxun Yang <jiaxun.yang@flygoat.com>,  Yi Liu
 <yi.l.liu@intel.com>,  "Michael S. Tsirkin" <mst@redhat.com>,  Eduardo
 Habkost <eduardo@habkost.net>,  Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>,  Alistair Francis
 <alistair.francis@wdc.com>,  Daniel Henrique Barboza
 <dbarboza@ventanamicro.com>,  Marcelo Tosatti <mtosatti@redhat.com>,
  qemu-riscv@nongnu.org,  Weiwei Li <liwei1518@gmail.com>,  Amit Shah
 <amit@kernel.org>,  Yanan Wang <wangyanan55@huawei.com>,  Helge Deller
 <deller@gmx.de>,  Palmer Dabbelt <palmer@dabbelt.com>,  Ani Sinha
 <anisinha@redhat.com>,  Igor Mammedov <imammedo@redhat.com>,  Fabiano
 Rosas <farosas@suse.de>,  Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
  =?utf-8?Q?Cl=C3=A9ment?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
  qemu-arm@nongnu.org,  =?utf-8?Q?Marc-Andr=C3=A9?= Lureau
 <marcandre.lureau@redhat.com>,
  Huacai Chen <chenhuacai@kernel.org>,  Jason Wang <jasowang@redhat.com>
Subject: Re: How to mark internal properties
In-Reply-To: <eedd1fa2-5856-41b8-8e6b-38bd5c98ce8f@nutanix.com> (Mark
	Cave-Ayland's message of "Mon, 12 May 2025 15:48:34 +0100")
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-13-philmd@linaro.org>
	<23260c74-01ba-45bc-bf2f-b3e19c28ec8a@intel.com>
	<aB2vjuT07EuO6JSQ@intel.com>
	<2f526570-7ab0-479c-967c-b3f95f9f19e3@redhat.com>
	<CAFEAcA-kuHvxjuV_cMh-Px3C-k2Gd51jFqhwndO52vm++M_jAA@mail.gmail.com>
	<aCG6MuDLrQpoTqpg@redhat.com> <87jz6mqeu5.fsf@pond.sub.org>
	<eedd1fa2-5856-41b8-8e6b-38bd5c98ce8f@nutanix.com>
Date: Tue, 13 May 2025 10:18:55 +0200
Message-ID: <87ecwshqj4.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Mark Cave-Ayland <mark.caveayland@nutanix.com> writes:

> On a related note this also brings us back to the discussion as to the relationship between qdev and QOM: at one point I was under the impression that qdev properties were simply QOM properties that were exposed externally, i.e on the commmand line for use with -device.
>
> Can you provide an update on what the current thinking is in this area, in particular re: scoping of qdev vs QOM properties?

qdev is a leaky layer above QOM.

qdev properties are also QOM properties.

All device properties are exposed externally.

We use device properties for:

* Letting users configure pluggable devices, with -device or device_add

* Letting code configure onboard devices

  For onboard devices that are also pluggable, everything exposed to
  code is also exposed externally.  This might be a mistake in places.

* Letting the machine versioning machinery adjust device configuration

  Some properties are meant to be used just for this.  They're exposed
  externally regardless, which is a mistake.


