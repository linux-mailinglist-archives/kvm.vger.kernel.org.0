Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15CDD4E8BCB
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 03:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbiC1Bz1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Mar 2022 21:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237406AbiC1BzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Mar 2022 21:55:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 86C862625
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 18:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648432424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2dO/oV1qOltZyPId5baa2irih13HA1zn6mOKO291fhY=;
        b=YJfwTswsCZlK+pdf2uysa8otMmCqxmZ/IDHxMRQryEBnthuXseoyj7YJqTcuEupepx/egY
        +LZZDB1L4LGAyH+DIhTaLttBYrpY5xzIQuPEaMoR3Ief5o+4IZLYZZCVS0tLGvqvn1qsk+
        Z29WDCfmPdLIYe3Uy9hhG/qCkU+ke9Q=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-256-j2BemGfQMIiuZyQlv6tnGw-1; Sun, 27 Mar 2022 21:53:40 -0400
X-MC-Unique: j2BemGfQMIiuZyQlv6tnGw-1
Received: by mail-lj1-f200.google.com with SMTP id h4-20020a2ea484000000b002480c04898aso5242303lji.6
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 18:53:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2dO/oV1qOltZyPId5baa2irih13HA1zn6mOKO291fhY=;
        b=T/je8Qx/0hnV8uyJS/DcDtIPoVwHYGxVlPI/74AnNhKX5sbl8y5bIOw++Xe57wViv7
         mrkcapLO2sx8m7Ebk/esSXRv9xW0BH1SNGrvK6PI/V9klPKsmnPIiwBJyKQjCZ3eQgwN
         T/jUGcVrPsz+EiS8rx4Fwh+pVF1ZnOnHYyNR0HrGcmbxYL0GOo2oo3f8mupyon+OEx8P
         7pNAZQyR6TQIkdKli9sV2hCMkA99q8Mi+CKAUWPC84LR60KtzCQ0lio0s8BMKcnINNxn
         YOfKzf5T8BU8yXutJIns0eFaTjWw5mXjUwBMFlEoRLPaTOsOVrmRFZzS1z3yp2S5cz43
         pV1Q==
X-Gm-Message-State: AOAM532vhcJBx3VEnay/LIg5BMTsATdSQ3wME1rlL3IKKfkfH93K+Ujc
        4IGKWPgECieSO00xeqjqKOmgF4vaT5YKVWIXVM0woeqJ/ZVrHy4KCZg4ma2Ifof9xkqPAstM9qs
        knkFrXCBG0AtpDZ99EHGzID6KnYGz
X-Received: by 2002:a05:6512:3341:b0:433:b033:bd22 with SMTP id y1-20020a056512334100b00433b033bd22mr17655625lfd.190.1648432419152;
        Sun, 27 Mar 2022 18:53:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxq8kzelEt+v1IsX1TZPbDlKbWX97klqcRsVueoo1G7JjrBUCzhgXc3wVkBT8uRlLsPpQUWTvhiKwixigMDGIE=
X-Received: by 2002:a05:6512:3341:b0:433:b033:bd22 with SMTP id
 y1-20020a056512334100b00433b033bd22mr17655598lfd.190.1648432418951; Sun, 27
 Mar 2022 18:53:38 -0700 (PDT)
MIME-Version: 1.0
References: <808a871b3918dc067031085de3e8af6b49c6ef89.camel@linux.ibm.com>
 <20220322145741.GH11336@nvidia.com> <20220322092923.5bc79861.alex.williamson@redhat.com>
 <20220322161521.GJ11336@nvidia.com> <BN9PR11MB5276BED72D82280C0A4C6F0C8C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CACGkMEutpbOc_+5n3SDuNDyHn19jSH4ukSM9i0SUgWmXDydxnA@mail.gmail.com>
 <BN9PR11MB5276E3566D633CEE245004D08C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CACGkMEvTmCFqAsc4z=2OXOdr7X--0BSDpH06kCiAP5MHBjaZtg@mail.gmail.com>
 <BN9PR11MB5276ECF1F1C7D0A80DA086D18C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CACGkMEtpWemw6tj=suxNjvSHuixyzhMJBYmqdbhQkinuWNADCQ@mail.gmail.com> <20220324114605.GX11336@nvidia.com>
In-Reply-To: <20220324114605.GX11336@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 28 Mar 2022 09:53:27 +0800
Message-ID: <CACGkMEtTVMuc-JebEbTrb3vRUVaNJ28FV_VyFRdRquVQN9VeQA@mail.gmail.com>
Subject: Re: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be usable
 for iommufd
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Sean Mooney <smooney@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 24, 2022 at 7:46 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Thu, Mar 24, 2022 at 11:50:47AM +0800, Jason Wang wrote:
>
> > It's simply because we don't want to break existing userspace. [1]
>
> I'm still waiting to hear what exactly breaks in real systems.
>
> As I explained this is not a significant change, but it could break
> something in a few special scenarios.
>
> Also the one place we do have ABI breaks is security, and ulimit is a
> security mechanism that isn't working right. So we do clearly need to
> understand *exactly* what real thing breaks - if anything.
>
> Jason
>

To tell the truth, I don't know. I remember that Openstack may do some
accounting so adding Sean for more comments. But we really can't image
openstack is the only userspace that may use this.

To me, it looks more easier to not answer this question by letting
userspace know about the change,

Thanks

