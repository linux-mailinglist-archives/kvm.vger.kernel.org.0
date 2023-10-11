Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8FA57C5A09
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 19:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbjJKRGj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 13:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbjJKRGh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 13:06:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC695E9
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 10:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697043945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y1brdHaYQR/1KT6dTzx9XTkLz90qgniDtBGmYHkS7B4=;
        b=aLp42Quk1uTQEEmOflVo5j5ZCHuvluqpOFzEiNsPh7ljgilegvd2/ZeQ3ktBNbXzRyRJc8
        9wQ4szeI05Sf/2CD9eJ77//YpY1MQXb7I8ojH09oZ684YaZz/D0WwY4oAV8FVdbafPixVu
        OwV6O0e91yVgHBT7pwEQt9i+rk76seY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-dFTfQlfJNvKsW8UpB8rspQ-1; Wed, 11 Oct 2023 13:05:33 -0400
X-MC-Unique: dFTfQlfJNvKsW8UpB8rspQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4063dd6729bso752925e9.2
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 10:05:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697043932; x=1697648732;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y1brdHaYQR/1KT6dTzx9XTkLz90qgniDtBGmYHkS7B4=;
        b=VQgjbzAW6lk0Gyq2ev1kAyne8WpC/K5YMOhlEbBJVoB5UbZ6Dl9cUigzKEbUKSKIXs
         YHGlakLQkpe3erwRsXyibjRSsThmaoXXrChQRSY7URQ/rlMEUwHmed5wn1Pt6ZMTbsxk
         c0sfXVLsuvpjBZgv3VhBy59OZvAFhP+99GrZ4srWAHvx6FPRrvbK4MsJYfwJxMlnO8ev
         LC0TwYofHSRpjIVOUPgYpsStq+Xx5+sA3xV9NlyuMIbkTZFsGtQWQnkSetPt5knGVZOE
         ny68l43WmHqq+e7YJPUSK720Cl5B6n6QALBqb2biYDX3hwHckSJicisZYLcRiPpZ9o7v
         cFDA==
X-Gm-Message-State: AOJu0YwYY3tntlxzSCuYcTngWCw3FYwdH1oiWksaYo4v4orFv99qR7Ud
        qOre4huoS/6TBPcZuhfseZi88pCcmQ1DlbbRwVSk1fwy4dQHGo7Pa8gaoqHaZ9twVLD/G9ZM5Zv
        RDh/inJIhBDkA
X-Received: by 2002:a05:600c:b49:b0:406:7232:1431 with SMTP id k9-20020a05600c0b4900b0040672321431mr19337286wmr.33.1697043932490;
        Wed, 11 Oct 2023 10:05:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEkP7tKH7rx3WNL++lr4xFcEO49W8z8lrIDi+0WNMmcJnSlIasAGIk0kmgIQ5uKwF989mkFhg==
X-Received: by 2002:a05:600c:b49:b0:406:7232:1431 with SMTP id k9-20020a05600c0b4900b0040672321431mr19337264wmr.33.1697043932189;
        Wed, 11 Oct 2023 10:05:32 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73d2:bf00:e379:826:5137:6b23])
        by smtp.gmail.com with ESMTPSA id b5-20020a5d6345000000b0032326908972sm15811545wrw.17.2023.10.11.10.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 10:05:31 -0700 (PDT)
Date:   Wed, 11 Oct 2023 13:05:28 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231011130317-mutt-send-email-mst@kernel.org>
References: <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <20231010155937.GN3952@nvidia.com>
 <ZSY9Cv5/e3nfA7ux@infradead.org>
 <20231011021454-mutt-send-email-mst@kernel.org>
 <ZSZHzs38Q3oqyn+Q@infradead.org>
 <PH0PR12MB5481336B395F38E875ED11D8DCCCA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20231011040331-mutt-send-email-mst@kernel.org>
 <20231011121849.GV3952@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011121849.GV3952@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023 at 09:18:49AM -0300, Jason Gunthorpe wrote:
> With VDPA doing the same stuff as vfio I'm not sure who is auditing it
> for security.

Check the signed off tags and who sends the pull requests if you want to
know.

-- 
MST

