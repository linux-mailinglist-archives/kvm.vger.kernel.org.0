Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB63B26DE65
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 16:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbgIQOjA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 10:39:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57648 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727308AbgIQOiD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 10:38:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600353427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D7Y4Bb0REAA01/yalsAXcLlACWLJwg5WgAp2JXMzOqo=;
        b=Wx6TD+VUFXKx7eNK3ZfiOdokAudfp1BTl5a332TiWFdD1TYNdda4r+9BzYL84yJNYM8cZq
        C0CtZIkqhJNHEhZNfQ8MSkR4AzV9kmNwV5w3q25dKhCXiK1dpSoT1Jkoh/6dqzd2KN2mFk
        h4fHCxS1Tzlj1lK1Zu9pDtD0py2Gkxc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-7lN7k9JmO2CNErGYpNJHpA-1; Thu, 17 Sep 2020 10:35:02 -0400
X-MC-Unique: 7lN7k9JmO2CNErGYpNJHpA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B93A79CC03;
        Thu, 17 Sep 2020 14:34:59 +0000 (UTC)
Received: from gondolin (ovpn-113-19.ams2.redhat.com [10.36.113.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A7EE68871;
        Thu, 17 Sep 2020 14:34:51 +0000 (UTC)
Date:   Thu, 17 Sep 2020 16:34:48 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v10 07/16] s390/vfio-ap: sysfs attribute to display the
 guest's matrix
Message-ID: <20200917163448.4db80db3.cohuck@redhat.com>
In-Reply-To: <20200821195616.13554-8-akrowiak@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
        <20200821195616.13554-8-akrowiak@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Aug 2020 15:56:07 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The matrix of adapters and domains configured in a guest's CRYCB may
> differ from the matrix of adapters and domains assigned to the matrix mdev,
> so this patch introduces a sysfs attribute to display the matrix of a guest
> using the matrix mdev. For a matrix mdev denoted by $uuid, the crycb for a
> guest using the matrix mdev can be displayed as follows:
> 
>    cat /sys/devices/vfio_ap/matrix/$uuid/guest_matrix
> 
> If a guest is not using the matrix mdev at the time the crycb is displayed,
> an error (ENODEV) will be returned.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 58 +++++++++++++++++++++++++++++++
>  1 file changed, 58 insertions(+)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index efb229033f9e..30bf23734af6 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1119,6 +1119,63 @@ static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
>  }
>  static DEVICE_ATTR_RO(matrix);
>  
> +static ssize_t guest_matrix_show(struct device *dev,
> +				 struct device_attribute *attr, char *buf)
> +{
> +	struct mdev_device *mdev = mdev_from_dev(dev);
> +	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> +	char *bufpos = buf;
> +	unsigned long apid;
> +	unsigned long apqi;
> +	unsigned long apid1;
> +	unsigned long apqi1;
> +	unsigned long napm_bits = matrix_mdev->shadow_apcb.apm_max + 1;
> +	unsigned long naqm_bits = matrix_mdev->shadow_apcb.aqm_max + 1;
> +	int nchars = 0;
> +	int n;
> +
> +	if (!vfio_ap_mdev_has_crycb(matrix_mdev))
> +		return -ENODEV;
> +
> +	apid1 = find_first_bit_inv(matrix_mdev->shadow_apcb.apm, napm_bits);
> +	apqi1 = find_first_bit_inv(matrix_mdev->shadow_apcb.aqm, naqm_bits);
> +
> +	mutex_lock(&matrix_dev->lock);
> +
> +	if ((apid1 < napm_bits) && (apqi1 < naqm_bits)) {
> +		for_each_set_bit_inv(apid, matrix_mdev->shadow_apcb.apm,
> +				     napm_bits) {
> +			for_each_set_bit_inv(apqi,
> +					     matrix_mdev->shadow_apcb.aqm,
> +					     naqm_bits) {
> +				n = sprintf(bufpos, "%02lx.%04lx\n", apid,
> +					    apqi);
> +				bufpos += n;
> +				nchars += n;
> +			}
> +		}
> +	} else if (apid1 < napm_bits) {
> +		for_each_set_bit_inv(apid, matrix_mdev->shadow_apcb.apm,
> +				     napm_bits) {
> +			n = sprintf(bufpos, "%02lx.\n", apid);
> +			bufpos += n;
> +			nchars += n;
> +		}
> +	} else if (apqi1 < naqm_bits) {
> +		for_each_set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm,
> +				     naqm_bits) {
> +			n = sprintf(bufpos, ".%04lx\n", apqi);
> +			bufpos += n;
> +			nchars += n;
> +		}
> +	}
> +
> +	mutex_unlock(&matrix_dev->lock);
> +
> +	return nchars;
> +}

This basically looks like a version of matrix_show() operating on the
shadow apcb. I'm wondering if we could consolidate these two functions
by passing in the structure to operate on as a parameter? Might not be
worth the effort, though.

