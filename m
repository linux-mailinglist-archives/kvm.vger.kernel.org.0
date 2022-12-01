Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D756163F19E
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 14:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbiLAN3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 08:29:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiLAN3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 08:29:31 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835DCA9E8B
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 05:29:30 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B1DEX8W026956
        for <kvm@vger.kernel.org>; Thu, 1 Dec 2022 13:29:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=23QTgNHWNa/GlrEN8huepuOrsi0rN7yrQwYJo3+si8k=;
 b=WEtTQFBe4Xu8XCk23iqWfReyse8N+5JDdRF8rDoMOXag0ViG76qiPETDP9FRIzZeaLTR
 NdB3y/rB2slFNOFjQTjDUFhZ7pOgIYeLwXX3PTbmIEW2NkGKWhzhvkTYpgRt7y6Hk30/
 2zDIoWplmXaWWNFlpb+OZYZRsC9o+W641vpE5edEUWrfkparA3UOnDakEuUYJ/nl380e
 SbsWT7hV/Vp+9gi/rK2TUK+hpfy9lkFa921wqExBr8uOk0vCdzOx8RGcW6pQD2bsI7MZ
 66eMnzYPEHra+MlegmSiYHfhpksOQvUCPacaHc10LQumNvjiNgQ1rpGSA0J0u0i4tw9p ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6vyngcfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 13:29:30 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B1DFcfe032181
        for <kvm@vger.kernel.org>; Thu, 1 Dec 2022 13:29:29 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6vyngcen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 13:29:29 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B1DLm3U020270;
        Thu, 1 Dec 2022 13:29:27 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3m3ae95brx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 13:29:27 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B1DU7lH63570390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Dec 2022 13:30:07 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECA6DA404D;
        Thu,  1 Dec 2022 13:29:23 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC928A4040;
        Thu,  1 Dec 2022 13:29:23 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Dec 2022 13:29:23 +0000 (GMT)
Date:   Thu, 1 Dec 2022 14:27:58 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 2/3] lib: s390x: skey: add seed value
 for storage keys
Message-ID: <20221201142758.4ac860d2@p-imbrenda>
In-Reply-To: <20221201084642.3747014-3-nrb@linux.ibm.com>
References: <20221201084642.3747014-1-nrb@linux.ibm.com>
        <20221201084642.3747014-3-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HJfxePODTU5_qPc7imSKY_QLPuoNcgcF
X-Proofpoint-GUID: yc06o9JK_uIFyNeDIdaHYIFZ86LcPLFU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_04,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=965 phishscore=0 spamscore=0
 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  1 Dec 2022 09:46:41 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> Upcoming changes will change storage keys in a loop. To make sure each
> iteration of the loops sets different keys, add variants of the storage
> key library functions which allow to specify a seed.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

I wonder if you can simply merge this patch with the previous one

> ---
>  lib/s390x/skey.c | 12 +++++++-----
>  lib/s390x/skey.h | 14 ++++++++++++--
>  2 files changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/s390x/skey.c b/lib/s390x/skey.c
> index 100f0949a244..4ab0828ee98f 100644
> --- a/lib/s390x/skey.c
> +++ b/lib/s390x/skey.c
> @@ -14,10 +14,11 @@
>  #include <skey.h>
>  
>  /*
> - * Set storage keys on pagebuf.
> + * Set storage keys on pagebuf with a seed for the storage keys.
>   * pagebuf must point to page_count consecutive pages.
> + * Only the lower seven bits of the seed are considered.
>   */
> -void skey_set_keys(uint8_t *pagebuf, unsigned long page_count)
> +void skey_set_keys_with_seed(uint8_t *pagebuf, unsigned long page_count, unsigned char seed)
>  {
>  	unsigned char key_to_set;
>  	unsigned long i;
> @@ -30,7 +31,7 @@ void skey_set_keys(uint8_t *pagebuf, unsigned long page_count)
>  		 * protection as well as reference and change indication for
>  		 * some keys.
>  		 */
> -		key_to_set = i * 2;
> +		key_to_set = (i ^ seed) * 2;
>  		set_storage_key(pagebuf + i * PAGE_SIZE, key_to_set, 1);
>  	}
>  }
> @@ -38,13 +39,14 @@ void skey_set_keys(uint8_t *pagebuf, unsigned long page_count)
>  /*
>   * Verify storage keys on pagebuf.
>   * Storage keys must have been set by skey_set_keys on pagebuf before.
> + * skey_set_keys must have been called with the same seed value.
>   *
>   * If storage keys match the expected result, will return a skey_verify_result
>   * with verify_failed false. All other fields are then invalid.
>   * If there is a mismatch, returned struct will have verify_failed true and will
>   * be filled with the details on the first mismatch encountered.
>   */
> -struct skey_verify_result skey_verify_keys(uint8_t *pagebuf, unsigned long page_count)
> +struct skey_verify_result skey_verify_keys_with_seed(uint8_t *pagebuf, unsigned long page_count, unsigned char seed)
>  {
>  	union skey expected_key, actual_key;
>  	struct skey_verify_result result = {
> @@ -56,7 +58,7 @@ struct skey_verify_result skey_verify_keys(uint8_t *pagebuf, unsigned long page_
>  	for (i = 0; i < page_count; i++) {
>  		cur_page = pagebuf + i * PAGE_SIZE;
>  		actual_key.val = get_storage_key(cur_page);
> -		expected_key.val = i * 2;
> +		expected_key.val = (i ^ seed) * 2;
>  
>  		/*
>  		 * The PoP neither gives a guarantee that the reference bit is
> diff --git a/lib/s390x/skey.h b/lib/s390x/skey.h
> index a0f8caa1270b..bba1c131276d 100644
> --- a/lib/s390x/skey.h
> +++ b/lib/s390x/skey.h
> @@ -23,9 +23,19 @@ struct skey_verify_result {
>  	unsigned long page_mismatch_addr;
>  };
>  
> -void skey_set_keys(uint8_t *pagebuf, unsigned long page_count);
> +void skey_set_keys_with_seed(uint8_t *pagebuf, unsigned long page_count, unsigned char seed);
>  
> -struct skey_verify_result skey_verify_keys(uint8_t *pagebuf, unsigned long page_count);
> +static inline void skey_set_keys(uint8_t *pagebuf, unsigned long page_count)
> +{
> +	skey_set_keys_with_seed(pagebuf, page_count, 0);
> +}
> +
> +struct skey_verify_result skey_verify_keys_with_seed(uint8_t *pagebuf, unsigned long page_count, unsigned char seed);
> +
> +static inline struct skey_verify_result skey_verify_keys(uint8_t *pagebuf, unsigned long page_count)
> +{
> +	return skey_verify_keys_with_seed(pagebuf, page_count, 0);
> +}
>  
>  void skey_report_verify(struct skey_verify_result * const result);
>  

