Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD9861F430
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 14:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbiKGNVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 08:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbiKGNVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 08:21:44 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B681B787
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 05:21:41 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7BSdYG017940;
        Mon, 7 Nov 2022 13:21:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=KquJ7rvlQjmwSewLGxFyrbm4+CoXHk/g1eYUn+eRdvM=;
 b=JM+XgCc2xp7yFYuoGYn2RPeQ5+lo2PUtk1iMx6GvNBQKYD72rAaBdLz4xF86S8UokbQX
 AFcG5Ce4K4qdWB5UgwSi46qCF9xMY4KYJiSdEVn1TXEmd+htmakW6DPdZ24fPCoh/WrP
 ddIl7WqVKiAgPhZMPj9L60U30nIjE5dmFs4ekds75UetBDRlyGR0gPKJYn1UiZumk+GM
 NbIzMYSbnne4N04hVvCr5Fhn6tJBekmUANJ8jnnzkIk9OwpQLSROMh1QBwvGfvtW0MO/
 wYynZhpOFF9eS7NbqkaVLgjilMowM7Iwm3lOn9ONC4JVO9/qY/gnpXApXBQ2qpaPg2j+ 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp14x3hmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 13:21:06 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A7CUqYx011656;
        Mon, 7 Nov 2022 13:21:06 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp14x3hk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 13:21:05 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A7DKIZU026830;
        Mon, 7 Nov 2022 13:21:03 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3kngmqhw8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 13:21:03 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A7DLba747841548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Nov 2022 13:21:37 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D405CA405B;
        Mon,  7 Nov 2022 13:20:59 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2D2BA4054;
        Mon,  7 Nov 2022 13:20:58 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.55.234])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Nov 2022 13:20:58 +0000 (GMT)
Message-ID: <ebfe8dea72adaf23913797c482377f4fd58fd097.camel@linux.ibm.com>
Subject: Re: [PATCH v10 2/9] s390x/cpu topology: reporting the CPU topology
 to the guest
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Mon, 07 Nov 2022 14:20:58 +0100
In-Reply-To: <d82372a9-581a-9544-eb6d-7b3e125926f5@linux.ibm.com>
References: <20221012162107.91734-1-pmorel@linux.ibm.com>
         <20221012162107.91734-3-pmorel@linux.ibm.com>
         <4c5afcb5754cb829cd8b9ddbf4f74e610d5f6012.camel@linux.ibm.com>
         <d82372a9-581a-9544-eb6d-7b3e125926f5@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: A-CuPbDJiU9CiPi6xsMjXzu1Ps0WW3Bc
X-Proofpoint-GUID: MMjj-W9aUXI5GTPBiWwJb7KPmYx83DJt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_06,2022-11-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211070102
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-10-28 at 12:00 +0200, Pierre Morel wrote:
> 
> On 10/27/22 22:42, Janis Schoetterl-Glausch wrote:
> > On Wed, 2022-10-12 at 18:21 +0200, Pierre Morel wrote:
> > > The guest can use the STSI instruction to get a buffer filled
> > > with the CPU topology description.
> > > 
> > > Let us implement the STSI instruction for the basis CPU topology
> > > level, level 2.
> > > 
> > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > ---
> > >   include/hw/s390x/cpu-topology.h |   3 +
> > >   target/s390x/cpu.h              |  48 ++++++++++++++
> > >   hw/s390x/cpu-topology.c         |   8 ++-
> > >   target/s390x/cpu_topology.c     | 109 ++++++++++++++++++++++++++++++++
> > >   target/s390x/kvm/kvm.c          |   6 +-
> > >   target/s390x/meson.build        |   1 +
> > >   6 files changed, 172 insertions(+), 3 deletions(-)
> > >   create mode 100644 target/s390x/cpu_topology.c
> > > 
> > > diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
> > > index 66c171d0bc..61c11db017 100644
> > > --- a/include/hw/s390x/cpu-topology.h
> > > +++ b/include/hw/s390x/cpu-topology.h
> > > @@ -13,6 +13,8 @@
> > >   #include "hw/qdev-core.h"
> > >   #include "qom/object.h"
> > >   
> > > +#define S390_TOPOLOGY_POLARITY_H  0x00
> > > +
> > >   typedef struct S390TopoContainer {
> > >       int active_count;
> > >   } S390TopoContainer;
> > > @@ -29,6 +31,7 @@ struct S390Topology {
> > >       S390TopoContainer *socket;
> > >       S390TopoTLE *tle;
> > >       MachineState *ms;
> > > +    QemuMutex topo_mutex;
> > >   };
> > >   
> > >   #define TYPE_S390_CPU_TOPOLOGY "s390-topology"
> > > diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
> > > index 7d6d01325b..d604aa9c78 100644
> > > --- a/target/s390x/cpu.h
> > > +++ b/target/s390x/cpu.h
> > > 
> > [...]
> > > +
> > > +/* Maxi size of a SYSIB structure is when all CPU are alone in a container */
> > 
> > Max or Maximum.
> > 
> > > +#define S390_TOPOLOGY_SYSIB_SIZE (sizeof(SysIB_151x) +                         \
> > > +                                  S390_MAX_CPUS * (sizeof(SysIBTl_container) + \
> > > +                                                   sizeof(SysIBTl_cpu)))
> > 
> > Currently this is 16+248*3*8 == 5968 and will grow with books, drawer support to
> > 16+248*5*8 == 9936 ...
> > 
> > [...]
> > > 
> > > +
> > > +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar)
> > > +{
> > > +    uint64_t page[S390_TOPOLOGY_SYSIB_SIZE / sizeof(uint64_t)] = {};
> > 
> > ... so calling this page is a bit misleading. Also why not make it a char[]?
> > And maybe use a union for type punning.
> 
> OK, what about:
> 
>      union {
>          char place_holder[S390_TOPOLOGY_SYSIB_SIZE];
>          SysIB_151x sysib;
>      } buffer QEMU_ALIGNED(8);
> 
I don't think you need the QEMU_ALIGNED since SysIB_151x already has it. Not that it hurts to be
explicit. If you declared the tle member as uint64_t[], you should get the correct alignment
automatically and can then drop the explicit one.
Btw, [] seems to be preferred over [0], at least there is a commit doing a conversion:
f7795e4096 ("misc: Replace zero-length arrays with flexible array member (automatic)")
> 
> > 
> > > +    SysIB_151x *sysib = (SysIB_151x *) page;
> > > +    int len;
> > > +
> > > +    if (s390_is_pv() || !s390_has_topology() ||
> > > +        sel2 < 2 || sel2 > S390_TOPOLOGY_MAX_MNEST) {
> > > +        setcc(cpu, 3);
> > > +        return;
> > > +    }
> > > +
> > > +    len = setup_stsi(sysib, sel2);
> > 
> > This should now be memory safe, but might be larger than 4k,
> > the maximum size of the SYSIB. I guess you want to set cc code 3
> > in this case and return.
> 
> I do not find why the SYSIB can not be larger than 4k.
> Can you point me to this restriction?

Says so at the top of the description of STSI:

The SYSIB is 4K bytes and must begin at a 4 K-byte
boundary; otherwise, a specification exception may
be recognized.

Also the graphics show that it is 1024 words long.
> 
> 
> Regards,
> Pierre
> 

