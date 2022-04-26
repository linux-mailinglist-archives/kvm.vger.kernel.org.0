Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0DE50F9EF
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 12:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348596AbiDZKQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 06:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348598AbiDZKQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 06:16:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C62C43385;
        Tue, 26 Apr 2022 02:39:42 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23Q9CCCA012220;
        Tue, 26 Apr 2022 09:39:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wf2o/TngjbdQCkWU8ln2Fq1y+dpilYYa4+CZjwx8RKI=;
 b=ake9Gj4VuU6VZUKVMpccI0CiI0mAAuo2uyK8fL1s4zyN79eRDlnkuz3Og6+eKkgTYVdN
 RSvaQ09ndJ9R3fh18E/GGvb8/xOqDD8somytFxZGTisHGQqL9QqUhkWwNKs0QVsZzGrp
 dFe1Tojz04/LRBSgz2MhdgLKozSzV2434pZhdDmenad31y9tnyylOTRssxXnmuT/e37a
 euJQrxQSr/AdI4V0N+7KLbvArjwmNzhzwTjjA6AlgI78M1oVHDAEhKAXMK8xa0QkdH1t
 dF9P1h5HBQ/GxZx6Hmw6h6h/jbaCM8BA9q/DBEbAhi5YFTV3/FA3XCYR2AIRl80ZRxLE Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpdw2rfcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 09:39:41 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23Q9cSPL015877;
        Tue, 26 Apr 2022 09:39:40 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpdw2rfca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 09:39:40 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23Q9dCLY024841;
        Tue, 26 Apr 2022 09:39:38 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3fm938u802-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 09:39:38 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23Q9QX0n41091366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 09:26:33 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 103004C046;
        Tue, 26 Apr 2022 09:39:35 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAAB74C044;
        Tue, 26 Apr 2022 09:39:34 +0000 (GMT)
Received: from [9.145.85.71] (unknown [9.145.85.71])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 26 Apr 2022 09:39:34 +0000 (GMT)
Message-ID: <81a99617-d6ab-959c-be0c-73622cbf1203@linux.ibm.com>
Date:   Tue, 26 Apr 2022 11:39:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v4 5/5] s390x: uv-guest: Add attestation
 tests
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220421094527.32261-1-seiden@linux.ibm.com>
 <20220421094527.32261-6-seiden@linux.ibm.com>
 <ad44e7d2-6123-1981-b103-e5d9cc497c4c@linux.ibm.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
Organization: IBM
In-Reply-To: <ad44e7d2-6123-1981-b103-e5d9cc497c4c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: a9VjrP3foWgrhkGx3B7WXempjrD4OCSm
X-Proofpoint-GUID: ODjpAgKXXgVROmN2-DwfGf0-vh9bW1zs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_02,2022-04-25_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxscore=0 spamscore=0 malwarescore=0 adultscore=0
 impostorscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204260062
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Janosch,

thanks for your review.

On 4/26/22 11:22, Janosch Frank wrote:
> On 4/21/22 11:45, Steffen Eiden wrote:
>> Adds several tests to verify correct error paths of attestation.
>>
>> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
>> ---
>>   lib/s390x/asm/uv.h |   5 +-
>>   s390x/Makefile     |   1 +
>>   s390x/pv-attest.c  | 225 +++++++++++++++++++++++++++++++++++++++++++++
>>   s390x/uv-guest.c   |  13 ++-
>>   4 files changed, 240 insertions(+), 4 deletions(-)
>>   create mode 100644 s390x/pv-attest.c
>>
>> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
>> index 7c8c399d..38920461 100644
>> --- a/lib/s390x/asm/uv.h
>> +++ b/lib/s390x/asm/uv.h
>> @@ -108,7 +108,10 @@ struct uv_cb_qui {
>>       u8  reserved88[158 - 136];    /* 0x0088 */
>>       uint16_t max_guest_cpus;    /* 0x009e */
>>       u64 uv_feature_indications;    /* 0x00a0 */
>> -    u8  reserveda8[200 - 168];    /* 0x00a8 */
>> +    uint8_t  reserveda8[224 - 168];    /* 0x00a8 */
>> +    uint64_t supp_att_hdr_ver;    /* 0x00e0 */
>> +    uint64_t supp_paf;        /* 0x00e8 */
>> +    uint8_t  reservedf0[256 - 240];    /* 0x00f0 */
>>   }  __attribute__((packed))  __attribute__((aligned(8)));
>>   struct uv_cb_cgc {
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index 8ff84db5..5a49d1e7 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -29,6 +29,7 @@ tests += $(TEST_DIR)/mvpg-sie.elf
>>   tests += $(TEST_DIR)/spec_ex-sie.elf
>>   tests += $(TEST_DIR)/firq.elf
>>   tests += $(TEST_DIR)/epsw.elf
>> +tests += $(TEST_DIR)/pv-attest.elf
>>   pv-tests += $(TEST_DIR)/pv-diags.elf
>> diff --git a/s390x/pv-attest.c b/s390x/pv-attest.c
>> new file mode 100644
>> index 00000000..e31780a3
>> --- /dev/null
>> +++ b/s390x/pv-attest.c
>> @@ -0,0 +1,225 @@
> [...]
>> +
>> +static void test_attest_v1(uint64_t page)
>> +{
>> +    struct uv_cb_attest uvcb = {
>> +        .header.cmd = UVC_CMD_ATTESTATION,
>> +        .header.len = sizeof(uvcb),
>> +    };
>> +    const struct uv_cb_qui *uvcb_qui = uv_get_query_data();
>> +    struct attest_request_v1 *attest_req = (void *)page;
>> +    struct uv_arcb_v1 *arcb = &attest_req->arcb;
>> +    int cc;
>> +
>> +    report_prefix_push("v1");
>> +    if (!test_bit_inv(0, &uvcb_qui->supp_att_hdr_ver)) {
>> +        report_skip("Attestation version 1 not supported");
>> +        goto done;
>> +    }
>> +
>> +    memset((void *)page, 0, PAGE_SIZE);
>> +
>> +    /*
>> +     * Create a minimal arcb/uvcb such that FW has everything to start
>> +     * unsealing the request. However, this unsealing will fail as the
>> +     * kvm-unit-test framework provides no cryptography functions that
>> +     * would be needed to seal such requests.
>> +     */
>> +    arcb->req_ver = ARCB_VERSION_1;
>> +    arcb->req_len = sizeof(*arcb);
>> +    arcb->nks = 1;
>> +    arcb->sea = sizeof(arcb->meas_key);
>> +    arcb->plaint_att_flags = PAF_PHKH_ATT;
>> +    arcb->meas_alg_id = ARCB_MEAS_HMAC_SHA512;
>> +    uvcb.arcb_addr = (uint64_t)&attest_req->arcb;
>> +    uvcb.measurement_address = (uint64_t)attest_req->measurement;
>> +    uvcb.measurement_length = sizeof(attest_req->measurement);
>> +    uvcb.add_data_address = (uint64_t)attest_req->additional;
>> +    uvcb.add_data_length = sizeof(attest_req->additional);
>> +
>> +    uvcb.continuation_token = 0xff;
>> +    cc = uv_call(0, (uint64_t)&uvcb);
>> +    report(cc == 1 && uvcb.header.rc == 0x0101, "invalid continuation 
>> token");
> 
> Please don't add the 0 to the front of the rc values.
OK
> 
> [...]
> 
>> @@ -111,8 +120,6 @@ static void test_sharing(void)
>>       cc = uv_call(0, (u64)&uvcb);
>>       report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED, "unshare");
>>       report_prefix_pop();
>> -
>> -    report_prefix_pop();
> 
> That's unrelated, no?
Right, it is now unrelated. I forgot to remove that change for v4.
  In the previous version this double pop would mess with the output as
`test_sharing` was not the last test in that file
(attestation test followed).
I'll add another fix patch for this.

> 
>>   }
>>   static struct {
> 

Steffen
