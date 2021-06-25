Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA2C3B3E61
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 10:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhFYIXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 04:23:14 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:1454 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229799AbhFYIXN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 04:23:13 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15P8I3VZ013825;
        Fri, 25 Jun 2021 08:20:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=4GSlOqBzMi6ZvKcdjof/bFT97MKGX+sEIaqyog7N84E=;
 b=DKV4PoH+KYVAFh3URyu5VG6RApRYUKmp/1Zl0T4QBmUD+lm8XJxndntAbBrx2sxOdo5a
 0eF1SsuywBiQ1dd6MsdsEqnZ4Ed/RWIgxa+yqBz0ODIT6eK2zaqwZcBfmNsc1j7QvkRO
 l1F9zCCpaT+BvpYnTEbZ2wxeqwb4cntayC9DgwvYj0TuvrGcgqIXwvnUDnZnshvyRzqx
 I1KoS2FlSDabETjkQnbAOl92IsczzYiVB+QcCO1UexJ3hFEOMP8dKP30YDyzU0uG5BCe
 n8fNxWt8hXAJsfYTCjj7bUJo+3q5c+2S0fuGLH2JTQbyd0fypaXqMcxlq4qsnxH8bvtO 9A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39d2pe8qyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 08:20:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15P8FmPM101835;
        Fri, 25 Jun 2021 08:20:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 39d2pxv08w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 08:20:52 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15P8IkOB109476;
        Fri, 25 Jun 2021 08:20:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 39d2pxv08a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 08:20:52 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 15P8KoOn011748;
        Fri, 25 Jun 2021 08:20:50 GMT
Received: from mwanda (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Jun 2021 01:20:49 -0700
Date:   Fri, 25 Jun 2021 11:20:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     jgg@ziepe.ca
Cc:     kvm@vger.kernel.org
Subject: [bug report] vfio/mtty: Convert to use vfio_register_group_dev()
Message-ID: <YNWR3PwALrq98NNU@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-GUID: fbtR8yMVKjZ8FI-wL4PhA1-HyPrYqOAI
X-Proofpoint-ORIG-GUID: fbtR8yMVKjZ8FI-wL4PhA1-HyPrYqOAI
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Jason Gunthorpe,

The patch 09177ac91921: "vfio/mtty: Convert to use
vfio_register_group_dev()" from Jun 17, 2021, leads to the following
static checker warning:

	samples/vfio-mdev/mtty.c:742 mtty_probe()
	warn: '&mdev_state->next' not removed from list

samples/vfio-mdev/mtty.c
   730  
   731          mutex_init(&mdev_state->ops_lock);
   732          mdev_state->mdev = mdev;
   733  
   734          mtty_create_config_space(mdev_state);
   735  
   736          mutex_lock(&mdev_list_lock);
   737          list_add(&mdev_state->next, &mdev_devices_list);
                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   738          mutex_unlock(&mdev_list_lock);
   739  
   740          ret = vfio_register_group_dev(&mdev_state->vdev);
   741          if (ret) {
   742                  kfree(mdev_state);
                              ^^^^^^^^^^
This is still on the list so it will lead to a user after free.

   743                  return ret;
   744          }
   745          dev_set_drvdata(&mdev->dev, mdev_state);
   746          return 0;

regards,
dan carpenter
