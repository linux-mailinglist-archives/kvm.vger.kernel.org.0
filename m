Return-Path: <kvm+bounces-26505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58A5D975288
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 14:36:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8ECB8B29290
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 12:36:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82F34187FEB;
	Wed, 11 Sep 2024 12:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WU5P2Aen"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2659917C230
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 12:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726058052; cv=none; b=VLCxA3nBsi2hPZoYRI9MGX0yUeREUAE9pWYv64z8kanZyAmCFODL7eypAiOTJcPmYwHaE0WhTWVRWVDsVAOCp6Txk0gtbmUnYp3moYgZwGqfp5ZSUfxankU/MQgI3ONaSWZO7DLYgsdtAW6HSaymqgUWNJoOEaml/kTu3/Yhi5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726058052; c=relaxed/simple;
	bh=lZcMLOSNbHtpEXUK0+YoGbJ5Ye7mAOyWaS+7dXwJPRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kq9xxd+Fda/TgawEahFAjui2Vo0PVybdz3jEGH1KcYYQck2UCdHb6FHnCWEUbDXe/9IkSJnf4RbTgMPVGIWg/n9cT3n2nW1DuA1bCZjcrDq+bwMru+y71wrIFJlc+8p2gbcVZF+M0ALJCGwDrx3WaO9jHMDRXj4fcH5fqqqnW8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WU5P2Aen; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726058049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zwWiCWwJ3dGN6gxSk3Yzd9j0+zvFL+3PfRinwilJ57Y=;
	b=WU5P2Aen2p4HZxJPmEYcAa21k1E1BJD9DHhDLLBnF1jo8MDGf6vQS8o8rvGJHJDQ+TLgu7
	dMIBnh0PnzSLUrJA2v2tYp1xqWnbHSHyGiggrHQXnDe9pcsqHbRPKrP+QP8VqY/+LVzq6N
	DB7VOGFpYXZwpgb/lLxmKK1XS1Gbth8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-644-WpP9fjYZPdaDAYx7zZo4qg-1; Wed,
 11 Sep 2024 08:34:08 -0400
X-MC-Unique: WpP9fjYZPdaDAYx7zZo4qg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C090E1958B1E;
	Wed, 11 Sep 2024 12:33:59 +0000 (UTC)
Received: from redhat.com (unknown [10.2.16.98])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 874C530001A1;
	Wed, 11 Sep 2024 12:33:39 +0000 (UTC)
Date: Wed, 11 Sep 2024 07:33:36 -0500
From: Eric Blake <eblake@redhat.com>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: qemu-devel@nongnu.org, Zhao Liu <zhao1.liu@intel.com>, 
	"Richard W.M. Jones" <rjones@redhat.com>, Joel Stanley <joel@jms.id.au>, Kevin Wolf <kwolf@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, Corey Minyard <minyard@acm.org>, 
	Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>, Keith Busch <kbusch@kernel.org>, 
	WANG Xuerui <git@xen0n.name>, Hyman Huang <yong.huang@smartx.com>, 
	Stefan Berger <stefanb@linux.vnet.ibm.com>, Michael Rolnik <mrolnik@gmail.com>, 
	Alistair Francis <alistair.francis@wdc.com>, =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>, 
	Markus Armbruster <armbru@redhat.com>, Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, qemu-riscv@nongnu.org, Ani Sinha <anisinha@redhat.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Jesper Devantier <foss@defmacro.it>, 
	Laurent Vivier <laurent@vivier.eu>, Peter Maydell <peter.maydell@linaro.org>, 
	Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org, 
	Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>, Richard Henderson <richard.henderson@linaro.org>, 
	Fam Zheng <fam@euphon.net>, qemu-s390x@nongnu.org, Hanna Reitz <hreitz@redhat.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Eduardo Habkost <eduardo@habkost.net>, 
	Laurent Vivier <lvivier@redhat.com>, Rob Herring <robh@kernel.org>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, qemu-block@nongnu.org, 
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>, qemu-ppc@nongnu.org, 
	Daniel Henrique Barboza <danielhb413@gmail.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Harsh Prateek Bora <harshpb@linux.ibm.com>, Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>, 
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Fabiano Rosas <farosas@suse.de>, Helge Deller <deller@gmx.de>, 
	Dmitry Fleytman <dmitry.fleytman@gmail.com>, Daniel Henrique Barboza <dbarboza@ventanamicro.com>, 
	Akihiko Odaki <akihiko.odaki@daynix.com>, Marcelo Tosatti <mtosatti@redhat.com>, 
	David Gibson <david@gibson.dropbear.id.au>, Aurelien Jarno <aurelien@aurel32.net>, 
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, Yanan Wang <wangyanan55@huawei.com>, 
	Peter Xu <peterx@redhat.com>, Bin Meng <bmeng.cn@gmail.com>, Weiwei Li <liwei1518@gmail.com>, 
	Klaus Jensen <its@irrelevant.dk>, Jean-Christophe Dubois <jcd@tribudubois.net>, 
	Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH 01/39] docs/spin: replace assert(0) with
 g_assert_not_reached()
Message-ID: <zkyoryho5alnyirnl7ulvh5y6tkty6koccgeygmve42uml7glu@37rkdodtlx4f>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
 <20240910221606.1817478-2-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910221606.1817478-2-pierrick.bouvier@linaro.org>
User-Agent: NeoMutt/20240425
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Sep 10, 2024 at 03:15:28PM GMT, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---

A general suggestion for the entire series: please use a commit
message that explains why this is a good idea.  Even something as
boiler-plate as "refer to commit XXX for rationale" that can be
copy-pasted into all the other commits is better than nothing,
although a self-contained message is best.  Maybe:

This patch is part of a series that moves towards a consistent use of
g_assert_not_reached() rather than an ad hoc mix of different
assertion mechanisms.

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.
Virtualization:  qemu.org | libguestfs.org


