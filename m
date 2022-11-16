Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F1662C57D
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 17:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238523AbiKPQy4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 11:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238928AbiKPQy3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 11:54:29 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5146279
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 08:53:16 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AGGmAlS004170;
        Wed, 16 Nov 2022 16:51:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=a4xd5IvN05qgG/J49mCe9rXuFnit7YXgygEfv2XXef4=;
 b=nk/c/jTU0jhHGZkkWa2pdMGJh5uyZBJIPnYm25N30HMszxy1uzk7Un2PDetsd/zH/oWG
 JHpjaX+ftRpf9dEFjDKuiqG9Fl49um9GdowGfRzA++x71c+6Am0z++dVAa5xK3RAGi4G
 0ynHowuP+8bnD0v+uAtpKD1vAGqf9oM4kuS4D8GgNVxlZb6Nv2G2GlyLlgS0MA24BAMW
 f4kDA4LohNhZI3qipNReEieA2preGl2D7MJd7xz/Lh466oyLK/Gpll3fcgqts16PC/gW
 MD6ZWG5zfL6qqh2P08KdbAfXVK4i7sxixu9qe5iqJoIL6VHkEcOhk769jURo6nGCnOE9 Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kw3q1r36p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Nov 2022 16:51:51 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AGGmcno005830;
        Wed, 16 Nov 2022 16:51:51 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kw3q1r360-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Nov 2022 16:51:50 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AGGo6r6032686;
        Wed, 16 Nov 2022 16:51:49 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3ktbd9mcwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Nov 2022 16:51:49 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AGGpkaS5898842
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Nov 2022 16:51:46 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0499D11C04A;
        Wed, 16 Nov 2022 16:51:46 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C9B411C050;
        Wed, 16 Nov 2022 16:51:45 +0000 (GMT)
Received: from [9.171.75.44] (unknown [9.171.75.44])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 16 Nov 2022 16:51:45 +0000 (GMT)
Message-ID: <a2ddbba2-9e52-8ed8-fdbc-a587b8286576@de.ibm.com>
Date:   Wed, 16 Nov 2022 17:51:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v9 00/10] s390x: CPU Topology
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20220902075531.188916-1-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EOWPqYYjA5fSIEK3fusWU8yjdMlcJyLY
X-Proofpoint-GUID: 7PSQOZON3XbnEcOQhYTBAzovGLZpUtx1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-16_03,2022-11-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 malwarescore=0 adultscore=0 clxscore=1011
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211160115
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 02.09.22 um 09:55 schrieb Pierre Morel:
> Hi,
> 
> The implementation of the CPU Topology in QEMU has been drastically
> modified since the last patch series and the number of LOCs has been
> greatly reduced.
> 
> Unnecessary objects have been removed, only a single S390Topology object
> is created to support migration and reset.
> 
> Also a documentation has been added to the series.
> 
> 
> To use these patches, you will need Linux V6-rc1 or newer.
> 
> Mainline patches needed are:
> 
> f5ecfee94493 2022-07-20 KVM: s390: resetting the Topology-Change-Report
> 24fe0195bc19 2022-07-20 KVM: s390: guest support for topology function
> 0130337ec45b 2022-07-20 KVM: s390: Cleanup ipte lock access and SIIF fac..
> 
> Currently this code is for KVM only, I have no idea if it is interesting
> to provide a TCG patch. If ever it will be done in another series.
> 
> To have a better understanding of the S390x CPU Topology and its
> implementation in QEMU you can have a look at the documentation in the
> last patch.
> 
> New in this series
> ==================
> 
>    s390x/cpus: Make absence of multithreading clear
> 
> This patch makes clear that CPU-multithreading is not supported in
> the guest.
> 
>    s390x/cpu topology: core_id sets s390x CPU topology
> 
> This patch uses the core_id to build the container topology
> and the placement of the CPU inside the container.
> 
>    s390x/cpu topology: reporting the CPU topology to the guest
> 
> This patch is based on the fact that the CPU type for guests
> is always IFL, CPUs are always dedicated and the polarity is
> always horizontal.
> This may change in the future.
> 
>    hw/core: introducing drawer and books for s390x
>    s390x/cpu: reporting drawers and books topology to the guest
> 
> These two patches extend the topology handling to add two
> new containers levels above sockets: books and drawers.
> 
> The subject of the last patches is clear enough (I hope).
> 
> Regards,
> Pierre
> 
> Pierre Morel (10):
>    s390x/cpus: Make absence of multithreading clear
>    s390x/cpu topology: core_id sets s390x CPU topology
>    s390x/cpu topology: reporting the CPU topology to the guest
>    hw/core: introducing drawer and books for s390x
>    s390x/cpu: reporting drawers and books topology to the guest
>    s390x/cpu_topology: resetting the Topology-Change-Report
>    s390x/cpu_topology: CPU topology migration
>    target/s390x: interception of PTF instruction
>    s390x/cpu_topology: activating CPU topology


Do we really need a machine property? As far as I can see, old QEMU
cannot  activate the ctop facility with old and new kernel unless it
enables CAP_S390_CPU_TOPOLOGY. I do get
oldqemu .... -cpu z14,ctop=on
qemu-system-s390x: Some features requested in the CPU model are not available in the configuration: ctop

With the newer QEMU we can. So maybe we can simply have a topology (and
then a cpu model feature) in new QEMUs and non in old. the cpu model
would then also fence migration from enabled to disabled.
