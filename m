Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F68B56BB34
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 15:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237891AbiGHNv7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 09:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233022AbiGHNv5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 09:51:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7D5CD19034
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 06:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657288314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yVefCn2Sr2XDtcSF1e802d6x0OPOMy5L9rDF1Zp3WNI=;
        b=UCEeuR7V675yczouLZGyT2PSI0G2l2A5fjwFfsnzyKzbsEWdjFUZ8HAonxmeWeKU0e6VDG
        b3eUwQLbCuSzJVD8PWCDcNA6CVPaVXsqq24tVYHwsX0P1IA9RorxmdIJuNZP7bRZ2b1wC+
        BZugZVbAnviZda/AqEe/3Ok5qiE78Jc=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-3s3yqfxOM0aApaUTih8iPw-1; Fri, 08 Jul 2022 09:51:53 -0400
X-MC-Unique: 3s3yqfxOM0aApaUTih8iPw-1
Received: by mail-qt1-f199.google.com with SMTP id bs7-20020ac86f07000000b0031d3efbb91aso17522431qtb.21
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 06:51:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=yVefCn2Sr2XDtcSF1e802d6x0OPOMy5L9rDF1Zp3WNI=;
        b=tQXG1oMCIFdiiNFhFbe5cmBVIHX5Eq/AetKQ8GKg2xRacfWuiooUHjgKdXxamFr/WF
         BhiI2hyVziHCRr7MGMGL5L4UV6XcHznHUkKdahhH0QHEfvAw2SUEtnXhc+DtknuoIVRf
         hNoRuFWgkPSVO0VamWtOpUzyxuzwhhJZm+ym7/7hqvf0DULf92mKxKMj19aFjmXuedpt
         Xr2TNpzx5AQjkoE5hTYCc0MVde9fNwjzLHSeZuy7HuSz/uod86KzXqKHM9AXmIf/MRUT
         HbiIEHGvkEFsX3kYdRhn36bJjcwsrh877RC2YlMgelOpnu+0JLocuPQznGXHiisD+qid
         nBoQ==
X-Gm-Message-State: AJIora9av8/V8LhVlZac39jvtTtHhjP0LzCVoyOUo+FYU1iyjH1CXwGv
        EqBOGaeaaZlQ2YXCwAQDI3al37epvD1keUlz/eDaqFgxP6Mrk03odZNZxlZdt6FYoQceDcbeVNu
        S4o3uahj6wHch
X-Received: by 2002:a05:6214:20ea:b0:473:421d:d459 with SMTP id 10-20020a05621420ea00b00473421dd459mr1714729qvk.27.1657288313021;
        Fri, 08 Jul 2022 06:51:53 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s9HR4FiVcyVsBfX00aQKPJWG12vBD+uxGxuwJDaIa2y0QoQQjiF0NRy0pY+w9XGYubd8flkg==
X-Received: by 2002:a05:6214:20ea:b0:473:421d:d459 with SMTP id 10-20020a05621420ea00b00473421dd459mr1714693qvk.27.1657288312809;
        Fri, 08 Jul 2022 06:51:52 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-206.retail.telecomitalia.it. [79.46.200.206])
        by smtp.gmail.com with ESMTPSA id t14-20020a05620a004e00b006a6d20386f6sm31658212qkt.42.2022.07.08.06.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 06:51:50 -0700 (PDT)
Date:   Fri, 8 Jul 2022 15:51:38 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, Jason Wang <jasowang@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Cindy Lu <lulu@redhat.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "Uminski, Piotr" <Piotr.Uminski@intel.com>,
        habetsm.xilinx@gmail.com, "Dawar, Gautam" <gautam.dawar@amd.com>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Longpeng <longpeng2@huawei.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Martin Porter <martinpo@xilinx.com>,
        Eli Cohen <elic@nvidia.com>, ecree.xilinx@gmail.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: Re: [PATCH v6 2/4] vhost-vdpa: introduce SUSPEND backend feature bit
Message-ID: <20220708135138.kjdnnxelgll2p3cv@sgarzare-redhat>
References: <20220623160738.632852-1-eperezma@redhat.com>
 <20220623160738.632852-3-eperezma@redhat.com>
 <20220628134340.5fla7surd34bwnq3@sgarzare-redhat>
 <CAJaqyWd8yNdfGEDJ3Zesruh_Q0_9u_j80pad-FUA=oK=mvnLGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJaqyWd8yNdfGEDJ3Zesruh_Q0_9u_j80pad-FUA=oK=mvnLGQ@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 08, 2022 at 01:38:45PM +0200, Eugenio Perez Martin wrote:
>On Tue, Jun 28, 2022 at 3:43 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> On Thu, Jun 23, 2022 at 06:07:36PM +0200, Eugenio Pérez wrote:
>> >Userland knows if it can suspend the device or not by checking this feature
>> >bit.
>> >
>> >It's only offered if the vdpa driver backend implements the suspend()
>> >operation callback, and to offer it or userland to ack it if the backend
>> >does not offer that callback is an error.
>>
>> Should we document in the previous patch that the callback must be
>> implemented only if the drive/device support it?
>>
>
>It's marked as optional in the doc, following other optional callbacks
>like set_group_asid for example. But I'm ok with documenting this
>behavior further.
>
>> The rest LGTM although I have a doubt whether it is better to move this
>> patch after patch 3, or merge it with patch 3, for bisectability since
>> we enable the feature here but if the userspace calls ioctl() with
>> VHOST_VDPA_SUSPEND we reply back that it is not supported.
>>
>
>I'm fine with moving it, but we will have that behavior with all the
>devices anyway. Regarding userspace, we just replace ENOIOCTL with
>EOPNOTSUPP. Or I'm missing something?

Yep, you're right, this is fine! ;-)

Stefano

