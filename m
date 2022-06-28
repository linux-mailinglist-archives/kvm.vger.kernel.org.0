Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D58E55CB99
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343526AbiF1Gov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 02:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244575AbiF1Gou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 02:44:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 78D4224BCE
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 23:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656398688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hKKhmAVY6ZLU32yFo246MjjcA6QB3q+Asrc/tb9AagA=;
        b=FWCGJqg5msDnwZD0HXb37xFn4rZJnRa1NBrjulXChbQpXZ0+RvnfXDUaROncqdfjI8bReT
        8ePxKVow7na5aCdCDIWjgSqN/n6Gs4um23RAjAjYlztefRXrvcc5k+EE1UQMvfUPuaG4t9
        +SnZukzymjNxBQirLKq8bwd38Ecq2K4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-03p_AHU6Pn2nvf0Fq-FE3w-1; Tue, 28 Jun 2022 02:44:46 -0400
X-MC-Unique: 03p_AHU6Pn2nvf0Fq-FE3w-1
Received: by mail-wr1-f69.google.com with SMTP id s1-20020a5d69c1000000b0021b9f3abfebso1507385wrw.2
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 23:44:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hKKhmAVY6ZLU32yFo246MjjcA6QB3q+Asrc/tb9AagA=;
        b=mmUcqlvL5ZYHWLhlCaiOAbGeKTRlnp7F3q+NKRrPV9Rs10qXxpQbshCZKP7aPVejCJ
         FMhe5DdG67NEIR8/7CkMPW+TJIPPbcrdQQ8uEmBMNRRmF++ZkL3ycNSEAzDGXhxcUfrI
         m5n1yTLcANn5PH6p37uT1t8PIRweNoewBy+fOOAxhOAKMC6tjYfDoDwBjXsSkGZ3vYyQ
         c9rLi7JYbqxJ6OPeUtc+dCc4pBs56C7kgg0A9QPy3lVYqnEARPhmg5TvdLWPBe5w+6no
         I0Nwwo+PVXGoPHl6RrkDFa70wrtVxzZhqeJVNjk8HT52byBE3Qk/PYlwhyKxhYcLcsKX
         00sw==
X-Gm-Message-State: AJIora/MtqeQu40SXTHqXeYF1mrbVU8zi7kPlnz9p9ndU9tHdxcepkEa
        AQLvyZ+AYtEfkAHZkfH01R89lPRR2CmANV8SYNglWSlm9/8u6dMdFUGIr4mI0xEF7peFRkS4Kc8
        pHeRS/AkjYMdI
X-Received: by 2002:a05:600c:4e90:b0:39c:7ec6:c7d2 with SMTP id f16-20020a05600c4e9000b0039c7ec6c7d2mr19756870wmq.140.1656398685545;
        Mon, 27 Jun 2022 23:44:45 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uIze8DJsIvzB3CNFTFD7nxCkijrxeoiA7/FaJ3ir6OLO+Z+2vAtNLsCgnTCLoOO1PL/wj22A==
X-Received: by 2002:a05:600c:4e90:b0:39c:7ec6:c7d2 with SMTP id f16-20020a05600c4e9000b0039c7ec6c7d2mr19756849wmq.140.1656398685292;
        Mon, 27 Jun 2022 23:44:45 -0700 (PDT)
Received: from redhat.com ([2.52.23.204])
        by smtp.gmail.com with ESMTPSA id l15-20020a05600c1d0f00b003a04962ad3esm9243219wms.31.2022.06.27.23.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 23:44:44 -0700 (PDT)
Date:   Tue, 28 Jun 2022 02:44:40 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH V3] virtio: disable notification hardening by default
Message-ID: <20220628023832-mutt-send-email-mst@kernel.org>
References: <20220624022622-mutt-send-email-mst@kernel.org>
 <CACGkMEuurobpUWmDL8zmZ6T6Ygc0OEMx6vx2EDCSoGNnZQ0r-w@mail.gmail.com>
 <20220627024049-mutt-send-email-mst@kernel.org>
 <CACGkMEvrDXDN7FH1vKoYCob2rkxUsctE_=g61kzHSZ8tNNr6vA@mail.gmail.com>
 <20220627053820-mutt-send-email-mst@kernel.org>
 <CACGkMEvcs+9_SHmO1s3nyzgU7oq7jhU2gircVVR3KDsGDikh5Q@mail.gmail.com>
 <20220628004614-mutt-send-email-mst@kernel.org>
 <CACGkMEsC4A+3WejLSOZoH3enXtai=+JyRNbxcpzK4vODYzhaFw@mail.gmail.com>
 <20220628022035-mutt-send-email-mst@kernel.org>
 <CACGkMEt=go5qAH+P0to6yyE2dPhyfFmOQP0jfuj=57PmD7Y3zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEt=go5qAH+P0to6yyE2dPhyfFmOQP0jfuj=57PmD7Y3zg@mail.gmail.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 28, 2022 at 02:32:19PM +0800, Jason Wang wrote:
> > Question is are there drivers which kick before they are ready
> > to handle callbacks?
> 
> Let me try to have a look at all the drivers to answer this.

One thing to note is that I consider hardening probe and
hardening remove separate features. I think that at this point
for secured guests it is prudent to outright block device
removal - we have been finding races in removal for years.
Note sure there's a flag for that but it's probably not too hard to add
e.g. to pci core.

-- 
MST

