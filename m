Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6235B01F8
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 12:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiIGKhF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 06:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiIGKhC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 06:37:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8B37646E
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 03:37:01 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 287AAFgp037293;
        Wed, 7 Sep 2022 10:36:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=D8QaIE9C8bXOOAL5wO/5ZOwVtWUU1P3KZ/emI/wAaQY=;
 b=WUcVOH5NYCakLZXh+dvX4WmcDBOpcdH3wdxC6U/o2PP9jtMwsneIWLbPCi1KLJI9udJI
 bgau6oVPZEnnq3cBZfrb8mHyMc78fBKvCk95yUhc0X1AYTmxRBPBavZ7f55xcGPvhAXo
 l5PHRBOoiwvwp/Os2XEj/dL9jis2irivsCYTtO2oa2pkjYkettewmIRbKLN0Ih/fgi9U
 9iLV9JbtP+l3rWBQOvZAkLu6fN/dioUZ/FkV0fffSiueye2qK+5XCe8e/254xCfKVf9a
 H3dqIOP5qs8HWXJE04TMAioPTCvCRwGyJBC2UY2BQVtnXkDQmrzM458tQbgx6e2nDoRg Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jerxa1519-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Sep 2022 10:36:52 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 287ABJoK040062;
        Wed, 7 Sep 2022 10:36:52 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jerxa150d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Sep 2022 10:36:52 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 287AaCb0030181;
        Wed, 7 Sep 2022 10:36:49 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3jbxj8uqas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Sep 2022 10:36:49 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 287AakS141419242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Sep 2022 10:36:46 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91CD7A4067;
        Wed,  7 Sep 2022 10:36:46 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5800A4068;
        Wed,  7 Sep 2022 10:36:45 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.17.128])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Sep 2022 10:36:45 +0000 (GMT)
Message-ID: <ecfcac0e9f31b6d4eac15b8b2cd10aab31ff0ff7.camel@linux.ibm.com>
Subject: Re: [PATCH v9 05/10] s390x/cpu: reporting drawers and books
 topology to the guest
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
Date:   Wed, 07 Sep 2022 12:36:45 +0200
In-Reply-To: <20220902075531.188916-6-pmorel@linux.ibm.com>
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
         <20220902075531.188916-6-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YBdF7rx1ZvK-LK1eiprh1s0iHndgqX2C
X-Proofpoint-GUID: Y7x2nZjBGB3JzcjMxfqsTaqGN3qnEmqs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-07_06,2022-09-06_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501 impostorscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209070041
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-09-02 at 09:55 +0200, Pierre Morel wrote:
> The guest can ask for a topology report on drawer's or book's
> level.
> Let's implement the STSI instruction's handling for the corresponding
> selector values.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  hw/s390x/cpu-topology.c         | 19 +++++++---
>  hw/s390x/s390-virtio-ccw.c      |  2 ++
>  include/hw/s390x/cpu-topology.h |  7 +++-
>  target/s390x/cpu_topology.c     | 64 +++++++++++++++++++++++++++------
>  4 files changed, 76 insertions(+), 16 deletions(-)
> 
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index e2fd5c7e44..bb9ae63483 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> 
[...]

> @@ -99,13 +103,20 @@ static void s390_topology_realize(DeviceState *dev, Error **errp)
>      S390Topology *topo = S390_CPU_TOPOLOGY(dev);
>      int n;
>  
> +    topo->drawers = ms->smp.drawers;
> +    topo->books = ms->smp.books;
> +    topo->total_books = topo->books * topo->drawers;
>      topo->sockets = ms->smp.sockets;
> +    topo->total_sockets = topo->sockets * topo->books * topo->drawers;
>      topo->cores = ms->smp.cores;
> -    topo->tles = ms->smp.max_cpus;
>  
> -    n = topo->sockets;
> +    n = topo->drawers;
> +    topo->drawer = g_malloc0(n * sizeof(S390TopoContainer));
> +    n *= topo->books;
> +    topo->book = g_malloc0(n * sizeof(S390TopoContainer));
> +    n *= topo->sockets;
>      topo->socket = g_malloc0(n * sizeof(S390TopoContainer));
> -    topo->tle = g_malloc0(topo->tles * sizeof(S390TopoTLE));
> +    topo->tle = g_malloc0(n * sizeof(S390TopoTLE));

Same question here about using g_new0.
>  
>      qemu_mutex_init(&topo->topo_mutex);
>  }
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 15cefd104b..3f28e28d47 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -626,6 +626,8 @@ static void ccw_machine_class_init(ObjectClass *oc, void *data)
>      hc->unplug_request = s390_machine_device_unplug_request;
>      nc->nmi_monitor_handler = s390_nmi;
>      mc->default_ram_id = "s390.ram";
> +    mc->smp_props.books_supported = true;
> +    mc->smp_props.drawers_supported = true;
>  }
>  
>  static inline bool machine_get_aes_key_wrap(Object *obj, Error **errp)
> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
> index 0b7f3d10b2..4f8ac39ca0 100644
> --- a/include/hw/s390x/cpu-topology.h
> +++ b/include/hw/s390x/cpu-topology.h
> @@ -29,9 +29,14 @@ typedef struct S390TopoTLE {
>  
>  struct S390Topology {
>      SysBusDevice parent_obj;
> +    int total_books;
> +    int total_sockets;

What are these used for? I'm not seeing anything.

> +    int drawers;
> +    int books;
>      int sockets;
>      int cores;
> -    int tles;

You remove this in this patch and you didn't really need it before.
As far as I can tell it was just used for calculating the number of
tles to allocate and you could use a local variable instead.
So I would get rid of it in the patch that introduced it.

> +    S390TopoContainer *drawer;
> +    S390TopoContainer *book;
>      S390TopoContainer *socket;
>      S390TopoTLE *tle;
>      QemuMutex topo_mutex;
> diff --git a/target/s390x/cpu_topology.c b/target/s390x/cpu_topology.c
> index 56865dafc6..305fbb9734 100644
> --- a/target/s390x/cpu_topology.c
> +++ b/target/s390x/cpu_topology.c
> @@ -37,19 +37,18 @@ static char *fill_tle_cpu(char *p, uint64_t mask, int origin)
>      return p + sizeof(*tle);
>  }
>  
> -static char *s390_top_set_level2(S390Topology *topo, char *p)
> +static char *s390_top_set_level2(S390Topology *topo, char *p, int fs, int ns)
>  {

I wouldn't hate more verbose names for fs and ns. start_socket,
num_socket maybe? Same for fb, nb, but it is your call, it's not really
hard to understand the code.

> -    int i, origin;
> +    int socket, origin;
> +    uint64_t mask;
>  
> -    for (i = 0; i < topo->sockets; i++) {
> -        if (!topo->socket[i].active_count) {
> +    for (socket = fs; socket < fs + ns; socket++) {
> +        if (!topo->socket[socket].active_count) {
>              continue;
>          }
> -        p = fill_container(p, 1, i);
> +        p = fill_container(p, 1, socket);

Have you considered using an enum for the level constants?

>          for (origin = 0; origin < S390_TOPOLOGY_MAX_ORIGIN; origin++) {
> -            uint64_t mask = 0L;
> -
> -            mask = be64_to_cpu(topo->tle[i].mask[origin]);
> +            mask = be64_to_cpu(topo->tle[socket].mask[origin]);
>              if (mask) {
>                  p = fill_tle_cpu(p, mask, origin);
>              }
> @@ -58,19 +57,63 @@ static char *s390_top_set_level2(S390Topology *topo, char *p)
>      return p;
>  }
>  
> +static char *s390_top_set_level3(S390Topology *topo, char *p, int fb, int nb)
> +{
> +    int book, fs = 0;
> +
> +    for (book = fb; book < fb + nb; book++, fs += topo->sockets) {
> +        if (!topo->book[book].active_count) {
> +            continue;
> +        }
> +        p = fill_container(p, 2, book);
> +    p = s390_top_set_level2(topo, p, fs, topo->sockets);

Indent is off.

> +    }
> +    return p;
> +}
> +
> +static char *s390_top_set_level4(S390Topology *topo, char *p)
> +{
> +    int drawer, fb = 0;
> +
> +    for (drawer = 0; drawer < topo->drawers; drawer++, fb += topo->books) {
> +        if (!topo->drawer[drawer].active_count) {
> +            continue;
> +        }
> +        p = fill_container(p, 3, drawer);
> +        p = s390_top_set_level3(topo, p, fb, topo->books);
> +    }
> +    return p;
> +}
> +
>  static int setup_stsi(SysIB_151x *sysib, int level)
>  {
>      S390Topology *topo = s390_get_topology();
>      char *p = (char *)sysib->tle;
> +    int max_containers;
>  
>      qemu_mutex_lock(&topo->topo_mutex);
>  
>      sysib->mnest = level;
>      switch (level) {
>      case 2:
> +        max_containers = topo->sockets * topo->books * topo->drawers;
> +        sysib->mag[TOPOLOGY_NR_MAG2] = max_containers;
> +        sysib->mag[TOPOLOGY_NR_MAG1] = topo->cores;
> +        p = s390_top_set_level2(topo, p, 0, max_containers);

Isn't this logic change already required for the patch that introduced
stsi 15.1.2 handling?

> +        break;
> +    case 3:
> +        max_containers = topo->books * topo->drawers;
> +        sysib->mag[TOPOLOGY_NR_MAG3] = max_containers;
>          sysib->mag[TOPOLOGY_NR_MAG2] = topo->sockets;
>          sysib->mag[TOPOLOGY_NR_MAG1] = topo->cores;
> -        p = s390_top_set_level2(topo, p);
> +        p = s390_top_set_level3(topo, p, 0, max_containers);
> +        break;
> +    case 4:
> +        sysib->mag[TOPOLOGY_NR_MAG4] = topo->drawers;
> +        sysib->mag[TOPOLOGY_NR_MAG3] = topo->books;
> +        sysib->mag[TOPOLOGY_NR_MAG2] = topo->sockets;
> +        sysib->mag[TOPOLOGY_NR_MAG1] = topo->cores;
> +        p = s390_top_set_level4(topo, p);
>          break;
>      }
>  
> @@ -79,7 +122,7 @@ static int setup_stsi(SysIB_151x *sysib, int level)
>      return p - (char *)sysib->tle;
>  }
>  
> -#define S390_TOPOLOGY_MAX_MNEST 2
> +#define S390_TOPOLOGY_MAX_MNEST 4

AFAIK you're only allowed to increase this if the maximum mnest
facility is installed. If it isn't, only level 2 is supported.
Which would mean that this patch doesn't do anything.

>  void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar)
>  {
>      SysIB_151x *sysib;
> @@ -105,4 +148,3 @@ void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar)
>  out_free:
>      g_free(sysib);
>  }
> -

