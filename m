Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A42D69DCCC
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 10:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbjBUJWg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 04:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233921AbjBUJWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 04:22:32 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A51624483;
        Tue, 21 Feb 2023 01:22:21 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31L70iB2030981;
        Tue, 21 Feb 2023 09:22:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=j8hhK+Tzh5WHowonwpgoor6na4KXD/gFUWretwzQFZI=;
 b=r/Jo//mgLF60doYxA9p1s7JmZyEUcAJh53/NqhCHn/NKBUt1pjAE9iWA+6XFlaVkwCBU
 hDy4vYbCFYaunyUSAM8CvQd+mE6X+TD/a0Dkc5xaouOEp/3fYXo23wgTWprlGcfbpfaL
 PqibVGFFXBiHYTaxPXYTolBTIC62bZJ3BpMFRp0/E4COds6OAMPBSH6nodf/a8xNqFca
 7/phiII9YEhmtR6X72NXqkFrgoXyjf+8HjIBtAJeldI2uFVzw7Wse42d0VgFQO8Em/it
 52wvExjeNruNxxqa2jtgMPszU31YSKF/ympSAXP4SgfWl9c7KwTnOhqRe/M62/bE5Vyr 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nvs6pk09f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 09:22:20 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31L7oieG037391;
        Tue, 21 Feb 2023 09:22:20 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nvs6pk08m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 09:22:20 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31L8U2gK007331;
        Tue, 21 Feb 2023 09:22:17 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3ntpa6bsu7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 09:22:17 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31L9ME5R51249638
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 09:22:14 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63FEE2004B;
        Tue, 21 Feb 2023 09:22:14 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF79E20043;
        Tue, 21 Feb 2023 09:22:13 +0000 (GMT)
Received: from [9.179.7.22] (unknown [9.179.7.22])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 21 Feb 2023 09:22:13 +0000 (GMT)
Message-ID: <95184ea5-7451-934d-8988-54f0eeec99f1@linux.ibm.com>
Date:   Tue, 21 Feb 2023 10:22:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
References: <20230201084833.39846-1-frankja@linux.ibm.com>
 <20230201084833.39846-3-frankja@linux.ibm.com>
 <20230215180625.53b260a9@p-imbrenda>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 2/3] s390x: pv: Test sie entry intercepts
 and validities
In-Reply-To: <20230215180625.53b260a9@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zaDYAJDoWh2_AY0QYPE4nSrdzmrDWct9
X-Proofpoint-ORIG-GUID: 8lI0VD59_TEtv-ttw5c1_q8yJDp-iQpm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_04,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 clxscore=1015 mlxscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302210078
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/15/23 18:06, Claudio Imbrenda wrote:
> On Wed,  1 Feb 2023 08:48:32 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> The lowcore is an important part of any s390 cpu so we need to make
>> sure it's always available when we virtualize one. For non-PV guests
>> that would mean ensuring that the lowcore page is read and writable by
>> the guest.
>>
>> For PV guests we additionally need to make sure that the page is owned
>> by the guest as it is only allowed to access them if that's the
>> case. The code 112 SIE intercept tells us if the lowcore pages aren't
>> secure anymore.
>>
>> Let's check if that intercept is reported by SIE if we export the
>> lowcore pages. Additionally check if that's also the case if the guest
>> shares the lowcore which will make it readable to the host but
>> ownership of the page should not change.
>>
>> Also we check for validities in these conditions:
>>       * Manipulated cpu timer
>>       * Double SIE for same vcpu
>>       * Re-use of VCPU handle from another secure configuration
>>       * ASCE re-use
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> 
> looks good, see some questions below
> 
>> ---
[...]
>> +	extern const char SNIPPET_NAME_START(asm, snippet_pv_icpt_vir_timing)[];
>> +	extern const char SNIPPET_NAME_END(asm, snippet_pv_icpt_vir_timing)[];
>> +	extern const char SNIPPET_HDR_START(asm, snippet_pv_icpt_vir_timing)[];
>> +	extern const char SNIPPET_HDR_END(asm, snippet_pv_icpt_vir_timing)[];
>> +	int size_hdr = SNIPPET_HDR_LEN(asm, snippet_pv_icpt_vir_timing);
>> +	int size_gbin = SNIPPET_LEN(asm, snippet_pv_icpt_vir_timing);
>> +
>> +	report_prefix_push("manipulated cpu time");
>> +	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_icpt_vir_timing),
>> +			SNIPPET_HDR_START(asm, snippet_pv_icpt_vir_timing),
>> +			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
>> +
>> +	sie(&vm);
>> +	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
>> +	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x44,
>> +	       "stp done");
>> +	vm.sblk->cputm -= 0x280de80000 / 2;
> 
> so you are subtracting half of the value?
> 
> why not vm.sblk->cputm /= 2?
> or just set a fixed (very low) magic value?
> 
> what should happen if the cpu timer is higher instead of lower?

I'll need to do some digging to find out why I used this specific 
procedure. It's been a very long time since I wrote those tests.

[...]

>> +	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_loop),
>> +			SNIPPET_HDR_START(asm, snippet_loop),
>> +			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
>> +
>> +	sie_expect_validity(&vm);
>> +	smp_cpu_setup(1, psw);
>> +	smp_cpu_setup(2, psw);
>> +	while (vm.sblk->icptcode != ICPT_VALIDITY) { mb(); }
> 
> maybe put the mb(); in a separate line

Can do

> 
>> +	/* Yes I know this is not reliable as one cpu might overwrite it */
> 
> the wording in this comment could be improved

How about:
This might not be fully reliable but it should be sufficient for our 
current goals.

[...]

>> +	report_prefix_push("shared");
>> +	sie(&vm);
>> +	/* Guest indicates that it has shared the new lowcore */
>> +	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
>> +	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x44,
>> +	       "intercept values");
>> +
>> +	uv_export(vm.sblk->mso + lc_off);
>> +	uv_export(vm.sblk->mso + lc_off + PAGE_SIZE);
> 
> why are you not testing both pages individually here, like you did
> above?

Hmm, I don't think there was a reason behind this. I'll add it.

[...]
