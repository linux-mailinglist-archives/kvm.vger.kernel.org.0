Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C155B596449
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 23:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237425AbiHPVNX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 17:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiHPVNV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 17:13:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD040520A0
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 14:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660684397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AYi2WRVY0WJT21lyY1QoYwOC5FBNKCZk5dLPYuZKuSk=;
        b=UAhceFTx27RzTyNK3GYz0OQy+ruJC6R50sP0MAuqU8SOwMTL3J6peeOGeSytLvTMFezzr/
        QYbkhsyEgsVRpBnub4m59fALgrHa2tmxILm0CA26fNbrJH3uEMA63WKHG/t6D/AsZSXrdM
        A9DR6VumeEVm5H8kybaeCN4/aWzfvFE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-551-iBF6923sPlKBOjERtoFrNQ-1; Tue, 16 Aug 2022 17:13:16 -0400
X-MC-Unique: iBF6923sPlKBOjERtoFrNQ-1
Received: by mail-wm1-f72.google.com with SMTP id b4-20020a05600c4e0400b003a5a96f1756so28117wmq.0
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 14:13:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=AYi2WRVY0WJT21lyY1QoYwOC5FBNKCZk5dLPYuZKuSk=;
        b=FGpy3NYVEC+MTzgvYduwMOBdZJHfN9QLHFM9XKqL1Lg8OR2xHj0p9Cjsp+y7x+SfDr
         CidCmcft6Qdo6MwjHGPwt/RV1QaDdFboMsR+6ymq7niPAkGqTHjuEqseX6ISaBgAZwi6
         wiEmGulbFtdXV02tXJFNLgOrF3wyK4bHfecgow7sOdEYqaNklJkU+ifFqn8xeBhVM543
         ikYiiySl/ct4yFBwBK8WwtrObKHaq9KYMouwyE66oKGVRJjzk1Z690QAb6uMbotk20KF
         YydXdlmFXVMhx6ivi9sZvOGB3ej1V+ayOXmOb51Ci1xCbFfLlHWVPDr75DXoiARwwLEE
         YVEQ==
X-Gm-Message-State: ACgBeo2l3bBZZl0pe6uH6VEjx5D8iLOr5nh2LZe7+R+hNKGGCFlGyXaC
        t2eCwf3B+iUC/UG93sQLefLg+f//jOLCPHm7gQ+LOB8xDU1J57bqgV/HRjuQz8W1awOtXY26tK+
        XUhxsmyenXm+s
X-Received: by 2002:a5d:5949:0:b0:224:e674:534 with SMTP id e9-20020a5d5949000000b00224e6740534mr9977936wri.254.1660684395169;
        Tue, 16 Aug 2022 14:13:15 -0700 (PDT)
X-Google-Smtp-Source: AA6agR55aKwS//DmXsaapDe8frvEPqPbRT1KPyjrWnb98GBtsRPDzvJ16TcKJ2nMrDKcC0LZ1eOhNg==
X-Received: by 2002:a5d:5949:0:b0:224:e674:534 with SMTP id e9-20020a5d5949000000b00224e6740534mr9977924wri.254.1660684394894;
        Tue, 16 Aug 2022 14:13:14 -0700 (PDT)
Received: from redhat.com ([2.55.43.215])
        by smtp.gmail.com with ESMTPSA id c21-20020a05600c149500b003a604a29a34sm4258950wmh.35.2022.08.16.14.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 14:13:14 -0700 (PDT)
Date:   Tue, 16 Aug 2022 17:13:11 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com, jasowang@redhat.com
Subject: Re: [PATCH V5 4/6] vDPA: !FEATURES_OK should not block querying
 device config space
Message-ID: <20220816171106-mutt-send-email-mst@kernel.org>
References: <20220812104500.163625-1-lingshan.zhu@intel.com>
 <20220812104500.163625-5-lingshan.zhu@intel.com>
 <e99e6d81-d7d5-e1ff-08e0-c22581c1329a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e99e6d81-d7d5-e1ff-08e0-c22581c1329a@oracle.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 16, 2022 at 12:41:21AM -0700, Si-Wei Liu wrote:
> Hi Michael,
> 
> I just noticed this patch got pulled to linux-next prematurely without
> getting consensus on code review, am not sure why. Hope it was just an
> oversight.
> 
> Unfortunately this introduced functionality regression to at least two cases
> so far as I see:
> 
> 1. (bogus) VDPA_ATTR_DEV_NEGOTIATED_FEATURES are inadvertently exposed and
> displayed in "vdpa dev config show" before feature negotiation is done.
> Noted the corresponding features name shown in vdpa tool is called
> "negotiated_features" rather than "driver_features". I see in no way the
> intended change of the patch should break this user level expectation
> regardless of any spec requirement. Do you agree on this point?
> 
> 2. There was also another implicit assumption that is broken by this patch.
> There could be a vdpa tool query of config via
> vdpa_dev_net_config_fill()->vdpa_get_config_unlocked() that races with the
> first vdpa_set_features() call from VMM e.g. QEMU. Since the S_FEATURES_OK
> blocking condition is removed, if the vdpa tool query occurs earlier than
> the first set_driver_features() call from VMM, the following code will treat
> the guest as legacy and then trigger an erroneous
> vdpa_set_features_unlocked(... , 0) call to the vdpa driver:
> 
>  374         /*
>  375          * Config accesses aren't supposed to trigger before features
> are set.
>  376          * If it does happen we assume a legacy guest.
>  377          */
>  378         if (!vdev->features_valid)
>  379                 vdpa_set_features_unlocked(vdev, 0);
>  380         ops->get_config(vdev, offset, buf, len);
> 
> Depending on vendor driver's implementation, L380 may either return invalid
> config data (or invalid endianness if on BE) or only config fields that are
> valid in legacy layout. What's more severe is that, vdpa tool query in
> theory shouldn't affect feature negotiation at all by making confusing calls
> to the device, but now it is possible with the patch. Fixing this would
> require more delicate work on the other paths involving the cf_lock
> reader/write semaphore.
> 
> Not sure what you plan to do next, post the fixes for both issues and get
> the community review? Or simply revert the patch in question? Let us know.
> 
> Thanks,
> -Siwei
> 

I'm not sure who you are asking. I didn't realize this is so
controversial. If you feel it should be reverted I suggest
you post a revert patch with a detailed motivation and this
will get the discussion going.
It will also help if you stress whether you describe theoretical
issues or something observed in practice above
discussion does not make this clear.

-- 
MST

