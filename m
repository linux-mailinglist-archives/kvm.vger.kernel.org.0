Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A376D5FE3
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 14:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234553AbjDDMFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 08:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234665AbjDDMDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 08:03:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A692135
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 05:02:50 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3349nwvB016184;
        Tue, 4 Apr 2023 12:02:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TbysJwY2zHe6zj8FEPLRW3eHWnteIjZYOe15z9d+Csg=;
 b=puvhR0U5xdNYIPUCLigac3gUZaBuSi1pIprb4GlK6qtQgg0A/aAMfwIAfHErXl7FhZfj
 ZdOrBe02E++8yEOuTIQdYOmscYtbTqSmGFEK63Rc/dqfDnjkGQRXSCs/BkGanrHVV0It
 RdVkADrW6frYKpBc+xsynxpHyTjMq7Y4h4Lo/WcwiLIV1PyP30BcKs6I8K3l1r97eHMo
 7oRIjFlNpw7hkYkMIDzTekXobrCoJCjn6cBTnKcDnfWHkqfP6tFzAzzP7r0PDYlv7hND
 j0qvtoe7kk1a1+cdPjsboYO5xZDgmKn8UtDa8WBY/NBtPHwPqqHExF4vwgS0OgwR5xGW Pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr4d95bgj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 12:02:41 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334BFINu014345;
        Tue, 4 Apr 2023 12:02:40 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr4d95bf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 12:02:40 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3344qwQX023380;
        Tue, 4 Apr 2023 12:02:38 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3ppbvfsvs9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 12:02:38 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334C2YlH46858640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 12:02:34 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E2902004E;
        Tue,  4 Apr 2023 12:02:34 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19CA720043;
        Tue,  4 Apr 2023 12:02:34 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue,  4 Apr 2023 12:02:34 +0000 (GMT)
Message-ID: <2b3c224e-cfa2-df8f-443c-d49ced4ae29b@linux.ibm.com>
Date:   Tue, 4 Apr 2023 14:02:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v19 17/21] tests/avocado: s390x cpu topology test
 dedicated CPU
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
 <20230403162905.17703-18-pmorel@linux.ibm.com>
 <e86317ad-74d6-937e-5b48-f3ee93171ded@kaod.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <e86317ad-74d6-937e-5b48-f3ee93171ded@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fZt5OK4u7k42VpedB6PuxqUavbLf9nmo
X-Proofpoint-ORIG-GUID: nZ_GS_eCO_ZSXVza753QUAN7BEhMO5lk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_04,2023-04-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 spamscore=0 bulkscore=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304040107
X-Spam-Status: No, score=-2.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/4/23 11:19, Cédric Le Goater wrote:
> On 4/3/23 18:29, Pierre Morel wrote:
>> A dedicated CPU in vertical polarization can only have
>> a high entitlement.
>> Let's check this.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   tests/avocado/s390_topology.py | 43 +++++++++++++++++++++++++++++++++-
>>   1 file changed, 42 insertions(+), 1 deletion(-)
>>
>> diff --git a/tests/avocado/s390_topology.py 
>> b/tests/avocado/s390_topology.py
>> index f12f0ae148..6a41f08897 100644
>> --- a/tests/avocado/s390_topology.py
>> +++ b/tests/avocado/s390_topology.py
>> @@ -52,6 +52,7 @@ class S390CPUTopology(LinuxKernelTest):
>>       The polarization is changed on a request from the guest.
>>       """
>>       timeout = 90
>> +    skip_basis = False
>
> This should come through its own patch.

OK, this is more a debug help, I wonder if I should not just remove it


>
>
>>       def check_topology(self, c, s, b, d, e, t):
>> @@ -116,12 +117,14 @@ def system_init(self):
>>           exec_command_and_wait_for_pattern(self,
>>                   '/bin/cat /sys/devices/system/cpu/dispatching', '0')
>>   +    @skipIf(skip_basis, 'skipping basis tests')
>>       def test_single(self):
>>           self.kernel_init()
>>           self.vm.launch()
>>           self.wait_for_console_pattern('no job control')
>>           self.check_topology(0, 0, 0, 0, 'medium', False)
>>   +    @skipIf(skip_basis, 'skipping basis tests')
>>       def test_default(self):
>>           """
>>           This test checks the implicite topology.
>> @@ -147,6 +150,7 @@ def test_default(self):
>>           self.check_topology(11, 2, 1, 0, 'medium', False)
>>           self.check_topology(12, 0, 0, 1, 'medium', False)
>>   +    @skipIf(skip_basis, 'skipping basis tests')
>>       def test_move(self):
>>           """
>>           This test checks the topology modification by moving a CPU
>> @@ -167,6 +171,7 @@ def test_move(self):
>>           self.assertEqual(res['return'], {})
>>           self.check_topology(0, 2, 0, 0, 'low', False)
>>   +    @skipIf(skip_basis, 'skipping basis tests')
>>       def test_hotplug(self):
>>           """
>>           This test verifies that a CPU defined with '-device' 
>> command line
>> @@ -184,6 +189,7 @@ def test_hotplug(self):
>>             self.check_topology(10, 2, 1, 0, 'medium', False)
>>   +    @skipIf(skip_basis, 'skipping basis tests')
>>       def test_hotplug_full(self):
>>           """
>>           This test verifies that a hotplugged fully defined with 
>> '-device'
>> @@ -202,6 +208,7 @@ def test_hotplug_full(self):
>>           self.wait_for_console_pattern('no job control')
>>           self.check_topology(1, 1, 1, 1, 'medium', False)
>>   +    @skipIf(skip_basis, 'skipping basis tests')
>>       def test_polarisation(self):
>>           """
>>           This test verifies that QEMU modifies the entitlement 
>> change after
>> @@ -231,7 +238,7 @@ def test_polarisation(self):
>>             self.check_topology(0, 0, 0, 0, 'medium', False)
>>   -    def test_set_cpu_topology_entitlement(self):
>> +    def test_entitlement(self):
>
> May be introduce the correct name in the first patch.


right.


Thanks,

Pierre

