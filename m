Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21CF866624E
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 18:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbjAKRwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 12:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjAKRw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 12:52:26 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDC511165
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 09:52:24 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30BGeT9b007069;
        Wed, 11 Jan 2023 17:52:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=bf2+KZUauErns86CeVDeMSV6FItnzCC6ssTxE/11o5s=;
 b=WWxQPMeAErvOZEKkbe3uGkHxQFghWPHdCQE9psoaRbLX3KsyU6VGECw7HXXNG7h7lmOb
 SWv09jxIsxJmhX1IMKVyQJS3oOx+RnqkK7FbT/4v0GFcM54s1hAxRuY+9041lfifHlm/
 eFdyR5GEg0vUc0uEGKvuQjm1SRjAaU6pSR1z0/bIzyuGe6HiktVlSTjZCJxQQfH7awvy
 /oYs3dy0Yi7bYP/sOjyQXig2y04OM5JmJ/oXFK29SlWjznL7YRGGi0gbOGA/lSKA72Ub
 T5ZLKAEXXBUvS2p0dvFsOKeCSSxaBYNNP4TSr8R63Z9xDRBpV9XbWm3cxAivLvRoY6du 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n1y4mn7nh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Jan 2023 17:52:17 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30BHbEqs028875;
        Wed, 11 Jan 2023 17:52:16 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n1y4mn7n3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Jan 2023 17:52:16 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30BCn08b030764;
        Wed, 11 Jan 2023 17:52:14 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3n1kf7h8wt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Jan 2023 17:52:14 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30BHqBTJ50790882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Jan 2023 17:52:11 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BD032004E;
        Wed, 11 Jan 2023 17:52:11 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A95E20040;
        Wed, 11 Jan 2023 17:52:10 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.175.58])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 11 Jan 2023 17:52:10 +0000 (GMT)
Message-ID: <47b72645aaa2456476fe0d73f45d3f37ebb4eb3d.camel@linux.ibm.com>
Subject: Re: [PATCH v14 04/11] s390x/sclp: reporting the maximum nested
 topology entries
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Wed, 11 Jan 2023 18:52:10 +0100
In-Reply-To: <20230105145313.168489-5-pmorel@linux.ibm.com>
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
         <20230105145313.168489-5-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GKOn9ZkJGIK0c5U9GdRHKmWI2ltawZ-m
X-Proofpoint-GUID: CwJGCI_4huQ9o_xe7Z9PpZE-W8VFPofA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_07,2023-01-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0 suspectscore=0
 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301110128
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2023-01-05 at 15:53 +0100, Pierre Morel wrote:
> The maximum nested topology entries is used by the guest to know
> how many nested topology are available on the machine.
>=20
> Currently, SCLP READ SCP INFO reports MNEST =3D 0, which is the
> equivalent of reporting the default value of 2.
> Let's use the default SCLP value of 2 and increase this value in the
> future patches implementing higher levels.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
if you address the issues Thomas found with the commit description
and the nits below.

> ---
>  include/hw/s390x/sclp.h | 5 +++--
>  hw/s390x/sclp.c         | 4 ++++
>  2 files changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/hw/s390x/sclp.h b/include/hw/s390x/sclp.h
> index 712fd68123..4ce852473c 100644
> --- a/include/hw/s390x/sclp.h
> +++ b/include/hw/s390x/sclp.h
> @@ -112,12 +112,13 @@ typedef struct CPUEntry {
>  } QEMU_PACKED CPUEntry;
> =20
>  #define SCLP_READ_SCP_INFO_FIXED_CPU_OFFSET     128
> -#define SCLP_READ_SCP_INFO_MNEST                2
> +#define SCLP_READ_SCP_INFO_MNEST                4
>  typedef struct ReadInfo {
>      SCCBHeader h;
>      uint16_t rnmax;
>      uint8_t rnsize;
> -    uint8_t  _reserved1[16 - 11];       /* 11-15 */
> +    uint8_t  _reserved1[15 - 11];       /* 11-14 */
> +    uint8_t  stsi_parm;                 /* 15-16 */

The numbering here is the same as the one in the arch doc, instead
of the maybe more usual one where the right number is exclusive.
So 15-16 looks like a two byte field, so just do 15 or just drop it.

>      uint16_t entries_cpu;               /* 16-17 */
>      uint16_t offset_cpu;                /* 18-19 */
>      uint8_t  _reserved2[24 - 20];       /* 20-23 */
> diff --git a/hw/s390x/sclp.c b/hw/s390x/sclp.c
> index eff74479f4..07e3cb4cac 100644
> --- a/hw/s390x/sclp.c
> +++ b/hw/s390x/sclp.c
> @@ -20,6 +20,7 @@
>  #include "hw/s390x/event-facility.h"
>  #include "hw/s390x/s390-pci-bus.h"
>  #include "hw/s390x/ipl.h"
> +#include "hw/s390x/cpu-topology.h"
> =20
>  static inline SCLPDevice *get_sclp_device(void)
>  {
> @@ -125,6 +126,9 @@ static void read_SCP_info(SCLPDevice *sclp, SCCB *scc=
b)
> =20
>      /* CPU information */
>      prepare_cpu_entries(machine, entries_start, &cpu_count);
> +    if (s390_has_topology()) {
> +        read_info->stsi_parm =3D SCLP_READ_SCP_INFO_MNEST;
> +    }

Maybe move that up a bit, not sure if it belongs under the CPU information =
section.
I'd leave prepare_cpu_entries and read_info->entries_cpu =3D adjacent in an=
y case.

>      read_info->entries_cpu =3D cpu_to_be16(cpu_count);
>      read_info->offset_cpu =3D cpu_to_be16(offset_cpu);
>      read_info->highest_cpu =3D cpu_to_be16(machine->smp.max_cpus - 1);

