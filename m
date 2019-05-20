Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4072124229
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 22:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbfETUfG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 16:35:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34030 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725776AbfETUfG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 May 2019 16:35:06 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4KKVlRr079305
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 16:35:05 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sm0p7wy1c-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 16:35:04 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <alifm@linux.ibm.com>;
        Mon, 20 May 2019 21:35:03 +0100
Received: from b01cxnp22035.gho.pok.ibm.com (9.57.198.25)
        by e16.ny.us.ibm.com (146.89.104.203) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 20 May 2019 21:35:01 +0100
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4KKZ0Kv14549014
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 20:35:00 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B925AAE064;
        Mon, 20 May 2019 20:35:00 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA004AE060;
        Mon, 20 May 2019 20:35:00 +0000 (GMT)
Received: from [9.56.58.54] (unknown [9.56.58.54])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 20 May 2019 20:35:00 +0000 (GMT)
Subject: Re: [PATCH v3 1/3] s390/cio: Don't pin vfio pages for empty transfers
To:     Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20190516161403.79053-1-farman@linux.ibm.com>
 <20190516161403.79053-2-farman@linux.ibm.com>
From:   Farhan Ali <alifm@linux.ibm.com>
Date:   Mon, 20 May 2019 16:35:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190516161403.79053-2-farman@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19052020-0072-0000-0000-000004308A35
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011132; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01206185; UDB=6.00633351; IPR=6.00987144;
 MB=3.00026974; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-20 20:35:03
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052020-0073-0000-0000-00004C4BD507
Message-Id: <619e473b-372f-6e6d-20e8-63f50225c599@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-20_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905200128
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05/16/2019 12:14 PM, Eric Farman wrote:
> The skip flag of a CCW offers the possibility of data not being
> transferred, but is only meaningful for certain commands.
> Specifically, it is only applicable for a read, read backward, sense,
> or sense ID CCW and will be ignored for any other command code
> (SA22-7832-11 page 15-64, and figure 15-30 on page 15-75).
> 
> (A sense ID is xE4, while a sense is x04 with possible modifiers in the
> upper four bits.  So we will cover the whole "family" of sense CCWs.)
> 
> For those scenarios, since there is no requirement for the target
> address to be valid, we should skip the call to vfio_pin_pages() and
> rely on the IDAL address we have allocated/built for the channel
> program.  The fact that the individual IDAWs within the IDAL are
> invalid is fine, since they aren't actually checked in these cases.
> 
> Set pa_nr to zero when skipping the pfn_array_pin() call, since it is
> defined as the number of pages pinned and is used to determine
> whether to call vfio_unpin_pages() upon cleanup.
> 
> As we do this, since the pfn_array_pin() routine returns the number of
> pages pinned, and we might not be doing that, the logic for converting
> a CCW from direct-addressed to IDAL needs to ensure there is room for
> one IDAW in the IDAL being built since a zero-length IDAL isn't great.
> 
> Signed-off-by: Eric Farman<farman@linux.ibm.com>
> ---
>   drivers/s390/cio/vfio_ccw_cp.c | 55 ++++++++++++++++++++++++++++++----
>   1 file changed, 50 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 086faf2dacd3..0467838aed23 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -294,6 +294,10 @@ static long copy_ccw_from_iova(struct channel_program *cp,
>   /*
>    * Helpers to operate ccwchain.
>    */
> +#define ccw_is_read(_ccw) (((_ccw)->cmd_code & 0x03) == 0x02)
> +#define ccw_is_read_backward(_ccw) (((_ccw)->cmd_code & 0x0F) == 0x0C)
> +#define ccw_is_sense(_ccw) (((_ccw)->cmd_code & 0x0F) == CCW_CMD_BASIC_SENSE)
> +
>   #define ccw_is_test(_ccw) (((_ccw)->cmd_code & 0x0F) == 0)
>   
>   #define ccw_is_noop(_ccw) ((_ccw)->cmd_code == CCW_CMD_NOOP)
> @@ -301,10 +305,39 @@ static long copy_ccw_from_iova(struct channel_program *cp,
>   #define ccw_is_tic(_ccw) ((_ccw)->cmd_code == CCW_CMD_TIC)
>   
>   #define ccw_is_idal(_ccw) ((_ccw)->flags & CCW_FLAG_IDA)
> -
> +#define ccw_is_skip(_ccw) ((_ccw)->flags & CCW_FLAG_SKIP)
>   
>   #define ccw_is_chain(_ccw) ((_ccw)->flags & (CCW_FLAG_CC | CCW_FLAG_DC))
>   
> +/*
> + * ccw_does_data_transfer()
> + *
> + * Determine whether a CCW will move any data, such that the guest pages
> + * would need to be pinned before performing the I/O.
> + *
> + * Returns 1 if yes, 0 if no.
> + */
> +static inline int ccw_does_data_transfer(struct ccw1 *ccw)
> +{
> +	/* If the skip flag is off, then data will be transferred */
> +	if (!ccw_is_skip(ccw))
> +		return 1;
> +
> +	/*
> +	 * If the skip flag is on, it is only meaningful if the command
> +	 * code is a read, read backward, sense, or sense ID.  In those
> +	 * cases, no data will be transferred.
> +	 */
> +	if (ccw_is_read(ccw) || ccw_is_read_backward(ccw))
> +		return 0;
> +
> +	if (ccw_is_sense(ccw))
> +		return 0;

Just out of curiosity, is there a reason we are checking ccw_is_sense in 
a separate if statement?

> +
> +	/* The skip flag is on, but it is ignored for this command code. */
> +	return 1;
> +}

