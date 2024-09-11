Return-Path: <kvm+bounces-26506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 72D5097529E
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 14:38:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3803E28A934
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 12:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47630198A21;
	Wed, 11 Sep 2024 12:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EiRMEf7G"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4020188A14
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 12:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726058258; cv=none; b=Gm1Q9aItUUsYcJi6s47mRO3Idya/+53s0ad4lcGDRrWaVEv+m2v7T4eflpfiIYI2dwpuEwMw7l9YNpFeuR4p5RaAkGMCxsf+qQnsvtRnS7eT7s3wkzRY9vwNqGoO/YlVY7Q6IIqNYk1wPRtToz2iFi7dnE80dU2XBugtfayIpcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726058258; c=relaxed/simple;
	bh=UbZ1lUlQ70GIatJ9Od4Ua1Y53oKXUgTquqsOxqVIL2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pb2yE+8U3iwEjvgYQ4n7g3T1n3q6aHVjWY8hHyYD6UxEYjDempHbsLj0gxJ2SIi+4BMMCZTXYhD1GVn+MuD0MXJSlEbmN/w7O5NNOlmu/iV6N2nNi96FMLkq6M3GWlk/0hWfCcvkdpDj8Q6BIWadGGG1o7mzjplCU0YOhb/K5qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EiRMEf7G; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726058255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2yyoUHl0RktlwtpBgJrkB7WrBtx0gjcCkcB5aXQqSHw=;
	b=EiRMEf7GzRTVD4iiHNueLZ29Eq2R+odQR6EXVqAXz/0Egc6S8gVioap1iRtTzl6MRbqB1f
	C+J+RTiyZOwy4uK537djNoNN9kMPf1/r+MdE0WttyK/tCEVjk5tybsdc+CFHwXBEQc+pnv
	PFnw5dtPXBWHdMHCMk7ptsjHEoExthw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-441-jaSzpHeWNrut-meJROLWwg-1; Wed,
 11 Sep 2024 08:37:32 -0400
X-MC-Unique: jaSzpHeWNrut-meJROLWwg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C874D19560BE;
	Wed, 11 Sep 2024 12:37:23 +0000 (UTC)
Received: from redhat.com (unknown [10.2.16.98])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5E27C19560A3;
	Wed, 11 Sep 2024 12:37:05 +0000 (UTC)
Date: Wed, 11 Sep 2024 07:37:02 -0500
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
Message-ID: <bwo43ms2wi6vbeqhlc7qjwmw5jyt2btxvpph3lqn7tfol4srjf@77yusngzs6wh>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
 <20240910221606.1817478-2-pierrick.bouvier@linaro.org>
 <zkyoryho5alnyirnl7ulvh5y6tkty6koccgeygmve42uml7glu@37rkdodtlx4f>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <zkyoryho5alnyirnl7ulvh5y6tkty6koccgeygmve42uml7glu@37rkdodtlx4f>
User-Agent: NeoMutt/20240425
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Wed, Sep 11, 2024 at 07:33:59AM GMT, Eric Blake wrote:
> On Tue, Sep 10, 2024 at 03:15:28PM GMT, Pierrick Bouvier wrote:
> > Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> > ---
> 
> A general suggestion for the entire series: please use a commit
> message that explains why this is a good idea.  Even something as
> boiler-plate as "refer to commit XXX for rationale" that can be
> copy-pasted into all the other commits is better than nothing,
> although a self-contained message is best.  Maybe:
> 
> This patch is part of a series that moves towards a consistent use of
> g_assert_not_reached() rather than an ad hoc mix of different
> assertion mechanisms.

Or summarize your cover letter:

Use of assert(false) can trip spurious control flow warnings from some
versions of gcc:
https://lore.kernel.org/qemu-devel/54bb02a6-1b12-460a-97f6-3f478ef766c6@linaro.org/
Solve that by unifying the code base on g_assert_not_reached()
instead.

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.
Virtualization:  qemu.org | libguestfs.org


