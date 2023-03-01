Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A466A7050
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 16:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjCAPyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 10:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjCAPx7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 10:53:59 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FEE457CC
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 07:53:19 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321FflJ3022058;
        Wed, 1 Mar 2023 15:53:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=eYVCkaSbJ2rtItwyr5vHtJzgeDl7SPSyuL7arfT9xBY=;
 b=BcAgkj0r7AR9/EYqTJK5NcUyU2pGSGo0363RF92UvyescHSpxKFXIo/1V8mYc6/Eevef
 udYuE5yTX8y4si0wISoIAou3YIh+DX3VCHPE7yubiBoFi35eVebQFUmCFpre78CbLL7x
 9b1KnsWqDOwysCzqQ3SsM7Hqg+GrwLtzSdqtTrlQcmI6ctHXWZMNQbY4vxZ5I3g1DF6G
 ucLM2lalgDvD7r3vFpmxjnH9+qJ16DSv56WqiiOvJdtnk77MvdqZBi8n4MGdxoiMw9xu
 b1Q5jOof7GYQWoeM32j7HclSjyGez/ROGALJGaQcxezTSSPS7KhMJjVq0S6fF2W79Bk0 EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p29jqga9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 15:53:04 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 321FghSk027696;
        Wed, 1 Mar 2023 15:53:04 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p29jqga8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 15:53:04 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3216FLrG032007;
        Wed, 1 Mar 2023 15:52:07 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3nybcucnm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 15:52:07 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 321Fq3Ow34210428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Mar 2023 15:52:03 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62FB320043;
        Wed,  1 Mar 2023 15:52:03 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFE3520040;
        Wed,  1 Mar 2023 15:52:02 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.186.20])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  1 Mar 2023 15:52:02 +0000 (GMT)
Message-ID: <ae00f540a0842d4a13b851ed0298812710dd8133.camel@linux.ibm.com>
Subject: Re: [PATCH v16 11/11] docs/s390x/cpu topology: document s390x cpu
 topology
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Wed, 01 Mar 2023 16:52:02 +0100
In-Reply-To: <20230222142105.84700-12-pmorel@linux.ibm.com>
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
         <20230222142105.84700-12-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: T0u-hh0OVB53MYKHz-VxCyor-HNF2XV2
X-Proofpoint-ORIG-GUID: HghytpWqyJetFn7mrY9QcUqjNGQ494vV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_11,2023-03-01_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303010127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-02-22 at 15:21 +0100, Pierre Morel wrote:
> Add some basic examples for the definition of cpu topology
> in s390x.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  docs/system/s390x/cpu-topology.rst | 378 +++++++++++++++++++++++++++++
>  docs/system/target-s390x.rst       |   1 +
>  2 files changed, 379 insertions(+)
>  create mode 100644 docs/system/s390x/cpu-topology.rst
>=20
> diff --git a/docs/system/s390x/cpu-topology.rst b/docs/system/s390x/cpu-t=
opology.rst
> new file mode 100644
> index 0000000000..d470e28b97
> --- /dev/null
> +++ b/docs/system/s390x/cpu-topology.rst
> @@ -0,0 +1,378 @@
>=20
[...]
> +
> +set-cpu-topology
> +++++++++++++++++
> +
> +The command set-cpu-topology allows the admin to modify the topology
> +tree or the topology modifiers of a vCPU in the configuration.
> +
> +.. code-block:: QMP
> +
> + -> { "execute": "set-cpu-topology",
> +      "arguments": {
> +         "core-id": 11,
> +         "socket-id": 0,
> +         "book-id": 0,
> +         "drawer-id": 0,
> +         "entitlement": low,
> +         "dedicated": false
> +      }
> +    }
> + <- {"return": {}}

This fails when building the documenation.
You need to get rid of the arrows and need "" around the low.


[...]
