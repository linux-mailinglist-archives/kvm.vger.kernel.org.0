Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE6AAB6AD6
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 20:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387651AbfIRSuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 14:50:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42038 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387634AbfIRSuF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 14:50:05 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F38D480F6D;
        Wed, 18 Sep 2019 18:50:04 +0000 (UTC)
Received: from x1.home (ovpn-118-102.phx2.redhat.com [10.3.118.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0D8319C5B;
        Wed, 18 Sep 2019 18:49:59 +0000 (UTC)
Date:   Wed, 18 Sep 2019 12:49:59 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     kwankhede@nvidia.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH] sample: vfio mdev display - Fix a missing error code in
 an error handling path
Message-ID: <20190918124959.2741993f@x1.home>
In-Reply-To: <20190916202240.30189-1-christophe.jaillet@wanadoo.fr>
References: <20190916202240.30189-1-christophe.jaillet@wanadoo.fr>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 18 Sep 2019 18:50:05 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Sep 2019 22:22:40 +0200
Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> 'ret' is known to be 0 at this point. So explicitly set it to -ENOMEM if
> 'framebuffer_alloc()' fails.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  samples/vfio-mdev/mdpy-fb.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
> index 2719bb259653..6fe0187f47a2 100644
> --- a/samples/vfio-mdev/mdpy-fb.c
> +++ b/samples/vfio-mdev/mdpy-fb.c
> @@ -131,8 +131,10 @@ static int mdpy_fb_probe(struct pci_dev *pdev,
>  		 width, height);
>  
>  	info = framebuffer_alloc(sizeof(struct mdpy_fb_par), &pdev->dev);
> -	if (!info)
> +	if (!info) {
> +		ret = -ENOMEM;
>  		goto err_release_regions;
> +	}
>  	pci_set_drvdata(pdev, info);
>  	par = info->par;
>  

I think you're only scratching the surface here, this looks more
complete to me:

diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
index 2719bb259653..a760e130bd0d 100644
--- a/samples/vfio-mdev/mdpy-fb.c
+++ b/samples/vfio-mdev/mdpy-fb.c
@@ -117,22 +117,27 @@ static int mdpy_fb_probe(struct pci_dev *pdev,
 	if (format != DRM_FORMAT_XRGB8888) {
 		pci_err(pdev, "format mismatch (0x%x != 0x%x)\n",
 			format, DRM_FORMAT_XRGB8888);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_release_regions;
 	}
 	if (width < 100	 || width > 10000) {
 		pci_err(pdev, "width (%d) out of range\n", width);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_release_regions;
 	}
 	if (height < 100 || height > 10000) {
 		pci_err(pdev, "height (%d) out of range\n", height);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_release_regions;
 	}
 	pci_info(pdev, "mdpy found: %dx%d framebuffer\n",
 		 width, height);
 
 	info = framebuffer_alloc(sizeof(struct mdpy_fb_par), &pdev->dev);
-	if (!info)
+	if (!info) {
+		ret = -ENOMEM;
 		goto err_release_regions;
+	}
 	pci_set_drvdata(pdev, info);
 	par = info->par;
 
