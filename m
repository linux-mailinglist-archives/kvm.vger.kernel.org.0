Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06FF150F79F
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 11:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240251AbiDZJMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 05:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235062AbiDZJHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 05:07:05 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACA881493;
        Tue, 26 Apr 2022 01:48:16 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23Q8WqOB010831;
        Tue, 26 Apr 2022 08:48:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : from : to : cc : references : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hAK1W5voV6+T1iZ8LBtXiN2172RTlnxJd98vrlsvhTs=;
 b=HyffLHMcWYSn86XciyBG8WrZcD0xK7mlad0N90kvpxxT2xx6DU1lWncsK2Zzv5gk0b//
 OcFLNPBWQKxTkwhtTXEYjGmYqx/JYrTAOZLnMNECE2Wo/cMkjGHuL31+bTDBoAF/+sY+
 0u1oNLaiOErB1k4xeuWz1NXP5YbIqtfg2f0IxQkHQKgtDe/ryHWZMSZNtURD6Jg/q1oo
 2lW5rdZ0C/ioZTQWZCPWqgGRTT4nTEMaMvohTQfaLFdR/6OUil9IB9pySAnMMBafrglx
 CFr9akce7gSOW9JJCwGzQcc1CScTcipoZoRBjkWAPWKsLtx+eHz6ZuMgUcXIWs18hbqT 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpcv3gtue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 08:48:15 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23Q8e3HZ010440;
        Tue, 26 Apr 2022 08:48:15 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpcv3gtty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 08:48:15 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23Q8gQeO000842;
        Tue, 26 Apr 2022 08:48:13 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3fm938v28q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 08:48:13 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23Q8mAro47907180
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 08:48:10 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60B51AE045;
        Tue, 26 Apr 2022 08:48:10 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F08C8AE051;
        Tue, 26 Apr 2022 08:48:09 +0000 (GMT)
Received: from [9.145.2.160] (unknown [9.145.2.160])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 26 Apr 2022 08:48:09 +0000 (GMT)
Message-ID: <8d61269b-5a49-c277-548e-dc82dfe47f73@linux.ibm.com>
Date:   Tue, 26 Apr 2022 10:48:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220425161731.1575742-1-scgl@linux.ibm.com>
 <95769733-5a42-a61d-aee7-e78257fcd9ea@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5] s390x: Test effect of storage keys on
 some instructions
In-Reply-To: <95769733-5a42-a61d-aee7-e78257fcd9ea@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Cu0M3RG3SEdQjh8MRcXjOZf2UzAcjneT
X-Proofpoint-ORIG-GUID: csezsbjJy7zzO5tLFb8L8bbbLbdESVLQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_02,2022-04-25_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 malwarescore=0 bulkscore=0 mlxscore=0 impostorscore=0
 adultscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204260056
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/26/22 09:53, Janosch Frank wrote:
> On 4/25/22 18:17, Janis Schoetterl-Glausch wrote:
>> Some instructions are emulated by KVM. Test that KVM correctly emulates
>> storage key checking for two of those instructions (STORE CPU ADDRESS,
>> SET PREFIX).
>> Test success and error conditions, including coverage of storage and
>> fetch protection override.
>> Also add test for TEST PROTECTION, even if that instruction will not be
>> emulated by KVM under normal conditions.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
[...]

We need to:
a) Fence this in our CI environments
b) Fence this for the gitlab ci s390x kvm entry

Could you please add a patch that removes the skey test from 
.gitlab-ci.yml? It's at the very end of that file.

If the nit below is fixed:
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>


> Please add a comment that we're testing the fetch access of the operand
> since the prefix is only checked for addressing.
> 
>> +static void test_set_prefix(void)
>> +{
>> +	uint32_t *prefix_ptr = (uint32_t *)pagebuf;
>> +	uint32_t *no_override_prefix_ptr;
>> +	uint32_t old_prefix;
>> +	pgd_t *root;
>> +
>> +	report_prefix_push("SET PREFIX");
>> +	root = (pgd_t *)(stctg(1) & PAGE_MASK);
>> +	old_prefix = get_prefix();
>> +	memcpy(lowcore_tmp, 0, sizeof(lowcore_tmp));
>> +	assert(((uint64_t)&lowcore_tmp >> 31) == 0);
>> +	*prefix_ptr = (uint32_t)(uint64_t)&lowcore_tmp;
>> +
>> +	report_prefix_push("zero key");
>> +	set_prefix(old_prefix);
>> +	set_storage_key(prefix_ptr, 0x20, 0);
>> +	set_prefix(*prefix_ptr);
>> +	report(get_prefix() == *prefix_ptr, "set prefix");
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("matching key");
>> +	set_prefix(old_prefix);
>> +	set_storage_key(pagebuf, 0x10, 0);
>> +	set_prefix_key_1(prefix_ptr);
>> +	report(get_prefix() == *prefix_ptr, "set prefix");
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("mismatching key");
>> +
>> +	report_prefix_push("no fetch protection");
>> +	set_prefix(old_prefix);
>> +	set_storage_key(pagebuf, 0x20, 0);
>> +	set_prefix_key_1(prefix_ptr);
>> +	report(get_prefix() == *prefix_ptr, "set prefix");
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("fetch protection");
>> +	set_prefix(old_prefix);
>> +	set_storage_key(pagebuf, 0x28, 0);
>> +	expect_pgm_int();
>> +	set_prefix_key_1(prefix_ptr);
>> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>> +	report(get_prefix() == old_prefix, "did not set prefix");
>> +	report_prefix_pop();
>> +
>> +	register_pgm_cleanup_func(dat_fixup_pgm_int);
>> +
>> +	report_prefix_push("remapped page, fetch protection");
>> +	set_prefix(old_prefix);
>> +	set_storage_key(pagebuf, 0x28, 0);
>> +	expect_pgm_int();
>> +	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
>> +	set_prefix_key_1((uint32_t *)0);
>> +	install_page(root, 0, 0);
>> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>> +	report(get_prefix() == old_prefix, "did not set prefix");
>> +	report_prefix_pop();
>> +
>> +	ctl_set_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
>> +
>> +	report_prefix_push("fetch protection override applies");
>> +	set_prefix(old_prefix);
>> +	set_storage_key(pagebuf, 0x28, 0);
>> +	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
>> +	set_prefix_key_1((uint32_t *)0);
>> +	install_page(root, 0, 0);
>> +	report(get_prefix() == *prefix_ptr, "set prefix");
>> +	report_prefix_pop();
>> +
>> +	no_override_prefix_ptr = (uint32_t *)(pagebuf + 2048);
>> +	WRITE_ONCE(*no_override_prefix_ptr, (uint32_t)(uint64_t)&lowcore_tmp);
>> +	report_prefix_push("fetch protection override does not apply");
>> +	set_prefix(old_prefix);
>> +	set_storage_key(pagebuf, 0x28, 0);
>> +	expect_pgm_int();
>> +	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
>> +	set_prefix_key_1((uint32_t *)2048);
>> +	install_page(root, 0, 0);
>> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>> +	report(get_prefix() == old_prefix, "did not set prefix");
>> +	report_prefix_pop();
>> +
>> +	ctl_clear_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
>> +	register_pgm_cleanup_func(NULL);
>> +	report_prefix_pop();
>> +	set_storage_key(pagebuf, 0x00, 0);
>> +	report_prefix_pop();
>> +}
>> +
>>    int main(void)
>>    {
>>    	report_prefix_push("skey");
>> @@ -130,6 +352,11 @@ int main(void)
>>    	test_set();
>>    	test_set_mb();
>>    	test_chg();
>> +	test_test_protection();
>> +	test_store_cpu_address();
>> +
>> +	setup_vm();
>> +	test_set_prefix();
>>    done:
>>    	report_prefix_pop();
>>    	return report_summary();
>>
>> base-commit: 6a7a83ed106211fc0ee530a3a05f171f6a4c4e66
> 

