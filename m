Return-Path: <kvm+bounces-26508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB6E19752E3
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 14:51:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40DDA281F3D
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 12:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7DCC18EFF9;
	Wed, 11 Sep 2024 12:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ivlAOQ1G"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E958185952
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 12:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726059106; cv=none; b=JUxkWRhZpkGN7tO4kN0RGoVaw2q16IZ9amwfZb0zNcfgBu1OPn36lgRePTWJMC+bsrSClD5p2Q1oosUkG2sIrHvorN/0RXQWzMpmxhIoND0SZTvBe7c5TVk9kmJL3iEFIgyjBmG+j0hUVwRzGYyvavzPhZBYq5+fNOK+6BKqGng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726059106; c=relaxed/simple;
	bh=WJw4N4zEGiHBLFPXFclNgqe6hweUrFGC32876JvxpI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=StA4iHOjYip6EGTl389Z/KKWSic7+1GOXLuw/k+j8VdvS1UYds4pHIh1FZzi+6QI/rmfmyNubPuz+hcmryPbxeAtIuQkrpWPGDZj8YQfxWavCMKvVrYIygZq0AYIdBcl+q+TQHJ78rWR0FYR5E7Gw/CwatkjWwVbcUFh8kLFskI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ivlAOQ1G; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726059103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mFTkfxZe8Y3KC8+GnCo7YhR64xl+MhtnbrQRYDpeikY=;
	b=ivlAOQ1GkfSPHrTYLvd7ofye1BXKU8SiCvB+l9B8p58ri7getcc0OZyoPP7EeTwXZcoDiD
	V5L4dSmyUpB+H43liSzjsq+e2kKLll19JhzN1mjWjL+fc0+n+bejjYTJe8BD4EvctfVzsy
	Zljc5+RcH1GxP5nEa9+xtlfW3socxrQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-632-iUWjuNGROCO2yRVTK23Trg-1; Wed,
 11 Sep 2024 08:51:40 -0400
X-MC-Unique: iUWjuNGROCO2yRVTK23Trg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F906193584D;
	Wed, 11 Sep 2024 12:51:31 +0000 (UTC)
Received: from localhost (unknown [10.42.28.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E3A1319560AB;
	Wed, 11 Sep 2024 12:51:27 +0000 (UTC)
Date: Wed, 11 Sep 2024 13:51:26 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Eric Blake <eblake@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	qemu-devel@nongnu.org, Zhao Liu <zhao1.liu@intel.com>,
	Joel Stanley <joel@jms.id.au>, Kevin Wolf <kwolf@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
	Corey Minyard <minyard@acm.org>, Eric Farman <farman@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>, Keith Busch <kbusch@kernel.org>,
	WANG Xuerui <git@xen0n.name>, Hyman Huang <yong.huang@smartx.com>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, qemu-riscv@nongnu.org,
	Ani Sinha <anisinha@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
	Jesper Devantier <foss@defmacro.it>,
	Laurent Vivier <laurent@vivier.eu>,
	Peter Maydell <peter.maydell@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fam Zheng <fam@euphon.net>, qemu-s390x@nongnu.org,
	Hanna Reitz <hreitz@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Laurent Vivier <lvivier@redhat.com>, Rob Herring <robh@kernel.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	qemu-block@nongnu.org, qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Fabiano Rosas <farosas@suse.de>, Helge Deller <deller@gmx.de>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Yanan Wang <wangyanan55@huawei.com>, Peter Xu <peterx@redhat.com>,
	Bin Meng <bmeng.cn@gmail.com>, Weiwei Li <liwei1518@gmail.com>,
	Klaus Jensen <its@irrelevant.dk>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH 01/39] docs/spin: replace assert(0) with
 g_assert_not_reached()
Message-ID: <20240911125126.GS1450@redhat.com>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
 <20240910221606.1817478-2-pierrick.bouvier@linaro.org>
 <zkyoryho5alnyirnl7ulvh5y6tkty6koccgeygmve42uml7glu@37rkdodtlx4f>
 <bwo43ms2wi6vbeqhlc7qjwmw5jyt2btxvpph3lqn7tfol4srjf@77yusngzs6wh>
 <10d6d67a-32f6-40fc-aba9-c62a74d9d98d@maciej.szmigiero.name>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10d6d67a-32f6-40fc-aba9-c62a74d9d98d@maciej.szmigiero.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Sep 11, 2024 at 02:46:18PM +0200, Maciej S. Szmigiero wrote:
> On 11.09.2024 14:37, Eric Blake wrote:
> >On Wed, Sep 11, 2024 at 07:33:59AM GMT, Eric Blake wrote:
> >>On Tue, Sep 10, 2024 at 03:15:28PM GMT, Pierrick Bouvier wrote:
> >>>Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> >>>---
> >>
> >>A general suggestion for the entire series: please use a commit
> >>message that explains why this is a good idea.  Even something as
> >>boiler-plate as "refer to commit XXX for rationale" that can be
> >>copy-pasted into all the other commits is better than nothing,
> >>although a self-contained message is best.  Maybe:
> >>
> >>This patch is part of a series that moves towards a consistent use of
> >>g_assert_not_reached() rather than an ad hoc mix of different
> >>assertion mechanisms.
> >
> >Or summarize your cover letter:
> >
> >Use of assert(false) can trip spurious control flow warnings from some
> >versions of gcc:
> >https://lore.kernel.org/qemu-devel/54bb02a6-1b12-460a-97f6-3f478ef766c6@linaro.org/
> >Solve that by unifying the code base on g_assert_not_reached()
> >instead.
> >
> 
> If using g_assert_not_reached() instead of assert(false) silences
> the warning about missing return value in such impossible to reach
> locations should we also be deleting the now-unnecessary "return"
> statements after g_assert_not_reached()?

Although it's unlikely to be used on any compiler that can also
compile qemu, there is a third implementation of g_assert_not_reached
that does nothing, see:

https://gitlab.gnome.org/GNOME/glib/-/blob/927683ebd94eb66c0d7868b77863f57ce9c5bc76/glib/gtestutils.h#L269

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-builder quickly builds VMs from scratch
http://libguestfs.org/virt-builder.1.html


