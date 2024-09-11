Return-Path: <kvm+bounces-26537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C798297551A
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 16:17:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 027351C22C4A
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 14:17:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC1A419F107;
	Wed, 11 Sep 2024 14:17:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zero.eik.bme.hu (zero.eik.bme.hu [152.66.115.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942A919DFAC
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 14:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.66.115.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726064226; cv=none; b=U525Mb/6dHhU5ptvOsXwtO3y3J322IdlruTXeZG+sLppdVDlC6+SK5SOEgKCx6HnO2sXGUecXKyvFAK/RftaKqRVpvNw3xg3V6rxw1vLNrfkfyR774wUy2UKda6NePvH35Nkdn329ykedTrUtM2yVp7aK7j4XhV67O8l+bkhReA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726064226; c=relaxed/simple;
	bh=SOUw5Y4YQMLsjOAljdqcjjuymWDc8Xu/C98I0ot+Gx8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=KluzvG+hIA4+NP+E4lbZzg7fdCHCnvEy+DpgJUQCLhvyF0Zf9ReOqq2kEss4jLVGqMKaXk1Y6khprdD5sidEz5ouanACXyXGhcdlay3uKDc7DtkfRSk58ciM/iiDNNl1WSlStg1B9P+ftFX+K9VlZIN4E+cSUztkz0XZRMvD4ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu; spf=pass smtp.mailfrom=eik.bme.hu; arc=none smtp.client-ip=152.66.115.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eik.bme.hu
Received: from zero.eik.bme.hu (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id 667EE4E6004;
	Wed, 11 Sep 2024 16:10:09 +0200 (CEST)
X-Virus-Scanned: amavisd-new at eik.bme.hu
Received: from zero.eik.bme.hu ([127.0.0.1])
 by zero.eik.bme.hu (zero.eik.bme.hu [127.0.0.1]) (amavisd-new, port 10028)
 with ESMTP id YLElQEdkb6ps; Wed, 11 Sep 2024 16:10:07 +0200 (CEST)
Received: by zero.eik.bme.hu (Postfix, from userid 432)
	id 7534F4E600E; Wed, 11 Sep 2024 16:10:07 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id 7180A746F60;
	Wed, 11 Sep 2024 16:10:07 +0200 (CEST)
Date: Wed, 11 Sep 2024 16:10:07 +0200 (CEST)
From: BALATON Zoltan <balaton@eik.bme.hu>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
cc: qemu-devel@nongnu.org, Zhao Liu <zhao1.liu@intel.com>, 
    "Richard W.M. Jones" <rjones@redhat.com>, Joel Stanley <joel@jms.id.au>, 
    Kevin Wolf <kwolf@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
    qemu-arm@nongnu.org, Corey Minyard <minyard@acm.org>, 
    Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>, 
    Keith Busch <kbusch@kernel.org>, WANG Xuerui <git@xen0n.name>, 
    Hyman Huang <yong.huang@smartx.com>, 
    Stefan Berger <stefanb@linux.vnet.ibm.com>, 
    Michael Rolnik <mrolnik@gmail.com>, 
    Alistair Francis <alistair.francis@wdc.com>, 
    =?ISO-8859-15?Q?Marc-Andr=E9_Lureau?= <marcandre.lureau@redhat.com>, 
    Markus Armbruster <armbru@redhat.com>, 
    Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>, 
    Palmer Dabbelt <palmer@dabbelt.com>, qemu-riscv@nongnu.org, 
    Ani Sinha <anisinha@redhat.com>, Halil Pasic <pasic@linux.ibm.com>, 
    Jesper Devantier <foss@defmacro.it>, Laurent Vivier <laurent@vivier.eu>, 
    Peter Maydell <peter.maydell@linaro.org>, 
    Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org, 
    =?ISO-8859-15?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>, 
    Richard Henderson <richard.henderson@linaro.org>, 
    Fam Zheng <fam@euphon.net>, qemu-s390x@nongnu.org, 
    Hanna Reitz <hreitz@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, 
    Eduardo Habkost <eduardo@habkost.net>, Laurent Vivier <lvivier@redhat.com>, 
    Rob Herring <robh@kernel.org>, 
    Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, qemu-block@nongnu.org, 
    "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>, qemu-ppc@nongnu.org, 
    Daniel Henrique Barboza <danielhb413@gmail.com>, 
    Christian Borntraeger <borntraeger@linux.ibm.com>, 
    Harsh Prateek Bora <harshpb@linux.ibm.com>, 
    =?ISO-8859-15?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>, 
    Nina Schoetterl-Glausch <nsg@linux.ibm.com>, 
    "Michael S. Tsirkin" <mst@redhat.com>, Fabiano Rosas <farosas@suse.de>, 
    Helge Deller <deller@gmx.de>, Dmitry Fleytman <dmitry.fleytman@gmail.com>, 
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
Subject: Re: [PATCH 20/39] hw/ppc: replace assert(false) with
 g_assert_not_reached()
In-Reply-To: <20240910221606.1817478-21-pierrick.bouvier@linaro.org>
Message-ID: <232858c7-6270-f763-adfc-b6c8259bf021@eik.bme.hu>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org> <20240910221606.1817478-21-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed



On Tue, 10 Sep 2024, Pierrick Bouvier wrote:

> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
> hw/ppc/spapr_events.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/hw/ppc/spapr_events.c b/hw/ppc/spapr_events.c
> index cb0eeee5874..38ac1cb7866 100644
> --- a/hw/ppc/spapr_events.c
> +++ b/hw/ppc/spapr_events.c
> @@ -645,7 +645,7 @@ static void spapr_hotplug_req_event(uint8_t hp_id, uint8_t hp_action,
>         /* we shouldn't be signaling hotplug events for resources
>          * that don't support them
>          */
> -        g_assert(false);
> +        g_assert_not_reached();
>         return;
>     }

If break does not make sense after g_assert_not_reached() and removed then 
return is the same here.

It may make the series shorter and easier to check that none of these are 
missed if this is done in the same patch where the assert is changed 
instead of separate patches. It's unlikely that the assert change and 
removal of the following break or return would need to be reverted 
separately so it's a simple enough change to put in one patch in my 
opinion but I don't mink if it's kept separate either.

Regards,
BALATON Zoltan

