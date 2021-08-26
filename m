Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E3D3F83D4
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 10:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240547AbhHZIha (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 04:37:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6514 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240351AbhHZIh3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 04:37:29 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17Q8aaRZ091959;
        Thu, 26 Aug 2021 04:36:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=W3XCYcUz9J5/hAW2mjZkntBmA3/2aSp+E6yAvrb7spU=;
 b=CYEry+AKZkeNVVFddzn574yRU6JcjC5kFjSXNvkLIl5dhysuKaDJXFL8001/A0uCe9lg
 OL19nL4Ncwed6gC7S7LFdwPihuFdYXm17beX6zFpAPkgrRILvR14j5ToIOI3pDHRM1dJ
 43gh8nnYxg81fj160GQ+u1KsqvPxXX47A52dQJI45hrc3dc2xfbTaxUMq5lEladJfOY8
 CBIKtdw594g+Y/fw1pxjAvqepazhcqYeseJKQNzGMsy74Z6RjBMNf+WU0YRn216ae2yc
 /hq08fI7IadwhDSkdCBNiUGYWxxg/GCzp8kP8NK/ylxzap3gDHVNIlNmcd47IXm7DNh+ gA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ap72pgskh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Aug 2021 04:36:42 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17Q8aggM092996;
        Thu, 26 Aug 2021 04:36:42 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ap72pgs6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Aug 2021 04:36:42 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17Q8XB7c026348;
        Thu, 26 Aug 2021 08:33:48 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3ajs490v9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Aug 2021 08:33:48 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17Q8XfOx11796810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Aug 2021 08:33:41 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FA0FA4084;
        Thu, 26 Aug 2021 08:33:41 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4C61A4057;
        Thu, 26 Aug 2021 08:33:39 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.32.161])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 26 Aug 2021 08:33:39 +0000 (GMT)
Subject: Re: [PATCH v4 13/14] KVM: s390: pv: lazy destroy for reboot
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
References: <20210818132620.46770-1-imbrenda@linux.ibm.com>
 <20210818132620.46770-14-imbrenda@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
Message-ID: <63a25b80-9dcf-7948-e2c3-88b8f9064736@linux.vnet.ibm.com>
Date:   Thu, 26 Aug 2021 10:33:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210818132620.46770-14-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1UZrufRMQtr9wSVDrviP86wPML_6Eyds
X-Proofpoint-ORIG-GUID: 0-Z5DjNoyOFwAP6tQ2AYHIklc-_VU9JY
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-26_01:2021-08-25,2021-08-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 priorityscore=1501 spamscore=0 phishscore=0
 adultscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108260050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 18.08.21 um 15:26 schrieb Claudio Imbrenda:
> Until now, destroying a protected guest was an entirely synchronous
> operation that could potentially take a very long time, depending on
> the size of the guest, due to the time needed to clean up the address
> space from protected pages.
> 
> This patch implements a lazy destroy mechanism, that allows a protected
> guest to reboot significantly faster than previously.
> 
> This is achieved by clearing the pages of the old guest in background.
> In case of reboot, the new guest will be able to run in the same
> address space almost immediately.
> 
> The old protected guest is then only destroyed when all of its memory has
> been destroyed or otherwise made non protected.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c |   6 +-
>  arch/s390/kvm/kvm-s390.h |   2 +-
>  arch/s390/kvm/pv.c       | 132 ++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 134 insertions(+), 6 deletions(-)
> 
[...]
> 
> +static int kvm_s390_pv_destroy_vm_thread(void *priv)
> +{
> +	struct deferred_priv *p = priv;
> +	u16 rc, rrc;
> +	int r;
> +
> +	/* Clear all the pages as long as we are not the only users of the mm */
> +	s390_uv_destroy_range(p->mm, 1, 0, TASK_SIZE_MAX);
> +	/*
> +	 * If we were the last user of the mm, synchronously free (and clear
> +	 * if needed) all pages.
> +	 * Otherwise simply decrease the reference counter; in this case we
> +	 * have already cleared all pages.
> +	 */
> +	mmput(p->mm);
> +
> +	r = uv_cmd_nodata(p->handle, UVC_CMD_DESTROY_SEC_CONF, &rc, &rrc);
> +	WARN_ONCE(r, "protvirt destroy vm failed rc %x rrc %x", rc, rrc);
> +	if (r) {
> +		mmdrop(p->mm);

The comment about leaking makes more sense here, no?
Also
		goto out_dont_free;
> +		return r;
> +	}
> +	atomic_dec(&p->mm->context.is_protected);
> +	mmdrop(p->mm);
> +
> +	/*
> +	 * Intentional leak in case the destroy secure VM call fails. The
> +	 * call should never fail if the hardware is not broken.
> +	 */
> +	free_pages(p->stor_base, get_order(uv_info.guest_base_stor_len));
> +	free_pages(p->old_table, CRST_ALLOC_ORDER);
> +	vfree(p->stor_var);
out_dont_free:
> +	kfree(p);
> +	return 0;
> +}
> +
[...]

