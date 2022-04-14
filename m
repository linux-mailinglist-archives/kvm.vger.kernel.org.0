Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F22A501480
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 17:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244894AbiDNOHM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 10:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347733AbiDNN7a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 09:59:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FADADD4C;
        Thu, 14 Apr 2022 06:52:08 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EC3x8m006615;
        Thu, 14 Apr 2022 13:52:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=oHY6GZiVb5HyuxgKDnBJtLv236U25bxeDI9Xv19FNTk=;
 b=gOHaXCF6Yb7Tdkl6Qe1YRyLuVxqrwiUjA5tyGFt/K/LWHAsrfBE8gJkT1t7iVBM4L7Yf
 /YBp6dsQn2s3j9urf4T7HQ5cvujwFnRvHGSXZtK4HnhfQvU2NwLDk4DLP7+Q+x0ev06p
 TUxvgqjNFo8bIUuTaTBLbaMT8gck8PIz55J7lYtwyWdjZfO8CVgTHObMU8ShTAd5RmJZ
 WnrfEPGqxtGbxaXcKLa6JIxWjU+arE1EcXyWIvqVkv68luZvUzO1WZct5BgfQ5vXMlQg
 Bt+TokHdsPhuG9T9CPZJoKNyuLetz2gKD44e5gHu1cxkLqe1MyMGDX5ga72vsmaRsEml fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fefh56up2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 13:52:00 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23EDTc1s002057;
        Thu, 14 Apr 2022 13:52:00 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fefh56unq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 13:51:59 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23EDhjun003747;
        Thu, 14 Apr 2022 13:51:58 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04wdc.us.ibm.com with ESMTP id 3fb1sa7ntq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 13:51:58 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23EDpvES13828434
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 13:51:57 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD049AE05F;
        Thu, 14 Apr 2022 13:51:57 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63B9AAE05C;
        Thu, 14 Apr 2022 13:51:50 +0000 (GMT)
Received: from [9.211.76.45] (unknown [9.211.76.45])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 14 Apr 2022 13:51:50 +0000 (GMT)
Message-ID: <d6e2778a-01e4-6468-2c2b-3b718d924e65@linux.ibm.com>
Date:   Thu, 14 Apr 2022 09:51:49 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 9/9] vfio: Remove calls to vfio_group_add_container_user()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
References: <9-v1-a8faf768d202+125dd-vfio_mdev_no_group_jgg@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <9-v1-a8faf768d202+125dd-vfio_mdev_no_group_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: p__mnI6kUAsRVhj3MeN1iQJ3xzHvSix8
X-Proofpoint-ORIG-GUID: eRlxuhpLbLi2wEFbBZUimbF33iPl8iJP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_04,2022-04-14_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 impostorscore=0 phishscore=0
 mlxlogscore=765 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140074
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/12/22 11:53 AM, Jason Gunthorpe wrote:
> When the open_device() op is called the container_users is incremented and
> held incremented until close_device(). Thus, so long as drivers call
> functions within their open_device()/close_device() region they do not
> need to worry about the container_users.
> 
> These functions can all only be called between
> open_device()/close_device():
> 
>    vfio_pin_pages()
>    vfio_unpin_pages()
>    vfio_dma_rw()
>    vfio_register_notifier()
>    vfio_unregister_notifier()
> 
> So eliminate the calls to vfio_group_add_container_user() and add a simple
> WARN_ON to detect mis-use by drivers.
> 

vfio_device_fops_release decrements dev->open_count immediately before 
calling dev->ops->close_device, which means we could enter close_device 
with a dev_count of 0.

Maybe vfio_device_fops_release should handle the same way as 
vfio_group_get_device_fd?

	if (device->open_count == 1 && device->ops->close_device)
		device->ops->close_device(device);
	device->open_count--;

