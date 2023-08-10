Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C1E777FA7
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 19:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235517AbjHJRzh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 13:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbjHJRzg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 13:55:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BEF8E7E
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 10:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691690089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DEbgyFSwr4grpjj9Lb0jzqz1ORrnMasCGrg9RIsiNrc=;
        b=Jo4K8Sx75agW0pOJrb6mWtEc462bu7oPjKWalsH84qu7CC0ZEOhA8DCQkTvsc5WTo8GWL+
        ghIKxAorfoEpOKLv+vGU6J2p5VhGNyGy569MEb7DjVrCzzGiCR3Dv7mT6O8s8dUo6mMfML
        sNu0u/nXyjg14vPdY0a7nXXUbjTv9aI=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-bVB54Qf4PgiL3-XOl1gbLQ-1; Thu, 10 Aug 2023 13:54:46 -0400
X-MC-Unique: bVB54Qf4PgiL3-XOl1gbLQ-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-790bb87da92so88204539f.1
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 10:54:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691690086; x=1692294886;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DEbgyFSwr4grpjj9Lb0jzqz1ORrnMasCGrg9RIsiNrc=;
        b=h7azdFLY5EFAqoroENhj1fWjH9oG1PfJnxrdgM/Oh3+N8tVqPQdkCynWYZa6sinc1Y
         aSaN5XWma7ye98S5MZRWjw25r9ht/8yCzthVLUGEKJUJplGz7kKQBeJXHvuF0IUH3wVD
         CSDtqB2s4e8ZXg0kF/HN/c+/Qkp1fnGEiru1uyzLLGabLALRGdlkL2+wLzkilZ4cUo+0
         q9VGJyoJLXmQrZvZMCJHZ1FK0muO3xZAO9FsJwUM9YtlvVEKbQaSH6oxZTC4B26U2LLV
         UZdJEjDMvg9aWpItCeHmRVyUt5PT+pjkpT2HkwNtji+6Eoh4hiLuQ+A/kxK2JsSjXhpk
         pfoQ==
X-Gm-Message-State: AOJu0YyqNK6gKYvLJSY/V57Vo3AZ+oJEJuhkC7wpHZUNJn27S05lEE/8
        iLfE+yZL8SBiZhoMqIlKTgez0G+YCI04Lw+qlgDH5K9eGdZgzWN7ww/Nm5flTviE5+YxcL10W8a
        lMqDugNW7z0UO
X-Received: by 2002:a6b:d802:0:b0:783:5e93:1e7f with SMTP id y2-20020a6bd802000000b007835e931e7fmr4138466iob.18.1691690085949;
        Thu, 10 Aug 2023 10:54:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFsNk82Q3LSF2n67H8Eoj/Sz4yXPWAYYogZh6heK7ptILV9xcHGMCFUNzsZsZ7JEI4E/ZiCg==
X-Received: by 2002:a6b:d802:0:b0:783:5e93:1e7f with SMTP id y2-20020a6bd802000000b007835e931e7fmr4138459iob.18.1691690085736;
        Thu, 10 Aug 2023 10:54:45 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id g15-20020a02b70f000000b0043021113e09sm530909jam.75.2023.08.10.10.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 10:54:45 -0700 (PDT)
Date:   Thu, 10 Aug 2023 11:54:44 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Brett Creeley <bcreeley@amd.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "horms@kernel.org" <horms@kernel.org>,
        "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: Re: [PATCH v14 vfio 6/8] vfio/pds: Add support for dirty page
 tracking
Message-ID: <20230810115444.21364456.alex.williamson@redhat.com>
In-Reply-To: <ZNUhqEYeT7us5SV/@nvidia.com>
References: <20230807205755.29579-1-brett.creeley@amd.com>
        <20230807205755.29579-7-brett.creeley@amd.com>
        <20230808162718.2151e175.alex.williamson@redhat.com>
        <01a8ee12-7a95-7245-3a00-2745aa846fca@amd.com>
        <20230809113300.2c4b0888.alex.williamson@redhat.com>
        <ZNPVmaolrI0XJG7Q@nvidia.com>
        <BN9PR11MB5276F32CC5791B3D91C62A468C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20230810104734.74fbe148.alex.williamson@redhat.com>
        <ZNUcLM/oRaCd7Ig2@nvidia.com>
        <20230810114008.6b038d2a.alex.williamson@redhat.com>
        <ZNUhqEYeT7us5SV/@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Aug 2023 14:43:04 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Aug 10, 2023 at 11:40:08AM -0600, Alex Williamson wrote:
>=20
> > PCI Express=C2=AE Base Specification Revision 6.0.1, pg 1461:
> >=20
> >   9.3.3.11 VF Device ID (Offset 1Ah)
> >=20
> >   This field contains the Device ID that should be presented for every =
VF to the SI.
> >=20
> >   VF Device ID may be different from the PF Device ID...
> >=20
> > That?  Thanks, =20
>=20
> NVMe matches using the class code, IIRC there is language requiring
> the class code to be the same.

Ok, yes:

  7.5.1.1.6 Class Code Register (Offset 09h)
  ...
  The field in a PF and its associated VFs must return the same value
  when read.

Seems limiting, but it's indeed there.  We've got a lot of cleanup to
do if we're going to start rejecting drivers for devices with PCI
spec violations though ;)  Thanks,

Alex

