Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC8C7ADC8F
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 17:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbjIYP7w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 11:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233295AbjIYP7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 11:59:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0833B112;
        Mon, 25 Sep 2023 08:59:38 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38PFRYUV030069;
        Mon, 25 Sep 2023 15:59:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=FNTns10X71pQI2BgVEWJM7995Il9ezfrG8r32tk2zMg=;
 b=pQjNBW33oGP5n4h/6TCwyKxiV+tSAbobZVkf/2eYljDdwwwihmaCiVij6CxWeSSihp6w
 MSy3PuueeNzdQP9XmI9llOEiP2lXxx9B+oXZxvcyieUiJXmng6BrPwfBaGc3iiJto4G/
 Iz7HSsTPqrAAl6Rqk3dROst9Ebbh3T8J8rsCWAIRrCBF9R2uXjh6/DLCBUIMIKWVpmyT
 GV8tkKHc8cOQlBEnbQqEH78lCVX0wkwCx0o4gI1wrFifsh16n85pHLPl8nLWHSJ66A9A
 FRAdaFTAqJpso3B5WA3RFtGBfLXiEorF1YkJ7lyRZ18c2BYmvSu1iKD/YBf9M+MMVQyB ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tbcuw8wt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Sep 2023 15:59:37 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38PFV4oK008100;
        Mon, 25 Sep 2023 15:59:37 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tbcuw8wsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Sep 2023 15:59:37 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38PF3UYE030392;
        Mon, 25 Sep 2023 15:59:36 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tad21axsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Sep 2023 15:59:36 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38PFxXtW18743922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Sep 2023 15:59:33 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28A8E20043;
        Mon, 25 Sep 2023 15:59:33 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C35AA20040;
        Mon, 25 Sep 2023 15:59:32 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.171.62.152])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 25 Sep 2023 15:59:32 +0000 (GMT)
Message-ID: <d9019e6293a664df8450ab73ddf2d9132178cbd1.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1] s390x: run PV guests with
 confidential guest enabled
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Date:   Mon, 25 Sep 2023 17:59:32 +0200
In-Reply-To: <20230925135259.1685540-1-nrb@linux.ibm.com>
References: <20230925135259.1685540-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OIcxP5bd6MGACarg5iH0E5RT19fTRyYi
X-Proofpoint-ORIG-GUID: Z4tdiyXArJ0NLZmC-xEi9nJ0IAnJR2y9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-25_12,2023-09-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1011 malwarescore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2309250119
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-09-25 at 15:52 +0200, Nico Boehr wrote:
> PV can only handle one page of SCLP read info, hence it can only support
> a maximum of 247 CPUs.
>=20
> To make sure we respect these limitations under PV, add a confidential
> guest device to QEMU when launching a PV guest.
>=20
> This fixes the topology-2 test failing under PV.
>=20
> Also refactor the run script a bit to reduce code duplication by moving
> the check whether we're running a PV guest to a function.
>=20
> Suggested-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

> ---
>  s390x/run | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
>=20
> diff --git a/s390x/run b/s390x/run
> index dcbf3f036415..e58fa4af9f23 100755
> --- a/s390x/run
> +++ b/s390x/run
> @@ -14,19 +14,34 @@ set_qemu_accelerator || exit $?
>  qemu=3D$(search_qemu_binary) ||
>  	exit $?
> =20
> -if [ "${1: -7}" =3D ".pv.bin" ] || [ "${TESTNAME: -3}" =3D "_PV" ] && [ =
"$ACCEL" =3D "tcg" ]; then
> +is_pv() {
> +	if [ "${1: -7}" =3D ".pv.bin" ] || [ "${TESTNAME: -3}" =3D "_PV" ]; the=
n
> +		return 0
> +	fi
> +	return 1
> +}

Could also just do

is_pv() {
        [ "${1: -7}" =3D ".pv.bin" ] || [ "${TESTNAME: -3}" =3D "_PV" ]
}

but it might actually be more readable with the if
> +
> +if is_pv && [ "$ACCEL" =3D "tcg" ]; then
>  	echo "Protected Virtualization isn't supported under TCG"
>  	exit 2
>  fi
> =20
> -if [ "${1: -7}" =3D ".pv.bin" ] || [ "${TESTNAME: -3}" =3D "_PV" ] && [ =
"$MIGRATION" =3D "yes" ]; then
> +if is_pv && [ "$MIGRATION" =3D "yes" ]; then
>  	echo "Migration isn't supported under Protected Virtualization"
>  	exit 2
>  fi
> =20
>  M=3D'-machine s390-ccw-virtio'
>  M+=3D",accel=3D$ACCEL$ACCEL_PROPS"
> +
> +if is_pv; then
> +	M+=3D",confidential-guest-support=3Dpv0"
> +fi
> +
>  command=3D"$qemu -nodefaults -nographic $M"
> +if is_pv; then
> +	command+=3D" -object s390-pv-guest,id=3Dpv0"
> +fi
>  command+=3D" -chardev stdio,id=3Dcon0 -device sclpconsole,chardev=3Dcon0=
"
>  command+=3D" -kernel"
>  command=3D"$(panic_cmd) $(migration_cmd) $(timeout_cmd) $command"

