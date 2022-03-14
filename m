Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3904D8B08
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 18:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242402AbiCNRrQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 13:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiCNRrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 13:47:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4BB29DEB5
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 10:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647279964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YEJG0IObRkUr69r2f7J23FXjPgRCTJSeRdoCwh8LUrA=;
        b=iuPIKwDsMqOXtJawwR5UZVez5uH2iIjq+7iu6F1pHglL6Uz1df8OoydeVhPsDnuoIw//WG
        lxSUwO+SdpU6h5p9K0cWWeeQBqzORSXmeMILn+pEkMGaJatU9Ath/zNs7HDDIwLpFJsMoV
        5LpuCvUeKtSryiqRCNZQCadxef9F6Xc=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-141-L1KL-u85M5qCHUpgkD3MUw-1; Mon, 14 Mar 2022 13:46:03 -0400
X-MC-Unique: L1KL-u85M5qCHUpgkD3MUw-1
Received: by mail-il1-f198.google.com with SMTP id k5-20020a926f05000000b002be190db91cso9715058ilc.11
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 10:46:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YEJG0IObRkUr69r2f7J23FXjPgRCTJSeRdoCwh8LUrA=;
        b=PPbuxcLayP/xBgDtPEN30MvoK6dA6YsvMCT6IH7RKVAkuk4bXI+3Oa1BemvySCagkQ
         jb36mczhuM50iwAY07W1qqals+Eki6im7owmNssRdOQf/xhu9+ii2k3C/afyJl8T81Uq
         YdNVA7StbzVB9DblOQwdJoPm85T+BLX+6SOdrWhtzHOF2jy76+wz5hh/juoUobOYeRTW
         nutpSuKA0aBn5av8UMSFAZYCux5cCMTXlHXsTQZvYkGM+pFHCu93uhk1+7tuDKHsQXrK
         jd/3L/C7RdaJo17ZMRLCPbp9R7EY/7sKIvE1WHP2QKPZZIlKVSApJOfQBJgRtH35qUec
         oB9w==
X-Gm-Message-State: AOAM531cK2N+0HNKsYGrM6w0mD8f56ky0wxby0h4ttKtKhaAvjtzR8Ln
        niBOSH8QfJ98nnuBDOHE/80MAamRcf2bCGyg5J7Jecfj+wsERj/go/EqVcIXhr74uNsrPcev6PH
        JYHyy+bMksghB
X-Received: by 2002:a05:6602:3c5:b0:613:8644:591c with SMTP id g5-20020a05660203c500b006138644591cmr20675139iov.161.1647279961388;
        Mon, 14 Mar 2022 10:46:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZJJA4WojvmGdmtZ74f1wNxVgekXaAUaGHvuviIsQF6/0w1VCSMfKnNrXxBYkfIXxrO2Rn+w==
X-Received: by 2002:a05:6602:3c5:b0:613:8644:591c with SMTP id g5-20020a05660203c500b006138644591cmr20675084iov.161.1647279960174;
        Mon, 14 Mar 2022 10:46:00 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id b2-20020a923402000000b002c25b16552fsm9227068ila.14.2022.03.14.10.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 10:45:59 -0700 (PDT)
Date:   Mon, 14 Mar 2022 11:45:58 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        Linuxarm <linuxarm@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v9 0/9] vfio/hisilicon: add ACC live migration driver
Message-ID: <20220314114558.2cdd57fc.alex.williamson@redhat.com>
In-Reply-To: <df217839a41b47dc94ef201dfe379e4e@huawei.com>
References: <20220308184902.2242-1-shameerali.kolothum.thodi@huawei.com>
        <df217839a41b47dc94ef201dfe379e4e@huawei.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 14 Mar 2022 17:26:59 +0000
Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:

> Hi Alex,
>=20
> > -----Original Message-----
> > From: Shameerali Kolothum Thodi
> > Sent: 08 March 2022 18:49
> > To: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linux-crypto@vger.kernel.org
> > Cc: linux-pci@vger.kernel.org; alex.williamson@redhat.com; jgg@nvidia.c=
om;
> > cohuck@redhat.com; mgurtovoy@nvidia.com; yishaih@nvidia.com;
> > kevin.tian@intel.com; Linuxarm <linuxarm@huawei.com>; liulongfang
> > <liulongfang@huawei.com>; Zengtao (B) <prime.zeng@hisilicon.com>;
> > Jonathan Cameron <jonathan.cameron@huawei.com>; Wangzhou (B)
> > <wangzhou1@hisilicon.com>
> > Subject: [PATCH v9 0/9] vfio/hisilicon: add ACC live migration driver
> >=20
> > Hi,
> >=20
> > This series attempts to add vfio live migration support for HiSilicon
> > ACC VF devices based on the new v2 migration protocol definition and
> > mlx5 v9 series discussed here[0].
> >=20
> > v8 --> v9
> > =C2=A0- Added acks by Wangzhou/Longfang/Yekai
> > =C2=A0- Added R-by tags by Jason.
> > =C2=A0- Addressed comments=C2=A0by Alex on v8.
> > =C2=A0- Fixed the pf_queue pointer assignment error in patch #8.
> > =C2=A0- Addressed=C2=A0comments from Kevin,
> >  =C2=A0 =C2=A0-Updated patch #5 commit log msg with a clarification tha=
t VF
> > =C2=A0 =C2=A0 =C2=A0migration BAR assignment is fine if migration suppo=
rt is not there.
> >  =C2=A0 =C2=A0-Added QM description to patch #8 commit msg. =20
>=20
> Hope there is nothing pending for this series now to make it to next.
> I know ack from Bjorn is still pending for patch #3, and I have
> sent a ping last week and also CCd him on that patch.
>=20
> Please let me know if there is anything I missed.=20

Hi Shameer,

Nothing still pending from my end, as soon as we can get an ack on
patch #3 and barring issues in the interim, I'll merge it.  Thanks,

Alex

