Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D35163BE35
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 11:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbiK2KqD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 05:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbiK2KqA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 05:46:00 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91545F874
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 02:45:58 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AT8pnGO028167
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 10:45:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=l2yZgrXtKT18wCh8D42EGmtVz1Nq2DX49eHMOQZy+Tk=;
 b=I7zQ5p83vizfFqye9J22C/6cN5I/m/y5eJEa4nHOqgTW2vV+yGXqngNBUz4z41LDFALQ
 buvfW3oDluB0UqaeB6P6zz5tAN1Gb/A2RbPlEgC+ie2/l5weRj7AGTgisciwHN6zQk34
 0jU7YHgt/g9joSSH+l4D1V1qkcBP6HM2pj3t9QHlrTDR6PuJVT+b4D3G3Buu3XaLopBD
 8KAT6VM4hTsq/4Froasau6T6LWO4zPmAiUIQTcGCbbLu/hCDswFRqijP2JxH/Y/6kRIF
 VpYdf84Nn2wm6Y0kf/ut3Vgn2YoidYsxxYjNQcFPqjMQMbMDppf/xIWHHlpMtyEOwYA5 Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m5ckmefy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 10:45:57 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AT9jdU5001268
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 10:45:57 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m5ckmefx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 10:45:57 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ATAasD2030960;
        Tue, 29 Nov 2022 10:45:55 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3m3ae92u1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 10:45:54 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ATAkYwJ12190208
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Nov 2022 10:46:34 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 988BA4203F;
        Tue, 29 Nov 2022 10:45:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41C6742041;
        Tue, 29 Nov 2022 10:45:51 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.61.66])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Nov 2022 10:45:51 +0000 (GMT)
Message-ID: <2b33fe2cf1d0416793a5555f84cef770a232631d.camel@linux.ibm.com>
Subject: Re: [PATCH v2 1/2] lib: s390x: add PSW and PSW_CUR_MASK macros
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        thuth@redhat.com
Date:   Tue, 29 Nov 2022 11:45:51 +0100
In-Reply-To: <20221129094142.10141-2-imbrenda@linux.ibm.com>
References: <20221129094142.10141-1-imbrenda@linux.ibm.com>
         <20221129094142.10141-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1 (3.46.1-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: x3_Pml3-I2QhKr6p_adVTH0Sb5x2_Io-
X-Proofpoint-ORIG-GUID: nj3a9RoAv-k1Pp9nFrZIWkPL--TDKodl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_07,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 phishscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211290065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-11-29 at 10:41 +0100, Claudio Imbrenda wrote:
> Since a lot of code starts new CPUs using the current PSW mask, add two
> macros to streamline the creation of generic PSWs and PSWs with the
> current program mask.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

> ---
>  lib/s390x/asm/arch_def.h | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 783a7eaa..43137d5f 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -41,6 +41,8 @@ struct psw {
>  	uint64_t	addr;
>  };
> =20
> +#define PSW(m, a) ((struct psw){ .mask =3D (m), .addr =3D (uint64_t)(a) =
})
> +
>  struct short_psw {
>  	uint32_t	mask;
>  	uint32_t	addr;
> @@ -321,6 +323,8 @@ static inline uint64_t extract_psw_mask(void)
>  	return (uint64_t) mask_upper << 32 | mask_lower;
>  }
> =20
> +#define PSW_CUR_MASK(addr) PSW(extract_psw_mask(), (addr))
> +
>  static inline void load_psw_mask(uint64_t mask)
>  {
>  	struct psw psw =3D {

