Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 299E461FCD8
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 19:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbiKGSIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 13:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232893AbiKGSI0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 13:08:26 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0EE27DD8
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 10:04:19 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7GUkP3001553;
        Mon, 7 Nov 2022 18:04:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=9oZh4CsSa/8Gj4z764dnILKpovbkaksgcK3gclKKLTM=;
 b=R3MgOaZ2GFSZtJ9hKBWm/muQX3IDmuBS/rSoXKXZJq2dLEN5aipBkgwwmrQcQgAqlE4+
 PtjrwLThFZA7s9NpGGwW4/0vBBYRzTL9iRmO549ARV4rvH7yKx/KeplI/fcVZeU3Cz/r
 sCCQt51EuUiEbfHmF94syY3sWCPT0cHOiZUAC/d7Gat8BAtFfM0w6YES5nMq0gcueJGu
 SlOQnnbHk7pZK9HlwAE3KHvNAR9XzzMRxK7fx/9KxGLQ5QbtKQSvCqUD1xjGyZwiPQSc
 QNEeeLUODTvG/kHS2vjG8j3Dp7hNcu9I7PyIdIcbBBGNKTt66KfAmwPSAzi1TQUxpJNq kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp1mswxjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 18:04:08 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A7FbAHw002558;
        Mon, 7 Nov 2022 18:04:08 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp1mswxgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 18:04:08 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A7Hq0QL017652;
        Mon, 7 Nov 2022 18:04:06 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3kngncayqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 18:04:05 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A7I4etV53281142
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Nov 2022 18:04:40 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE403A4053;
        Mon,  7 Nov 2022 18:04:02 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15689A404D;
        Mon,  7 Nov 2022 18:04:02 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.55.88])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Nov 2022 18:04:02 +0000 (GMT)
Message-ID: <4b2dcb313e3409697b702308d94078d16c6cd955.camel@linux.ibm.com>
Subject: Re: [PATCH v10 1/9] s390x/cpu topology: core_id sets s390x CPU
 topology
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Mon, 07 Nov 2022 19:04:01 +0100
In-Reply-To: <2657bf9e-add2-1f48-18c9-9f9e5b561c80@linux.ibm.com>
References: <20221012162107.91734-1-pmorel@linux.ibm.com>
         <20221012162107.91734-2-pmorel@linux.ibm.com>
         <ad2a9892184cd5dc7597d411f42e330558146acf.camel@linux.ibm.com>
         <15b829ca-14d0-dc77-5e1e-1b4455784ed6@linux.ibm.com>
         <c1c2a492596c3f853ca260e22ba2c9f8afb9a0ae.camel@linux.ibm.com>
         <2657bf9e-add2-1f48-18c9-9f9e5b561c80@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZgFpdZ8MnMqKnNFsmaZLvq_SuwUNJRaK
X-Proofpoint-ORIG-GUID: twEWzrbzalKBDXHbfRMz4Dd2Db8_LA_S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_08,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 phishscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 mlxscore=0 adultscore=0 impostorscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070144
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-10-28 at 11:30 +0200, Pierre Morel wrote:
> 
> On 10/27/22 22:20, Janis Schoetterl-Glausch wrote:
> > On Wed, 2022-10-26 at 10:34 +0200, Pierre Morel wrote:
> > > 
> > > On 10/25/22 21:58, Janis Schoetterl-Glausch wrote:
> > > > On Wed, 2022-10-12 at 18:20 +0200, Pierre Morel wrote:
> > > > > In the S390x CPU topology the core_id specifies the CPU address
> > > > > and the position of the core withing the topology.
> > > > > 
> > > > > Let's build the topology based on the core_id.
> > > > > s390x/cpu topology: core_id sets s390x CPU topology
> > > > > 
> > > > > In the S390x CPU topology the core_id specifies the CPU address
> > > > > and the position of the cpu withing the topology.
> > > > > 
> > > > > Let's build the topology based on the core_id.
> > > > > 
> > > > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > > > ---
> > > > >    include/hw/s390x/cpu-topology.h |  45 +++++++++++
> > > > >    hw/s390x/cpu-topology.c         | 132 ++++++++++++++++++++++++++++++++
> > > > >    hw/s390x/s390-virtio-ccw.c      |  21 +++++
> > > > >    hw/s390x/meson.build            |   1 +
> > > > >    4 files changed, 199 insertions(+)
> > > > >    create mode 100644 include/hw/s390x/cpu-topology.h
> > > > >    create mode 100644 hw/s390x/cpu-topology.c
> > > > > 
> > > > [...]
> > > > 
> > > > > +/**
> > > > > + * s390_topology_realize:
> > > > > + * @dev: the device state
> > > > > + * @errp: the error pointer (not used)
> > > > > + *
> > > > > + * During realize the machine CPU topology is initialized with the
> > > > > + * QEMU -smp parameters.
> > > > > + * The maximum count of CPU TLE in the all Topology can not be greater
> > > > > + * than the maximum CPUs.
> > > > > + */
> > > > > +static void s390_topology_realize(DeviceState *dev, Error **errp)
> > > > > +{
> > > > > +    MachineState *ms = MACHINE(qdev_get_machine());
> > > > > +    S390Topology *topo = S390_CPU_TOPOLOGY(dev);
> > > > > +
> > > > > +    topo->cpus = ms->smp.cores * ms->smp.threads;
> > > > 
> > > > Currently threads are not supported, effectively increasing the number of cpus,
> > > > so this is currently correct. Once the machine version limits the threads to 1,
> > > > it is also correct. However, once we support multiple threads, this becomes incorrect.
> > > > I wonder if it's ok from a backward compatibility point of view to modify the smp values
> > > > by doing cores *= threads, threads = 1 for old machines.
> > > 
> > > Right, this will become incorrect with thread support.
> > > What about having a dedicated function:
> > > 
> > > 	topo->cpus = s390_get_cpus(ms);
> > > 
> > > This function will use the S390CcwMachineClass->max_thread introduced
> > > later to report the correct number of CPUs.
> > 
> > I don't think max_threads is exactly what matters here, it's if
> > threads are supported or not or, if max_threads == 1 it doesn't matter.
> > The question is how best to do the check. You could check the machine version.
> > I wonder if you could add a feature bit for the multithreading facility that is
> > always false and use that.
> > 
> > I don't know if using a function makes a difference, that is if it is obvious on
> > introduction of multithreading support that the function needs to be updated.
> > (If it is implemented in a way that requires updating, if you check the machine
> > version it doesn't)
> > In any case, the name you suggested isn't very descriptive.
> 
> I think we care about this machine and olders.
> Olders do not support topology so this, Multithreading (MT) does not mater.
> This machine support topology, if I follow Cedric advise, the 
> "max_thread" will/may be introduce before the topology.
> 
> This in fact is not an implementation for MT or does not allow the 
> implementation of MT it is only a way to get rid of the false 
> information given to the user that we accept MT.
> 
> So I think that when we introduce MT we will take care of making things 
> right at this place as in other places of the code.
> 
> What about we keep the original:
> 
>      topo->cpus = ms->smp.cores * ms->smp.threads;

If topology is only supported for new machines and not the old machines
for which you set max_threads to a compatibility value (max cpus), then
you should just ignore the threads, cpus == cores.
(There might not be any point in keeping a topo->cpus member in this case, I haven't checked)
> 
> Which does not do any arm to machines without MT ?
> 
> Regards,
> Pierre
> 

