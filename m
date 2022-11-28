Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEAA63ABFC
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 16:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbiK1PKs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 10:10:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbiK1PKl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 10:10:41 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A122122BE5
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 07:10:39 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ASDeULR031083
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 15:10:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=kWbIyMoVTQVX2FasDfS8T6yHLZ9VeLXUg3qusfXX6uo=;
 b=mNiaxlb9gDVg0t5txLMzPfT6ub649h+S9oRf67IB72A4v8Z49H1xYhQeYiiedAxLdVuW
 SSlRXM0vZjXV871pMH8WkvWE7yVEn2rQKOlotbM4GwCfXJVn96N3FWGG2CT8/05LV6eo
 Ewxr1SAtiWy/mq+7kJsJZvxQI1LAL5c6RKIJxUePMgVcPZSBubpeag3LnE0+ybaYdz+r
 9kct1PzweFRJVpuEg7yJXv01G2OiddiezFx4ixZc3e8fsUSDrSYXNkpAajRBOvwryx6e
 92WUrFP8H4iOBy9ZOmVrrVvaXnShE2bpngJR8vGLoeq79m8bj0gG/GKlQPE6l+QHiAya 5A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3vmrkaq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 15:10:39 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ASEfwpH028995
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 15:10:38 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3vmrkanw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 15:10:38 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ASF5Hv2026464;
        Mon, 28 Nov 2022 15:10:36 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3m3ae9ar7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 15:10:36 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ASFAXWb10814206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Nov 2022 15:10:33 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2690AA405B;
        Mon, 28 Nov 2022 15:10:33 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C847EA4054;
        Mon, 28 Nov 2022 15:10:32 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.179.31.174])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 28 Nov 2022 15:10:32 +0000 (GMT)
Message-ID: <80691035f83c3ceb1b0e576086c4a60689a32e99.camel@linux.ibm.com>
Subject: Re: [PATCH v1 1/1] lib: s390x: add smp_cpu_setup_cur_psw_mask
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        thuth@redhat.com
Date:   Mon, 28 Nov 2022 16:10:32 +0100
In-Reply-To: <20221128123834.21252-1-imbrenda@linux.ibm.com>
References: <20221128123834.21252-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1 (3.46.1-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aqNnSKXQQor27idOtq-Yau_-tanupjEf
X-Proofpoint-ORIG-GUID: 2oGzf6CXWJ2TwBJjeZAapLT2LsATuVnz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-28_13,2022-11-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 impostorscore=0 mlxscore=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211280112
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-11-28 at 13:38 +0100, Claudio Imbrenda wrote:
> Since a lot of code starts new CPUs using the current PSW mask, add a
> wrapper to streamline the operation and hopefully make the code of the
> tests more readable.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/smp.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
>=20
> diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
> index f4ae973d..0bcb1999 100644
> --- a/lib/s390x/smp.h
> +++ b/lib/s390x/smp.h
> @@ -47,4 +47,13 @@ void smp_setup(void);
>  int smp_sigp(uint16_t idx, uint8_t order, unsigned long parm, uint32_t *=
status);
>  struct lowcore *smp_get_lowcore(uint16_t idx);
> =20
> +static inline void smp_cpu_setup_cur_psw_mask(uint16_t idx, void *addr)
> +{
> +	struct psw psw =3D {
> +		.mask =3D extract_psw_mask(),
> +		.addr =3D (unsigned long)addr,
> +	};
> +	smp_cpu_setup(idx, psw);
> +}
> +
>  #endif

Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Although I would have expected you to also use the function.

I'm wondering if just improving the ergonomics of creating a psw would suff=
ice
#define PSW(m, a) ((struct psw){ .mask =3D (uint64_t)m, .addr =3D (uint64_t=
)a })

Then it would look like

smp_cpu_setup(idx, PSW(extract_psw_mask(), addr))

and the macro might come in handy in other situations, too, but I haven't s=
urveyed the code.
