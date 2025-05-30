Return-Path: <kvm+bounces-48101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 34A37AC8D53
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 14:08:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1899A7A31CE
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 12:07:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D063D22AE76;
	Fri, 30 May 2025 12:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FirrEwr3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AC521CA1C
	for <kvm@vger.kernel.org>; Fri, 30 May 2025 12:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748606930; cv=none; b=gWjGprqsJSfcYNQj5RhXweCoN56BlgGIIKv6NiQCXP8VOmwbc+aoS0+BHvb7zkolJzTexptWE0VxMmyzKM+NJNoDdxr+sl5mGw7+ajQ6ycJLMu1CK3AuWhNG/71xcSF9GuwO5lYY1AWzLblxu46P2iHJp6L3Izt6cyvbQ5greko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748606930; c=relaxed/simple;
	bh=yB8rvqcq/8FLCbMqgGu3oexfvTI5Y+SKDZ5H96fAK18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A62or2ArwkeptHQWSDsutA1K/ZXfzqeCvb2EQ7CaKJrfm/Djo+keMaTRm3z22qzQQeDZHQszkvSQcUE2AgCW6ukSD7y2SuDEszZ9B86dnjEOvq5Fp/9tin9CT35XdJdfUM9ZZJcjc+dxdgve0HqPNdYYeAPDjjKhZu5TPVx1X0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FirrEwr3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748606927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sU0N6WlJ5TO/u4ut1lrXrvR6Inh+h+at/x1N2MEci8A=;
	b=FirrEwr3MiEeMFiiNYVxlhMksYDw1836pmlmOMwRyKpPHMvSGliacg24FtA2WRxuuHet8V
	IKu3q7svD36NzqVDSzCAxcyoLjWGpub2O4Jc2CuJexvJGG/MpXhh0fCiUOjpysDkQ9rXzo
	9HwOy5rhIfe4fPIl8WFoY2LD5sEyG50=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-13-7JU8xvgmOYmmbcElxZx7FA-1; Fri,
 30 May 2025 08:08:44 -0400
X-MC-Unique: 7JU8xvgmOYmmbcElxZx7FA-1
X-Mimecast-MFC-AGG-ID: 7JU8xvgmOYmmbcElxZx7FA_1748606921
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4F0DA1800258;
	Fri, 30 May 2025 12:08:40 +0000 (UTC)
Received: from angien.pipo.sk (unknown [10.44.22.3])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DCC621954185;
	Fri, 30 May 2025 12:08:28 +0000 (UTC)
Date: Fri, 30 May 2025 14:08:25 +0200
From: Peter Krempa <pkrempa@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	qemu-devel@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org, Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>, Yi Liu <yi.l.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-riscv@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>, Yanan Wang <wangyanan55@huawei.com>,
	Helge Deller <deller@gmx.de>, Palmer Dabbelt <palmer@dabbelt.com>,
	Ani Sinha <anisinha@redhat.com>, Fabiano Rosas <farosas@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?iso-8859-1?Q?Cl=E9ment?= Mathieu --Drif <clement.mathieu--drif@eviden.com>,
	qemu-arm@nongnu.org,
	=?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>, devel@lists.libvirt.org
Subject: Re: [PATCH v4 00/27] hw/i386/pc: Remove deprecated 2.6 and 2.7 PC
 machines
Message-ID: <aDmfuVLXmfvJB0tX@angien.pipo.sk>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250513132338.4089736b@imammedo.users.ipa.redhat.com>
 <20250530073524-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250530073524-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Fri, May 30, 2025 at 07:35:38 -0400, Michael S. Tsirkin via Devel wrote:
> On Tue, May 13, 2025 at 01:23:38PM +0200, Igor Mammedov wrote:
> > On Thu,  8 May 2025 15:35:23 +0200
> > Philippe Mathieu-Daudé <philmd@linaro.org> wrote:
> > 
> > > Since v3:
> > > - Addressed Thomas and Zhao review comments
> > > - Rename fw_cfg_init_mem_[no]dma() helpers
> > > - Remove unused CPU properties
> > > - Remove {multi,linux}boot.bin
> > > - Added R-b tags
> > > 
> > > Since v2:
> > > - Addressed Mark review comments and added his R-b tags
> > > 
> > > The versioned 'pc' and 'q35' machines up to 2.12 been marked
> > > as deprecated two releases ago, and are older than 6 years,
> > > so according to our support policy we can remove them.
> > > 
> > > This series only includes the 2.6 and 2.7 machines removal,
> > > as it is a big enough number of LoC removed. Rest will
> > > follow.
> > 
> > CCing libvirt folks
> > 
> > series removes some properties that has been used as compat
> > knobs with 2.6/2.7 machine types that are being removed.
> > 
> > However libvirt might still use them,
> > please check if being removed properties are safe to remove
> > as is | should be deprecated 1st | should be left alone
> > from an immediate user perspective.
> 
> Anyone on libvirt side can confirm please?

Sorry, it was a bit of a chore to go through the patches.

IIUC the following list is to be reviewed:

 DEFINE_PROP_BOOL("x-buggy-eim", IntelIOMMUState, buggy_eim, false)
 DEFINE_PROP_BOOL("x-ignore-backend-features", VirtIOPCIProxy,
 DEFINE_PROP_BOOL("migrate", PCSpkState, migrate,  true),
 DEFINE_PROP_UINT8("version", IOAPICCommonState, version, IOAPIC_VER_DEF)
 DEFINE_PROP_BIT64("emergency-write", VirtIOSerial, host_features
 DEFINE_PROP_BOOL("format_transport_address", VirtIOMMIOProxy,
 DEFINE_PROP_BOOL("legacy-instance-id", APICCommonState, legacy_instance_id,

None of the above are exposed by libvirt to the user nor used by libvirt
internally.

 DEFINE_PROP_BIT("page-per-vq", VirtIOPCIProxy, flags

This property is exposed to users for all virtio devices as
'page_per_vq' property:a

https://www.libvirt.org/formatdomain.html#virtio-related-options

It is an optional property and not formatted to qemu unless explicitly
requested by the user. Removing it thus should be fine without the need
to change anything in libvirt

The rest are CPU properties

 DEFINE_PROP_BOOL("cpuid-0xb", X86CPU, enable_cpuid_0xb, true),
 DEFINE_PROP_BOOL("fill-mtrr-mask", X86CPU, fill_mtrr_mask, true),
 DEFINE_PROP_BOOL("full-cpuid-auto-level", X86CPU, full_cpuid_auto_level, true),

which appear in our cpu test data but I'm not 100% sure how they are
used. Jirka, can you please comment?

Finally there's

 DEFINE_PROP_BOOL("l3-cache", X86CPU, enable_l3_cache, true),

which is exposed to the users via cache mode setting of cpu:

https://www.libvirt.org/formatdomain.html#cpu-model-and-topology

look for 'cache'.

Thus from libvirt's side 'page-per-vq' and 'l3-cache' will likely require
deprecation period. The rest except for CPU is fine to remove without
anything at least from our PoV.

Jirka will hopefully clarify the Cpu property side.


