Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40211FA10
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 15:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbfD3N0W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 09:26:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57068 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728737AbfD3N0R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Apr 2019 09:26:17 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3UDHXQa016184
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2019 09:26:16 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2s6pa6awwn-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2019 09:26:15 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Tue, 30 Apr 2019 14:26:12 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 30 Apr 2019 14:26:08 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3UDQ7Lh45940956
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Apr 2019 13:26:07 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B13052050;
        Tue, 30 Apr 2019 13:26:07 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.116])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7C5575204F;
        Tue, 30 Apr 2019 13:26:06 +0000 (GMT)
Date:   Tue, 30 Apr 2019 15:26:05 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     borntraeger@de.ibm.com, alex.williamson@redhat.com,
        cohuck@redhat.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        frankja@linux.ibm.com, akrowiak@linux.ibm.com, david@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        freude@linux.ibm.com, mimu@linux.ibm.com
Subject: Re: [PATCH v7 3/4] s390: ap: implement PAPQ AQIC interception in
 kernel
In-Reply-To: <1556283688-556-4-git-send-email-pmorel@linux.ibm.com>
References: <1556283688-556-1-git-send-email-pmorel@linux.ibm.com>
        <1556283688-556-4-git-send-email-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19043013-0028-0000-0000-00000368E2DA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19043013-0029-0000-0000-00002428482B
Message-Id: <20190430152605.3bb21f31.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-30_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=827 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904300086
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 26 Apr 2019 15:01:27 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> +/**
> + * vfio_ap_clrirq: Disable Interruption for a APQN
> + *
> + * @dev: the device associated with the ap_queue
> + * @q:   the vfio_ap_queue holding AQIC parameters
> + *
> + * Issue the host side PQAP/AQIC
> + * On success: unpin the NIB saved in *q and unregister from GIB
> + * interface
> + *
> + * Return the ap_queue_status returned by the ap_aqic()
> + */
> +static struct ap_queue_status vfio_ap_clrirq(struct vfio_ap_queue *q)
> +{
> +	struct ap_qirq_ctrl aqic_gisa = {};
> +	struct ap_queue_status status;
> +	int checks = 10;
> +
> +	status = ap_aqic(q->apqn, aqic_gisa, NULL);
> +	if (!status.response_code) {
> +		while (status.irq_enabled && checks--) {
> +			msleep(20);

Hm, that seems like a lot of time to me. And I suppose we are holding the
kvm lock: e.g. no other instruction can be interpreted by kvm in the
meantime.

> +			status = ap_tapq(q->apqn, NULL);
> +		}
> +		if (checks >= 0)
> +			vfio_ap_free_irq_data(q);

Actually we don't have to wait for the async part to do it's magic
(indicated by the status.irq_enabled --> !status.irq_enabled transition)
in the instruction handler. We have to wait so we can unpin the NIB but
that could be done async (e.g. workqueue).

BTW do you have any measurements here? How many msleep(20) do we
experience for one clear on average?

If linux is not using clear (you told so offline, and I also remember
something similar), we can probably get away with something like this,
and do it properly (from performance standpoint) later.

Regards,
Halil

> +		else
> +			WARN_ONCE("%s: failed disabling IRQ", __func__);
> +	}
> +
> +	return status;
> +}

