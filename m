Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A150F6D5F41
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 13:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234468AbjDDLkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 07:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbjDDLkB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 07:40:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557268F
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 04:40:00 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3349kVlS032887;
        Tue, 4 Apr 2023 11:39:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5M3KptzvVMXLKqcU+fyWOaCQnyZjY4gNixVaLfPF6QQ=;
 b=WSMWNYa6VplrmeR7zZGZplVorThVplGEgqfR+BgH/lIcUJmMSWDNZx5I0wW/2rqawkQE
 4tdllvpfwjTh7c7x88F9mpOH1o0cZ2H6jKMdPxidpQIlSQ4B8sn99dXJWk5EndLgT3yS
 DY/c/XrdLhWFq7Q+29SfBmKklTSyFcUzdIzO/XH6WjcD0WdAAYwtRnyoX5/+S4DGLYqS
 zdGzcpGgI34dvhLX+mh67XEahvTCrRrHhDJm5QTydH8zqD45qnFfN+m7kOzJD9qs0FQ2
 KLwXBYES/dQhEiR0nuXBodT1VW40t1zdT/6eaJ/ZXLN+pmeu9K1C4Wo6Yfjn84Bl//Wi AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prhjd2ncp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:39:47 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3349uvXx034449;
        Tue, 4 Apr 2023 11:39:46 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prhjd2nbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:39:46 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3344L7o7025622;
        Tue, 4 Apr 2023 11:39:42 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3ppbvg2ftk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:39:42 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334BdcU744892580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 11:39:38 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AAF420043;
        Tue,  4 Apr 2023 11:39:38 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C7BE2004B;
        Tue,  4 Apr 2023 11:39:37 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue,  4 Apr 2023 11:39:37 +0000 (GMT)
Message-ID: <c4b05d61-75af-8c90-df7c-9ed09612b879@linux.ibm.com>
Date:   Tue, 4 Apr 2023 13:39:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v19 02/21] s390x/cpu topology: add topology entries on CPU
 hotplug
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
 <20230403162905.17703-3-pmorel@linux.ibm.com>
 <7affffef-8d04-ac9f-0920-f765d362d60d@kaod.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <7affffef-8d04-ac9f-0920-f765d362d60d@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EzAFr4alKHCJrvAKsWSKbC0WhgaoLKdl
X-Proofpoint-ORIG-GUID: jswu3TboVL1qKbWQIzzxlAig-bFvlfpR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_04,2023-04-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 suspectscore=0
 clxscore=1015 phishscore=0 adultscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304040107
X-Spam-Status: No, score=-2.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/4/23 09:31, Cédric Le Goater wrote:
> On 4/3/23 18:28, Pierre Morel wrote:
>>

[...]


>> +
>> +/**
>> + * s390_socket_nb:
>> + * @cpu: s390x CPU
>> + *
>> + * Returns the socket number used inside the cores_per_socket array
>> + * for a cpu.
>> + */
>> +int s390_socket_nb(S390CPU *cpu)
>
> s390_socket_nb() doesn't seem to be used anywhere else than in
> hw/s390x/cpu-topology.c. It should be static.


right

[...]
>> +/**
>> + * s390_topology_add_core_to_socket:
>> + * @cpu: the new S390CPU to insert in the topology structure
>> + * @drawer_id: new drawer_id
>> + * @book_id: new book_id
>> + * @socket_id: new socket_id
>> + * @creation: if is true the CPU is a new CPU and there is no old 
>> socket
>> + *            to handle.
>> + *            if is false, this is a moving the CPU and old socket 
>> count
>> + *            must be decremented.
>> + * @errp: the error pointer
>> + *
>> + */
>> +static void s390_topology_add_core_to_socket(S390CPU *cpu, int 
>> drawer_id,
>> +                                             int book_id, int 
>> socket_id,
>> +                                             bool creation, Error 
>> **errp)
>> +{
>
> Since this routine is called twice, in s390_topology_setup_cpu() for
> creation, and in s390_change_topology() for socket migration, we could
> duplicate the code in two distinct routines.
>
> I think this would simplify a bit each code path and avoid the 'creation'
> parameter which is confusing.


right

Thanks.


>
>
>> +    int old_socket_entry = s390_socket_nb(cpu);
>> +    int new_socket_entry;
>> +
>> +    if (creation) {
>> +        new_socket_entry = old_socket_entry;
>> +    } else {
>> +        new_socket_entry = (drawer_id * s390_topology.smp->books + 
>> book_id) *
>> +                            s390_topology.smp->sockets + socket_id;
>
> A helper common routine that s390_socket_nb() could use also would be 
> a plus.


Yes, thanks


>
>> +    }
>> +
>> +    /* Check for space on new socket */
>> +    if ((new_socket_entry != old_socket_entry) &&
>> +        (s390_topology.cores_per_socket[new_socket_entry] >=
>> +         s390_topology.smp->cores)) {
>> +        error_setg(errp, "No more space on this socket");
>> +        return;
>> +    }
>> +
>> +    /* Update the count of cores in sockets */
>> +    s390_topology.cores_per_socket[new_socket_entry] += 1;
>> +    if (!creation) {
>> +        s390_topology.cores_per_socket[old_socket_entry] -= 1;
>> +    }
>> +}
>> +
>> +/**
>> + * s390_update_cpu_props:
>> + * @ms: the machine state
>> + * @cpu: the CPU for which to update the properties from the 
>> environment.
>> + *
>> + */
>> +static void s390_update_cpu_props(MachineState *ms, S390CPU *cpu)
>> +{
>> +    CpuInstanceProperties *props;
>> +
>> +    props = &ms->possible_cpus->cpus[cpu->env.core_id].props;
>> +
>> +    props->socket_id = cpu->env.socket_id;
>> +    props->book_id = cpu->env.book_id;
>> +    props->drawer_id = cpu->env.drawer_id;
>> +}
>> +
>> +/**
>> + * s390_topology_setup_cpu:
>> + * @ms: MachineState used to initialize the topology structure on
>> + *      first call.
>> + * @cpu: the new S390CPU to insert in the topology structure
>> + * @errp: the error pointer
>> + *
>> + * Called from CPU Hotplug to check and setup the CPU attributes
>> + * before to insert the CPU in the topology.
>
> ... before the CPU is inserted in the topology.
OK
>
>> + * There is no use to update the MTCR explicitely here because it
>
> ... is no need ... sounds better.
OK
>
>> + * will be updated by KVM on creation of the new vCPU.
>
> "CPU" is used everywhere else.
OK
>
>> + */
>> +void s390_topology_setup_cpu(MachineState *ms, S390CPU *cpu, Error 
>> **errp)
>> +{
>> +    ERRP_GUARD();
>> +
>> +    /*
>> +     * We do not want to initialize the topology if the cpu model
>> +     * does not support topology, consequently, we have to wait for
>> +     * the first CPU to be realized, which realizes the CPU model
>> +     * to initialize the topology structures.
>> +     *
>> +     * s390_topology_setup_cpu() is called from the cpu hotplug.
>> +     */
>> +    if (!s390_topology.cores_per_socket) {
>> +        s390_topology_init(ms);
>> +    }
>> +
>> +    s390_topology_cpu_default(cpu, errp);
>> +    if (*errp) {
>
> May be having s390_topology_cpu_default() return a bool would be cleaner.
> Same comment for the routines below. This is minor.


Yes and it is more readable. I do it.


Thanks for the comments.

Regards,

Pierre

