Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4BAA5B2548
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 20:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbiIHSE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 14:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiIHSEx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 14:04:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D0632EF2
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 11:04:51 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 288HrKkK013203;
        Thu, 8 Sep 2022 18:04:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Mle2F5fFpz4YrINvvy96vp5NlrPJhOZ9uc36Yt+o4kg=;
 b=mX93uU/PKkENeG9VZd7XqFczqjnJxJwvGSFsERDwcORm9GV8Bg/AftE0/CzTw9TfuSUF
 toIr5JCtIBqfHuWe74tfRYiPOaTeCp+pf048XxlIkgPcVI31AiUOtNu+sUBeLGSOsZRq
 DdXYT0g7YcXsfqrjnr0sWeCekQgAatoWnHfySQr21k9yl1KRFvR9y1BDzhSSyZEOXmaG
 RQR5XZ+mzY4Y35p3Y+j+E2INC1kvwCHcJKX+GRKlV1Es+CScSnAg8ynuD9hi8dtVUJe/
 xc3h5EXlg1Gq2Cfv0k1lb63Z6/lSHq2GiLi41nMbPWIquIVDCXVun8fehgfk9AqS31Oz Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jfn6bgb4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Sep 2022 18:04:44 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 288HrgaG014330;
        Thu, 8 Sep 2022 18:04:44 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jfn6bgb2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Sep 2022 18:04:44 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 288HoBWI020086;
        Thu, 8 Sep 2022 18:04:41 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3jbxj8xwyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Sep 2022 18:04:41 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 288I4cwm35389938
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Sep 2022 18:04:38 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8107EA4040;
        Thu,  8 Sep 2022 18:04:38 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C24AEA404D;
        Thu,  8 Sep 2022 18:04:37 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.10.204])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  8 Sep 2022 18:04:37 +0000 (GMT)
Message-ID: <5f127a8be58d0842c6d94d682538af55f4eef64f.camel@linux.ibm.com>
Subject: Re: [PATCH v9 07/10] s390x/cpu_topology: CPU topology migration
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
Date:   Thu, 08 Sep 2022 20:04:37 +0200
In-Reply-To: <20220902075531.188916-8-pmorel@linux.ibm.com>
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
         <20220902075531.188916-8-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NaKyoln0i0GCHYEP_NVnfCQMQL3GXX1w
X-Proofpoint-GUID: nHpM-SVDUKX-hUxF1B0Z7eUdJCormOwb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-08_10,2022-09-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2209080064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-09-02 at 09:55 +0200, Pierre Morel wrote:
> The migration can only take place if both source and destination
> of the migration both use or both do not use the CPU topology
> facility.
> 
> We indicate a change in topology during migration postload for the
> case the topology changed between source and destination.

You always set the report bit after migration, right?
In the last series you actually migrated the bit.
Why the change? With the code you have actually migrating the bit isn't
hard.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  hw/s390x/cpu-topology.c         | 79 +++++++++++++++++++++++++++++++++
>  include/hw/s390x/cpu-topology.h |  1 +
>  target/s390x/cpu-sysemu.c       |  8 ++++
>  target/s390x/cpu.h              |  1 +
>  4 files changed, 89 insertions(+)
> 
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index 6098d6ea1f..b6bf839e40 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -19,6 +19,7 @@
>  #include "target/s390x/cpu.h"
>  #include "hw/s390x/s390-virtio-ccw.h"
>  #include "hw/s390x/cpu-topology.h"
> +#include "migration/vmstate.h"
>  
>  S390Topology *s390_get_topology(void)
>  {
> @@ -132,6 +133,83 @@ static void s390_topology_reset(DeviceState *dev)
>      s390_cpu_topology_reset();
>  }
>  
> +/**
> + * cpu_topology_postload
> + * @opaque: a pointer to the S390Topology
> + * @version_id: version identifier
> + *
> + * We check that the topology is used or is not used
> + * on both side identically.
> + *
> + * If the topology is in use we set the Modified Topology Change Report
> + * on the destination host.
> + */
> +static int cpu_topology_postload(void *opaque, int version_id)
> +{
> +    S390Topology *topo = opaque;
> +    int ret;
> +
> +    if (topo->topology_needed != s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY)) {

Does this function even run if topology_needed is false?
In that case there is no data saved, so no reason to load it either.
If so you can only check that both the source and the destination have
the feature enabled. You would need to always send the topology VMSD in
order to check that the feature is disabled.

Does qemu allow you to attempt to migrate to a host with another cpu
model?
If it disallowes that you wouldn't need to do any checks, right?

> +        if (topo->topology_needed) {
> +            error_report("Topology facility is needed in destination");
> +        } else {
> +            error_report("Topology facility can not be used in destination");
> +        }
> +        return -EINVAL;
> +    }
> +
> +    /* We do not support CPU Topology, all is good */
> +    if (!s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY)) {
> +        return 0;
> +    }
> +
> +    /* We support CPU Topology, set the MTCR */
> +    ret = s390_cpu_topology_mtcr_set();
> +    if (ret) {
> +        error_report("Failed to set MTCR: %s", strerror(-ret));
> +    }
> +    return ret;
> +}
> +
> +/**
> + * cpu_topology_presave:
> + * @opaque: The pointer to the S390Topology
> + *
> + * Save the usage of the CPU Topology in the VM State.
> + */
> +static int cpu_topology_presave(void *opaque)
> +{
> +    S390Topology *topo = opaque;
> +
> +    topo->topology_needed = s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY);
> +    return 0;
> +}
> +
> +/**
> + * cpu_topology_needed:
> + * @opaque: The pointer to the S390Topology
> + *
> + * If we use the CPU Topology on the source it will be needed on the destination.
> + */
> +static bool cpu_topology_needed(void *opaque)
> +{
> +    return s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY);
> +}
> +
> +
> +const VMStateDescription vmstate_cpu_topology = {
> +    .name = "cpu_topology",
> +    .version_id = 1,
> +    .post_load = cpu_topology_postload,
> +    .pre_save = cpu_topology_presave,
> +    .minimum_version_id = 1,
> +    .needed = cpu_topology_needed,
> +    .fields = (VMStateField[]) {
> +        VMSTATE_BOOL(topology_needed, S390Topology),
> +        VMSTATE_END_OF_LIST()
> +    }
> +};
> +
[...]
