Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EF728F1DF
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 14:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgJOMMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Oct 2020 08:12:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34945 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgJOMMu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Oct 2020 08:12:50 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kT27k-00063J-NC; Thu, 15 Oct 2020 12:12:48 +0000
From:   Colin Ian King <colin.king@canonical.com>
Subject: re: vfio/fsl-mc: trigger an interrupt via eventfd
To:     Diana Craciun <diana.craciun@oss.nxp.com>, kvm@vger.kernel.org
Cc:     Bharat Bhushan <Bharat.Bhushan@nxp.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <3b376171-8ca8-a4ad-cbbb-8deeb3cd9bca@canonical.com>
Date:   Thu, 15 Oct 2020 13:12:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Static analysis with Coverity on linux-next today has detected an issue
in the following commit:

commit cc0ee20bd96971c10eba9a83ecf1c0733078a083
Author: Diana Craciun <diana.craciun@oss.nxp.com>
Date:   Mon Oct 5 20:36:52 2020 +0300

    vfio/fsl-mc: trigger an interrupt via eventfd


The analysis is as follows:

106 static int vfio_fsl_mc_set_irq_trigger(struct vfio_fsl_mc_device *vdev,
107                                       unsigned int index, unsigned
int start,
108                                       unsigned int count, u32 flags,
109                                       void *data)
110 {
111        struct fsl_mc_device *mc_dev = vdev->mc_dev;
112        int ret, hwirq;
113        struct vfio_fsl_mc_irq *irq;
114        struct device *cont_dev = fsl_mc_cont_dev(&mc_dev->dev);
115        struct fsl_mc_device *mc_cont = to_fsl_mc_device(cont_dev);
116

cond_const: Condition count != 1U, taking false branch. Now the value of
count is equal to 1.

117        if (start != 0 || count != 1)
118                return -EINVAL;
119
120        mutex_lock(&vdev->reflck->lock);
121        ret = fsl_mc_populate_irq_pool(mc_cont,
122                        FSL_MC_IRQ_POOL_MAX_TOTAL_IRQS);
123        if (ret)
124                goto unlock;
125
126        ret = vfio_fsl_mc_irqs_allocate(vdev);
127        if (ret)
128                goto unlock;
129        mutex_unlock(&vdev->reflck->lock);
130

const: At condition count, the value of count must be equal to 1.
dead_error_condition: The condition !count cannot be true.

Logically dead code (DEADCODE)
dead_error_line: Execution cannot reach the expression flags & 1U inside
this statement: if (!count && flags & 1U)

 ....
131        if (!count && (flags & VFIO_IRQ_SET_DATA_NONE))
132                return vfio_set_trigger(vdev, index, -1);

At line 131, count is 1 because of the check and return on lines
117-118.  !count is 0, and so 0 && (flags & VFIO_IRQ_SET_DATA_NONE) is
always false, so the vfio_set_trigger is never called. I suspect that
was not the intention.

Colin
