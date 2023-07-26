Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A826E763F81
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 21:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbjGZT0l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 15:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbjGZT0j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 15:26:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C4D2720
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 12:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690399549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b470bquDvAWwTJ3wEUm2l/rKWbtahDTcrXgZvkuAUQM=;
        b=QzZxSmdtkR0Ld42nFtYsbFdrxsMrwL7GhdmeFKCGfPmG4I9QtPkSfr6Cj77qxmY2DPlUY4
        zjxnniK8t1jOIqVhhSUCP2NMygk0CF1AhJbcY/bHeC1Q4EpmhH7ZDh8AGmJ2+mRPBcCPnQ
        P3hjplMFlzoYFs0p/IkBH17L5gyAh7E=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-HYiWqIlxMC6xgdhpXH21HA-1; Wed, 26 Jul 2023 15:25:47 -0400
X-MC-Unique: HYiWqIlxMC6xgdhpXH21HA-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-78705f0e3feso8668439f.1
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 12:25:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690399547; x=1691004347;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b470bquDvAWwTJ3wEUm2l/rKWbtahDTcrXgZvkuAUQM=;
        b=Vx+DX4FGcvDUYtr7wQdSj1InFBC6j6CqbF7XYrgGZo1jfHu6n0nypGls46pn1uic7b
         sUKUGGiVQ9ydLoCqdQcZ2/WjOmvvjjmI9WN4NJyHuQJF2cnRjUmlfUkE33DiVjMFPlzm
         KjF1t1Zb5d+UeDqfnUKAN3tAOL24o+9efhxETpJW+HMWnP1f6580io8a6T5io5KVPFyg
         kSpuQDmTMScwldOG8+kJsLND/LXi5O3E0UvAl8Fr+fnSeryAPfWQQXY9sOCX/Fvpfkmu
         rFpE3oA7BIGdVA2wZ/55ec976TA3EaGP6FdeEVuW3xglSS2YAVktxx3O/2+lxuhP/4Uj
         pb9Q==
X-Gm-Message-State: ABy/qLYwWCmW1OyseJoYHXFqgKRiLT4igCuWZukkwWS9uX47DaLSeUF6
        7aumc+5xV1HrVAKnL3tBWvzsNkI7sYD/eq5I0iTLSIC4w4BTySW+6ifIb/NZz71Upe66Oop95QZ
        GgdgxDnpI08Sq
X-Received: by 2002:a05:6602:10f:b0:783:57a0:612c with SMTP id s15-20020a056602010f00b0078357a0612cmr3115861iot.10.1690399547027;
        Wed, 26 Jul 2023 12:25:47 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHKSNJk//D8TxnhZOZHTizZXe3HvjTavmKRr+BZbiNXoTGUO8viZnZraxYCP7ylJPTA66TjGg==
X-Received: by 2002:a05:6602:10f:b0:783:57a0:612c with SMTP id s15-20020a056602010f00b0078357a0612cmr3115848iot.10.1690399546796;
        Wed, 26 Jul 2023 12:25:46 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id e26-20020a5d925a000000b0078335414ddesm5258050iol.26.2023.07.26.12.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 12:25:46 -0700 (PDT)
Date:   Wed, 26 Jul 2023 13:25:44 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Brett Creeley <bcreeley@amd.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        simon.horman@corigine.com, shannon.nelson@amd.com
Subject: Re: [PATCH v13 vfio 0/7] pds-vfio-pci driver
Message-ID: <20230726132544.69e52844.alex.williamson@redhat.com>
In-Reply-To: <95fa9f2d-a529-4d79-167f-eaee1ed0ac4f@amd.com>
References: <20230725214025.9288-1-brett.creeley@amd.com>
        <ZMEhCrZDNLSrWP/5@nvidia.com>
        <20230726125051.424ed592.alex.williamson@redhat.com>
        <95fa9f2d-a529-4d79-167f-eaee1ed0ac4f@amd.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 26 Jul 2023 12:05:13 -0700
Brett Creeley <bcreeley@amd.com> wrote:

> On 7/26/2023 11:50 AM, Alex Williamson wrote:
> > Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> > 
> > 
> > On Wed, 26 Jul 2023 10:35:06 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> >> On Tue, Jul 25, 2023 at 02:40:18PM -0700, Brett Creeley wrote:
> >>  
> >>> Note: This series is based on the latest linux-next tree. I did not base
> >>> it on the Alex Williamson's vfio/next because it has not yet pulled in
> >>> the latest changes which include the pds_vdpa driver. The pds_vdpa
> >>> driver has conflicts with the pds-vfio-pci driver that needed to be
> >>> resolved, which is why this series is based on the latest linux-next
> >>> tree.  
> >>
> >> This is not the right way to handle this, Alex cannot apply a series
> >> against linux-next.
> >>
> >> If you can't make a shared branch and the conflicts are too
> >> significant to forward to Linus then you have to wait for the next
> >> cycle.  
> > 
> > Brett, can you elaborate on what's missing from my next branch vs
> > linux-next?
> > 
> > AFAICT the pds_vdpa driver went into mainline via a8d70602b186 ("Merge
> > tag 'for_linus' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost") during the
> > v6.5 merge window and I'm not spotting anything in linux-next obviously
> > relevant to pds-vfio-pci since then.
> > 
> > There's a debugfs fix on the list, but that's sufficiently trivial to
> > fixup on merge if necessary.  This series also applies cleanly vs my
> > current next branch.  Was the issue simply that I hadn't updated my
> > next branch (done yesterday) since the v6.5 merge window?  You can
> > always send patches vs mainline.  Thanks,  
> 
> Yeah, this was exactly it. Your vfio/next branch didn't have the 
> pds_vdpa series in it yet, which also included some changes to the 
> header files used by the pds-vfio-pci series, which is where the 
> conflicts are.

Ok, so let's put this back on the table as a candidate for v6.6.

> Should I rebase my series on your vfio/next branch and resend?

It doesn't seem necessary, I think rebasing my next branch to v6.5-rc3
made it effectively equivalent to linux-next for the purposes of this
driver.  It applies cleanly, so I think we can continue review from
this.  Thanks,

Alex

