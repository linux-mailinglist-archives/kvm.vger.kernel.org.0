Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70EA46316FC
	for <lists+kvm@lfdr.de>; Sun, 20 Nov 2022 23:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiKTWz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Nov 2022 17:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKTWz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Nov 2022 17:55:27 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911F72AE35
        for <kvm@vger.kernel.org>; Sun, 20 Nov 2022 14:55:25 -0800 (PST)
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AKLfP8v005024;
        Sun, 20 Nov 2022 14:55:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=GJeXqpDHgyh0YCTgJnnjR5U5XH9EvDHDAi6wF4aODWo=;
 b=NbFPtk1OnwvWt1bhfjYYmYPVu1CBGvIemrrjQxOFzgeEYYc+4gLc4CQqkwtA27jJUWQN
 EGYaKLGTJmq7NzOMOYkowkOenKgyau5IanUlTLJ/ulyBUMeKn9suztlFLquqPZL4ljZj
 4mfKSnEQPjdrXgVPcwir1ZxzlcS3Ku45qjcY9RBfFdzGw+FSqyEs41yHRlZJ7QRbCkE1
 Omyr9NWQ/A5ZG8KjnE1faS7larir/nuCOcqQyjJsuAe9TI4Mj4Oc/EOo9jLbZ8rfvVqO
 M5xtjhpO/RLO3Qgs+0V+uf2wQI0OoQwoubyL1NuG6qUMZo6PNowihdq2fCj20zW+SB08 aw== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3kxyk32jwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 20 Nov 2022 14:55:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l/4ylUEgjimf9HIUEQNNJ6KcC9oEkRBZKaeg6hPpoEh+2KGEdPSE/cJC4hHJxAa7N7i8HckaLmGZqvtQhXnMB6vRBYj1yM9r440FmCWewJu6/WeMP/YWNPp1URkLga6b4DTt0xuWO1RVJf66zKQSbOKlH1IsA9NAebK5/XBakaTHaH8aTZeUILmBf40s17CDo5Q2HeFQq72TzRlLzvpQmIzPge58ru8ujNHE7BNopG+hWd9wyYS6OaelX4zkswRvNP9rcNPKHQmcroLnXemRZzwDBIROahyJO2wCW/J+Nd9hCZuj2X/sFd/BfycI5kLbSsSy2srqPaRv73d3hbPZ1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GJeXqpDHgyh0YCTgJnnjR5U5XH9EvDHDAi6wF4aODWo=;
 b=iqKo37cpzURRFo863NVZQuv8l55Ukca+Ux/9MqyC2sLrpqeTvgRrksbcZ9CKtO/HwfHccxGo8w2ww/2fLNd83fltd/zmb1A/IKWwAPeWWjY9p270sgqaQqRUIXMPGqDvxw0hOUQhxt5fpXYimtthOhDtqBPocWf4R+GAVmeFPC+F/RXMkfZNQC5r28N65ekRsmjThQotAVEBWLED75iRdCKJeFionsnTyfEfJQrBAAPQ3AmViWqLR/bNeluS1DEWmh1ptMVxYf1alrHsrvR1Ol3L/JCtLTW6jxYUtT3oe5dvxFNxvM7HscXnQaxX+stS55NpOBGbjoJ/EWxcbEkGJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GJeXqpDHgyh0YCTgJnnjR5U5XH9EvDHDAi6wF4aODWo=;
 b=LzQEzrlpV40IIEk30VP4+61SXSxTf63PuzuCWu0bzkW+fUng2iOGpCZqQcfV9+pRGHYcG23rAVyLfOz8hD9Tq3zlCLviGN0RHJlseCiKPZuGBPpjwU2QBDrf5LJbNSAPJLuhqRThYI4qgY7vl29SdWvDdQ0AJwIDMFo0Bb3Njj7Cq7Rl/F4PcYVI9TFtHFMvQuXXOlOGyjotzhCZveGhiXpezr7obT+HD1YI4COex1E19rnQPeMYEH5CeQ0eUrr0Z6YphK+3NR27AD2aCsPEsZlJ2J0QAr3sGnAEOtfAhrS1Ui0an5SDpM/JqkhJuDd8qua60KMFnWjXZzI7u8EEHg==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by CH0PR02MB8107.namprd02.prod.outlook.com (2603:10b6:610:10c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Sun, 20 Nov
 2022 22:55:12 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8779:9a4f:69d6:a301]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8779:9a4f:69d6:a301%7]) with mapi id 15.20.5834.015; Sun, 20 Nov 2022
 22:55:12 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, peterx@redhat.com, david@redhat.com,
        quintela@redhat.com, dgilbert@redhat.com, kvm@vger.kernel.org,
        Shivam Kumar <shivam.kumar1@nutanix.com>
Subject: [RFC PATCH 0/1] QEMU: Dirty quota-based throttling of vcpus
Date:   Sun, 20 Nov 2022 22:54:57 +0000
Message-Id: <20221120225458.144802-1-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::23) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|CH0PR02MB8107:EE_
X-MS-Office365-Filtering-Correlation-Id: 29030c1e-f553-49ea-61cf-08dacb4a4700
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8a+jmOJerrfKYNy089tB6hquePtO5sjmQUtOoviK031nOMSGfc7D76bAwYfJXksGd8zKJX4I5SdDyhRyw4RV2qSFEH1aOkbhaiqTan78v1I5hOWoTYdMOng4YOnsyYXCTr13LnxI2aCBBa7mnk/4WGz78P/waJQKEkNKvnfRQU4BanQDbNlBFb7/GvcOoxKukJQP9hvt+chSsI93WkDiA3v/oNSWzg8+nGoNKJsAvpz2mey9uaYuKJKmg8lFDuzVovqyVY4rNd/2H1T9xtX3diaiBv81b3kyVfzWe1GUoTYiisUrcEVVRJ0XNHRFZuyd8HWP11TJrXA+EnwhSorK0itxoXDO+vZ6r9r9m7c2ae7wYlcD0raELT1mk7jGany7/1Wy0Fm2vd8gUwxBgbYH8KyWda9D6RsbOlVduxeI9fH08DD4/No7Azy0JSRwCFa4m8vY5G09npFz7w/inwNMl12Li3JVnj0ssFutAPpRgYzMNBcdr+/4LTP5CF3Y59TN5KcXeWjsDBGwuzU0aDKObRKKMKfFI+YsvI2Yzmf8QhwAfZSDoNEPrZqQfh3ImOG//EVNwmfN8VEGkH2ul3OCCBtenKoXb4yeLhY2MlkYaazACT5NfKlmnXgx/DxvjaJn8Z/geM/Ncqu6tQ61LbFQ1PWn/PB/VWaiOy5hdrZQSf5dwtcukyboGEeOHZdEcQoupYaH6WrXHcPFCTPsN86wt9+mRjZr9vtKjAuQkM2Gbvxyvz9EV4uTHZqDNt5PxbfJxyDno6hFfNN9pvQsJlZfpRt/vbAuKRYyojNPHUSmL2A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(366004)(376002)(39850400004)(451199015)(107886003)(6486002)(966005)(6506007)(52116002)(316002)(66946007)(66556008)(478600001)(6916009)(6666004)(36756003)(86362001)(2616005)(186003)(1076003)(38100700002)(83380400001)(26005)(6512007)(5660300002)(8936002)(66476007)(38350700002)(4326008)(41300700001)(8676002)(2906002)(15650500001)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o+BDSGnhzOJuJvbyPC9+g8k2nOfdSAYaWD5JhaYPw5E/y3pmQSX/QcY/h6Vs?=
 =?us-ascii?Q?y4Uv7b4T2RePGayd2vAEHnvtLAittmC0JIWf6lLkgsy545eGlZGhkwALLFRM?=
 =?us-ascii?Q?qmy/pJi0OfpLSPLNnUpbMi2XDsHGlhtqe4k29TiC27RUleJ9u34pqbT0tLcl?=
 =?us-ascii?Q?bZqYGYYLBC03Tn6EtBuBdFNE0YWaTUX8QXVPib02KGAMvXFHV+I6dO6abpNM?=
 =?us-ascii?Q?H6TVsy8QzYUEAMzV4nzlRDEouVht74tmWz5K2HMRdpU1WB/QNBpIROvJ7wKm?=
 =?us-ascii?Q?dal7ljAdrb2t0WSIufRmy4AK4cOv+E1/pXT3b9NIx6ddYfrtFspGoA4VNlsL?=
 =?us-ascii?Q?t/lMjeSQzoisqcE5DLVNY5apx8V8DbIkM48ji3MqTWkqXwaTzCae/CFQYB2A?=
 =?us-ascii?Q?3xUkrBHDADovBRHbV7OkxvYOeNgav6jyiS9tAOELhHnBjqm74DR9OEvvYgNE?=
 =?us-ascii?Q?n7hq2xJnq8k1DgMtQJY28CMUV2GbqzvVBbq9HtPCfm4e6anDK5D4AvtS/K/C?=
 =?us-ascii?Q?Qg+R2IJjCLWhUzCC6jIqj3WtEpyc7oCoR85OPcOZBxxYGkCOsQDkFX8N6Sjl?=
 =?us-ascii?Q?9q0WDzskyTejZvTQNeSzhImbI9rfSDHIqkWSop0tHLXa8q+mzM2BSH878XIQ?=
 =?us-ascii?Q?PIP0l26MStbnErvtFn33MVfpqYTGKN5/K/M9FrB70JbMTiv4FDGM0+Hpi4KB?=
 =?us-ascii?Q?nKb5IGD5Y1CnpyoyNfi9++QFHCMhd+RWupqvQR4lhVtmihkRsz2i8+kQsYjR?=
 =?us-ascii?Q?DWKOyXiuSK59+QnD43jkwYFScBgvLQq6PTPHz/ga1XtSUvXreDERm/FoT11d?=
 =?us-ascii?Q?oJ/VJyb//uSfUeXoBywKSvPsnNwL10ZKzVsgWhAJNmWngRYq3XvBgDoeHIao?=
 =?us-ascii?Q?EuYYPyTc8Zd/HcQdjOfvOijDHhjcqThcTvYogGIlhFenMpobtTwIexg1Bpa6?=
 =?us-ascii?Q?rwkO3YihiknSF+op5tKROQQruzeRLdKk5YHIU8tA5GZG26Wy5UvKCyesTGty?=
 =?us-ascii?Q?K0Ov56De1rygzzC6yaUEeGSNJQfAXk6yq4aVbRfl14aO3Usx7t3kBWLvAjcI?=
 =?us-ascii?Q?TrieIAbxQl+b++Ic+mhDLXHMVa8Ov4RTeiXuxX5i7JSIQlYOTTId69RtNS4Q?=
 =?us-ascii?Q?iRBACUm6VbsPgkez1QpfyY4NoXWj3G8gXxXcrIL4aRvQTMjT2rSLWx1nvnYP?=
 =?us-ascii?Q?QwoJO8sfgsDK+glfqXkQ8dRUkRka1lZf2sxJqMlkNAtJR5bs7UrWYkmHBdg8?=
 =?us-ascii?Q?AnvoSdUbgoTg7HT/8RQY6gvz8EXF9ue7/GvA1cKB5Ba3mOJMo4QdZzB1t/mw?=
 =?us-ascii?Q?rAEZKAYz5OYz9qvEt38ZumJGzR4A5GW+5Yz54RC3TiJyoGoR9fKE0QbViIu6?=
 =?us-ascii?Q?4vSwghOhbag/kqUMyssxLp+mFbk0keO74TXEUenmpSFStNyCB7Zn7Qxaamdm?=
 =?us-ascii?Q?nh8KWVKzwjI+DitpodyJuPRIq4W8np6MnkkIHkO9g5txsnX1SOc82a5eP5Or?=
 =?us-ascii?Q?Fom159xpSNhK54zXbqhFaMsJzPmVlYrpFRlY3vD4jMi411MYrj04Addr6KNF?=
 =?us-ascii?Q?lstMLaljNUnqUUCqPRqiTzYa58QdjNWLeKqBkS4ym9YF8sFSJswBxoAAMo+b?=
 =?us-ascii?Q?3A=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29030c1e-f553-49ea-61cf-08dacb4a4700
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2022 22:55:12.1172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mgbAfreD/2lXE+XzIDCA6Pihaz+9V/jyHsagUiYSmck6hYonjZCY+C/AsWbA/kBEGAVNPuKdOVoRGc9Bil/iaH7RRbZAEqEGZmDar1HRW1Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB8107
X-Proofpoint-ORIG-GUID: ixWN9BkW7ejr2qilxBOJWQTw24GZESxC
X-Proofpoint-GUID: ixWN9BkW7ejr2qilxBOJWQTw24GZESxC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-20_13,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset is the QEMU-side implementation of a (new) dirty "quota"
based throttling algorithm that selectively throttles vCPUs based on their
individual contribution to overall memory dirtying and also dynamically
adapts the throttle based on the available network bandwidth.

Overview
----------
----------

To throttle memory dirtying, we propose to set a limit on the number of
pages a vCPU can dirty in given fixed microscopic size time intervals. This
limit depends on the network throughput calculated over the last few
intervals so as to throttle the vCPUs based on available network bandwidth.
We are referring to this limit as the "dirty quota" of a vCPU and
the fixed size intervals as the "dirty quota intervals". 

One possible approach to distributing the overall scope of dirtying for a
dirty quota interval is to equally distribute it among all the vCPUs. This
approach to the distribution doesn't make sense if the distribution of
workloads among vCPUs is skewed. So, to counter such skewed cases, we
propose that if any vCPU doesn't need its quota for any given dirty
quota interval, we add this quota to a common pool. This common pool (or
"common quota") can be consumed on a first come first serve basis
by all vCPUs in the upcoming dirty quota intervals.


Design
----------
----------

Userspace                                 KVM

[At the start of dirty logging]
Initialize dirty quota to some            
non-zero value for each vcpu.    ----->   [When dirty logging starts]
                                          Start incrementing dirty count
                                          for every dirty by the vcpu.

                                          [Dirty count equals/exceeds
                                          dirty quota]
If the vcpu has already claimed  <-----   Exit to userspace.
its quota for the current dirty           
quota interval:

        1) If common quota is
        available, give the vcpu
        its quota from common pool.

        2) Else sleep the vcpu until
        the next interval starts.

Give the vcpu its share for the
current(fresh) dirty quota       ----->  Continue dirtying with the newly
interval.                                received quota.  

[At the end of dirty logging]             
Set dirty quota back to zero
for every vcpu.                 ----->   Throttling disabled.


References
----------
----------

KVM Forum Talk: https://www.youtube.com/watch?v=ZBkkJf78zFA
Kernel Patchset:
https://lore.kernel.org/all/20221113170507.208810-1-shivam.kumar1@nutanix.com/


Note
----------
----------

We understand that there is a good scope of improvement in the current
implementation. Here is a list of things we are working on:
1) Adding dirty quota as a migration capability so that it can be toggled
through QMP command.
2) Adding support for throttling guest DMAs.
3) Not enabling dirty quota for the first migration iteration.
4) Falling back to current auto-converge based throttling in cases where dirty
quota throttling can overthrottle.

Please stay tuned for the next patchset.

Shivam Kumar (1):
  Dirty quota-based throttling of vcpus

 accel/kvm/kvm-all.c       | 91 +++++++++++++++++++++++++++++++++++++++
 include/exec/memory.h     |  3 ++
 include/hw/core/cpu.h     |  5 +++
 include/sysemu/kvm_int.h  |  1 +
 linux-headers/linux/kvm.h |  9 ++++
 migration/migration.c     | 22 ++++++++++
 migration/migration.h     | 31 +++++++++++++
 softmmu/memory.c          | 64 +++++++++++++++++++++++++++
 8 files changed, 226 insertions(+)

-- 
2.22.3

