Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3792B52623F
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 14:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356173AbiEMMqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 08:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232952AbiEMMq2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 08:46:28 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A201369CB;
        Fri, 13 May 2022 05:46:11 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24DABdLT016290;
        Fri, 13 May 2022 12:46:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GhuFD0tvpplEZPHGUR68GSVygjd+mUt0FdZPJzquy6I=;
 b=FHeGXKV3N1oe8/iQrMyPJ7HrBgEYefdZtscz/pDnAMMl2xdsbCFDlr/dGiPB51A7H29P
 SchdcW+Sn9B/q40+np2iAE6ON7VoVanVh0ovgysuFJiYmuX0YoZTDUJdTbq9PspCzrla
 2uchc+Ou+d5ZNMaTwp0UmlalJjvmq3ftsIKAKFjRR2dqapGhDqKsKRzHTQHuJricn8kb
 zdtIhW3v89kjGuUJ2JVa9EuG2YmtjhceuWSbTFu+4W1CcsL34iRuKh5PtbdU9WGJFF6n
 IBuVH8Jt6HZL2KIl8VQBmNsNXNCFcNS3bzSbCFXvzNUjqMT6UW7H7FRiFv/7U/1Spm03 iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1mxr37th-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 12:46:10 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24DCj3qu015734;
        Fri, 13 May 2022 12:46:10 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1mxr37sy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 12:46:09 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24DCVXxT005694;
        Fri, 13 May 2022 12:46:08 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3fyrkk4hvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 12:46:08 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24DCk57g43712884
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 May 2022 12:46:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDAD24C050;
        Fri, 13 May 2022 12:46:04 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A57D84C04A;
        Fri, 13 May 2022 12:46:04 +0000 (GMT)
Received: from [9.171.38.167] (unknown [9.171.38.167])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 May 2022 12:46:04 +0000 (GMT)
Message-ID: <a2e497b3-7d86-280c-f483-9ba20707294b@linux.ibm.com>
Date:   Fri, 13 May 2022 14:46:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: add migration test for
 storage keys
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
References: <20220512140107.1432019-1-nrb@linux.ibm.com>
 <20220512140107.1432019-3-nrb@linux.ibm.com>
 <5781a3a7-c76c-710d-4236-b82f6e821c48@linux.ibm.com>
 <20220513143323.25ca256a@p-imbrenda>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220513143323.25ca256a@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RepaHimRdFn7dpsgbeKjHvNEUbR_cCW8
X-Proofpoint-ORIG-GUID: s1h4AuQTuI1Qi_LqhCpdVeBbihlxS-1A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_04,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 spamscore=0 bulkscore=0 impostorscore=0 clxscore=1015
 adultscore=0 malwarescore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130055
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/13/22 14:33, Claudio Imbrenda wrote:
> On Fri, 13 May 2022 13:04:34 +0200
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
>> On 5/12/22 16:01, Nico Boehr wrote:
>>> Upon migration, we expect storage keys being set by the guest to be preserved,
>>> so add a test for it.
>>>
>>> We keep 128 pages and set predictable storage keys. Then, we migrate and check
>>> they can be read back and the respective access restrictions are in place when
>>> the access key in the PSW doesn't match.
>>>
>>> TCG currently doesn't implement key-controlled protection, see
>>> target/s390x/mmu_helper.c, function mmu_handle_skey(), hence add the relevant
>>> tests as xfails.
>>>
>>> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
>>> ---
>>>  s390x/Makefile         |  1 +
>>>  s390x/migration-skey.c | 98 ++++++++++++++++++++++++++++++++++++++++++
>>>  s390x/unittests.cfg    |  4 ++
>>>  3 files changed, 103 insertions(+)
>>>  create mode 100644 s390x/migration-skey.c
>>>

[...]

>>> +	for (i = 0; i < NUM_PAGES; i++) {
>>> +		report_prefix_pushf("page %d", i);
>>> +
>>> +		page = &pagebuf[i][0];
>>> +		actual_key.val = get_storage_key(page);
>>> +		expected_key.val = i * 2;
>>> +
>>> +		/* ignore reference bit */
>>> +		actual_key.str.rf = 0;
>>> +		expected_key.str.rf = 0;
>>> +
>>> +		report(actual_key.val == expected_key.val, "expected_key=0x%x actual_key=0x%x", expected_key.val, actual_key.val);
>>> +
>>> +		/* ensure access key doesn't match storage key and is never zero */
>>> +		mismatching_key.str.acc = expected_key.str.acc < 15 ? expected_key.str.acc + 1 : 1;
>>> +		*page = 0xff;
>>> +
>>> +		expect_pgm_int();
>>> +		asm volatile (
>>> +			/* set access key */
>>> +			"spka 0(%[mismatching_key])\n"
>>> +			/* try to write page */
>>> +			"mvi 0(%[page]), 42\n"
>>> +			/* reset access key */
>>> +			"spka 0\n"
>>> +			:
>>> +			: [mismatching_key] "a"(mismatching_key.val),
>>> +			  [page] "a"(page)
>>> +			: "memory"
>>> +		);
>>> +		check_pgm_int_code_xfail(host_is_tcg(), PGM_INT_CODE_PROTECTION);
>>> +		report_xfail(host_is_tcg(), *page == 0xff, "no store occured");  
>>
>> What are you testing with this bit? If storage keys are really effective after the migration?
>> I'm wondering if using tprot would not be better, it should simplify the code a lot.
>> Plus you'd easily test for fetch protection, too.
> 
> on the other hand you could have tprot successful, but then not honour
> the protection it indicates (I don't know how TPROT is implemented in
> TCG)

Not at all with regards to skeys. But neither is checking the keys on access.
And for kvm, both TPROT and checking is handled by SIE.
> 
> to be fair, this test is only about checking that storage keys are
> correctly migrated, maybe the check for actual protection is out of
> scope
> 

Having more tests does no harm and might uncover things nobody thought of,
but I'd also be fine with keeping it short and sweet.
[...]

