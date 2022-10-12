Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A9D5FC424
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 13:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiJLLLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 07:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiJLLLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 07:11:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7ED9A99E6
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 04:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665573074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8YiAlVcyacuAF1cXPKHrDiH+rQYQoNsO4NEHWDYYi14=;
        b=iDIJ8YJ7dFjXb2rzD86PK0sSXWE5o+yyGWbgK1DjTyFZ0efUFxwFHVKz8UGuyLEBCkwFl7
        +d3RimS8s9MPiH0k6PRjiTrDzuo1DsRkD9xY01+ZeO+U1HKW4dQf0Uhlon5kBjzgT8iIfT
        zPWZJQWhakUsBq5rMgd29tNz/jRHf0Y=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-90-7okeR0rtOnqJt_AMbLNlRg-1; Wed, 12 Oct 2022 07:11:13 -0400
X-MC-Unique: 7okeR0rtOnqJt_AMbLNlRg-1
Received: by mail-wr1-f70.google.com with SMTP id k30-20020adfb35e000000b0022e04708c18so4891190wrd.22
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 04:11:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8YiAlVcyacuAF1cXPKHrDiH+rQYQoNsO4NEHWDYYi14=;
        b=JehBcAmkFiaXBAzF2U9W0nzdfnBXnriR/IIL1fAsxj0Di1Yv9YAPYUjCwbCd8XAOcT
         b5cCpEHQGB/xZfYcGjuNl27CA+QCEtZa2TioGiQNfTdyH2s1HoiTJw5TfTpkFAZYXhG6
         DHDk3EazRGor4awbLIVqQpJ+oA7zLyIh5q3Ao3lmvyH/9nmXrf2BYPEGnCK0TnFt42c8
         N60dcCVg6pUtSqx0WbQMiIaNkeatzi2QmvgDG7+YgzC4uE0coSfEFAUwe91KOZS7syEN
         2DXq5YdX105EIIU6RVPWoeotBP/IBxIObU+bD8KufEfNok1gwVHf2uK/sZdFGr8cv8n5
         sXhQ==
X-Gm-Message-State: ACrzQf01cS6cKR2Pjng04CdALazuTKNThRbQPZ1wLewyo+nj+ccKuUaS
        WeRyuk3glmVu5PvOA97KRvdfeysIvBG2GHpXznTZN8jGlTP8XwUNphGGznbYV2y/O18jj4L9oeV
        AMbtqgwVrVOHS
X-Received: by 2002:a5d:4581:0:b0:228:a8e5:253c with SMTP id p1-20020a5d4581000000b00228a8e5253cmr16709130wrq.506.1665573072676;
        Wed, 12 Oct 2022 04:11:12 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4M2UeBQqsLu/YgEb0FS7XO2FtVoGI+qgl10zlKDVC740GbGZGoVVc16JkgQ8fSzCwcytvnSw==
X-Received: by 2002:a5d:4581:0:b0:228:a8e5:253c with SMTP id p1-20020a5d4581000000b00228a8e5253cmr16709111wrq.506.1665573072445;
        Wed, 12 Oct 2022 04:11:12 -0700 (PDT)
Received: from redhat.com ([2.54.162.123])
        by smtp.gmail.com with ESMTPSA id y8-20020a05600c364800b003c6bd91caa5sm1493777wmq.17.2022.10.12.04.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 04:11:11 -0700 (PDT)
Date:   Wed, 12 Oct 2022 07:11:08 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alvaro.karsz@solid-run.com, angus.chen@jaguarmicro.com,
        gavinl@nvidia.com, jasowang@redhat.com, lingshan.zhu@intel.com,
        wangdeming@inspur.com, xiujianfeng@huawei.com,
        linuxppc-dev@lists.ozlabs.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] virtio: fixes, features
Message-ID: <20221012070532-mutt-send-email-mst@kernel.org>
References: <20221010132030-mutt-send-email-mst@kernel.org>
 <87r0zdmujf.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r0zdmujf.fsf@mpe.ellerman.id.au>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 12, 2022 at 05:21:24PM +1100, Michael Ellerman wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
> > The following changes since commit 4fe89d07dcc2804c8b562f6c7896a45643d34b2f:
> >
> >   Linux 6.0 (2022-10-02 14:09:07 -0700)
> >
> > are available in the Git repository at:
> >
> >   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> >
> > for you to fetch changes up to 71491c54eafa318fdd24a1f26a1c82b28e1ac21d:
> >
> >   virtio_pci: don't try to use intxif pin is zero (2022-10-07 20:00:44 -0400)
> >
> > ----------------------------------------------------------------
> > virtio: fixes, features
> >
> > 9k mtu perf improvements
> > vdpa feature provisioning
> > virtio blk SECURE ERASE support
> >
> > Fixes, cleanups all over the place.
> >
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >
> > ----------------------------------------------------------------
> > Alvaro Karsz (1):
> >       virtio_blk: add SECURE ERASE command support
> >
> > Angus Chen (1):
> >       virtio_pci: don't try to use intxif pin is zero
> 
> This commit breaks virtio_pci for me on powerpc, when running as a qemu
> guest.
> 
> vp_find_vqs() bails out because pci_dev->pin == 0.
> 
> But pci_dev->irq is populated correctly, so vp_find_vqs_intx() would
> succeed if we called it - which is what the code used to do.
> 
> I think this happens because pci_dev->pin is not populated in
> pci_assign_irq().
> 
> I would absolutely believe this is bug in our PCI code, but I think it
> may also affect other platforms that use of_irq_parse_and_map_pci().
> 
> cheers

How about fixing this in of_irq_parse_and_map_pci then?
Something like the below maybe?

diff --git a/drivers/pci/of.c b/drivers/pci/of.c
index 196834ed44fe..504c4d75c83f 100644
--- a/drivers/pci/of.c
+++ b/drivers/pci/of.c
@@ -446,6 +446,8 @@ static int of_irq_parse_pci(const struct pci_dev *pdev, struct of_phandle_args *
 	if (pin == 0)
 		return -ENODEV;
 
+	pdev->pin = pin;
+
 	/* Local interrupt-map in the device node? Use it! */
 	if (of_get_property(dn, "interrupt-map", NULL)) {
 		pin = pci_swizzle_interrupt_pin(pdev, pin);

