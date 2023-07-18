Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2043E757BBA
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 14:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbjGRMZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 08:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbjGRMZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 08:25:47 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A869AE55
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 05:25:46 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36ICFJl8030834;
        Tue, 18 Jul 2023 12:25:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=u6N+hvd5JoqV6+4Cw4qLWUImJU/KW0gqzHgq23yxHu8=;
 b=R2a2UjznIDT7IysUT0QC0YPCZEITQ1BNTYC57259yuWAEV8MkCYTHDssF7toxzd1hjRI
 I03f6iSHfk2Ft5LNrW5PzxL2LVA7D9naB5r4vdWoy9E/QRSUuEGfn7XmNEG4ONXgZ7wZ
 XAWHjpF4ioMgZ0dQFjhC0WlCOGuqiGnvxdeNpnQq3CD72vGGx3xRiS80btWN74c/aGBh
 3jZqQbYM6doJ/+7WmwjJxn6tj2vL6x7rybUxZm+ZdVwyuXgetMfwYPyWWHTB4rIcOdhn
 1KkrLvvJDyo6YOLe3REg/u0ZBhV+ratIHGZuoZmEOwYQgcTd4IY9ZLx4TaOa5cPCWb2s qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rwtk089h4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jul 2023 12:25:38 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36ICHHxx007461;
        Tue, 18 Jul 2023 12:25:38 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rwtk089gv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jul 2023 12:25:38 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36I8GoxY004183;
        Tue, 18 Jul 2023 12:25:37 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3rv8g0wpaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jul 2023 12:25:37 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36ICPXUU19137142
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jul 2023 12:25:33 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 368FD2004D;
        Tue, 18 Jul 2023 12:25:33 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E596D20040;
        Tue, 18 Jul 2023 12:25:31 +0000 (GMT)
Received: from [9.171.12.30] (unknown [9.171.12.30])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 18 Jul 2023 12:25:31 +0000 (GMT)
Message-ID: <d2de100c-621d-126d-42e0-34bfa642cf60@linux.ibm.com>
Date:   Tue, 18 Jul 2023 14:25:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v21 08/20] qapi/s390x/cpu topology: set-cpu-topology qmp
 command
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-9-pmorel@linux.ibm.com>
 <23b69647bf18028ce568e5c4b4078b8048b5febc.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <23b69647bf18028ce568e5c4b4078b8048b5febc.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yfdnG2zsVgDmBD9GlVRAjSd2Sr2O1i1X
X-Proofpoint-GUID: 166wcCJgyBEafcw4iCNkA6n3GaYEbz0r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-18_09,2023-07-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 adultscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307180110
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/18/23 09:54, Nina Schoetterl-Glausch wrote:
> On Fri, 2023-06-30 at 11:17 +0200, Pierre Morel wrote:
>> The modification of the CPU attributes are done through a monitor
>> command.
>>
>> It allows to move the core inside the topology tree to optimize
>> the cache usage in the case the host's hypervisor previously
>> moved the CPU.
>>
>> The same command allows to modify the CPU attributes modifiers
>> like polarization entitlement and the dedicated attribute to notify
>> the guest if the host admin modified scheduling or dedication of a
>> vCPU.
>>
>> With this knowledge the guest has the possibility to optimize the
>> usage of the vCPUs.
>>
>> The command has a feature unstable for the moment.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>


Thanks,

Pierre

