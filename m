Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D54965C174
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 15:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237127AbjACOFq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 09:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237620AbjACOFW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 09:05:22 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D66D1057A
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 06:05:20 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 303BNodW019095
        for <kvm@vger.kernel.org>; Tue, 3 Jan 2023 14:05:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=GgOo+goLTZhe2tBlkRRVPe9QpNfZ7TZjAqJkg2Bb3OE=;
 b=WjGDK5/zkzx2aaFK7qQ2GtkQ31ZHDK9evGPx+iNF0xWdduqYnXKyJ/BtwPAi27pPRDB1
 PFN9t+w5S61YrcTizVODj62P79BgaUijirZuUpXiQFGFiesdkBAjlVoaFhkuapqZwZ+J
 9bT0Vi/aVeD3S26eeZ7AAV9nuwoGkFF2wg3ztu8lCMtu4hKg547RK95gwMnnz8rPdQI9
 xkEyKMODK341shlZneCUT1fL6rmeW/uBQWRN9xxfWJE1eZMo1oSggcawMDGJ/ouJ7vUy
 gAp1Bb1i45jc1PngZj2QoRU9AWGZPuDKnCiU57O+XxdpLjDq1+QHgtVKOUVQtZU+mOfz Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mvkf0b3u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 14:05:19 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 303DKfrB027573
        for <kvm@vger.kernel.org>; Tue, 3 Jan 2023 14:05:19 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mvkf0b3tj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Jan 2023 14:05:19 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3035Lm25000322;
        Tue, 3 Jan 2023 14:05:17 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3mtcq6tuq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Jan 2023 14:05:17 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 303E5EhU37290454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Jan 2023 14:05:14 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F091920049;
        Tue,  3 Jan 2023 14:05:13 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4C4920040;
        Tue,  3 Jan 2023 14:05:13 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.170.222])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  3 Jan 2023 14:05:13 +0000 (GMT)
Message-ID: <486f8b2f0f1b127a4bcffbbafeff317f4de3872d.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: fix make standalone
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        thuth@redhat.com
Date:   Tue, 03 Jan 2023 15:05:13 +0100
In-Reply-To: <20221220175508.57180-1-imbrenda@linux.ibm.com>
References: <20221220175508.57180-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Mg41sopO2FPPrBWfmB__rnLWEeGecguX
X-Proofpoint-ORIG-GUID: w8m9CQE5kSCQ3TAa9Kw1DHy_av1CtOKn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-03_04,2023-01-03_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 mlxlogscore=942 phishscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301030122
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-12-20 at 18:55 +0100, Claudio Imbrenda wrote:
> A recent patch broke make standalone. The function find_word is not
> available when running make standalone, replace it with a simple grep.
>=20
> Reported-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> Fixes: 743cacf7 ("s390x: don't run migration tests under PV")
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>  scripts/s390x/func.bash | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
> index 2a941bbb..6c75e89a 100644
> --- a/scripts/s390x/func.bash
> +++ b/scripts/s390x/func.bash
> @@ -21,7 +21,7 @@ function arch_cmd_s390x()
>  	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" =
"$accel" "$timeout"
> =20
>  	# run PV test case
> -	if [ "$ACCEL" =3D 'tcg' ] || find_word "migration" "$groups"; then
> +	if [ "$ACCEL" =3D 'tcg' ] || grep -q "migration" <<< "$groups"; then
>  		return
>  	fi
>  	kernel=3D${kernel%.elf}.pv.bin

