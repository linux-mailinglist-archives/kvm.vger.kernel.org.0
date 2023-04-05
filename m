Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C035E6D8178
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 17:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238861AbjDEPRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 11:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238617AbjDEPRZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 11:17:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36ECB65B6
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 08:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680707684;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MSbeq35rqJ3WHS2Hi/jg4P1mAmdjaUY8F18xUXAczgA=;
        b=Vb28R4uloxg+h941jR5GKUiprHdRWryytaMtEEJCqSeIOdNfLe18fcJog9F1SO/hSMyQBu
        L0wFR+Lfs6iCPurrHunvIxgkZzmO5pRNV5tdsUgoFVU7w/Y24kplqEYU0umfWZol/Xk+c6
        UEl7dXZ6OhU8hcnJxK3tA6DlkDf6yKQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-228-6vmkls7BMYmmbb0RiwGIeQ-1; Wed, 05 Apr 2023 11:14:43 -0400
X-MC-Unique: 6vmkls7BMYmmbb0RiwGIeQ-1
Received: by mail-qv1-f69.google.com with SMTP id dg8-20020a056214084800b005acc280bf19so16370812qvb.22
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 08:14:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680707682;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MSbeq35rqJ3WHS2Hi/jg4P1mAmdjaUY8F18xUXAczgA=;
        b=ItOp5OLjh/xeNh3/XEa71wA1D03sjwITpl45dY5d8T6VIiw7Ip3DujHFudSAAejxX7
         uykz8WQGK0vTkPgw+0gVAi/PMgVd6k6Rs/VVlkZiXXimDlpWJiz7+sNfr4TUkHTf+XPI
         I/q8qsgBdsn187SWDy9lljBcwa4hx3cvxBdUNdZCLGg5ZnLUk8uVUddExLqnS/LrLyVo
         8IqRjGKMeORLydCOUbH/pbsVFvX2wJbhs6IcinbtmjE3qE9ptJtmu8q6AV5ZFbpIAxp3
         zIn8xYCnB1sWpAsV+FA6pIC1oXVYTid/R8+pU7+l/AaXfsJWhcK954ayDMSi6wZ2JtgM
         iNiQ==
X-Gm-Message-State: AAQBX9eDsdV9LCISQPVQD9x/OsHbITv4pEFz18qUmBkSj1010swZIUBg
        SRlVXGguNaqih785qyk5e6CoaOJkWg+eF41vLPqaOcPxoslfZkbA1/lXAXfnGl4BPW4vTrrS3Hm
        bUXcjf0saAYdf
X-Received: by 2002:ac8:5cc5:0:b0:3d6:ff99:7e9e with SMTP id s5-20020ac85cc5000000b003d6ff997e9emr5229938qta.33.1680707682480;
        Wed, 05 Apr 2023 08:14:42 -0700 (PDT)
X-Google-Smtp-Source: AKy350Zlgevm6Gpp8gQwtyz6Xv8+LMvLwjE1yHVNcDW2XGpmSXvtrNr59FUgRAfBeWw7meygfbGx0A==
X-Received: by 2002:ac8:5cc5:0:b0:3d6:ff99:7e9e with SMTP id s5-20020ac85cc5000000b003d6ff997e9emr5229887qta.33.1680707682097;
        Wed, 05 Apr 2023 08:14:42 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id i19-20020ac87653000000b003e38e2815a5sm4031551qtr.22.2023.04.05.08.14.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 08:14:39 -0700 (PDT)
Message-ID: <48208e9e-2721-bea5-3a5e-852e32185d34@redhat.com>
Date:   Wed, 5 Apr 2023 17:14:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 02/12] vfio/pci: Only check ownership of opened devices
 in hot reset
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-3-yi.l.liu@intel.com>
 <844faa5c-2968-2a4f-8a70-900f359be1a0@redhat.com>
 <DS0PR11MB75290339DD0FD467146D4655C3939@DS0PR11MB7529.namprd11.prod.outlook.com>
 <fc87191d-2e79-83c3-b5ba-7f8b1083988a@redhat.com>
 <DS0PR11MB7529441450FE32DC9578C6B8C3939@DS0PR11MB7529.namprd11.prod.outlook.com>
 <5781064c-8742-d37d-57dc-7a7238e948d5@redhat.com>
 <ZC1eg8ZqwkfKuTDx@nvidia.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <ZC1eg8ZqwkfKuTDx@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 4/5/23 13:41, Jason Gunthorpe wrote:
> On Tue, Apr 04, 2023 at 05:59:01PM +0200, Eric Auger wrote:
>
>>> but the hot reset shall fail as the group is not owned by the user.
>> sure it shall but I fail to understand if the reset fails or the device
>> plug is somehow delayed until the reset completes.
> It is just racy today - vfio_pci_dev_set_resettable() doesn't hold any
> locks across the pci_walk_bus() check to prevent hot plug in while it is
> working on the reset.

OK thanks

Eric
>
> Jason
>

